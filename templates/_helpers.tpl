{{- define "n8n.secureCookie" -}}
{{- if eq .Values.n8n.publicUrl.protocol "https" -}}true{{- else -}}false{{- end -}}
{{- end -}}

{{- define "n8n.ingress.tlsHosts" -}}
{{- $hosts := list .Values.n8n.publicUrl.host .Values.ingress.grafanaHost -}}
{{- with .Values.ingress.tls.extraHosts -}}
{{- $hosts = concat $hosts . -}}
{{- end -}}
{{- toYaml $hosts -}}
{{- end -}}
