#Simple logistic regression
library(brms)
library(bayesplot)
df_c <- df_c %>% 
  mutate(ams=as.factor(ams),
         id=as.factor(id))
glm_bernoulli_brms <- brm(
  death ~ count*ams + age + rr + hr + adl,
  family = bernoulli(),
  data = df_c,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"))
)
glm_bernoulli_brms
#Random intercept model 
formula <- formula(death ~ age)
design_mat <- model.matrix(formula, df_c)
data_list <- list(
  N = nrow(df_c),
  death = df_c$death,
  age = df_c$age
)
data_list
glmm1 <- stan(
  file = "Lecture4.stan",
  data = data_list,
  seed = 1
)
mcmc_rhat(rhat(glmm1))
print(glmm1,
      pars = c("Intercept", "b_age", "sigma_r"),
      probs = c(0.025, 0.5, 0.975))
mcmc_sample <- rstan::extract(glmm1, permuted = FALSE)
age_mcmc_vec <- as.vector(mcmc_sample[,,"b_age"])
age_df <- data.frame(age_mcmc_sample = age_mcmc_vec)
ggplot(data = age_df, mapping = aes(x = age_mcmc_sample)) +
  geom_density(size = 1.5)
#Another way
glmm_brms <- brm(
  formula = death ~ age + (1|id),
  family = bernoulli(),
  data = df_c,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"),
            set_prior("", class = "sd"))
)
glmm_brms
