clear all
clc

[file,path]=uigetfile('*.txt','File with nodes:');
nodi=dlmread([path file]);
[file,path]=uigetfile('*.txt','File with elements:');
elem=dlmread([path file]);

patch('Faces',elem(:,2:4),'Vertices',nodi(:,2:4),'CData',nodi(:,4),'Edgecolor','none','Facecolor','interp','CDataMapping','scaled');