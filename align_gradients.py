# 03 - align_gradients

import sys
import numpy as np
from brainspace.gradient.alignment import ProcrustesAlignment

subject_IDs = sys.argv[1]
f = open(subject_IDs, 'r')
subject_IDs = np.array(f.read().splitlines())

output_dir = sys.argv[2]

gradients = [np.load(f"{output_dir}/{s}.DM_Gradients.npy") for s in subject_IDs]

aligner = ProcrustesAlignment()

aligned_gradients = aligner.fit(gradients).aligned_

for subject, gradient in zip(subject_IDs, aligned_gradients):
    np.save(f"{output_dir}/{subject}.DM_Gradients_aligned", gradient)

avg_gradients = np.asarray(aligned_gradients).mean(axis=0)
np.save(f"{output_dir}/group_avg.DM_Gradients_aligned", avg_gradients)

import seaborn as sns
plot = sns.scatterplot(x=avg_gradients[:,0], y=avg_gradients[:,1])
plot.set(xlabel ="Gradient 1", ylabel = "Gradient 2", title ='Group averge gradients')
fig = plot.get_figure()
fig.savefig(f"{output_dir}/group_avg.DM_Gradients_aligned.png")
