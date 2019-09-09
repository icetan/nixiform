# TerraNix examples

Start by entering `nix-shell`, this will setup your environment and create SSH
keys if necessary:

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

Initialize TerraNix using Terraform state and push config to instances:

```sh
terranix init
```

```sh
terranix push
```

Check result by browsing to web server:

```sh
xdg-open http://$(terranix input nodes.server_01.ip)
```
