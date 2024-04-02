%%该程序用于方向高斯滤波计算方向角
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
%     Filename         : direct_gradient.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-08-30 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function a = direict_gradient( DMap4)
%ASYMMERTICSMOOTH Return the smoothed image of DMap4 and the gaussian filter is
%asymmertric .
% DMap4 I4与参考图像对应的深度图
% a  输出的方向角
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %申请空间
[m_Height m_Width clr] = size(DMap4);
a = zeros(m_Height, m_Width);
Hh = fspecial('sobel');
Hv = Hh';
gx = imfilter(DMap4,Hh,'replicate');
gy = imfilter(DMap4,Hv,'replicate');
% figure;
% imshow(gx);
% figure;
% imshow(gy);

%计算梯度值
for m = 1 : m_Height
    for n = 1 : m_Width
        if gy(m,n) ~= 0
            g = double(gx(m,n)/gy(m,n));
            a(m,n) = atan(g);
        else
            if gx(m,n) == 0
               a(m,n) = 0;
            else
                a(m,n) =  pi/2;
            end
        end
    end
end
end


