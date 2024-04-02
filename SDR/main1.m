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
%     Filename         : main.m
%     Description      : code to draw the Fig. 6 in the paper entitled "
%                        Spatio-temporal Hole-filling for DIBR System"
%   ------------------------------------------------------------------------
%       Revision   |     DATA     |   Authors                     |   Changes
%   ------------------------------------------------------------------------
%         1.00     |  2014-10-28  |   Donghua Cao                 |   Original
%         1.01     |  2014-10-28  |   Ran Liu                     |   The code style has been changed
%   ------------------------------------------------------------------------
% =========================================================================================================
clc
clear
% 全局变量
local_path ='G:\' ;
svn_path = 'thesis_experiment_rxw\datasets\breakdancers\MSR3DVideo-Breakdancers\';%原始图像路径
tic;
%% 3D image warping for 100 frames
% initialise parameters
calib_params_breakdancers; % read the calibration parameters of “ballet” sequence
% 
% for idx = 0 : 99
%     % 读取摄像机5捕获的图像IR-color-cam5
%     if (idx < 10)
%         FileName = strcat(local_path, svn_path, 'cam5\color-cam5-f00', int2str(idx), '.jpg');
%         IR = imread(FileName);
%         
%         % 读取IR对应的深度图
%         FileName = strcat(local_path, svn_path, 'cam5\depth-cam5-f00', int2str(idx), '.png');
%         D = imread(FileName);
%     else
%         FileName = strcat(local_path, svn_path, 'cam5\color-cam5-f0', int2str(idx), '.jpg');
%         IR = imread(FileName);
%         
%         % 读取IR对应的深度图
%         FileName = strcat(local_path, svn_path, 'cam5\depth-cam5-f0', int2str(idx), '.png');
%         D = imread(FileName);
%     end
%     
%     % 3D image warping
%     [Ides, M] = threed_image_warping(IR, D, MinZ, MaxZ, m5_ProjMatrix, m4_RT, m4_ProjMatrix); % Ides: generated destination image, uint8; M: generated non-hole matrix, double
%     % imshow(Ides);
%     
% 	%消除匹配误差，膨胀边缘空洞
%     M = double(M);
%     hi = size(Ides, 1);
%     wi = size(Ides, 2);
%     th_big_hole = 3; % threshold for big hole detection. if the number of hole-points in a hole is greater than th_big_hole, the hole is labeled as a “big hole”
%     sharp_th = 4; % threshold for sharp transition
%     n_dilation = 3; % the number of points to be dilated
%     rend_order = 0; % flag of the rending order of the reference image. The destination image positioned at camera 4 is rendered from camera 5 (camera 5 ? camera 4), therefore the destination image is right view.
%     [Ides, M] = big_hole_dilation(Ides, M, th_big_hole, sharp_th, n_dilation, rend_order, wi, hi);
% % 
% %     % 去除空洞区域中竖的一列像素点。思路：如果某个像素点左右都是-1，则将该像素点置为-1
% %     for i = 1:hi
% %        for j = 1:wi
% %            if (j==1 && M(i,j)>-1 && M(i,j+1)==-1) || (j==wi &&M(i,j)>-1 && M(i,j-1)==-1) || ...
% %                    (j>1 && j<wi && M(i,j)>-1 && M(i,j-1)==-1 && M(i,j+1)==-1)
% %                M(i,j) = -1;
% %                Ides(i,j,:) = 0;
% %            end
% %        end
% %     end
%     FileName = strcat( 'Ides_breakdancers\Ides_breakdancers_des',int2str(idx),'.bmp');
%     imwrite(Ides, FileName);
%     FileName = strcat('Ides_breakdancers\Is_breakdancers_m', int2str(idx), 'M');
%     save(FileName, 'M', '-ASCII','-double');
% end
% % dilate_holes -- 曹
% %  for idx = 0: 0
% % svn_path = 'workspace\threed_tv\trunk\hardware\DIBR\doc\paper\Spatio-temporal Hole-filling for DIBR System\code\Fig6\ballet\';
% %     FileName = strcat(local_path, svn_path, 'M\Is_Ballet_m', int2str(idx), 'M');
% %     M = dlmread(FileName);
% %      [ M1 ] = dilate_big_holes( M, 3, 50, 4, 1024, 768);
% %     FileName = strcat(local_path, svn_path, 'Ides\Is_Ballet_m', int2str(idx), 'M');
% %     save(FileName, 'M1', '-ASCII','-double'); 
% % end
% 
% % SDR for 100 frames
% for idx =0 :99
% FileName = strcat('Ides_breakdancers\Ides_breakdancers_des', int2str(idx), '.bmp');
% Fig6_c = imread(FileName); % 读取待修补目标图像
% FileName = strcat('Ides_breakdancers\Is_breakdancers_m', int2str(idx), 'M');
% Fig6_c_m = dlmread(FileName);
% pPointer = idx;
% nPointer = idx;
% while (pPointer > 0 || nPointer < 99)
%     % 用当前帧前面的帧去补
%     if (pPointer > 0)
%         pPointer = pPointer - 1;
%         FileName = strcat('Ides_breakdancers\Ides_breakdancers_des', int2str(pPointer), '.bmp');
%         Ides_other_p = imread(FileName);
%         FileName = strcat('Ides_breakdancers\Is_breakdancers_m', int2str(pPointer), 'M');
%         M_other_p = dlmread( FileName);
%         [Fig6_c, Fig6_c_m] = sdr_copy_single_frame(Fig6_c, Ides_other_p, Fig6_c_m, M_other_p, 100, 768, 1024);
%     end
%     
%     % 用当前帧后面的帧去补
%     if (nPointer < 99)
%         nPointer = nPointer + 1;
%         FileName = strcat('Ides_breakdancers\Ides_breakdancers_des', int2str(nPointer), '.bmp');
%         Ides_other_n = imread(FileName);
%         FileName = strcat('Ides_breakdancers\Is_breakdancers_m', int2str(nPointer), 'M');
%         M_other_n = dlmread(FileName);
%         [Fig6_c, Fig6_c_m] = sdr_copy_single_frame(Fig6_c, Ides_other_n, Fig6_c_m, M_other_n, 100, 768, 1024);
%     end
% end
% FileName = strcat( 'SDR_breakdancers\Ides_sdr_breakdancers_',int2str(idx),'.bmp');
% imwrite(Fig6_c, FileName);
% % imshow(uint8(Fig6_c));
% FileName = strcat('SDR_breakdancers\Ides_sdr_breakdancers_',int2str(idx),'M');
% save(FileName, 'Fig6_c_m', '-ASCII', '-double');
% end
% 
% % Image projection
% for idx=0:99
%     % 读取摄像机5捕获的图像IR-color-cam5
%     if (idx < 10)
%         FileName = strcat(local_path, svn_path, 'cam5\color-cam5-f00', int2str(idx), '.jpg');
%         IR = imread(FileName);
%         % 读取IR对应的深度图
%         FileName = strcat(local_path, svn_path, 'cam5\depth-cam5-f00', int2str(idx), '.png');
%         D = imread(FileName);
%     else
%         FileName = strcat(local_path, svn_path, 'cam5\color-cam5-f0', int2str(idx), '.jpg');
%         IR = imread(FileName);
%         % 读取IR对应的深度图
%         FileName = strcat(local_path, svn_path, 'cam5\depth-cam5-f0', int2str(idx), '.png');
%         D = imread(FileName);
%     end
% % [Ides, dD] = Image_project(IR, D, m5_RT ,m5_K, m4_RT, m4_K );
% [Ides, M, PV] = im_reprojection(IR, D, MinZ, MaxZ, m4_K, m4_R, m4_C, m4_T, m5_ProjMatrix, m5_K, m5_R, m5_C, m5_T);
% dD = cat(3, M, M, M); % Fig4_c_m: Hi x Wi x 3
% FileName = strcat('projection_breakdancers\color', int2str(idx),'.bmp');
% imwrite(uint8(Ides),FileName);
% FileName = strcat('projection_breakdancers\depth', int2str(idx),'.bmp');
% imwrite(uint8(dD),FileName);
% end
% % 目标图逆采样
for  idx=0:99
% 读取三维图像变换和膨胀大空洞后生成的Camera 4的图像IS
    FileName = strcat('Ides_breakdancers\Ides_breakdancers_des', int2str(idx), '.bmp');
    IS = imread(FileName);
    % 读取IS对应的深度图
    FileName = strcat('Ides_breakdancers\Is_breakdancers_m', int2str(idx), 'M');
    D = load(FileName); % -1：空洞

    % 读取经过SDR后的目标图像ides_sdr及对应的非空洞矩阵m_sdr
    FileName = strcat('SDR_breakdancers\Ides_sdr_breakdancers_', int2str(idx), '.bmp');
    ides_sdr = imread(FileName);
    % 读取ides_sdr对应的深度图
    FileName = strcat('SDR_breakdancers\Ides_sdr_breakdancers_', int2str(idx), 'M');
    m_sdr = load(FileName); % -1：空洞

    % 读取IR的重投影的图像im_re_prj
    FileName = strcat('projection_breakdancers/color', int2str(idx), '.bmp');
    im_re_prj = imread(FileName);
    % 读取IR的重投影的图像对应的深度图im_re_prj
    FileName = strcat('projection_breakdancers/depth', int2str(idx), '.bmp');
    im_re_prj_m = imread(FileName);

    % get PV
    PV = get_pv(m4_K, m4_R, m4_C, m5_C);
    [Ides, M] = backward_resampling(ides_sdr, m_sdr, IS, D, m4_ProjMatrix, im_re_prj, im_re_prj_m, PV, MinZ, MaxZ);
%     [Ides,M] = projection_holefilling(Is,M,original_M,IR,D,MinZ, MaxZ, m5_ProjMatrix, m4_ProjMatrix);
    FileName = strcat('projection_holefilling_breakdancers\Ides_ project-',int2str(idx),'.bmp');
    imwrite(uint8(Ides),FileName);
    M(M == -1) = 0; % for display only, holes are  labeled “0”. There is no pixel like [0, 0, 0]' in "ballet" sequence
    dD = cat(3, M, M, M); % Fig4_a_m: Hi x Wi x Clr
    dD = uint8(dD);
    FileName = strcat('projection_holefilling_breakdancers\Ides_ project-depth',int2str(idx),'.bmp');
    imwrite(uint8(dD),FileName);
%% 后处理-滤波
    Ides=Filter(Ides);
%     imshow(Ides);
    dD=Filter(dD);
    %  figure;
    %  imshow(dD);
    % [Id,Ddes] =inpainting1(Ides,dD(:,:,1),1024,768,1,50,19,17,0.01,1,3);% 修复算法
    Id=Ides;
    Ddes=dD;
    Ddes(Ddes==0)=255;
    Ddes(Ddes~=255)=0;
    
    %转为白色
    Id(Ddes == 255) = 255;
    
    FileName = strcat('filter_breakdancers\Is_breakdancers_des',int2str(idx),'.png');
    imwrite(uint8(Id),FileName);
%     figure;
%     imshow(uint8(Id));
    FileName = strcat('filter_breakdancers\Is_breakdancers_des',int2str(idx),'_mask.png');
    imwrite(uint8(Ddes),FileName);
end
toc;
%% output