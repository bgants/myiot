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
- port: {{ .Values.service.pcmd.port }}
  targetPort: {{ .Values.service.pcmd.port }}
  protocol: TCP
  name: {{ .Values.service.pcmd.name }}
- port: {{ .Values.service.stomp.port }}
  targetPort: {{ .Values.service.stomp.port }}
  protocol: TCP
  name: {{ .Values.service.stomp.name }}
- port: {{ .Values.service.xmpp.port }}
  targetPort: {{ .Values.service.xmpp.port }}
  protocol: TCP
  name: {{ .Values.service.xmpp.name }}
- port: {{ .Values.service.webgui.port }}
  targetPort: {{ .Values.service.webgui.port }}
  protocol: TCP
  name: {{ .Values.service.webgui.name }}
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
