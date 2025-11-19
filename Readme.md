# FedRAMP Multi-Cloud Security Architecture

This project demonstrates how AWS and Azure can be combined to implement a FedRAMP-aligned security architecture using cloud-native services and Terraform. The project maps to core NIST 800-53 Rev 5 controls and is designed strictly for educational and portfolio purposes.

This is not a production-ready FedRAMP solution. It demonstrates architectural alignment, documentation structure, and baseline compliance practices.

---------------------------------------------------------------------

## Project Purpose

1. Show how AWS and Azure cloud services can meet core FedRAMP and NIST 800-53 control expectations.
2. Demonstrate multi-cloud security architecture concepts.
3. Provide Terraform-based reproducible deployment.
4. Document how identity, logging, secrets, and monitoring can be configured for compliance.
5. Serve as a reference architecture for cloud security portfolios.

---------------------------------------------------------------------

## System Requirements

### Business Requirements
1. Demonstrate a multi-cloud FedRAMP-style security architecture using AWS and Azure.
2. Use only cloud-native services to highlight shared responsibility.
3. Provide documentation aligned to FedRAMP-style requirements and NIST 800-53 controls.
4. Support auditability, logging, and traceability.

### Functional Requirements
1. Deploy minimal AWS and Azure infrastructure using Terraform.
2. Implement IAM least-privilege roles.
3. Enable logging, monitoring, and auditing across both clouds.
4. Provide scanning or validation scripts.
5. Include clear documentation: design, requirements, risks, and control mapping.

### Security Requirements
1. Secrets must be stored only in AWS Secrets Manager or Azure Key Vault.
2. IAM roles must enforce least privilege.
3. Logging must be enabled for all identity and API actions.
4. Terraform code must avoid manual configuration drift.
5. Control mappings must reference NIST 800-53 Rev 5.

### Non-Functional Requirements
1. Project must remain cloud-vendor-neutral in structure and wording.
2. Documentation must be portable across platforms.
3. No real credentials or sensitive information may be included.

---------------------------------------------------------------------

## Documentation Provided

The repository includes:

- requirements.md (merged here)
- design_overview.md
- technologies.md
- security_requirements.md
- compliance_mapping.md
- risks_and_mitigations.md

These files follow documentation patterns used in FedRAMP SSP preparation but are simplified for learning and demonstration.

---------------------------------------------------------------------

## NIST 800-53 Alignment (Summary)

The project demonstrates baseline alignment with:

- AC-2 Access Control
- AC-6 Least Privilege
- AU-2 Logging
- AU-12 Audit Record Generation
- SC-12 Cryptographic Key and Secrets Management
- SI-2 Flaw Remediation

More detailed mappings are listed in compliance_mapping.md.

---------------------------------------------------------------------

## Deployment Instructions

The project includes Terraform modules for AWS and Azure.

Initialize Terraform:

terraform init
Review changes:

teraform plan
Deploy:

terraform apply
Teardown:

terraform destroy


---------------------------------------------------------------------

## Repository Structure

A typical structure (your exact repo may differ):

fedramp-multicloud/
    README.md
    requirements.md
    design_overview.md
    technologies.md
    security_requirements.md
    compliance_mapping.md
    risks_and_mitigations.md
    aws/
    azure/
    scripts/
    terraform/

---------------------------------------------------------------------

## Future Enhancements

1. Add GCP support to complete three-cloud coverage.
2. Add GitHub Actions workflow for compliance validation.
3. Generate System Security Plan (SSP) stubs automatically.
4. Add multi-cloud boundary and data-flow diagrams.

---------------------------------------------------------------------

## Disclaimer

This project is for demonstration and portfolio purposes only.  
It does not represent an official FedRAMP system or production-ready security boundary.  
All architecture must be tailored to system classification, business requirements, risk posture, and authorized compliance standards.
