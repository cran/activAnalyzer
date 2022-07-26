% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rasch_transform.R
\name{rasch_transform}
\alias{rasch_transform}
\title{Compute Rasch transformation for PROactive scores}
\usage{
rasch_transform(
  x,
  quest = c("C-PPAC", "D-PPAC"),
  score = c("difficulty", "quantity")
)
}
\arguments{
\item{x}{A numeric value that is the difficulty score (between 0 and 40 for C-PPAC or 0 and 20 for D-PPAC) or the quantity score (between 0 and 15 for C-PPAC or 0 and 17 for D-PPAC) obtained using a PROactive questionnaire.}

\item{quest}{A character value to indicate with which PROactive questionnaire the raw score has been obtained.}

\item{score}{A character value.}
}
\value{
A numeric value.
}
\description{
This function provides the 0-100 Rasch scaled score of a given C-PPAC or D-PPAC raw score (based on: Garcia-Aymerich J, et al. Thorax 2021;0:1–11. doi: 10.1136/thoraxjnl-2020-214554).
}
\examples{
rasch_transform(33, quest = "C-PPAC", score = "difficulty")

}
