#!/bin/bash

subj=$1
anat_dir="$2/${subj}/MNINonLinear/fsaverage_LR32k"
func_dir="$3/${subj}/MNINonLinear/Results"
n=$4

runs=(REST${n})


kernel=6
for tseries in ${runs[@]}; do

    raw="${func_dir}/rfMRI_${tseries}/rfMRI_${tseries}_Atlas_MSMAll_hp0_clean.dtseries.nii"
    smooth="${func_dir}/rfMRI_${tseries}/rfMRI_${tseries}_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii"
    
    if [ -f "${smooth}" ]; then continue; fi

    wb_command  -cifti-smoothing "${raw}" ${kernel} ${kernel} COLUMN "${smooth}" \
                -left-surface ${anat_dir}/${subj}.L.midthickness_MSMAll.32k_fs_LR.surf.gii \
                -right-surface ${anat_dir}/${subj}.R.midthickness_MSMAll.32k_fs_LR.surf.gii
done


out_tseries="${func_dir}/rfMRI_REST${n}_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii"

len=${#runs[@]}
if (( len > 1 )); then
    wb_command  -cifti-merge "${out_tseries}" \
                -cifti "${func_dir}/rfMRI_REST${n}_AP/rfMRI_REST${n}_AP_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii" \
                -cifti "${func_dir}/rfMRI_REST${n}_PA/rfMRI_REST${n}_PA_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii"
else
    mv "${func_dir}/rfMRI_${tseries}/rfMRI_${tseries}_Atlas_MSMAll_hp0_clean_smooth.dtseries.nii" ${out_tseries}
fi
