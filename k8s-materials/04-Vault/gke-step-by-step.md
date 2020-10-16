# Kubernetes secrets. Hashicorp Vault. DEMO.

---
##  Заводим кластер и vpc

```bash
gcloud compute networks create otus-network     --subnet-mode=auto     --bgp-routing-mode=regional

gcloud compute addresses create otus-vpc-range \
    --global \
    --purpose=VPC_PEERING \
    --addresses=10.17.0.0 \
    --prefix-length=16 \
    --description='otus vpc network' \
    --network=otus-network

```
    
---

```bash
gcloud services vpc-peerings connect \
    --service=servicenetworking.googleapis.com \
    --ranges=otus-vpc-range \
    --network=otus-network \
    --project=disco-dispatch-266719    


gcloud container clusters create otus-cluster \
  --enable-ip-alias --num-nodes=3 \
  --subnetwork=otus-network \
  --cluster-ipv4-cidr=/16 \
  --services-ipv4-cidr=/22

```
---

## Заводим базу

```bash

gcloud beta sql instances create otus-wp   --zone=europe-west1-b \
--tier db-n1-standard-1 --no-assign-ip --network=otus-network

export INSTANCE_NAME=otus-wp
CLOUD_SQL_PASSWORD=$(openssl rand -base64 18)
gcloud sql users create wordpress --host=% --instance $INSTANCE_NAME \
    --password $CLOUD_SQL_PASSWORD

```  
    
---

## Заводим вордпресс
 
```bash
   
kubectl create secret generic cloudsql-db-credentials \
    --from-literal username=wordpress \
    --from-literal password=$CLOUD_SQL_PASSWORD
    
export INSTANCE_CONNECTION_NAME=$(gcloud sql instances describe $INSTANCE_NAME \
    --format='value(connectionName)')
  
cat $WORKING_DIR/wordpress_cloudsql.yaml.template | envsubst > \
    $WORKING_DIR/wordpress_cloudsql.yaml
    
kubectl apply -f $WORKING_DIR/wordpress-volumeclaim.yaml
kubectl create -f $WORKING_DIR/wordpress_cloudsql.yaml  
kubectl create -f $WORKING_DIR/wordpress-service.yaml  

```
---

# create gossip key

kubectl create secret generic consul-gossip-encryption-key  --from-literal=key=ConsOtus

# crate a vault key
`openssl genrsa -out vault_gke.key 4096`

# create a csr config
`vi vault_gke_csr.cnf`

```bash
[ req ]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn
req_extensions = v3_ext
[ dn ]
commonName = localhost
stateOrProvinceName = Moscow
countryName = RU
emailAddress = lucky@perflabs.org
organizationName = Perflabs
organizationalUnitName = Development
[ v3_ext ]
basicConstraints = CA:FALSE
keyUsage = keyEncipherment,dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[ alt_names ]
DNS.0 = localhost
DNS.1 = vault
```

## create a request
```bash
openssl req -config vault_gke_csr.cnf -new -key vault_gke.key -nodes -out vault.csr

# get signed cert
kubectl get csr vaultcsr -o jsonpath='{.status.certificate}'  | base64 --decode > vault.crt
kubectl create secret tls vault-certs --cert=vault.crt --key=vault_gke.key

```




---
## Vault database engine


vault write database/config/my-mysql-database     plugin_name=mysql-database-plugin     connection_url="{{username}}:{{password}}@tcp(10.17.1.3:3306)/"     allowed_roles="vault-role"     username="vault"     password="otusVault20_20"

vault read database/config/my-mysql-database 

vault write database/roles/vault-role \
    db_name=my-mysql-database \
    creation_statements="CREATE USER '{{name}}'@'%' IDENTIFIED BY '{{password}}';GRANT SELECT,INSERT,UPDATE,DELETE ON wordpress.* TO '{{name}}'@'%';" \
    default_ttl="2m" \
    max_ttl="10m"
    
vault read database/roles/vault-role

vault read database/creds/vault-role

---

## Vault kubernetes engine

-  создадим service-account
-  создадим политику
-  создадим роль

---

## Настройка vault-agent-injector

- обновим волт с инжектором
- настройим конфиг-мэп
- настроим аннотации для патча
- пропатчим аплликейшен
- проверим доставку паролей