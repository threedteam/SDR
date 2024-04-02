%%�ó������ڷ����˹�˲�����ʾһ�η����˹�˲�
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
%     Filename         : sub_direict_asymmertricsmooth.m
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
function sDMap4 = sub_direict_asymmertricsmooth( DMap4,wh,wv,b,c,a,Md)
%ASYMMERTICSMOOTH Return the smoothed image of DMap4 and the gaussian filter is
%asymmertric .
% DMap4 I4��ο�ͼ���Ӧ�����ͼ
% m_Width ͼ��I4�Ŀ��
% m_Height ͼ��I4�ĸ߶ȶ�
% b   ˮƽ������һά��˹sigma��ֵ
% c  ��ֱ������һά��˹sigma��ֵ
% a �����a(m -(wv - 1)/2 : m + (wv - 1)/2, n -(wh - 1)/2: n + (wh - 1)/2)
% wv��whΪ���ĳߴ紹ֱ��ˮƽ�ߴ�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %����ռ�
[m_Height m_Width clr ] = size(DMap4);

sDMap4(1:m_Height,1:m_Width)  = DMap4(:,:,1);


%ͼ���˲�
for m = (wv + 1)/2 : m_Height - (wv - 1)/2
    for n = (wh + 1)/2 : m_Width - (wh - 1)/2
        if Md(m,n) == 1
             sDMap4(m,n) = sub_sub_daf( DMap4(m -(wv - 1)/2 : m + (wv - 1)/2, n -(wh - 1)/2: n + (wh - 1)/2),wh,wv,b,c,a(m -(wv - 1)/2 : m + (wv - 1)/2, n -(wh - 1)/2: n + (wh - 1)/2));         
        end
    end
end

end

