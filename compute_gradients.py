# 02 - compute gradients

import sys
import numpy as np
from brainspace.gradient import GradientMaps

subj = sys.argv[1]

def prep_matrix(adj_matrix):
    from sklearn.metrics import pairwise_distances
    
    np.fill_diagonal(adj_matrix, 0)
    adj_matrix[adj_matrix < np.percentile(adj_matrix, 90, axis=1)] = 0
    aff_matrix = 1 - pairwise_distances(adj_matrix, metric = "cosine")
    return aff_matrix


path = sys.argv[2]
M = np.genfromtxt(path, delimiter=",")
M = prep_matrix(M)

gm = GradientMaps(n_components=200, approach="dm", kernel="normalized_angle")
gm.fit(M, sparsity=0.,  n_iter=10)

output_dir = sys.argv[3]

np.save(f"{output_dir}/{subj}.DM_Lambdas", gm.lambdas_)
np.save(f"{output_dir}/{subj}.DM_Gradients", gm.gradients_)