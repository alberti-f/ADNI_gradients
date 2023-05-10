#!/bin/bash

subj_list="/path/to/subject_IDs.txt"
subj_dir="/path/to/subjects/data"
output_dir="/path/to/output/directory"

pip3 install -r requirements.txt


while read subj; do
    if [ -f "${output_dir}/${subj}.DM_Gradients.npy" ]; then continue; fi

    echo -e "\n$(date +"%D %T") - ${subj}"


    if [ ! -f "${subj_dir}/${subj}/fmriresults01/${subj}_V1_MR/MNINonLinear/Results/rfMRI_REST_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii" ]; then 
        ./additional_preprocessing.sh ${subj} ${subj_dir} && echo "$(date +"%D %T") - smoothing done"
    fi


    if [ ! -f "${output_dir}/${subj}.fcMatrix.rfMRI_REST1_Atlas_MSMAll_hp0_clean.npy" ]; then
        python3 adjacency_matrix.py "${subj_dir}/${subj}/fmriresults01/${subj}_V1_MR/MNINonLinear/Results/rfMRI_REST1_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii" \
                                    "${output_dir}/${subj}.fcMatrix.rfMRI_REST1_Atlas_MSMAll_hp0_clean"\ && echo "$(date +"%D %T") - adjacency matrix computed"
    fi


    python3 compute_gradients.py ${subj} "${output_dir}/${subj}.fcMatrix.rfMRI_REST1_Atlas_MSMAll_hp0_clean.npy" ${output_dir} && echo "$(date +"%D %T") - decomposition done"


    rm "${output_dir}/${subj}.fcMatrix.rfMRI_REST1_Atlas_MSMAll_hp0_clean.npy"

done < ${subj_list}

python3 align_gradients.py ${subj_list} ${output_dir} && echo -e "\n$(date +"%D %T") - alignment done"