%% Input File 1
% This file contains GUI inputs for an experiment utilizing a single camera
% system at the Pearl River

%% Camera Specs:
nameCam = 'Flir Boson 640';  % String that represents the name of the camera
                             %   E.g. 'Flir Boson 640',...

numCam = 3; % Number of cameras to be used.

focalLength = 8.7;  % Focal length of the camera lens in mm.

NU = 640;   % Width of the chip (A.K.A. sensor) in pixels
NV = 512;   % Height of the chip in pixels
ssU = 12E-3 * NU;   % The width of the chip in mm
ssV = 12E-3 * NV;   % The height of the chip in mm

tilt = 60;  % Tilt of camera in degrees, with 0 being straight down and 90 
            %   being parallel to the water surface.

heading = 235;   % Direction that camera is facing degrees, relative to North
            %   In the event of a multi-camera array, enter the azimuth of
            %   the center of the desired field of view.

cz = 12;    % Elevation of camera above water surface in meters.

olap = 5;   % Overlap of horizontal field of view of the cameras in the array in deg.

%% Site Location:
lat = 30.35233611;  % Latitude of camera station (southern hemisphere 
                    %   requires a (-) sign).

lon = -89.64583333; % Longitude of camera station (west of prime meridian 
                    %   requires a (-) sign).

epsgCode = 32616;    % EPSG code that corresponds to the appropriate UTM zone 
                     %   coordinate system.  See User Manual for how to
                     %   determine the appropriate code.

%% Paths to support routines and output directory:
supportPath = 'C:\Users\kkoetje\Documents\GitHub\Support-Routines\';   
    % Path to UAV Toolbox support routines.

outPath = 'C:\Users\kkoetje\Documents\GitHub\Station-Design-Toolbox\StationDesignGui\Outputs';    
    % Path to directory where output files will be saved.
      
%%
%    Developed at Naval Research Laboratory, Stennis Space Center (2019)
%    Public Release Number: 19-1231-0203
%
%    This program is free software: you can redistribute it and/or  
%    modify it under the terms of the GNU General Public License as 
%    published by the Free Software Foundation, version 3 of the 
%    License.

%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.

%    You should have received a copy of the GNU General Public License
%    along with this program.  If not, see
%                                <http://www.gnu.org/licenses/>.
%  