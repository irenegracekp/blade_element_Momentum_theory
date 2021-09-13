R = 0.355;       %meters
c = 0.032;       %meters
N_b = 2;         %Number of blades per rotor
RPM = 1500; 
omega = RPM*(2*pi)/60;    %radian/sec

rho = 1.225;      %kg/m^3
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

for j = 1:16
    theta(j) = j*pi/180;
    ct = 0;
    cq = 0;
    for i = 1:length(ri)
        lambda(i) = (sigma*cl_ap/16)*(sqrt(1+((32*theta(j)*ri(i))/(sigma*cl_ap)))-1) ;
        ct = (0.5 * sigma * cl_ap * ((theta(j)*(ri(i)^2)) - (lambda(i)*ri(i))) * dri) +ct;
        cq = (((k*lambda(i)/2)*sigma*cl_ap*((theta(j)*(ri(i)^2))-(lambda(i)*ri(i)))) + (0.5*sigma*cd*ri(i)^3))*dri + cq;
    end
    
    T(j) = ct * rho * (pi*R^2) * (omega*R)^2;
    P(j) = cq * rho * (pi*R^2) * (omega*R)^3;
    
end

