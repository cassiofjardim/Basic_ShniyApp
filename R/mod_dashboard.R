# R/mod_dashboard.R ---------------------------------------------------

mod_dashboard_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(
      class = "dashboard-page",
      
      # Header ---------------------------------------------------------
      div(
        class = "app-header",
        div(
          class = "header-left",
          div(class = "header-logo", "F"),
          div(
            class = "header-text",
            div(class = "header-title", "Dashboard Financeiro"),
            div(
              class = "header-tagline",
              "Financeiro simples, organizado e automático."
            )
          )
        ),
        div(
          class = "header-center",
          NULL
        ),
        div(
          class = "header-right",
          span("Usuário: "),
          span(class = "user-name", textOutput(ns("user_label"), inline = TRUE)),
          actionButton(
            inputId = ns("logout"),
            label   = "Sair",
            class   = "btn-logout"
          )
        )
      ),
      
      # Conteúdo -------------------------------------------------------
      div(
        class = "dashboard-content",
        
        # Linha de KPIs
        div(
          class = "kpi-row",
          
          div(
            class = "card kpi-card",
            div(class = "kpi-label", "Receita Total"),
            div(class = "kpi-value", textOutput(ns("kpi_total_receita")))
          ),
          
          div(
            class = "card kpi-card",
            div(class = "kpi-label", "Qtde de Transações"),
            div(class = "kpi-value", textOutput(ns("kpi_qtd_transacoes")))
          ),
          
          div(
            class = "card kpi-card",
            div(class = "kpi-label", "Ticket Médio"),
            div(class = "kpi-value", textOutput(ns("kpi_ticket_medio")))
          ),
          
          div(
            class = "card kpi-card",
            div(class = "kpi-label", "Nº de Regiões"),
            div(class = "kpi-value", textOutput(ns("kpi_n_regioes")))
          )
        ),
        
        # Grid principal 2 colunas
        div(
          class = "main-grid",
          
          # Coluna esquerda ---------------------------------------------
          div(
            class = "grid-left",
            
            # Card grande: gráfico de barras por região
            div(
              class = "card card-map card-chart-lg",
              div(class = "card-title", "Receita por região"),
              div(
                class = "card-body",
                div(
                  class = "hc-chart",
                  highchartOutput(ns("map_receita_regiao"), height = "100%")
                )
              )
            ),
            
            # Linha de 2 cards: barras horizontais e donut
            div(
              class = "subgrid-row",
              
              div(
                class = "card card-chart",
                div(class = "card-title", "Receita por canal"),
                div(
                  class = "card-body",
                  div(
                    class = "hc-chart",
                    highchartOutput(ns("bar_canal"), height = "100%")
                  )
                )
              ),
              
              div(
                class = "card card-chart",
                div(class = "card-title", "Receita por categoria"),
                div(
                  class = "card-body",
                  div(
                    class = "hc-chart",
                    highchartOutput(ns("donut_categoria"), height = "100%")
                  )
                )
              )
            )
          ),
          
          # Coluna direita ----------------------------------------------
          div(
            class = "grid-right",
            
            div(
              class = "card card-chart card-chart-md",
              div(class = "card-title", "Receita por mês"),
              div(
                class = "card-body",
                plotOutput(ns("bar_mes"), height = "100%")
              )
            ),
            
            div(
              class = "card card-table",
              div(class = "card-title", "Detalhamento de vendas"),
              div(
                class = "card-body card-body-table",
                reactableOutput(ns("tabela_detalhes"))
              )
            )
          )
        )
      )
    )
  )
}

mod_dashboard_server <- function(id, user_email_reactive, logged_reactive) {
  moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns
      
      # 1) Carregamento dos dados -------------------------------------
      # Arquivo: data/dados_dashboard_demo.csv
      
      dados <- reactive({
        req(logged_reactive())
        
        readr::read_csv(
          file = "data/dados_dashboard_demo.csv",
          show_col_types = FALSE,
          col_types = readr::cols(
            data      = readr::col_date(),
            regiao    = readr::col_character(),
            canal     = readr::col_character(),
            categoria = readr::col_character(),
            valor     = readr::col_double()
          )
        )
      })
      
      dados_mes <- reactive({
        dados() %>%
          mutate(ano_mes = lubridate::floor_date(data, "month")) %>%
          group_by(ano_mes) %>%
          summarise(
            receita = sum(valor, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          arrange(ano_mes)
      })
      
      # 2) Header: usuário logado e logout ----------------------------
      output$user_label <- renderText({
        req(user_email_reactive())
        user_email_reactive()
      })
      
      observeEvent(input$logout, {
        session$reload()
      })
      
      # 3) KPIs --------------------------------------------------------
      output$kpi_total_receita <- renderText({
        req(dados())
        total <- dados() %>%
          summarise(total = sum(valor, na.rm = TRUE)) %>%
          pull(total)
        scales::dollar(
          total,
          prefix       = "R$ ",
          big.mark     = ".",
          decimal.mark = ","
        )
      })
      
      output$kpi_qtd_transacoes <- renderText({
        req(dados())
        dados() %>%
          summarise(n = dplyr::n()) %>%
          pull(n)
      })
      
      output$kpi_ticket_medio <- renderText({
        req(dados())
        ticket <- dados() %>%
          summarise(
            total = sum(valor, na.rm = TRUE),
            n     = dplyr::n()
          ) %>%
          mutate(ticket = dplyr::if_else(n > 0, total / n, 0)) %>%
          pull(ticket)
        scales::dollar(
          ticket,
          prefix       = "R$ ",
          big.mark     = ".",
          decimal.mark = ","
        )
      })
      
      output$kpi_n_regioes <- renderText({
        req(dados())
        dados() %>%
          summarise(n = dplyr::n_distinct(regiao)) %>%
          pull(n)
      })
      
      # 4) Gráfico de barras - receita por região ---------------------
      output$map_receita_regiao <- renderHighchart({
        df <- dados() %>%
          group_by(regiao) %>%
          summarise(
            receita = sum(valor, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          arrange(desc(receita))
        
        req(!rlang::is_empty(df))
        
        highchart() %>%
          hc_chart(
            type            = "column",
            backgroundColor = "#FFFFFF"
          ) %>%
          hc_title(text = NULL) %>%
          hc_xAxis(
            categories = df$regiao,
            title      = list(text = NULL)
          ) %>%
          hc_yAxis(
            title = list(text = NULL)
          ) %>%
          hc_series(
            list(
              name  = "Receita",
              data  = df$receita,
              color = "#2563EB"
            )
          ) %>%
          hc_tooltip(
            pointFormat = "Receita: R$ {point.y:,.2f}"
          ) %>%
          hc_plotOptions(
            series = list(
              dataLabels = list(
                enabled = TRUE,
                format  = "R$ {y:,.0f}"
              )
            )
          ) %>%
          hc_legend(enabled = FALSE) %>%
          hc_exporting(enabled = FALSE) %>%
          hc_credits(enabled = FALSE)
      })
      
      # 5) Barras horizontais - receita por canal ---------------------
      output$bar_canal <- renderHighchart({
        df <- dados() %>%
          group_by(canal) %>%
          summarise(
            receita = sum(valor, na.rm = TRUE),
            .groups = "drop"
          ) %>%
          arrange(receita)
        
        highchart() %>%
          hc_chart(
            type            = "bar",
            inverted        = TRUE,
            backgroundColor = "#FFFFFF"
          ) %>%
          hc_title(text = NULL) %>%
          hc_xAxis(
            categories = df$canal,
            title      = list(text = NULL)
          ) %>%
          hc_yAxis(
            title = list(text = NULL)
          ) %>%
          hc_series(
            list(
              name  = "Receita",
              data  = df$receita,
              color = "#2563EB"
            )
          ) %>%
          hc_tooltip(
            pointFormat = "Receita: R$ {point.y:,.2f}"
          ) %>%
          hc_plotOptions(
            series = list(
              dataLabels = list(
                enabled = TRUE,
                format  = "R$ {y:,.0f}"
              )
            )
          ) %>%
          hc_legend(enabled = FALSE) %>%
          hc_exporting(enabled = FALSE) %>%
          hc_credits(enabled = FALSE)
      })
      
      # 6) Donut - receita por categoria ------------------------------
      output$donut_categoria <- renderHighchart({
        df <- dados() %>%
          group_by(categoria) %>%
          summarise(
            receita = sum(valor, na.rm = TRUE),
            .groups = "drop"
          )
        
        highchart() %>%
          hc_chart(
            type            = "pie",
            backgroundColor = "#FFFFFF"
          ) %>%
          hc_title(text = NULL) %>%
          hc_plotOptions(
            pie = list(
              innerSize  = "60%",
              dataLabels = list(
                enabled = TRUE,
                format  = "{point.name}: {point.percentage:.1f}%"
              )
            )
          ) %>%
          hc_series(
            list(
              name  = "Receita",
              data  = list_parse2(
                df %>%
                  mutate(
                    name = categoria,
                    y    = receita
                  ) %>%
                  select(name, y)
              ),
              colors = purrr::rep_along(df$receita, "#2563EB")
            )
          ) %>%
          hc_tooltip(
            pointFormat = "Receita: R$ {point.y:,.2f}"
          ) %>%
          hc_legend(enabled = FALSE) %>%
          hc_exporting(enabled = FALSE) %>%
          hc_credits(enabled = FALSE)
      })
      
      # 7) Barras por mês (ggplot2) -----------------------------------
      output$bar_mes <- renderPlot({
        df <- dados_mes()
        req(!rlang::is_empty(df))
        
        ggplot(df, aes(x = ano_mes, y = receita)) +
          geom_col(fill = "#2563EB", width = 25) +
          scale_y_continuous(
            labels = function(x) {
              scales::comma(x, big.mark = ".", decimal.mark = ",")
            }
          ) +
          scale_x_date(date_labels = "%b/%Y") +
          labs(
            x = NULL,
            y = NULL
          ) +
          if (exists("theme_dashboard")) {
            theme_dashboard()
          } else {
            ggplot2::theme_minimal()
          }
      })
      
      # 8) Tabela detalhada (reactable) -------------------------------
      output$tabela_detalhes <- renderReactable({
        df <- dados() %>%
          arrange(desc(data))
        
        reactable(
          df,
          searchable      = TRUE,
          filterable      = TRUE,
          resizable       = TRUE,
          pagination      = TRUE,
          defaultPageSize = 10,
          highlight       = TRUE,
          striped         = TRUE,
          defaultColDef   = colDef(
            headerClass = "rt-header",
            class       = "rt-cell"
          )
        )
      })
      
    }
  )
}
