function holesnum =  holes_num2(M)
%UNTITLED2 Summary of this function goes here
% ����ն��ĸ���
% M ��ʾ������Ӳ�ͼ��� ֵΪ0ʱ��ʾ�ն�
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