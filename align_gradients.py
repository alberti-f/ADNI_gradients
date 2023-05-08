# 03 - align_gradients

import sys
import numpy as np
from brainspace.gradient.alignment import ProcrustesAlignment

subject_IDs = sys.argv[1]
f = open(subject_IDs, 'r')
subject_IDs = np.array(f.read().splitlines())

output_dir = sys.argv[2]

gradients = [np.load(f"{output_dir}/{s}.DM_Gradients.npy") for s in subject_IDs]

avg_gradients = np.asarray(gradients).mean(axis=0)
np.save(f"{output_dir}/group_avg.DM_Gradients_aligned", avg_gradients)

aligner = ProcrustesAlignment()

aligned_gradients = aligner.fit(gradients).aligned_

for subject, gradient in zip(subject_IDs, aligned_gradients):
    np.save(f"{output_dir}/{subject}.DM_Gradients_aligned", gradient)


import seaborn as sns
heat_map = sns.heatmap(avg_gradients, cmap='RdBu_r', center=0)
fig = heat_map.get_figure()
fig.savefig(f"{output_dir}/group_avg.DM_Gradients_aligned.png")
