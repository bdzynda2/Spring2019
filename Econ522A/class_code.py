# -*- coding: utf-8 -*-
"""
Created on Tue Feb 12 13:19:18 2019

Code for 522a


@author: dzynda
"""


import numpy as np
import matplotlib.pyplot as plt


np.random.seed(1234)
N = 1000

# generating standard normal dist random numbers
x1 = np.random.normal(size=N)
x2 = np.random.normal(size=N, scale=5)
epsilon = np.random.normal(size=N)

y = 1 + x1 + x2 + epsilon

X = np.empty((N, 3)) # N by 3 matrix
X[:, 0] = 1 # consta_nt term
X[:, 1] = x1 # fill with x1 values
X[:, 2] = x2 # fill with x2 values

## Estimate Beta
beta_hat = np.linalg.inv(X.T @ X) @ (X.T @ y)
beta_hat



## Residuals
epsilon_hat = y - X @ beta_hat



################################################################################
### T-stat

## Estimate Variance
sigma_hat = np.sqrt((epsilon_hat ** 2).sum() / (N - 3))


# auxiliary residuals of regressing X1 on constant and X2
gamma_hat = np.linalg.inv(X[:, [0, 2]].T @ X[:, [0, 2]]) @ (X[:, [0, 2]].T @ x1)
v1_hat = x1 - X[:, [0, 2]] @ gamma_hat



denominator_t = np.sqrt(sigma_hat ** 2 / (v1_hat.T @ v1_hat))
numerator_t = beta_hat[1] - 0
numerator_t / denominator_t

np.sqrt(np.diag(sigma_hat ** 2 / (X.T @ X)))






################################################################################
### F-stat

## H0: CB = 0 where C = [0, I]


denominator = (epsilon_hat @ epsilon_hat) / (N - 3)
C = np.zeros((2, 3))
C[:, 1:] = np.eye(2)
numerator = (C @ beta_hat).T @ np.linalg.inv(C @ np.linalg.inv(X.T @ X) @ C.T) @ (C @ beta_hat) / 2

F = numerator / denominator
F






################################################################################
### Effect of ith obs



i = 2 #This will be the ith + 1 obs in python
l = list(range(0, len(X)))

# Remove ith obs by creating an index for array that excludes it
l = l[:i] + l[i+1:]

beta_no_i = np.linalg.inv(X[l,:].T @ X[l,:]) @ (X[l,:].T @ y[l])

top = (X[i,:].T @ np.linalg.inv(X[l,:].T @ X[l,:]) @ X[i,:]) 
bottom = (1 + X[i,:].T @ np.linalg.inv(X[l,:].T @ X[l,:]) @ X[i,:])


(top / bottom) * (y[i] - X[i,:] @ beta_no_i)


################################################################################
### Find five most influential data affecting OLS estimate of the coefficient on x1i

ith_effect = np.zeros((X.shape))
beta_no_i = np.zeros((N, 3))
for i in range(0, len(X)):
    
    l = l[:i] + l[i+1:]

    beta_no_i[i,:] = np.linalg.inv(X[l,:].T @ X[l,:]) @ (X[l,:].T @ y[l])

    top = (X[i,:].T @ np.linalg.inv(X[l,:].T @ X[l,:]) @ X[i,:]) 
    bottom = (1 + X[i,:].T @ np.linalg.inv(X[l,:].T @ X[l,:]) @ X[i,:])

    ith_effect[i,:] = (top / bottom) * (y[i] - X[i,:] @ beta_no_i[i])


diff = beta_hat - beta_no_i
np.max(diff[:,1])
np.where(diff[:,1]==diff[:,1].max())
diff.sort()

def maxN(elements, n):
    return sorted(elements, reverse=True)[:n]




largest_elements = maxN(diff[:,1], 5)
largest_elements

largest_elements = np.array(largest_elements)
np.where(diff[:,1] == largest_elements)

## I do not know how in python to yield the exact index of the largest values. 
## I gave it a couple hours of searching and trying










