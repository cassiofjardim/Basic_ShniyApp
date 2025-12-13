# R/mod_login.R -------------------------------------------------------

mod_login_ui <- function(id) {
  ns <- NS(id)
  
  tagList(
    div(
      class = "login-page",
      div(
        class = "login-card",
        
        # Logo / título
        div(
          class = "login-header",
          div(class = "login-logo", "F"),
          div(
            class = "login-header-text",
            h2(class = "login-title", "Painel Financeiro"),
            p(
              class = "login-subtitle",
              "Acesse o painel para organizar seus lançamentos."
            )
          )
        ),
        
        # Formulário
        div(
          class = "login-form",
          div(
            class = "form-group",
            tags$label(
              `for` = ns("email"),
              class = "form-label",
              "E-mail"
            ),
            textInput(
              inputId    = ns("email"),
              label      = NULL,
              value      = "demo@demo.com",
              width      = "100%",
              placeholder = "seuemail@gmail.com"
            )
          ),
          div(
            class = "form-group",
            tags$label(
              `for` = ns("password"),
              class = "form-label",
              "Senha"
            ),
            passwordInput(
              inputId    = ns("password"),
              label      = NULL,
              value      = "123456",
              width      = "100%",
              placeholder = "Digite sua senha"
            )
          ),
          actionButton(
            inputId = ns("login_btn"),
            label   = "Entrar",
            class   = "btn-primary btn-block"
          ),
          div(
            class = "login-links",
            tags$a(
              href  = "#",
              class = "login-link-muted",
              "Esqueci minha senha"
            )
          ),
          div(
            class = "login-error",
            textOutput(ns("login_error"), inline = TRUE)
          ),
          tags$small(
            class = "login-hint",
            "Login demo: e-mail demo@demo.com | senha 123456"
          )
        )
      )
    )
  )
}

mod_login_server <- function(id) {
  moduleServer(
    id,
    function(input, output, session) {
      
      ns <- session$ns
      
      logged      <- reactiveVal(FALSE)
      user_email  <- reactiveVal(NULL)
      login_error <- reactiveVal("")
      
      observeEvent(input$login_btn, {
        req(input$email, input$password)
        
        res <- verify_demo_login(
          email    = input$email,
          password = input$password
        )
        
        if (isTRUE(res$success)) {
          logged(TRUE)
          user_email(res$user$email)
          login_error("")
        } else {
          logged(FALSE)
          user_email(NULL)
          login_error("Credenciais inválidas. Tente novamente.")
        }
      })
      
      output$login_error <- renderText({
        login_error()
      })
      
      # Exporta reativos para o app
      list(
        logged     = logged,
        user_email = user_email
      )
    }
  )
}
