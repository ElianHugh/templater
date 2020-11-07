templater_ui  <- function(wd) {
    shiny::fluidPage(
        theme = shinythemes::shinytheme("darkly"),
        shinyjs::useShinyjs(),
        if (fs::file_exists("www/styles.css"))
        shiny::includeCSS("www/styles.css"),
        if (fs::file_exists("www/app.js"))
        shiny::includeScript(path = "www/app.js"),
        shiny::navbarPage(
            "templater::",
            id = "nav",
            shiny::navbarMenu(
                title = "Use Templates",
                shiny::tabPanel("Package Templates"),
                shiny::tabPanel("Other Templates")
            ),
            shiny::tabPanel(
                "Create Templates",
                shiny::wellPanel(
                    shiny::wellPanel(
                        templater_creator(),
                        shiny::fluidRow(
                            style = "float:right",
                            templater_canc_button("can2"),
                            templater_gen_button()
                        )
                    )
                )
            )
        ),
        shiny::conditionalPanel(
            condition = "input.nav != 'Create Templates'",
            shiny::div(
                shiny::wellPanel(
                    shiny::h4("Templates:"),
                    shiny::wellPanel(templater_selection()),
                    shiny::wellPanel(
                        templater_input(wd),
                        shiny::checkboxInput(
            inputId = "check_input",
            label = "Create in New Directory"
        ),
                        shiny::div(
                            style = "float:right",
                            templater_canc_button("can"),
                            templater_conf_button()
                        )
                    )
                )
            )
        )
    )
}
