function [T,P,RPM_max,P_max,RPM] = BEMT_2(pitch,GTOW,R,AR,N_r,N_b)


R = R/100; % rotor radius in meters
c = R/AR;

%omega = RPM*(2*pi)/60;    %radian/sec

rho = 1.225;          %kg/m^3
cl_ap = 5.73;         
cd_0 = 0.01;      

sigma = (N_b * c)/(pi*R);
cd = cd_0;
P = 0;
T = 0;
k = 1.15;
dri = 1/100000;
ri = 0:dri:1;
lambda = 0;
    ct = 0;
    cq = 0;
    for i = 1:length(ri)
        theta(i) = (pitch - 17*ri(i))*pi/180;
        lambda(i) = (sigma*cl_ap/16)*(sqrt(1+((32*theta(i)*ri(i))/(sigma*cl_ap)))-1) ;
        ct = (0.5 * sigma * cl_ap * ((theta(i)*(ri(i)^2)) - (lambda(i)*ri(i))) * dri) +ct;
        cq = (((k*lambda(i)/2)*sigma*cl_ap*((theta(i)*(ri(i)^2))-(lambda(i)*ri(i)))) + (0.5*sigma*cd*ri(i)^3))*dri + cq;
    end    
    
    T_r = GTOW*9.81/(N_r*1000) ;
    omega = sqrt(T_r/(ct*rho*pi*R^4));
    RPM = omega*60/(2*pi) ;
    
    T_max = 2*GTOW*9.81/(N_r*1000) ;
    omega_max = sqrt(T_max/(ct*rho*pi*R^4));
    RPM_max = omega_max*60/(2*pi) ;
    
    T = ct * rho * (pi*R^2) * (omega*R)^2;
    P = cq * rho * (pi*R^2) * (omega*R)^3;

    P_max = cq * rho * (pi*R^2) * (omega_max*R)^3;
end
