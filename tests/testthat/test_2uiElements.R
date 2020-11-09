test_that("templater_table() returns a datatable", {
    expect_true("datatables" %in% class(
                                        templater_table(
                                        get_package_templates()
    )))
})

test_that("uiElements are all of class shiny.tag", {
    expect_true("shiny.tag" %in% class(templater_selection()))
    expect_true("shiny.tag" %in% class(templater_input()))
    expect_true("shiny.tag" %in% class(templater_directory(wd = getwd())))
    expect_true("shiny.tag" %in% class(templater_creator()))
})

test_that("templater_ui is of class shiny.tag.list", {
    expect_true("shiny.tag.list" %in% class(templater_ui(wd = getwd())))
})
