#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  # Panel steps
  # Name Panel
  output$panel_one <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '-1' & input.next_button <= '2'",
      box(
        title = "Generate your corporation's name:",
        solidHeader = TRUE,
        renderText({
          paste0("The following name was generated randomly using some of the most common words used in ",
                 "the names of actual offshore corporations.")
        }),
        h2(textOutput("corp_name")),
        actionButton("refresh_name", label = "Refresh"),
        width = 12
      )
    )
  })
  output$corp_name <- renderText({get_new_corp_name()})
  get_new_corp_name <- reactive({
    input$refresh_name
    f.generate_random_name(3)
  })
  
  output$panel_two <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '0' & input.next_button <= '2'",
      box(
        title = "Locate your local intermediary:",
        solidHeader = TRUE,
        renderText({
          paste0("The intermediary acts as a middle-man for you and the offshore service provider and is able ",
                 "to purchase, on your behalf, one or several corporations. In the case of the Panama Papers, ",
                 "Mossack Fonseca was the largest supplier of these corporations.")
        }),
        selectInput("country_select", label = "Originating Country:", selected = "",
                    choices = c("", sort(unique(as.character(intermed_countries$ent_countries))))),
        conditionalPanel(
          condition = "input.country_select != ''",
          DT::dataTableOutput("intermediary_table"),
          conditionalPanel(
            condition = "input.intermediary_table_row_last_clicked >= '1'",
            renderText({
              paste0("You've chosen to enlist the services of ",
                     f.get_intermediaries(country = input$country_select, 5)$Intermediary[as.integer(input$intermediary_table_row_last_clicked)],
                     ". He/She has facilitated the creation of at least ",
                     f.get_intermediaries(country = input$country_select, 5)$CorpsSetupPreviously[as.integer(input$intermediary_table_row_last_clicked)],
                     " offshore corporations.")
            })
          )
        ),
        width = 12
      )
    )
  })
  output$intermediary_table <- DT::renderDataTable({
    DT::datatable(f.get_intermediaries(country = input$country_select, 5), selection = "single", escape = FALSE,
                  options = list(paging = FALSE, searching = FALSE))
  })
  
  output$panel_three <- renderUI({
    pictures <<- f.get_pictures(3)
    conditionalPanel(
      condition = "input.next_button > '1' & input.next_button <= '2'",
      box(title = "Choose your corporation's jurisdiction:",
          renderText({
            paste0("Typically a jurisdiction is chosen for its low-tax and specialization in providing corporate and commercial services to non-residents. ",
                   "Three random jurisdictions, used to house offshore companies, taken from the Panama Papers are pirctured below. ",
                   "Where would you like to store your assets?")
          }),
        fluidRow(
          column(3,
                 #h2(paste0(pictures$jurisdiction_description[1])),
                 h2(paste0(1), align="center"),
                 img(src = pictures$beach_url[1], width="100%")),
          column(3, offset = 1,
                 #h2(paste0(pictures$jurisdiction_description[2])),
                 h2(paste0(2), align="center"),
                 img(src = pictures$beach_url[2], width="100%")),
          column(3, offset = 1,
                 #h2(paste0(pictures$jurisdiction_description[3])),
                 h2(paste0(3), align="center"),
                 img(src = pictures$beach_url[3], width="100%"))
        ),
        selectInput("jurisdiction_select", label = "Choose your jurisdiction:", selected = "",
                    choices = c("", "1"=1,"2"=2,"3"=3)),
        conditionalPanel(
          condition = "input.jurisdiction_select != ''",
          h3(paste0("Excellent choice!\n")),
          renderText({
            paste0("You've chosen ", pictures$jurisdiction_description[as.integer(input$jurisdiction_select)], "!")
          }),
          renderText({
            paste0(pictures$n[as.integer(input$jurisdiction_select)],
                    " Offshore corporations are currently active in that area!")
          })
        ),
        width = 12
      )
    )
  })
  
  observeEvent({
    input$next_button
    input$intermediary_table_row_last_clicked
    input$jurisdiction_select
    },{
    if (input$next_button == 2 & input$jurisdiction_select != "") {
      updateButton(session, "next_button", label = "Finish", disabled = FALSE)
    }
      else if (input$next_button == 1 & input$country_select == "") {
      updateButton(session, "next_button", label = "Next >>", disabled = TRUE)
    }
      else if (input$next_button == 1 & input$country_select != "") {
      updateButton(session, "next_button", label = "Next >>", disabled = FALSE)
      }
      else if (input$next_button == 2 & input$jurisdiction_select == "") {
      updateButton(session, "next_button", label = "Finish", disabled = TRUE)
      } else if (input$next_button == 3) {
      hide("next_button")
    }
  })
  
  output$final_panel <- renderUI({
    conditionalPanel(
      condition = "input.next_button > '2'",
      box(title = "Your Corporation:",
      h2(renderText({paste0(get_new_corp_name())})),
      h4(renderText({paste0("Intermediary: ")})),
      renderText({paste0(f.get_intermediaries(country = input$country_select, 5)$Intermediary[as.integer(input$intermediary_table_row_last_clicked)])}),
      renderText({paste0(f.get_intermediaries(country = input$country_select, 5)$Address_original[as.integer(input$intermediary_table_row_last_clicked)])}),
      h4(renderText({paste0("Jurisdiction: ")})),
      renderText({paste0(pictures$jurisdiction_description[as.integer(input$jurisdiction_select)])}),
      br(),br(),
      renderText({paste0("You are in good company! Here is a map of intermediaries from around the world:")}),
      img(src = "interm_density.png"),
      width = 12
      )
    )
  })
  
  # output$text <- renderText({
  #   paste0("next button:'", input$next_button, "'  row:'", "'  jur:'", input$jurisdiction_select, "'")
  # })
})
