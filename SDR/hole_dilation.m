function tx_m = hole_dilation(rx_m, rx_th_big_hole, rx_th_sharp, rx_n_dilation, rx_height, rx_width)
% HOLE_DILATION Dilate holes to correct matching errors
% tx_m: non-hole matrix after holes dilation
% rx_m: input non-hole matrix
% rx_th_big_hole: threshold for big hole identification
% rx_th_sharp: threshold for sharp depth transition detection
% rx_n_dilation: number of points to be dilated for big holes
% rx_width: width of image
% rx_height: height of image

% ������ֻ�ʺ�destination image is on the right side of reference image������

tx_m = rx_m; % Ԥ����ռ�

v = 1; % ָʾ��ǰ�е�ѭ��������1-based

while v <= rx_height % �����ұ���ÿһ�����ص�
    u = 1; % ָʾ��ǰ�е�ѭ��������1-based
    
    while u <= rx_width
        % ���ն�
        % num: �м������ǰ�治��rx��txǰ׺����ʾ��ǰ�ն��ı�Ե�����ǿն����м�Ŀն������,���ն��ĳ���
        % u: �м������ǰ�治��rx��txǰ׺���˴������uΪ��ǰ�ն����ұ�Ե�ĵ�һ���ǿն���ĺ�����,����ͼ����ұ߽磨�ն��㣩+
        % 1������û�б仯���ǿն��㣩����֮��
        [num, u] = hole_detection(tx_m(v, :), rx_width, u); % ����1��
        
        if num > 2 % ����3�����Ͽն���ļ���Ϊ�Ǵ�ն�
            % ���ͽϴ�ն�
            [tx_m(v,:), u] = dilate_big_holes(tx_m(v, :), rx_th_big_hole, rx_th_sharp, rx_n_dilation, num, u, rx_width, 0);
        end
        u = u + 1;
    end
    v = v + 1;
end

end

