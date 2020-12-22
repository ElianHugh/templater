test_that("curr_path reactivity is functioning", {
    shiny::testServer(templater_server, {
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
    })
})

test_that("validate_custom_input() reactivity is functioning", {
    shiny::testServer(templater_server, {
        session$setInputs(
            template_name_input = "Test",
            template_desc_input = "Description",
            rmd_input = "Lorem ipsum"
        )
        expect_true(validate_custom_input())

        session$setInputs(template_name_input = "Test%")
        expect_false(validate_custom_input())

        session$setInputs(template_name_input = NULL)
        expect_error(validate_custom_input())
    })
})

test_that("validate_input true reactivity is functioning (1/2)", {
    if (fs::file_exists("~/foo.Rmd")) {
        fs::file_delete("~/foo.Rmd")
    }
    if (fs::file_exists("~/bar/bar.Rmd")) {
        fs::file_delete("~/bar/bar.Rmd")
    }

    shiny::testServer(templater_server, {
        session$setInputs(
            dir_input = "~",
            name_input = "foo",
            check_input = FALSE
        )
        expect_error(validate_input())

        session$setInputs(
            table_rows_selected = 1
        )
        expect_true(validate_input())

        session$setInputs(
            dir_input = "~",
            name_input = "foo",
            check_input = TRUE
        )
        expect_true(validate_input())
    })
})

test_that("validate_input false reactivity is functioning (2/2)", {
    if (!fs::file_exists("~/foo.Rmd")) {
        fs::file_create("~/foo.Rmd")
    }
    if (!fs::file_exists("~/bar/bar.Rmd")) {
        fs::dir_create("~/bar/")
        fs::file_create("~/bar/bar.Rmd")
    }
    shiny::testServer(templater_server, {
        session$setInputs(
            dir_input = "~",
            name_input = "foo",
            check_input = FALSE
        )
        expect_error(validate_input())

        session$setInputs(
            table_rows_selected = 1
        )
        expect_false(validate_input())
        session$setInputs(
            dir_input = "~",
            name_input = "bar",
            check_input = TRUE
        )
    })
})

test_that("validate_name reactivity is functioning", {
    shiny::testServer(templater_server, {
        session$setInputs(name_input = "")
        expect_error(validate_name())

        session$setInputs(name_input = "$%#test")
        expect_false(validate_name())

        session$setInputs(name_input = "Valid")
        expect_true(validate_name())
    })
})
