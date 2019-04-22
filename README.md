Terraform Examples
==================
### A collection of Terraform examples

Each directory contains an example, be sure to check the README.md file in each for more details.  In general, you will navigate to each directory and do your terraform init/plan/apply, but some may require additional configuration for variables specific to you.


General Notes
-------------
### Using terraform-docs
The [terraform-docs](https://github.com/segmentio/terraform-docs) package can be used to generate tables of your input/output values

* The steps below detail the following:
  * Install the package
  * Set an alias to output markdown for the local directory
  * Validate, format, then add input/output values to your README.md file (Note that you'll need to add the `<!--Start-->` and `<!--End-->` comments)
* Installing on Linux
```bash
# You'll need to have golang installed to build the binary
# Instructions are here: https://github.com/segmentio/terraform-docs
go get github.com/segmentio/terraform-docs

# Add these aliases to your .bash_aliases (or wherever makes sense for you)
alias tfdoc="terraform-docs --sort-inputs-by-required md ."
alias tfgo="terraform validate -check-variables=false && terraform fmt && tfdoc && sed -i -e '/<!--Start-->/,/<!--End-->/{//!d;}' -e '/<!--Start-->/r'<(tfdoc) README.md"
```

* Installing on Mac
```bash
brew install terraform-docs

# Add these aliases to your .bash_profile (or wherever makes sense for you)
alias tfdoc="terraform-docs --sort-inputs-by-required md ."
alias tfgo="terraform validate -check-variables=false && terraform fmt && tfdoc && sed -i '' -e '/<!--Start-->/,/<!--End-->/{//!d;}'  README.md && sed -i '' -e '/<!--Start-->/r'<(tfdoc) README.md"
```
