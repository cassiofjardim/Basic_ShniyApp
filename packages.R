install.packages(
  c(
    # Base para ciência de dados
    "tidyverse", "dplyr", "tidyr", "purrr", "readr", "stringr", "lubridate",
    
    # Shiny + extensões
    "shiny", "shinythemes", "shinydashboard", "shinyWidgets",
    "htmltools", "bs4Dash", "bslib",
    
    # Tabelas
    "reactable", "reactablefmtr", "DT",
    
    # Gráficos
    "ggplot2", "highcharter", "plotly",
    
    # Banco de dados
    "DBI", "RSQLite",
    
    # API / HTTP / Requests
    "httr", "jsonlite",
    
    # Manipulação de arquivos
    "openxlsx",
    
    # Segurança e utilidades
    "dotenv", "config", "fs",
    
    # Ajudas gerais
    "janitor", "glue", "here", "magrittr",
    
    # Shiny avançado
    "shinyjs", "shinyvalidate", "waiter"
  ),
  dependencies = TRUE
)
