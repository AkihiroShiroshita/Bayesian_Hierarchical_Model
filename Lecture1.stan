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
  for (i in 1:N){
    rr[i] ~ normal(mu, sigma);
  }
}
