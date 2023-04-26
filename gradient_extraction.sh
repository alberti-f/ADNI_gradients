#!/bin/bash

subj_list="/home/fralberti/Data/HCP_LifeSpan/subj_IDs.txt" #"/path/to/subject_IDs.txt"
subj_dir="/home/fralberti/Data/HCP_LifeSpan" #"/path/to/subjects/data"
output_dir="/home/fralberti/Data/HCP_LifeSpan/Output" #"/path/to/output/directory"

pip install -r requirements.txt

while read subj; do

    echo $subj

    ./additional_preprocessing.sh ${subj} ${subj_dir} 1

    python3 adjacency_matrix.py "${subj_dir}/${subj}/fmriresults01/${subj}_V1_MR/MNINonLinear/Results/rfMRI_REST1_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii" \
                                "${output_dir}/${subj}.fcMatrix.rfMRI_REST1_Atlas_MSMAll_hp0_clean"

    python3 compute_gradients.py ${subj} "${output_dir}/${subj}.fcMatrix.rfMRI_REST1_Atlas_MSMAll_hp0_clean.npy" ${output_dir}

done < ${subj_list}

python3 align_gradients.py ${subj_list} ${output_dir}