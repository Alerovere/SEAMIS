%This script extracts values from GIA models stored in netcdf files, and
%plots maps at 2,4,6,8,10 ka
%Author: Alessio Rovere 5.Oct.2018

%Known bugs and welcome updates
%BUGS 
%The second map in the plot is displayed in the pdf with a weird upper
%part. Probably the reason is in the pdf conversion.

%WELCOME UPDATES
%Insert the possibility to choose which time(s) one wants to plot, and
%adjust the graph accordingly.
%

%%%%%DISCLAIMER%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This MATLAB script is provided "as is", without any warranty of any sort. 
%The author makes no warranties, express ir implied that the algorithms and
%scripts are error-free nor guarantee the accuracy, completeness,
%usefulness, or adequacy available at or through these algorithms and
%scripts. The script should not be relied on for solving a problem whose incorrect 
%solution may result in damage to people or properties. You can use this
%script in such manner at your own risk.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all
close all
clc

%reads the models in the Models folder
data=dir('*.nc');
nr=size(data);  % number of rows in field content

%time extracted is 2,4,6,8,10 ka
load coastlines;

for i=1:nr
filename = data(i).name
totLat = ncread(filename,'Lat');
totLon = ncread(filename,'Lon');
RSL = ncread(filename,'RSL');
totLat = ncread(filename,'Lat');
totLon = ncread(filename,'Lon');
RSL = ncread(filename,'RSL');
fig=figure ('Name',filename)
time=4;
for k=1:5
%reads the netcdf file and extracts data at the Lat/Lon specified in the excel file
RSLextract=RSL(:,:,time);
A=totLat'; Latextract = repmat(A,197,1);
Lonextract = repmat(totLon,1,95);
%plots the model
subplot(3,2,k)

%sets the map limit
latlim = [min(Latextract(:)) max(Latextract(:))];
lonlim = [min(Lonextract(:)) max(Lonextract(:))];

% worldmap(latlim,lonlim)

pcolor(Lonextract,Latextract,RSLextract); 
shading flat; 
colormap jet;
colorbar('southoutside')
geoshow('landareas.shp', 'FaceColor', 'black')

realtime=time/2;
EntireTitle=strcat(num2str(realtime),'ka');
title(EntireTitle);
time=time+4;
end;
imagename=strcat(filename,'.pdf')
print(fig,imagename,'-fillpage','-opengl','-dpdf')
end;