# 01 - adjacency_matrix
import nibabel as nib
import numpy as np
import hcp_utils as hcp 
import sys

smoothed_tseries = sys.argv[1]
out_matrix = sys.argv[2]

smoothed_tseries = nib.load(smoothed_tseries).get_fdata()[hcp.struct.cortex]
adjacency_matrix = np.corrcoef(smoothed_tseries.squeeze().T)

np.save(out_matrix, adjacency_matrix)