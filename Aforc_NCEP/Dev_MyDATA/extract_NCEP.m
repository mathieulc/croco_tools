function extract_NCEP(NCEP_dir,url,fname,vname,year,month,...
                      lon,lat,tndx,time,...
                      trange,level,jrange,...
                      i1min,i1max,i2min,i2max,i3min,i3max,...
                      jmin,jmax,Yorig,Get_My_Data)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Extract a subset from NCEP using OPENDAP if Get_My_Data~=1 
% Extract a subset from NCEP my ftp data   if Get_My_Data==1
%
% Write it in a local file
% 
%
%  Further Information:  
%  http://www.brest.ird.fr/Roms_tools/
%  
%  This file is part of ROMSTOOLS
%
%  ROMSTOOLS is free software; you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published
%  by the Free Software Foundation; either version 2 of the License,
%  or (at your option) any later version.
%
%  ROMSTOOLS is distributed in the hope that it will be useful, but
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
%  Updated    22-Sep-2006 by Pierrick Penven (readattribute)
%  Updated    Jul-2007 to use Nomads3 server, J. Lefevre. 
%  Updated    Oct-2009 Gildas Cambon 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Get the variable name
%
disp(['Get ',vname,' for year ',num2str(year),...
      ' - month ',num2str(month)])
%
% Get the variable 2D subset (take care of greenwitch)
%
if Get_My_Data~=1
var=getdap(url,fname,vname,...
            trange,level,jrange,...
            i1min,i1max,i2min,i2max,i3min,i3max);	
%size(var)
%size(shiftdim(var,2))

%
% Get the dataset attributes
%
x=readattribute([url,fname]);
%eval(['add_offset=x.',vname,'.add_offset;']);
%eval(['scale_factor=x.',vname,'.scale_factor;']);  %no scale scale factor and offset ??
eval(['missing_value=x.',vname,'.missing_value;']);



else %if Get_My_Data
nc=netcdf([url,fname,'.',num2str(year),'.nc']);
  if ~isempty(i1min)
      if strcmp(vname,'air')==1 || strcmp(vname,'uwnd')==1 || ...
	 strcmp(vname,'vwnd')==1 || strcmp(vname,'shum')==1 
	
	var1=squeeze(nc{vname}(tndx,1,jmin:jmax,i1min:i1max));
%        var10=flipdim(squeeze(nc{vname}(tndx,1,:,:)) , 2);
%        var1=var10(:,jmin:jmax,i1min:i1max);
	
      else
	var2=squeeze(nc{vname}(tndx,jmin:jmax,i1min:i10max));	
%        var10=flipdim(squeeze(nc{vname}(tndx,:,:)) , 2);
%	var1=var10(:,jmin:jmax,i1min:i1max);
        
      end
    else
    var1=[];
  end
  
  if ~isempty(i2min)
      if strcmp(vname,'air')==1 || strcmp(vname,'uwnd')==1 || ...
	 strcmp(vname,'vwnd')==1 || strcmp(vname,'shum')==1 
	
        var2=squeeze(nc{vname}(tndx,1,jmin:jmax,i2min:i2max));
%	var20=flipdim(squeeze(nc{vname}(tndx,1,:,:)) , 2);
%	var2=var20(:,jmin:jmax,i2min:i2max);
	
      else
        var2=squeeze(nc{vname}(tndx,jmin:jmax,i2min:i2max));	
%        var20=flipdim(squeeze(nc{vname}(tndx,:,:)) , 2);
%	var2=var20(:,jmin:jmax,i2min:i2max);

      end
  else
    var2=[];
  end
  
  if ~isempty(i3min)
       if strcmp(vname,'air')==1 || strcmp(vname,'uwnd')==1 || ...
	  strcmp(vname,'vwnd')==1 || strcmp(vname,'shum')==1 
	
        var3=squeeze(nc{vname}(tndx,1,jmin:jmax,i3min:i3max));
%	var30=flipdim(squeeze(nc{vname}(tndx,1,:,:)) , 2);
%	var3=var30(:,jmin:jmax,i3min:i3max);
		
       else
        var3=squeeze(nc{vname}(tndx,jmin:jmax,i3min:i3max));
%	var30=flipdim(squeeze(nc{vname}(tndx,:,:)) , 2);
%	var3=var30(:,jmin:jmax,i3min:i3max);
	
       end
  else
    var3=[];
  end
%%      
    var=cat(3,var1,var2,var3);
    close(nc)
%%
  nc=netcdf([url,fname,'.',num2str(year),'.nc']);
  add_offset=nc{vname}.add_offset(:);
  if isempty(add_offset)
     add_offset=0;    
  end
  scale_factor=nc{vname}.scale_factor(:);
  if isempty(scale_factor)
       scale_factor=1
  end
  missing_value=nc{vname}.missing_value(:);
  if isempty(missing_value)
       missing_value=-99999;
  end
  close(nc)

end  %if Get_My_Data
%
% Correct the variable
%
if Get_My_Data~=1
disp(['Get_My_Data is OFF'])
var=shiftdim(var,2);
var(var==missing_value)=NaN;

else
disp(['Get_My_Data is ON'])
var(var==missing_value)=NaN;
var=add_offset+var.*scale_factor;
% $$$ %------
% $$$ disp(['Attention car convention differenets modeles atm (NCEP) et OCEAN (roms)'])
% $$$ disp(['size(var)= ',num2str(size(var))])
% $$$ var=flipdim(var,2);
% $$$ lat=flipdim(lat,1);
% $$$ %-------

end  %if Get_My_Data
%
% Write it in a file
%
% $$$ size(lon)
% $$$ size(lat)
% $$$ size(var)
% $$$ tndx
write_NCEP([NCEP_dir,vname,'_Y',num2str(year),'M',num2str(month),'.nc'],...
            vname,lon,lat,time,var,Yorig)
%
return
