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
            div(class = "kpi-value", textOutput(ns("kpi_total_receita"))),
            div(
              class = "kpi-note",
              "Soma de todas as vendas registradas no período. Use este número como referência para comparar crescimento."
            )
          ),
          
          div(
            class = "card kpi-card",
            div(class = "kpi-label", "Qtde de Transações"),
            div(class = "kpi-value", textOutput(ns("kpi_qtd_transacoes"))),
            div(
              class = "kpi-note",
              "Quantidade total de lançamentos. Ajuda a entender volume e sazonalidade junto do ticket médio."
            )
          ),
          
          div(
            class = "card kpi-card",
            div(class = "kpi-label", "Ticket Médio"),
            div(class = "kpi-value", textOutput(ns("kpi_ticket_medio"))),
            div(
              class = "kpi-note",
              "Valor médio por transação. Bom indicador de mix de produtos, preços e comportamento do cliente."
            )
          ),
          
          div(
            class = "card kpi-card",
            div(class = "kpi-label", "Nº de Regiões"),
            div(class = "kpi-value", textOutput(ns("kpi_n_regioes"))),
            div(
              class = "kpi-note",
              "Cobertura geográfica com vendas no período. Use para identificar expansão e concentração de receita."
            )
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
                class = "card-subtitle",
                "Comparação de desempenho entre regiões. Passe o mouse para detalhes e identifique as maiores contribuições."
              ),
              div(
                class = "card-body",
                div(
                  class = "card-region-tabs",
                  tabsetPanel(
                    type = "pills",
                    selected = "Nacional",
                    tabPanel(
                      "Nacional",
                      div(
                        class = "card-visual",
                        div(
                          class = "hc-chart",
                          highchartOutput(ns("map_receita_regiao"), height = "420px")
                        )
                      )
                    ),
                    tabPanel(
                      "Nordeste",
                      div(
                        class = "region-tab",
                        p(class = "region-p", "📍 Região com maior participação no período e boa consistência de volume."),
                        p(class = "region-p", "📈 Sugestão: mantenha o ritmo e teste campanhas de upsell nas categorias mais fortes."),
                        p(class = "region-p", "💡 Verifique picos por mês para entender sazonalidade e oportunidades de antecipação."),
                        p(class = "region-p", "🧩 Leitura rápida: quando a receita cresce com ticket estável, o ganho vem de volume; quando o volume cai, o ticket ajuda a sustentar o resultado."),
                        p(class = "region-p", "🎯 Ação sugerida: priorize os 2 canais mais eficientes e crie uma oferta “âncora” (produto/serviço) para puxar itens complementares."),
                        p(class = "region-p", "📌 Monitoramento: acompanhe a dispersão por cidade/cluster para não depender de poucos pontos de venda."),
                        p(class = "region-p", "✅ Checklist da semana: revisar meta, ajustar verba por canal e validar se a categoria líder continua crescendo."),
                        p(class = "region-p", "🔎 Pergunta guia: quais transações repetem padrão (mesmo canal/categoria) e podem virar playbook?")
                      )
                    ),
                    tabPanel(
                      "Sudeste",
                      div(
                        class = "region-tab",
                        p(class = "region-p", "🏙️ Receita alta e grande potencial de escala por capilaridade de canais."),
                        p(class = "region-p", "🎯 Foco: otimizar conversão nos canais com maior tráfego e menor retorno."),
                        p(class = "region-p", "✅ Acompanhe ticket médio para identificar mix premium vs. volume."),
                        p(class = "region-p", "⚡ Oportunidade: pequenas melhorias no funil (visita → compra) costumam gerar impacto grande no total por causa do volume."),
                        p(class = "region-p", "🧪 Testes: rode A/B de oferta (desconto vs. bônus) e observe mudança em ticket e frequência."),
                        p(class = "region-p", "🧭 Segmentação: separe por canal e categoria para entender onde o crescimento é saudável (margem + recorrência)."),
                        p(class = "region-p", "📦 Mix: categorias com alta participação podem estar saturadas; busque as que crescem mês a mês para ganhar share."),
                        p(class = "region-p", "📌 Monitoramento: atenção a “picos” pontuais — valide se são campanhas ou outliers no detalhamento."),
                        p(class = "region-p", "🤝 Execução: alinhe metas por canal e acompanhe semanalmente a diferença entre planejado e realizado.")
                      )
                    ),
                    tabPanel(
                      "Sul",
                      div(
                        class = "region-tab",
                        p(class = "region-p", "🧭 Receita relevante e boa estabilidade no período analisado."),
                        p(class = "region-p", "🔎 Explore variações por canal para identificar ganho rápido de eficiência."),
                        p(class = "region-p", "📊 Use o detalhamento para checar recorrência e categorias com maior margem."),
                        p(class = "region-p", "🧱 Base sólida: estabilidade é ótima para padronizar processos e reduzir custo de aquisição ao longo do tempo."),
                        p(class = "region-p", "🎯 Ação sugerida: reforçar o canal mais previsível e abrir um segundo canal “de crescimento” com metas menores."),
                        p(class = "region-p", "📈 Olhe tendência: se a receita cresce, mas o ticket cai, investigue descontos e condições comerciais."),
                        p(class = "region-p", "🧩 Mix: avalie categorias “meio de funil” (nem as maiores nem as menores) — elas costumam ter melhor potencial de expansão."),
                        p(class = "region-p", "✅ Checklist: revisar top 20 transações por valor, comparar com a média e entender o que gerou os maiores resultados."),
                        p(class = "region-p", "🗺️ Pergunta guia: quais canais aumentam o ticket sem derrubar volume?")
                      )
                    ),
                    tabPanel(
                      "Centro-Oeste",
                      div(
                        class = "region-tab",
                        p(class = "region-p", "🌾 Receita próxima do Sul — pode responder bem a ajustes de mix e oferta."),
                        p(class = "region-p", "⚙️ Teste ações por categoria e acompanhe o impacto mês a mês."),
                        p(class = "region-p", "🤝 Se houver representante, avalie cobertura e produtividade."),
                        p(class = "region-p", "🧭 Contexto: a performance pode variar bastante por praça; foque nos clusters com melhor retorno para ganhar escala."),
                        p(class = "region-p", "📦 Estratégia: combine uma categoria “carro-chefe” com uma de expansão para aumentar participação sem canibalizar."),
                        p(class = "region-p", "🎯 Ação sugerida: padronize abordagem comercial por canal (mensagem, preço e prazo) e meça impacto na conversão."),
                        p(class = "region-p", "📊 Monitoramento: acompanhe frequência de compra (recorrência) para diferenciar crescimento real de picos pontuais."),
                        p(class = "region-p", "✅ Checklist: revisar performance por canal, cortar o pior e reforçar o melhor com metas realistas."),
                        p(class = "region-p", "🔎 Pergunta guia: onde a receita cresce com o menor esforço (custo/tempo) de execução?")
                      )
                    ),
                    tabPanel(
                      "Norte",
                      div(
                        class = "region-tab",
                        p(class = "region-p", "🌿 Menor participação no total, mas com espaço para crescimento incremental."),
                        p(class = "region-p", "🚀 Ações rápidas: reforçar o melhor canal e simplificar a oferta."),
                        p(class = "region-p", "🗺️ Monitore concentração: poucos pontos podem puxar o resultado."),
                        p(class = "region-p", "🧩 Ganhos incrementais: foque em repetibilidade (processo) antes de buscar grandes saltos de volume."),
                        p(class = "region-p", "🎯 Ação sugerida: escolha 1 categoria prioritária e 1 canal principal para executar com consistência por 2–4 semanas."),
                        p(class = "region-p", "📦 Oferta: reduza fricção (menos opções, mensagem clara) e destaque benefícios para elevar conversão."),
                        p(class = "region-p", "📈 Acompanhe ticket + volume: se o volume subir e o ticket se mantiver, você ganha escala com saúde."),
                        p(class = "region-p", "✅ Checklist: revisar transações de maior valor, entender origem e replicar o padrão em campanhas pequenas."),
                        p(class = "region-p", "🔎 Pergunta guia: quais ajustes simples (prazo, combo, canal) melhoram o resultado sem aumentar complexidade?")
                      )
                    )
                  )
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
                  class = "card-subtitle",
                  "Mostra quais canais trazem mais receita. Útil para ajustar investimento e priorizar ações comerciais."
                ),
                div(
                  class = "card-body",
                  div(
                    class = "card-visual",
                    div(
                      class = "hc-chart",
                      highchartOutput(ns("bar_canal"), height = "320px")
                    )
                  ),
                  div(
                    class = "card-note",
                    "Interpretação rápida: canais com baixo volume e alto valor podem ser nichos estratégicos."
                  )
                )
              ),
              
              div(
                class = "card card-chart",
                div(class = "card-title", "Receita por categoria"),
                div(
                  class = "card-subtitle",
                  "Distribuição da receita por categoria de produto/serviço. Ajuda a enxergar o mix e o peso relativo."
                ),
                div(
                  class = "card-body",
                  div(
                    class = "card-visual",
                    div(
                      class = "hc-chart",
                      highchartOutput(ns("donut_categoria"), height = "320px")
                    )
                  ),
                  div(
                    class = "card-note",
                    "Dica: categorias com participação pequena, mas crescimento consistente, podem merecer campanhas dedicadas."
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
                class = "card-subtitle",
                "Evolução mensal da receita. Use para identificar tendência, sazonalidade e pontos de atenção no período."
              ),
              div(
                class = "card-body",
                div(
                  class = "card-visual",
                  plotOutput(ns("bar_mes"), height = "300px")
                ),
                div(
                  class = "card-note",
                  "Sugestão: compare meses consecutivos para ver aceleração/desaceleração e investigar variações fora do padrão."
                )
              )
            ),
            
            div(
              class = "card card-table",
              div(class = "card-title", "Detalhamento de vendas"),
              div(
                class = "card-subtitle",
                "Lista de transações para auditoria e drill-down. Pesquise, filtre e ordene para encontrar padrões."
              ),
              div(
                class = "card-body card-body-table",
                div(
                  class = "card-note card-note-top",
                  "Dica: filtre por região/canal/categoria para cruzar com os gráficos e validar hipóteses rapidamente."
                ),
                div(
                  class = "card-visual",
                  reactableOutput(ns("tabela_detalhes"))
                )
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
        
        base_theme <- if (exists("theme_dashboard")) {
          theme_dashboard()
        } else {
          ggplot2::theme_minimal()
        }
        
        ggplot(df, aes(x = ano_mes, y = receita)) +
          geom_col(fill = "#2563EB", width = 25) +
          scale_y_continuous(
            labels = function(x) {
              scales::comma(x, big.mark = ".", decimal.mark = ",")
            }
          ) +
          scale_x_date(date_labels = "%b/%y") +
          labs(
            x = NULL,
            y = NULL
          ) +
          base_theme +
          ggplot2::theme(
            plot.margin = grid::unit(c(4, 4, 4, 4), "pt"),
            axis.text.x = ggplot2::element_text(size = 9),
            axis.text.y = ggplot2::element_text(size = 9)
          )
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
