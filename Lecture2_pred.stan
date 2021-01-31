//Linear regression
data {
  int<lower=0> N;
  vector[N] rr;
  vector[N] age;
  int N_pred;
  vector[N_pred] age_pred;
}

parameters {
  real intercept;
  real beta;
  real<lower=0> sigma;
}

model {
  rr ~ normal(intercept + beta*rr, sigma);
}

generated quantities {
  vector[N_pred] mu_pred;
  vector[N_pred] rr_pred;
  for (i in 1:N_pred){
    mu_pred[i] = intercept + beta*age_pred[i];
    rr_pred[i] = normal_rng(mu_pred[i], sigma);
  }
}
