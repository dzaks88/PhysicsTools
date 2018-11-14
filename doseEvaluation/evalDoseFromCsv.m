function [T] = evalDoseFromCsv(P, planId, csvPathIn, csvPathOut, useIEC)
%evalDoseFromCsv(P, planId, csvPathIn, csvPathOut, useIEC) Reads a CSV file that contains a list of
%points to evaluate dose and writes the dose values back to a CSV. 
%
% Example:
% -------
% evalDoseFromCsv(P, 'vv_SBRT2_ac_statHomOff', 'test.csv', 'test.csv', true)
%
% The input CSV file should look as follows:
%%%%%%%%%%%%%%%%%%%%
% EXAMPLE CSV FILE %
%%%%%%%%%%%%%%%%%%%%
% xMm,yMm,zMm
% 0,0,0
% 0,-15
% 0,-30,0

    if nargin < 4
       csvPathOut = csvPathIn;
    end

    if nargin < 5
        useIEC = true;
    end
    
    D = loadDoseInterpolator(P, planId, useIEC);
    T = readtable(csvPathIn);
    T.doseValGy = D(T.xMm, T.yMm, T.zMm);
    
    plan = P.db.plan.findById(planId);
    
    header = {
     sprintf('Plan Name: %s', plan.name)
     sprintf('Plan Description: %s', plan.description)
     sprintf('useIEC: %s', string(logical(useIEC)))
    };
    
    fprintf('\n%s\n', strjoin(header, '\n')); disp(T); fprintf('\n');
    
    writetable(T, csvPathOut);
    appendCsvHeader(csvPathOut, header{:});
    

end

