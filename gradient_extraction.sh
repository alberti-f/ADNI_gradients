#!/bin/bash

subj_list="/path/to/subject_IDs.txt"
subj_dir="/path/to/subjects/data"
output_dir="/path/to/output/directory"

pip install -r requirements.txt

while read subj; do

    echo $subj

    python3 adjacency_matrix.py 

    python3 compute_gradients.py ${subj} "${output_dir}/adjacency_matrix.npy" ${output_dir}

done < ${subj_list}

python3 align_gradients.py ${subj_list} ${output_dir}