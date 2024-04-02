
for idx = 2:2
        
        FileName = strcat('D:\cao\spatial_time\目标图\color\Is_Ballet_des', int2str(idx), '.bmp');
        Id = imread(FileName); % 读取待修补目标图
        FileName = strcat('D:\cao\spatial_time\目标图\depth\Is_Ballet_depth', int2str(idx), '.bmp');
        dD = imread(FileName); %读取待修补目标图对应的深度图
        FileName = load(strcat('D:\cao\spatial_time\目标图\M\Is_Ballet_', int2str(idx), 'M'));
        M= logical( FileName);%读取待修补目标图对应的空洞标记表
    
        for i=1:1   %从待修补目标图的前一帧依次向前搜索，直到第一帧结束
            if ((idx-1)>=0)
            FileName = strcat('D:\cao\spatial_time\目标图\color\Is_Ballet_des', int2str(i), '.bmp');
            Id_other = imread(FileName);
            FileName = strcat('D:\cao\spatial_time\目标图\depth\Is_Ballet_depth', int2str(i), '.bmp');
            dD_other = imread(FileName);
            FileName = load(strcat('D:\cao\spatial_time\目标图\M\Is_Ballet_', int2str(i), 'M'));
            M_other= logical( FileName);        
            [Id1,dD1,M1]=SDR(Id, Id_other, dD, dD_other,M,M_other,110); % 搜索暴露区域并填补空洞
            Id=Id1;
            dD=dD1;
            M=M1;
            end
        end
FileName = strcat('D:\cao\spatial_time\目标图\color\Is_Ballet_SDR_des', int2str(idx), '.bmp');
        imwrite(uint8(Id), FileName);
end