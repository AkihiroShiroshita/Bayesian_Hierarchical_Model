#Design matrix
formula_lm <- formula(rr ~ age)
X <- model.matrix((formula_lm), df_c)
head(X)
#Go to stan file
N <- nrow(df_c)
K <- 2 #independent variables + 1
Y <- df_c$rr
data_list_design <- list(N =N, K = K, Y = Y, X = X)
mcmc_result_design <- stan(
  file = "Lecture3.stan",
  data = df_c,
  seed = 1
)
#Package brms
library(brms)
simple_lm_brms <- brm(
  formula = rr ~ age,
  family = gaussian(link="identity"),
  data = df_c,
  seed = 1,
  prior = c(set_prior("", class = "Intercept"),
            set_prior("", class = "sigma")), #Non-informative prior
  chains = 4,
  iter = 2000,
  warmup = 1000,
  thin = 1
) #Default: Weak prior
#estimate = posterior mean
as.mcmc(simple_lm_brms, combine_chains = TRUE)
plot(simple_lm_brms)
stancode(simple_lm_brms)
standata(simple_lm_brms)
mcmc_plot(simple_lm_brms,
         type = "intervals",
         pars = "^b_",
         prob = 0.8,
         prob_outer = 0.95)
new_data <- data.frame(age = 40)
new_data
set.seed(1)
predict(simple_lm_brms, new_data)
fitted(simple_lm_brms, new_data)
eff <- conditional_effects(simple_lm_brms)
plot(eff, points = TRUE)
eff_pre <- marginal_effects(simple_lm_brms, method = "predict")
plot(eff_pre, points = TRUE)