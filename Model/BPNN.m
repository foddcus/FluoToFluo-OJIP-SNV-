%训练集：70%，验证集15%，测试集15%


%训练脚本示意：
clear variables
%原始数据
load("C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Nor_Data_GreenHouse_Cate_ReOederTime_OJIPZscore.mat");
%样本分割数据
load('SpiltedNumData.mat');
% %数据集划分

% IDX1=find(CateGo=='S1');
% [idxTrain1,idxValidation1,idxTest1] = trainingPartitions(length(IDX1),[0.7 0.15 0.15]);
% 
% IDX2=find(CateGo=='S2');
% [idxTrain2,idxValidation2,idxTest2] = trainingPartitions(length(IDX2),[0.7 0.15 0.15]);
% 
% IDX3=find(CateGo=='CK');
% [idxTrain3,idxValidation3,idxTest3] = trainingPartitions(length(IDX3),[0.7 0.15 0.15]);
% 
% idxTrain=[IDX1(idxTrain1);IDX2(idxTrain2);IDX3(idxTrain3)];
% idxValidation=[IDX1(idxValidation1);IDX2(idxValidation2);IDX3(idxValidation3)];
% idxTest=[IDX1(idxTest1);IDX2(idxTest2);IDX3(idxTest3)];


%%

Cate=categorical();
Cate(find(CateGo=='S1'),1)='S1';
Cate(find(CateGo=='S2'),1)='S2';
Cate(find(CateGo=='CK'),1)='C';
clear CateGo
CateGo=Cate;
    
%展示数据
Data=Data_FP110_Orin_Para;
PreditedValue=CateGo;
numChannels=1;
idx = [3 64 115 182];
figure
tiledlayout(2,2);

for i = 1:4
    nexttile
    plot(Data(idx(i),:))
    xlabel("Time Step")
    title(string(PreditedValue(idx(i))))
end

%数据预处理

TData=Calculate_PSII_Para([Data(idxTrain,:);Data(idxValidation,:)]);
TLable=PreditedValue([idxTrain;idxValidation]);

TeData=Calculate_PSII_Para(Data(idxTest,:));
TeLable=PreditedValue(idxTest);




