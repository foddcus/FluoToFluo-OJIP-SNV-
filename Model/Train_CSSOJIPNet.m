% %生成二维光谱数据的训练集和预测集
clear all

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
Data_Orin=Data_FP110_Orin_Para;
Data_SNV=normalize(Data_FP110_Orin_Para,1,'zscore');%对列归一化
Data_OJIPSNV=Data_FP_OJIPSNV;

PreditedValue=CateGo;
numChannels=1;
idx = [3 64 115 182];
figure
tiledlayout(2,2);

for i = 1:4
    nexttile
    plot(Data_SNV(idx(i),:))
    xlabel("Time Step")
    title(string(PreditedValue(idx(i))))
end

%数据预处理
TData1=arrayDatastore(Data_SNV(idxTrain,:)',"IterationDimension",2);
TLabel=arrayDatastore(PreditedValue(idxTrain));


VData1=arrayDatastore(Data_SNV(idxValidation,:)',"IterationDimension",2);
VLabel=arrayDatastore(PreditedValue(idxValidation));

TeData1=arrayDatastore(Data_SNV(idxTest,:)',"IterationDimension",2);
TeLabel=arrayDatastore(PreditedValue(idxTest));



%数据预处理
%LSTM数据，对数据库进行预处理，转化为Cell储存的形式,cell代表样本，在cell中，行代表时间步，列代表通道
TData2u=Data_OJIPSNV(idxTrain,:);
VData2u=Data_OJIPSNV(idxValidation,:);
TeData2u=Data_OJIPSNV(idxTest,:);

for i=1:size(idxTrain,1)
    TData2(i,:)=TData2u(i,:);
end

for i=size(idxValidation,1)
    VData2(i,:)=VData2u(i,:);
end

for i=1:size(idxTest,1)
    TeData2(i,:)=TeData2u(i,:);
end

%计算参数Parmameter
%数据预处理
PEA=false;
for i=1:size(idxTrain,1)
    if PEA
        TData3(i,:)=Calculate_PEA_Para(Data_Orin(idxTrain(i),:));
    else
        TData3(i,:)=Calculate_PSII_Para(Data_Orin(idxTrain(i),:));
    end
end

for i=1:size(idxValidation,1)
    if PEA
        VData3(i,:)=Calculate_PEA_Para(Data_Orin(idxValidation(i),:));
    else
        VData3(i,:)=Calculate_PSII_Para(Data_Orin(idxValidation(i),:));
    end
end

for i=1:size(idxTest,1)
    if PEA
        TeData3(i,:)=Calculate_PEA_Para(Data_Orin(idxTest(i),:));
    else
        TeData3(i,:)=Calculate_PSII_Para(Data_Orin(idxTest(i),:));
    end
end
TData=combine(TData1,arrayDatastore(TData2',"IterationDimension",2),arrayDatastore(normalize(TData3,1,'zscore')','IterationDimension',2),TLabel);
VData=combine(VData1,arrayDatastore(VData2',"IterationDimension",2),arrayDatastore(normalize(VData3,1,'zscore')',"IterationDimension",2),VLabel);
TeData=combine(TeData1,arrayDatastore(TeData2',"IterationDimension",2),arrayDatastore(normalize(TeData3,1,'zscore')',"IterationDimension",2),TeLabel);

read(TData);


options = trainingOptions("adam", ...
    MiniBatchSize=128,...
    MaxEpochs=100, ...
    InitialLearnRate=0.001,...
    GradientThreshold=1, ...
    Shuffle='every-epoch', ...%可以乱序，反正长度都一样
    Plots="training-progress", ...
    Metrics=["accuracy","recall","auc"], ...
    Verbose=false,...
    ValidationData= VData,...
    ValidationFrequency=100, ...
    LearnRateSchedule='piecewise',...%分段学习
    LearnRateDropFactor=0.25,...%学习率下降因子
    LearnRateDropPeriod=20,...%下降周期间隔
    OutputNetwork="best-validation");

%[47,86],[72,207]
layerN=creat_CSS_OJIP_net([457 1 nan],[18 nan],1,[72 207],457);

[Net, traininfo] = trainnet(TData,layerN,'crossentropy',options);


Yp = minibatchpredict(Net,TeData);
classNames = categories(CateGo);
pLabel = scores2label(Yp,classNames);
figure
TeLabel=CateGo(idxTest);
confusionchart(TeLabel,pLabel);
% 计算混淆矩阵
C = confusionmat(TeLabel, pLabel);
metrics = calculateClassificationMetrics(TeLabel, pLabel);
