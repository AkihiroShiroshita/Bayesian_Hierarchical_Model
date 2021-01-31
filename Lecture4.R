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
#Hierarchical model
sample_size <- nrow(df_c)
formula <- formula(death ~ age)
design_mat <- model.matrix(formula, df_c)
data_list <- list(
  N = nrow(df_c),
  death = df_c$death,
  age = df_c$age
)
data_list
glmm <- stan(
  file = "Lecture4.stan",
  data = data_list,
  seed = 1
)
mcmc_rhat(rhat(glmm))
print(glmm,
      pars = c("Intercept", "b_age", "sigma_r"),
      probs = c(0.025, 0.5, 0.975))
#Random intercept