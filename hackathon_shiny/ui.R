library(shiny)
library(shinydashboard)

body_layout <- list(
  div(class="container",
    fluidRow(
      h1("Build Your Own Offshore Corporation")
    )
  )
)

dashboardPage(
  dashboardHeader(title = "Mission:Economy Hackathon"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(body_layout)
)
