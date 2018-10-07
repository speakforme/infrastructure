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
    └── security_groups.tf
```

## How does it work?

We run entirely off Terraform, AWS (SES+Lambda+DynamoDB).

The website part of it is at [speakforme/website](https://github.com/speakforme/website).
We mark ourselves in the bcc (`bcc@email.speakforme.in`). This is caught by SES, which triggers
a Lambda job.

The Lambda job:

-   [x] Generates a UUID.
-   [x] Saves the from email in dynamoDB against the UUID.
-   [x] Sends an acknowledgement email with a unsubscription link that has the UUID.
-   [x] Bumps counters in another table for every email marked on the email

The unsubscription link triggers another Lambda job which:

-   [ ] Deletes the email entry from the DynamoDB using the UUID.
