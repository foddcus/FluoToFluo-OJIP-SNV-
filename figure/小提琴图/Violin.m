
clear all

load("参数.mat");
[Size_Sample,Size_Prara]=size(Data_PEA);
k=6;


ydata1 = Data_FP(:,k);
ydata2 = Data_PEA(:,k);
CoffV=corr(ydata1,ydata2);
% 计算偏度
ske1 =skewness(ydata1);
ske2 =skewness(ydata2);
% 计算峰度
kur1 = kurtosis(ydata1);
kur2 = kurtosis(ydata2);
%[f,xf] = kde(ydata1,Bandwidth=0.6);

xgroupdata1 = categorical(repelem(cellstr(Data_Title{k}),Size_Sample, 1));
xgroupdata2 = categorical(repelem(cellstr(Data_Title{k}),Size_Sample,1));

set(legend,'AutoUpdate','off');%禁用自动更新标签
violinplot(xgroupdata1,ydata1,Orientation="vertical",DensityDirection="positive",DensityWidth=0.75)
hold on
violinplot(xgroupdata2,ydata2,Orientation="vertical",DensityDirection="negative",DensityWidth=0.75)

%%
%画正半轴线段
groupData=ydata1;
% 计算统计量
pv=0.25;                           %线段中心取值
dv=0.25;                           % 线段长度
meanVal = mean(groupData);         % 均值
medianVal = median(groupData);     % 中位数
q25 = quantile(groupData, 0.25);   % 第1四分位数
q75 = quantile(groupData, 0.75);   % 第3四分位数

% 在小提琴图上添加均值线
line([1+pv-dv, 1+pv+dv], [meanVal, meanVal], 'Color', [0,0.13,0.78], 'LineWidth', 1.75, 'LineStyle', '-');
% 添加中位数线
line([1+pv-dv, 1+pv+dv], [medianVal, medianVal], 'Color',[0.18,0.51,0.00], 'LineWidth', 1.25,'LineStyle','-.');

% 添加四分位数线（第1四分位数和第3四分位数）
line([1+pv-dv, 1+pv+dv], [q25, q25], 'Color', [0.85,0.33,0.10], 'LineWidth', 1.25, 'LineStyle', '-.');
line([1+pv-dv, 1+pv+dv], [q75, q75], 'Color', [0.85,0.33,0.10], 'LineWidth', 1.25, 'LineStyle', '-.');
%%
%画负半轴线段
groupData=ydata2;
% 计算统计量
meanVal = mean(groupData);         % 均值
medianVal = median(groupData);     % 中位数
q25 = quantile(groupData, 0.25);   % 第1四分位数
q75 = quantile(groupData, 0.75);   % 第3四分位数

% 在小提琴图上添加均值线
line([1-pv-dv, 1-pv+dv], [meanVal, meanVal], 'Color', [0,0.13,0.78], 'LineWidth', 1.75, 'LineStyle', '-');
% 添加中位数线
line([1-pv-dv, 1-pv+dv], [medianVal, medianVal],'Color',[0.18,0.51,0.00], 'LineWidth',  1.25,'LineStyle','-.');

% 添加四分位数线（第1四分位数和第3四分位数）
line([1-pv-dv, 1-pv+dv], [q25, q25], 'Color', [0.85,0.33,0.10], 'LineWidth', 1.25, 'LineStyle', '-.');
line([1-pv-dv, 1-pv+dv], [q75, q75], 'Color', [0.85,0.33,0.10], 'LineWidth', 1.25, 'LineStyle', '-.');


%legend("FluorPen","Pocket PEA")


% 图题
%Arbitrary Units
ylabel("Value (a.u.)")
xlabel("Parameter")
disp(num2str(CoffV))

% 设置坐标轴的字体
ax = gca;
ax.FontSize = 20;
ax.FontName = 'Times New Roman';


% 设置 x 轴标签的字体
ax.XLabel.FontSize = 20;
ax.XLabel.FontName = 'Times New Roman';


% 设置 y 轴标签的字体
ax.YLabel.FontSize = 20;
ax.YLabel.FontName = 'Times New Roman';


% 设置纵坐标范围
%ylim([0.1 0.5]);


% 设置分辨率
set(gcf, 'Position', [100, 100, 400, 600])
