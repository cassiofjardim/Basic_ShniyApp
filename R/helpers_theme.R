# R/helpers_theme.R ---------------------------------------------------

theme_dashboard <- function() {
  ggplot2::theme_minimal(base_family = "Inter", base_size = 11) +
    ggplot2::theme(
      plot.background  = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),
      panel.background = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),
      panel.grid.major = ggplot2::element_line(colour = "#E5E7EB"),
      panel.grid.minor = ggplot2::element_blank(),
      axis.text        = ggplot2::element_text(colour = "#111827"),
      axis.title       = ggplot2::element_text(colour = "#111827"),
      plot.title       = ggplot2::element_text(
        colour = "#111827",
        face   = "bold",
        family = "Poppins"
      ),
      plot.subtitle    = ggplot2::element_text(colour = "#6B7280"),
      strip.background = ggplot2::element_rect(fill = "#0F172A", colour = NA),
      strip.text       = ggplot2::element_text(colour = "#F9FAFB"),
      legend.background = ggplot2::element_rect(fill = "#FFFFFF", colour = NA),
      legend.text       = ggplot2::element_text(colour = "#111827"),
      legend.title      = ggplot2::element_text(colour = "#111827")
    )
}
