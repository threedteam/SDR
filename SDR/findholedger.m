%% ��������ͼ���޸����������ر�Ե�������ŶȺ�������ʱ��������ͼ�ĵ�ǰ�ն��ı�Ե
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
%     Filename         : findholedger.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-04-25 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ i,j,stopreturns] =findholedger(holedge,stopreturn,m,n)
%holedge �ն���Ե��� 3*3�ľ���
%m,n�ֱ�Ϊ�ն���Ե�ĺ�������
%i,j �ֱ�Ϊ��һ�� �ն���Ե��ĺ�������
if holedge(1,2) ==1 && stopreturn(1,2) ==1
    i = m - 1 ;
    j = n;
    stopreturns = 0;
else
    if holedge(2,3) ==1 && stopreturn(2,3) ==1
        i = m ;
        j = n + 1;
        stopreturns = 0;
    else
        if holedge(1,3) ==1 && stopreturn(1,3) ==1
            i = m - 1 ;
            j = n +1;
            stopreturns = 0;
        else
            
            if holedge(1,1) ==1 && stopreturn(1,1) ==1
                i = m - 1 ;
                j = n - 1;
                stopreturns = 0;
            else
                if holedge(2,1) ==1 && stopreturn(2,1) ==1
                    i = m  ;
                    j = n - 1;
                    stopreturns = 0;
                else
                    
                    
                    if holedge(3,3) ==1 && stopreturn(3,3) ==1
                        i = m + 1 ;
                        j = n + 1;
                        stopreturns = 0;
                    else
                        if holedge(3,2) ==1 && stopreturn(3,2) ==1
                            i = m + 1 ;
                            j = n ;
                            stopreturns = 0;
                        else
                            if holedge(3,1) ==1 && stopreturn(3,1) ==1
                                i = m + 1 ;
                                j = n - 1;
                                stopreturns = 0;
                            else
                                
                                
                                i = 0;%��ʾ��ǰ�ն��Ѿ����ص�ԭ��
                                j = 0;
                                stopreturns = 0;
                            end
                        end
                    end
                end
            end
        end
    end
end
end
