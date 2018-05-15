# Billing Alarm stack

This project creates the minimum AWS resources necessary to alert when
a the monthly billing charges exceeds a given threshold. The resources
are managed with a CloudFormation stack.

One design decision made is to add a basic email address as the only
subscriber to the SNS topic receiving the Cloudwatch alarm.  This is
intended to be the account's email address (supplied by the caller).
If another process wants to subscribe to the SNS topic, create another
CloudFormation stack using the exported stack output for the SNS
topic ARN.

## Requirements

* `make`
* AWS access
* Permission to create/delete CloudFormation stacks, SNS topics, and
CloudWatch alarms.

Ansible is required if you want full orchestration of the stack, but if
you are comfortable launching the CloudFormation stack you can consider
the Ansible components as optional.  If you are new to this project, use
Ansible.

## Launching this Stack

Given some values for `EMAIL_ADDRESS`, `ACCOUNT_NAME`, and `MAX_DOLLARS`
you launch the stack with the following command:

```
$ make create-stack RECIPIENT_EMAIL=EMAIL_ADDRESS ACCOUNT_NAME=ACCOUNT_NAME MAX_EXPENSE_IN_DOLLARS=MAX_DOLLARS AWS_PROFILE=example-profile
{
  "StackId": "..."
}
```

The stack is created asynchronously.  It's status can be checked by
calling: `make status`

Take note that the SNS topic subscription will need to be confirmed, which
arrives as an email to the email address's inbox specified in the call to
launch the stack.

## License

tl;dr MIT license

See [LICENSE](LICENSE) for more details.

