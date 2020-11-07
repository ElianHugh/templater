
<!-- badges: start -->

[![R build
status](https://github.com/ElianHugh/templater/workflows/R-CMD-check/badge.svg)](https://github.com/ElianHugh/templater/actions)
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

    remotes::install_github("ElianHugh/templater")

# Usage

## Calling Templater

*{templater}* can be called by first loading it into your r session and
then running its shiny app

    library(templater)
    templater()

Alternatively, you can call *{templater}* through the addin interface.
