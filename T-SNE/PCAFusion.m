clear all
%读取数据：
load("C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Nor_data128_GreenHouse_Cate.mat")


%%
% 注意PCA降维前需要归一化（这里默认是已经将样本归一化至-1~1的范围中，但对于通道，我们可能需要进行二次归一化）；

%way1 简单合并数据
%Data_ALL=[Data_PEA_Nor_Para,Data_FP110_Nor_Para];
%
%way2 通道2次归一化，先前后参数做差，再进行归一化。
for i=1:length(Data_PEA_Nor_Para(1,:))-1
    if i==1
    Data_PEA(:,i)=Data_PEA_Nor_Para(:,1);
    else
    Data_PEA(:,i)=Data_PEA_Nor_Para(:,i+1)-Data_PEA_Nor_Para(:,i);
    end
end

for i=1:length(Data_FP110_Nor_Para(1,:))-1
    if i==1
    Data_FP110(:,i)=Data_FP110_Nor_Para(:,1);
    else
    Data_FP110(:,i)=Data_FP110_Nor_Para(:,i+1)-Data_FP110_Nor_Para(:,i);
    end
end
Data_ALL=[Data_PEA,Data_FP110];
Data_ALL=normalize(Data_ALL,1,"zscore");

%way3 OJIP Z-score OJIP对应的点为为PEA（1,47,84,118) FP(


%% PCA

%获取主成分系数
[coeff,score,~,~,explained,~]= pca(Data_ALL);

%分析占 99.999% 解释性的主成分
for i=1:length(Data_ALL(1,:))
    if sum(explained(1:i))>99
        numP=i;
        break
    end
end

Data_PCAFusion=score(:,1:numP);
Data_show=Data_ALL;
%%画图：
[Y, loss] = tsne(Data_show, 'NumDimensions', 2);
% 使用 gscatter 函数绘制散点图
figure; % 创建一个新图形窗口
gscatter(Y(:,1), Y(:,2), CateGo);
 
% 设置轴标签
xlabel('Dim 1');
ylabel('Dim 2');
title(['loss:',num2str(loss)]);
 