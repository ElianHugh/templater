templater_ui <- function(wd) {
    miniUI::miniPage(
        # * TODO check why css isn't being applied
        if (fs::file_exists("www/styles.css"))
        shiny::includeCSS("www/styles.css"),
        # Include JS
        shinyjs::useShinyjs(),
        if (fs::file_exists("www/app.js"))
        shiny::includeScript(path = "www/app.js"),
        miniUI::gadgetTitleBar("templater::"),
        shiny::conditionalPanel(
            condition = "input.nav != 'Create Templates'",
                shiny::fillCol(
                    width = "100%",
                    height = "50%",
                    #flex = c(2,3),
                    style = "justify-content: center; align-items: center;
                    padding-left: 20px;
                    padding-top: 10px;
                    background: #f5f5f5;",
                    templater_input(),
                    templater_directory(wd)
                ),
                templater_selection()
            ),

        miniUI::miniTabstripPanel(
            id = "nav",
            miniUI::miniTabPanel("Package Templates",
                icon = shiny::icon("box-open"),
                miniUI::miniContentPanel()
            ),
            miniUI::miniTabPanel("Other Templates",
                icon = shiny::icon("tape"),
                miniUI::miniContentPanel()
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