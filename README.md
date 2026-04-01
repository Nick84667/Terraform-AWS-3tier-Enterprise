# Terraform AWS 3-Tier Enterprise

This repository contains an enterprise-oriented Terraform implementation of an AWS 3-tier architecture, designed to evolve from low-cost lab validation into a more production-ready infrastructure foundation.

The project is organized to support modular infrastructure delivery, stack-based execution, environment-driven configuration, and future enterprise hardening practices such as CI/CD, governance, security controls, and operational standardization.

At the current stage, Stack B has been successfully validated through full apply/destroy testing. For lab cost optimization, the data layer uses Amazon RDS for PostgreSQL instead of Amazon Aurora PostgreSQL, while preserving the intended architectural direction.

---

## Purpose

The purpose of this repository is to provide a structured and extensible Infrastructure as Code foundation for deploying, validating, and progressively hardening an AWS 3-tier architecture with Terraform.

The main goals of the project are:

- modularity
- repeatability
- stack-based deployment control
- environment isolation
- cost-aware lab validation
- enterprise-oriented evolution

---

## Architecture Overview

The target architecture follows a standard **3-tier model**:

### 1. Presentation / Access Tier
This tier includes controlled entry points to the platform, such as:

- public-facing access components
- load balancers
- administrative access patterns
- bastion or SSM-based operational access, depending on the final implementation

### 2. Application Tier
This tier hosts the application or service workloads:

- private compute resources
- internal services
- isolated application components
- security boundaries between public and private layers

### 3. Data Tier
This tier provides managed relational database services.

In the current lab implementation, the data layer uses:

**Amazon RDS for PostgreSQL**

This is a deliberate cost-conscious design choice for validation purposes and does not prevent future evolution toward more production-oriented data patterns.



## Current Status

### Validated
- **Stack B apply/destroy successfully validated**
- Terraform execution lifecycle confirmed for the validated stack
- Lab database layer aligned to **Amazon RDS for PostgreSQL**
- Repository structure initialized for enterprise-style evolution

### Current lab decision
In the lab environment, **Amazon RDS for PostgreSQL** is used instead of **Amazon Aurora PostgreSQL** because it provides:

- lower cost
- simpler provisioning and destroy cycles
- easier iterative validation
- better alignment with constrained AWS lab budgets

This is an intentional implementation choice for the lab and not a long-term architectural limitation.



## Repository Structure

The repository is currently organized as follows:



├── bootstrap/
├── docs/
├── infra/
├── scripts/
├── .gitignore
├── LICENSE
└── README.md
