% (C) Copyright 2019 CPP_SPM developers

function test_suite = test_setBatchSkullStripping %#ok<*STOUT>
  try % assignment of 'localfunctions' is necessary in Matlab >= 2016
    test_functions = localfunctions(); %#ok<*NASGU>
  catch % no problem; early Matlab versions can use initTestSuite fine
  end
  initTestSuite;
end

function test_setBatchSkullStrippingBasic()

  subLabel = '01';

  opt = setOptions('vislocalizer', subLabel);

  [BIDS, opt] = getData(opt);

  opt.orderBatches.segment = 2;

  matlabbatch = {};
  matlabbatch = setBatchSkullStripping(matlabbatch, BIDS, opt, subLabel);

  expected_batch = returnExpectedBatch(opt);

  assertEqual(matlabbatch, expected_batch);

end

function expected_batch = returnExpectedBatch(opt)

  expectedFileName = 'sub-01_ses-01_T1w.nii';

  expectedAnatDataDir = fullfile(fileparts(mfilename('fullpath')), ...
                                 'dummyData', 'derivatives', 'cpp_spm', ...
                                 'sub-01', 'ses-01', 'anat');

  imcalc.input(1) = cfg_dep( ...
                            'Segment: Bias Corrected (1)', ...
                            substruct( ...
                                      '.', 'val', '{}', {2}, ...
                                      '.', 'val', '{}', {1}, ...
                                      '.', 'val', '{}', {1}), ...
                            substruct( ...
                                      '.', 'channel', '()', {1}, ...
                                      '.', 'biascorr', '()', {':'}));

  imcalc.input(2) = cfg_dep( ...
                            'Segment: c1 Images', ...
                            substruct( ...
                                      '.', 'val', '{}', {2}, ...
                                      '.', 'val', '{}', {1}, ...
                                      '.', 'val', '{}', {1}), ...
                            substruct( ...
                                      '.', 'tiss', '()', {1}, ...
                                      '.', 'c', '()', {':'}));

  imcalc.input(3) = cfg_dep( ...
                            'Segment: c2 Images', ...
                            substruct( ...
                                      '.', 'val', '{}', {2}, ...
                                      '.', 'val', '{}', {1}, ...
                                      '.', 'val', '{}', {1}), ...
                            substruct( ...
                                      '.', 'tiss', '()', {2}, ...
                                      '.', 'c', '()', {':'}));
  imcalc.input(4) = cfg_dep( ...
                            'Segment: c3 Images', ...
                            substruct( ...
                                      '.', 'val', '{}', {2}, ...
                                      '.', 'val', '{}', {1}, ...
                                      '.', 'val', '{}', {1}), ...
                            substruct( ...
                                      '.', 'tiss', '()', {3}, ...
                                      '.', 'c', '()', {':'}));

  imcalc.output = ['m' strrep(expectedFileName, '.nii', '_skullstripped.nii')];
  imcalc.outdir = {expectedAnatDataDir};
  imcalc.expression = sprintf('i1.*((i2+i3+i4)>%f)', opt.skullstrip.threshold);
  imcalc.options.dtype = 16;

  expected_batch = {};
  expected_batch{end + 1}.spm.util.imcalc = imcalc;

  % add a batch to output the mask
  imcalc.expression = sprintf('(i2+i3+i4)>%f', opt.skullstrip.threshold);
  imcalc.output = ['m' strrep(expectedFileName, '.nii', '_mask.nii')];

  expected_batch{end + 1}.spm.util.imcalc = imcalc;

end
