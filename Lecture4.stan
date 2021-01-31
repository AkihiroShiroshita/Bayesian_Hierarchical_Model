//Random intercept model
data {
  int N;
  int<lower=0, upper=1> death[N];
  vector[N] age;
}

parameters {
  real Intercept;
  real b_age;
  vector[N] r;
  real<lower=0> sigma_r;
}

transformed parameters{
  vector[N] lambda = Intercept + b_age*age + r;
}

model{
  r ~ normal(0, sigma_r);
  death ~ bernoulli_logit(lambda);
}
