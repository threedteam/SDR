function [tx_ides, tx_m] = sdr_copy_single_frame(rx_ides, rx_ides_other, rx_m, rx_m_other, th_fg, height, width)
% SDR_COPY_SINGLE_FRAME  Find and copy the SDRs from rx_ides_other to current destination image to fill the holes
% tx_ides: SDR-filled destination image, uint8
% tx_m: non-hole matrix after SDR copy, double
% rx_ides: current destination image, uint8
% rx_ides_other: other destination image contains SDRs for rx_ides
% rx_m: non-hole matrix associated with rx_ides
% rx_m_other: non-hole matrix associated with rx_ides_other
% th_fg: threshold for foreground identification
% height: height of image
% width: width of image

% 代码风格：相同类型的函数参数一般应放在一起，
tx_ides = rx_ides;
tx_m = rx_m;

for i = 1 : height
    %     for j = 1 : width
    j=2;
    while(j<=width)
        if (rx_m(i, j) == -1&&rx_m(i, j-1)~=-1)
            n=0;
            while(j+n<=width&&rx_m(i, j+n) == -1)
                %             while(j+n<width && rx_m(i, j+n) == -1)
                n=n+1;
            end
            if (j+n<=width)
                if (rx_m(i, j-1) <= th_fg ||rx_m(i, j+n)<= th_fg)
                    for a = 0 : n-1
                        if (rx_m(i, j+a) == -1  &&  rx_m_other(i, j+a) > -1 && rx_m_other(i, j+a) <= th_fg) % 待填充的目标图像为空洞，被搜索那一帧不是空洞，并且为背景，则填充
                            tx_ides (i, j+a, :) = rx_ides_other(i, j+a, :);
                            tx_m(i, j+a) = rx_m_other(i, j+a);
                        end
                    end
                    j = j+n;
                else
                    if(n>25)
                        for a = 0 : n-1
                            if (rx_m(i, j+a) == -1  &&  rx_m_other(i, j+a) > -1 && rx_m_other(i, j+a) <= th_fg) % 待填充的目标图像为空洞，被搜索那一帧不是空洞，并且为背景，则填充
                                tx_ides (i, j+a, :) = rx_ides_other(i, j+a, :);
                                tx_m(i, j+a) = rx_m_other(i, j+a);
                            end
                        end 
                        j = j+n;
                    
                else
                    j = j+n;
                    end
                end
            else
                j= j + 1;
            end
        else
            if (rx_m(i, j) == -1  &&  rx_m_other(i, j) > -1 && rx_m_other(i, j) <= th_fg) % 待填充的目标图像为空洞，被搜索那一帧不是空洞，并且为背景，则填充
                tx_ides (i, j, :) = rx_ides_other(i, j, :);
                tx_m(i, j) = rx_m_other(i, j);
            end
            
            j=j+1;
        end
    end
    i
end
end


