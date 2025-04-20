# FedRAMP Multi-Cloud Security Architecture

This project implements a FedRAMP-aligned security framework using AWS and Azure. It’s mapped to key NIST 800-53 controls and is designed to demonstrate how cloud-native services can be combined with compliance-focused architecture and automation.

> ⚠️ **Disclaimer:** This is not intended as a production-ready FedRAMP solution. It is a home project meant to showcase architectural design and security alignment with regulatory frameworks. Business requirements should always drive final implementation.

---

## 📌 Key Features

- ✅ Multi-cloud architecture (AWS + Azure)
- 🔐 IAM policies with least privilege
- 📜 Logging & monitoring (CloudWatch + Azure Monitor)
- 🧩 Terraform modules for IaC and multi-cloud provisioning
- 📦 Compliance scanning scripts for AWS and Azure
- 🧠 Mapped to NIST 800-53 Rev 5 controls
- 🧰 Folder structure aligned with real-world documentation & security ops

---

## 📂 Folder Overview


---

## 🔐 Mapped NIST 800-53 Controls

| Control Area           | NIST ID    | Description                              |
|------------------------|------------|------------------------------------------|
| IAM Roles              | AC-2, AC-6 | Least privilege & access enforcement     |
| Logging & Monitoring   | AU-2, AU-12| CloudWatch + Azure Monitor configuration |
| Secrets Management     | SC-12      | AWS Secrets Manager / Azure Key Vault    |
| Vulnerability Scanning | SI-2       | Compliance scans for AWS and Azure       |

---

## 🚀 Future Enhancements

- Add GCP Terraform modules
- Integrate automated SSP generator
- Create GitHub Actions workflows for CI/CD & validation

---

## 📄 License

This project is under the [MIT License](LICENSE).
