function holesnum =  holes_num2(M)
%UNTITLED2 Summary of this function goes here
% 计算空洞的个数
% M 表示输入的视差图标记 值为0时表示空洞
%

holesnum = 0;
[n,m] = size(M);

for i = 1 : n
    for j = 1: m
       if (M(i,j)== 0 )
         holesnum = holesnum + 1 ;
       end
    end
end
end