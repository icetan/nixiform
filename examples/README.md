# TerraNix examples

Start by entering `nix-shell`, this will setup your environment and create SSH
keys if necessary:

```sh
nix-shell
```

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
```

Init Terraform plugins and apply plan:

```sh
terraform init
terraform apply -auto-approve
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
xdg-open http://$(jq -r '."nixos-1".ip' < terranix-state.json)
```
