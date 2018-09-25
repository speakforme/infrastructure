# infrastructure

Infrastructure Components for Speakforme campaign. This includes:

1.  AWS Configuration, managed via terraform
2.  Ansible Configuration

Writing our Infrastructure as Code allows us to make easier changes, rollback if needed,
and most importantly - allow everyone to contribute to the infrastructure.

## Directory Structure

```
├── README.md (This file)
├── terraform (AWS and other service configuration)
├───├── data.tf (AMI configuration)
├───├── dns.tf (All DNS records within speakforme.in)
├───├── instance.tf (AWS Instances)
├───├── provider.tf (AWS Provider Configuration)
├───├── s3.tf (S3 Buckets)
├───└── security_groups.tf (Security Groups, duh)
└── ansible (Server Configuration)
```

## TODO

-   [ ] Grant other people access
-   [ ] Add pass provider to hold secrets
-   [ ] Add netlify-provider
