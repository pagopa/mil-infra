# mil-infra

[![Static Analysis](https://github.com/pagopa/mil-infra/actions/workflows/static_analysis.yml/badge.svg)](https://github.com/pagopa/mil-infra/actions/workflows/static_analysis.yml)
[![Release](https://github.com/pagopa/mil-infra/actions/workflows/release.yml/badge.svg)](https://github.com/pagopa/mil-infra/actions/workflows/release.yml)

[![Continuous Delivery on dev core](https://github.com/pagopa/mil-infra/actions/workflows/dev_cd_core.yml/badge.svg)](https://github.com/pagopa/mil-infra/actions/workflows/dev_cd_core.yml)
[![Drift Detection on dev core](https://github.com/pagopa/mil-infra/actions/workflows/dev_drift_core.yml/badge.svg)](https://github.com/pagopa/mil-infra/actions/workflows/dev_drift_core.yml)

[![Continuous Delivery on prod core](https://github.com/pagopa/mil-infra/actions/workflows/prod_cd_core.yml/badge.svg)](https://github.com/pagopa/mil-infra/actions/workflows/prod_cd_core.yml)
[![Drift Detection on prod core](https://github.com/pagopa/mil-infra/actions/workflows/prod_drift_core.yml/badge.svg)](https://github.com/pagopa/mil-infra/actions/workflows/prod_drift_core.yml)

MIL project infrastructure

![This is an image](./docs/architecture.png)

### Terraform folders name convention

Inside the folder src we have this folders, that contains the terraform files. Here you can find the meaning of the folders

* core: here you can find all the business infrastructure objects, use data to load the objects created in pillar.

## Requirements

### 1. terraform

In order to manage the suitable version of terraform it is strongly recommended to install the following tool:

* [tfenv](https://github.com/tfutils/tfenv): **Terraform** version manager inspired by rbenv.

Once these tools have been installed, install the terraform version shown in:

* .terraform-version

After installation install terraform:

```sh
tfenv install
```

## Terraform modules

As PagoPA we build our standard Terraform modules, check available modules:

* [PagoPA Terraform modules](https://github.com/search?q=topic%3Aterraform-modules+org%3Apagopa&type=repositories)

## Apply changes

To apply changes follow the standard terraform lifecycle once the code in this repository has been changed:

```sh
terraform.sh init [dev|uat|prod]

terraform.sh plan [dev|uat|prod]

terraform.sh apply [dev|uat|prod]
```

## Terraform lock.hcl

We have both developers who work with your Terraform configuration on their Linux, macOS or Windows workstations and automated systems that apply the configuration while running on Linux.
<https://www.terraform.io/docs/cli/commands/providers/lock.html#specifying-target-platforms>

So we need to specify this in terraform lock providers:

```sh
terraform init

rm .terraform.lock.hcl

terraform providers lock \
  -platform=windows_amd64 \
  -platform=darwin_amd64 \
  -platform=darwin_arm64 \
  -platform=linux_amd64
```

## Precommit checks

Check your code before commit.

<https://github.com/antonbabenko/pre-commit-terraform#how-to-install>

```sh
pre-commit run -a
```
