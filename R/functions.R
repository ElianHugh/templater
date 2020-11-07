
#' @title get package templates
#' @description Find all package templates stored locally on the computer,
#' return a dataframe for later use.
#' @return tibble
#' @examples
#' \dontrun{
#' if(interactive()) {
#'  get_package_templates()
#'  }
#' }
#' @export
#' @rdname get_package_templates
#' @import purrr
#' @import yaml
#' @import tibble
#' @import dplyr
#' @import stringr
get_package_templates <- function() {
    pattern <- "[A-Za-z0-9_ ]+(?=/+rmarkdown)"
    temp_name_pat <- "[A-Za-z0-9_ ]+(?=/+template.yaml)"
    paths <- get_paths(.libPaths(), "*template.yaml")

    # Appeasing R CMD check
    Package <- NULL

    if(!is.null(paths) | length(paths) > 0) {
        temp_frame <- paths %>%
            purrr::map_df(yaml::read_yaml) %>%
            tibble::add_column(paths) %>%
            dplyr::mutate(
                Temp = stats::na.omit(stringr::str_extract(paths, temp_name_pat)),
                Package = dplyr::case_when(
                    stats::na.omit(((stringr::str_extract(paths, pattern)))) == 0 ~ "rmarkdown",
                    TRUE ~ stats::na.omit(((stringr::str_extract(paths, pattern))))
                ),
                PkgDisplay = paste0("{", Package, "}"),
            ) %>%
            dplyr::filter(!grepl("templater", Package))
        return(temp_frame)
    } else {
        NULL
    }
}


#' @title get other templates
#' @description Find all templater templates (including custom templates)
#' stored locally on the computer, and return a dataframe for later use.
#' @return tibble
#' @examples
#' \dontrun{
#' if(interactive()) {
#'  get_other_templates()
#'  }
#' }
#' @export
#' @rdname get_other_templates
#' @import purrr
#' @import yaml
#' @import tibble
#' @import dplyr
#' @import stringr
get_other_templates  <- function() {
    pattern <- "[A-Za-z0-9_ ]+(?=/+rmarkdown)"
    temp_name_pat <- "[A-Za-z0-9_ ]+(?=/+template.yaml)"
    paths <- get_paths(.libPaths(), "*template.yaml")

  # Appeasing R CMD check
  Package <- NULL

  if (!is.null(paths) | length(paths) > 0) {
      temp_frame <- paths %>%
          purrr::map_df(yaml::read_yaml) %>%
          tibble::add_column(paths) %>%
          dplyr::mutate(
              Temp = stats::na.omit(stringr::str_extract(paths, temp_name_pat)),
              Package = dplyr::case_when(
                  stats::na.omit(((stringr::str_extract(paths, pattern)))) == 0 ~ "rmarkdown",
                  TRUE ~ stats::na.omit(((stringr::str_extract(paths, pattern))))
              ),
              PkgDisplay = paste0("{", Package, "}"),
          ) %>%
          dplyr::filter(grepl("templater", Package))
      return(temp_frame)
  } else {
      NULL
  }
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
        template = curr_data()[s, ]$Temp,
        package = curr_data()[s, ]$Package,
        edit = FALSE,
        create_dir = check
    )

    if (fs::file_exists(file_path)) {
        rstudioapi::showDialog(
            title = "Templator",
            "created document."
        )
        rstudioapi::navigateToFile(file_path)
    } else {
        rstudioapi::showDialog(
            title = "Templator",
            "error in document creation.."
        )
    }
}

create_custom_template <- function(input) {
    template_name  <- input$template_name_input
    template_desc <- input$template_desc_input
    templater_path <- fs::dir_ls(
        path = .libPaths(),
        recurse = TRUE,
        type = "directory",
        glob = "*templater/rmarkdown/templates",
        fail = FALSE
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

check_valid  <- function(input, curr_path) {
    if (!is.null(input$table_rows_selected) &&
        !fs::file_access(path = curr_path, mode = "exists") &&
        !grepl(input$name_input, pattern = "[^(a-zA-Z0-9_ ]", perl = TRUE)) {
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
        input$rmd_input != "") {
        return(TRUE)
    } else {
        return(FALSE)
    }
}
