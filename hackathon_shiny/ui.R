library(shiny)
library(shinydashboard)

body_layout <- list(
  div(class="container",
    fluidRow(
      h1("Build Your Own Offshore Corporation")
    ),
    uiOutput("panel_one"),
    uiOutput("panel_two"),
    uiOutput("panel_three"),
    actionButton("next_button", label = "Next >>")
  )
)

dashboardPage(
  dashboardHeader(title = "Mission:Economy Hackathon"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(body_layout)
)
