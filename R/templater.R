#' @title Call templater
#' @description * TODO
#' @examples
#' \dontrun{
#' if(interactive()) {
#'     templater()
#'  }
#' }
#' @export
#' @rdname templater
#' @importFrom shiny reactive observe observeEvent
#' updateCheckboxInput updateTextInput stopApp shinyApp
#' @importFrom DT renderDT
#' @importFrom shinyjs toggleState
#' @importFrom easycsv choose_dir
templater <- function() {
    wd <- if(!is.null(getwd())) getwd() else ""
    ui <- templater_ui(wd)
            rmd   <- get_package_templates()
            other <- get_other_templates()

    server <- function(input, output, session) {

            # Reactive Variables
            curr_path <- shiny::reactive({
                loc   <- input$dir_input
                name  <- input$name_input
                check <- input$check_input
                if (check) {
                    path <- paste0(
                        loc,
                        "/",
                        name,
                        "/",
                        name,
                        ".Rmd"
                    )
                } else {
                    path <- paste0(
                        loc,
                        "/",
                        name,
                        ".Rmd"
                    )
                }
                return(path)
            })

            curr_data <- shiny::reactive({
                if (input$nav == "Package Templates") {
                    data <- rmd
                } else {
                    data <- other
                }
                data
            })

            ## Template list
            output$table <- DT::renderDT({
                templater_table(curr_data())
            })

            # * TODO correct the logic here
            ## Reactive confirm
            shiny::observe({
                if(input$nav != "Create Templates") {
                shinyjs::toggleState("done", check_valid(input, curr_path()))
                } else {
                shinyjs::toggleState("done", check_input(input))
                }
            })

            ## Tick Event
            shiny::observeEvent(input$table_rows_selected, {
                s <- input$table_rows_selected
                if (!is.na(curr_data()[s, ]$create_dir) ||
                !is.null(curr_data()[s, ]$create_dir)) {
                    shiny::updateCheckboxInput(
                        session,
                        inputId = "check_input",
                        value   = curr_data()[s, ]$create_dir
                    )
                }
            })

            # User Input
            ## File dialog
            shiny::observeEvent(input$dir_button, {
                dir_path <- easycsv::choose_dir()
                shiny::updateTextInput(
                    session,
                    inputId = "dir_input",
                    value   = dir_path
                )
            })

            ## Confirm
            shiny::observeEvent(input$done, {
                if (input$nav != "Create Templates") {
                    use_template(
                        loc   = input$dir_input,
                        s     = input$table_rows_selected,
                        name  = input$name_input,
                        check = input$check_input,
                        curr_data
                    )
                    shiny::stopApp(returnValue = invisible())
                } else {
                    create_custom_template(input)
                    shiny::stopApp(returnValue = invisible())
                }
            })

            # Exit Handle
            ## Auto-kill app '
            # (ensures app doesn't continue running)
            session$onSessionEnded(shiny::stopApp)
    }

    shiny::runGadget(shiny::shinyApp(ui, server))
}
