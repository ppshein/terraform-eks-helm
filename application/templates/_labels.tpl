# it's for label defination along pods and services

{{- define "labels" -}}
app: {{ .Release.Name }}
name: {{ .Release.Name }}
tier: {{ .Release.Name }}
app.kubernetes.io/managed-by: Helm
{{- end -}}
