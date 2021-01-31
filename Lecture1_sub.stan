//Simple example
data {
  int<lower=0> N;
  vector[N] rr;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  rr ~ normal(mu, sigma);
}
