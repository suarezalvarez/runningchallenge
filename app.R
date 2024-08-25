library(shiny)
library(bslib)

# Define UI ----
ui <- page_sidebar(
  
  title = "Repte runner dels Quechua",
  sidebar = sidebar(checkboxGroupInput("seleccio_corredor",
                                       "Selecciona el teu nom",
                                        c("Andreu",
                                          "Hektor",
                                          "Marc",
                                          "Martí",
                                          "Martín",
                                          "Nil",
                                          "Sergi"))),
  card(
    card_header("Intro"),
    card_body(
      "Benvingut/da a la pàgina del repte runner dels Quechua. 
      Aquí podràs veure les teves dades de corredor/corredora i comparar-les 
      amb les de la resta de corredors/corredores.",
      "Per començar, selecciona el teu nom a la barra lateral esquerra."
      )
  ),
  card(
    card_header(textOutput("seleccio_corredor")),
    card_body(
      plotOutput("plot")
    )
  )
  
)



# Define server logic ----
server <- function(input, output) {
 
 source("data/myplot.R")
  
  output$seleccio_corredor <- renderText({
    c("Has seleccionat:", paste(input$seleccio_corredor, collapse = ", "))
  }) 
  
  output$plot = renderPlot({
    myplot
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)