# Architecture Overview — Terraform AWS 3-Tier Enterprise

## Purpose

This document defines the target architecture for the **Terraform AWS 3-Tier Enterprise** platform.

Its purpose is to describe how the repository should evolve toward an enterprise-ready delivery model based on:

- **Terraform** for infrastructure provisioning
- **Amazon EKS** as the Kubernetes runtime platform on AWS
- **Jenkins** for CI and pipeline orchestration
- **ArgoCD** for GitOps-based application delivery

This document complements:

- `README.md`
- `docs/standards.md`
- `CONTRIBUTING.md`
- `ROADMAP.md`

---

## Architecture Goals

The target architecture is designed to achieve the following goals:

- provision AWS infrastructure in a repeatable and destroyable way
- support application delivery through CI/CD automation
- separate infrastructure provisioning from application deployment concerns
- adopt a GitOps model for Kubernetes application delivery
- remain compatible with low-cost lab validation while evolving toward enterprise practices
- support future controlled creation and destruction of the platform through unified Terraform-oriented scripts

---

## High-Level Architecture

The target platform is composed of three main layers:

### 1. Infrastructure Provisioning Layer
Managed by **Terraform**.

This layer is responsible for creating the AWS platform resources required by the environment, including:

- VPC and subnet topology
- routing and internet/NAT access
- security groups
- public and internal load balancers
- relational database services
- Kubernetes platform resources on AWS
- IAM and supporting infrastructure primitives

### 2. Continuous Integration and Delivery Orchestration Layer
Managed by **Jenkins**.

This layer is responsible for:

- building the Spring Boot application
- running tests and quality checks
- building and publishing container images
- updating the desired Kubernetes deployment state in Git
- optionally validating Terraform changes in CI

### 3. GitOps Continuous Delivery Layer
Managed by **ArgoCD**.

This layer is responsible for:

- monitoring a Git repository containing Kubernetes manifests or Helm values
- detecting changes in the desired application state
- synchronizing the Kubernetes cluster with the desired state in Git
- supporting drift detection and self-healing behavior where enabled

---

## Recommended Repository Model

The target operating model uses **three repositories**, each with a clear responsibility.

### Repository 1 — Application Repository
This repository contains the Spring Boot application and everything required to build and package it.

Typical contents:

- Spring Boot source code
- `Dockerfile`
- `Jenkinsfile`
- unit and integration tests
- build configuration (`pom.xml` or `build.gradle`)

**Responsibility:** source of truth for application code.

### Repository 2 — Infrastructure Repository
This is the current repository.

Typical contents:

- Terraform infrastructure code
- bootstrap logic
- infrastructure modules
- environment-specific Terraform configuration
- documentation and standards
- helper scripts

**Responsibility:** source of truth for infrastructure provisioning.

### Repository 3 — GitOps Repository
This repository contains the desired Kubernetes deployment state tracked by ArgoCD.

Typical contents:

- Helm values
- Kubernetes manifests
- Kustomize overlays
- ArgoCD `Application` or `ApplicationSet` definitions
- environment-specific deployment configuration

**Responsibility:** source of truth for Kubernetes application deployment state.

---

## Technology Responsibilities

### Terraform Responsibilities
Terraform should manage:

- AWS networking and subnet layout
- security baselines
- load balancers and ingress-related infrastructure
- database services such as Amazon RDS PostgreSQL
- Amazon EKS cluster provisioning
- worker node groups on EC2
- IAM, roles, and platform prerequisites
- optional bootstrap installation of ArgoCD if that becomes part of the platform baseline

Terraform should not be the primary mechanism for day-2 application release changes.

### Jenkins Responsibilities
Jenkins should manage:

- application build and test lifecycle
- container image creation
- container image publishing to a registry
- automation of Git updates for the GitOps repository
- Terraform validation, formatting, and planning workflows where appropriate
- gated apply workflows for infrastructure when needed

Jenkins should **not** be the long-term source of truth for Kubernetes live deployment state.

### ArgoCD Responsibilities
ArgoCD should manage:

- GitOps synchronization of Kubernetes application resources
- continuous reconciliation of desired versus live state
- automated deployment when the GitOps repository changes
- drift detection and optional self-healing
- application-level delivery inside Kubernetes

ArgoCD should **not** be the primary infrastructure provisioning engine for AWS foundational resources.

---

## Kubernetes Platform Target

The recommended Kubernetes target platform is:

## **Amazon EKS with EC2 worker nodes**

This model is preferred over a fully self-managed Kubernetes installation on raw EC2 instances.

### Why EKS

The target benefits include:

- managed Kubernetes control plane
- tighter AWS integration
- cleaner operational model
- better compatibility with GitOps delivery using ArgoCD
- clearer infrastructure lifecycle for create/destroy operations
- easier path toward enterprise hardening

### Worker Node Strategy

The recommended node strategy is:

- EKS control plane managed by AWS
- EC2-based worker nodes via managed node groups where practical
- environment-specific scaling profiles
- possibility to evolve later toward more advanced node management if needed

---

## Application Delivery Flow

The target application delivery flow is as follows:

### Step 1 — Application change
A developer changes the Spring Boot application source code in the application repository.

### Step 2 — Jenkins pipeline execution
Jenkins detects the change and runs the CI pipeline:

- checkout source code
- build and test the application
- build the container image
- push the image to the target registry

### Step 3 — GitOps state update
Jenkins updates the GitOps repository with the new desired application version.

Typical examples:

- update container image tag in Helm values
- update Kustomize image reference
- commit and push the change to the tracked GitOps branch

### Step 4 — ArgoCD synchronization
ArgoCD detects the change in the GitOps repository and synchronizes the Kubernetes cluster.

### Step 5 — Application rollout
The application is rolled out in Kubernetes according to the deployment strategy defined in the GitOps repository.

---

## Infrastructure Delivery Flow

The target infrastructure workflow is separate from the application deployment workflow.

### Step 1 — Infrastructure change
A contributor updates Terraform code in the infrastructure repository.

### Step 2 — Validation
The change is validated locally and later through CI:

- `terraform fmt`
- `terraform validate`
- optional linting and security scanning
- `terraform plan`

### Step 3 — Controlled apply
For approved changes, Terraform apply is executed in a controlled way, either manually or through Jenkins.

### Step 4 — Platform availability
The infrastructure becomes available for application delivery and GitOps synchronization.

---

## Environment Model

The architecture should support at least the following environments:

- `lab`
- `dev`
- `prod`

### Lab
Used for:

- low-cost validation
- iterative Terraform apply/destroy testing
- architectural experimentation

This environment may use simplified cost-aware components such as **Amazon RDS for PostgreSQL** in place of more advanced production-oriented alternatives.

### Dev
Used for:

- integration validation
- CI/CD testing
- early platform behavior verification

### Prod
Used for:

- stable, approved platform deployment
- stronger governance
- more restrictive operational controls
- production-oriented resilience and protection settings

---

## GitOps Design Principles

The target GitOps model must follow these principles:

- Git is the source of truth for Kubernetes application state
- Jenkins updates Git, not the cluster directly
- ArgoCD pulls and reconciles the desired state from Git
- manual `kubectl apply` for managed applications should be avoided
- drift between Git and cluster should be visible and manageable

This keeps the deployment model auditable, declarative, and easier to reason about.

---

## Platform Provisioning Scope

The infrastructure repository should eventually provision, directly or indirectly, the components required to bring up the platform end-to-end.

### Core Platform Scope

Planned platform scope includes:

- networking foundation
- load balancer topology
- web and app compute layers where still relevant
- relational database tier
- Kubernetes platform layer on AWS
- core IAM and security prerequisites
- platform observability baseline where applicable

### Future Platform Scope

Potential future scope may include:

- ArgoCD installation bootstrap
- Kubernetes namespace baselines
- ingress controller configuration
- cluster add-ons
- external DNS or certificate management if required

---

## Create/Destroy Operating Model

A key design objective is to reach a point where the platform can be brought up and torn down through two clear entry points.

### Target Scripts

The long-term target is to provide:

- `scripts/create.sh`
- `scripts/destroy.sh`

### `create.sh` Target Responsibilities

This script should eventually orchestrate:

1. bootstrap prerequisites if needed
2. Terraform initialization
3. Terraform apply for the main platform
4. optional post-provision platform bootstrap steps
5. optional validation outputs for next-stage automation

### `destroy.sh` Target Responsibilities

This script should eventually orchestrate:

1. optional application or GitOps cleanup steps where required
2. platform destroy execution
3. optional bootstrap cleanup if intentionally supported

### Design Rule

These scripts should be wrappers around explicit, understandable Terraform workflows.
They must not become opaque shortcuts that hide infrastructure behavior.

---

## Security and Governance Direction

The target architecture should evolve toward stronger controls over time.

### Key areas

- IAM least privilege
- protected Terraform state
- secure secret handling
- environment isolation
- tagging consistency
- approval controls for sensitive environments
- auditable delivery through Git and CI/CD

This direction should be implemented progressively rather than all at once.

---

## Jenkins and ArgoCD Boundary

The boundary between Jenkins and ArgoCD must remain clear.

### Jenkins does

- build
- test
- package
- publish image
- update GitOps repository
- validate infrastructure changes

### ArgoCD does

- monitor GitOps repository
- compare desired versus live state
- synchronize Kubernetes resources
- maintain application deployment state in the cluster

### Anti-pattern to avoid

Do not use Jenkins as the long-term direct deployment mechanism for GitOps-managed applications.
If ArgoCD is the deployment controller, Jenkins should trigger deployment by changing Git, not by applying manifests directly to the cluster.

---

## Recommended Evolution Path

The recommended architecture evolution path is:

1. stabilize the Terraform repository
2. standardize naming, tagging, and contribution workflows
3. introduce local quality gates and CI validation
4. define and provision the Kubernetes target platform on AWS
5. introduce Jenkins for CI and infrastructure validation workflows
6. introduce the GitOps repository and ArgoCD deployment model
7. connect application CI to GitOps delivery
8. wrap final provisioning flows in `create` and `destroy` scripts

---

## Definition of Success

The target architecture can be considered successful when:

- infrastructure provisioning is repeatable and documented
- the Kubernetes platform can be created and destroyed in a controlled way
- application delivery is automated through Jenkins and GitOps
- ArgoCD manages Kubernetes application synchronization declaratively
- responsibilities between repositories are clear
- the platform supports both lab validation and enterprise evolution

---

## Final Note

This architecture is intentionally designed to be progressive.

The immediate goal is not to maximize complexity. The immediate goal is to build a platform that is:

- understandable
- repeatable
- automatable
- maintainable
- ready for controlled enterprise growth

Terraform, Jenkins, and ArgoCD should work together as complementary tools, each responsible for a specific layer of the overall delivery model.
