# test_that("server reactivity functions correctly", {
#     wd <- if (!is.null(getwd())) getwd() else ""
#     ui <- templater_ui(wd)
#     app <- shinyApp(ui, templater_server)
#     shiny::testServer(app, {
#            print(session)
#            expect_equal(1, 1)
#     })
# })
