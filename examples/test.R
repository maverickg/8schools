library(rstan8schools)
dat <- list(J = as.integer(8), 
            y = c(28,  8, -3,  7, -1,  1, 18, 12),
            sigma = c(15, 10, 16, 11,  9, 11, 10, 18))

nullf <- function() { }

schmod <- new(stan_fit4model6d76abeee19_schools_code, dat, nullf)

args <- list(init = 0, seed = 3, method = 'sampling')

s <- schmod$call_sampler(args)

print(s)
