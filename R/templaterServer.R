templater_server <- function(input, output, session) {

    curr_data <- get_package_templates()

    # Error Messages
    if ("Faulty_YAML" %in% unlist(curr_data)) {
        shiny::showNotification(
            paste0("Faulty YAML detected in package/s:\n",
            toString( curr_data[curr_data$name == "FAULTY YAML", ]$Package)),
            duration = 6,
            type = "warning"
        )
    }

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

    name_valid <- shiny::reactive({
        shiny::req(input$name_input)
         if (!grepl(
                input$name_input,
                pattern = "[^(a-zA-Z0-9_ ]",
                perl = TRUE)) {
            return(TRUE)
        } else {
            return(FALSE)
        }
    })

    check_valid  <- shiny::reactive({
        shiny::req(input$table_rows_selected)
        if (name_valid() &&
            !fs::file_access(path = curr_path(), mode = "exists")) {
            return(TRUE)
        } else {
            return(FALSE)
        }
    })

    check_input  <- shiny::reactive({
        shiny::req(
            input$template_name_input,
            input$template_desc_input,
            input$rmd_input
        )
        if (!grepl(input$template_name_input,
              pattern = "[^(a-zA-Z0-9_ ]",
              perl = TRUE)
              ) {
              return(TRUE)
          } else {
              return(FALSE)
          }
    })

    ## Template list
    output$table <- DT::renderDT({
        templater_table(shiny::req(curr_data))
    })

    ## Reactive confirm
    shiny::observe({
        if (input$nav != "Create Templates") {
            if (check_valid()) {
                shinyjs::enable(id = "done")
            } else {
                shinyjs::disable(id = "done")
            }
        } else if (check_input()) {
            shinyjs::enable(id = "done")
    }})

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
              if (check_valid() == TRUE) {
                  use_template(
                      loc   = input$dir_input,
                      s     = input$table_rows_selected,
                      name  = input$name_input,
                      check = input$check_input,
                      curr_data
                  )
                  shiny::stopApp(returnValue = invisible())
              } else {
                  message(
                      "\nThere was an error during document creation.
                      \nAll parameters must be used."
                  )
              }
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
