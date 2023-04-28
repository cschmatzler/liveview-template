# Explanation here

# Setup

## Prerequisites

- Install `talosctl` - `curl -sL https://talos.dev/install | sh`
- Domain ?

## Steps

- Generate Talos secrets - `talosctl gen secrets -o infra/secrets.yaml`
- Generate Talos configuration - `talosctl gen config --with-secrets infra/talos/secrets.yaml --config-patch-control-plane @infra/talos/cni.yaml --with-examples=false --with-docs=false -o infra/talos liveview-template https://cluster.liveview-template.app:6443`
- Init terraform - `terraform -chdir=infra init`
- Build Talos image - `packer build -var talos_version=1.4.0 infra`
- Add image ID returned to .env
- Reload .env with `rtx trust`
- Run terraform - `terraform -chdir=infra apply`
- talosctl config
```
talosctl --talosconfig infra/talosconfig config endpoint <ip>
talosctl --talosconfig infra/talosconfig config node <ip>
```
- bootstrap - `talosctl --talosconfig infra/talosconfig bootstrap`
- retrieve kubeconfig - `talosctl --talosconfig infra/talosconfig kubeconfig infra/kubeconfig`
- generate secrets key - `age-keygen -o infra/secrets.agekey`
- generate hcloud secret - `scripts/gen-secret.sh infra/secrets/hcloud.yaml`
- bootstrap flux
```

```
- add secrets key to kubernetes
```
cat infra/secrets.agekey |
kubectl create secret generic sops-age \
--namespace flux-system \
--from-file secrets.agekey=/dev/stdin \
--kubeconfig infra/kubeconfig
```
