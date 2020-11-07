
<!-- badges: start -->

[![Build](https://travis-ci.com/ElianHugh/templater.svg?token=gH35B76qsVbgqgsMRb83&branch=master)](https://travis-ci.com/ElianHugh/templater)
[![R-CMD-Check](https://github.com/ElianHugh/templater/workflows/R-CMD-check/badge.svg)](https://github.com/ElianHugh/templater/actions)
<!-- badges: end -->

# templater

*{templater}* is an attempt to bring rmarkdown template usage to
[VSCode-R](https://github.com/Ikuyadeu/vscode-R). *{templater}* scans
your installed packages for templates that can be used to create
rmarkdown files. *{templater}* also comes with some basic templates that
can be used to quickly get started on a project, without having to deal
with all the extra bells and whistles that come with complicated
templates. *{templater}* also allows for the creation of user-templates,
which are stored alongside the package’s templates.

*{templater}* is unlikely to be useful for those using RStudio, but I
hope that it might find some use amongst vscode users.

# Installation

Install with:

``` r
remotes::install_github("ElianHugh/templater")
```

# Opening Templater

*{templater}* can be called by first loading it into your r session and
then running its shiny app

``` r
library(templater)
templater()
```

Alternatively, you can call *{templater}* through the addin interface.

# Template Usage

Templates can be found under the “Use Templates” tab, with a choice
between package templates (i.e. templates derived from installed
packages) and *{templater}* templates (including any custom templates).

Once you have selected a template, input a file name and choose where to
save the file. Clicking confirm will close templater and open up the new
rmarkdown file.

# Template Creation

You can also use *{templater}* to create templates for later use.
Navigate to the “Create Templates” tab, and type in your new template’s
name, description, and body.

The body contains *both* the YAML header and rmarkdown body. When
writing the body, make sure you include the YAML header first.
