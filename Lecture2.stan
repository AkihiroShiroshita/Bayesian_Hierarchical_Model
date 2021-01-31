//Linear regression
data {
  int<lower=0> N;
  vector[N] rr;
  vector[N] age;
}

parameters {
  real intercept;
  real beta;
  real<lower=0> sigma;
}

model {
  rr ~ normal(intercept + beta*rr, sigma);
}
