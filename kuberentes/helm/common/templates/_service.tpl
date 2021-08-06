{{/* vim: set filetype=mustache: */}}
{{/*
Create the service ports
*/}}
{{- define "common.service.ports" -}}
{{- if eq .Chart.Name "activemq" -}}
- port: {{ .Values.service.nio.port }}
  targetPort: {{ .Values.service.nio.port }}
  protocol: TCP
  name: {{ .Values.service.nio.name }}
{{- else -}}
- port: {{ .Values.service.port }}
  targetPort: {{ .Values.service.port }}
  protocol: TCP
  name: {{ .Values.service.name }}
{{- if eq .Values.service.type "NodePort" }}
  nodePort: {{ .Values.service.nodePort }}
{{- end -}}
{{- end -}}
{{- end -}}
