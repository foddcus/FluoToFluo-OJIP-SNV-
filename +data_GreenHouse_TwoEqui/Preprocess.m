%用于数据归一化
load("Nor_Data128_GreenHouse_Cate_ReOederTime.mat")


for i=1:length(Data_PEA_Orin_Para(:,1))
Y = Data_FP110_Orin_Para(i,:);
% 使用分段线性插值方法
Data_FP_128(i,:) = interp1(Data_FP110_Orin_Time, Y, Time_128, 'pchip');
end
% 'linear'：线性插值，计算速度快，适用于一般平滑数据。
% 'spline'：三次样条插值，结果更平滑，但计算相对复杂。
% 'nearest'：最近邻插值，取最近的已知数据点的值。
% 'pchip'：分段三次Hermite插值，保持单调性和形状特征。
%前10位不变
Data_FP_128(:,2:11) = Data_FP110_Orin_Para(:,1:10);
Data_FP_128(:,1)=0;
%对比：
% 添加标题和标签（可选）
title('折线图');
xlabel('横坐标');
ylabel('纵坐标');
% 显示网格（可选）
grid on;
semilogx(Time_128(2:end),Data_FP_128(2200,2:end),'-o');
hold on
semilogx(Data_FP110_Orin_Time(1:end),Data_FP110_Orin_Para(2200,1:end),'-o');
legend('Interpolated','Original')
%A=imshow(semilogx(Data_FP100_Orin_Time,Data_FP100_Orin_Para(1,:),'-o'));
Data_PEA_128=[Data_PEA_Orin_Para,zeros(length(Data_PEA_Orin_Para(:,1)),9)];