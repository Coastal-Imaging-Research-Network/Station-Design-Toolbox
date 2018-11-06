function [Iclear,Iover,Iunif] = radianceModelAzimuth(tau,azim,alpha,gamma,Rx,Ry)

% RADIANCEMODEL simulates the reflected radiance for a clear, 
% cloudy and uniform sky including the Fresnel surface reflectivity 
% for unpolarized light. The camera is fixed on the x axis looking 
% in the positive x-direction.
%
% USAGE: 
%   [Iclear,Iover,Iunif] = radianceModelAzimuth(tau,azim,alpha,gamma,Rx,Ry)
%
% INPUT:
%   tau - camera tilt from horizontal (degrees, positive down)
%   azim - camera azimuth fromx axis (degrees, positive CCW)
%   alpha - sun azimuth (degrees CCW from positive x-axis)
%   gamma - sun zenith angle (tilt in degrees from vertical)
%   Rx - cross-shore surface slope
%   Ry - alongshore surface slope
%
% OUTPUT:
%   Iclear - reflected radiance for clear sky
%   Iover - reflected radiance for overcast (cloudy) sky
%   Iunif - reflected radiance for uniform sky
%   Note: units are in relative luminance
%

warning off MATLAB:divideByZero
%%%%% Try the whole enchilada without any approximations

% deg to rad for some angles
tau = tau*pi/180; % camera tilt sensor, from horizontal
azim=azim*pi/180; % camera azimuth sensor, from x axis
gamma = gamma*pi/180; % sun zenith angle
alpha = alpha*pi/180; % sun azimuth angle

% normal vectors
C = [-cos(tau)*cos(azim)  -cos(tau)*sin(azim)  sin(tau)];
N = [-Rx(:) -Ry(:) ones(size(Ry(:)))];
N = N./repmat(sqrt(sum(N.^2,2)),1,3);
S = -repmat(C,length(Ry),1) + 2*N.*repmat(sum(N.*repmat(C,length(Ry),1),2),1,3); % sun vector
% S = -repmat(C,length(Ry(:)),1) + 2*N.*repmat(sum(N.*repmat(C,length(Ry(:)),1),2),1,3); % sun vector %correzione
  
% view angles
theta = acos(S(:,3));
beta = acos(sum(N.*repmat(C,length(Ry),1),2));
betaP = asin(sin(beta)/1.34);
%mu = theta; % sun is at nadir, no azimuthal light dependence
mu = acos(cos(gamma)*cos(theta) + sin(gamma)*sin(theta).*cos(alpha - angle(complex(S(:,1),S(:,2)))));

% radiance at the sensor, for clear sky cloudy and uniform sky
FresRef = ((sin(beta - betaP).^2)./(sin(beta + betaP).^2) + (tan(beta - betaP).^2)./(tan(beta + betaP).^2))/2; % unpolarized light
%FresRef = sin(beta - asin(sin(beta)/1.34)).^2./(sin(beta + asin(sin(beta)/1.34)).^2);
%FresRef(FresRef>1) = 0; % shadowed points can't see them in the time series
Iclear = ((1+cos(mu).^2)./(1-cos(mu))).*(1-exp(-0.32./cos(theta))).*FresRef; % assuming scattering is zero
Iclear(theta>pi/2) = ((1+cos(mu(theta>pi/2)).^2)./(1-cos(mu(theta>pi/2)))).*FresRef(theta>pi/2); % take care of spurious points
Iover = (1+2*cos(theta)).*FresRef;
Iunif = FresRef;

warning on

