% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_fig_mvpa.R
\name{create_fig_mvpa}
\alias{create_fig_mvpa}
\title{Create a figure showing the mean daily MVPA time}
\usage{
create_fig_mvpa(score, language = c("en", "fr", "de"))
}
\arguments{
\item{score}{A numeric value for mean daily MVPA time in minutes.}

\item{language}{A character value for setting the language with which the figure should be created: \code{en} for english; \code{fr} for french.}
}
\value{
A ggplot object.
}
\description{
The function generates a figure showing mortality hazard ratio in correspondence with daily MVPA minutes. The figure is based on
data extracted from Ekelund et al. paper (2019; doi: 10.1136/bmj.l4570).
}
\examples{
create_fig_mvpa(score = 27)

}
