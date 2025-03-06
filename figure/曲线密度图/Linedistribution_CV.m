clear all
load('C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Orin_data_UnAve.mat')
FP110=true;
%%
if FP110
    %预处理,仅针对FP110：
    Time_title=Data_FP110_Orin_Time;

    % 需要插值的新时间点 Xq
    Aim_Time_title=Data_PEA_Orin_Time(2:end);

    for i=1:length(CV_result_FP(:,1))
        Y = CV_result_FP(i,:);
        % 使用分段线性插值方法
        Data_Aim(i,:) = interp1(Time_title, Y, Aim_Time_title, 'pchip');
    end
    % 'linear'：线性插值，计算速度快，适用于一般平滑数据。
    % 'spline'：三次样条插值，结果更平滑，但计算相对复杂。
    % 'nearest'：最近邻插值，取最近的已知数据点的值。
    % 'pchip'：分段三次Hermite插值，保持单调性和形状特征。
else
    Aim_Time_title=Data_PEA_Orin_Time;
    Data_Aim=CV_result_PEA;

end
%%
%Y的取值范围
Yp=0.1:0.1:10;

for i=1:length(Aim_Time_title)
    data=Data_Aim(:,i);
    [z(:,i), y(:,i)] = ksdensity(data); % 估计参数的概率密度函数
    %x(:,i)=ones(100,1)*Data_FP100_Orin_Para(i);
    %x(:,i)=ones(100,1)*i;

    Zp(:,i) = interp1(y(:,i), z(:,i), Yp, 'cubic');
    Zp(isnan(Zp(:,i))) = 0;
    Zp(:,i)=Zp(:,i)/max(Zp(:,i))-min(Zp(:,i));
end


%%

% 热力图
[Xq, Yq] = meshgrid(1:1:length(Aim_Time_title), Yp);
Zq = griddata(Xq(:), Yq(:), Zp(:), Xq, Yq, 'natural');

%KD=min(Zq(:)):0.000001:max(Zq(:));
figure;
contourf(Xq, Yq, Zp,1000,'LineStyle','none');
%colormap("sky");
colorbar; % 添加颜色条

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


% 设置分辨率
set(gcf, 'Position', [100, 100, 800, 400])
%积分测试
%integral = trapz(y(:,3), z(:,3));


MeanCV_PEA=mean(CV_result_PEA,'all');
MeanCV_FP=mean(CV_result_FP,'all');
%显著性检验
[h, p, ci, stats] =ttest2(CV_result_PEA(:), CV_result_FP(:));

%F0，2ms，30ms，Fm对应（1,48,85,85-119max)
MeanCV_OK_FP=mean(CV_result_FP(:,1:30),'all');
MeanCV_KJ_FP=mean(CV_result_FP(:,31:47),'all');
MeanCV_JI_FP=mean(CV_result_FP(:,48:84),'all');
MeanCV_IP_FP=mean(CV_result_FP(:,85:end),'all');

MeanCV_OK_PEA=mean(CV_result_PEA(:,1:30),'all');
MeanCV_KJ_PEA=mean(CV_result_PEA(:,31:47),'all');
MeanCV_JI_PEA=mean(CV_result_PEA(:,48:84),'all');
MeanCV_IP_PEA=mean(CV_result_PEA(:,85:end),'all');

Ratio_OK=MeanCV_OK_FP/MeanCV_OK_PEA;
Ratio_KJ=MeanCV_KJ_FP/MeanCV_KJ_PEA;
Ratio_JI=MeanCV_JI_FP/MeanCV_JI_PEA;
Ratio_IP=MeanCV_IP_FP/MeanCV_IP_PEA;
Ratio_ALL=MeanCV_FP/MeanCV_PEA;

%%分析一下 归一化荧光值的变异系数对于行分别为Fv/Fm	Fv/Fo	Vj	Vi
load("Ratiodata.mat")
Data_Aim= FvmFP_UnAve;
Data_Aim2= FvmPEA_UnAve;
RepeatNum=3;
SampleNum=length(Data_Aim(:,1))/RepeatNum;

for i=1:SampleNum
    CV_Fvm_FP(i,:)=100.*std(Data_Aim((i-1)*RepeatNum+1:i*RepeatNum,:))./mean(Data_Aim((i-1)*RepeatNum+1:i*RepeatNum,:));
    CV_Fvm_PEA(i,:)=100.*std(Data_Aim2((i-1)*RepeatNum+1:i*RepeatNum,:))./mean(Data_Aim2((i-1)*RepeatNum+1:i*RepeatNum,:));

end


MeanCV_FvmRatio_FP=mean(CV_Fvm_FP,1);
MeanCV_FvmRatio_PEA=mean(CV_Fvm_PEA,1);