function [Rb] = getBulkRi(T0,T1,Z0,Z1,U0,U1,V0,V1,RH1,RH0,P0)
%  [[Rb] = getBulkRi(T1,T2,Z1,Z2,U1,U2,varargin) computes the Bulk
%  Richardson number
%
% Inputs
% T1: float [1x1]: absolute temperature at height Z1
% T2: float [1x1]: absolute temperature at height Z2
% Z1: float [1x1]: height no1 above the surface
% Z2: float [1x1]: height no2 above the surface
% U1: float [1x1]: mean wind speed at height Z1
% U2: float [1x1]: mean wind speed at height Z2
% %
% Output
% Rb:  float [1x1]: Bulk Richardson number
%
% Author: E. Cheynet - UiB - 2020

%%
G = 9.81; % gravitational acceleration

% Get pressure at height Z1 from the suface measurements
[P1] = getP_hydrostatic(P0,T0,Z1);
% Get virtual potential temperature at the surface
[~,thetaV0] = calcPoT(P0,T0,RH0); % 100% humidity at the surface
% Get virtual potential temperature at Z1
[~,thetaV1] = calcPoT(P1,T1,RH1); % 100% humidity at the surface
% Get average virtual potential temperature
thetaV = 0.5.*(thetaV1(:) + thetaV0(:));

%% get Bulk Richardson number

dZ = Z1(:)-Z0(:);
dT = (thetaV1(:)-thetaV0(:));
dU = (U1(:)-U0(:));
dV = (V1(:)-V0(:));
rho = G./thetaV;
Rb = rho.*dT.*dZ./(dU.^2 + dV.^2);



    function [Es] = calcESAT(T,varargin)
        %  function [Es] = calcESAT(T) computes the the water vapour saturation
        %  pressure using the Guide to Meteorological Instruments and Methods of
        % Observation (CIMO Guide)
        %
        % Input
        % T: double [1x1]: Air Temperature at the Height of interest (in Kelvin)
        %
        % Output
        % Es: double [1x1]: water vapour saturation pressure in hPa
        %
        % Author: E. Cheynet, Adapted From Christiane Duscha's toolbox (UiB)
        % Last modified: 28/01/2020
        %
        
        %% Inputparseer
        p = inputParser();
        p.CaseSensitive = false;
        p.addOptional('A',6.112); % empirical parameter
        p.addOptional('m',17.62); % empirical parameter
        p.addOptional('Tn',243.12); % empirical parameter
        p.parse(varargin{:});
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        A = p.Results.A ;
        m = p.Results.m ;
        Tn = p.Results.Tn ;
        
        if T>200, T = T-273.15; end
        Es = A.*exp((m.*T)./(Tn+T));
        
        
    end
    function [E] = calcE(T,RH)
        %  function  [E] = calcE(T,RH,varargin) computes the the water vapour saturation
        %  pressure using the Guide to Meteorological Instruments and Methods of
        % Observation (CIMO Guide)
        %
        % Input
        % T: double [1x1]: Air Temperature at the Height of interest (in Kelvin)
        % RH: double [1x1]: Relative humidty of the air (in %)
        %
        % Output
        % E: double [1x1]: water vapour pressure in hPa
        %
        % Author: E. Cheynet, Adapted From Christiane Duscha's toolbox (UiB)
        % Last modified: 28/01/2020
        %
        
        %% Inputparseer
        
        Es = calcESAT(T);
        E = Es.*RH/100;
        
        
    end
    function [theta,thetaV] = calcPoT(P,T,RH)
        %  function  [Theta,thetaV] = calcPoT(inputArg1,inputArg2) calculates the
        %  potential and virtual potential temperature.
        %
        % Input
        % T: double [1x1]: Air Temperature at height z (in Kelvin)
        % P: double [1x1]: Atmospheric pressure at height z (in hPa)
        % RH: double [1x1]: Relative humidty of the air (in %)
        %
        % Output
        % r: double [1x1]: mixing ratio
        %
        % Author: E. Cheynet, Adapted From Christiane Duscha's toolbox (UiB)
        % Last modified: 28/01/2020
        %
        
        e = calcE(T,RH);
        q_v = 0.622.*e./P;
        
        % Estimate virtual temperature
        T_v = T(:).*(1+0.608*q_v(:));
        
        % Potential Temperature
        theta = T(:).*(1000./P(:)).^0.286;
        
        % Virtual potential temperature
        thetaV = T_v(:).*(1000./P(:)).^0.286;
        
    end
    function [P_l,P_baro] = getP_hydrostatic(P0,T0,z,varargin)
        
        %% Inputparseer
        p = inputParser();
        p.CaseSensitive = false;
        p.addOptional('g',9.81); % Earth-surface gravitational acceleration
        p.addOptional('cp',1004.68506); % Constant-pressure specific heat
        p.addOptional('M',0.0289644); % Molar mass of dry air
        p.addOptional('R',8.314462618); % Universal gas constant
        p.parse(varargin{:});
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        cp = p.Results.cp ;
        g = p.Results.g ;
        M = p.Results.M ;
        R = p.Results.R ;
        
        
        % barometric formula
        B = (M.*g.*z)./(R.*T0);
        P_baro = P0.*exp(-B);
 
        L = -6.5e-3;% Lapse rate
        Rp = 287.053; %  specific gas constant = 287.053 J/(kg K)
        P_l = P0.*(1+(L.*z)./T0).^(-g/(L*Rp));
    end
end

