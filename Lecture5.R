#Random slope model
glmm_brms <- brm(
  formula = death ~ age + (age||id),
  family = bernoulli(),
  data = df_c,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"),
            set_prior("", class = "sd"))
)
glmm_brms
#Hierarchical model
length(unique(df_c$id))
data_list <- list(
  N = nrow(df_c),
  N_id = length(unique(df_c$id)),
  Y = df_c$death,
  X = df_c$age,
  s_id = df_c$id
)
data_list
glmm2 <- stan(
  file = "Lecture5.stan",
  data = data_list,
  seed = 1
)
mcmc_rhat(rhat(glmm2))
mcmc_sample <- rstan::extract(glmm2, permuted = FALSE)
head(mcmc_sample)
age_mcmc_vec <- as.vector(mcmc_sample[,,"a_id[1]"])
age_df <- data.frame(age_mcmc_sample = age_mcmc_vec)
ggplot(data = age_df, mapping = aes(x = age_mcmc_sample)) +
  geom_density(size = 1.5)
median(age_mcmc_vec)
quantile(age_mcmc_vec, probs = c(0.025, 0.975))
