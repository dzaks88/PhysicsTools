addpath(genpath(fileparts(pwd)));
resolver = matlab.internal.language.introspective.resolveName('rxmPlanOptimize', '', false);
basePath = fileparts(resolver.nameLocation);
path = fullfile(basePath, '..', '..', '..', 'RxDB', 'vv-ac-homo');
P = rxmNewPlanSessionMock(path);
planId = 'vv_SBRT2_ac_statHomOff';

csvPathIn = 'doseCalcPoints.csv';

evalDoseFromCsv(P, planId, csvPathIn);