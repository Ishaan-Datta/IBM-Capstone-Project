# IBM-Capstone-Project

ML Pipeline Web Application

This project demonstrates a full end-to-end machine learning pipeline hosted on AWS, utilizing a variety of AWS services, Kubernetes, and Kubeflow. The system supports distributed training, hyperparameter tuning, model deployment, metadata management, automation, version control, and portability.
Table of Contents

    System Architecture
    Project Structure
    Prerequisites
    Setup and Deployment
    Usage
    Architecture Decision Records
    PlantUML Diagram

System Architecture

The system architecture involves several AWS services and Kubernetes components working together:

    Amazon S3: Stores uploaded CSV files and static website files.
    Amazon EKS: Manages Kubernetes clusters for running Kubeflow pipelines.
    Amazon EC2: Provides compute resources for training large models or running custom ML workflows.
    Amazon VPC: Isolates resources and controls network settings.
    Amazon Route 53: Manages DNS routing for internal services and domain registration.
    Kubeflow: Manages ML pipelines for distributed training, hyperparameter tuning, model deployment, and metadata management.

The website allows users to submit text or CSV files as input, which are processed by a backend API written in Golang. The processed data is then used in the ML pipeline. The pipeline is defined using Kubeflow's Python SDK and executed on an Amazon EKS cluster. The pipeline consists of several steps, including data preprocessing, model training, hyperparameter tuning, and model deployment. The pipeline artifacts are stored in Amazon S3, and the metadata is stored in Kubeflow's metadata store.

Prerequisites

    AWS account with appropriate permissions
    Terraform installed
    Helm installed
    Docker installed
    kubectl installed
    Node.js and npm installed

Usage

    Access the React application via the domain specified in Route 53.
    Upload text or CSV files through the web interface.
    The backend API processes the input and triggers the ML pipeline.
    View the results, including any generated images and text data.

Architecture Decision Records
ADR 001: Use of Amazon EKS for Kubernetes Management

Context: Managing Kubernetes clusters manually is complex and time-consuming.

Decision: Use Amazon EKS to manage Kubernetes clusters, leveraging its managed service capabilities to simplify operations.

Status: Accepted

Consequences:

    Reduced operational overhead
    Integration with other AWS services
    Increased cost compared to self-managed Kubernetes

ADR 002: Use of Terraform for Infrastructure Provisioning

Context: Consistent and repeatable infrastructure provisioning is crucial for reliability and scalability.

Decision: Use Terraform for provisioning all AWS infrastructure.

Status: Accepted

Consequences:

    Improved infrastructure consistency
    Enhanced version control for infrastructure
    Learning curve for new team members

ADR 003: Use of Helm for Kubernetes Resource Management

Context: Managing Kubernetes resources requires a templating mechanism to handle complex deployments.

Decision: Use Helm to manage Kubernetes resources, including deployments, services, and ingress.

Status: Accepted

Consequences:

    Simplified Kubernetes resource management
    Easier updates and rollbacks
    Dependency on Helm ecosystem