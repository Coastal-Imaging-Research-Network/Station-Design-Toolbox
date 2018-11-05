function [data,cam,epoch,xyz,W] = synthTimestack(wave,grid,camera,h,dt,T,idPlot)

% SYNTHTIMESTACK will make synthetic sea surface and
% optical surface time series.

% STEP 1 - Build analytical spectrum. 
% STEP 2 - Make synthetic sea surface elevation.
% STEP 3 - Simulate the reflected radiance for clear, cloudy and uniform 
%          sky including the Fresnel surface reflectivity for unpolarized 
%          light. 
% STEP 4 - Define the Timestack in a structure readable by cBathy
% The camera is fixed on the x axis looking in the positive x-direction.
% Note: in the current version azimuth and tilt are variable, but there is
% the possibility changing the formulation in lines 166,167 to fix their value.
%
% USAGE: 
%   [data,cam,epoch,xyz,W] = synthTimex(wave,grid,camera,h,dt,T,idPlot)
% 
% INPUT:
%   wave=[Tp Hs theP s] - wave parameters, Tp(s) is the peak period, Hs(m) 
%                         is the significant wave height,theP(deg) is the
%                         peak wave direction and s is the spreading 
%                         parameter.
%   grid=[x0 x1 dx y0 y1 dy] - extension of the analysis grid  in meters, 
%                              x0 and y0 are the first coordinate of the 
%                              grid, x1 and y1 are the last coordinate
%                              of the grid,dx and dy are the resolution in 
%                              x and y direction respectively. 
%   camera=[hcam alpha gammaS] - camera parameters, hcam is the camera
%                                height, alpha and tilt are the azimuth 
%                                angle and the tilt angle, respectively.
%   h - water depth in meters
%   dt - time sample rate
%   T - time series length
%   idPlot - set idPlot=1 to display images, set idPlot=0 to do not display 
%            images
%
% OUTPUT:
%   data - optical time series
%   cam - indices of the used cameras
%   epoch - Argus time
%   xyz - analys grid
%   W - sea surface time series

% Example:
%   [data,cam,epoch,xyz,W]=synthTimestack([10 2 0 5],[100 600 5 0 800 5],[25 45 0],7,0.5,300,1);
%


switch nargin
    case 1
      error('not enough inputs')
    case 2
      error('not enough inputs')
    case 3
      error('not enough inputs')
    case 4
      error('not enough inputs')
    case 5
      error('not enough inputs')
    case 6
      error('not enough inputs')
    case 7  
    otherwise
    error('too many inputs')
end


%% STEP 1 
% Design frequency-direction spectra 

%frequency dependent wave spectrum (Carter,1982)
Tp=wave(1); 
Hs=wave(2);
f_max=6*1/Tp;
f_int=1/1000;
f=0:f_int:f_max;        % frequency range
pfact = 3.3;        % peak factor
Tz=Tp/1.286;
for i=1:length(f)
    if Tp*f(i)<=1; sigma(i)=0.07; elseif Tp*f(i)>1; sigma(i)=0.09; end
end
a=exp(-(1.286.*Tz.*f-1).^2./(2*sigma.^2));
SS=pfact.^a.*0.0749.*Hs.^2.*Tz.*(Tz*f).^(-5).*exp(-0.4567./(Tz.*f).^4);

%directional distribution (Nwogu et al.,1987)
s=wave(4);
theP=wave(3); %peak direction (degree)
thetaP=deg2rad(theP);
theta=deg2rad([-180:5:180]);
G=(1/pi^0.5).*(gamma(s+1)/gamma(s+1/2));
for i=1:length(theta)
    if abs(theta(i)-thetaP)<(pi/2)
        D(i)=G.*((cos(theta(i)-thetaP)).^(2.*s));
    else
        D(i)=0;
    end
end

%analytic frequency-directional spectra
S3=SS'*D;
if idPlot==1
    figure;
    contour((rad2deg(theta))',(f)',S3,20);
    axis([-180 180 0 f_max])
    xlabel('direction')
    ylabel('frequency')
    colorbar
    colormap jet
end

%% STEP 2
% Make synthetic sea surface elevation time series using the designed spectrum, in the specific array.

%define the grid
x=[grid(1):grid(3):grid(2)]';
y=[grid(4):grid(6):grid(5)]';
[xx,yy]=meshgrid(x,y);
X=[xx(:),yy(:)];

%define parameters
S=S3; 
dirs=theta; 
Hs=[];  
NSR=0.001;  
Dflag=0;  %0=default

%Sea surface
[W,Wx,Wy] = synth2DWaveField_v1(X,S,f,dirs,dt,T,h,Hs,NSR,Dflag);
        
if idPlot==1
    frame=input(['Which frame do you want to show? (from 1 to ', num2str(size(W,1)),')    ']);
    sup=W(frame,:);
    sup_1=reshape(sup,length(y),length(x));
    figure
    imag1=imagesc(x,y,sup_1);
    axis image
    axis xy
    xlabel('x (m)')
    ylabel('y (m)')
    title(['Synthetic sea surface elevation   frame n°',num2str(frame)])
    colorbar
    colormap jet
end

%% STEP 3
% Build an image with simulated reflected radiance

%camera parameters
hcam=camera(1);
alpha=camera(2); %sun azimuth
gammaS=camera(3);  %sun zenith
tau=atand(hcam./sqrt(xx.^2+yy.^2));  %tau=fixedTau*ones(size(xx)); %
azim=atand(yy./xx);   %azim=fixedAzim*ones(size(xx)); % 

%radiance 
for i=1:size(Wx,2)
Rx=Wx(:,i);
Ry=Wy(:,i);
[Iclear(:,i),Iover(:,i),Iunif(:,i)] = radianceModel_v1(tau(i),azim(i),alpha,gammaS,Rx,Ry);
end

if idPlot==1 
    foto=Iunif(frame,:);
    foto_1=reshape(foto,length(y),length(x));
    figure
    imagesc(x,y,foto_1);
    axis image
    axis xy
    xlabel('x (m)')
    ylabel('y (m)')
    title(['Simulated reflected radiance, Iunif  frame n°',num2str(frame)])
    colorbar
    colormap gray
    caxis([0 1])

    foto=Iclear(frame,:);
    foto_1=reshape(foto,length(y),length(x));
    figure
    imagesc(x,y,foto_1);
    axis image
    axis xy
    xlabel('x (m)')
    ylabel('y (m)')
    title(['Simulated reflected radiance, Iclear   frame n°',num2str(frame)])
    colorbar
    colormap gray
    caxis([0 1])
    
    foto=Iover(frame,:);
    foto_1=reshape(foto,length(y),length(x));
    figure
    imagesc(x,y,foto_1);
    axis image
    axis xy
    xlabel('x (m)')
    ylabel('y (m)')
    title(['Simulated reflected radiance, Iover   frame n°',num2str(frame)])
    colorbar
    colormap gray
    caxis([0 1])
end

%% STEP 4
% cBathy variables

sky=input('Choose sky conditions. Write: Iclear, Iover or Iunif.    ','s');
eval(['data=',sky,';'])
cam=ones(size(Iunif,2),1);
date=matlab2Epoch('01-Jan-2018 12:00:00'); 
epoch=[date+dt:dt:date+T]';
epoch=epoch';
xyz=[X(:,1), X(:,2), zeros(size(X,1),1)];


% check the timestack:
if idPlot==1
    transect=input(['Which transect do you want? (from 1 to ', num2str(length(y)),')      ']);  %total transect= lenght(y)
    while transect>length(y)
        disp('not valid transect')
        transect=input(['Which transect do you want? (from 1 to ', num2str(length(y)),')      ']);  %total transect= lenght(y)
    end
    iAlongshore = find(xyz(:,2) == y(transect));   %n°y
    tempo=epoch-epoch(1);
    figure;
    imagesc(x,tempo,data(:,iAlongshore))
    xlabel('cross-shore direction (m)')
    ylabel('time (s)');
    colormap gray
    title('Simulated Timestack')
end

end



