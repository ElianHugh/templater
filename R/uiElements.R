
templater_selection <- function() {
    shiny::div(
        DT::DTOutput("table"),
    )
}

templater_input <- function() {
     shiny::div(
         style = "width: 80%",
         shiny::p(shiny::strong("Name")),
         shiny::tags$input(
             placeholder = "untitled",
             class = "form-control",
             type = "text",
             pattern = "[(a-zA-Z0-9_ )]*",
             title = "Must be a valid file name.",
             id = "name_input",
         )
     )
}

# * TODO change flex sizes for elements
templater_directory <- function(wd) {
shiny::div(
    shiny::p(shiny::strong("Directory")),
        shiny::fillRow(
            flex = c(5, 4, 3),
            shiny::textInput(
                "dir_input",
                label = NULL,
                value = wd
            ),
            shiny::actionButton(
                inputId = "dir_button",
                label = "Browse",
                class = "btn btn-secondary"
            ),
            shiny::checkboxInput(
                inputId = "check_input",
                label = "New Directory"
            )
        )

)
}

# * TODO change table width
templater_table <- function(data) {
    DT::datatable(data,
        rownames = FALSE,
        selection = "single",
        extensions = "Buttons",
        options = list(
            headerCallback = DT::JS(
                "function(thead, data, start, end, display) {",
                "  $(thead).remove();",
                "}"
            ),
            rowCallback = DT::JS(
            "function(row, data) {",
            "var full_text = data[2]",
            "$('td', row).attr('title', full_text);",
            "}"),
            scrollY = "40vh",
            scrollCollapse = TRUE,
            dom = "Bft",
            buttons = list(
                 list(
                     extend = "collection",
                     text = "Packages",
                     action = DT::JS("function ( e, dt, node, config ) {
                                      Shiny.setInputValue('test', true, {priority: 'event'});
                                   }")
                 ),
                 list(
                     extend = "collection",
                     text = "Other",
                     action = DT::JS("function ( e, dt, node, config ) {
                                      Shiny.setInputValue('test', true, {priority: 'event'});
                                   }")
                 )
              ),
            paging = FALSE,
            language = list(
                search = "",
                searchPlaceholder = "Search"
            ),
            searchDelay = 0,
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
    shiny::div(
        class = "templateDetails",
        shiny::p(shiny::strong("Template Name")),
        shiny::tags$input(
                placeholder = "untitled",
                class = "form-control",
                type = "text",
                pattern = "[(a-zA-Z0-9_ )]*",
                title = "Must be a valid file name.",
                id = "template_name_input",
        ),
        shiny::p(shiny::strong("Template Description")),
        shiny::textAreaInput(
            "template_desc_input",
            label = NULL,
            placeholder = "My custom template.",
            resize = "vertical",
            width = "100%"
        ),
        shiny::p(shiny::strong("Body")),
        shiny::textAreaInput(
            inputId = "rmd_input",
            label = NULL,
            resize = "vertical",
            width = "100%"
        )
    )
}
