# infrastructure

Infrastructure Components for Speakforme campaign. This includes:

1.  AWS Configuration, managed via terraform
2.  Ansible Configuration

Writing our Infrastructure as Code allows us to make easier changes, rollback if needed,
and most importantly - allow everyone to contribute to the infrastructure.

## Directory Structure

```
├── ansible (server configuration)
│   ├── ansible.cfg
│   ├── group_vars
│   │   └── all
│   │       └── vault.yml (SES Secrets)
│   ├── inventory
│   └── servers.yml (ansible playbook)
├── README.md
└── terraform
    ├── data.tf (AMI Configuration)
    ├── dns.tf
    ├── instance.tf (Instance Configuration)
    ├── keys.tf (Default AWS Keys)
    ├── provider.tf (AWS Config)
    ├── s3.tf (S3 Bucket for storing terraform state)
    ├── security_groups.tf
```

## TODO

-   [ ] Setup campaign app on the server
-   [ ] Grant other people access
-   [ ] Add pass provider to hold secrets
-   [ ] Add netlify-provider
