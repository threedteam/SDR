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
%     Corresponding author��Ran Liu
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

%% ��������õĻ���Ϊ0����궨ʱ���õĻ���һ�£��ڴ���ԭʼͼ����������ͼ��ʱ����Ҫת����������Ҫƽ������ϵ��
% ����ռ�
% image resolution is hi x wi,
% hi:ͼ��ĸ�
% wi:ͼ��Ŀ�
% clr:ͼ���ҳ
wi_ext = 1920;
[hi, wi, clr] = size(rx_ref);
tx_re_prj = uint8(zeros(hi, wi_ext, clr)); % ��ͶӰͼ��uint8
tx_m = uint8(zeros(hi, wi_ext)); % each element varies from 0 to 255. All elements are initialized to 0, 2D array

%  ��xoy��x'o'y'������任����
Trl = [1  0  0
    0 -1  hi - 1
    0  0  1];  % ����Ҫ���ǻ���Ϊ0����Ϊ1�����⣬��Ϊ����������ϵ������ʵ��ͼ�����ꡣ
% ��������õĻ���Ϊ0����궨ʱ���õĻ���һ�£��ڴ���ԭʼͼ����������ͼ��ʱ����Ҫת����������Ҫƽ������ϵ��

%% Get the the first component of the (RS)-1CR
c1 = rx_rs \ rx_cr;
c1 = c1(1);
c = [c1; -rx_cs(1); -rx_cs(2)];

% matrices that carry out the map ur''-->ur
min_T = rx_rs * c - rx_cr;
m_mat = inv(Trl) * rx_kr * rx_rr;
h_mat =  m_mat * inv(rx_rs) * inv(rx_ks) * Trl;
t_mat = m_mat * min_T;

% ����IR"��ͶӰ����4 x 4
zero_vector = [0 0 0 0]';
LastLine = [0 0 0 1];
ks_rs = rx_ks * rx_rs;  % 3 x 3
tx_pv = [ks_rs -ks_rs * rx_cr];  % 3 x 4
tx_pv = [tx_pv; LastLine]; % 4 x 4, LastLine: ȫ�ֱ����ں������ǲ��ɼ���
tmp_t = [ -ks_rs * min_T; 0]; % 4 x 1
tx_pv = tx_pv + [zero_vector zero_vector zero_vector tmp_t];  % 4 x 4

%% ����IR'
% for i = 0 : hi - 1 %  ����ɨ��
%     for j = 0 : wi - 1
%         zr_ur = h_mat * [j; i; 1];
%         ur = round(hnormalise(zr_ur));  %  ȡ���������ȶ�ur�淶�������õ�Ӧ�����������������һ���������ӣ�������
%         %  ��������ص��������ǹ淶��������ꡣ���Ӧ�ö��������淶�������ս���������zr�ٹ淶����һ���ġ�
%
%         if (ur(2) >= 0) && (ur(2) <= hi - 1) && (ur(1) >= 0) && (ur(1) <= wi - 1)  % ur��ԭʼͼ��ƽ�淶Χ��
%             tx_re_prj(i + 1, j + 1, :) = rx_ref(ur(2) + 1, ur(1) + 1, :);   %  �� ur��Ӧ�����ؿ�������(j + 1, i + 1)��λ�ã�����Ϊ0������IR'
%             tx_m(i + 1, j + 1) =  rx_d(ur(2) + 1, ur(1) + 1); % j + 1�У�i + 1�С�����RGB��������ͬ����ȡ����һ�������warped depth mapʱ����Ҫ����任��ֱ�ӿ������ɡ�2D array
%         end;
%
%     end
% end

%% ����ӳ��
% p_m_mat = inv(Trl) * ks_rs;
% p_h_mat = p_m_mat * inv(rx_rr) * inv(rx_kr) * Trl;
% p_t_mat = p_m_mat * min_T;
%
% for i = 0 : hi - 1 %  ����ɨ��IR
%     for j = 0 : wi - 1
%         get zr
%         �����[j; i; 1]���õ�������xoy����ϵ�е����꣬��ԭ����ͼ������Ͻ�
%         ��ȡ���ͼ�ϵ�[j; i; 1]��ֵ
%         d = rx_d(i + 1, j + 1); % j + 1�У�i + 1�С�����RGB��������ͬ����ȡ����һ��
%         zw = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  ��������ϵ�µ�����ֵ
%         [xw, yw] = projUVZtoXY(hi, rx_pr, double(j), double(i), zw); % ����Ϊ0
%         zr = rx_rr * [xw; yw; zw] + rx_ref_t; % 3 x 1,xRyRzR�µ�����ֵ�������5�����������ϵ��
%         zr = zr(3); % zs is the depth value of us with respect to the camera coordinate system of Camera 5 (reference image)��
%
%         zs_ur2 = p_h_mat * (zr * [j; i; 1]) - p_t_mat;  %  ur2����IR"ƽ���еĵ�
%
%         ur2 = round(hnormalise(zs_ur2));  %  ȡ���������ȶ�ur2�淶�������õ�Ӧ�����������������һ���������ӣ�������
%          ��������ص��������ǹ淶��������ꡣ���Ӧ�ö��������淶�������ս���������zr�ٹ淶����һ���ġ�
%
%         if (ur2(2) >= 0) && (ur2(2) <= hi - 1) && (ur2(1) >= 0) && (ur2(1) <= wi - 1)  % ur2��IR"��Χ��
%             tx_re_prj(ur2(2) + 1, ur2(1) + 1, :) = rx_ref(i + 1, j + 1, :);   %  �� (j + 1, i + 1)��Ӧ�����ؿ�������ur2��λ�ã�����Ϊ0
%             tx_m(ur2(2) + 1, ur2(1) + 1) =  d; % j + 1�У�i + 1�С����warped depth mapʱ����Ҫ����任��ֱ�ӿ������ɡ�
%         end;
%     end
% end

% ��չ���ͼ����չ��һ���ֵ����ͼ��ֵΪ0����ʾ��Զ�ľ��룬��������£���ͶӰ��������������ڲο�ͼ���ƽ�ơ�
ext_d_w = uint8(zeros(768, 896, 3));
% ext_d_w(:, :, :) = 255; % ����0��255��������ġ�
rx_d  = cat(2, rx_d, ext_d_w);

%% ����IR"
for i = 0 : hi - 1 %  ����ɨ��
    for j = 0 : wi_ext - 1
        % get zs
        % �����[j; i; 1]���õ�������xoy����ϵ�е����꣬��ԭ����ͼ������Ͻ�
        % ��ȡ���ͼ�ϵ�[j; i; 1]��ֵ
        d = rx_d(i + 1, j + 1); % j + 1�У�i + 1�С�����RGB��������ͬ����ȡ����һ��
        zw = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  ��������ϵ�µ�����ֵ
        [xw, yw] = projUVZtoXY(hi, rx_pr, double(j), double(i), zw); % ����Ϊ0
        zs = rx_rs * [xw; yw; zw] + rx_des_t; % 3 x 1
        zs = zs(3); % zs is the depth value of us with respect to the camera coordinate system of Camera 4 (destination image)��
        % ���вο�ͼ���ϵĵ��Ӧ�����ֵ���������任�󣬱䵽�������4�����������ϵ�µ����ͼ������Breakdancers��������ϵ�����������ϵ�����غϣ��������ֵ�任����ϵ�����û�䡣
        
        zr_ur = h_mat * (zs * [j; i; 1]) + t_mat;     %  ur����ԭʼͼ��ƽ���еĵ�
        
        ur = round(hnormalise(zr_ur));  %  ȡ���������ȶ�ur�淶�������õ�Ӧ�����������������һ���������ӣ�������
        %  ��������ص��������ǹ淶��������ꡣ���Ӧ�ö��������淶�������ս���������zr�ٹ淶����һ���ġ�
        
        if (ur(2) >= 0) && (ur(2) <= hi - 1) && (ur(1) >= 0) && (ur(1) <= wi - 1)  % ur��ԭʼͼ��ƽ�淶Χ��
            tx_re_prj(i + 1, j + 1, :) = rx_ref(ur(2) + 1, ur(1) + 1, :);   %  �� ur��Ӧ�����ؿ�������(j + 1, i + 1)��λ�ã�����Ϊ0
            tx_m(i + 1, j + 1) =  rx_d(ur(2) + 1, ur(1) + 1); % j + 1�У�i + 1�С�����RGB��������ͬ����ȡ����һ�������warped depth mapʱ����Ҫ����任��ֱ�ӿ������ɡ�
        end;
    end;
end;

end