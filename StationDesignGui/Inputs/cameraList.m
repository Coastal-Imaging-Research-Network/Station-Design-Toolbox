% This file defines the number of pixels and field of view based on the
% type of camera specified and the focal length of the lens in mm
% This info is based on best available info about chip from camera and chip
% companies, and is likely to be slightly inaccurate, but provides a 
% ballpark estimate until you can actually buy the camera and measure the
% field of view
% M. Palmsten, NRL, 2/2015; K. Koetje, NRL, 08/2018


%% Needed vars
%   cflag:  A number flag to define each camera on the list
%   cname:  A string containing the name of the camera model
%   NU:     The width of the chip (A.K.A. sensor) in pixels
%   NV:     The height of the chip in pixels
%   ssU:    The width of the chip in mm
%   ssv:    The height of the chip in mm
% **Note that the width and height of the chip/sensor in mm is not always 
% given by the manufacturer. Sometimes only the diagonal "width" of the
% sensor is provided, in which case ssU = diagonal*sin(atan(NU/NV))
% and ssV = diagonal*cos(atan(NU/NV)). Sometimes the pixel pitch, or size 
% in mm of a single pixel, is given. In this case, ssU = pixelPitch*NU and
% ssV = pixelPitch*NV.
%

cflag = 1;
camList(cflag).cname = 'Flir Boson 640';
camList(cflag).NU = 640;
camList(cflag).NV = 512;
pp = 12E-3;  %pixel pitch
camList(cflag).ssU = pp * camList(cflag).NU;
camList(cflag).ssV = pp * camList(cflag).NV;

cflag = 2;
camList(cflag).cname = 'Point Grey Grasshopper 3 60S6C-C';
camList(cflag).NU = 2750;
camList(cflag).NV = 2200;
camList(cflag).ssU = 15.989.*sin(atan(camList(cflag).NU/camList(cflag).NV));
camList(cflag).ssV = 15.989.*cos(atan(camList(cflag).NU/camList(cflag).NV));

cflag = 3;
camList(cflag).cname = 'Point Grey Grasshopper 14S5M-C';
camList(cflag).NU = 1360;
camList(cflag).NV = 1024;
camList(cflag).ssU = 10.2;
camList(cflag).ssV = 7.68;

cflag = 4;
camList(cflag).cname = 'Point Grey Blackfly 5.0 MP';
camList(cflag).NU = 2448;
camList(cflag).NV = 2048;
pp = 12E-3;  %pixel pitch
camList(cflag).ssU = pp * camList(cflag).NU;
camList(cflag).ssV = pp * camList(cflag).NV;

cflag = 5;
camList(cflag).cname = 'GoPro HERO 6 Black (4k video mode)';
camList(cflag).NU = 3840;
camList(cflag).NV = 2160;
camList(cflag).ssU = 6.17;
camList(cflag).ssV = 4.63;

%% Create new camera
% Fill in variables below:
%
% cflag = 6;
% camList(cflag).cname = ' ';
% camList(cflag).NU =       ;
% camList(cflag).NV =       ;
% camList(cflag).ssU =      ;
% camList(cflag).ssV =      ;


%%
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