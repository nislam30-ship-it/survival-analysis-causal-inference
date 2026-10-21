
install.packages(c("survival", "survey", "broom", "ggplot2"))
source("01_survey_cox_survival_pipeline.R")

library(survival)
library(survey)
library(broom)
library(dplyr)

run_survival_pipeline <- function() {
  
  data(pbc, package = "survival")
  
  df_survival <- pbc %>%
    filter(!is.na(trt)) %>% 
    mutate(
      event = ifelse(status == 2, 1, 0),          
      time_years = time / 365.25,                 
      psu = id %% 10 + 1,                        
      strata = rep(1:2, length.out = n()),         
      pw = runif(n(), min = 0.5, max = 2.5)       
    )
  
  surv_design <- svydesign(
    ids = ~psu,
    strata = ~strata,
    weights = ~pw,
    nest = TRUE,
    data = df_survival
  )

  km_fit <- survfit(Surv(time_years, event) ~ trt, data = df_survival)
  print(summary(km_fit, times = c(1, 3, 5)))
  svy_cox_fit <- svycoxph(
    Surv(time_years, event) ~ trt + age + bili + albumin,
    design = surv_design
  )
  
  cox_summary <- tidy(svy_cox_fit, exponentiate = TRUE, conf.int = TRUE)
  print(cox_summary %>% select(term, estimate, std.error, statistic, p.value, conf.low, conf.high))
  std_cox_fit <- coxph(Surv(time_years, event) ~ trt + age + bili + albumin, data = df_survival)
  ph_test <- cox.zph(std_cox_fit)
  print(ph_test)
  
  return(list(survey_design = surv_design, cox_model = svy_cox_fit, ph_test = ph_test))
}

if (sys.nframe() == 0) {
  results <- run_survival_pipeline()
}
