# terraform

## Предварительные действия в yandex cloud

- создать каталог
- создать сервис аккоунт с ролью editor
- создать статический ключ для заданного сервис аккоунта
    - сохранить предложенные значения как переменные AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
- `TF_VAR_yc_token` можно получить используя документацию по [ссылке](https://cloud.yandex.ru/docs/iam/operations/iam-token/create).
- заполняем переменные в terraform.tfvars
    - значения берем из созданного каталога


## Список необходимых переменных окружения

Переменные можно поместить в файл `.env`, пример файла
```shell
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
export TF_VAR_yc_token=""
```

