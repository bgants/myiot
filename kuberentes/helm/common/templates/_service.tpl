{{/* vim: set filetype=mustache: */}}
{{/*
Create the service ports
*/}}
{{- define "common.service.ports" -}}
- port: {{ .Values.service.port }}
  targetPort: {{ .Values.service.port }}
  protocol: TCP
  name: {{ .Values.service.name }}
{{- range .Values.service.extraPorts }}
- port: {{ .port }}
  targetPort: {{ .port }}
  protocol: TCP
  name: {{ .name }}
{{- end -}}
{{- end -}}
