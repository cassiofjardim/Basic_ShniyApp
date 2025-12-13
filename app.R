# app.R ---------------------------------------------------------------

library(shiny)
library(tidyverse)
library(highcharter)
library(ggplot2)
library(reactable)
library(scales)

# Carrega módulos e helpers
source("R/mod_login.R")
source("R/mod_dashboard.R")
source("R/helpers_supabase.R")

# helpers_the me é opcional; se existir, aplica theme
if (file.exists("R/helpers_theme.R")) {
  source("R/helpers_theme.R")
  if (exists("theme_dashboard")) {
    ggplot2::theme_set(theme_dashboard())
  }
}

ui <- bootstrapPage(
  tags$head(
    tags$title("Dashboard Financeiro – simples, organizado e automático."),
    
    # CSS principal do app
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    
    # Fontes Google: Poppins + Inter
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
    ),
    tags$link(
      rel = "stylesheet",
      href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap"
    )
  ),
  
  div(
    id = "app-root",
    uiOutput("main_ui")
  )
)

server <- function(input, output, session) {
  
  # Módulo de login
  credentials <- mod_login_server("login")
  
  # Módulo de dashboard
  mod_dashboard_server(
    id                 = "dashboard",
    user_email_reactive = credentials$user_email,
    logged_reactive     = credentials$logged
  )
  
  # Decide o que mostrar: login ou dashboard
  output$main_ui <- renderUI({
    if (isTRUE(credentials$logged())) {
      mod_dashboard_ui("dashboard")
    } else {
      mod_login_ui("login")
    }
  })
}

shinyApp(ui, server)
