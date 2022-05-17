# it's for pod resource configuration, that value can be overrited at specific environment config
{{- define "podResources" -}}
{{- if .Values.podResources -}}
{{- toYaml .Values.podResources }}
{{- end -}}
{{- end -}}


{{- define "extraPodConfig" -}}
{{- if .Values.extraPodConfig -}}
{{- toYaml .Values.extraPodConfig }}
{{- end -}}
{{- end -}}