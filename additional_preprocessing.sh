#!/bin/bash

subj=$1
subj_dir="$2/${subj}"
n=$3

func_dir="${subj_dir}/fmriresults01/${subj}_V1_MR/MNINonLinear/Results"
struct_dir="${subj_dir}/fmriresults01/${subj}_V1_MR/MNINonLinear/fsaverage_LR32k"


kernel=6
for tseries in REST${n}_AP REST${n}_PA; do

    raw="${func_dir}/rfMRI_${tseries}/rfMRI_${tseries}_Atlas_MSMAll_hp0_clean.dtseries.nii"
    smooth="${func_dir}/rfMRI_${tseries}/rfMRI_${tseries}_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii"
    
    if [ -f "${out_tseries}" ]; then
        echo "already preprocessed"
        continue
    fi

    wb_command  -cifti-smoothing "${raw}" ${kernel} ${kernel} COLUMN "${smooth}" \
                -left-surface ${struct_dir}/${subj}_V1_MR.L.midthickness_MSMAll.32k_fs_LR.surf.gii \
                -right-surface ${struct_dir}/${subj}_V1_MR.R.midthickness_MSMAll.32k_fs_LR.surf.gii
done


out_tseries="${func_dir}/rfMRI_REST${n}_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii"

if [ ! -f "${out_tseries}" ]; then
    wb_command  -cifti-merge "${out_tseries}" \
                -cifti "${func_dir}/REST${n}_AP/rfMRI_REST${n}_AP_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii" \
                -cifti "${func_dir}/REST${n}_PA/rfMRI_REST${n}_PA_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii"
fi
