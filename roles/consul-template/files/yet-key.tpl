{{- /* yet-key.tpl */ -}}
{{ with secret "pki_int/issue/yet-dot-org" "common_name=nginx" "ttl=2m"}}
{{ .Data.private_key }}{{ end }}