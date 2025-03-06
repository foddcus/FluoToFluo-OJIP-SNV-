%读取数据：
clear all
load("C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Nor_Data_GreenHouse_Cate_ReOederTime_OJIPZscore.mat")

%%
% 注意PCA降维前需要归一化（这里默认是已经将样本归一化至-1~1的范围中，但对于通道，我们可能需要进行二次归一化）；

%2次归一化，先前后参数做差，再进行Z-score归一化。

%对于PEA-OJIP：F0，2ms，30ms，Fm对应（1,48,85,85-119max) ,使用reoder的数据，有时间等于0的点（F0）

%F0原点不变，后面做差
for i=1:length(Data_PEA_Orin_Para(1,:))
    if i==1
    Data_PEA(:,i)=Data_PEA_Orin_Para(:,1);
    else
    Data_PEA(:,i)=Data_PEA_Orin_Para(:,i)-Data_PEA_Orin_Para(:,i-1);
    end
end

Data_PEA_F0_AVE=mean(Data_PEA(:,1));
Data_PEA_F0_STD=std(Data_PEA(:,1));

Data_PEA_OJ=Data_PEA(:,2:47);
Data_PEA_OJ_AVE=mean(Data_PEA_OJ(:));
Data_PEA_OJ_STD=std(Data_PEA_OJ(:));

Data_PEA_JI=Data_PEA(:,48:86);
Data_PEA_JI_AVE=mean(Data_PEA_JI(:));
Data_PEA_JI_STD=std(Data_PEA_JI(:));

Data_PEA_IP=Data_PEA(:,87:end);
Data_PEA_IP_AVE=mean(Data_PEA_IP(:));
Data_PEA_IP_STD=std(Data_PEA_IP(:));

%归一化
Data_PEA(:,1)=(Data_PEA(:,1)-Data_PEA_F0_AVE)./Data_PEA_F0_STD;
Data_PEA(:,2:47)=(Data_PEA(:,2:47)-Data_PEA_OJ_AVE)./Data_PEA_OJ_STD;
Data_PEA(:,48:86)=(Data_PEA(:,48:86)-Data_PEA_JI_AVE)./Data_PEA_JI_STD;
Data_PEA(:,87:end)=(Data_PEA(:,87:end)-Data_PEA_IP_AVE)./Data_PEA_IP_STD;
Data_PEA_STD=std(Data_PEA);
Data_PEA_AVE=mean(Data_PEA);
Data_PEA=normalize(Data_PEA,1,'zscore');%对列归一化

%FP-OJIP(4，72，207，207~458max），FP默认先减去背景噪声，由40us至2s，40us为F0. 不格外接F0

for i=1:length(Data_FP110_Orin_Para(:,1))
Data_FP110_Orin_Para(i,:)=[Data_FP110_Orin_Para(i,1),Data_FP110_Orin_Para(i,2:end)-Data_FP110_Orin_Para(i,1)];
end

for i=1:length(Data_FP110_Orin_Para(1,:))
    if i==1
    Data_FP(:,i)=Data_FP110_Orin_Para(:,1);
    else
    Data_FP(:,i)=Data_FP110_Orin_Para(:,i)-Data_FP110_Orin_Para(:,i-1);
    end
end

Data_FP_F0_AVE=mean(Data_FP(:,1));
Data_FP_F0_STD=std(Data_FP(:,1));

Data_FP_OJ=Data_FP(:,2:71);
Data_FP_OJ_AVE=mean(Data_FP_OJ(:));
Data_FP_OJ_STD=std(Data_FP_OJ(:));

Data_FP_JI=Data_FP(:,72:206);
Data_FP_JI_AVE=mean(Data_FP_JI(:));
Data_FP_JI_STD=std(Data_FP_JI(:));

Data_FP_IP=Data_FP(:,207:end);
Data_FP_IP_AVE=mean(Data_FP_IP(:));
Data_FP_IP_STD=std(Data_FP_IP(:));

%归一化
Data_FP(:,1)=(Data_FP(:,1)-Data_FP_F0_AVE)./Data_FP_F0_STD;
Data_FP(:,2:72)=(Data_FP(:,2:72)-Data_FP_OJ_AVE)./Data_FP_OJ_STD;
Data_FP(:,73:206)=(Data_FP(:,73:206)-Data_FP_JI_AVE)./Data_FP_JI_STD;
Data_FP(:,207:end)=(Data_FP(:,207:end)-Data_FP_IP_AVE)./Data_FP_IP_STD;
Data_FP_STD=std(Data_FP);
Data_FP_AVE=mean(Data_FP);
Data_FP=normalize(Data_FP,1,'zscore');%对列归一化




