#' Average results over valid days
#' 
#' This function computes, using valid days only, the mean of each of the metrics 
#'     obtained using the \code{\link{recap_by_day}} function. The median can also 
#'     be obtained with an appropriate configuration of the function.
#'
#' @param data A dataframe obtained using the \code{\link{prepare_dataset}},  \code{\link{mark_wear_time}}, \code{\link{mark_intensity}}, and then the \code{\link{recap_by_day}} functions.
#' @param minimum_wear_time A numeric value (in hours) to set the minimum wear time duration for validating a day.
#' @param fun A character value indicating whether means or medians should be computed.
#'
#' @return A dataframe.
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom stats median
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
#'     sex = "male",
#'     )
#' summary_by_day <- recap_by_day(
#'     data = mydata_with_intensity_marks, 
#'     age = 32, 
#'     weight = 67, 
#'     sex = "male",
#'     valid_wear_time_start = "07:00:00",
#'     valid_wear_time_end = "22:00:00"
#'     )$df_all_metrics
#' average_results(data = summary_by_day, minimum_wear_time = 10)
#' }
#' 
average_results <- function(
    data, 
    minimum_wear_time = 10, 
    fun = c("mean", "median")
    ) {
  
  fun <- match.arg(fun)
  
  if (fun == "mean") {
    
  results <- data %>%
    dplyr::mutate(validity = dplyr::if_else(wear_time >= minimum_wear_time * 60, "valid", "invalid")) %>%
    dplyr::filter(validity == "valid") %>%
    dplyr::summarise(valid_days = dplyr::n(),
              wear_time = round(mean(wear_time), 2),
              total_counts_axis1 = round(mean(total_counts_axis1), 2),
              total_counts_vm = round(mean(total_counts_vm), 2),
              axis1_per_min = round(mean(axis1_per_min), 2),
              vm_per_min = round(mean(vm_per_min), 2),
              minutes_SED = round(mean(minutes_SED), 2),
              minutes_LPA = round(mean(minutes_LPA), 2),
              minutes_MPA = round(mean(minutes_MPA), 2),
              minutes_VPA = round(mean(minutes_VPA), 2),
              minutes_MVPA = round(mean(minutes_MVPA), 2),
              percent_SED = round(mean(percent_SED), 2),
              percent_LPA = round(mean(percent_LPA), 2),
              percent_MPA = round(mean(percent_MPA), 2),
              percent_VPA = round(mean(percent_VPA), 2),
              percent_MVPA = round(mean(percent_MVPA), 2),
              ratio_mvpa_sed = round(mean(ratio_mvpa_sed), 2),
              mets_hours_mvpa = round(mean(mets_hours_mvpa), 2),
              total_kcal = round(mean(total_kcal), 2),
              pal = round(mean(pal), 2),
              total_steps = round(mean(total_steps), 2),
              max_steps_60min = round(mean(max_steps_60min), 2),
              max_steps_30min = round(mean(max_steps_30min), 2),
              max_steps_20min = round(mean(max_steps_20min), 2),
              max_steps_5min = round(mean(max_steps_5min), 2),
              max_steps_1min = round(mean(max_steps_1min), 2),
              peak_steps_60min = round(mean(peak_steps_60min), 2),
              peak_steps_30min = round(mean(peak_steps_30min), 2),
              peak_steps_20min = round(mean(peak_steps_20min), 2),
              peak_steps_5min = round(mean(peak_steps_5min), 2),
              peak_steps_1min = round(mean(peak_steps_1min), 2),
              ig = round(mean(ig), 2),
              `M1/3` = round(mean(`M1/3`), 2),
              M120 = round(mean(M120), 2),
              M60 = round(mean(M60), 2),
              M30 = round(mean(M30), 2),
              M15 = round(mean(M15), 2),
              M5 = round(mean(M5), 2)
    )
  
  return(results)
  
  }
  
 if (fun == "median") {
    
   results <-  data %>%
      dplyr::mutate(validity = dplyr::if_else(wear_time >= minimum_wear_time * 60, "valid", "invalid")) %>%
      dplyr::filter(validity == "valid") %>%
      dplyr::summarise(valid_days = dplyr::n(),
                       wear_time = round(median(wear_time), 2),
                       total_counts_axis1 = round(median(total_counts_axis1), 2),
                       total_counts_vm = round(median(total_counts_vm), 2),
                       axis1_per_min = round(median(axis1_per_min), 2),
                       vm_per_min = round(median(vm_per_min), 2),
                       minutes_SED = round(median(minutes_SED), 2),
                       minutes_LPA = round(median(minutes_LPA), 2),
                       minutes_MPA = round(median(minutes_MPA), 2),
                       minutes_VPA = round(median(minutes_VPA), 2),
                       minutes_MVPA = round(median(minutes_MVPA), 2),
                       percent_SED = round(median(percent_SED), 2),
                       percent_LPA = round(median(percent_LPA), 2),
                       percent_MPA = round(median(percent_MPA), 2),
                       percent_VPA = round(median(percent_VPA), 2),
                       percent_MVPA = round(median(percent_MVPA), 2),
                       ratio_mvpa_sed = round(median(ratio_mvpa_sed), 2),
                       mets_hours_mvpa = round(median(mets_hours_mvpa), 2),
                       total_kcal = round(median(total_kcal), 2),
                       pal = round(median(pal), 2),
                       total_steps = round(median(total_steps), 2),
                       max_steps_60min = round(median(max_steps_60min), 2),
                       max_steps_30min = round(median(max_steps_30min), 2),
                       max_steps_20min = round(median(max_steps_20min), 2),
                       max_steps_5min = round(median(max_steps_5min), 2),
                       max_steps_1min = round(median(max_steps_1min), 2),
                       peak_steps_60min = round(median(peak_steps_60min), 2),
                       peak_steps_30min = round(median(peak_steps_30min), 2),
                       peak_steps_20min = round(median(peak_steps_20min), 2),
                       peak_steps_5min = round(median(peak_steps_5min), 2),
                       peak_steps_1min = round(median(peak_steps_1min), 2),
                       ig = round(median(ig), 2),
                       `M1/3` = round(median(`M1/3`), 2),
                       M120 = round(median(M120), 2),
                       M60 = round(median(M60), 2),
                       M30 = round(median(M30), 2),
                       M15 = round(median(M15), 2),
                       M5 = round(median(M5), 2)
      )
   
   return(results)
   
  } 
  
}
