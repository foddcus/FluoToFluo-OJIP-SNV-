clear all
load("C:\data\BaiduSyncdisk\文件与申请工作\论文\2025 棉花荧光迁移学习\matlab script\+data_GreenHouse_TwoEqui\Orin_data_GreenHouse.mat");
Time_title=Data_PEA_Orin_Time;
Yp=100:25:50000;

for i=1:length(Time_title)%length(Time_title)   
data=Data_PEA_Orin_Para(:,i);
[z(:,i), y(:,i)] = ksdensity(data); % 估计参数的概率密度函数
%x(:,i)=ones(100,1)*Data_FP100_Orin_Para(i);
x(:,i)=ones(100,1)*i;

Zp(:,i) = interp1(y(:,i), z(:,i), Yp, 'cubic');
Zp(isnan(Zp(:,i))) = 0;
Zp(:,i)=Zp(:,i)/max(Zp(:,i))-min(Zp(:,i));
end


%%

% 热力图
[Xq, Yq] = meshgrid(1:1:length(Time_title), Yp);%length(Time_title)
Zq = griddata(Xq(:), Yq(:), Zp(:), Xq, Yq, 'natural');

%KD=min(Zq(:)):0.000001:max(Zq(:));
figure;
contourf(Xq, Yq, Zp,1000,'LineStyle','none');
%colormap("sky");olorbar; % 添加颜色条

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


