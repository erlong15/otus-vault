# Kubernetes secrets. Hashicorp Vault.

{% include "slides/OTUS_Platform/Common/recording-reminder.md.nj" %}

---

## План
* Работа с секретами в kubernetes
* Вспомнить как работает SSL
* Хранение секретов в vault
* Использование vault в k8s


Notes:

* Хранение секретов в k8s
* Взаимодействие с хранилищем секретов
* Шифрование хранения секретов

* Что такое vault и для чего он нужен
* Инициализация
* Unseal
* Авторизация
* Заводим пользователей
* Заводим секреты
* Настраиваем политики
* Базовые команды

* Vault в k8s
* Хранилище в консул
* helm от hashicorp
* настройка авторизации по тлс
* авто unseal
* использование 
* преобразование в enviroment variables
* прямой коннект из приложения
* генерация сертификатов

---



## Хранение секретов в k8s

- Создание секрета
```
kubectl create secret generic dev-db-secret --from-literal=username=devuser \
     --from-literal=password='S!B\*d$zDsb'
```
* Создание секрета из файла
```bash
kubectl create secret generic db-user-pass --from-file=./username.txt --from-file=./password.txt
```
- Создание секрета из yaml'а
   - для записи в yaml используем base64
- Хранение сертификатов
```bash
kubectl create secret tls vault-certs --cert=vault.crt --key=vault_gke.key
```


Notes:

* Рассказываем и показываем как мы можем создать секреты
---

## Использование секретов в k8s

* Монтирование секрета через volumeMounts в файл
* Мэппинг в переменные окружения пода

```bash
          env:
          - name: WORDPRESS_DB_PASSWORD
            valueFrom:
              secretKeyRef:
                name: cloudsql-db-credentials
                key: password
```

---
## Volume Mount  

```
     containers:
          ....
          volumeMounts:
            - name: cloudsql-instance-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
      volumes:
        - name: cloudsql-instance-credentials
          secret:
            secretName: cloudsql-instance-credentials
```

Notes:

* Рассказываем как мы можем использовать секреты
---

## Шифрование хранилища секретов

* По умолчанию секреты сохраняются в etcd в нешифрованном виде
* Но есть возможность зашифровать с использованием одного из провайдеров
    * aescbc
    * secretbox
    * aesgcm
    * kms

Notes:

* Рассказываем как мы можем использовать секреты

---

# Остались вопросы про секреты?

---
# Поговорим про SSL

---
## Что здесь не так?

![vault-logo](/assets/OTUS_Platform/Module-04/04-Vault/bad-diagram.jpg)

---


## Ассиметричное/симметричное шифрование

- Симметричный алгоритм шифрования — алгоритм, 
при котором для шифрования и дешифрования используется один и тот же ключ.

- В ассиметричном шифровании используется 2 ключа — открытый и закрытый(тайный). 
Открытый ключ для шифрования, закрытый — для дешифрования.

---

## Ассиметричное шифрование

![vault-logo](/assets/OTUS_Platform/Module-04/04-Vault/asymmetric-encryption.jpg)

---

## TLS Handshake

![vault-logo](/assets/OTUS_Platform/Module-04/04-Vault/tls-handshake.png)

Notes:
- Так как TLS работает над TCP, для начала между клиентом и сервером устанавливается TCP-соединение.
- После установки TCP, клиент посылает на сервер спецификацию в виде обычного текста (а именно версию протокола, которую он хочет использовать, поддерживаемые методы шифрования, etc).
- Сервер утверждает версию используемого протокола, выбирает способ шифрования из предоставленного списка, прикрепляет свой сертификат и отправляет ответ клиенту (при желании сервер может так же запросить клиентский сертификат).
- Версия протокола и способ шифрования на данном моменте считаются утверждёнными, клиент проверяет присланный сертификат и инициирует либо RSA, либо обмен ключами по Диффи-Хеллману, в зависимости от установленных параметров.
- Сервер обрабатывает присланное клиентом сообщение, сверяет MAC, и отправляет клиенту заключительное (‘Finished’) сообщение в зашифрованном виде.
- Клиент расшифровывает полученное сообщение, сверяет MAC, и если всё хорошо, то соединение считается установленным и начинается обмен данными приложений.

---
## TLS Handshake

![vault-logo](/assets/OTUS_Platform/Module-04/04-Vault/handshake_diagram.png)

---

## Certificate's chain

![vault-logo](/assets/OTUS_Platform/Module-04/04-Vault/cert-chain.png)

---

##  SSL/TLS: терминология

- SSL - Secure Socket Layer
- TLS - Transport Layer Security (актуальная версия 1.3)
- PKI - Public Key Infrastructure
- CA - certificate authorities
- Intermediate certificate
- CRL - Certificate Revocation List

---

## Hashicorp vault

![vault-logo](/assets/OTUS_Platform/Module-04/04-Vault/vault.png)

---
## Особеннности

* REST, JSON
* Безопасно хранит и управляет ключами.
* хранилища: file, consul, etcd, mysql, mongodb ...
* кластеризуется (в том числе в k8s)
* удобная система политик
* наличие API для взаимодействия из приложений напрямую
* различные варианты аутентификации: userpass, tls, токены, внешние API ...

Notes:


---
## Проблемы и решения от Vault
Проблемы|	Возможности vault
-----------------|-----------------------------------------------|
Хранение секретов везде.	| Одно общее хранилище.
Хранение в открытом виде.	| Встроенное шифрование, включая транзитное
Сложности с динамическими секретами	|Встроенная возможность динамической генерации
Сложно выделять на время и отзывать	|Доступы к секретам могуть быть выданы и отозваны
Сложно отслеживать кто имел доступ  |Встроенный аудит на генерацию и использование секретов

---

## Demo - vault UI

- kubectl get svc vault-ui

---

## Deploy в kubernetes

- Рекомендуемый backend - consul
- (consul-helm)[https://github.com/hashicorp/consul-helm]
- (vault-helm)[https://github.com/hashicorp/vault-helm]

---

## На что обратить внимание при деплое

- gossip-encryption-key в consul
- HA
- HTTPS
- включить UI

---

## CSR
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
---
## Создаем и подписываем сертификаты для HTTPS

- create a vault key
    - `openssl genrsa -out vault_gke.key 4096`

- create a request
    - `openssl req -config vault_gke_csr.cnf -new -key vault_gke.key -nodes -out vault.csr`

---

## create k8s csr resource
`vi vault_csr.yml`

```bash
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: vaultcsr
spec:
  groups:
  - system:authenticated
  request: ${BASE64_CSR}
  usages:
  - digital signature
  - key encipherment
  - server auth
```

---
## apply to k8s

- sign with k8s
```bash
export BASE64_CSR=$(cat ./vault.csr | base64 | tr -d '\n')
cat vault_csr.yml | envsubst | kubectl apply -f -
kubectl get csr
kubectl certificate approve vaultcsr
```
-  get signed cert
```bash
kubectl get csr vaultcsr -o jsonpath='{.status.certificate}'  | base64 --decode > vault.crt
kubectl create secret tls vault-certs --cert=vault.crt --key=vault_gke.key
```

---

## Demo. Изучаем values.yml.

---

## Инициализация и открытие хранилища

* После установки требуется инициализация хранилища
    * ``` vault operator init --key-shares=1 --key-threshold=1```
* После инициализации отдает ключи
    * root'а
    * unseal ключ
* По дефолту работает через HTTP
    * необходимо включить https в конфиге
    
    
Notes:

 --key-shares - на сколько ключей разбить мастер ключ
 --key-threshold - сколько частей нужно для сборки мастер ключа
 
---

## Смена токена root

```bash
## change root token
```bash
vault operator generate-root -init
vault operator generate-root

vault operator generate-root -decode=<encoded token> -otp=<OTP>
```

---

## Vault  аутентификация

- [Документация](https://www.vaultproject.io/docs/auth/userpass)
- Поддерживает несколько auth методов: 
    - userpass, token, tls, kubernetes
* По умолчанию каждый тип авторизации хранится по пути ```auth/<type>```
* Для использования метода его необходимо включить
```bash
vault auth enable userpass 
vault write auth/userpass/users/otus \
    password=otusPass \
    policies=otus 
vault list auth/userpass/users
vault read auth/userpass/users/otus
```

---

## Key-value secret engine
- [Документация](https://www.vaultproject.io/docs/secrets/kv/kv-v2)
```bash
vault secrets enable -path=internal kv-v2
vault kv put internal/database/config username="db-readonly-username" password="db-secret-password"
vault kv get internal/database/config

```

---
## Kubernetes auth

![vault-logo](/assets/OTUS_Platform/Module-04/04-Vault/vaul-k8s-auth.png)<!-- .element: class="image-center" -->

---
##  Kubernetes   auth
```bash
# включили аутентификацию через k8s
vault auth enable kubernetes

# прописали куда обращаться за api
vault write auth/kubernetes/config \
token_reviewer_jwt="$SA_JWT_TOKEN" \
kubernetes_host="$K8S_HOST" \
kubernetes_ca_cert="$SA_CA_CRT"
    
# создаем роль с привязкой к сервис аккоунту
vault write auth/kubernetes/role/demo \
    bound_service_account_names=vault-auth \
    bound_service_account_namespaces=default \
    policies=default \
    ttl=1h

```
---
## Kubernetes Service Account
```yaml
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

## Vault secrets engines

* Компоненты для хранения, генерации и шифрования секретов
    * проще воспринимать как функцию для реализации этих методов
* Может хранить локально, может обращаться на внешний  API
* Обращение к компоненту происходит через  ```path```
* Жизненный цикл secret engines
     * enable/disable
     * move
     * tune
* Помощь по  конкретному энжину ```vault path-help```


---
## Динамические секреты
* Создаются по требованию
* ограниченный доступ согласно роли
* могут быть ограничены сроком жизни
* могут быть отозваны
* доступ к секрету логгируется (включен аудит)

---
## Динамические секреты

![vault-dyn](/assets/OTUS_Platform/Module-04/04-Vault/dynamic-secret.jpg)

---

## Vault leases

* Метаинформация о динамических секретах и  токенах
    * содержит ttl,  возможность обновления итд
* При чтении выдается LeaseId, через который можно
    * ```vault renew my-lease-id 3600```
    * ```vault revoke my-lease-id```

---

## Vault wrapping

* Доступ к секрету через временный токен
    * при чтении секрета создается временный токет
    * у токена ограничен TTL
    * передается токен
    * по токену читается секрет
---

## Vault agent

Клиентский демон со следующим функционалом

- Auto-auth
    -  автоматическая аутентификация и автообновление токена
- Caching 
    - кэширование токенов
- Templating
    - рендер шаблонов с автоподстановкой новых секретов и возможностями вызова команд
---

## Vault agent

![vault-dyn](/assets/OTUS_Platform/Module-04/04-Vault/vault-agent-k8s-4.png)

---

## Vault inject

![vault-dyn](/assets/OTUS_Platform/Module-04/04-Vault/vault-inject.png)


---
## Пример инжектора

- patch-inject-secrets.yml
```
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/role: "internal-app"
        vault.hashicorp.com/agent-inject-secret-database-config.txt: "internal/data/database/config"
```
---

## Инжектор с конфигмэпом

- patch-basic-annotation.yaml
```bash
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/agent-configmap: vault-injector-configmap
```
- `kubectl patch deployment wordpress --patch "$(cat patch-basic-annotations.yaml)"`


---

## Vault policies
* Задаются файлами правил
    * ```vault policy write my_policy my_policy.hcl```
    * my-policy.hcl
        ```
        path "secret/app/*" {
          capabilities = ["create", "read", "update", "delete", "list"]
        }
        path "secret/db/*" {
           policy = "read"
        }
        ```

---

##  Транзитное шифрование
```
vault secrets enable transit
vault write -f transit/keys/otus
vault write transit/encrypt/otus plaintext=$(base64 <<< "Hell, kitty")
vault write transit/decrypt/otus ciphertext=<cipher> | base64 -d
```

---

## Policy capabilities
* create - позволяет создавать секреты по заданному пути
* read - разрашает чтение
* update - разврешает обновление существующих секретов
* delete - разрешает удаление существующих секретов
* list - просмотр списка секретов
* sudo - позволяет доступ к root-protected секретам
* deny - запрещает доступ

Notes:

* create (POST/PUT) - Allows creating data at the given path. 
Very few parts of Vault distinguish between create and update, 
so most operations require both create and update capabilities.
 Parts of Vault that provide such a distinction are noted in documentation.
* read (GET) - Allows reading the data at the given path.
* update (POST/PUT) - Allows changing the data at the given path. 
In most parts of Vault, this implicitly includes the ability to create the initial value at the path.
* delete (DELETE) - Allows deleting the data at the given path.
* list (LIST) - Allows listing values at the given path. Note that the keys returned by a list operation are not filtered by policies. Do not encode sensitive information in key names. Not all backends support listing.

* sudo - Allows access to paths that are root-protected.
 Tokens are not permitted to interact with these paths 
 unless they are have the sudo capability
  (in addition to the other necessary capabilities for performing 
  an operation against that path, such as read or delete).
* Deny - Disallows access. 
This always takes precedence regardless of any other defined capabilities, 
including sudo.

---

## Vault audit

```bash
# file
vault audit enable file file_path=/var/log/vault_audit.log
# stdout
vault audit enable file file_path=stdout
# syslog
vault audit enable syslog tag="vault" facility="AUTH"
# tcp/udp/unix socket
vault audit enable syslog tag="vault" facility="AUTH" format="json"

```

---

## Kubevault

* https://kubevault.com
* автоматическая инициализация и unsealing
* управления политиками vault
* AWS/Azure/GCP/Database secrets engines
* мониторинг через Prometheus
* реализация через operator

---
{% include "slides/OTUS_Platform/Common/thanks.md.nj" %}
