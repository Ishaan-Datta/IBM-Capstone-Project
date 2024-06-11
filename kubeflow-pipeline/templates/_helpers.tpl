{{- define "kubeflow-pipeline.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride -}}
{{- else -}}
{{- .Release.Name | replace "-" "" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}