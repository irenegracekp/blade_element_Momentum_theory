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
lambda = 0;

zeta=[-0.9491079123; -0.7415311855; -0.4058451513; 0.0;
0.4058451513; 0.7415311855; 0.9491079123];

w=[0.1294849661; 0.2797053914; 0.3818300505; 0.4179591836;
0.3818300505; 0.2797053914; 0.1294849661];

Index=1:7; 
a = 0;
b = 1;
c1 = (b+a)/2;       
c2 = (b-a)/2;

for j = 1:16
    theta(j) = j*pi/180;
    ct = 0;
    cq = 0;
    
    cq = @(x)(((((k*sigma.*cl_ap./16).*(sqrt(1+((32.*theta(j).*x)./(sigma.*cl_ap)))-1))./2).*sigma.*cl_ap.*((theta(j).*(x))-(((sigma.*cl_ap./16).*(sqrt(1+((32.*theta(j).*x)./(sigma.*cl_ap)))-1)).*x)))+(0.5.*sigma.*cd.*x.^3));
    ct = @(x)(0.5.*sigma.*cl_ap.*((theta(j).*(x))-(((sigma.*cl_ap./16).*(sqrt(1+((32.*theta(j).*x)./(sigma.*cl_ap)))-1)).*x)));
    
    CT = c2*sum(w(Index).*ct(c2.*(zeta(Index)+c1)));
    CQ = c2*sum(w(Index).*cq(c2.*(zeta(Index)+c1)));
    
    T(j) = CT * rho * (pi*R^2) * (omega*R)^2;
    P(j) = CQ * rho * (pi*R^2) * (omega*R)^3;
    
end

plot(theta*180/pi,T,'-*','Color','magenta')
title('Thrust v/s Pitch Graph using Guassian Method')
xlabel('Pitch (Degree)')
ylabel('Thrust (N)')

plot(theta*180/pi,P,'-*','Color','magenta')
title('Power v/s Pitch Graph using Guassian Method')
xlabel('Pitch (Degree)')
ylabel('Power (W)')