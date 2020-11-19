templater_server <- function(input, output, session) {
    curr_data <- get_package_templates()
    # Reactive Variables
    curr_path <- shiny::reactive({
        loc <- input$dir_input
        name <- input$name_input
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

    ## Template list
    output$table <- DT::renderDT({
        templater_table(curr_data)
    })

    # * TODO does not appear to function with gadget title bar
    ## Reactive confirm
    shiny::observe({
        if (input$nav != "Create Templates" &&
        check_valid(input, curr_path())) {
                shinyjs::enable(id = "done")
        } else if (check_input(input)) {
                shinyjs::enable(id = "done")
        } else {
            shinyjs::disable(id = "done")
        }
    })

    ## Tick Event
    shiny::observeEvent(input$table_rows_selected, {
        s <- input$table_rows_selected
        if (!is.na(curr_data[s, ]$create_dir) ||
            !is.null(curr_data[s, ]$create_dir)) {
            shiny::updateCheckboxInput(
                session,
                inputId = "check_input",
                value   = curr_data[s, ]$create_dir
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
