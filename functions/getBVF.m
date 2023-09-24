function [N_squared,N] = getBVF(T1,T0,Z1,Z0,P0,varargin)
% function [BVF] = getBVF(T1,T2,z1,z2,varargin) computes the Brunt–Väisälä
% frequency from the potential virtual temperature and bulk method.
%
% Inputs
% T1: float [1x1]: Virtual potential temperature at height Z1
% T2: float [1x1]: Virtual potential temperature at height Z2
% Z1: float [1x1]: height no1 above the surface
% Z2: float [1x1]: height no2 above the surface
%
% Output
% BVF:  float [1x1]: Brunt-Vaisala frequency
%
% Author: E. Cheynet - UiB - 2020

%% Inputparseer
q = inputParser();
q.CaseSensitive = false;
q.addOptional('g',9.81); % Earth-surface gravitational acceleration
q.addOptional('RH1',zeros(size(T1))); % rh at z1
q.addOptional('RH0',zeros(size(T0))); % rh at the surface
q.parse(varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%
g = q.Results.g ;
RH1 = q.Results.RH1 ;
RH0 = q.Results.RH0 ;


% Get virtual potential temperature at the surface
[~,thetaV0] = calcPoT(P0(:),T0(:),RH0(:)); % 100 % humidity at the surface

% Get pressure at height Z1 from the suface measurements
[P1,P1_baro] = getP_hydrostatic(P0(:),T0(:),Z1(:));
% Get virtual potential temperature at Z1
[~,thetaV1] = calcPoT(P1(:),T1(:),RH1(:)); % 100% humidity at the Z1

% Get average virtual potential temperature
thetaV = 0.5.*(thetaV1(:) + thetaV0(:));
dT = thetaV1-thetaV0;
dZ = Z1-Z0;

N_squared = g./thetaV .*dT./dZ;



N= N_squared;
N(N_squared>0) = sqrt(N_squared(N_squared>0));
N(N_squared<0) = -sqrt(-N_squared(N_squared<0));











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
        
        if nanmin(T)>200, T = T-273.15; end
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
        E = Es.*RH./100;
        
        
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
        
        if nanmin(P)>7e4, P = P./100; end % to get hPa;
        
        e = calcE(T(:),RH);
        q_v = 0.622.*e./(P(:));
        
        
        % Potential Temperature
        theta = T(:).*(1000./P(:)).^0.286;
        % Virtual potential temperature
%         thetaV = T_v(:).*(1000./P(:)).^0.286;
        thetaV = theta(:).*(1+0.608*q_v(:));
        
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
        
        % hydrostatic atmosphere
        L = -6.5e-3;% Lapse rate
        Rp = 287.053; %  specific gas constant = 287.053 J/(kg K)
        P_l = P0.*(1+(L.*z)./T0).^(-g/(L*Rp));
    end
end

