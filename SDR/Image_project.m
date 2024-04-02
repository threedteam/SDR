% =========================================================================================================
%       C Q UC Q UC Q UC Q U          C Q UC Q UC Q U              C Q U          C Q U
% C Q U               C Q U     C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q U               C Q U          C Q U          C Q U
% C Q U                         C Q UC Q UC Q U     C Q U          C Q U          C Q U
% C Q U               C Q U     C Q U          C Q UC Q U          C Q U          C Q U
%      C Q UC Q UC Q U               C Q UC Q UC Q U                    C Q UC Q U
%                                              C Q UC Q U
%
%     (C) Copyright Chongqing University All Rights Reserved.
%
%     This program and corresponding materials are protected by software
%     copyright and patents.
%
%     Corresponding author：Ran Liu
%     Address: College of Computer Science, Chongqing University, 400044, Chongqing, P.R.China
%     Phone: +86 136 5835 8706
%     Fax: +86 23 65111874
%     Email: ran.liu_cqu@qq.com
%
%     Filename         : Image_project.m
%     Description      : the function to perform  image projection
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-11-26  |   Donghua Cao                 |   Original
%   ------------------------------------------------------------------------
% =========================================================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tx_ides, tx_depth] = Image_project(rx_iref, rx_d,rx_ref_rt ,rx_kr, rx_ides_rt, rx_ks)
% IMAGE_PROGECT  Return the re-projection color image and depth imge
% tx_ides: generated destination image, uint8
% tx_m: generated non-hole matrix, double
% rx_iref: reference image
% rx_d: depth map
% rx_min_z: minimum actual z (depth)
% rx_max_z: maximum actual z (depth)
% rx_pr: projection matrix of reference image, 4 x 4
% rx_ides_rt: affine transformation matrix of destination image, 3 x 4
% rx_ps: projection matrix of destination image, 4 x 4

%% 初始化参数

% image resolution is m_Width x Height,
% m_Height:图像的高
% m_Width:图像的宽
% Clr:图像的页
[m_Height, m_Width, Clr] = size(rx_iref);

% 从xoy到x'o'y'的坐标变换矩阵
Trl = [1 0  0
    0 -1 m_Height - 1
    0 0  1];  % 这里要考虑基数为0还是为1的问题，因为这里的坐标关系到了真实的图像坐标。
% 本程序采用的基数为0，与标定时采用的基数一致，在处理原始图像和最后生成图像时，需要转换基数（即要平移坐标系）
%%  计算参考图像的投影矩阵     
% 计算目标图像tx_ides的外部参数矩阵
R_ides = rx_ides_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
T_ides = rx_ides_rt(:, 4); % 3 x 1
% 计算参考图像tx_ides的外部参数矩阵
R_ref = rx_ref_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
T_ref = rx_ref_rt(:, 4); % 3 x 1
% 计算重投影图像tx_ides的外部参数矩阵，旋转矩阵
ms_R = R_ides* inv(R_ref);
ms_RT = [ms_R, T_ref];
ms_ProjMatrix =  rx_kr * ms_RT;
LastLine = [0 0 0 1];
ms_ProjMatrix = [ms_ProjMatrix; LastLine]; % 4 * 4
  M = inv(Trl)*rx_ks * ms_R *inv(rx_kr) * Trl;  %  求I5到Is的单应矩阵M
 [tx_ides] = GetPartSyndImg(rx_iref, M);
 [tx_depth] = GetPartSyndImg(rx_d, M);

end

