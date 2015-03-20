numcurrcoils = 1;
magfieldmatrix = zeros(100);
 
for coil = 1 : numcurrcoils
    
    mu0 = 4.*pi.*10^(-7./4.*pi);
    coilradius = 5; %radius of coil
    
    xcord = 5;
    ycord = 5;
    zcord = 5;
    current = 1;
    heightcoil = 1; % height of coil
    numcoils = 1; % number of coils per coil
    heightpercoil = heightcoil/numcoils; %height of each coil
    heightinc = heightpercoil/360; %height increase for each theta


    for x = 1:100
        x1 = (x - xcord); %from point to center in x direction
        for y = 1:100
            y1 = (y - ycord);
            for z = 1:100
               z1 = (z - zcord);
               for num = 1:numcoils
                    for theta = 0:360
                    if theta == 0
                        vector = [(x1- coilradius) y1 z1]; %vector
                        deltaz = heightinc.*theta.*num;
                        z2 = z1 + deltaz;
                        vectordx = [0 0 deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        normvector = vector./norm(vector); 
                        R = sqrt(x1.^2 + y1.^2 + z1.^2)- coilradius;
                        dlxdr = (cross(normvectordx,normvector));
                        B = mu0.*(current.*dlxdr)./R.^3;                      
                        %magfieldmatrix(x,y,z) =  magfieldmatrix(x,y,z) + norm(B);
                    elseif (theta > 0) && (90 >= theta)
                        deltay = coilradius.*sind(theta);
                        deltax = coilradius.*cosd(theta);
                        deltaz = heightinc.*theta.*num;
                        y2 = y1 + deltay;
                        x2 = x1 + deltax;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vectordx = [deltax deltay deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        vector = [x2 y2 z2];
                        normvector = vector./norm(vector);
                        dlxdr = (cross(normvectordx,normvector));
                        B = (mu0.*(current.*dlxdr))./R.^3;                       
                        %magfieldmatrix(x,y,z) =  magfieldmatrix(x,y,z) + norm(B);
                    elseif (theta > 90) && (180 >= theta)
                        deltay = coilradius.*(1-cosd(theta));
                        deltax = coilradius.*(1+sind(theta));
                        deltaz = heightinc.*theta.*num;
                        x2 = x1 + deltax;
                        y2 = y2 + deltay;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vectordx = [deltax deltay deltaz];
                        vector = [x2 y2 z2];
                        dlxdr = cross(normvectordx,normvector);
                        B = mu0.*(current.*dlxdr)./R.^3;                       
                        %magfieldmatrix(x,y,z) =  magfieldmatrix(x,y,z) + norm(B);
                    elseif (theta > 180) && (270 >= theta)
                        deltay = coilradius.*(-cosd(theta));
                        deltax = coilradius.*(2-sind(theta));
                        deltaz = heightinc.*theta.*num;
                        x2 = x1 + deltax;
                        y2 = y2 + deltay;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vectordx = [deltax deltay deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        vector = [x2 y2 z2];
                        normvector = vector./norm(vector);
                        dlxdr = cross(normvectordx,normvector);
                        B = mu0.*(current.*dlxdr)./R.^3;                       
                        %magfieldmatrix(x,y,z) =  magfieldmatrix(x,y,z) + norm(B);
                    else
                        deltay = coilradius.*(1-cosd(theta));
                        deltax = coilradius.*(1+sind(theta));
                        deltaz = heightinc.*theta;
                        x2 = x1 + deltax;
                        y2 = y2 + deltay;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vector = [x2 y2 z2];
                        vectodx = [deltax deltay deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        normvector = vector./norm(vector);
                        dlxdr = cross(normvectordx,normvector);
                        B = mu0.*(current.*dlxdr)./R.^3;                       
                        %magfieldmatrix(x,y,z) =  magfieldmatrix(x,y,z) + norm(B)
                    end
                    end
                end
            end
        end
    end
end 
  
