#' @title Call templater
#' @description * TODO
#' @examples
#' \dontrun{
#' if(interactive()) {
#'     templater()
#'  }
#' }
#' @export
#' @rdname templater
#' @importFrom shiny reactive observe observeEvent
#' updateCheckboxInput updateTextInput stopApp shinyApp
#' @importFrom DT renderDT
#' @importFrom shinyjs toggleState
#' @importFrom easycsv choose_dir
templater <- function() {
    wd <- if (!is.null(getwd())) getwd() else ""
    ui <- templater_ui(wd)
    shiny::runGadget(
        shiny::shinyApp(
            ui,
            templater_server
        ),
        viewer = shiny::paneViewer(minHeight = "maximize")
    )
}
