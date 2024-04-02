%% ��������ͼ���޸���������ȷ���ն���Ե�ĳ���
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
%     Filename         : filledge.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-04-23 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ filledge,holedges] = filledge(dD,Wi, Hi,B)
%dD Ŀ��ͼ���Ӧ�����ͼ
%M �ն����ͼ

filledge = zeros(Hi,Wi);
%%ȷ�����Ŀն���Ե
holedges = holedge(dD,Wi, Hi); %ȷ���ն���Ե
if B>0
    for i= 1:Hi
        for j = Wi-1:-1:1
            if (holedges(i,j) == 1)
                if ((dD(i ,j - 1) == 0) && (dD(i,j+1) ~= 0))
%                   if (M(i ,j - 1) == -128) 
                    filledge(i,j) = 1;
                end
            end
        end
    end
else
     for i= 1:Hi
        for j = 1:.1:Wi-1
            if (holedges(i,j) == 1)
                if (dD(i ,j + 1) == 0) && (dD(i,j-1) ~= 0)
                    filledge(i,j) = 1;
                end
            end
        end
    end
end