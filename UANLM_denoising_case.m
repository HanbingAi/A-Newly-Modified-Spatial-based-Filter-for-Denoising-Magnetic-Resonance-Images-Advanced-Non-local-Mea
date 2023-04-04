clc;
clear all;
close all;
%% Date: 2023.4.1.
%% Coder: Hanbing Ai
%% How to contact me?
%E-mail:AHB_ECUT@163.com/1724178612@qq.com
%% Step 1: Reading MRI data:
filename1='t1_icbm_normal_1mm_pn0_rf0';
filename2='t2_icbm_normal_1mm_pn0_rf0';
filename3='pd_icbm_normal_1mm_pn0_rf0';
[imaVOL1,scaninfo] = loadminc([filename1,'.mnc']);
[imaVOL2,scaninfo] = loadminc([filename2,'.mnc']);
[imaVOL3,scaninfo] = loadminc([filename3,'.mnc']);
%%
R_D_squeezed=imaVOL1;
[X,Y,Z]=size(R_D_squeezed);
%%
G_min=1;G_max=min([X,Y,Z]);
G_num=fix(1:(max([X,Y,Z])/min([X,Y,Z])):max([X,Y,Z]));
%%
PreImage=R_D_squeezed(:,:,90);
Input=PreImage;
%% Step 2: Adding noise (Rician distribution)
%%
Threshold=55;
%
[ROW,COL]=find(Input<Threshold);
[ROW2,COL2]=find(Input>=Threshold);
MEAN_BG=mean(Input(find(Input<Threshold)));
MEAN_content=mean(Input(find(Input>=Threshold)));
%
Noise_corrupted=Input;
%
MRI_BG=add_noise(Input,'rayleigh',10*MEAN_BG);
MRI_content=add_noise(Input,'gaussian',0,10*MEAN_BG);
%
for k=1:length(ROW)
    Noise_corrupted(ROW(k),COL(k))=MRI_BG(ROW(k),COL(k));
    RayleighNoise(k)=MRI_BG(ROW(k),COL(k))-Input(ROW(k),COL(k));
end
%
for k=1:length(ROW2)
    Noise_corrupted(ROW2(k),COL2(k))=MRI_content(ROW2(k),COL2(k));
    GaussianNoise(k)=MRI_content(ROW2(k),COL2(k))-Input(ROW2(k),COL2(k));
end
%% Step 3: Visualization of noise corruption:
figure
%
set(gcf,'color',[1 1 1],'units','normalized','position',[0.1 0.1 0.9 0.5]) 
%
subplot(1,3,1)
imagesc(Input)
daspect([2 2 2])
axis off
colormap('bone')
%
subplot(1,3,2)
imagesc(Noise_corrupted)
daspect([2 2 2])
axis off
colormap('bone')
%
subplot(1,3,3)
imagesc(Noise_corrupted-Input)
daspect([2 2 2])
axis off
colormap('bone')
%%
Noise=Noise_corrupted;
%%
sigma=mean(mean(Noise));ds=3;d=2*ds+1;
%%
C_P_h=[0.09*sigma];% for T1,T2
% C_P_h=[0.036*sigma];% for PD
C_P_Ds=[5];
%%
INPUT=Noise;
%%
tic;
OUTPUT_NLM=NLM_II(INPUT,C_P_Ds,ds,C_P_h);
UOUTPUT_NLM=abs(sqrt(OUTPUT_NLM.^2-mean(INPUT(find(INPUT<10*Threshold)))));
%
RMSE=sqrt(mean(mean((Input-OUTPUT_NLM).^2)))
URMSE=sqrt(mean(mean((Input-UOUTPUT_NLM).^2)))
toc;

figure
%
set(gcf,'color',[1 1 1],'units','normalized','position',[0.1 0.1 0.9 0.5]) 
%
subplot(1,3,1)
imagesc(UOUTPUT_NLM)
rectangle('position',[80 100 50 50],'linewidth',2,'edgecolor','m')
daspect([2 2 2])
axis off
colormap('bone')
%
subplot(1,3,2)
imagesc(Noise_corrupted-UOUTPUT_NLM)
daspect([2 2 2])
axis off
colormap('bone')
%
subplot(1,3,3)
imagesc(Input-UOUTPUT_NLM)
daspect([2 2 2])
axis off
colormap('bone')

