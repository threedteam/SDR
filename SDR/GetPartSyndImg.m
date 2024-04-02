function Is = GetPartSyndImg(im, M);
%  GETPARTSYNDIMG  Return the part-synthesized image
%  im: ͼ������
%  M: the homography
%  Is: ���ֺϳɵ�ͼ�񣨲ü���
%  polyPts: im��Is�е�ͶӰ�Ķ���
%  Vertexes: im���ĸ�������Is�е�ͶӰ
% 
%  Ran Liu: liuran781101@tom.com
%  College of Computer Science, Chongqing University
%  Panovasic Technology Co.,Ltd

%%  Ԥ����ͼ��im���õ�Rect����im��Is�е�ͶӰ��MBR
polyPts = Preprocess(im, M);

%%  ����ͼ��
Is = ProduceImg(im, M, polyPts);  % �Ӻ������ܲ����������ı���
 
%%
function [polyPts] = Preprocess(im, M)
%  PREPROCESS  Return the projections of the  im in Is 
%  ����im��Is�е�ͶӰ
[Hight Width Clr] = size(im);    %  ��im��ά�Ĵ�С
Vertexes = [0  0         Width - 1  Width - 1
            0  Hight - 1 Hight - 1  0
            1  1         1          1];  %  im���ĸ�����Ķ�ά�����������ʱ��˳�򹹳�һ����������û����ͼ��������ƶ�һ������
polyPts = M * Vertexes;                  %  ͶӰ
polyPts = round(hnormalise(polyPts));    %  ������ط���Ӧ�ö����������й�һ��(��h����1)������ͻ����û��һ��
                                         %  ͳһ������ͼ������ϵ��״��
% %  ���im��Is��ͶӰ�ı߽磬��Ҫ�ü��������Ժ��
% % ���polyPts�еĵ㲻��Vertexes�ڣ���������Vertexes�еĵ����polyPts�еĵ�
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
% �Դ����ҡ����ϵ��µ�˳�򣬼���polyPts��MBR�е�ÿһ������ԭʼͼ��ƽ���еĶ�Ӧ�㣬����Ϊ0
TopLeftX = min(polyPts(1, :));   
TopLeftY = min(polyPts(2, :));
BottomRightX = max(polyPts(1, :));
BottomRightY = max(polyPts(2, :));

[Hight Width Clr] = size(im); 
%  ����ռ䣬Is�Ĵ�С��im��ͬ
% Is = zeros(BottomRightY+23, BottomRightX-133, Clr);
Is = zeros(Hight, Width+100, Clr);
%  ����ӳ������У�����ͼ��Ĺ���Ϊ M * Ii-->�������Ĺ淶��(ʹ��Ϊ'�淶���������')
%  ����ӳ���򵹹�������M-->�������Ĺ淶��(ʹ��Ϊ'�淶���������')
% for i = 1 : 768  %  ����ɨ��
%     for j = 1 :1024
%         ui = M * [j; i; 1];     %  ui����ԭʼͼ��ƽ���еĵ�
%         ui = round(hnormalise(ui));  %  ȡ���������ȶ�ui�淶�������õ�Ӧ�����������������һ���������ӣ�������
%                                      %  ��������ص��������ǹ淶��������ꡣ���Ӧ�ö��������淶��
%         if (ui(2) >= TopLeftY) && (ui(2) <= BottomRightY - 1) && (ui(1) >= TopLeftX) && (ui(1) <= BottomRightX-1)  % ui��ԭʼͼ��ƽ�淶Χ��
%             try
%                 Is(ui(2) + 1, ui(1)+ 1, :) = im(i+ 1, j + 1, :);   %  �� ui��Ӧ�����ؿ�������(j + 1, i + 1)��λ�ã�����Ϊ0
%             catch
%                 error('There are error(s), please check!');
%             end;                                 
%         end;
%     end;
% end;
for i = TopLeftY : BottomRightY  %  ����ɨ��
    for j = TopLeftX : BottomRightX
        ui = inv(M) * [j; i; 1];     %  ui����ԭʼͼ��ƽ���еĵ�
        ui = round(hnormalise(ui));  %  ȡ���������ȶ�ui�淶�������õ�Ӧ�����������������һ���������ӣ�������
                                     %  ��������ص��������ǹ淶��������ꡣ���Ӧ�ö��������淶��
        if (ui(2) >= 0) && (ui(2) <= Hight - 1) && (ui(1) >= 0) && (ui(1) <= Width - 1)  % ui��ԭʼͼ��ƽ�淶Χ��
          if (i>0)
                Is(i + 1, j + 1, :) = im(ui(2) + 1, ui(1) + 1, :);   %  �� ui��Ӧ�����ؿ�������(j + 1, i + 1)��λ�ã�����Ϊ0
          end
           
%             catch
%                 error('There are error(s), please check!');
%             end;                                 
        end;
    end;
end;
Is = uint8(Is);  %  ��ͼ���Ϊ24λλͼ