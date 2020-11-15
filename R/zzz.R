.onLoad <- function(...) {
    shiny::addResourcePath(
        "templater",
        system.file(
            "assets",
            package = "templater"
        )
    )
}
