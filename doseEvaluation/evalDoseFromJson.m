function [J] = evalDoseFromJson(P, jsonPath)
%evalDoseFromJson(P, jsonPath) Reads a JSON file that contains a list of
%plan ids and points at which to evaluate the dose volume. The resulting
%dose values are written to the same JSON.
%
% Example:
% -------
% evalDoseFromJson(P, 'doseCalcPoints.json')
%
% The input JSON should be formatted follows:
% [
% 	{
% 		"planId": "vv_SBRT2_ac_statHomOff",
% 		"useIEC": 1,
% 		"pointsXyzMm": [
% 			[0,0,0],
% 			[0,-15,0],
% 			[0,-30,0]
% 		]
% 	},
%     {
% 		"planId": "some_Plan_id",
% 		"useIEC": 1,
% 		"pointsXyzMm": [
% 			[0,0,0],
% 			[0,-15,0],
% 			[0,-30,0]
% 		]
% 	},
%     
% ]

    J = loadjson(jsonPath);
        
    nPlans = numel(J);
    for i = 1:nPlans
        
        % Initialize dose interpolator
        if ~isfield(J{i},'useIEC') || isempty(J{i}.useIEC)
            J.useIEC = true;
        end
        
        [D] = loadDoseInterpolator(P, J{i}.planId, J{i}.useIEC);
        xMm = J{i}.pointsXyzMm(:,1); yMm = J{i}.pointsXyzMm(:,2); zMm = J{i}.pointsXyzMm(:,3);
        doseValGy = D(xMm, yMm, zMm);
                
        % Write results to JSON
        plan = P.db.plan.findById(J{i}.planId);
        
        upd = struct( ...
            'planId', plan.id, ...
            'planName', plan.name, ...
            'planDescription', plan.description, ...
            'useIEC', J{i}.useIEC, ...
            'pointsXyzMm', J{i}.pointsXyzMm, ...
            'doseValGy', doseValGy);
                
        J{i} = upd;
        displayDoseTable(J{i});
        savejson('',J,jsonPath);
    end
end


function displayDoseTable(S)

    fprintf('\nPlan Name: %s', S.planName);
    fprintf('\nPlan Description: %s', S.planDescription);
    fprintf('\nuseIEC: %s\n', string(logical(S.useIEC)));
    T.xMm = S.pointsXyzMm(:,1);
    T.yMm = S.pointsXyzMm(:,2);
    T.zMm = S.pointsXyzMm(:,3);
    T.doseValGy = S.doseValGy;
    T = struct2table(T);
    disp(T);
    fprintf('\n\n\n');

end