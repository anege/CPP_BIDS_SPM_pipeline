function test_suite = test_setBatchCoregistration %#ok<*STOUT>
    try % assignment of 'localfunctions' is necessary in Matlab >= 2016
        test_functions = localfunctions(); %#ok<*NASGU>
    catch % no problem; early Matlab versions can use initTestSuite fine
    end
    initTestSuite;
end

function test_setBatchCoregistrationBasic()

    % necessarry to deal with SPM module dependencies
    spm_jobman('initcfg');

    opt.derivativesDir = fullfile(fileparts(mfilename('fullpath')), 'dummyData');
    opt.taskName = 'vismotion';

    opt = checkOptions(opt);

    [~, opt, BIDS] = getData(opt);

    subID = '02';

    opt.orderBatches.selectAnat = 1;
    opt.orderBatches.realign = 2;

    matlabbatch = {};
    matlabbatch = setBatchCoregistration(matlabbatch, BIDS, subID, opt);

    nbRuns = 4;
    expectedBatch = returnExpectedBatch(nbRuns);
    assertEqual( ...
                matlabbatch{1}.spm.spatial.coreg.estimate.ref, ...
                expectedBatch{1}.spm.spatial.coreg.estimate.ref);
    assertEqual( ...
                matlabbatch{1}.spm.spatial.coreg.estimate.source, ...
                expectedBatch{1}.spm.spatial.coreg.estimate.source);
    assertEqual( ...
                matlabbatch{1}.spm.spatial.coreg.estimate.other, ...
                expectedBatch{1}.spm.spatial.coreg.estimate.other);

end

function expectedBatch = returnExpectedBatch(nbRuns)

    expectedBatch = {};

    expectedBatch{end + 1}.spm.spatial.coreg.estimate.ref(1) = ...
        cfg_dep('Named File Selector: Anatomical(1) - Files', ...
                substruct( ...
                          '.', 'val', '{}', {1}, ...
                          '.', 'val', '{}', {1}, ...
                          '.', 'val', '{}', {1}, ...
                          '.', 'val', '{}', {1}), ...
                substruct('.', 'files', '{}', {1}));

    expectedBatch{end}.spm.spatial.coreg.estimate.source(1) = ...
        cfg_dep('Realign: Estimate & Reslice/Unwarp: Mean Image', ...
                substruct( ...
                          '.', 'val', '{}', {2}, ...
                          '.', 'val', '{}', {1}, ...
                          '.', 'val', '{}', {1}, ...
                          '.', 'val', '{}', {1}), ...
                substruct('.', 'rmean'));

    for iRun = 1:nbRuns

        stringToUse = sprintf( ...
                              'Realign: Estimate & Reslice/Unwarp: Realigned Images (Sess %i)', ...
                              iRun);

        expectedBatch{end}.spm.spatial.coreg.estimate.other(iRun) = ...
            cfg_dep(stringToUse, ...
                    substruct( ...
                              '.', 'val', '{}', {2}, ...
                              '.', 'val', '{}', {1}, ...
                              '.', 'val', '{}', {1}, ...
                              '.', 'val', '{}', {1}), ...
                    substruct( ...
                              '.', 'sess', '()', {iRun}, ...
                              '.', 'cfiles'));

    end

end
