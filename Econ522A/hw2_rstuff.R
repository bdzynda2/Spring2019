
## Problem 14

# (a) Generate Data 

x1 = rnorm(1000, 0, 1)
x2 = rnorm(1000, 0, 1)
e = rnorm(1000, 0, 1)

y = 1 + x1 + x2 + e

x1 = as.matrix(x1)
x2 = as.matrix(x2)
e = as.matrix(e)

y = as.matrix(y)


my_lm = lm(y ~ x1 + x2)
summary(my_lm)


# (b) compute residuals



my_lm$residuals

t(my_lm$residuals) %*% x1
t(my_lm$residuals) %*% x2

## (c) verify true residuals are not orthoganol

t(e) %*% x1
t(e) %*% x2

## (d) Auxiliary Regression

aux = lm(x1 ~ x2)

solve(t(aux$residuals) %*% aux$residuals) %*% (t(aux$residuals) %*% y)
b1

## What is E(x'x)

t(x1) %*% x1



