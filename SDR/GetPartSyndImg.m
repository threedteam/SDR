function Is = GetPartSyndImg(im, M);
%  GETPARTSYNDIMG  Return the part-synthesized image
%  im: 图像数据
%  M: the homography
%  Is: 部分合成的图像（裁减）
%  polyPts: im在Is中的投影的顶点
%  Vertexes: im的四个顶点在Is中的投影
% 
%  Ran Liu: liuran781101@tom.com
%  College of Computer Science, Chongqing University
%  Panovasic Technology Co.,Ltd

%%  预处理图像im，得到Rect，即im在Is中的投影的MBR
polyPts = Preprocess(im, M);

%%  生成图像
Is = ProduceImg(im, M, polyPts);  % 子函数不能操作主函数的变量
 
%%
function [polyPts] = Preprocess(im, M)
%  PREPROCESS  Return the projections of the  im in Is 
%  计算im在Is中的投影
[Hight Width Clr] = size(im);    %  求im各维的大小
Vertexes = [0  0         Width - 1  Width - 1
            0  Hight - 1 Hight - 1  0
            1  1         1          1];  %  im的四个顶点的二维齐次坐标以逆时针顺序构成一个矩阵，这里没有让图像的坐标移动一个像素
polyPts = M * Vertexes;                  %  投影
polyPts = round(hnormalise(polyPts));    %  在这个地方，应该对齐次坐标进行规一化(让h等于1)，否则就会出现没有一个
                                         %  统一的像素图像坐标系的状况
% %  求解im在Is中投影的边界，需要裁减。这里以后改
% % 如果polyPts中的点不在Vertexes内，则依次用Vertexes中的点替代polyPts中的点
% IsRectXV = [Vertexes(1, :), Vertexes(1, 1)];
% IsRectYV = [Vertexes(2, :), Vertexes(2, 1)];
% prjVX = polyPts(1, :);
% prjVY = polyPts(2, :);
% InIs = inpolygon(prjVX, prjVY, IsRectXV, IsRectYV);  % 1 = True
% for i = 1 : 4
%     if InIs(i) == 0
%         polyPts(:, i) = Vertexes(:, i);
%     end
% end;

%%
function Is = ProduceImg(im, M, polyPts)
% 以从左到右、从上到下的顺序，计算polyPts的MBR中的每一个点在原始图像平面中的对应点，基数为0
TopLeftX = min(polyPts(1, :));   
TopLeftY = min(polyPts(2, :));
BottomRightX = max(polyPts(1, :));
BottomRightY = max(polyPts(2, :));

[Hight Width Clr] = size(im); 
%  申请空间，Is的大小与im相同
% Is = zeros(BottomRightY+23, BottomRightX-133, Clr);
Is = zeros(Hight, Width+100, Clr);
%  正向映射生成校正后的图像的过程为 M * Ii-->齐次坐标的规范化(使变为'规范化齐次坐标')
%  逆向映射则倒过来：逆M-->齐次坐标的规范化(使变为'规范化齐次坐标')
% for i = 1 : 768  %  按行扫描
%     for j = 1 :1024
%         ui = M * [j; i; 1];     %  ui代表原始图像平面中的点
%         ui = round(hnormalise(ui));  %  取整。必须先对ui规范化。采用单应矩阵计算出的坐标相差一个比例因子，而用于
%                                      %  计算的像素的坐标总是规范化齐次坐标。因此应该对齐次坐标规范化
%         if (ui(2) >= TopLeftY) && (ui(2) <= BottomRightY - 1) && (ui(1) >= TopLeftX) && (ui(1) <= BottomRightX-1)  % ui在原始图像平面范围内
%             try
%                 Is(ui(2) + 1, ui(1)+ 1, :) = im(i+ 1, j + 1, :);   %  将 ui对应的像素拷贝到点(j + 1, i + 1)的位置，基数为0
%             catch
%                 error('There are error(s), please check!');
%             end;                                 
%         end;
%     end;
% end;
for i = TopLeftY : BottomRightY  %  按行扫描
    for j = TopLeftX : BottomRightX
        ui = inv(M) * [j; i; 1];     %  ui代表原始图像平面中的点
        ui = round(hnormalise(ui));  %  取整。必须先对ui规范化。采用单应矩阵计算出的坐标相差一个比例因子，而用于
                                     %  计算的像素的坐标总是规范化齐次坐标。因此应该对齐次坐标规范化
        if (ui(2) >= 0) && (ui(2) <= Hight - 1) && (ui(1) >= 0) && (ui(1) <= Width - 1)  % ui在原始图像平面范围内
          if (i>0)
                Is(i + 1, j + 1, :) = im(ui(2) + 1, ui(1) + 1, :);   %  将 ui对应的像素拷贝到点(j + 1, i + 1)的位置，基数为0
          end
           
%             catch
%                 error('There are error(s), please check!');
%             end;                                 
        end;
    end;
end;
Is = uint8(Is);  %  将图像变为24位位图