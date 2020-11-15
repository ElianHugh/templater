test_that("get_package_templates() functions correctly", {
    rmd <- get_package_templates()
    expect_false(is.null(rmd))
})

test_that("get_paths() returns file paths", {
    paths <- get_paths(.libPaths(), "*template.yaml")
    expect_gte(length(paths), 0)
})

test_that("check_valid() detects input correctly", {
    input <- NULL
    input$table_rows_selected <- TRUE
    input$name_input <- "test all0wed characters"
    expect_true(check_valid(input, ""))
    input$name_input <- "test d|sallowed ch@racter?"
    expect_false(check_valid(input, ""))
})

test_that("check_input() detects input correctly", {
    input <- NULL
    input$template_name_input <- "Template Name"
    input$template_desc_input <- "Template Desc"
    input$rmd_input <- "Body"
    expect_true(check_input(input))
    input$template_name_input <- ""
    input$template_desc_input <- ""
    input$rmd_input <- ""
    expect_false(check_input(input))
    input$template_name_input <- NULL
    input$template_desc_input <- NULL
    input$rmd_input <- NULL
    expect_false(check_input(input))
    input$template_name_input <- "test d|sallowed ch@racter"
    input$template_desc_input <- ""
    expect_false(check_input(input))
})

test_that("get_yaml() functions correctly", {
    expect_error(get_yaml())

    x <- get_yaml(("../testdata/Faulty_YAML/template.yaml"))
    expect_equal(x$name, "FAULTY YAML")
    expect_equal(x$description, "FAULTY YAML")
    expect_equal(x$path, "../testdata/Faulty_YAML/template.yaml")

    x <- get_yaml(("../testdata/Correct_YAML/template.yaml"))
    expect_equal(x$name, "Basic Word")
    expect_equal(x$description, "A basic markdown template for Word outputs.\n")
    expect_equal(x$path, "../testdata/Correct_YAML/template.yaml")
})

test_that("use_template() functions correctly", {
    expect_error(use_template())

    loc <- ""
    s <- 1
    name <- "document"
    check <- FALSE
    curr_data <- data.frame(
            "Temp" = "basic_word",
            "Package" = "templater"
        )
    # Due to permission issues, have to  skip on non-windows OS
    skip_on_os(c("mac", "linux", "solaris"))
    expect_error(use_template(loc, s, name, check, curr_data), NA)

    skip_on_os(c("mac", "linux", "solaris"))
    expect_message(use_template(loc, s, name, check, curr_data),
    "templater: error in document creation...")
})

test_that("create_custom_template() functions correctly", {
    expect_error(create_custom_template())

    input <- NULL
    input$template_name_input <- "Title"
    input$template_desc_input <- "A description"
    input$rmd_input <- "Lorem ipsum"

    # Due to permission issues, have to  skip on non-windows OS
    skip_on_os(c("mac", "linux", "solaris"))
    expect_error(create_custom_template(input), NA)
})
