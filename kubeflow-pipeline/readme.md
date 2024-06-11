# Kubeflow Pipeline Helm Chart

This Helm chart deploys an end-to-end Kubeflow pipeline on Kubernetes, enabling distributed training, hyperparameter tuning, model deployment, metadata management, automation, version control, and data preparation.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.0+
- AWS S3 buckets
- EKS cluster

## Installation

```sh
helm install kubeflow-pipeline ./kubeflow-pipeline