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
%     Filename         : get_pv.m
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2018-11-28 |  Ran Liu    |          Original
%   ------------------------------------------------------------------------
% \*=======================================================================


function [tx_pv] = get_pv(rx_ks, rx_rs, rx_cs, rx_cr)
% GET_PV  get the age planes of the reference and destination images parallel and ensure that there are only horizontal parallaxes between them (i.e., satisfy the scanline property)
% tx_pv: the projection matrix of IR", 4 x 4
%
% rx_ks: intrinsic matrix of the destination image
% rx_rs: rotation matrix of the destination image
% rx_cs: the optical center of the destination image
% rx_cr: the optical center of the reference image

%% Get the the first component of the (RS)-1CR
c1 = rx_rs \ rx_cr;
c1 = c1(1);
c = [c1; -rx_cs(1); -rx_cs(2)];

% matrices that carry out the map ur''-->ur
min_T = rx_rs * c - rx_cr;

% 计算IR"的投影矩阵，4 x 4
zero_vector = [0 0 0 0]';
LastLine = [0 0 0 1];
ks_rs = rx_ks * rx_rs;  % 3 x 3
tx_pv = [ks_rs -ks_rs * rx_cr];  % 3 x 4
tx_pv = [tx_pv; LastLine]; % 4 x 4, LastLine: 全局变量在函数里是不可见的
tmp_t = [ -ks_rs * min_T; 0]; % 4 x 1
tx_pv = tx_pv + [zero_vector zero_vector zero_vector tmp_t];  % 4 x 4
