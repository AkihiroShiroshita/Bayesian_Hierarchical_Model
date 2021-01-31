#Linear regression
ggplot(df_c, aes(x = age, y = rr)) +
  geom_point()
data_list <- list(
  N = sample_size,
  rr = df_c$rr,
  age = df_c$age
)
mcmc_result <- stan(
  file = "Lecture2.stan",
  data = data_list,
  seed = 1
) #Not convergent
print(mcmc_result, probs = c(0.025, 0.5, 0.975))
mcmc_sample <- rstan::extract(mcmc_result, permuted = FALSE)
mcmc_combo(
  mcmc_sample,
  pars = c("intercept", "beta", "sigma")
)
#Prediction
age_pred <- 40:80
age_pred
data_list_pred <- list(
  N = sample_size, 
  rr = df_c$rr,
  age = df_c$age,
  N_pred = length(age_pred),
  age_pred = age_pred
)
mcmc_result_pred <- stan(
  file = "Lecture2_pred.stan",
  data = data_list_pred,
  seed = 1
)
print(mcmc_result_pred, probs = c(0.025, 0.5, 0.975))
mcmc_sample_pred <- rstan::extract(mcmc_result_pred, permuted = FALSE)
class(mcmc_sample_pred)
mcmc_intervals(
  mcmc_sample_pred,
  regex_pars = c("rr_pred."),
  prob = 0.8,
  prob_outer = 0.95
)
mcmc_areas(
  mcmc_sample_pred,
  pars = c("")
)
