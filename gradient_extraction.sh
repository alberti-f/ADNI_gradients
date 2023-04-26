#!/bin/bash

subj_list= "/home/fralberti/Data/HCP_Lifespan/subj_IDs.txt" #"/path/to/subject_IDs.txt"
subj_dir= "/home/fralberti/Data/HCP_Lifespan" #"/path/to/subjects/data"
output_dir= "/home/fralberti/Data/HCP_Lifespan/Output" #"/path/to/output/directory"

pip install -r requirements.txt

while read subj; do

    ./additional_preprocessing.sh ${subj} ${subj_dir} 1

    #python3 adjecency_matrix.py

    python3 compute_gradients.py ${subj} "${subj_dir}/${subj}/Analysis/${subj}.rfMRI_REST1_LR.Schaefer_1000.fcMatrix.csv"  ${output_dir}

done < ${subj_list}

python3 align_gradients.py ${subj_list} ${output_dir}