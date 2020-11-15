templater_ui <- function(wd) {
    miniUI::miniPage(
        htmltools::singleton(x = htmltools::tagList(
            htmltools::tags$link(
                rel = "stylesheet",
                type = "text/css",
                href = "templater/styles.css"
            ),
            htmltools::tags$script(src = "templater/app.js")
        )),
        miniUI::gadgetTitleBar("templater::",
        right = miniUI::miniTitleBarButton(
            inputId = "done",
            "Done",
            primary = TRUE)),
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
                            templater_directory(wd)
                        )
                    )
                )
            ),
            miniUI::miniTabPanel("Create Templates",
                icon = shiny::icon("edit"),
                miniUI::miniContentPanel(
                    templater_creator()
                )
            )
        )
    )
}
