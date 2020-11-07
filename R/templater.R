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

    server <- function(input, output, session) {
            rmd   <- get_package_templates()
            other <- get_other_templates()

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

            ## Reactive confirm
            shiny::observe({
                shinyjs::toggleState("conf", check_valid(input, curr_path()))
            })

            ## Reactive Generate
            shiny::observe({
                shinyjs::toggleState("gen", check_input(input))
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
            shiny::observeEvent(input$gen, {
                    create_custom_template(input)
                    shiny::stopApp(returnValue = invisible())

            })

            ## Confirm
            shiny::observeEvent(input$conf, {
                    use_template(
                        loc   = input$dir_input,
                        s     = input$table_rows_selected,
                        name  = input$name_input,
                        check = input$check_input,
                        curr_data
                    )
                    shiny::stopApp(returnValue = invisible())
            })

            ## Close App
            shiny::observeEvent(input$can | input$can2, {
                shiny::stopApp(returnValue = invisible())
            }, ignoreInit = TRUE)

            # Exit Handle
            ## Auto-kill app
            session$onSessionEnded(shiny::stopApp)
    }

    shiny::shinyApp(ui, server)
}
