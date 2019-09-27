# TerraNix

Provision infrastructure with Terraform and manage configuration with NixOS.

## Installation

```
nix-env -i -f https://github.com/icetan/terranix/tarball/master
```

## Motivation

Declarative style infrastructure provisioning is really nice! So is declarative
configuration management.

This makes Terraform and NixOS a nice match, being able to define the result you
want in code and realizing it with one command (more or less :P).

## Inspiration

I've been using NixOps for my deployments for some time.

But infrastructure provisioning is hard and needs a big community effort
to cover cloud provider API's. Therefore carving out the provisioning part
of NixOps replacing it with Terraform gives access to the rich provider
support of the Terraform community.

This leaves implementing a bridge between Terraform and managing NixOS
configurations.

This is mostly what TerraNix does. It takes the output from Terraform (or any
other source really) and installs NixOS on the nodes provisioned if needed and
then pushes each corresponding NixOS config defined in a `terranix.nix` file.

## Examples

First we need to declare our infrastructure on which we will push our
configuration to.

We do this using Terraform, although TerraNix despite it's name is agnostic to
who provisions the infrastructure. The only requirement is that TerraNix gets
information about how to connect to the nodes it will push to.

**main.tf**

```terraform
provider "hcloud" {
}
```

First off we need a SSH key pair for TerraNix to use when pushing it's config.

TerraNix does not manage SSH keys for you so you will need to generate and add
it to your SSH agent manually before pushing.

```terraform
locals {
  ssh_key = file("${path.module}/ssh_key.pub")
}

resource "hcloud_ssh_key" "default" {
  name       = "TerraNix SSH key"
  public_key = local.ssh_key
}
```

Provision two Hetzner Cloud nodes with Ubuntu, because most providers don't
support NixOS we select Ubuntu which can be replaced with NixOS automatically
by TerraNix on first config push.

```terraform
resource "hcloud_server" "ubuntu" {
  count = 2
  name = format("server_%02d", count.index + 1)
  server_type = "cx11"
  image = "ubuntu-16.04"
  ssh_keys = [hcloud_ssh_key.default.id]
}
```

In order for TerraNix to know how to connect to the nodes provisioned by
Terraform we have to give it some input.

By setting the output property `terranix` in the Terraform config, TerraNix
will be able pick up the relevant data.

The value of `terranix` can be a single node or a list of nodes with the keys
`name`, `ip`, `ssh_key`, `provider`.

- `name`: the node identifier to map against a NixOS config in `terranix.nix`
- `ip`: a node IP which can be connected to via SSH
- `ssh_key`: the public SSH key for which will be allowed access
- `provider` (optional): determines which configurator will be used to
  generate a NixOS hardware config

```terraform
output "terranix" {
  value = [for node in hcloud_server.ubuntu : {
    name = node.name
    ip = node.ipv4_address
    ssh_key = var.ssh_key
    provider = "hcloud"
  }]
}
```

**terranix.nix**

This is the file which maps which NixOS configuration will be pushed to which
provisioned node. Analogous to NixOps' network file.

```nix
let
  webpage = content: pkgs.runCommand "http-server-content" {} ''
    mkdir -p $out
    cat > $out/index.html <<EOF
    <pre>
    ${content}
    </pre>
    EOF
  '';
in input: {
```

Define a node, the attribute name corresponds to the value of
`terranix.*.name` in the terraform output.

The value is the nodes NixOS configuration, same as a NixOS module or what
you would have in your `configuration.nix`. Additional arguments passed is
`input` and `node`.

Where `node` is data about the specific node from the Terraform output, in
this case the value of `terranix.*` where `terranix.*.name` is equal to
`"server"`.

And `input` is the value of the entire `terranix` property from the
Terraform output, i.e. data about all the provisioned nodes in the network.

```nix
  "server_01" = { config, input, node, ... }: {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/" = {
          root = webpage "${node.ip}";
        };
      };
    };
  };

  "server_02" = { config, input, node, ... }: {
    networking.firewall.allowedTCPPorts = [ 80 443 ];
    services.nginx = {
      enable = true;
      virtualHosts.localhost = {
        locations."/" = {
          root = webpage "${node.ip}";
        };
      };
    };
  };
}
```

Now that we have declared our infrastructure and configuration we can start to
realize them.

We start by provisioning our Hetzner Cloud nodes:

```sh
terraform init
terraform apply
```

Then we will tell TerraNix to take any Terraform output from the current
directory and connect to each node to get information about the hardware which
we will need in order to build the NixOS config.

```sh
terranix init
```

Building the configs, this step is optional as it will be done automatically
before each `push` but it can be helpful to check that the configuration is
correct.

```sh
terranix build
```

Finally we push each nodes configuration and if the node doesn't have NixOS yet
it will be installed replacing whatever OS is currently on there. (**Note**:
only some Linux distributions are supported to push over, Ubuntu is the simplest
choice.)

**Warning**: Any previously installed OS will be wiped.

```sh
terranix push
```

More examples in the [examples](./examples) directory.
