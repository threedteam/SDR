
for idx = 2:2
        
        FileName = strcat('D:\cao\spatial_time\Ŀ��ͼ\color\Is_Ballet_des', int2str(idx), '.bmp');
        Id = imread(FileName); % ��ȡ���޲�Ŀ��ͼ
        FileName = strcat('D:\cao\spatial_time\Ŀ��ͼ\depth\Is_Ballet_depth', int2str(idx), '.bmp');
        dD = imread(FileName); %��ȡ���޲�Ŀ��ͼ��Ӧ�����ͼ
        FileName = load(strcat('D:\cao\spatial_time\Ŀ��ͼ\M\Is_Ballet_', int2str(idx), 'M'));
        M= logical( FileName);%��ȡ���޲�Ŀ��ͼ��Ӧ�Ŀն���Ǳ�
    
        for i=1:1   %�Ӵ��޲�Ŀ��ͼ��ǰһ֡������ǰ������ֱ����һ֡����
            if ((idx-1)>=0)
            FileName = strcat('D:\cao\spatial_time\Ŀ��ͼ\color\Is_Ballet_des', int2str(i), '.bmp');
            Id_other = imread(FileName);
            FileName = strcat('D:\cao\spatial_time\Ŀ��ͼ\depth\Is_Ballet_depth', int2str(i), '.bmp');
            dD_other = imread(FileName);
            FileName = load(strcat('D:\cao\spatial_time\Ŀ��ͼ\M\Is_Ballet_', int2str(i), 'M'));
            M_other= logical( FileName);        
            [Id1,dD1,M1]=SDR(Id, Id_other, dD, dD_other,M,M_other,110); % ������¶������ն�
            Id=Id1;
            dD=dD1;
            M=M1;
            end
        end
FileName = strcat('D:\cao\spatial_time\Ŀ��ͼ\color\Is_Ballet_SDR_des', int2str(idx), '.bmp');
        imwrite(uint8(Id), FileName);
end