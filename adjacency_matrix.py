# 01 - adjacency_matrix

import nibabel as nib
import nupy as np
import sys

smoothed_tseries = sys.argv[1]
out_matrix = sys.argv[2]

smoothed_tseries = nib.load(smoothed_tseries).get_fdata()
adjacency_matrix = np.corcoef(smoothed_tseries.squeeze())

np.save(out_matrix, adjacency_matrix)