# TerraNix examples

In these examples we will use `nix-shell` to setup our local environment,
including: creation of an SSH key and acquiring any dependencies.

`cd` into the example directory you want to try and enter `nix-shell`. Specific
instructions for any particular example should be echoed to the terminal.

## Trivial example with libvirt

### Prerequisites

Install `libvirt` and start default `pool` and `net`:

```sh
virsh --connect "qemu:///system" pool-define-as default dir - - - - /var/lib/libvirt/images
virsh --connect "qemu:///system" pool-start default
virsh --connect "qemu:///system" net-start default
```

### Init

```sh
cd libvirt
nix-shell
```

Init Terraform plugins and apply plan:

```sh
terraform init
terraform apply
```

Initialize TerraNix using the Terraform state:

```sh
terranix init
```

Take a look at the inputs given to TerraNix from Terraform:

```sh
terranix input
```

Build and push the configuration in `terranix.nix` to the instances created by
Terraform:

```sh
terranix push
```

Check result by browsing to web server:

```sh
xdg-open http://$(terranix input nodes.server_01.ip)
```
