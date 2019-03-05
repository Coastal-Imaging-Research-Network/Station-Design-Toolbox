function [] = makeStationDesignFigures(outPath, az, XYZVertices, res, dcRange, daRange, dcProj, daProj, cxyz, lat, lon, epsgCode)

% plot the camera footprint
f = figure;
hold on
grid on
for ii = 1:size(az,2)
    plot([XYZVertices{ii}(:,1); XYZVertices{ii}(1,1)],[XYZVertices{ii}(:,2) ;XYZVertices{ii}(1,2)]);
end
axis image
xlabel('X (m)')
ylabel('Y (m)')
title('Camera Footprints')
plot(cxyz(1,1),cxyz(1,2),'*k')
limx = get(gca,'XLim');
limy = get(gca,'YLim');
saveas(f,fullfile(outPath,'Footprint'),'png')

% imagesc of the cross-range resolution
f = figure;
hold on
grid on
imagesc(res{1}.x,res{1}.y, min(dcRange,[],3))
plot(cxyz(1,1), cxyz(1,2),'*k');
axis image
c = colorbar;
c.Label.String = 'Image Resolution (m)';
title(['Cross-range Resolution'])
xlabel('X (m)')
ylabel('Y (m)')
set(gca,'XLim',limx,'YLim',limy)
saveas(f,fullfile(outPath,'CrossRangeRes'),'png')

% imagesc of the along range resolution
f = figure;
hold on
grid on
imagesc(res{1}.x,res{1}.y, min(daRange,[],3))
plot(cxyz(1,1), cxyz(1,2),'*k')
axis image
c = colorbar;
c.Label.String = 'Image Resolution (m)';
title(['Along-range Resolution'])
xlabel('X (m)')
ylabel('Y (m)')
set(gca,'XLim',limx,'YLim',limy)
saveas(f,fullfile(outPath,'AlongRangeRes'),'png')

% %% ALONGSHORE/CROSS-SHORE RESOLUTION PLOTS ARE CURRENTLY DISABLED. 
% % Future versions of this tool may include the ability to specify a 
% % shoreline orientation in the local coordinate system.
%
% f = figure;
% hold on
% grid on
% imagesc(res{1}.x,res{1}.y, min(dcProj,[],3))
% plot(cxyz(1,1), cxyz(1,2),'*k')
% axis image
% c = colorbar;
% c.Label.String = 'Image Resolution (m)';
% title(['Cross-shore Resolution'])
% xlabel('X (m)')
% ylabel('Y (m)')
% set(gca,'XLim',limx,'YLim',limy)
% saveas(f,fullfile(outPath,'CrossShoreRes'),'png')
% 
% f = figure;
% hold on
% grid on
% imagesc(res{1}.x,res{1}.y, min(daProj,[],3))
% plot(cxyz(1,1), cxyz(1,2),'*k')
% axis image
% c = colorbar;
% c.Label.String = 'Image Resolution (m)';
% title(['Alongshore Resolution'])
% xlabel('X (m)')
% ylabel('Y (m)')
% set(gca,'XLim',limx,'YLim',limy)
% saveas(f,fullfile(outPath,'AlongShoreRes'),'png')
%
%clear f

% %% ALONGSHORE/CROSS-SHORE RESOLUTION PLOTS ARE CURRENTLY DISABLED. 
% % Future versions of this tool may include the ability to specify a 
% % shoreline orientation in the local coordinate system.
%
% % contour plot of alongshore/cross-shore resolution
% 
% f1 = figure;
% 
% maxI = max( max(max(min(daProj,[],3))), max(max(min(dcProj,[],3))) );
% 
% v = 0:maxI/20:maxI;
% colormap(jet(length(v)-1));
% 
% subplot(1,2,1)
% d = min(daProj,[],3);
% colormap(jet(length(v)-1));
% contourf( res{1}.x, res{1}.y, d, v );
% H1 = gca;
% grid on;
% title('Alongshore Resolution');
% xlabel('X (m)');
% ylabel('Y (m)');
% axis equal
% caxis([v(1) v(end)])
% 
% subplot(1,2,2)
% d = min(dcProj,[],3);
% colormap(jet(length(v)-1));
% contourf( res{1}.x, res{1}.y, d, v );
% set(gca,'YTickLabel', '' );
% H2 = gca;
% grid on;
% title('Cross-shore Resolution');
% xlabel('X (m)');
% axis equal
% caxis([v(1) v(end)])
% 
% linkaxes([H1 H2]);
% set(gca,'XLim',limx,'YLim',limy)
% h2AxPos1 = get(H2,'Position');
% set(H2,'Position',[h2AxPos1(1)-.093 h2AxPos1(2:4)])
% 
% h2AxPos = get(H2,'Position');
% h1AxPos = get(H1,'Position');
% 
% c = colorbar;
% c.Label.String = 'Image Resolution (m)';
% set(H2,'Position',h2AxPos)
% set(H1,'Position',h1AxPos)
% 
% saveas(f1,fullfile(outPath,'Resolution_AlongCrossShore_Subplot'),'png')
% 
% clear H1 H2 h1AxPos h2AxPos


% contour plot of along-range/cross-range resolution

f2 = figure;

maxI = max( max(max(min(daRange,[],3))), max(max(min(dcRange,[],3))) );

v = 0:maxI/20:maxI;
colormap(jet(length(v)-1));

subplot(1,2,1)
d = min(daRange,[],3);
colormap(jet(length(v)-1));
contourf( res{1}.x, res{1}.y, d, v );
H1 = gca;
grid on;
title('Along-range Resolution');
xlabel('X (m)');
ylabel('Y (m)');
axis equal
caxis([v(1) v(end)])

subplot(1,2,2)
d = min(dcRange,[],3);
colormap(jet(length(v)-1));
contourf( res{1}.x, res{1}.y, d, v );
set(gca,'YTickLabel', '' );
H2 = gca;
grid on;
title('Cross-range Resolution');
xlabel('X (m)');
axis equal
caxis([v(1) v(end)])

linkaxes([H1 H2]);
set(gca,'XLim',limx,'YLim',limy)
h2AxPos1 = get(H2,'Position');
set(H2,'Position',[h2AxPos1(1)-.093 h2AxPos1(2:4)])

h2AxPos = get(H2,'Position');
h1AxPos = get(H1,'Position');

c = colorbar;
c.Label.String = 'Image Resolution (m)';
set(H2,'Position',h2AxPos)
set(H1,'Position',h1AxPos)

saveas(f2,fullfile(outPath,'Resolution_AlongCrossRange_Subplot'),'png')

try
    % convert ll of instrument location to UTM using SuperTrans from OpenEarth Toolbox
    [east, north, logconv] = convertCoordinates(lon, lat, 'CS1.code', 4326,'CS2.code', epsgCode);
    logconv.CS2.name;
    
    % plot the footprints of cameras in Google Earth
    for ii = 1:size(az,2)
        % convert footprint based on camera location
        eastVertices = east+XYZVertices{ii}(:,1);
        northVertices = north+XYZVertices{ii}(:,2);
        
        % convert footprint to ll
        [lonVertices, latVertices, logconv] = convertCoordinates(eastVertices, northVertices, 'CS1.code', epsgCode, 'CS2.code', 4326);
        
        % make kml file with a patch of the footprint!
        KMLpatch([latVertices; latVertices(1)],[lonVertices; lonVertices(1)], 'fillColor',[1 0 0],'lineColor',[1 1 1],'fileName',fullfile(outPath, sprintf('FootprintCamera%d.kml',ii)))
    end
catch
    warning('Unable to generate KML file, code terminated. Run OpenEarth Toolbox and try again.')
    return
end

% make a contour plot of resolution in Google Earth
eastCont = east+res{1}.x;
northCont = north+ res{1}.y;
[eastMesh, northMesh] = meshgrid(eastCont,northCont);

% convert contour lines to ll
%pre-load to speed up code
EPSG = load('EPSG');
[lonCont, latCont, logconv] = convertCoordinates(eastMesh, northMesh, EPSG,'CS1.code', epsgCode, 'CS2.code', 4326);


% plot the resolution as a surface in Google Earth
KMLsurf(latCont, lonCont,[],min(daRange,[],3), 'fileName', fullfile(outPath, 'AlongRangeSurf.kml'))
KMLsurf(latCont, lonCont,[],min(dcRange,[],3), 'fileName', fullfile(outPath, 'CrossRangeSurf.kml'))



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