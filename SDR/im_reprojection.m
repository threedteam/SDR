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
%     Filename         : im_reprojection.m
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2018-11-20 |  Ran Liu    |          Original
%   ------------------------------------------------------------------------
% \*=======================================================================


function [tx_re_prj, tx_m, tx_pv]= im_reprojection(rx_ref, rx_d, rx_min_z, rx_max_z, rx_ks, rx_rs, rx_cs, rx_des_t, rx_pr, rx_kr, rx_rr, rx_cr, rx_ref_t)
% IM_REPROJECTION  to make the image planes of the reference and destination images parallel and ensure that there are only horizontal parallaxes between them (i.e., satisfy the scanline property)
% tx_re_prj: IR" after image reprojection, 1920 x 768
% tx_m: warped depth map, uint8, with respect to word coordinate system 1920 x 768
% tx_pv: the projection matrix of IR", 4 x 4
% rx_ref: reference image IR
% rx_d: input depth map
% rx_min_z:
% rx_max_z:
% rx_ks: intrinsic matrix of the destination image
% rx_rs: rotation matrix of the destination image
% rx_cs: the optical center of the destination image
% rx_des_t: the translation matrix of the destination image
% rx_pr: projection matrix of reference image, 4 x 4
% rx_kr: intrinsic matrix of the reference image
% rx_rr: rotation matrix of the reference image
% rx_cr: the optical center of the reference image
% rx_ref_t: the translation matrix of the reference image

%% 本程序采用的基数为0，与标定时采用的基数一致，在处理原始图像和最后生成图像时，需要转换基数（即要平移坐标系）
% 申请空间
% image resolution is hi x wi,
% hi:图像的高
% wi:图像的宽
% clr:图像的页
wi_ext = 1920;
[hi, wi, clr] = size(rx_ref);
tx_re_prj = uint8(zeros(hi, wi_ext, clr)); % 重投影图像，uint8
tx_m = uint8(zeros(hi, wi_ext)); % each element varies from 0 to 255. All elements are initialized to 0, 2D array

%  从xoy到x'o'y'的坐标变换矩阵
Trl = [1  0  0
    0 -1  hi - 1
    0  0  1];  % 这里要考虑基数为0还是为1的问题，因为这里的坐标关系到了真实的图像坐标。
% 本程序采用的基数为0，与标定时采用的基数一致，在处理原始图像和最后生成图像时，需要转换基数（即要平移坐标系）

%% Get the the first component of the (RS)-1CR
c1 = rx_rs \ rx_cr;
c1 = c1(1);
c = [c1; -rx_cs(1); -rx_cs(2)];

% matrices that carry out the map ur''-->ur
min_T = rx_rs * c - rx_cr;
m_mat = inv(Trl) * rx_kr * rx_rr;
h_mat =  m_mat * inv(rx_rs) * inv(rx_ks) * Trl;
t_mat = m_mat * min_T;

% 计算IR"的投影矩阵，4 x 4
zero_vector = [0 0 0 0]';
LastLine = [0 0 0 1];
ks_rs = rx_ks * rx_rs;  % 3 x 3
tx_pv = [ks_rs -ks_rs * rx_cr];  % 3 x 4
tx_pv = [tx_pv; LastLine]; % 4 x 4, LastLine: 全局变量在函数里是不可见的
tmp_t = [ -ks_rs * min_T; 0]; % 4 x 1
tx_pv = tx_pv + [zero_vector zero_vector zero_vector tmp_t];  % 4 x 4

%% 生成IR'
% for i = 0 : hi - 1 %  按行扫描
%     for j = 0 : wi - 1
%         zr_ur = h_mat * [j; i; 1];
%         ur = round(hnormalise(zr_ur));  %  取整。必须先对ur规范化。采用单应矩阵计算出的坐标相差一个比例因子，而用于
%         %  计算的像素的坐标总是规范化齐次坐标。因此应该对齐次坐标规范化。最终结果和先求出zr再规范化是一样的。
%
%         if (ur(2) >= 0) && (ur(2) <= hi - 1) && (ur(1) >= 0) && (ur(1) <= wi - 1)  % ur在原始图像平面范围内
%             tx_re_prj(i + 1, j + 1, :) = rx_ref(ur(2) + 1, ur(1) + 1, :);   %  将 ur对应的像素拷贝到点(j + 1, i + 1)的位置，基数为0，生成IR'
%             tx_m(i + 1, j + 1) =  rx_d(ur(2) + 1, ur(1) + 1); % j + 1列，i + 1行。由于RGB分量都相同，就取其中一个。求解warped depth map时不需要坐标变换，直接拷贝即可。2D array
%         end;
%
%     end
% end

%% 正向映射
% p_m_mat = inv(Trl) * ks_rs;
% p_h_mat = p_m_mat * inv(rx_rr) * inv(rx_kr) * Trl;
% p_t_mat = p_m_mat * min_T;
%
% for i = 0 : hi - 1 %  按行扫描IR
%     for j = 0 : wi - 1
%         get zr
%         处理点[j; i; 1]，该点坐标是xoy坐标系中的坐标，即原点在图像的左上角
%         读取深度图上点[j; i; 1]的值
%         d = rx_d(i + 1, j + 1); % j + 1列，i + 1行。由于RGB分量都相同，就取其中一个
%         zw = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  世界坐标系下的坐标值
%         [xw, yw] = projUVZtoXY(hi, rx_pr, double(j), double(i), zw); % 基数为0
%         zr = rx_rr * [xw; yw; zw] + rx_ref_t; % 3 x 1,xRyRzR下的坐标值（摄像机5的摄像机坐标系）
%         zr = zr(3); % zs is the depth value of us with respect to the camera coordinate system of Camera 5 (reference image)，
%
%         zs_ur2 = p_h_mat * (zr * [j; i; 1]) - p_t_mat;  %  ur2代表IR"平面中的点
%
%         ur2 = round(hnormalise(zs_ur2));  %  取整。必须先对ur2规范化。采用单应矩阵计算出的坐标相差一个比例因子，而用于
%          计算的像素的坐标总是规范化齐次坐标。因此应该对齐次坐标规范化。最终结果和先求出zr再规范化是一样的。
%
%         if (ur2(2) >= 0) && (ur2(2) <= hi - 1) && (ur2(1) >= 0) && (ur2(1) <= wi - 1)  % ur2在IR"范围内
%             tx_re_prj(ur2(2) + 1, ur2(1) + 1, :) = rx_ref(i + 1, j + 1, :);   %  将 (j + 1, i + 1)对应的像素拷贝到点ur2的位置，基数为0
%             tx_m(ur2(2) + 1, ur2(1) + 1) =  d; % j + 1列，i + 1行。求解warped depth map时不需要坐标变换，直接拷贝即可。
%         end;
%     end
% end

% 扩展深度图，扩展这一部分的深度图的值为0，表示最远的距离，这种情况下，重投影回来的像素相对于参考图像的平移。
ext_d_w = uint8(zeros(768, 896, 3));
% ext_d_w(:, :, :) = 255; % 设置0和255是有区别的。
rx_d  = cat(2, rx_d, ext_d_w);

%% 生成IR"
for i = 0 : hi - 1 %  按行扫描
    for j = 0 : wi_ext - 1
        % get zs
        % 处理点[j; i; 1]，该点坐标是xoy坐标系中的坐标，即原点在图像的左上角
        % 读取深度图上点[j; i; 1]的值
        d = rx_d(i + 1, j + 1); % j + 1列，i + 1行。由于RGB分量都相同，就取其中一个
        zw = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  世界坐标系下的坐标值
        [xw, yw] = projUVZtoXY(hi, rx_pr, double(j), double(i), zw); % 基数为0
        zs = rx_rs * [xw; yw; zw] + rx_des_t; % 3 x 1
        zs = zs(3); % zs is the depth value of us with respect to the camera coordinate system of Camera 4 (destination image)，
        % 所有参考图像上的点对应的深度值经过上述变换后，变到了摄像机4的摄像机坐标系下的深度图。由于Breakdancers世界坐标系与摄像机坐标系基本重合，所以深度值变换坐标系后基本没变。
        
        zr_ur = h_mat * (zs * [j; i; 1]) + t_mat;     %  ur代表原始图像平面中的点
        
        ur = round(hnormalise(zr_ur));  %  取整。必须先对ur规范化。采用单应矩阵计算出的坐标相差一个比例因子，而用于
        %  计算的像素的坐标总是规范化齐次坐标。因此应该对齐次坐标规范化。最终结果和先求出zr再规范化是一样的。
        
        if (ur(2) >= 0) && (ur(2) <= hi - 1) && (ur(1) >= 0) && (ur(1) <= wi - 1)  % ur在原始图像平面范围内
            tx_re_prj(i + 1, j + 1, :) = rx_ref(ur(2) + 1, ur(1) + 1, :);   %  将 ur对应的像素拷贝到点(j + 1, i + 1)的位置，基数为0
            tx_m(i + 1, j + 1) =  rx_d(ur(2) + 1, ur(1) + 1); % j + 1列，i + 1行。由于RGB分量都相同，就取其中一个。求解warped depth map时不需要坐标变换，直接拷贝即可。
        end;
    end;
end;

end