//Simple example
data {
  int<lower=0> N;
  vector[N] rr;
}

parameters {
  real<lower=1> mu;
  real<lower=0> sigma;
}

model {
  rr ~ normal(mu, sigma);
}

generated quantities{
  vector[N] pred;
  for (i in 1:N){
    pred[i] = normal_rng(mu, sigma);
  }
}
