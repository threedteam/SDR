%% �������Ե������x������ݶȣ�
%
% /*===========================================================================*\
%  This confidential and proprietary software may be used only by
%  authorized users by a licensing agreement from Panovasic Technology Co., Ltd.
%  In the event of publication, the following notice is applicable:
%   ========================================================================
%
%   PPPPPP    A      NN    N   OOOO  V       V   A      SSSS  IIIII  CCCCC
%   P    PP  A A     N N   N  O    O  V     V   A A    S        I   CC
%   PPPPPP  A   A    N  N  N  O    O   V   V   A   A    SSSS    I   CC
%   P      A A A A   N   N N  O    O    V V   A A A A       S   I   CC
%   P     A       A  N    NN   OOOO      V   A       A  SSSS  IIIII  CCCCC
%
%   ========================================================================
%     Filename         : sobelx.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-04-18 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================



function  [ sobelx ] = sobelx( I )
[m,n] = size(I);
% sobelxs = zeros(m,n);
sobelxb = [-1 0 1; -2 0 2; -1 0 1]; %sobel����x�᷽���ģ��ֵ

for i = 2:1:m-1
    for j = 2:1:n-1
        window = I(i-1:i+1,j-1:j+1);
        sobelx= sum(sum(window.*sobelxb)); %sobel������
    end
end
 
% sobelx = sum(sum(sobelxs));
end
