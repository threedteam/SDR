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
%     Filename         :projection_holefilling .m
%     Description      : the function to perform hole_filling use ref_image
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-11-26  |   Donghua Cao                 |   Original
%   ------------------------------------------------------------------------
% =========================================================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [tx_Ides,tx_m] = projection_holefilling(rx_ides,rx_m,rx_original_m,rx_iref,rx_id,x_min_z, rx_max_z,rx_pr,rx_ps)
% tx_ides: generated destination image, uint8
% tx_m: generated non-hole matrix, double
% rx_iref: reference image
% rx_d: depth map
% rx_min_z: minimum actual z (depth)
% rx_max_z: maximum actual z (depth)
% rx_pr: projection matrix of reference image, 4 x 4
% rx_ides_rt: affine transformation matrix of destination image, 3 x 4
% rx_ps: projection matrix of destination image, 4 x 4
a = rx_iref;
tx_Ides = rx_ides;
tx_m = rx_m ;
[m_Height, m_Width, Clr] = size(rx_ides);
% % 计算目标图像tx_ides的外部参数矩阵
% R_ides = rx_ides_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
% T_ides = rx_ides_rt(:, 4); % 3 x 1
% % 计算参考图像tx_ides的外部参数矩阵
% R_ref = rx_ref_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
% T_ref = rx_ref_rt(:, 4); % 3 x 1

for j =30:1:m_Height
    
    i= m_Width;
    while(i>=350)
        while(rx_original_m(j,i,1)~=-1&&rx_original_m(j,i-1,1)==-1)% 寻找空洞右边缘的像素点 （非空洞）
            us=i;
            vs=j;
            [ ur,vr ] = ref_coor(us,vs,rx_original_m, x_min_z, rx_max_z,m_Height,rx_ps,rx_pr);%将目标图像非空洞边缘点投影到参考图像
            %                            if (ur<=500)
            %                              vr= vr-6;
            %
            %                           end
            % 计算从空洞右边缘的空洞算起，直到遇见非空点时，空洞的个数
            i=i-1;
            num=0;
            while(rx_original_m(j,i,1)==-1&&i>1)
                num=num+1;
                i=i-1;
            end
            
            for m= 1:num  %从重投影的参考图像进行像素点的copy
                %                               tx_Ides(j , i+m, 1)= 0;
                %                                 tx_Ides(j , i+m, 2)= 0;
                %                                  tx_Ides(j , i+m, 3)= 255;
                %                                   a ( vr,ur+m-1,1)= 0;
                %                               a ( vr,ur+m-1,2)= 255;
                %                               a ( vr,ur+m-1,3)= 0;
                if (rx_original_m(j,i+m,1)==-1)
                    if (rx_m(j,i+m,1)==-1)
                        tx_Ides(j , i+m, :)= rx_iref( vr,ur+m-1,:);
                        %                                tx_Ides(j , i+m, 1)= 255;
                        %                                 tx_Ides(j , i+m, 2)= 0;
                        %                                  tx_Ides(j , i+m, 3)= 0;
                        %
                        %
                        %                               a ( vr,ur+m-1,1)= 255;
                        %                               a ( vr,ur+m-1,2)= 0;
                        %                               a ( vr,ur+m-1,3)= 0;
                        tx_m(j , i+m) = rx_id( vr,ur+m-1,1) ;
                    end
                    
                end
            end
        end
        
        i=i-1;
        
        
        
        
        
        
        
        
        
        
        
    end
    
end
% FileName = strcat('F:\hole_filling\ballet\result\Ides_ project-aaaa.bmp');
% imwrite(uint8(a),FileName);
end

