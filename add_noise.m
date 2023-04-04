function imgOut = add_noise(imgIn,type,x,y)
%% Title: Adding different types of noise to the object.
%% Date: 2021.12.11.
%% Coder: Hanbing Ai
%% How to contact me?
%E-mail:AHB_ECUT@163.com/1724178612@qq.com
%% Brief introduction:
% Input:
% imgIn: object image
%    type: a string determines the type 
%    gaussian noise: f(x,y), default value is (0,10)
%    rayleigh noise: f(x), default value is 30
%    gamma noise:    f(x,y), default value is (2,10)
%    exponential noise: f(x), default value is 15
%    uniform noise: f(x,y), default value is (-20,20)
%    salt & pepper noise: f(x), default value is 0.02
%%
% Output:
%     imgOut: noise-corrupted image
%%
%% Main program:
% Default noise type
if ndims(imgIn)>=3
    imgIn=rgb2gray(imgIn);
end
[M,N]=size(imgIn);
if nargin==1
    type='gaussian';
end
%
switch lower(type)
    case 'gaussian'
        if nargin<4
            y=10;
        end
        if nargin<3
            x=0;
        end
        R=normrnd(x,y,M,N);
        imgOut=double(imgIn)+R;
%         imgOut=uint8(round(imgOut));
    case 'uniform'
        if nargin<4
            y=20;
        end
        if nargin<3
            x=-20;
        end
        R=unifrnd(x,y,M,N);
        imgOut=double(imgIn)+R;
%         imgOut=uint8(round(imgOut));
    case 'salt & pepper'
        imgOut=imnoise(imgIn,'salt & pepper',x);
        if nargin<3
            x=0.02;
        end
        a1=rand(M,N)<x;  
        a2=rand(M,N)<x;
        imgOut=imgIn;
        imgOut(a1)=0; 
        imgOut(a2)=255;
    case 'rayleigh'
        if nargin<3
            x=30;
        end
        R=raylrnd(x,M,N);
        imgOut=double(imgIn)+R;
%         imgOut=uint8(round(imgOut));
    case 'exp'
        if nargin<3
            x=15;
        end
        R=exprnd(x,M,N);
        imgOut=double(imgIn)+R;
%         imgOut=uint8(round(imgOut));
    case 'gamma'
        if nargin<4
            y=10;
        end
        if nargin<3
           x=2;
        end
        R=gamrnd(x,y,M,N);
        imgOut=double(imgIn)+R;
%         imgOut=uint8(round(imgOut));
    otherwise
        error('Unkown distribution type')    
end
end
