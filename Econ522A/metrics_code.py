
## Object Oriented Program for Regression Basics


import numpy as np
import matplotlib.pyplot as plt
#%matplotlib inline

np.random.seed(1234)


## Generate Data

N = 1000

x1 = np.random.normal(size = N)
x2 = np.random.normal(size = N)
epsilon = np.random.normal(size = N)


## Specify Model

y = 1 + x1 + x2 + epsilon 



X = np.empty((N, 3)) # N by 3 matrix
X[:, 0] = 1 # consta_nt term
X[:, 1] = x1 # fill with x1 values
X[:, 2] = x2 # fill with x2 values


## Regression Object

class linmod(object):
    """A concrete class for linear regression"""
    

    def __init__(self, Y, X):
    # Y is a Nx1 matrix, X is NxK
        self.obs, self.regressors = X.shape
        self.Y = Y
        self.X = X
        ## Beta Estimate
        
        self.beta = np.linalg.inv((self.X.T @ self.X)) @ (self.X.T @ self.Y)
        
        ## T-Statistic
        self.resid = self.Y - self.X @  self.beta
        self.sig_hat = np.sqrt((self.resid ** 2)).sum() / (self.obs - self.regressors)

"""
    def beta_stderr(self):
        from numpy import linalg
        gamma_h = np.zeros((self.regressors, 1))
        X = np.ones((self.regressors, 3))
        for i in range(1, self.regressors):
            gamma_h[i,:] = linalg(X[:,:-i].T @ X[:,:-i]) #@ (X[:,:-i].T @ X[:,i])
        return gamma_h
            
"""

## T-stat

my_model = linmod(y, X)

gamma_hat = np.linalg.inv(my_model.X[:, [0,2]].T @ my_model.X[:, [0,2]]) @ (my_model.X[:, [0,2]].T @ my_model.X[:, 1])          
v1_hat = my_model.X[:,1] - my_model.X[:, [0,2]] @ gamma_hat            
        

denominator = np.sqrt(my_model.sig_hat ** 2 / (v1_hat.T @ v1_hat))         
    
# T-stat
my_model.beta[1] / denominator



