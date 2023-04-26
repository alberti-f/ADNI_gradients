#!/bin/bash

subj_list= #"/path/to/subject_IDs.txt"
subj_dir= #"/path/to/subjects/data/"
output_dir= #"/path/to/output/directory/"

pip install -r requirements.txt

while read subj; do

    if [ ! -f "${subj_dir}/rfMRI_REST_All_Atlas_MSMAll_hp2000_clean_smth.dtseries.nii" ]; then
        wb_command -cifti-merge "${subj_dir}/rfMRI_REST_All_Atlas_MSMAll_hp2000_clean_smth.dtseries.nii"\
                    -cifti "${subj_dir}/${runs[0]}/${runs[0]}_Atlas_MSMAll_hp2000_clean_smth.dtseries.nii"\
                    -cifti "${subj_dir}/${runs[1]}/${runs[1]}_Atlas_MSMAll_hp2000_clean_smth.dtseries.nii"\               
    fi
    
    wb_command 

    #python3 adjecency_matrix.py

    python3 compute_gradients.py ${subj} "${subj_dir}/${subj}/Analysis/${subj}.rfMRI_REST1_LR.Schaefer_1000.fcMatrix.csv"  ${output_dir}

done < ${subj_list}

python3 align_gradients.py ${subj_list} ${output_dir}