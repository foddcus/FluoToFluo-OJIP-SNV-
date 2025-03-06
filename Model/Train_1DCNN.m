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
Data=normalize(Data_FP110_Orin_Para,1,'zscore');%对列归一化
%Data=normalize(Data_FP110_Orin_Para,'range',[-1,1]);%对列归一化
%Data=Data_FP_OJIPSNE;
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
TData(:,1,:)=Data(idxTrain,:)';
TLabel=PreditedValue(idxTrain);


VData(:,1,:)=Data(idxValidation,:)';
VLabel=PreditedValue(idxValidation);

TeData(:,1,:)=Data(idxTest,:)';
TeLabel=PreditedValue(idxTest);


%Ytrain=inputData(:,end);
figure
histogram(TLabel)
axis tight
ylabel('Counts')
xlabel('catergories')


options = trainingOptions("adam", ...
    MiniBatchSize=128,...
    MaxEpochs=100, ...
    InitialLearnRate=0.001,...
    GradientThreshold=1, ...
    Shuffle='every-epoch', ...%可以乱序，反正长度都一样
    Plots="training-progress", ...
    Metrics=["accuracy","recall","auc"], ...
    Verbose=false,...
    ValidationData= {VData,VLabel},...
    ValidationFrequency=100, ...
    LearnRateSchedule='piecewise',...%分段学习
    LearnRateDropFactor=0.25,...%学习率下降因子
    LearnRateDropPeriod=20,...%下降周期间隔
    OutputNetwork="best-validation");
    
%
layerN=creatCNN1D_Fluorensece([458,1,nan]);
%深度增加时，适当减少核数
%两层神经元可以加快训练速度
[Net, traininfo] = trainnet(TData,TLabel,layerN,'crossentropy',options);
Yp = minibatchpredict(Net,TeData);
classNames = categories(TeLabel);
pLabel = scores2label(Yp,classNames);
figure
confusionchart(TeLabel,pLabel);
% 计算混淆矩阵  
C = confusionmat(TeLabel, pLabel);  
metrics = calculateClassificationMetrics(TeLabel, pLabel);


% %验证集表现
% mbq = minibatchqueue(Validation_Datastore, ...
%     MiniBatchSize=64, ...
%     PartialMiniBatch="return", ...
%     MiniBatchFcn=@ChangeFormer, ...%预处理方法，与采集的数据类型对应
%     MiniBatchFormat="CBT");
% pPredicted=[];
% while hasdata(mbq)
% X = next(mbq);
% thisP=extractdata(predict(net,X));
% pPredicted = [pPredicted(:);thisP(:)]
% end
% metrics_v = analysisRegression_Detail(VLabel, pPredicted);
