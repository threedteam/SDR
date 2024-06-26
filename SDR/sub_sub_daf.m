function [ sDMap4 ] = sub_sub_daf( DMap4,wh,wv,b,c,a)
%UNTITLED3 Summary of this function goes here
%  方向高斯滤波
%DMap4  输入的深度图
%wh,wv  窗的水平长度和垂直高度
%b,c    水平和垂直方向的平滑强度
%a      梯度方向角

z = zeros(1 ,wh);
zi = zeros(wv,1);
p = zi;
pj = z;


for  j = -(wh - 1)/2: 1 : (wh - 1)/2   % 水平高斯滤波
    for  i = -(wv - 1)/2 : 1 : (wv - 1)/2 % 垂直高斯滤波
        y = j*sin(a(i +(wv + 1)/2, j + (wh + 1)/2)) + i*cos(a(i +(wv + 1)/2, j + (wh + 1)/2));
%         y = j*sin(a) + i*cos(a);
        p(i + (wv - 1)/2 + 1) = DMap4((wv + 1)/2 - i, (wh + 1)/2 - j) *gaosi(y,c);
        zi(i + (wv - 1)/2 + 1) = gaosi(y,c);
    end
    x = j*cos(a(i +(wv + 1)/2, j + (wh + 1)/2)) - i*sin(a(i +(wv + 1)/2, j + (wh + 1)/2));
%       x = j*cos(a) -i*sin(a);
    pj(j + (wh - 1)/2 + 1) = sum(p)*gaosi(x,b);
    z(j + (wh-1)/2 + 1) = sum(zi)*gaosi(x, b);
end
hsunm = sum(pj);
sumz = sum(z);
sDMap4 =  hsunm/sumz; %归一化得到滤波后的值
end


