clear all
%读取数据：
%-1,1归一化
load("C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Nor_data128_GreenHouse_Cate.mat")
%OJIP-SNV
load('C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Nor_Data_GreenHouse_Cate_ReOederTime_OJIPZscore.mat');
%%

%简单合并数据
%Data_ALL=Data_FP110_Nor_Para;
%Data_ALL=[Data_PEA_Nor_Para,Data_FP110_Nor_Para];
%Data_ALL=normalize(Data_ALL,1,"zscore");

Data_ALL=Data_FP_OJIPSNE;

CateGo(find(CateGo=='S1'))='Salt stress';
CateGo(find(CateGo=='S2'))='Salt stress';
%% PCA

Data_show=Data_ALL;
%%画图：
[Y, loss] = tsne(Data_show, 'NumDimensions', 2);
% 使用 gscatter 函数绘制散点图
figure; % 创建一个新图形窗口


hold on
scatter(Y(find(CateGo=='Salt stress'),1),Y(find(CateGo=='Salt stress'),2),'o','DisplayName','Other',...
    'SizeData',25,'LineWidth',0.8,...
    'MarkerEdgeColor',[0.83,0.37,0.45],...
    'MarkerFaceAlpha',0.6,...
    'MarkerFaceColor',[0.83,0.37,0.45]);
hold on;

scatter(Y(find(CateGo=='CK'),1),Y(find(CateGo=='CK'),2),'o','DisplayName','Other',...
    'SizeData',25,'LineWidth',0.8,...
    'MarkerEdgeColor',[0.20,0.55,0.62],...
    'MarkerFaceAlpha',0.6,...
    'MarkerFaceColor',[0.20,0.55,0.62]);
hold on;

legend('Salt Stress','Checkout ');%你的种类(处理）名称
xlabel('feature 1 ','FontSize',12,'fontname','Times New Roman');
ylabel('feature 2 ','FontSize',12,'fontname','Times New Roman');
set(gca,'FontSize',16,'fontname','Times New Roman');  %设置坐标系
set(gca,'tickdir','out');
% 设置轴标签
xlabel('Dim 1');
ylabel('Dim 2');

%SS
%0.80,0.17,0.28
%CK
%0.20,0.55,0.62

disp(['loss:',num2str(loss)]);

%%SC轮廓系数
SCValue=mean(silhouette(Y,grp2idx(CateGo)));

%%调整兰德系数 Adjusted Rand Score
DB = evalclusters(Y,grp2idx(CateGo), 'DaviesBouldin');
lossDB=DB.CriterionValues;


