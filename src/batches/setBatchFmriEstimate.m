% (C) Copyright 2019 CPP BIDS SPM-pipeline developers

function matlabbatch = setBatchFmriEstimate(matlabbatch)

  printBatchName('estimate subject level fmri model');

  matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep( ...
                                                        'fMRI model specification SPM file', ...
                                                        substruct( ...
                                                                  '.', 'val', '{}', {1}, ...
                                                                  '.', 'val', '{}', {1}, ...
                                                                  '.', 'val', '{}', {1}), ...
                                                        substruct('.', 'spmmat'));

  matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
  matlabbatch{2}.spm.stats.fmri_est.write_residuals = 1;
end