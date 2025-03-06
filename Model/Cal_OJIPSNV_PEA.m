
function OJIPSNV_Data=Cal_OJIPSNV_PEA(inputData)

for i=1:length(inputData(1,:))
    if i==1
        Data_PEA(:,i)=inputData(:,1);
    else
        Data_PEA(:,i)=inputData(:,i)-inputData(:,i-1);
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
OJIPSNV_Data=normalize(Data_PEA,1,'zscore');%对列归一化

end
%FP-OJIP(4，72，207，207~458max），FP默认先减去背景噪声，由40us至2s，40us为F0. 不格外接F0