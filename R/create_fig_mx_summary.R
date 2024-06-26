#' Create a radar plot for the mean or median MX metrics relating to the measurement of physical behavior
#' 
#' This function creates a radar plot in relation to MX metrics as illustrated in Rowlands et al. 
#'     (2018; doi:10.1249/MSS.0000000000001561) paper.
#'
#' @param data A dataframe with physical behavior metrics summarised using means or medians of valid days. It should have 
#' been obtained using the \code{\link{prepare_dataset}}, \code{\link{mark_wear_time}}, \code{\link{mark_intensity}}, 
#'     \code{\link{recap_by_day}}, and then the \code{\link{average_results}} functions.
#' @param labels A vector of numeric values setting the breaks of the Y axis of the radar plot. Default is a vector of 6 values with
#'     a start at 0 and an end at the maximum of all the computed MX metrics. 
#' @param mpa_cutpoint A numeric value at and above which time is considered as spent in moderate-to-vigorous physical activity (in counts/epoch length used to compute MX metrics). 
#'    Defaut value is from Sasaki et al. (2011; doi:10.1016/j.jsams.2011.04.003) relating to vector magnitude.
#' @param vpa_cutpoint A numeric value at and above which time is considered as spent in vigorous physical activity (in counts/epoch length used to compute MX metrics). 
#'    Defaut value is from Sasaki et al. (2011; doi:10.1016/j.jsams.2011.04.003) relating to vector magnitude.
#'    
#' @return A ggplot object
#' 
#' @export
#'
#' @examples
#' \donttest{
#' file <- system.file("extdata", "acc.agd", package = "activAnalyzer")
#' mydata <- prepare_dataset(data = file)
#' mydata_with_wear_marks <- mark_wear_time(
#'     dataset = mydata, 
#'     TS = "TimeStamp", 
#'     to_epoch = 60,
#'     cts  = "vm",
#'     frame = 90, 
#'     allowanceFrame = 2, 
#'     streamFrame = 30
#'     )
#' mydata_with_intensity_marks <- mark_intensity(
#'     data = mydata_with_wear_marks, 
#'     col_axis = "vm", 
#'     equation = "Sasaki et al. (2011) [Adults]",
#'     sed_cutpoint = 200, 
#'     mpa_cutpoint = 2690, 
#'     vpa_cutpoint = 6167, 
#'     age = 32,
#'     weight = 67,
#'     sex = "male"
#'     )
#' summary_by_day <- recap_by_day(
#'     data = mydata_with_intensity_marks, 
#'     col_axis = "vm",
#'     age = 32, 
#'     weight = 67, 
#'     sex = "male",
#'     valid_wear_time_start = "07:00:00",
#'     valid_wear_time_end = "22:00:00",
#'     start_first_bin = 0,
#'     start_last_bin = 10000,
#'     bin_width = 500
#'     )$df_all_metrics
#' recap <- average_results(data = summary_by_day, minimum_wear_time = 10, fun  = "median")
#' create_fig_mx_summary(
#'     data = recap,
#'     labels = seq(2500, 12500, 2500)
#'  )
#'  }
#'  

create_fig_mx_summary <- function(
    data,
    labels = NULL,
    mpa_cutpoint = 2690, 
    vpa_cutpoint = 6167
){
  
# Tidy dataframe
data2 <-
  data %>%
  tidyr::pivot_longer(cols = everything(), names_to = "metric", values_to = "val") %>%
  dplyr::filter(metric %in% c("M1/3", "M120", "M60", "M30", "M15", "M5")) %>%
  dplyr::mutate(
    metric = forcats::fct_relevel(metric, "M1/3", "M120", "M60", "M30", "M15", "M5")
  )
                


# Setting labels
if (is.null(labels)) {
  
  max <- max(data2$val, na.rm = TRUE)
  min <- 0
  selected_labels = round(seq(0, max, (max-min)/5))
} else {
  selected_labels <- labels
}

# Creating a dataframe for labels
df_labels <-
  data.frame(
    x_lab = rep(30, length(selected_labels)),
    y_lab = selected_labels
  )

# Creating a dataframe for circles (thresholds)
df_circles <-
  data.frame(x = seq(1, 360, 1)) %>%
  dplyr::mutate(
    y_mpa = mpa_cutpoint,
    y_vpa = vpa_cutpoint
    ) %>%
  tidyr::pivot_longer(cols = -x, names_to = "cutpoint", values_to = "val")

# Making plot
p <-
  ggplot(data = data2, aes(x = seq(0, 300, 60), y = val)) +
  geom_polygon(aes(group = 1), color = "black", fill = "grey", alpha = 0.1) +
  geom_path(data = df_circles, aes(x = x, y = val, linetype = cutpoint), color = "red") +
  geom_text(
    data = df_labels,
    aes(x = x_lab, y = y_lab, label = y_lab)
    ) +
  coord_radar(start = 0) +
  scale_x_continuous(breaks = seq(0, 300, 60), labels = c("M1/3", "M120", "M60", "M30", "M15", "M5")) +
  scale_y_continuous(breaks = selected_labels, minor_breaks = mpa_cutpoint, labels = selected_labels) +
  scale_linetype_manual(values = c("dashed", "dotdash"), labels = c("MVPA cut-point", "VPA cut-point")) + 
  labs(x = NULL, y = NULL, linetype = "") +
  theme_bw() +
  theme(
    axis.text.y = element_blank(),
    axis.ticks.y = element_blank(),
    axis.text.x = element_text(size = 15),
    legend.text = element_text(size = 12),
    legend.key.width = unit(1.5,"cm"),
    legend.position.inside = c(0.13, 0.07)
  ) +
  guides(color = "none", fill = "none")

# Returning plot
return(p)

}
