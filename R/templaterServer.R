templater_server <- function(input, output, session) {
    curr_data <- get_package_templates()

    # Error Messages
    if (interactive()) {
        shiny::req(curr_data)
        if ("Faulty_YAML" %in% unlist(curr_data)) {
            packages <- toString(
                unique(
                    curr_data[curr_data$faulty == TRUE, ]$Package
                )
            )
            paths  <- toString(curr_data[curr_data$faulty == TRUE, ]$path)
            if (isNamespaceLoaded("rstudioapi") && rstudioapi::isAvailable()) {
                rstudioapi::showDialog(
                    title = "Templater",
                    message = packages,
                    url = paths
                )
            } else {
                message(paste0(
                    "Faulty YAML detected in package/s: ",
                    packages,
                    "\n",
                    paths
                ))
            }
        }
    }

    # Reactive Variables
    curr_path <- shiny::reactive({
        loc <- input$dir_input
        name <- input$name_input
        check <- input$check_input
        if (check == TRUE) {
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

    # Ensure that the text input is a valid name
    # i.e. no invalid characters
    validate_name <- shiny::reactive({
        shiny::req(input$name_input)
        if (!grepl(
            input$name_input,
            pattern = "[^(a-zA-Z0-9_ ]",
            perl = TRUE
        )) {
            return(TRUE)
        } else {
            return(FALSE)
        }
    })

    # Ensure that the current path is not occupied
    validate_path  <- shiny::reactive({
        shiny::req(input$name_input, curr_path())
        if (!fs::file_access(path = curr_path(), mode = "exists")) {
            return(TRUE)
        } else {
            return(FALSE)
        }
    })

    # Ensure name and path are valid
    validate_input <- shiny::reactive({
        shiny::req(input$table_rows_selected)
        if (validate_name() && validate_path()) {
            return(TRUE)
        } else {
            return(FALSE)
        }
    })

    # Ensure custom template name is a valid name
    validate_custom_input <- shiny::reactive({
        shiny::req(
            input$template_name_input,
            input$template_desc_input,
            input$rmd_input
        )
        if (!grepl(input$template_name_input,
            pattern = "[^(a-zA-Z0-9_ ]",
            perl = TRUE
        )
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
        shiny::req(input$nav)
        if (input$nav != "Create Templates") {
            if (validate_input()) {
                shinyjs::enable(id = "done")
            } else {
                shinyjs::disable(id = "done")
            }
        } else {
            if (validate_custom_input()) {
                shinyjs::enable(id = "done")
            } else {
                shinyjs::disable(id = "done")
            }
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

    # Confirm
    shiny::observeEvent(input$done, {
        shiny::req(input$nav)
        if (input$nav != "Create Templates") {
            if (validate_input() == TRUE) {
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
            shiny::req(
                input$template_name_input,
                input$template_desc_input,
                input$rmd_input
            )
            create_custom_template(input)
            shiny::stopApp(returnValue = invisible())
        }
    })

    shiny::observe({
        shiny::req(input$dir_input)
        shinyjs::toggleCssClass(
            id = "dir_input",
            class = "invalid",
            condition = validate_path()
        )
    })

    # Exit Handle
    ## Auto-kill app '
    # (ensures app doesn't continue running)
    session$onSessionEnded(shiny::stopApp)
}