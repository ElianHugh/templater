test_that("get_package_templates() functions correctly", {
    rmd <- get_package_templates()
    expect_false(is.null(rmd))
    expect_gte(nrow(rmd), 0)
})

test_that("get_paths() returns file paths", {
    paths <- get_paths(.libPaths(), "*template.yaml")
    expect_false(is.null(paths))
    expect_gte(length(paths), 0)
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

test_that("get_writeable_lib() functions correctly", {
    expect_error(get_writeable_lib(), NA)
})

test_that("use_template() functions correctly", {
    expect_error(use_template())

    loc <- path.expand("~")
    s <- 1
    name <- "document"
    check <- FALSE
    curr_data <- data.frame(
        "Temp" = "basic_word",
        "Package" = "templater"
    )

    expect_error(use_template(loc, s, name, check, curr_data), NA)
    if (fs::file_exists(paste0(loc, "/", name, ".Rmd"))) {
        fs::file_delete(paste0(loc, "/", name, ".Rmd"))
    }

    expect_message(
        use_template(loc, s, name, check, curr_data),
        "templater created document at:"
    )
    if (fs::file_exists(paste0(loc, "/", name, ".Rmd"))) {
        fs::file_delete(paste0(loc, "/", name, ".Rmd"))
    }
})

test_that("create_custom_template() functions correctly", {
    expect_error(create_custom_template())

    input <- NULL
    input$template_name_input <- "Title"
    input$template_desc_input <- "A description"
    input$rmd_input <- "Lorem ipsum"

    expect_error(create_custom_template(input), NA)
})