templater_ui <- function(wd) {
    miniUI::miniPage(
        if (fs::file_exists("www/styles.css")) {
            shiny::includeCSS("www/styles.css")
        },
        # Include JS
        shinyjs::useShinyjs(),
        if (fs::file_exists("www/app.js")) {
            shiny::includeScript(path = "www/app.js")
        },
        miniUI::gadgetTitleBar("templater::"),
        miniUI::miniTabstripPanel(
            id = "nav",
            miniUI::miniTabPanel("Markdown Templates",
                icon = shiny::icon("file-alt"),
                miniUI::miniContentPanel(

                        templater_selection(),
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
            miniUI::miniTabPanel("Other Templates",
                icon = shiny::icon("tape")
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