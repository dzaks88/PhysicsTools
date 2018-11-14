function [F, xx, yy, zz] = formGriddedInterpolant(ct, tformMatrix, varargin)
%formGriddedInterpolant(ct, tformMatrix, varargin) Creates a function
%handle that can be used to evaluate values inside the ct volume. If you
%pass the transform matrix tformMatrix, then the points will be transformed
%before evaluation.

    if nargin < 2
        tformMatrix = eye(4);
    end
        
    [xx,yy,zz] = ctbounds(ct);
    
    Vol = ct.Vol;
    
    [xx,yy,zz,Vol] = ensureIncreasing(xx,yy,zz,Vol);
    
    F0 = griddedInterpolant({xx, yy, zz}, permute(Vol, [2,1,3]), varargin{:});
    F = @(xx,yy,zz) transformThenInterp(xx,yy,zz,tformMatrix, F0);
        
end

function [val] = transformThenInterp(xx, yy, zz, A, F)

    [xx,yy,zz] = applyAffine(xx,yy,zz, A);
    val = F(xx,yy,zz);

end

function [xx,yy,zz,Vol] = ensureIncreasing(xx,yy,zz,Vol)

    isIncreasing = @(xx) all(diff(xx) >= 0);
    
    if ~isIncreasing(xx)
        xx = flip(xx);
        Vol = flip(Vol, 2);
    end
    
    if ~isIncreasing(yy)
        yy = flip(yy);
        Vol = flip(Vol, 1);
    end
    
    if ~isIncreasing(zz)
        zz = flip(zz);
        Vol = flip(Vol, 3);
    end

end


function [x2,y2,z2] = applyAffine(x1,y1,z1, A)

    x2 = x1;
    y2 = y1;
    z2 = z1;

    x2(:) = A(1,1)*x1(:) + A(1,2)*y1(:) + A(1,3)*z1(:) + A(1,4)*1;
    y2(:) = A(2,1)*x1(:) + A(2,2)*y1(:) + A(2,3)*z1(:) + A(2,4)*1;
    z2(:) = A(3,1)*x1(:) + A(3,2)*y1(:) + A(3,3)*z1(:) + A(3,4)*1;
    
end