# Contributing Guide

Thank you for contributing to the **Terraform AWS 3-Tier Enterprise** repository.

This repository is intended to evolve from a validated lab implementation into a more enterprise-ready Terraform platform. To support that goal, all contributions should follow a consistent workflow focused on clarity, validation, reviewability, and controlled change.

This guide explains how to contribute safely and effectively.

---

## Purpose

The purpose of this guide is to ensure that all repository changes are:

- understandable
- reviewable
- validated before merge
- aligned with the repository standards
- compatible with future CI/CD automation through **Jenkins**
- consistent with future platform boundaries for **ArgoCD** integration

---

## Scope

This guide applies to contributions involving:

- Terraform code in `infra/`
- bootstrap code in `bootstrap/`
- reusable modules in `infra/modules/`
- environment configuration in `infra/envs/`
- helper scripts in `scripts/`
- repository documentation in `docs/`, `README.md`, and related files

---

## Contribution Principles

All contributions should follow these principles:

- **small, focused changes**
  Prefer isolated changes over large mixed refactors.

- **explicit intent**
  The purpose of the change should be easy to understand from the branch name, commit message, and pull request description.

- **validation before merge**
  Infrastructure changes must be validated before they are merged.

- **documentation as part of the change**
  If structure, standards, workflows, or architecture are affected, the documentation must be updated.

- **safe evolution**
  The repository should evolve in a way that preserves repeatability and supports future automation.

---

## Branching Strategy

The current recommended branching model is lightweight but disciplined.

### Stable Branch

- main → stable branch

### Working Branches

Use dedicated branches for changes:

- `feature/*` → new functionality or repository improvements
- `docs/*` → documentation changes
- `fix/*` → bug fixes
- `refactor/*` → structural or code refactoring with no intended behavioral change

### Examples


feature/terraform-quality-gates
docs/standards-update
fix/lab-backend-path
refactor/network-module-cleanup
```

### Rules

- do not work directly on `main`
- create a branch for every non-trivial change
- keep branch scope focused on one logical purpose
- prefer pull requests over direct pushes to `main`

### Future Direction

If repository activity increases significantly, an intermediate integration branch such as `develop` may be introduced later. For now, `main` plus focused working branches is the recommended model.

---

## Recommended Workflow

### 1. Sync from `main`

Before starting a new change:


git checkout main
git pull origin main


### 2. Create a dedicated branch

Examples:


git checkout -b docs/contributing-guide
git checkout -b feature/tagging-standardization
git checkout -b fix/lab-tfvars-path


### 3. Implement the change

Make the smallest change set necessary to complete the objective.

### 4. Validate locally

At minimum, contributors should run validation appropriate to the type of change.

For Terraform changes, the minimum expectation is:


terraform fmt -check -recursive
terraform validate
terraform plan -var-file=envs/lab/terraform.tfvars


If formatting changes are needed:


terraform fmt -recursive


### 5. Review the diff

Before committing, check exactly what changed:


git status
git diff


### 6. Commit with a clear message

Examples:


git commit -m "docs: add contributing guide"
git commit -m "feat: standardize shared Terraform tags"
git commit -m "fix: correct lab backend configuration path"


### 7. Push the branch


git push -u origin <branch-name>


### 8. Open a Pull Request

Create a pull request from your working branch into `main`.

---

## Pull Request Expectations

Every pull request should clearly explain:

- **what changed**
- **why the change was needed**
- **which parts of the repository are affected**
- **how the change was validated**
- **whether documentation was updated**

### Recommended Pull Request Structure

Use a description that covers:

#### Summary
A concise explanation of the change.

#### Scope
The files, modules, or areas affected.

#### Validation
The commands run and the environment used.

#### Impact
Whether the change is documentation-only, non-breaking, breaking, operationally sensitive, or potentially destructive.

#### Follow-up
Any known future work or deferred improvements.

---

## Commit Message Guidelines

Commit messages should be concise, explicit, and consistent.

### Recommended Prefixes

- `docs:` → documentation
- `feat:` → new functionality
- `fix:` → bug fix
- `refactor:` → code restructuring without intended behavior change
- `test:` → validation-related update
- `chore:` → maintenance or repository housekeeping

### Examples


docs: add Terraform repository standards
feat: introduce shared naming and tagging locals
fix: correct lab backend configuration reference
refactor: simplify network module inputs
test: revalidate lab apply destroy workflow


### Rules

- keep the subject line short and meaningful
- describe the intent, not every implementation detail
- avoid vague messages such as `update`, `changes`, or `fix stuff`

---

## Terraform Contribution Rules

Infrastructure changes require extra care.

### Before Changing Terraform Code

Confirm the following:

- the target environment is known
- the intended resources are understood
- the impact of the change is clear
- required documentation has been reviewed

### Minimum Expectations for Terraform Changes

Contributors should aim to:

- keep modules focused and reusable
- avoid hardcoded environment-specific values
- preserve naming and tagging consistency
- keep inputs typed and documented
- expose only meaningful outputs
- avoid introducing hidden dependencies between modules

### Required Local Validation

For changes under `infra/`, the minimum local validation should include:


cd infra
terraform init -reconfigure -backend-config=envs/lab/backend.hcl
terraform fmt -check -recursive
terraform validate
terraform plan -var-file=envs/lab/terraform.tfvars


For changes that affect lifecycle behavior, contributors should strongly consider a full lab test cycle:


terraform apply -var-file=envs/lab/terraform.tfvars
terraform destroy -var-file=envs/lab/terraform.tfvars


---

## Documentation Contribution Rules

Documentation is part of the engineering process, not an afterthought.

### Update Documentation When:

- repository structure changes
- standards change
- branching workflow changes
- architecture decisions change
- Terraform usage or environment execution changes
- new operational constraints are introduced

### Documentation Quality Expectations

Documentation should be:

- written in professional English
- structured and readable
- specific to the repository
- updated together with the implementation where applicable

---

## Script Contribution Rules

Scripts under `scripts/` should improve usability and repeatability.

### Rules

- scripts must be intentional and clearly named
- scripts should not hide critical business logic that belongs in Terraform or documented workflows
- scripts should be reusable and environment-aware where appropriate
- scripts should fail clearly when required parameters are missing
- scripts should support future CI/CD use where possible

---

## Review Checklist

Before opening a pull request, confirm the following:

### General

- [ ] the change is focused and scoped appropriately
- [ ] the branch name reflects the work being done
- [ ] the diff has been reviewed locally
- [ ] commit messages are clear

### Terraform Changes

- [ ] Terraform code is formatted
- [ ] Terraform validation passes
- [ ] Terraform plan has been reviewed
- [ ] environment-specific paths are correct
- [ ] naming and tagging remain consistent
- [ ] outputs remain meaningful
- [ ] destructive impact, if any, is understood

### Documentation Changes

- [ ] the documentation reflects the current repository state
- [ ] wording is clear and professional
- [ ] references to paths, commands, and environments are correct

---

## Validation Expectations by Change Type

### Documentation-only changes

Expected checks:

- review content for clarity and correctness
- verify file paths and commands if referenced

### Terraform non-destructive changes

Expected checks:

- `terraform fmt -check -recursive`
- `terraform validate`
- `terraform plan`

### Terraform structural or lifecycle-sensitive changes

Expected checks:

- `terraform fmt -check -recursive`
- `terraform validate`
- `terraform plan`
- lab `apply/destroy` retest where reasonably possible

### Bootstrap changes

Expected checks depend on the nature of the bootstrap logic, but must include enough validation to justify the change safely.

---

## Quality Direction

As the repository matures, contributions should gradually align with stronger engineering controls, including:

- `pre-commit` hooks
- `tflint`
- `checkov` or `tfsec`
- automated formatting checks
- CI-based validation in Jenkins
- approval gates for sensitive environments

Contributors should design changes so they are compatible with this future direction.

---

## Jenkins Readiness Expectations

Because this repository is expected to integrate with **Jenkins**, all contributions should support predictable automation.

### Rules

- commands should be scriptable and deterministic
- environment selection must be explicit
- backend and tfvars paths must remain stable
- manual undocumented steps should be avoided
- outputs used by automation should remain meaningful and stable

### Practical Implication

If a contributor introduces a new workflow, path, or operational dependency, it must be documented clearly enough that the same behavior can later be reproduced in Jenkins without guesswork.

---

## ArgoCD Alignment Expectations

This repository is expected to coexist with a future **ArgoCD**-based GitOps model.

### Responsibility Boundary

Contributions to this repository should remain focused on:

- AWS foundational infrastructure
- network and security primitives
- platform components provisioned through Terraform
- infrastructure dependencies required before GitOps-managed workloads can run

Contributors should avoid mixing infrastructure concerns with future application deployment concerns unless explicitly documented.

---

## What to Avoid

Please avoid the following:

- direct work on `main`
- mixed-purpose pull requests
- hardcoded secrets
- undocumented manual AWS changes
- unreviewed destructive changes
- vague commit messages
- hidden logic in scripts without documentation
- repository changes that make future automation harder

---

## When to Ask for Additional Review

Additional review is strongly recommended when a change affects:

- Terraform backend or state handling
- networking layout or routing
- security groups or IAM boundaries
- database lifecycle behavior
- module contracts or shared variables
- environment conventions
- CI/CD execution patterns

---

## Definition of a Good Contribution

A good contribution is one that is:

- focused
- validated
- documented where necessary
- easy to review
- safe to merge
- aligned with the repository standards
- compatible with the future Jenkins and ArgoCD delivery model

---

## Final Note

This repository is evolving toward an enterprise-ready Terraform platform.

Contributing successfully does not mean introducing large changes quickly. It means improving the repository in a way that is:

- controlled
- clear
- repeatable
- safe
- compatible with future automation

If in doubt, prefer clarity over cleverness, and smaller validated changes over broad unreviewed refactors.
