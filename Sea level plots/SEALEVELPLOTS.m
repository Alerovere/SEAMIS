%This script extracts values from a xlsx file containing sea level data 
%(see Template.xlsx) and plots sea level data together with GIA model outputs
%stored in netcdf files. One example is provided
%Author: Alessio Rovere 5.Oct.2018

%Known bugs and welcome updates
%BUGS 
%works with MATLAB 2016b, MATLAB 2015b has a problem with the 
%errorbar function

%WELCOME UPDATES
%Improve the general usability of the script by allowing to plot several
%sea level plots in a single PDF page
%Code a function that takes the latest version of the database and
%subdivides it in regions into the DATA folder

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

%add current folder and subfolders to path
pwd
currentFolder = pwd
addpath(genpath(currentFolder));

%change here which folder you want to analyse
folder= uigetdir('DATA\','Select data folder')


%take all files in the specified folder
data=dir(fullfile(folder,'*.xlsx'));
nr=size(data);  % number of rows in field content

for nfiles=1:nr
file=data(nfiles).name;
%read general information
%limited to 500 SLI, MLI and TLI (for speed of the script)
[~,Title] =xlsread(file,'Info','B3:B3');
Lat=xlsread(file,'Info','B1:B1');
Lon=xlsread(file,'Info','B2:B2');
%read RSL index points data from the excel file
ySLI=xlsread(file,'SLI','BQ1:BS501');
tSLI=xlsread(file,'SLI','J1:L501');
tSLI=tSLI/1000;
%read Marine limiting points data from the excel file
yMLI=xlsread(file,'MLI','AL1:AO501');
tMLI=xlsread(file,'MLI','J1:L501');
tMLI=tMLI/1000;
%read Terrestrial limiting points data from the excel file
yTLI=xlsread(file,'TLI','AL1:AO501');
tTLI=xlsread(file,'TLI','J1:L501');
tTLI=tTLI/1000;

%read how many rejected indicators are in the study
Rej=xlsread(file,'rejected');
Nrej=size (Rej,1);

%check for null fields
test1=isempty (ySLI);
if test1==1;
    dummySLI=0;
    dummytSLI=0;
else
    dummySLI=ySLI;
    dummytSLI=tSLI;
end;
test2=isempty (yMLI);
if test2==1;
    dummyMLI=0;
    dummytMLI=0;
else
    dummyMLI=yMLI;
    dummytMLI=tMLI;
end;
test3=isempty (yTLI);
if test3==1;
    dummyTLI=0;
    dummytTLI=0;
    else
    dummyTLI=yTLI;
    dummytTLI=tTLI;
end;

%set the axes
disp (['The maximum age of your data is ',num2str(max([dummytSLI(:);dummytMLI(:);dummytTLI(:)])),'ka'])
prompt1 = 'Insert upper limit of age axis ';
xUpLim = input(prompt1);

disp (['The maximum elevation of your data is ',num2str(max([dummySLI(:,1);dummyMLI(:,1);dummyTLI(:,1)])),'m'])
prompt3 = 'Insert upper limit of RSL axis ';
yUpLim = input(prompt3);

disp (['The minimum elevation of your data is ',num2str(min([dummySLI(:,1);dummyMLI(:,1);dummyTLI(:,1)])),'m'])
prompt2 = 'Insert lower limit of RSL axis ';
yLoLim = input(prompt2);

xlim=[0 xUpLim]; %x axis limits
ylim=[yLoLim yUpLim]; %x axis limits

%read the models in the Models folder
GIA=dir(fullfile('Models','*.nc'));
Nmod=size(GIA);  % number of rows in field content
n=Nmod(1);
%read the netcdf file and extracts data at the Lat/Lon specified in the excel file
for i=1:n
filename = GIA(i).name;
totLat = ncread(filename,'Lat');
totLon = ncread(filename,'Lon');
RSL = ncread(filename,'RSL');
%extract time series at the cell closest to the site
[val,Longitude]=min(abs(totLon-Lon));
[val,Latitude]=min(abs(totLat-Lat));
time=43; %this goes back to 21 ka
for t=1:time
Val(t)=RSL(Longitude,Latitude,t);
end;
tseries(:,i)=Val;
end;
xGIA=linspace(0,(time-1)/2,time);%check this if you change time
xGIA=xGIA';

%initialization of the figure
RSLplot=figure;
Authors=Title{1,1};
if Nrej==0
EntireTitle=strcat(Authors,' (No rejected points)');
else
EntireTitle=strcat(Authors,' (Rejected points =',num2str(Nrej),')');
end;
title(EntireTitle)

ax = gca;
xlabel('Age [ka BP]');
ylabel('Relative Sea Level [m]');
ax.FontSize = 12;
ax.XLim = (xlim); %x axis limits
ax.YLim = (ylim); %x axis limits

%plots the GIA curves
for i=1:n
hold on
GIAplot=plot(xGIA,tseries(:,i));
GIAplot.LineWidth=0.7;
end;

%plot ESL
esl=xlsread('Eustasy_ICE5g.xlsx');
eslplot=plot(esl(:,1),esl(:,2),'LineWidth',0.6,'color','k')

%plot RSL indicators with error bars
if test1==0 
xpos=tSLI(:,2)-tSLI(:,1);
xneg=tSLI(:,1)-tSLI(:,3);
ypos=ySLI(:,2);
yneg=ySLI(:,3);
SLIplot=errorbar(tSLI(:,1),ySLI(:,1),yneg,ypos,xneg,xpos,'.');
SLIplot.MarkerSize=0.1;
SLIplot.Color = 'k';
SLIplot.CapSize = 0.1;
SLIplot.LineWidth = 1;
clear xpos ypos xneg yneg;
else disp ('No SLI in your dataset')
end;

%plot Marine Limiting indicators with X error bars
if test2==0
xpos=tMLI(:,2)-tMLI(:,1);
xneg=tMLI(:,1)-tMLI(:,3);
yneg=zeros(size(yMLI,1),1);
ypos=ones(size(yMLI,1),1)*0.5;
MLIplot=errorbar(tMLI(:,1),yMLI(:,1),yneg,ypos,xneg,xpos,'.');
MLIplot.MarkerSize=0.1;
MLIplot.Color = 'b';
MLIplot.CapSize = 0.1;
MLIplot.LineWidth = 1;
clear xpos ypos xneg yneg;
else disp ('No MLI in your dataset')
end;

%plot Terrestial Limiting indicators with X error bars
if test3==0
xpos=tTLI(:,2)-tTLI(:,1);
xneg=tTLI(:,1)-tTLI(:,3);
ypos=zeros(size(yTLI,1),1);
yneg=ones(size(yTLI,1),1)*0.5;
SLIplot=errorbar(tTLI(:,1),yTLI(:,1),yneg,ypos,xneg,xpos,'.');
SLIplot.MarkerSize=0.1;
SLIplot.Color = 'r';
SLIplot.CapSize = 0.1;
SLIplot.LineWidth = 1;
clear xpos ypos xneg yneg;
else disp ('No TLI in your dataset')
end;

name = {GIA.name}.';
name = cellstr(name);
name = cellfun(@(name) name(1:end-3), name, 'Uniform', 0);

legend({name{:},'Eustatic (ICE5g)'},'Location','southwest');

hold off
%save the figure in pdf

oldFolder=cd('Plots_pdf'); 
print(RSLplot,Authors,'-dpdf');
cd(oldFolder);
end;

