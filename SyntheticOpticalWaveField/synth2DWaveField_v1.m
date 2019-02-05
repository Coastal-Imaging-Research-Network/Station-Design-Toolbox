function [W,Wx,Wy]  = synth2DWaveField(X,S,f,dirs,dt,T,h,Hs,NSR,varargin)

%synth2DWaveField will make a time series realization of a f-dir wave specrtum
%
%Usage:
%  [W,Wx,Wy] = synth2DWaveField(X,Si,f,dirs,dt,T,h,Hs,NSR,Dflag)
%
%Input:
%  X - Ne x 2 array of sampling location 
%  S - input f-dir spectrum (Nf x Nd)
%  f - Nf length vector of frequencies (Hz, 1/s)
%  dirs - Nd length vector of directions (radians)
%  dt - sample rate
%  T - time series length
%  h - water depth
%  Hs - significant wave height (negative or empty Hs indicates no scaling)
%  NSR - Noise to signal ratio (noise variance = NSR(Hs/16)^2)
%  Dflag - make deterministic Fourier series (off by default).
%          Only accepts Si as a vector and assumes Dflag is 
%          the normalized wavenumber wrt. the maximum cross-shore 
%          lag of the array, Dflag = k*Lx_max
%
%Output:
%  W - time series of wave height height at each location in X, 
%      or Fourier series is Dflag
%  Wx - time series of cross-shore wave slope
%  Wy - time series of alongshore wave slope
%

% should we make deterministic time series
if ~isempty(varargin)
  Dflag = varargin{1};
else
  Dflag = 0;  % default to off
end

% make t, k, f, dirs., and spectrum
t = [dt:dt:T]';
dfi = abs(mean(diff(f)));
ddir = abs(mean(diff(dirs)));

% to scaling or not?
if isempty(Hs) | Hs<1
  scale = sqrt(nansum(S(:))*dfi*ddir); % modificato sum con nansum
else
  scale = Hs/4; 
end 

Hs_spectrum=scale*4;
% disp(Hs_spectrum)

warning off
% make fourier amplitudes and random phases
Ns = T/dt;
%Nt = 4*Ns + 1;
Nt = Ns + 1; 
ft = [0:(Nt-1)/2]/(Nt*dt);
dft = 1/(Nt*dt);
if Dflag
  k = Dflag/range(X(:,1)); % make k fraction of cross shore array dimension
else
  k = dispsol2(h,ft,1); % use fast flag, see Dean & Dalrymple p. 72
  k(1) = 0;
end
K = repmat(k,1,length(dirs));
D = repmat(dirs,length(k),1);
Kx = K.*cos(D); KxF = [-Kx; flipud(Kx(2:end,:))];
Ky = K.*sin(D); KyF = [-Ky; flipud(Ky(2:end,:))];
if Dflag
  Amps = sqrt(S)*(Hs/4);
  AmpsN = sqrt(ones(size(Amps))/prod(size(Amps)))*sqrt(NSR)*scale;
else
  AmpsI = interp2(dirs,f,S,dirs,ft'); 
  AmpsI(isnan(AmpsI)) = 0;
  Amps = AmpsI/sum(AmpsI(:)*dft)*(2*length(ft));
  Amps = sqrt(Amps)*scale;
  AmpsN = sqrt(ones(size(Amps))/(prod(size(Amps))*dft)*(2*length(ft)))*sqrt(NSR)*scale;
end
Amps(isnan(Amps)) = 0;
randPhs = 2*pi*rand(size(Amps));

%keyboard

% simutlate time series with ifft
W = zeros(Ns,size(X,1));
Wx = W;
Wy = W;
for j = 1:size(X,1)
  % fprintf('    %d\r',j)  
  % simulate the time series 
	randPhsN = 2*pi*rand(size(AmpsN)); % need to make rand. phases for noise for each instrument!
%   phs = randPhs - Kx.*X(j,1) - Ky.*X(j,2);
  phs = randPhs + Kx.*X(j,1) + Ky.*X(j,2); %per mandare le onde verso riva
  FC = Amps.*complex(cos(phs),sin(phs)) + AmpsN.*complex(cos(randPhsN),sin(randPhsN));
  if Dflag
    W(j) = sum(FC*2,2);
    Wx(j) = nan; % no slope for the moment, could do it later
    Wy(j) = nan;
  else
    FC = [FC; conj(flipud(FC(2:end,:)))];
    Wtemp = sum(ifft(FC,[],1),2);
    WtempKx = sum(ifft(i*KxF.*FC,[],1),2);
    WtempKy = sum(ifft(i*KyF.*FC,[],1),2);
    W(:,j) = real(Wtemp(1:Ns));
    Wx(:,j) = real(WtempKx(1:Ns));
    Wy(:,j) = real(WtempKy(1:Ns));
  end
end

warning on

% written by Chris Chickadel