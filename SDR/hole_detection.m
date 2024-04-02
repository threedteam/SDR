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
%     Corresponding author£ºRan Liu
%     Address: College of Computer Science, Chongqing University, 400044, Chongqing, P.R.China
%     Phone: +86 136 5835 8706
%     Fax: +86 23 65111874
%     Email: ran.liu_cqu@qq.com
%
%     Filename         : main.m
%     Description      : code to draw the Fig. 5 in the paper entitled "
%                        Spatio-temporal Hole-filling for DIBR System"
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-11-14  |   Ran Liu                     |   Original
%   ------------------------------------------------------------------------
% =========================================================================================================

function [tx_num, tx_u] = hole_detection(rx_m_v, rx_width, rx_u)
% HOLE_DETECTION  Return the number of hole-points in current hole and the horizontal coordinate of the right non-hole point which is nearest to the hole
% tx_num: number of hole-points between two non-hole points
% tx_u: the horizontal coordinate of the right non-hole point which is nearest to the hole
% rx_m_v: the vth line of the non-hole matrix rx_m
% rx_width: image width
% rx_u: horizontal coordinate of a pixel

tx_num = 0;

while rx_u <= rx_width && rx_m_v(rx_u) == -1 % ¼ì²â¿Õ¶´
    tx_num = tx_num + 1;
    rx_u = rx_u + 1;
end

tx_u = rx_u;

