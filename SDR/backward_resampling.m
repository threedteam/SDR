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
%     Filename         : backward_resampling.m
%     Description      : the function to perform backward resampling
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-11-26  |   Donghua Cao                 |   Original
%         1.00     |  2018-11-27  |   Ran Liu                     |   Revised according to new formula of backward resampling
%   ------------------------------------------------------------------------
% =========================================================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [tx_ides, tx_m] = backward_resampling(rx_ides_sdr, rx_m_sdr, rx_is, rx_m, rx_ps, rx_im_re_prj, rx_im_re_prj_m, rx_pv, rx_min_z, rx_max_z)
% tx_ides: 反向映射重采样后的图像，1024 x 768 x 3
% tx_m: 非空洞矩阵，[-1, 255], double, 1024 x 768
% rx_ides_sdr: 经过SDR后的目标图像
% rx_m_sdr: ides_sdr及对应的非空洞矩阵
% rx_is: 三维图像变换后生成的Camera 4的图像IS
% rx_m: IS对应的深度图，[-1, 255], 1024 x 768
% rx_ps: projection matrix of destination image IS, 4 x 4
% rx_im_re_prj: IR的重投影的图像，1920 x 768 x 3
% rx_im_re_prj_m:IR的重投影的图像对应的深度图, 1920 x 768
% rx_pv: the projection matrix of im_re_prj, 4 x 4
% rx_min_z: minimum actual z (depth)
% rx_max_z: maximum actual z (depth)

tx_ides = rx_ides_sdr; % 1024 x 768 x 3
tx_m = rx_m_sdr; % 1024 x 768
[m_Height, m_Width, ~] = size(rx_is);
[~, m_w_ext, ~] = size(rx_im_re_prj);

% for i = 0 : m_Height - 1 % 按行扫描，逐行处理输入的rx_is, 基数为0
%     j = m_Width - 1;
%     while(j > 0) % 从右向左搜索空洞的右边缘
%         if (rx_m(i + 1, j, 1) == -1 && rx_m(i + 1, j + 1, 1) ~= -1) % 寻找空洞右边缘的非空像素点，基数为0
%             % 将生成的Camera 4的图像IS空洞右边缘的非空像素点投影到IR的重投影图像IR"
%             d = rx_m(i + 1, j + 1); % j + 1列，i + 1行。
%             z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  世界坐标系下的坐标值
%             % “Ballet”、“Breakdancers”序列的深度图的深度值在量化时已经考虑了世界坐标系，各个视点的各个像素的z值都已经变换到了世界坐标系中
%             %  不需要再考虑从参考图像对应的摄像机的摄像机坐标系变换到世界坐标系
%             [x, y] = projUVZtoXY(m_Height, rx_ps, j, i, z); % 基数为0, rx_pr：摄像机4的投影矩阵
%             [u, ~] = projXYZtoUV(m_Height, rx_pv, x, y, z); % 基数为0，rx_pv：重投影图像IR"对应的矩阵。理论上，[i + 1, j + 1]和[u, v]满足扫描线特性，因此i + 1 = v
%
%             % 计算从IS空洞右边缘的空洞算起，直到遇见非空像素点时，连续空洞像素点个数
%             num = 0;
%             while(rx_m(i + 1, j) == -1 && j > 1) % j > 1 是为了防止超出左边界
%                 num = num + 1;
%                 j = j - 1;
%             end
%
%             % 从IR"进行像素拷贝，直接复制num个像素
%             if (u + 2 + num <= m_w_ext) % 判断是否超界
%                 tx_ides(i + 1, j + 1 : j + num, :) = rx_im_re_prj(i + 1, u + 2 : u + 1 + num, :); % j + 1映射到u + 1，拷贝是从u + 2开始，一共拷贝num个像素
%                 tx_m(i + 1, j + 1 : j + num) = rx_im_re_prj_m(i + 1, u + 2 : u + 1 + num); % rx_im_re_prj_m： 1920 x 768
%             end
%         end
%         j = j - 1;
%     end
% end

for i = 0 : m_Height - 1 % 按行扫描，逐行处理输入的rx_is, 基数为0
    j = 0;
    while(j < m_Width - 1) % 从左向右搜索空洞的左边缘，当前点(i + 1, j + 1)
        num = 0;
        k = j + 1; % k指向当前点
        
        if (rx_m(i + 1, j + 1) ~= -1 && rx_m(i + 1, j + 2) == -1) % 寻找空洞左边缘的非空像素点，并处理找到的空洞。基数为0
            % 将生成的Camera 4的图像IS空洞左边缘的非空像素点投影到IR的重投影图像IR"
            d = rx_m(i + 1, j + 1); % j + 1列，i + 1行。
            z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  世界坐标系下的坐标值
            % “Ballet”、“Breakdancers”序列的深度图的深度值在量化时已经考虑了世界坐标系，各个视点的各个像素的z值都已经变换到了世界坐标系中
            %  不需要再考虑从参考图像对应的摄像机的摄像机坐标系变换到世界坐标系
            [x, y] = projUVZtoXY(m_Height, rx_ps, j, i, z); % 基数为0, rx_pr：摄像机4的投影矩阵
            [u, ~] = projXYZtoUV(m_Height, rx_pv, x, y, z); % 基数为0，rx_pv：重投影图像IR"对应的矩阵。理论上，[i, j]和[u, v]满足扫描线特性，因此i = v
            
            % 计算从IS空洞右边缘的空洞算起，直到遇见非空像素点时，连续空洞像素点个数
            while(rx_m(i + 1, k + 1) == -1 && k + 1 < m_Width) % k + 1 < m_Width可以防止超出右边界(即j < m_Width - 2),最后一列不处理
                num = num + 1;
                k = k + 1;
            end
            
            % 此时k指向空洞的右边缘的最后一个空洞点
            d = rx_m(i + 1, k + 1); % j + 1列，i + 1行。
            z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  世界坐标系下的坐标值
            % “Ballet”、“Breakdancers”序列的深度图的深度值在量化时已经考虑了世界坐标系，各个视点的各个像素的z值都已经变换到了世界坐标系中
            %  不需要再考虑从参考图像对应的摄像机的摄像机坐标系变换到世界坐标系
            [x, y] = projUVZtoXY(m_Height, rx_ps, k, i, z); % 基数为0, rx_pr：摄像机4的投影矩阵
            [ue, ~] = projXYZtoUV(m_Height, rx_pv, x, y, z); % 基数为0，rx_pv：重投影图像IR"对应的矩阵。理论上，[i, k - 1]和[ue, v]满足扫描线特性，因此i = v
            
            % 从IR"进行像素拷贝
            if (u + 1 + num <= m_w_ext && ue >= u) % 判断是否超界
                if (ue - u + 1 >= num) % 足够复制，直接复制num个像素
                    for cnt = 0 : num - 1  % 从重投影的参考图像进行像素点的copy
                        if (rx_m_sdr(i + 1, j + 2 + cnt) == -1) % SDR未填充的点才使用重投影法填充
                            tx_ides(i + 1, j + 2 + cnt, :) = rx_im_re_prj(i + 1, u + 2 + cnt, :); % j + 1映射到u + 1，拷贝是从u + 2开始，一共拷贝num个像素
                            tx_m(i + 1, j + 2 + cnt) = rx_im_re_prj_m(i + 1, u + 2 + cnt); % rx_im_re_prj_m： 1920 x 768
                        end
                    end
                else
                    % 不足
                    for cnt = 0 : ue - u - 1  % 从重投影的参考图像进行像素点的copy
                        if (rx_m_sdr(i + 1, j + 2 + cnt) == -1) % SDR未填充的点才使用重投影法填充
                            tx_ides(i + 1, j + 2 + cnt, :) = rx_im_re_prj(i + 1, u + 2 + cnt, :); % j + 1映射到u + 1，拷贝是从u + 2开始，到ue + 2结束
                            tx_m(i + 1, j + 2 + cnt) = rx_im_re_prj_m(i + 1, u + 2 + cnt); % rx_im_re_prj_m： 1920 x 768
                        end
                    end
                end
            end
            j = j + num; % 跳到空洞的右边缘的第一个空洞像素点,基数为0
        end
        j = j + 1;
        
    end
end

% a = rx_iref;
% tx_Ides = rx_ides;
% tx_m = rx_m ;
% [m_Height, m_Width, Clr] = size(rx_ides);
% % % 计算目标图像tx_ides的外部参数矩阵
% % R_ides = rx_ides_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
% % T_ides = rx_ides_rt(:, 4); % 3 x 1
% % % 计算参考图像tx_ides的外部参数矩阵
% % R_ref = rx_ref_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
% % T_ref = rx_ref_rt(:, 4); % 3 x 1
%
% for j =30:1:m_Height
%
%     i= m_Width;
%     while(i>=350)
%         while(rx_original_m(j,i,1)~=-1&&rx_original_m(j,i-1,1)==-1)% 寻找空洞右边缘的像素点 （非空洞）
%             us=i;
%             vs=j;
%             [ ur,vr ] = ref_coor(us,vs,rx_original_m, x_min_z, rx_max_z,m_Height,rx_ps,rx_pr);%将目标图像非空洞边缘点投影到参考图像
%             %                            if (ur<=500)
%             %                              vr= vr-6;
%             %
%             %                           end
%             % 计算从空洞右边缘的空洞算起，直到遇见非空点时，空洞的个数
%             i=i-1;
%             num=0;
%             while(rx_original_m(j,i,1)==-1&&i>1)
%                 num=num+1;
%                 i=i-1;
%             end
%
%             for m= 1:num  %从重投影的参考图像进行像素点的copy
%                 %                               tx_Ides(j , i+m, 1)= 0;
%                 %                                 tx_Ides(j , i+m, 2)= 0;
%                 %                                  tx_Ides(j , i+m, 3)= 255;
%                 %                                   a ( vr,ur+m-1,1)= 0;
%                 %                               a ( vr,ur+m-1,2)= 255;
%                 %                               a ( vr,ur+m-1,3)= 0;
%                 if (rx_original_m(j,i+m,1)==-1)
%                     if (rx_m(j,i+m,1)==-1)
%                         tx_Ides(j , i+m, :)= rx_iref( vr,ur+m-1,:);
%                         %                                tx_Ides(j , i+m, 1)= 255;
%                         %                                 tx_Ides(j , i+m, 2)= 0;
%                         %                                  tx_Ides(j , i+m, 3)= 0;
%                         %
%                         %
%                         %                               a ( vr,ur+m-1,1)= 255;
%                         %                               a ( vr,ur+m-1,2)= 0;
%                         %                               a ( vr,ur+m-1,3)= 0;
%                         tx_m(j , i+m) = rx_id( vr,ur+m-1,1) ;
%                     end
%
%                 end
%             end
%         end
%
%         i=i-1;
%
%
%
%
%
%
%
%
%
%
%
%     end
%
% end
% % FileName = strcat('F:\hole_filling\ballet\result\Ides_ project-aaaa.bmp');
% % imwrite(uint8(a),FileName);
% end

