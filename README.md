# Terraform AWS 3-Tier Enterprise

This repository contains an enterprise-oriented Terraform implementation for AWS infrastructure provisioning, with a specific focus on progressive evolution from a low-cost lab setup to a more production-aligned platform foundation.

The repository currently supports a cost-aware **EKS lab profile** and is designed to evolve toward a full **EKS + Argo CD + GitOps** operating model.

---

## Goals

The main goals of this repository are:

- modular infrastructure design
- environment-based execution
- reusable Terraform modules
- repeatable create/destroy workflows
- cost-aware validation for lab environments
- progressive evolution toward enterprise platform engineering
- future CI/CD and GitOps integration with Argo CD

---

## Current Scope

At the current stage, the repository supports:

- Terraform-based AWS infrastructure provisioning
- Amazon EKS cluster provisioning for lab validation
- environment-specific backend configuration
- scripted create/destroy workflows
- optional Argo CD bootstrap for Kubernetes GitOps scenarios

This repository is intentionally structured to allow different operating profiles depending on budget, environment constraints, and validation goals.

---

## Repository Structure

```text
.
├── bootstrap/
│   ├── argocd/
│   ├── envs/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── versions.tf
├── docs/
│   ├── architecture/
│   ├── decisions/
│   └── runbooks/
├── infra/
│   ├── envs/
│   │   ├── dev/
│   │   ├── eks-lab/
│   │   ├── lab/
│   │   └── prod/
│   ├── global/
│   ├── modules/
│   │   ├── eks/
│   │   ├── iam-access/
│   │   └── ...
│   ├── data.tf
│   ├── locals.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── variables.tf
│   └── versions.tf
├── scripts/
│   ├── create/
│   ├── destroy/
│   ├── lib/
│   ├── apply.sh
│   ├── destroy.sh
│   ├── fmt.sh
│   ├── plan.sh
│   └── validate.sh
├── README.md
└── LICENSE

