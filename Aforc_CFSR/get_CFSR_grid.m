function [i1min,i1max,i2min,i2max,i3min,i3max,jrange,jmin,jmax,lon,lat]=...
    get_NCEP_grid(url_path,lonmin,lonmax,latmin,latmax)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get the indices for a NCEP subgrid 
%
%
%  Further Information:  
%  http://www.croco-ocean.org
%  
%  This file is part of CROCOTOOLS
%
%  CROCOTOOLS is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published
%  by the Free Software Foundation; either version 2 of the License,
%  or (at your option) any later version.
%
%  CROCOTOOLS is distributed in the hope that it will be useful, but
%  WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program; if not, write to the Free Software
%  Foundation, Inc., 59 Temple Place, Suite 330, Boston,
%  MA  02111-1307  USA
%
%  Copyright (c) 2005-2006 by Pierrick Penven 
%  e-mail:Pierrick.Penven@ird.fr  
%
%  Updated    6-Sep-2006 by Pierrick Penven
%  Updated    Fev-2008 by   Jerome Lefevre remove mask reading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get the indices for a NCEP 

dl=3;

lonmin=lonmin-dl;
lonmax=lonmax+dl;
latmin=latmin-dl;
latmax=latmax+dl;
%
% Get the global horizontal grid
%

lon=readdap(url_path,'lon',[]);
if lon(end)>360 
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!')  
    longitudes=[lon(1) lon(2)] 
    longitudes=[lon(end-1) lon(end)]
    lon=lon(2:end-1);
    disp('!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!') 
end
lat=readdap(url_path,'lat',[]);

%
% Get a subgrid
%
j=find(lat>=latmin & lat<=latmax);
%
i1=find(lon-360>=lonmin & lon-360<=lonmax);
i2=find(lon>=lonmin & lon<=lonmax);
i3=find(lon+360>=lonmin & lon+360<=lonmax);
%
lon=cat(1,lon(i1)-360,lon(i2),lon(i3)+360);
lat=lat(j);

decal=1;
%
if ~isempty(i1)
    i1min=min(i1)-decal;
    i1max=max(i1)-decal;
else
    i1min=[];
    i1max=[];
end
if ~isempty(i2)
    i2min=min(i2)-decal;
    i2max=max(i2)-decal;
else
    i2min=[];
    i2max=[];
end
if ~isempty(i3)
    i3min=min(i3)-decal;
  i3max=max(i3)-decal;
else
    i3min=[];
    i3max=[];
end
%
jmin=min(j)-decal;
jmax=max(j)-decal;
jrange=['[',num2str(jmin),':',num2str(jmax),']'];
