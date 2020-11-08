test_that("get_package_templates() functions correctly", {
    skip_on_ci()
    rmd <- get_package_templates()
    expect_false(is.null(rmd))
    rmd <- rmd %>%
        dplyr::filter(Package == "templater")
    expect_length(rmd$Package, 0)
})

# * TODO better test
# test_that("get_other_templates() functions correctly", {
#     other <- get_other_templates()
#     message(other)
#     skip_if_not_installed("templater")
#     expect_gt(length(other$Package), 0)

#     other <- other %>%
#         dplyr::filter(Package != "templater")
#     expect_length(other$Package, 0)
# })

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
