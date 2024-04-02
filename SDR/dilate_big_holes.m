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
%     Filename         : dilate_big_holes.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2011-07-8  |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================

function [TX_M, TX_u] = dilate_big_holes(RX_M, RX_len_bighole, RX_sharp_th, RX_l, RX_num, RX_u, RX_Wi,RX_num_holes)
% DILATE_BIG_HOLES  return the horizontal coordinates of starting points and
% end points of current hole, and the disparity map value
% RX_M: disparity map
% RX_len_bighole: threshold of holes detection
% RX_sharp_th: threshold of sharp transitions
% RX_l: number of pixels that is to be dilate
% RX_rend_order: flag of the rending order of the reference image
% RX_num: the number of contiue holes in the destination image
% RX_u: horizontal coordinate of the pixel
% TX_sd: coordinate of the starting pixel of current hole in the destination image
% TX_ed: coordinate of the ending pixel of current hole in the destination image
% TX_sr: scoordinate of the starting pixel of current hole in the reference image
% TX_er: coordinate of the ending pixel of current hole in the reference
% image
% TX_d: disparity value of the forground pixel which lays in the edge of
% the holes

if RX_num >= RX_len_bighole % 较大空洞
    RX_num_holes = 0;
    lb_bk_fg = 0;
    % 初始化参数值
    i = RX_u - RX_num - 1;
    TX_M = RX_M ;
    while lb_bk_fg == 0
        if i > 1 % 1-based
            if RX_M(i- 1) ~= - 1  % 非空洞点
                if RX_M(i+RX_num_holes) - RX_M(i - 1) <= -RX_sharp_th % 空洞左边缘区域为背景像素点
                    lb_bk_fg = 1;
                    for  j = 1 : RX_l
                        if (RX_u-RX_num-j>0)
                            TX_M(RX_u-RX_num-j)= -1;
                        end
                        if (RX_u+j-1<= RX_Wi)
                            TX_M(RX_u+j-1)= -1;
                        end
                        
                    end
                    TX_u= RX_u+RX_l-1;
                else
                    if RX_M(i+RX_num_holes ) - RX_M(i - 1) >= RX_sharp_th  % 空洞左边缘区域为前景像素点
                        lb_bk_fg = 1;
                        for  j = 1 : RX_l
                            if (RX_u+j-1<= RX_Wi)
                                TX_M(RX_u+j-1)= -1;
                            end
                        end
		
                        
                        TX_u= RX_u+RX_l-1;
					
                    else
                        RX_num_holes = 0 ;
                        i = i - 1;
                    end
                end
            else
                RX_num_holes = RX_num_holes + 1;
                i = i - 1;
            end
        else
            lb_bk_fg = 1;
            for  j = 1 : RX_l
                if (RX_u+j-1<= RX_Wi)
                    TX_M(RX_u+j-1)= -1;
                end
            end
            
            TX_u= RX_u+RX_l-1;
            
            
            %     % 空洞左边缘区域为前景像素点，且前景像素点前面没有背景像素点
            %    TX_u= RX_u;
        end
    end
    
end
end