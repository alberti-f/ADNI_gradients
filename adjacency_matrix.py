# 01 - adjacency_matrix
from sklearn.metrics import pairwise_distances
import nibabel as nib
import numpy as np
import sys

smoothed_tseries = sys.argv[1]
out_matrix = sys.argv[2]

smoothed_tseries = nib.load(smoothed_tseries).get_fdata()
adjacency_matrix = np.corrcoef(smoothed_tseries.squeeze())
print(adjacency_matrix.shape)

adjacency_matrix[adjacency_matrix < np.percentile(adjacency_matrix, 90, axis=0)] = 0
adjacency_matrix = 1 - pairwise_distances(adjacency_matrix, metric = 'cosine')

np.save(out_matrix, adjacency_matrix)