{{/* vim: set filetype=mustache: */}}
{{/*
Create the volumes
*/}}
{{- define "common.volumes" -}}
{{- if .Values.volumes.persistentVolumeClaim -}}
- name: {{ .Values.volumes.persistentVolumeClaim.name }}
  persistentVolumeClaim:
    claimName: {{ .Values.volumes.persistentVolumeClaim.name }}
{{- else if .Values.volumes.data -}}
- name: {{ .Values.volumes.data.persistentVolumeClaim.name }}
  persistentVolumeClaim:
    claimName: {{ .Values.volumes.data.persistentVolumeClaim.name }}
- name: {{ .Values.volumes.ingest.persistentVolumeClaim.name }}
  persistentVolumeClaim:
    claimName: {{ .Values.volumes.ingest.persistentVolumeClaim.name }}
{{- end }}
{{- if .Values.volumes.configMap }}
- name: {{ .Values.volumes.configMap.name }}
  configMap:
    name: {{ .Values.volumes.configMap.name }}
    {{- if .Values.volumes.configMap.key }}
    items:
      - key: {{ .Values.volumes.configMap.key }}
        path: {{ .Values.volumes.configMap.key }}
    {{- end }}
{{- end }}
{{- end -}}

{{/*
Create the volume mounts
*/}}
{{- define "common.volumeMounts" -}}
{{- if .Values.volumes.persistentVolumeClaim -}}
- name: {{ .Values.volumes.persistentVolumeClaim.name }}
  mountPath: {{ .Values.volumes.persistentVolumeClaim.mountPath }}
{{- else if .Values.volumes.data -}}
- name: {{ .Values.volumes.data.persistentVolumeClaim.name }}
  mountPath: {{ .Values.volumes.data.persistentVolumeClaim.mountPath }}
- name: {{ .Values.volumes.ingest.persistentVolumeClaim.name }}
  mountPath: {{ .Values.volumes.ingest.persistentVolumeClaim.mountPath }}
{{- end -}}
{{- if .Values.volumes.configMap }}
- name: {{ .Values.volumes.configMap.name }}
  mountPath: {{ .Values.volumes.configMap.mountPath }}
{{- if .Values.volumes.configMap.key }}
  subPath: {{ .Values.volumes.configMap.key }}
  readOnly: true
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create the init containers
*/}}
{{- define "common.init" -}}
- name: {{ .Chart.Name}}-init
  image: {{ .Values.init.repository }}
  imagePullPolicy: {{ .Values.init.pullPolicy }}
{{- with .Values.init.args }}
  args:
    {{- toYaml . | nindent 4 }}
{{- end }}
{{- end -}}

{{/*
Create the individual environment variables
*/}}
{{- define "common.env" -}}
{{- with .Values.env -}}
env:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
Create the configmap environment variables
*/}}
{{- define "common.envFrom" -}}
{{- if .Values.envFrom -}}
envFrom:
  - configMapRef:
      name: {{ .Values.envFrom.name }}
{{- end -}}
{{- end -}}

{{/*
Create the arguments
*/}}
{{- define "common.args" -}}
{{- with .Values.args -}}
args:
  {{- toYaml . | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
Create the deployment ports
*/}}
{{- define "common.deployment.ports" -}}
{{- if eq .Chart.Name "activemq" -}}
- name: {{ .Values.service.nio.name }}
  containerPort: {{ .Values.service.nio.port }}
  protocol: TCP
- name: {{ .Values.service.pcmd.name }}
  containerPort: {{ .Values.service.pcmd.port }}
  protocol: TCP
- name: {{ .Values.service.stomp.name }}
  containerPort: {{ .Values.service.stomp.port }}
  protocol: TCP
- name: {{ .Values.service.xmpp.name }}
  containerPort: {{ .Values.service.xmpp.port }}
  protocol: TCP
- name: {{ .Values.service.webgui.name }}
  containerPort: {{ .Values.service.webgui.port }}
  protocol: TCP
{{- else -}}
- name: {{ .Values.service.name }}
  containerPort: {{ .Values.service.port }}
  protocol: TCP
{{- end -}}
{{- end -}}

{{/*
Create the liveness probe
*/}}
{{- define "common.livenessProbe" -}}
{{- if eq .Values.probes.liveness.type "httpGet" -}}
httpGet:
  path: {{ .Values.probes.liveness.path }}
{{- if .Values.service }}
  port: {{ .Values.service.port }}
{{- else }}
  port: 8080
{{- end }}
{{- else if eq .Values.probes.liveness.type "tcpSocket" -}}
tcpSocket:
{{- if eq .Chart.Name "activemq" }}
  port: {{ .Values.service.pcmd.port }}
{{- else }}
  port: {{ .Values.service.port }}
{{- end }}
{{- else if eq .Values.probes.liveness.type "exec" -}}
exec:
  command: {{ .Values.probes.liveness.command }}
{{- end }}
{{- if .Values.probes.liveness.initialDelaySeconds }}
initialDelaySeconds: {{ .Values.probes.liveness.initialDelaySeconds }}
{{- end }}
{{- if .Values.probes.liveness.periodSeconds }}
periodSeconds: {{ .Values.probes.liveness.periodSeconds }}
{{- end }}
{{- if .Values.probes.liveness.failureThreshold }}
failureThreshold: {{ .Values.probes.liveness.failureThreshold }}
{{- end }}
{{- if .Values.probes.liveness.timeoutSeconds }}
timeoutSeconds: {{ .Values.probes.liveness.timeoutSeconds }}
{{- end }}
{{- end -}}

{{/*
Create the readiness probe
*/}}
{{- define "common.readinessProbe" -}}
{{- if eq .Values.probes.readiness.type "httpGet" -}}
httpGet:
  path: {{ .Values.probes.readiness.path }}
{{- if .Values.service }}
  port: {{ .Values.service.port }}
{{- else }}
  port: 8080
{{- end }}
{{- else if eq .Values.probes.readiness.type "tcpSocket" -}}
tcpSocket:
{{- if eq .Chart.Name "activemq" }}
  port: {{ .Values.service.pcmd.port }}
{{- else }}
  port: {{ .Values.service.port }}
{{- end }}
{{- else if eq .Values.probes.readiness.type "exec" -}}
exec:
  command: {{ .Values.probes.readiness.command }}
{{- end }}
{{- if .Values.probes.readiness.initialDelaySeconds }}
initialDelaySeconds: {{ .Values.probes.readiness.initialDelaySeconds }}
{{- end }}
{{- if .Values.probes.readiness.periodSeconds }}
periodSeconds: {{ .Values.probes.readiness.periodSeconds }}
{{- end }}
{{- if .Values.probes.readiness.failureThreshold }}
failureThreshold: {{ .Values.probes.readiness.failureThreshold }}
{{- end }}
{{- if .Values.probes.readiness.timeoutSeconds }}
timeoutSeconds: {{ .Values.probes.readiness.timeoutSeconds }}
{{- end }}
{{- end -}}
