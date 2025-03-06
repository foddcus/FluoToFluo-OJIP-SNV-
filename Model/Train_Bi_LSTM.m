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
%Data=normalize(Data_FP110_Orin_Para,1,'zscore');%对列归一化
%Data=normalize(Data_FP110_Orin_Para,'range',[-1,1]);%Minmax归一化
Data=Data_FP_OJIPSNE;

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
TData=Data(idxTrain,:);
TLable=PreditedValue(idxTrain);

VData=Data(idxValidation,:);
VLable=PreditedValue(idxValidation);

TeData=Data(idxTest,:);
TeLable=PreditedValue(idxTest);

%对数据库进行预处理，转化为Cell储存的形式,cell代表样本，在cell中，行代表时间步，列代表通道
Sample_Num=size(TLable);
for i=1:Sample_Num
T_Data{i,1}=TData(i,:)';
end

Sample_Num=size(VLable);
for i=1:Sample_Num
V_Data{i,1}=VData(i,:)';
end

Sample_Num=size(TeLable);
for i=1:Sample_Num
Te_Data{i,1}=TeData(i,:)';
end

%%
%模型构建
%numHiddenUnits = 512;

% layers = [
%     sequenceInputLayer(1)
%     bilstmLayer(numHiddenUnits,OutputMode='sequence',BiasInitializer='unit-forget-gate')
%     bilstmLayer(numHiddenUnits/2,OutputMode='sequence',BiasInitializer='unit-forget-gate')
%     bilstmLayer(numHiddenUnits/4,OutputMode='last',BiasInitializer='unit-forget-gate')
%     %dropoutLayer(0.25)
%     fullyConnectedLayer(64)
%     fullyConnectedLayer(3)
%     softmaxLayer()
%     ];

%sp[47, 86] [71,206]
layers=Creat_Bi_LSTM_Net(1,118 ,[47, 86]); 

options = trainingOptions("adam", ...
    MiniBatchSize=128,...
    MaxEpochs=100, ...
    InitialLearnRate=0.001,...
    GradientThreshold=1, ...
    Shuffle='every-epoch', ...%可以乱序，反正长度都一样
    Plots="training-progress", ...
    Metrics=["accuracy","recall","auc"], ...
    Verbose=false,...
    ValidationData= {V_Data,VLable},...
    ValidationFrequency=100, ...
    LearnRateSchedule='piecewise',...%分段学习
    LearnRateDropFactor=0.25,...%学习率下降因子
    LearnRateDropPeriod=20,...%下降周期间隔
    OutputNetwork="best-validation");
     

%Train LSTM Neural Network
net = trainnet(T_Data,TLable,layers,'crossentropy',options);

%Test LSTM Neural Network
%对测试数据进行分类，并计算预测的分类准确率。使用minibatchpredict函数进行预测
score =  minibatchpredict(net,Te_Data);
classNames = categories(TeLable);
pLabel = scores2label(score,classNames);
acc = mean(pLabel == TeLable);
figure
confusionchart(TeLable,pLabel)

