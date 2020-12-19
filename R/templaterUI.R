templater_ui <- function(input, output, session) {
    htmltools::tagList(
        shinyjs::useShinyjs(),
        miniUI::miniPage(
            htmltools::singleton(x = htmltools::tagList(
                htmltools::tags$link(
                    rel = "stylesheet",
                    type = "text/css",
                    href = "templater/styles.css"
                ),
                htmltools::tags$script(src = "templater/resize-area.js")
            )),
            miniUI::gadgetTitleBar("templater::",
                right = shinyjs::disabled(miniUI::miniTitleBarButton(
                    inputId = "done",
                    label = "Done",
                    primary = TRUE
                )
            )),
            miniUI::miniTabstripPanel(
                id = "nav",
                miniUI::miniTabPanel("Markdown Templates",
                    icon = shiny::icon("file-alt"),
                    miniUI::miniContentPanel(
                        templater_selection()
                    ),
                    miniUI::miniContentPanel(
                        shiny::fillCol(
                            height = "30vh",
                            shiny::fillCol(
                                class = "templateDetails",
                                width = "100%",
                                height = "100%",
                                templater_input(),
                                templater_directory(
                                    if (!is.null(getwd())) getwd() else ""
                                )
                            )
                        )
                    )
                ),
                miniUI::miniTabPanel("Create Templates",
                    icon = shiny::icon("edit"),
                    miniUI::miniContentPanel(
                        style = "overflow-y: auto;",
                        templater_creator()
                    )
                )
            )
        )
    )
}
