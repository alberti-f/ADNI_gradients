# 02 - compute gradients

import sys
import numpy as np
from mapalign.embed import compute_diffusion_map

subj = sys.argv[1]
path = sys.argv[2]
output_dir = sys.argv[3]


def prep_matrix(adj_matrix):
    from sklearn.metrics import pairwise_distances
    
    np.fill_diagonal(adj_matrix, 0)
    adj_matrix[adj_matrix < np.percentile(adj_matrix, 90, axis=1)] = 0
    aff_matrix = 1 - pairwise_distances(adj_matrix, metric = "cosine")
    return aff_matrix


M = np.load(path)
M = prep_matrix(M)

gradients, results = compute_diffusion_map(M, alpha = 0.5, n_components=10, return_result=True)

np.save(f"{output_dir}/{subj}.DM_Gradients", gradients)
np.save(f"{output_dir}/{subj}.DM_Lambdas", results['lambdas'])