{{- /* yet-cert.tpl */ -}}
{{ with secret "pki_int/issue/yet-dot-org" "common_name=nginx"     "ttl=2m" }}
{{ .Data.certificate }}
{{ .Data.issuing_ca }}{{ end }}