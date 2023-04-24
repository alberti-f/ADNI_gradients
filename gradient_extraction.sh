#!/bin/bash

subj_list="/path/to/subject_IDs.txt"
subj_dir="/path/to/subjects/data/"
output_dir="/path/to/output/directory/"

pip install -r requirements.txt

while read subj; do

    # python3 adjecency_matrix.py

    python3 compute_gradients.py ${subj} "${subj_dir}/${subj}/Analysis/${subj}.rfMRI_REST1_LR.Schaefer_1000.fcMatrix.csv"  ${output_dir}

done < ${subj_list}

python3 align_gradients.py ${subj_list} ${output_dir}