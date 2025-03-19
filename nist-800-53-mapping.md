# FedRAMP to NIST 800-53 Control Mapping

This document provides a mapping between the FedRAMP controls implemented in this project and their corresponding NIST 800-53 Rev 5 controls. This mapping helps demonstrate how the cloud-specific implementations satisfy the underlying security requirements defined in NIST 800-53.

## Access Control (AC) Family

| NIST 800-53 Control ID | Control Name | FedRAMP Requirement | Implementation in Project |
|------------------------|--------------|---------------------|---------------------------|
| AC-1 | Access Control Policy and Procedures | Develop, document, and disseminate access control policy and procedures | - Documentation in SSP template<br>- Policy templates in each provider's IAM directory |
| AC-2 | Account Management | Implement account management processes including creation, activation, modification, review, disabling, and removal | - AWS IAM User lifecycle management<br>- Azure AD user provisioning<br>- GCP IAM account management |
| AC-3 | Access Enforcement | Enforce approved authorizations for logical access | - AWS IAM policies<br>- Azure RBAC<br>- GCP IAM permissions |
| AC-4 | Information Flow Enforcement | Enforce approved authorizations for controlling information flow | - AWS Security Groups & NACLs<br>- Azure NSGs<br>- GCP Firewall Rules |
| AC-5 | Separation of Duties | Enforce separation of duties | - AWS: Admin vs Auditor roles<br>- Azure: AD security groups<br>- GCP: Custom IAM roles |
| AC-6 | Least Privilege | Employ principle of least privilege | - Granular IAM policies across all providers<br>- Custom roles with minimal permissions |
| AC-7 | Unsuccessful Logon Attempts | Enforce limit of consecutive invalid access attempts | - AWS account settings<br>- Azure AD smart lockout<br>- GCP login failures tracking |
| AC-8 | System Use Notification | Display system use notification message | - Login banners in each provider |
| AC-11 | Session Lock | Prevent further access after period of inactivity | - Session timeout settings in each provider |
| AC-12 | Session Termination | Automatically terminate user sessions | - AWS session policies<br>- Azure token lifetime policies<br>- GCP session controls |
| AC-17 | Remote Access | Establish and document usage restrictions and implementation guidance for remote access | - Secure VPN configurations<br>- Conditional access policies<br>- Remote access logging |

## Audit and Accountability (AU) Family

| NIST 800-53 Control ID | Control Name | FedRAMP Requirement | Implementation in Project |
|------------------------|--------------|---------------------|---------------------------|
| AU-1 | Audit and Accountability Policy and Procedures | Develop, document, and disseminate audit and accountability policy | - Documentation in SSP template |
| AU-2 | Audit Events | Determine system events that require auditing | - AWS CloudTrail configuration<br>- Azure activity logs<br>- GCP audit logs |
| AU-3 | Content of Audit Records | Ensure audit records contain information to establish what events occurred | - Comprehensive logging configuration across providers |
| AU-4 | Audit Storage Capacity | Allocate sufficient audit record storage capacity | - S3 bucket for CloudTrail<br>- Azure Log Analytics retention<br>- GCP log storage |
| AU-5 | Response to Audit Processing Failures | Alert personnel in the event of an audit processing failure | - AWS CloudWatch alarms<br>- Azure Monitor alerts<br>- GCP monitoring alerts |
| AU-6 | Audit Review, Analysis, and Reporting | Review and analyze audit records for inappropriate activity | - Log analysis configurations across providers |
| AU-7 | Audit Reduction and Report Generation | Provide audit reduction and report generation capability | - AWS Athena for CloudTrail analysis<br>- Azure Log Analytics queries<br>- GCP Log Explorer |
| AU-9 | Protection of Audit Information | Protect audit information from unauthorized access, modification, and deletion | - Encryption and access controls for audit logs |
| AU-12 | Audit Generation | Provide audit record generation capability | - Comprehensive audit logging across all providers |

## Risk Assessment (RA) Family

| NIST 800-53 Control ID | Control Name | FedRAMP Requirement | Implementation in Project |
|------------------------|--------------|---------------------|---------------------------|
| RA-1 | Risk Assessment Policy and Procedures | Develop, document, and disseminate risk assessment policy | - Documentation in SSP template |
| RA-2 | Security Categorization | Categorize information and systems | - System categorization in SSP |
| RA-3 | Risk Assessment | Conduct risk assessments | - Compliance scanning scripts in project |
| RA-5 | Vulnerability Scanning | Scan for vulnerabilities and remediate | - AWS Inspector configuration<br>- Azure Defender<br>- GCP Security Command Center |

## System and Communications Protection (SC) Family

| NIST 800-53 Control ID | Control Name | FedRAMP Requirement | Implementation in Project |
|------------------------|--------------|---------------------|---------------------------|
| SC-1 | System and Communications Protection Policy and Procedures | Develop, document, and disseminate system and communications protection policy | - Documentation in SSP template |
| SC-7 | Boundary Protection | Implement boundary protection mechanisms | - Network configuration across all providers |
| SC-8 | Transmission Confidentiality and Integrity | Protect the confidentiality and integrity of transmitted information | - TLS configuration<br>- Certificate management |
| SC-12 | Cryptographic Key Establishment and Management | Establish and manage cryptographic keys | - AWS KMS<br>- Azure Key Vault<br>- GCP Cloud KMS |
| SC-13 | Cryptographic Protection | Implement cryptographic mechanisms | - Encryption configuration across all providers |
| SC-28 | Protection of Information at Rest | Protect information at rest | - Encryption at rest configuration |

## System and Information Integrity (SI) Family

| NIST 800-53 Control ID | Control Name | FedRAMP Requirement | Implementation in Project |
|------------------------|--------------|---------------------|---------------------------|
| SI-1 | System and Information Integrity Policy and Procedures | Develop, document, and disseminate system and information integrity policy | - Documentation in SSP template |
| SI-2 | Flaw Remediation | Identify, report, and correct flaws | - Patching configurations<br>- Vulnerability remediation process |
| SI-3 | Malicious Code Protection | Implement malicious code protection | - AWS GuardDuty<br>- Azure Defender<br>- GCP Security Command Center |
| SI-4 | Information System Monitoring | Monitor system to detect attacks and unauthorized activities | - Monitoring configuration across providers<br>- Alert setup |
| SI-5 | Security Alerts, Advisories, and Directives | Receive and respond to security alerts and advisories | - Alert configuration |

## Implementation Notes

1. **Control Documentation**: Most controls require both technical implementation and documentation. The SSP template in this project addresses the documentation component.

2. **Control Enhancement Mapping**: NIST 800-53 controls often have enhancements (e.g., AC-2(1), AC-2(2)). This mapping focuses on the base controls, but many implementations address enhancements as well.

3. **Control Inheritance**: In a cloud environment, many controls are partially inherited from the CSP. This project focuses on customer-responsible aspects.

4. **Implementation Depth**: The implementation depth varies by control, with some having detailed technical implementations and others focused on policy templates.

## NIST 800-53 Rev 5 Control Families Not Fully Addressed

This project focuses on key control families, but a comprehensive FedRAMP implementation would need to address all relevant families including:

- Awareness and Training (AT)
- Assessment, Authorization, and Monitoring (CA)
- Configuration Management (CM)
- Contingency Planning (CP)
- Identification and Authentication (IA)
- Incident Response (IR)
- Maintenance (MA)
- Media Protection (MP)
- Physical and Environmental Protection (PE)
- Planning (PL)
- Program Management (PM)
- Personnel Security (PS)
- Supply Chain Risk Management (SR)

## References

- [NIST SP 800-53 Rev. 5](https://csrc.nist.gov/publications/detail/sp/800-53/rev-5/final)
- [FedRAMP Security Controls Baseline](https://www.fedramp.gov/documents/)
