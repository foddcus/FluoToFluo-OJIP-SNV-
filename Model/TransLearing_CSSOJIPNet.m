% %生成二维光谱数据的训练集和预测集
clear all

%原始数据
load("C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Nor_Data_GreenHouse_Cate_ReOederTime_OJIPZscore.mat");
%样本分割数据
load("C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\22_23_AddData\TransData_22_23.mat")
load('SpiltedNumData.mat');
%%
idxTrain(2089:11162-(2985-2088))=2986:1:11162;
CateGo=[CateGo;Cate_22_23];
Cate=categorical();
Cate(find(CateGo=='S1'),1)='S1';
Cate(find(CateGo=='S2'),1)='S2';
Cate(find(CateGo=='CK'),1)='C';
Cate(find(CateGo=='C'),1)='C';
clear CateGo%消除Salt stress、CK的信息
CateGo=Cate;

Data_Orin=[Data_PEA_Orin_Para;ADD_Data_Orin];
%Data_Orin=[Data_PEA_Orin_Para];
Data_OJIPSNV=Cal_OJIPSNV_PEA(Data_Orin);
for i=1:length(Data_Orin(:,1))
    Data_Parameter(i,:)=Calculate_PEA_Para(Data_Orin(i,:));
end
Data_Parameter=normalize(Data_Parameter,'range',[0,1]);


PreditedValue=CateGo;
catNames = categories(CateGo);


%数据预处理,SNV输入
Data_SNV=normalize(Data_Orin,'zscore');%对列归一化
TData1=arrayDatastore(Data_SNV(idxTrain,:)',"IterationDimension",2);
TLabel=arrayDatastore(PreditedValue(idxTrain));


VData1=arrayDatastore(Data_SNV(idxValidation,:)',"IterationDimension",2);
VLabel=arrayDatastore(PreditedValue(idxValidation));

TeData1=arrayDatastore(Data_SNV(idxTest,:)',"IterationDimension",2);
TeLabel=arrayDatastore(PreditedValue(idxTest));


%数据预处理
%LSTM数据，对数据库进行预处理，转化为Cell储存的形式,cell代表样本，在cell中，行代表时间步，列代表通道
TData2=Data_OJIPSNV(idxTrain,:);
VData2=Data_OJIPSNV(idxValidation,:);
TeData2=Data_OJIPSNV(idxTest,:);

%参数Parmameter
TData3=Data_Parameter(idxTrain,:);
VData3=Data_Parameter(idxValidation,:);
TeData3=Data_Parameter(idxTest,:);

%
%[AA.rows, AA.cols] = find(isnan(Data_Parameter))

TData=combine(TData1,arrayDatastore(TData2',"IterationDimension",2),arrayDatastore(TData3','IterationDimension',2),TLabel);
VData=combine(VData1,arrayDatastore(VData2',"IterationDimension",2),arrayDatastore(VData3',"IterationDimension",2),VLabel);
TeData=combine(TeData1,arrayDatastore(TeData2',"IterationDimension",2),arrayDatastore(TeData3',"IterationDimension",2),TeLabel);

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

%PEA数据[47,86],119
%FP数据 [72,207]，457
layerN=creat_CSS_OJIP_net([119 1 nan],[18 nan],1,[47 86],119);

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






