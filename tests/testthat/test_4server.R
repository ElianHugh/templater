test_that("check curr_path reactivity", {
    shiny::testServer(
        app = shiny::shinyApp(
            ui <- templater_ui(getwd()),
            templater_server
        ), {
            session$setInputs(
                dir_input = "folder",
                name_input = "document",
                check_input = TRUE
            )
            expect_equal("folder/document/document.Rmd", curr_path())

            session$setInputs(
                dir_input = "folder",
                name_input = "document",
                check_input = FALSE
            )
            expect_equal("folder/document.Rmd", curr_path())
        }
    )
})

test_that("check check_input reactivity", {
    shiny::testServer(
        app = shiny::shinyApp(
            ui <- templater_ui(getwd()),
            templater_server
        ), {
            session$setInputs(
                template_name_input = "Test",
                template_desc_input = "Description",
                rmd_input = "Lorem ipsum"
            )
            expect_true(check_input(input))
            session$setInputs(template_name_input = NULL)
            expect_false(check_input(input))
        }
    )
})

test_that("check check_valid reactivity", {
    shiny::testServer(
        app = shiny::shinyApp(
            ui <- templater_ui(getwd()),
            templater_server
        ), {
            session$setInputs(
                dir_input = "folder",
                name_input = "document",
                check_input = TRUE
            )
            expect_false(check_valid(input, curr_path()))
        }
    )
})
