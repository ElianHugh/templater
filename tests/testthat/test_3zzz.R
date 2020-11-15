test_that(".onLoad is adding assets to the resource path", {
    # Check that .onLoad() worked
    expect_true(any(grepl("assets", shiny::resourcePaths())))
    # Check that defining the resource path is working
    expect_error(shiny::addResourcePath(
        "templater",
        system.file(
            "assets",
            package = "templater"
        )
    ), NA)
})
