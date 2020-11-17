#' @title Call templater
#' @description Opens the templater shiny gadget, allowing
#' for template usage and creation.
#' @return NULL
#' @examples
#' \dontrun{
#' if(interactive()) {
#'    templater()
#'  }
#' }
#' @seealso
#'  \code{\link[shiny]{runGadget}},
#'  \code{\link[shiny]{shinyApp}},
#'  \code{\link[shiny]{viewer}}
#' @rdname templater
#' @export
#' @importFrom shiny runGadget shinyApp paneViewer
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
