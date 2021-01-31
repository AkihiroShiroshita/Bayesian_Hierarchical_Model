//Hierarchical model
data {
  int N;
  int N_id;
  real X[N];
  int<lower=0, upper=1> Y[N];
  int<lower=1, upper=N_id> s_id[N];
}

parameters {
  real a0;
  real b0;
  real a_id[N_id];
  real b_id[N_id];
  real<lower=0> s_a;
  real<lower=0> s_b;
}

transformed parameters{
  real a[N_id];
  real b[N_id];
  for (n in 1:N_id){
    a[n] = a0 + a_id[n]; 
    b[n] = b0 + b_id[n];
  }
}

model{
  for(id in 1:N_id){
    a_id[id] ~ normal(0, s_a);
    b_id[id] ~ normal(0, s_b);
  }
  
  for(n in 1:N){
    Y[n] ~ bernoulli_logit(a[s_id[n]]*X[n]+b[s_id[n]]);
  }
}
