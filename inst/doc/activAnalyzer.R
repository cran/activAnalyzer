## ---- include = FALSE---------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)

## ----setup--------------------------------------------------------------------
library(activAnalyzer)
library(magrittr)

## -----------------------------------------------------------------------------
file <- system.file("extdata", "acc.agd", package = "activAnalyzer")

## ---- warning=FALSE, message=FALSE--------------------------------------------
mydata <- prepare_dataset(data = file)

## ---- message = FALSE, fig.width = 7, fig.height = 5, fig.align = "center"----
mydata_with_wear_marks <- 
  mydata %>%
  mark_wear_time(
    to_epoch = 60,
    cts = "vm",
    frame = 90, 
    allowanceFrame = 2, 
    streamFrame = 30
    )

plot_data(data = mydata_with_wear_marks, metric = "vm")

## ---- warning = FALSE, message = FALSE, fig.width = 7, fig.height = 5, fig.align = "center"----
mydata_with_intensity_marks <- 
  mark_intensity(
     data = mydata_with_wear_marks, 
     col_axis = "vm", 
     equation = "Sasaki et al. (2011) [Adults]",
     sed_cutpoint = 200, 
     mpa_cutpoint = 2690, 
     vpa_cutpoint = 6167, 
     age = 32,
     weight = 67,
     sex = "male",
    )

plot_data_with_intensity(mydata_with_intensity_marks, metric = "vm" )

## ---- eval = FALSE------------------------------------------------------------
#  results_by_day <-
#    mydata_with_intensity_marks %>%
#    recap_by_day(
#      age = 32,
#      weight = 67,
#      sex = "male",
#      valid_wear_time_start = "07:00:00",
#      valid_wear_time_end = "22:00:00"
#      )
#  
#  results_by_day

## ---- echo = FALSE, message= FALSE--------------------------------------------
results_by_day <-
  mydata_with_intensity_marks %>%
  recap_by_day(
    age = 32, 
    weight = 67, 
    sex = "male",
    valid_wear_time_start = "00:00:00",
    valid_wear_time_end = "23:59:59"
    )

results_by_day %>%  
  reactable::reactable(  
           striped = TRUE,
           list(date = reactable::colDef(minWidth = 140),
                wear_time = reactable::colDef(minWidth = 150),
                total_counts_axis1 = reactable::colDef(minWidth = 190),
                total_counts_vm = reactable::colDef(minWidth = 170),
                axis1_per_min = reactable::colDef(minWidth = 170),
                vm_per_min = reactable::colDef(minWidth = 170),
                total_steps = reactable::colDef(minWidth = 170),
                minutes_SED = reactable::colDef(minWidth = 150),
                minutes_LPA = reactable::colDef(minWidth = 150),
                minutes_MPA = reactable::colDef(minWidth = 150),
                minutes_VPA = reactable::colDef(minWidth = 150),
                minutes_MVPA = reactable::colDef(minWidth = 155),
                percent_SED = reactable::colDef(minWidth = 150),
                percent_LPA = reactable::colDef(minWidth = 150),
                percent_MPA = reactable::colDef(minWidth = 150),
                percent_VPA = reactable::colDef(minWidth = 150),
                percent_MVPA = reactable::colDef(minWidth = 155),
                ratio_mvpa_sed = reactable::colDef(minWidth = 160),
                total_kcal = reactable::colDef(minWidth = 205),
                mets_hours_mvpa = reactable::colDef(minWidth = 205),
                max_steps_60min = reactable::colDef(minWidth = 205),
                max_steps_30min = reactable::colDef(minWidth = 205),
                max_steps_20min = reactable::colDef(minWidth = 205),
                max_steps_5min = reactable::colDef(minWidth = 205),
                max_steps_1min = reactable::colDef(minWidth = 205),
                peak_steps_60min = reactable::colDef(minWidth = 205),
                peak_steps_30min = reactable::colDef(minWidth = 205),
                peak_steps_20min = reactable::colDef(minWidth = 205),
                peak_steps_5min = reactable::colDef(minWidth = 205),
                peak_steps_1min = reactable::colDef(minWidth = 205)
                )
           )

## ---- eval = FALSE------------------------------------------------------------
#  averaged_results <-
#    results_by_day %>%
#    average_results(minimum_wear_time = 10, fun = "mean")
#  
#  averaged_results

## ---- echo = FALSE------------------------------------------------------------
averaged_results <-
  results_by_day %>%
  average_results(minimum_wear_time = 10)

averaged_results %>% 
    reactable::reactable(
    list(valid_days = reactable::colDef(minWidth = 150),
         wear_time = reactable::colDef(minWidth = 150),
         total_counts_axis1 = reactable::colDef(minWidth = 190),
         total_counts_vm = reactable::colDef(minWidth = 170),
         axis1_per_min = reactable::colDef(minWidth = 170),
         vm_per_min = reactable::colDef(minWidth = 170),
         total_steps = reactable::colDef(minWidth = 170),
         minutes_SED = reactable::colDef(minWidth = 150),
         minutes_LPA = reactable::colDef(minWidth = 150),
         minutes_MPA = reactable::colDef(minWidth = 150),
         minutes_VPA = reactable::colDef(minWidth = 150),
         minutes_MVPA = reactable::colDef(minWidth = 155),
         percent_SED = reactable::colDef(minWidth = 150),
         percent_LPA = reactable::colDef(minWidth = 150),
         percent_MPA = reactable::colDef(minWidth = 150),
         percent_VPA = reactable::colDef(minWidth = 150),
         percent_MVPA = reactable::colDef(minWidth = 155),
         ratio_mvpa_sed = reactable::colDef(minWidth = 160),
         total_kcal = reactable::colDef(minWidth = 205),
         mets_hours_mvpa = reactable::colDef(minWidth = 195),
         max_steps_60min = reactable::colDef(minWidth = 205),
         max_steps_30min = reactable::colDef(minWidth = 205),
         max_steps_20min = reactable::colDef(minWidth = 205),
         max_steps_5min = reactable::colDef(minWidth = 205),
         max_steps_1min = reactable::colDef(minWidth = 205),
         peak_steps_60min = reactable::colDef(minWidth = 205),
         peak_steps_30min = reactable::colDef(minWidth = 205),
         peak_steps_20min = reactable::colDef(minWidth = 205),
         peak_steps_5min = reactable::colDef(minWidth = 205),
         peak_steps_1min = reactable::colDef(minWidth = 205)
         ),
    striped = TRUE
  )

