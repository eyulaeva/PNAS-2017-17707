%Calculation of the Total Ice Area and Total Ice Extent
clear;close all;
it=0;
dc=15.    %Ice concentration limit 
%Load Data
COLS=304; ROWS=448;
file=fopen('psn25area_v3.dat','r','l');
grid_area = fread(file, [COLS, ROWS],'int32')/1e9;
fclose(file);
file=fopen('psn25lons_v3.dat','r','l');
lon = fread(file, [COLS, ROWS],'int32')/1e5;
lon(lon<=0)=lon(lon<=0)+360;
fclose(file);
file=fopen('psn25lats_v3.dat','r','l');
lat = fread(file, [COLS, ROWS],'int32')/1e5;
fclose(file);
tlon=lon;
tlat=lat;
tarea1=grid_area;
ncid = netcdf.open ( 'ice_198009.nc','NOWRITE');
clear lon lat
di=netcdf.inqVarID(ncid,'longitude');
lon=netcdf.getVar(ncid,di);
di=netcdf.inqVarID(ncid,'latitude');
lat=netcdf.getVar(ncid,di);
tlon1 = lon;
tlat1 = lat;
tarea=tarea1(tlat<=90 & tlat>=5);
it=0;
for year=1980:2016
for month=9:9
filein=sprintf('ice_%4.1i%2.2i.nc',year,month);
filein
if exist(filein, 'file') == 2
ncid = netcdf.open ( filein,'NOWRITE')
di=netcdf.inqVarID(ncid,'seaice_conc_monthly_cdr');
aice = netcdf.getVar(ncid,di);
taice = double(aice);
clear aice;
aice=taice(tlat<=90 & tlat>=5 & taice > dc);
area=taice(tlat<=90 & tlat>=5 & taice > dc).*tarea1(tlat<=90 & tlat>=5 & taice > dc);
it=it+1;
ice_area(it)=sum(area);
clear area aice tarea
else
end
end
end
%ice_area
fid1 = fopen('ice_cdr_area_arc_mon_Sep_1980_2016.d','wt');
fprintf(fid1,'%hd\n',ice_area);
fclose(fid1);



