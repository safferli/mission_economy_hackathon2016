library(shiny)
library(shinydashboard)

body_layout <- list(
  #div(class="container", style="width: 80%",
  column(width = 8, offset = 2,
    fluidRow(
      h1("Build Your Own Offshore Corporation")
    ),
    fluidRow(
      uiOutput("panel_one")
    ),
    fluidRow(
      uiOutput("panel_two")
    ),
    fluidRow(
      uiOutput("panel_three")
    ),
    actionButton("next_button", label = "Next >>")
  )
)

dashboardPage(
  dashboardHeader(title = "Mission:Economy Hackathon"),
  dashboardSidebar(disable = TRUE),
  dashboardBody(body_layout)
)
