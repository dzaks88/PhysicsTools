function [D, ctD] = loadDoseInterpolator(P, planId, useIEC)
%loadDoseInterpolator(P, planId, useIEC) Creates a function
%handle that can be used to evaluate values inside the ct volume. If you
%pass the transform matrix tformMatrix, then the points will be transformed
%before evaluation. Default is to use IEC.
%
% Example:
% -------
% [D, ctD] = loadDoseInterpolator(P, 'somePlanId', true);
% doseValAtIsocenter = D(0, 0, 0);

    if nargin < 3
        useIEC = true;
    end

    plan = P.db.plan.findById(planId);
    dose = P.db.dose.findById(plan.doseId);
    ctD =  ctreadDicom(P.rxFiles.get(dose.pixelDataUrl));    
    dcm2iecMat = plan.x_treatmentPositions{1}.patientFrameOfReferenceToEquipmentMappingMatrix;
    
    if useIEC
        tformMat = inv(dcm2iecMat);
    else
        tformMat = eye(4);
    end
    
    D = formGriddedInterpolant(ctD, tformMat, 'linear', 'none');
    
end

