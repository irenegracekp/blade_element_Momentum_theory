%inputs:
AR = 0;  %disk loading, base line 50-150 N/m2
q = 0;
G = 0;
r = 0;
ar = 0;
for AR = 5:0.2:20
    q = q+1;
    FT = 20*60; %in secs
    GTOWi = 600 ; %in grams
    N_r = 4 ; % no of rotors
    S = 3; % number of battery cells
    DL = 65;
    R =  100*sqrt(GTOWi*9.81/(N_r*1000*DL*pi)); % rotor radius in centimeters
    ar(q) = AR;
    c = R/100*(1/AR);   % rotor radius in centimeters
    N_b =  2; % number of blades
    nu_m = 0.8; %motor efficiency

    sigma = (N_b * c)/(pi*R/100)  ; % solidity   sigma = (N_b * c)/(pi*R)
    Payload = 200 ; %in grams
    Battery_Voltage = 3.7*S ;  %volts 

    M_r = (0.0195)*(R^2.0859)*(sigma^(-0.2038))*(N_b^0.5344) ;
    pitch = 26;
    i = 1;
    GTOW = GTOWi;
    GTOWi = GTOWi - 10;
    while abs(GTOWi-GTOW)>= 5 && i<20
        GTOWi = GTOW;
        [T,P,RPM_max,P_max,RPM] = BEMT_2(pitch, GTOWi,R,AR,N_r,N_b);
        P = P/nu_m;
        P_max = P_max/nu_m;
        C = 4*P*FT/(0.001*S*3.7*3600) ;     %C is the battery capacity in milliamperes per hour
        M_b = 0.0418*C^0.9327*S^1.0725 ;    %Battary Weight in grams

        Kv = RPM_max/Battery_Voltage ; 
        %P_max = 25.0354;
        I_max = 4*P_max/(S*3.7) ;

        l_bl = (4.8910)*(I_max)^0.1751*P_max^0.2476 ;
        d_bl = (41.45)*Kv^(-0.1919)*P_max^0.1935 ; 

        M_bl = 0.0109*Kv^0.5122*P_max^(-0.1902)*(log10(l_bl))^2.5582*(log10(d_bl))^12.8502 ;
        M_ebl = (0.8013)*(I_max)^0.9727 ;
        M_a = (1.3119)*R^1.2767*M_b^0.4587 ;


        M(i) = 4*M_r + M_b + 4*M_bl + 4*M_ebl + M_a ;

        GTOW = M(i) + Payload;
        i = i +1;

    end
    G(q) = GTOW;
    r(q) = R;
    dl(q) = DL;
end