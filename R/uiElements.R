
templater_selection <- function() {
    shiny::div(
        DT::DTOutput("table", width = "100%", height = "auto"),
    )
}

templater_input <- function(wd) {
    shiny::div(
        shiny::div(
            style = "margin-top: -15px",
            shiny::p(shiny::strong("Name")),
            shiny::tags$input(
                placeholder = "untitled",
                class = "form-control",
                type = "text",
                pattern = "[(a-zA-Z0-9_ )]*",
                title = "Must be a valid file name.",
                id = "name_input",
        )),
        shiny::div(
            style = "padding-top: 5px",
            shiny::p(shiny::strong("Directory")),
            shiny::splitLayout(
                cellWidths = c("60%", "40%"),
                shiny::textInput(
                    "dir_input",
                    label = NULL,
                    value = wd
                ),
                shiny::actionButton(
                    inputId = "dir_button",
                    label = "Browse",
                    class = "btn btn-secondary"
                )
        ))
    )
}

templater_conf_button <- function() {
    shinyjs::disabled(
        shiny::actionButton(
            inputId = "conf",
            class = "btn btn-success",
            label = "Confirm"
        )
    )
}

templater_gen_button <- function() {
    shinyjs::disabled(
        shiny::actionButton(
            inputId = "gen",
            class = "btn btn-success",
            label = "Generate"
        )
    )
}

templater_canc_button <- function(id) {
    shiny::actionButton(
        inputId = id,
        class = "btn btn-danger",
        label = "Cancel"
    )
}

templater_table <- function(data) {
    DT::datatable(data,
        rownames = FALSE,
        selection = "single",
        extensions = "Scroller",
        options = list(
            headerCallback = DT::JS(
                "function(thead, data, start, end, display) {",
                "  $(thead).remove();",
                "}"
            ),
            rowCallback = DT::JS(
            "function(row, data) {",
            "var full_text = data[1]",
            "$('td', row).attr('title', full_text);",
            "}"),
            scroller = TRUE,
            scrollY = 300,
            scrollCollapse = TRUE,
            dom = "t",
            height = "100%",
            width = "100%",
            columnDefs = list(
                list(
                    visible = FALSE,
                    targets = c(1, 2, 3, 4, 5)
                )
            )
        )
    )
}

templater_creator <- function() {
    shiny::wellPanel(
        shiny::p(shiny::strong("Template Name")),
        shiny::textInput(
            "template_name_input",
            label = NULL,
            placeholder = "untitled"
        ),
        shiny::p(shiny::strong("Template Description")),
        shiny::textAreaInput(
            "template_desc_input",
            label = NULL,
            placeholder = "My custom template.",
            resize = "vertical"
        ),
        shiny::p(shiny::strong("Body")),
        shiny::textAreaInput(
            inputId = "rmd_input",
            label = NULL,
            resize = "vertical"
        )
    )
}
