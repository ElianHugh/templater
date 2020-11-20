#' @title Get Package Templates
#' @description Find all package templates stored
#' locally on the computer, return a dataframe for later use.
#' @return data.frame
#' @examples
#' \dontrun{
#' if(interactive()) {
#'  get_package_templates()
#'  }
#' }
#' @seealso
#'  \code{\link[purrr]{map}}
#'  \code{\link[dplyr]{mutate}},
#'  \code{\link[dplyr]{relocate}},
#'  \code{\link[dplyr]{reexports}}
#'  \code{\link[stringr]{str_extract}}
#' @rdname get_package_templates
#' @export
#' @importFrom purrr map_df
#' @importFrom dplyr mutate relocate everything
#' @importFrom stringr str_extract
get_package_templates <- function() {
    pattern <- "[A-Za-z0-9_ ]+(?=/+(rmarkdown(?!.*rmarkdown)))"
    temp_name_pat <- "[A-Za-z0-9_ ]+(?=/+template.yaml)"
    paths <- get_paths(.libPaths(), "*template.yaml")

    # Appeasing R CMD check
    Package <- NULL
    name <- NULL
    description <- NULL

    if (!is.null(paths) | length(paths) > 0) {
        temp_frame <- paths %>%
            purrr::map_df(get_yaml) %>%
            dplyr::mutate(
                Temp = stringr::str_extract(paths, temp_name_pat),
                Package = stringr::str_extract(paths, pattern),
                PkgDisplay = paste0("{", Package, "}"),
            ) %>%
            dplyr::relocate(
                name,
                description,
                dplyr::everything()
            )
        return(temp_frame)
    } else {
        NULL
    }
}

get_yaml <- function(path) {
    x <- yaml::read_yaml(path)
    if (is.null(x)) {
        x$name <- "FAULTY YAML"
        x$description <- "FAULTY YAML"
    }
    x$path <- path
    return(x)
}

get_paths <- function(vec, glob) {
    paths <- fs::dir_ls(
        path = vec,
        recurse = TRUE,
        type = "file",
        glob = glob,
        fail = FALSE
    )
    return(unlist(paths))
}


use_template  <- function(loc, s, name, check, curr_data) {
    conc_path <- paste0(
        loc,
        "/",
        name,
        ".Rmd"
    )

    file_path <- rmarkdown::draft(
        file = conc_path,
        template = curr_data[s, ]$Temp,
        package = curr_data[s, ]$Package,
        edit = FALSE,
        create_dir = check
    )

    # Ensure function works without rstudioapi
    if (isNamespaceLoaded("rstudioapi") && rstudioapi::isAvailable()) {
        if (fs::file_exists(file_path)) {
            rstudioapi::showDialog(
                title = "Templater",
                paste0("created document at: ", file_path)
            )
            rstudioapi::navigateToFile(file_path)
        } else {
            rstudioapi::showDialog(
                title = "Templater",
                "error in document creation..."
            )
        }
    } else {
        if (fs::file_exists(file_path)) {
            message("templater created document at: ", file_path)
        } else {
            message("templater: error in document creation...")
        }
    }
}

#' @title Create a template
#' @description Create a user-defined template, saved in the
#' templater package folder.
#' @param input
#' input$template_name_input (template name)
#' input$template_desc_input (template description)
#' input$rmd_input (template body)
#' @return NULL
#' @examples
#' \dontrun{
#' if(interactive()) {
#'  input <- NULL
#'  input$template_name_input <- "Title"
#'  input$template_desc_input <- "A description"
#'  input$rmd_input <- "Lorem ipsum"
#'  create_custom_template(input)
#'  }
#' }
#' @seealso
#'  \code{\link[fs]{create}},
#'  \code{\link[fs]{file_access}}
#'  \code{\link[rstudioapi]{isAvailable}},
#'  \code{\link[rstudioapi]{showDialog}}
#' @rdname create_custom_template
#' @export
#' @importFrom fs dir_create file_create file_exists
create_custom_template <- function(input) {
    template_name  <- input$template_name_input
    template_desc <- input$template_desc_input
    templater_path <- paste0(
        get_writeable_lib(),
        "/templater/rmarkdown/templates"
    )
    temp_yaml_lines <- sprintf(
        "name: %s\ndescription: >\n  %s\ncreate_dir: false",
        template_name,
        template_desc
    )
    temp_skel_lines <- input$rmd_input

    # Create directories and files
    skeleton_path <- fs::dir_create(path = paste0(
        templater_path,
        "/",
        template_name,
        "/skeleton"
    ))
    skeleton_file <- fs::file_create(paste0(
        skeleton_path,
        "/",
        "skeleton.Rmd"
    ))
    yaml_file <- fs::file_create(path = paste0(
        templater_path,
        "/",
        template_name,
        "/template.yaml"
    ))

    # Write lines
    writeLines(temp_skel_lines, skeleton_file)
    writeLines(temp_yaml_lines, yaml_file)

    # Utilise rstudioapi if loaded
    if (isNamespaceLoaded("rstudioapi") && rstudioapi::isAvailable()) {
        if (fs::file_exists(skeleton_file)) {
            rstudioapi::showDialog(
                title = "Templator",
                "created template"
            )
        } else {
            rstudioapi::showDialog(
                title = "Templator",
                "there was an error during template creation."
            )
        }
    } else {
         if (fs::file_exists(skeleton_file)) {
            message("Templater: created template")
         } else {
             message("Templater: there was an error during template creation.")
         }
    }

}

get_writeable_lib <- function() {
    lib <- .libPaths()
    writeable <- fs::file_access(lib, mode = "write")
    return(names(which(writeable == TRUE)[1]))
}

# * TODO make use of reactivity to
# refactor this
check_valid  <- function(input, curr_path, name_valid) {
    if (!is.null(input$table_rows_selected) &&
        !fs::file_access(path = curr_path, mode = "exists") &&
            name_valid) {
            return(TRUE)
    } else {
            return(FALSE)
    }
}

check_input <- function(input) {
    if (is.null(input$template_name_input) |
        is.null(input$template_desc_input) |
        is.null(input$rmd_input)) {
        return(FALSE)
    } else if (input$template_name_input != "" &&
        input$template_desc_input != "" &&
        input$rmd_input != "" &&
        !grepl(input$template_name_input,
            pattern = "[^(a-zA-Z0-9_ ]",
            perl = TRUE
        )) {
        return(TRUE)
    } else {
        return(FALSE)
    }
}
