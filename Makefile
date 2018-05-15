.DEFAULT_GOAL := help
.PHONY: help create-stack get-profile get-account get-email get-budget

# These values can change depending on your needs #
project.name := aws-billing-alarm
project.repo := github.com/unbounce/$(project.name)

stack.name := billing-alerts
stack.owner := security
stack.lifetime := long
# / #

help: ## show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

get-profile:
ifndef AWS_PROFILE
	@echo "Provide a AWS_PROFILE to continue."; exit 1
endif

get-account:
ifndef ACCOUNT_NAME
	@echo "Provide a ACCOUNT_NAME to continue."; exit 1
endif

get-email:
ifndef RECIPIENT_EMAIL
	@echo "Provide a RECIPIENT_EMAIL to continue."; exit 1
endif

get-budget:
ifndef MAX_EXPENSE_IN_DOLLARS
	@echo "Provide a MAX_EXPENSE_IN_DOLLARS to continue."; exit 1
endif

create-stack: get-profile get-account get-email get-budget ## create the stack in the given AWS_PROFILE
	aws cloudformation create-stack --stack-name $(stack.name) --template-body file://cfn-template.yml --parameters ParameterKey=AccountName,ParameterValue=$(ACCOUNT_NAME) ParameterKey=RecipientEmailAddress,ParameterValue=$(RECIPIENT_EMAIL) ParameterKey=MaxMonthlyExpenseInDollars,ParameterValue=$(MAX_EXPENSE_IN_DOLLARS) --tags Key=project,Value=$(project.name) Key=owner,Value=$(stack.owner) Key=repository,Value=$(project.repo) Key=lifetime,Value=$(stack.lifetime) --enable-termination-protection --region us-east-1 --profile $(AWS_PROFILE) --stack-policy-body file://cfn-policy.json

# Removing stack termination protection must be a manual operation to
# prevent accidents.
delete-stack: get-profile ## delete the stack
	aws cloudformation delete-stack --stack-name $(stack.name) --region us-east-1 --profile $(AWS_PROFILE)

