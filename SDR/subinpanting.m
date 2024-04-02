
%% ��������ͼ���޸���������Ѱ���޸�ָ����ĳ���
%
% /*===========================================================================*\
%  This confidential and proprietary software may be used only by
%  authorized users by a licensing agreement from Panovasic Technology Co., Ltd.
%  In the event of publication, the following notice is applicable:
%   ========================================================================
%
%   PPPPPP    A      NN    N   OOOO  V       V   A      SSSS  IIIII  CCCCC
%   P    PP  A A     N N   N  O    O  V     V   A A    S        I   CC
%   PPPPPP  A   A    N  N  N  O    O   V   V   A   A    SSSS    I   CC
%   P      A A A A   N   N N  O    O    V V   A A A A       S   I   CC
%   P     A       A  N    NN   OOOO      V   A       A  SSSS  IIIII  CCCCC
%
%   ========================================================================
%     Filename         : subinpanting.m
%     Author           : Hui Xie
%     Description      :
%     Revision History :
%   ------------------------------------------------------------------------
%        Revision  |     DATA    |   Author    |          Changes
%   ------------------------------------------------------------------------
%          1.00    |  2012-05-09 |  Hui Xie    |          Original
%   ------------------------------------------------------------------------

%   /*------------------------------------------------------------------------
%
%           Copyright(c) 2011, Panovasic Technology Co., Ltd
%                       All Right Reserved

% \*=======================================================================
function [ Ides,CM,holedges,MP,dD] =subinpanting(h, w,k,i,j,Wi,Hi,CM,dD,Ides,holedges,MP,th,a,c,B)
confidences = zeros(Hi,Wi);
datas = confidences;
stopreturn = holedges;
% g = 0;
p = confidences;
i1 = i;
j1 = j;
while((i< Hi - ((k -1)/2)*h -(h-1)/2) &&(j-((k-1)/2)*w -(w-1)/2>0 )&& (j+((k-1)/2)*w + (w-1)/2 < Wi)&& (i> ((k -1)/2)*h +(h-1)/2))
    %               if  %�ж��Ƿ�Խ��
%     g = g +1;
    %�ر�Ե�������Ŷ�
    if B <0 %����ͼ
        if dD(i,j - 1) ~= 0&& dD(i,j + 1) == 0 %�ն����Ե
            confidences(i,j) =confidence(CM( i - (h-1)/2 :i + (h-1)/2 , j - (w-1)/2: j + (w-1)/2),dD( i - (h-1)/2 :i+ (h-1)/2 , j - (w-1)/2: j + (w-1)/2),th, h, w);%�������Ŷ�
            datas(i,j)=data(Ides(i-1:i+1,j-1:j+1,:),dD(i-1:i+1,j-1:j+1) ,a, c);%����������
        else
            confidences(i,j) = 0;
            datas(i,j) = 0;
        end
    else  %����ͼ
%         if dD(i,j+1) ~= 0&&dD(i,j -1) == 0 %�ն��ұ�Ե
   if dD(i,j) == 0&&dD(i,j +1) ~= 0 %�ն��ұ�Ե
            confidences(i,j) =confidence(CM( i - (h-1)/2 :i + (h-1)/2 , j - (w-1)/2: j + (w-1)/2),dD( i - (h-1)/2 :i+ (h-1)/2 , j - (w-1)/2: j + (w-1)/2),th, h, w);%�������Ŷ�
            datas(i,j)=data(Ides(i-1:i+1,j-1:j+1,:),dD(i-1:i+1,j-1:j+1) ,a, c);%����������
        else
            confidences(i,j) = 0;
            datas(i,j) = 0;
        end
    end
    p(i,j) = confidences(i,j)*datas(i,j);%�������ȼ�
%     priority(g) = p(i,j);
    [ m,n,stopreturn(i,j)] = findholedge(holedges(i -1:i+1,j-1:j+1),stopreturn(i-1:i+1,j-1:j+1),i,j,B);%���Ҹÿն�����һ����Ե��
    i = m;
    j = n;
end
maxp = max( max(p)); %ȷ��������ȼ�
if maxp >0
[prow,pcol] = find( p ==maxp);%�ҵ�������ȼ����ڿ��λ��
else
    prow = i1;
    pcol = j1;
end
%%%%ȷ�����ƥ���
% if prow(1)-((k-1)/2)*h - (h-1)/2 < 1 || prow(1)+((k-1)/2)*h + (h-1)/2 > Hi || pcol(1)-((k-1)/2)*w -(w-1)/2 < 1 || pcol(1)+((k-1)/2)*w + (w-1)/2> Wi
%     display(prow(1));
%     display(pcol(1));
%     display(maxp);
%     display(holedges(prow(1),pcol(1)));
%     display(i1);
%     display(j1);
% 
% end   
[matching(1:h,1:w,:),matchingd(1:h,1:w),l]  = pachmatching(MP(prow(1)-((k-1)/2)*h - (h-1)/2:prow(1)+((k-1)/2)*h + (h-1)/2 ,pcol(1)-((k-1)/2)*w -(w-1)/2:pcol(1)+((k-1)/2)*w + (w-1)/2),Ides(prow(1)-((k-1)/2)*h - (h-1)/2:prow(1)+((k-1)/2)*h + (h-1)/2 ,pcol(1)-((k-1)/2)*w -(w-1)/2:pcol(1)+((k-1)/2)*w + (w-1)/2,:),dD(prow(1)-((k-1)/2)*h - (h-1)/2:prow(1)+((k-1)/2)*h + (h-1)/2 ,pcol(1)-((k-1)/2)*w -(w-1)/2:pcol(1)+((k-1)/2)*w + (w-1)/2),h,w,th,maxp);

% figure;
% imshow(uint8(matching));
%%%%��䲢���¿ն���Ե�Լ����Ŷ����ͼ
if l ==0
[Ides(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2,:),holedges(prow(1)-(h+1)/2:prow(1)+(h+1)/2,pcol(1)-(w+1)/2 :pcol(1)+(w+1)/2 ),CM(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2), MP(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2),dD(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2)] = fillpach( matching,MP(prow(1)-(h+3)/2:prow(1)+(h+3)/2 ,pcol(1)-(w+3)/2:pcol(1)+(w+3)/2),Ides(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2,:),confidences(prow(1),pcol(1)),matchingd,dD(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2),CM(prow(1)- (h-1)/2:prow(1)+ (h-1)/2, pcol(1)- (w-1)/2:pcol(1)+ (w-1)/2));
else
    holedges(prow(1),pcol(1))=2;
end
% figure;
% imshow(uint8(Ides));
% figure;
% imshow(uint8(holedges *255));
% figure;
% imshow(uint8(MP*255));

% figure;
% imshow(uint8(CM*255));


end
        