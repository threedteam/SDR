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
% tx_ides: ����ӳ���ز������ͼ��1024 x 768 x 3
% tx_m: �ǿն�����[-1, 255], double, 1024 x 768
% rx_ides_sdr: ����SDR���Ŀ��ͼ��
% rx_m_sdr: ides_sdr����Ӧ�ķǿն�����
% rx_is: ��άͼ��任�����ɵ�Camera 4��ͼ��IS
% rx_m: IS��Ӧ�����ͼ��[-1, 255], 1024 x 768
% rx_ps: projection matrix of destination image IS, 4 x 4
% rx_im_re_prj: IR����ͶӰ��ͼ��1920 x 768 x 3
% rx_im_re_prj_m:IR����ͶӰ��ͼ���Ӧ�����ͼ, 1920 x 768
% rx_pv: the projection matrix of im_re_prj, 4 x 4
% rx_min_z: minimum actual z (depth)
% rx_max_z: maximum actual z (depth)

tx_ides = rx_ides_sdr; % 1024 x 768 x 3
tx_m = rx_m_sdr; % 1024 x 768
[m_Height, m_Width, ~] = size(rx_is);
[~, m_w_ext, ~] = size(rx_im_re_prj);

% for i = 0 : m_Height - 1 % ����ɨ�裬���д��������rx_is, ����Ϊ0
%     j = m_Width - 1;
%     while(j > 0) % �������������ն����ұ�Ե
%         if (rx_m(i + 1, j, 1) == -1 && rx_m(i + 1, j + 1, 1) ~= -1) % Ѱ�ҿն��ұ�Ե�ķǿ����ص㣬����Ϊ0
%             % �����ɵ�Camera 4��ͼ��IS�ն��ұ�Ե�ķǿ����ص�ͶӰ��IR����ͶӰͼ��IR"
%             d = rx_m(i + 1, j + 1); % j + 1�У�i + 1�С�
%             z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  ��������ϵ�µ�����ֵ
%             % ��Ballet������Breakdancers�����е����ͼ�����ֵ������ʱ�Ѿ���������������ϵ�������ӵ�ĸ������ص�zֵ���Ѿ��任������������ϵ��
%             %  ����Ҫ�ٿ��ǴӲο�ͼ���Ӧ������������������ϵ�任����������ϵ
%             [x, y] = projUVZtoXY(m_Height, rx_ps, j, i, z); % ����Ϊ0, rx_pr�������4��ͶӰ����
%             [u, ~] = projXYZtoUV(m_Height, rx_pv, x, y, z); % ����Ϊ0��rx_pv����ͶӰͼ��IR"��Ӧ�ľ��������ϣ�[i + 1, j + 1]��[u, v]����ɨ�������ԣ����i + 1 = v
%
%             % �����IS�ն��ұ�Ե�Ŀն�����ֱ�������ǿ����ص�ʱ�������ն����ص����
%             num = 0;
%             while(rx_m(i + 1, j) == -1 && j > 1) % j > 1 ��Ϊ�˷�ֹ������߽�
%                 num = num + 1;
%                 j = j - 1;
%             end
%
%             % ��IR"�������ؿ�����ֱ�Ӹ���num������
%             if (u + 2 + num <= m_w_ext) % �ж��Ƿ񳬽�
%                 tx_ides(i + 1, j + 1 : j + num, :) = rx_im_re_prj(i + 1, u + 2 : u + 1 + num, :); % j + 1ӳ�䵽u + 1�������Ǵ�u + 2��ʼ��һ������num������
%                 tx_m(i + 1, j + 1 : j + num) = rx_im_re_prj_m(i + 1, u + 2 : u + 1 + num); % rx_im_re_prj_m�� 1920 x 768
%             end
%         end
%         j = j - 1;
%     end
% end

for i = 0 : m_Height - 1 % ����ɨ�裬���д��������rx_is, ����Ϊ0
    j = 0;
    while(j < m_Width - 1) % �������������ն������Ե����ǰ��(i + 1, j + 1)
        num = 0;
        k = j + 1; % kָ��ǰ��
        
        if (rx_m(i + 1, j + 1) ~= -1 && rx_m(i + 1, j + 2) == -1) % Ѱ�ҿն����Ե�ķǿ����ص㣬�������ҵ��Ŀն�������Ϊ0
            % �����ɵ�Camera 4��ͼ��IS�ն����Ե�ķǿ����ص�ͶӰ��IR����ͶӰͼ��IR"
            d = rx_m(i + 1, j + 1); % j + 1�У�i + 1�С�
            z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  ��������ϵ�µ�����ֵ
            % ��Ballet������Breakdancers�����е����ͼ�����ֵ������ʱ�Ѿ���������������ϵ�������ӵ�ĸ������ص�zֵ���Ѿ��任������������ϵ��
            %  ����Ҫ�ٿ��ǴӲο�ͼ���Ӧ������������������ϵ�任����������ϵ
            [x, y] = projUVZtoXY(m_Height, rx_ps, j, i, z); % ����Ϊ0, rx_pr�������4��ͶӰ����
            [u, ~] = projXYZtoUV(m_Height, rx_pv, x, y, z); % ����Ϊ0��rx_pv����ͶӰͼ��IR"��Ӧ�ľ��������ϣ�[i, j]��[u, v]����ɨ�������ԣ����i = v
            
            % �����IS�ն��ұ�Ե�Ŀն�����ֱ�������ǿ����ص�ʱ�������ն����ص����
            while(rx_m(i + 1, k + 1) == -1 && k + 1 < m_Width) % k + 1 < m_Width���Է�ֹ�����ұ߽�(��j < m_Width - 2),���һ�в�����
                num = num + 1;
                k = k + 1;
            end
            
            % ��ʱkָ��ն����ұ�Ե�����һ���ն���
            d = rx_m(i + 1, k + 1); % j + 1�У�i + 1�С�
            z = DepthLevelToZ(d, rx_min_z, rx_max_z);  %  ��������ϵ�µ�����ֵ
            % ��Ballet������Breakdancers�����е����ͼ�����ֵ������ʱ�Ѿ���������������ϵ�������ӵ�ĸ������ص�zֵ���Ѿ��任������������ϵ��
            %  ����Ҫ�ٿ��ǴӲο�ͼ���Ӧ������������������ϵ�任����������ϵ
            [x, y] = projUVZtoXY(m_Height, rx_ps, k, i, z); % ����Ϊ0, rx_pr�������4��ͶӰ����
            [ue, ~] = projXYZtoUV(m_Height, rx_pv, x, y, z); % ����Ϊ0��rx_pv����ͶӰͼ��IR"��Ӧ�ľ��������ϣ�[i, k - 1]��[ue, v]����ɨ�������ԣ����i = v
            
            % ��IR"�������ؿ���
            if (u + 1 + num <= m_w_ext && ue >= u) % �ж��Ƿ񳬽�
                if (ue - u + 1 >= num) % �㹻���ƣ�ֱ�Ӹ���num������
                    for cnt = 0 : num - 1  % ����ͶӰ�Ĳο�ͼ��������ص��copy
                        if (rx_m_sdr(i + 1, j + 2 + cnt) == -1) % SDRδ���ĵ��ʹ����ͶӰ�����
                            tx_ides(i + 1, j + 2 + cnt, :) = rx_im_re_prj(i + 1, u + 2 + cnt, :); % j + 1ӳ�䵽u + 1�������Ǵ�u + 2��ʼ��һ������num������
                            tx_m(i + 1, j + 2 + cnt) = rx_im_re_prj_m(i + 1, u + 2 + cnt); % rx_im_re_prj_m�� 1920 x 768
                        end
                    end
                else
                    % ����
                    for cnt = 0 : ue - u - 1  % ����ͶӰ�Ĳο�ͼ��������ص��copy
                        if (rx_m_sdr(i + 1, j + 2 + cnt) == -1) % SDRδ���ĵ��ʹ����ͶӰ�����
                            tx_ides(i + 1, j + 2 + cnt, :) = rx_im_re_prj(i + 1, u + 2 + cnt, :); % j + 1ӳ�䵽u + 1�������Ǵ�u + 2��ʼ����ue + 2����
                            tx_m(i + 1, j + 2 + cnt) = rx_im_re_prj_m(i + 1, u + 2 + cnt); % rx_im_re_prj_m�� 1920 x 768
                        end
                    end
                end
            end
            j = j + num; % �����ն����ұ�Ե�ĵ�һ���ն����ص�,����Ϊ0
        end
        j = j + 1;
        
    end
end

% a = rx_iref;
% tx_Ides = rx_ides;
% tx_m = rx_m ;
% [m_Height, m_Width, Clr] = size(rx_ides);
% % % ����Ŀ��ͼ��tx_ides���ⲿ��������
% % R_ides = rx_ides_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
% % T_ides = rx_ides_rt(:, 4); % 3 x 1
% % % ����ο�ͼ��tx_ides���ⲿ��������
% % R_ref = rx_ref_rt(1:3, 1:3); % 3 x 3, rotation matrix of tx_ides
% % T_ref = rx_ref_rt(:, 4); % 3 x 1
%
% for j =30:1:m_Height
%
%     i= m_Width;
%     while(i>=350)
%         while(rx_original_m(j,i,1)~=-1&&rx_original_m(j,i-1,1)==-1)% Ѱ�ҿն��ұ�Ե�����ص� ���ǿն���
%             us=i;
%             vs=j;
%             [ ur,vr ] = ref_coor(us,vs,rx_original_m, x_min_z, rx_max_z,m_Height,rx_ps,rx_pr);%��Ŀ��ͼ��ǿն���Ե��ͶӰ���ο�ͼ��
%             %                            if (ur<=500)
%             %                              vr= vr-6;
%             %
%             %                           end
%             % ����ӿն��ұ�Ե�Ŀն�����ֱ�������ǿյ�ʱ���ն��ĸ���
%             i=i-1;
%             num=0;
%             while(rx_original_m(j,i,1)==-1&&i>1)
%                 num=num+1;
%                 i=i-1;
%             end
%
%             for m= 1:num  %����ͶӰ�Ĳο�ͼ��������ص��copy
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

