% (C) Copyright 2020 CPP_SPM developers

function test_suite = test_setBatchSmoothConImages %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_setBatchSmoothConImagesBasic()

  funcFWHM = 6;
  conFWHM = 6;

  opt = setOptions('vismotion');
  opt.subjects = {'01', '02'};

  [~, opt] = getData(opt);

  matlabbatch = {};
  matlabbatch = setBatchSmoothConImages(matlabbatch, opt, funcFWHM, conFWHM);

  expectedBatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
  expectedBatch{1}.spm.spatial.smooth.prefix = 's6';
  expectedBatch{1}.spm.spatial.smooth.data = {fullfile(opt.dir.stats, 'sub-01', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0001.nii'); ...
                                              fullfile(opt.dir.stats, 'sub-01', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0002.nii'); ...
                                              fullfile(opt.dir.stats, 'sub-01', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0003.nii'); ...
                                              fullfile(opt.dir.stats, 'sub-01', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0004.nii')};
  expectedBatch{1}.spm.spatial.smooth.dtype = 0;
  expectedBatch{1}.spm.spatial.smooth.im = 0;

  expectedBatch{2}.spm.spatial.smooth.fwhm = [6 6 6];
  expectedBatch{2}.spm.spatial.smooth.prefix = 's6';
  expectedBatch{2}.spm.spatial.smooth.data = {fullfile(opt.dir.stats, 'sub-02', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0001.nii'); ...
                                              fullfile(opt.dir.stats, 'sub-02', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0002.nii'); ...
                                              fullfile(opt.dir.stats, 'sub-02', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0003.nii'); ...
                                              fullfile(opt.dir.stats, 'sub-02', 'stats', ...
                                                       'task-vismotion_space-MNI_FWHM-6', ...
                                                       'con_0004.nii')};
  expectedBatch{2}.spm.spatial.smooth.dtype = 0;
  expectedBatch{2}.spm.spatial.smooth.im = 0;

  assertEqual(matlabbatch{1}.spm.spatial.smooth.data, expectedBatch{1}.spm.spatial.smooth.data);

end
