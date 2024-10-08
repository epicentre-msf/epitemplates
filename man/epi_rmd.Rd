% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/use.R
\name{epi_rmd}
\alias{epi_rmd}
\title{Use Rmarkdown template}
\usage{
epi_rmd(path, add_project = FALSE, quiet = TRUE)
}
\arguments{
\item{path}{The path to the quarto document}

\item{add_project}{Boolean. Add a Rstudio project to the new document folder.}

\item{quiet}{Suppress messages}
}
\description{
Import and use Rmarkdown's template.
}
\examples{
\dontrun{
epi_rmd(path = ".")
}
}
