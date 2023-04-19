apiVersion: v1
kind: Secret
metadata:
  name: hcloud
  namespace: kube-system
stringData:
  token: {{ .Env.TOKEN }}
  network: {{ .Env.NETWORK }}
