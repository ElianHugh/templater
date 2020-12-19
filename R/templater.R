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
    shiny::runGadget(
        shiny::shinyApp(
            templater_ui,
            templater_server
        ),
        viewer = if("tools:vscode" %in% search() == TRUE) {
                shiny::paneViewer("R Templater")
            } else {
                # Min Height only works in RStudio
                shiny::paneViewer(minHeight = "maximize")
            }
    )
}
