function [ sDMap4 ] = sub_sub_daf( DMap4,wh,wv,b,c,a)
%UNTITLED3 Summary of this function goes here
%  �����˹�˲�
%DMap4  ��������ͼ
%wh,wv  ����ˮƽ���Ⱥʹ�ֱ�߶�
%b,c    ˮƽ�ʹ�ֱ�����ƽ��ǿ��
%a      �ݶȷ����

z = zeros(1 ,wh);
zi = zeros(wv,1);
p = zi;
pj = z;


for  j = -(wh - 1)/2: 1 : (wh - 1)/2   % ˮƽ��˹�˲�
    for  i = -(wv - 1)/2 : 1 : (wv - 1)/2 % ��ֱ��˹�˲�
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
sDMap4 =  hsunm/sumz; %��һ���õ��˲����ֵ
end

