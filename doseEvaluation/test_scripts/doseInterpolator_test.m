testDataPath = '../test_data/doseCtVolume.mat';
ctD = load(testDataPath);
[xG,yG,zG] = ctbounds(ctD);

D = formGriddedInterpolant(ctD);
numTestPoints = 1000;

xx = rand([numTestPoints, 1])*99 - 50;
yy = rand([numTestPoints, 1])*99 - 50;
zz = rand([numTestPoints, 1])*99;

results = [];
numFail = 0;
numPass = 0;
for i = 1:numTestPoints
    
    test = struct();
    doseValCalc = D(xx, yy, zz);    
    x = xx(i);
    y = yy(i);
    z = zz(i);
        
    test.x = x;
    test.y = y;
    test.z = z;
    test.doseCalc = D(x,y,z);
    test.doseExpected = z;
    test.relError = abs(test.doseCalc - test.doseExpected)/test.doseExpected;
    doseTol = 1.0e-6;
        
    if test.relError <= doseTol
        test.result = "SUCCESS";
        numPass = numPass + 1;
    else
        test.result = "FAIL";
        numFail = numFail + 1;
    end
    
    T = struct2table(test);
    results = cat(1,results, T);
        
end
disp(results);
writetable(results, 'test_results.csv');
assert(numPass == numTestPoints, sprintf('%i/%i tests failed!', numFail, numTestPoints));

if numPass == numTestPoints
    fprintf('\n%i/%i tests passed!', numPass, numTestPoints);
end
    



fprintf('\n\n');

