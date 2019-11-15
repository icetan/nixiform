# Nixiform examples

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

Initialize Nixiform using the Terraform state:

```sh
nixiform init
```

Take a look at the inputs given to Nixiform from Terraform:

```sh
nixiform input
```

Build and push the configuration in `nixiform.nix` to the instances created by
Terraform:

```sh
nixiform push
```

Check result by browsing to web server:

```sh
xdg-open http://$(nixiform input nodes.server_01.ip)
```
