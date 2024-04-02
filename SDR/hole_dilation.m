function tx_m = hole_dilation(rx_m, rx_th_big_hole, rx_th_sharp, rx_n_dilation, rx_height, rx_width)
% HOLE_DILATION Dilate holes to correct matching errors
% tx_m: non-hole matrix after holes dilation
% rx_m: input non-hole matrix
% rx_th_big_hole: threshold for big hole identification
% rx_th_sharp: threshold for sharp depth transition detection
% rx_n_dilation: number of points to be dilated for big holes
% rx_width: width of image
% rx_height: height of image

% 本程序只适合destination image is on the right side of reference image的情形

tx_m = rx_m; % 预分配空间

v = 1; % 指示当前行的循环变量，1-based

while v <= rx_height % 从左到右遍历每一个像素点
    u = 1; % 指示当前列的循环变量，1-based
    
    while u <= rx_width
        % 检测空洞
        % num: 中间变量，前面不加rx、tx前缀，表示当前空洞的边缘两个非空洞点中间的空洞点个数,即空洞的长度
        % u: 中间变量，前面不加rx、tx前缀，此处输出的u为当前空洞的右边缘的第一个非空洞点的横坐标,或者图像的右边界（空洞点）+
        % 1，或者没有变化（非空洞点），总之，
        [num, u] = hole_detection(tx_m(v, :), rx_width, u); % 输入1行
        
        if num > 2 % 包含3个以上空洞点的即认为是大空洞
            % 膨胀较大空洞
            [tx_m(v,:), u] = dilate_big_holes(tx_m(v, :), rx_th_big_hole, rx_th_sharp, rx_n_dilation, num, u, rx_width, 0);
        end
        u = u + 1;
    end
    v = v + 1;
end

end

