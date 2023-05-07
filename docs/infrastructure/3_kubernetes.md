# 2. Kubernetes

```
talosctl gen config --with-secrets infra/talos/secrets.yaml --config-patch @infra/talos/cloud-provider.yaml --config-patch-control-plane @infra/talos/cni.yaml --config-patch-worker @infra/talos/sysctl.yaml --with-examples=false --with-docs=false -o infra/talos liveview-template https://cluster.liveview-template.app:6443
```
