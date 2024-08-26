library(shiny)
library(bslib)
library(googledrive)
library(tidyverse)
library(lubridate)


convert_to_seconds <- function(time_str) {
  sapply(strsplit(time_str, ":"), function(x) {
    as.numeric(x[1]) * 60 + as.numeric(x[2])
  })
}

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
                                          "Sergi")),
                    
                    checkboxGroupInput("seleccio_esport",
                                       "Selecciona l'esport",
                                       c("Atletisme",
                                         "Ciclisme",
                                         "Natació",
                                         "Gimnàs",
                                         "Elíptica")),
                    
                    selectInput("seleccio_visual",
                                       "Què vols visualitzar?",
                                       c("Distància" = "distancia",
                                         "Ritme" = "ritme",
                                         "Temps" = "temps",
                                         "Distància acumulada individual" = "ac_dist_corredor",
                                         "Distància acumulada conjunta" = "ac_dist")),
  ),
  
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
 
  # Download data
  drive_download(path = "data/quechua" , 
                 as_id("https://docs.google.com/spreadsheets/d/1K251SxR0bz6sYHPDktJ51IbwVtpJoVYH9yXKt7SvvOg/edit?usp=sharing"),
                 type ="csv",
                 overwrite = T)
  # Read data
  
  running_data = read.csv("data/quechua.csv")
 
  # Rename columns
  colnames(running_data) = c("marca",
                             "persona",
                             "esport",
                             "distancia",
                             "ritme",
                             "temps",
                             "data",
                             "hora")
  
  # Transform data
  
  running_data$dia = running_data$data
  running_data$data = as.POSIXct(paste(running_data$data,running_data$hora), format = "%d/%m/%Y %H:%M")
  
  running_data = running_data |> select(-c(hora))
  
  running_data$temps_sec = convert_to_seconds(running_data$temps)
  
  running_data$ac_dist = cumsum(running_data$distancia)
  running_data$ac_dist_corredor = ave(running_data$distancia, running_data$persona, FUN = cumsum)
  
  output$seleccio_corredor <- renderText({
    c("Has seleccionat:", paste(input$seleccio_corredor, collapse = ", "))
  }) 
  
  
  
  
  output$plot = renderPlot({
    
  
    ggplot(running_data |> filter(persona %in% input$seleccio_corredor) |> filter(esport %in% input$seleccio_esport),
           aes(x = data, y = input$seleccio_visual, color = persona)) +
      geom_point() +
      geom_line() +
      labs(x = "Data",
           y = input$seleccio_visual) +
      theme_minimal()
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)