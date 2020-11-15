test_that(".onLoad is adding assets to the resource path", {
    expect_true(any(grepl("assets", shiny::resourcePaths())))
})
