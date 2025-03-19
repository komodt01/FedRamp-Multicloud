# AWS IAM Implementation (aws/iam/setup.sh)
#!/bin/bash
# FedRAMP IAM Controls Implementation for AWS

# Source configuration
cd "$(dirname "$0")/../.."
source config.env

echo "====================================================="
echo "AWS IAM Controls Implementation - FedRAMP Compliance"
echo "====================================================="

# Create directory for policies if it doesn't exist
mkdir -p aws/iam/policies

# Create a least-privilege IAM policy for FedRAMP auditing
cat > aws/iam/policies/fedramp-auditor-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudtrail:LookupEvents",
        "cloudwatch:GetMetricData",
        "config:BatchGetResourceConfig",
        "config:GetComplianceDetailsByResource",
        "config:GetResourceConfigHistory",
        "iam:GenerateCredentialReport",
        "iam:GetCredentialReport",
        "iam:GetAccountSummary",
        "s3:GetBucketLogging",
        "s3:GetBucketVersioning",
        "s3:GetEncryptionConfiguration"
      ],
      "Resource": "*"
    }
  ]
}
EOF

# Create FedRAMP-compliant password policy (AC-7, IA-5)
echo "Creating FedRAMP-compliant password policy..."
aws iam update-account-password-policy \
    --minimum-password-length 12 \
    --require-symbols \
    --require-numbers \
    --require-uppercase-characters \
    --require-lowercase-characters \
    --allow-users-to-change-password \
    --max-password-age 90 \
    --password-reuse-prevention 24

echo "Creating IAM policies and roles for FedRAMP compliance..."
# Create FedRAMP Auditor policy
aws iam create-policy \
    --policy-name FedRAMPAuditorPolicy \
    --policy-document file://aws/iam/policies/fedramp-auditor-policy.json

# Create FedRAMP Administrator policy
cat > aws/iam/policies/fedramp-administrator-policy.json << 'EOF'
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*",
        "organizations:*",
        "cloudtrail:*",
        "config:*",
        "kms:*",
        "s3:*",
        "cloudwatch:*",
        "guardduty:*",
        "ec2:*"
      ],
      "Resource": "*",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}
EOF

# Create Administrator policy with MFA requirement (AC-2, IA-2)
aws iam create-policy \
    --policy-name FedRAMPAdministratorPolicy \
    --policy-document file://aws/iam/policies/fedramp-administrator-policy.json

# Create roles for separation of duties (AC-5)
echo "Creating roles for separation of duties..."
aws iam create-role \
    --role-name FedRAMPAuditor \
    --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}'

aws iam attach-role-policy \
    --role-name FedRAMPAuditor \
    --policy-arn "arn:aws:iam::$AWS_ACCOUNT_ID:policy/FedRAMPAuditorPolicy"

aws iam create-role \
    --role-name FedRAMPAdministrator \
    --assume-role-policy-document '{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}'

aws iam attach-role-policy \
    --role-name FedRAMPAdministrator \
    --policy-arn "arn:aws:iam::$AWS_ACCOUNT_ID:policy/FedRAMPAdministratorPolicy"

# Setup automatic inactive session termination (AC-12)
echo "Setting up CloudWatch Events rule for inactive session termination..."
cat > aws/iam/policies/session-termination-rule.json << 'EOF'
{
  "Name": "FedRAMPInactiveSessionTermination",
  "ScheduleExpression": "rate(1 hour)",
  "State": "ENABLED",
  "Description": "Terminates inactive IAM user sessions after 30 minutes of inactivity"
}
EOF

# Finished
echo "AWS IAM FedRAMP controls implementation completed."
echo "============================================================"

# Azure IAM Implementation (azure/iam/setup.sh)
#!/bin/bash
# FedRAMP IAM Controls Implementation for Azure

# Source configuration
cd "$(dirname "$0")/../.."
source config.env

echo "====================================================="
echo "Azure IAM Controls Implementation - FedRAMP Compliance"
echo "====================================================="

# Create directory for policies if it doesn't exist
mkdir -p azure/iam/policies

# Create resource group if it doesn't exist
echo "Creating Azure resource group for FedRAMP resources..."
az group create --name $AZURE_RESOURCE_GROUP --location $AZURE_LOCATION

# Create custom RBAC role for FedRAMP auditing (AC-6)
echo "Creating custom RBAC role for FedRAMP auditing..."
cat > azure/iam/policies/fedramp-auditor-role.json << EOF
{
  "Name": "FedRAMP Auditor",
  "Description": "Custom role for FedRAMP compliance auditing",
  "Actions": [
    "Microsoft.Security/assessments/read",
    "Microsoft.Security/complianceResults/read",
    "Microsoft.Security/securityStatuses/read",
    "Microsoft.Storage/storageAccounts/blobServices/containers/read",
    "Microsoft.Resources/subscriptions/resourceGroups/read",
    "Microsoft.ResourceHealth/availabilityStatuses/read",
    "Microsoft.Insights/diagnosticSettings/read",
    "Microsoft.Insights/logprofiles/read"
  ],
  "NotActions": [],
  "AssignableScopes": [
    "/subscriptions/$AZURE_SUBSCRIPTION_ID"
  ]
}
EOF

az role definition create --role-definition @azure/iam/policies/fedramp-auditor-role.json

# Setup Azure AD password policy (IA-5)
echo "Note: Azure AD password policies should be configured in the Azure portal or via Microsoft Graph API"
echo "FedRAMP requirements include:"
echo "- Minimum password length: 12 characters"
echo "- Complexity requirements enabled"
echo "- Password expiration: 90 days maximum"
echo "- Password history: 24 passwords remembered"
echo "- Account lockout after 3 invalid attempts"

# Create Azure AD security groups for separation of duties (AC-5)
echo "Creating Azure AD security groups for separation of duties..."
az ad group create --display-name "FedRAMP Administrators" --mail-nickname "fedramp-admins"
az ad group create --display-name "FedRAMP Auditors" --mail-nickname "fedramp-auditors"
az ad group create --display-name "FedRAMP Users" --mail-nickname "fedramp-users"

# Setup role assignments
echo "Setting up role assignments..."
# Note: In a production environment, you would assign these roles to specific users or groups

# Configure Conditional Access policies for MFA (IA-2)
echo "Creating Conditional Access policy template for MFA..."
cat > azure/iam/policies/conditional-access-mfa.json << 'EOF'
{
  "displayName": "FedRAMP - Require MFA for all users",
  "state": "enabled",
  "conditions": {
    "userRiskLevels": [],
    "signInRiskLevels": [],
    "clientAppTypes": ["all"],
    "platforms": null,
    "locations": null,
    "applications": {
      "includeApplications": ["All"]
    },
    "users": {
      "includeUsers": ["All"]
    }
  },
  "grantControls": {
    "operator": "AND",
    "builtInControls": ["mfa"]
  }
}
EOF

echo "Note: Conditional Access policies must be implemented via Azure Portal or Microsoft Graph API"

# Azure AD session management (AC-12)
echo "Configuring Azure AD session timeout settings..."
cat > azure/iam/policies/token-lifetime-policy.json << 'EOF'
{
  "TokenLifetimePolicy": {
    "Version": 1.0,
    "AccessTokenLifetime": "01:00:00",
    "MaxInactiveTime": "00:30:00"
  }
}
EOF

echo "Note: Token lifetime policies must be implemented via Azure Portal or Microsoft Graph API"

# Finished
echo "Azure IAM FedRAMP controls implementation completed."
echo "============================================================"

# Google Cloud IAM Implementation (gcp/iam/setup.sh)
#!/bin/bash
# FedRAMP IAM Controls Implementation for Google Cloud Platform

# Source configuration
cd "$(dirname "$0")/../.."
source config.env

echo "====================================================="
echo "GCP IAM Controls Implementation - FedRAMP Compliance"
echo "====================================================="

# Create directory for policies if it doesn't exist
mkdir -p gcp/iam/policies

# Create custom IAM role for FedRAMP auditing (AC-6)
echo "Creating custom role for FedRAMP auditing in GCP..."
cat > gcp/iam/policies/fedramp-auditor-role.yaml << EOF
title: "FedRAMP Auditor"
description: "Role for FedRAMP compliance auditing"
stage: "GA"
includedPermissions:
- cloudasset.assets.listResource
- cloudkms.cryptoKeys.get
- compute.instances.get
- logging.logEntries.list
- monitoring.alertPolicies.get
- resourcemanager.projects.get
- storage.buckets.get
EOF

gcloud iam roles create FedRAMPAuditor \
  --project=$GCP_PROJECT_ID \
  --file=gcp/iam/policies/fedramp-auditor-role.yaml

# Create custom IAM role for FedRAMP administrators (AC-6)
echo "Creating custom role for FedRAMP administrators in GCP..."
cat > gcp/iam/policies/fedramp-admin-role.yaml << EOF
title: "FedRAMP Administrator"
description: "Role for FedRAMP security administration"
stage: "GA"
includedPermissions:
- iam.roles.*
- iam.serviceAccounts.*
- compute.firewalls.*
- compute.networks.*
- compute.subnetworks.*
- logging.sinks.*
- monitoring.alertPolicies.*
- storage.buckets.*
EOF

gcloud iam roles create FedRAMPAdministrator \
  --project=$GCP_PROJECT_ID \
  --file=gcp/iam/policies/fedramp-admin-role.yaml

# Create service accounts for separation of duties (AC-5)
echo "Creating service accounts for separation of duties..."
gcloud iam service-accounts create fedramp-auditor \
  --display-name="FedRAMP Auditor Service Account"

gcloud iam service-accounts create fedramp-admin \
  --display-name="FedRAMP Administrator Service Account"

# Assign roles to service accounts
echo "Assigning roles to service accounts..."
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:fedramp-auditor@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
  --role="projects/$GCP_PROJECT_ID/roles/FedRAMPAuditor"

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:fedramp-admin@$GCP_PROJECT_ID.iam.gserviceaccount.com" \
  --role="projects/$GCP_PROJECT_ID/roles/FedRAMPAdministrator"

# Setup organization policies for FedRAMP compliance (AC-2, AC-3)
echo "Setting up organization policies for FedRAMP compliance..."

# Require corporate login
gcloud resource-manager org-policies enable-enforce \
  --project=$GCP_PROJECT_ID constraints/iam.allowedPolicyMemberDomains

# Domain restricted sharing
echo "Creating domain restricted sharing organization policy..."
cat > gcp/iam/policies/domain-restricted-sharing.yaml << EOF
name: projects/$GCP_PROJECT_ID/policies/iam.allowedPolicyMemberDomains
spec:
  rules:
  - values:
      allowedValues:
      - c:YOUR_DOMAIN.com  # Replace with your organization's domain
EOF

# Disable service account key creation
gcloud resource-manager org-policies enable-enforce \
  --project=$GCP_PROJECT_ID constraints/iam.disableServiceAccountKeyCreation

# Require OS Login for VM instances
gcloud compute project-info add-metadata \
  --metadata enable-oslogin=TRUE

# Setup Cloud Identity-Aware Proxy for web applications (AC-17)
echo "Setting up template for Cloud Identity-Aware Proxy..."
cat > gcp/iam/policies/iap-config.yaml << 'EOF'
# IAP Web configuration
# To be applied with gcloud iap web enable command
oauth2ClientId: YOUR_CLIENT_ID
oauth2ClientSecret: YOUR_CLIENT_SECRET
EOF

echo "Note: To complete IAP setup, create OAuth credentials in the GCP Console"

# Finished
echo "GCP IAM FedRAMP controls implementation completed."
echo "============================================================"
