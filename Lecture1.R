##Bayesian hierarchical modeling lecture
library(tidyverse)
library(rstan)
rstan_options(auto_write = TRUE) #Avoid redundant compiling
options(mc.cores = parallel::detectCores()) 
df_o <- read_csv("sample_data.csv")
df_o %>% glimpse()
df_c <- df_o %>% na.omit()
#Simple example
#List conversion
sample_size <- nrow(df_c)
sample_size
df_list <- list(rr = df_c$rr, N = sample_size)
df_list
#Go to stan file
#Then run R codes
mcmc_result <- stan(
  file = "Lecture1.stan",
  data = df_list,
  seed = 1,
  chains = 4,
  iter = 2000,
  warmup = 1000,
  thin = 1
)
print(mcmc_result, probs = c(0.025, 0.5, 0.975))
traceplot(mcmc_result, inc_warmup = T)
traceplot(mcmc_result)
mcmc_sample <- rstan::extract(mcmc_result, permuted = FALSE)
class(mcmc_sample)
dim(mcmc_sample)
dimnames(mcmc_sample)
mcmc_sample[1, "chain:1", "mu"]
mcmc_sample[, "chain:1", "mu"]
mu_mcmc_vec <- as.vector(mcmc_sample[,,"mu"])
median(mu_mcmc_vec)
quantile(mu_mcmc_vec, probs = c(0.025, 0.975))
mu_df <- data.frame(mu_mcmc_sample = mu_mcmc_vec)
ggplot(data = mu_df, mapping = aes(x = mu_mcmc_sample)) +
  geom_density(size = 1.5)
#Another way
library(bayesplot)
mcmc_hist(mcmc_sample, pars = c("mu", "sigma"))
mcmc_dens(mcmc_sample, pars = c("mu", "sigma"))
#Autocorrelation
mcmc_acf_bar(mcmc_sample, pars = c("mu", "sigma"))
#Prediction
pred_list <- list(rr = df_c$rr, N = sample_size)
mcmc_normal <- stan(
  file = "Lecture1_pred.stan",
  data = pred_list,
  seed = 1
)
y_pred <- rstan::extract(mcmc_normal)$pred
dim(y_pred)
#Default: iter = 2000, warmup = 1000, thin =1
ppc_hist(y = df_c$rr,
         yrep = y_pred[1:5,])
#Diff MCMC sampling





