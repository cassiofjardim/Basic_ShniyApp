# R/helpers_supabase.R -----------------------------------------------

# Login demo simples, sem Supabase.
# Credenciais fixas:
#   email:    demo@demo.com
#   password: 123456


verify_demo_login <- function(email, password) {
  demo_email    <- "demo@demo.com"
  demo_password <- "123456"
  
  email_norm <- email %>%
    stringr::str_to_lower() %>%
    stringr::str_trim()
  
  success <- (email_norm == demo_email) && (password == demo_password)
  
  if (success) {
    list(
      success = TRUE,
      user = list(
        email = demo_email,
        name  = "Usuário Demo"
      )
    )
  } else {
    list(
      success = FALSE,
      user    = NULL
    )
  }
}
