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


    
  
