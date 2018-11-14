addpath(genpath(fileparts(pwd)));
resolver = matlab.internal.language.introspective.resolveName('rxmPlanOptimize', '', false);
basePath = fileparts(resolver.nameLocation);
path = fullfile(basePath, '..', '..', '..', 'RxDB', 'vv-ac-homo');

P = rxmNewPlanSessionMock(path);
jsonPathIn = 'doseCalcPoints.json';
evalDoseFromJson(P, jsonPathIn);