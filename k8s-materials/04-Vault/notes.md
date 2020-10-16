## Взаимодействие приложений с Vault

- Аутентификация и запрос токена
- Управление жизненым циклом токена
- получение секретов из  Vault
- Управление динамическими секретами

---

## UNSEAL key
RQ3V288g5+hKi0NJb6gJFlKcmtMptuqrBYz0A/PNQLs=

- root
    - s.AeMEmOeMFtAeHOmn78za6DYM
---
## UNSEAL
kubectl get svc vault
kubectl get sts vault

kubectl exec -it  vault-2 -- vault operator unseal 'RQ3V288g5+hKi0NJb6gJFlKcmtMptuqrBYz0A/PNQLs='
kubectl exec -it  vault-1 -- vault status

---
## change root token
```bash
vault operator generate-root -init

A One-Time-Password has been generated for you and is shown in the OTP field.
You will need this value to decode the resulting root token, so keep it safe.
Nonce         d7cf2291-61b1-eb7e-266f-72ebee51c3d6
Started       true
Progress      0/1
Complete      false
OTP           c4iakqbCtz5m95A8MYnL5qP4MJ
OTP Length    26

$ vault operator generate-root

Operation nonce: d7cf2291-61b1-eb7e-266f-72ebee51c3d6
Unseal Key (will be hidden):
Nonce            d7cf2291-61b1-eb7e-266f-72ebee51c3d6
Started          true
Progress         1/1
Complete         true
Encoded Token    EBpYBTJFBQA9D29VagZ1fAxrPj1kAjMHIiA

$ vault operator generate-root -decode=EBpYBTJFBQA9D29VagZ1fAxrPj1kAjMHIiA -otp=c4iakqbCtz5m95A8MYnL5qP4MJ
s.1dY4gCIuZ8S34DA2PqQsc3oj
```

---

## set up a local client

export VAULT_CACERT=/Users/lucky/otus/kubernetes-engine-samples/wordpress-persistent-disks/kuber.ca
export VAULT_ADDR=https://vault:8200

---

## kubernetes auth engine

- vault-auth-service-account.yml

```
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: role-tokenreview-binding
  namespace: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
  - kind: ServiceAccount
    name: vault-auth
    namespace: default
```

---
vault policy list
vault policy read otus-policy

vault list auth/kubernetes/role
vault read auth/kubernetes/role/otus
vault read auth/kubernetes/config

vault list database/config
vault read database/config/my-mysql-database
---


