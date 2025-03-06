%
% % 训练线性回归模型
mdl = fitlm(input, F0);
disp(mdl);
%
% data=[];

%data = [];
[sample,paralong]=size(data);
for j=1:1

    fluorescence_data = data(j,:);


    % 初始化变量来存储最高平均荧光值和对应的索引
    max_avg_fluorescence = -inf;
    max_avg_index = 1;

    % 遍历数据，计算每4个连续点的平均值，并找到最大平均值的索引
    for i = 1:paralong - 3
        % 计算当前4个点的平均值
        current_avg = mean(fluorescence_data(i:i+3));

        % 如果当前平均值大于之前记录的最大平均值，则更新它
        if current_avg > max_avg_fluorescence
            max_avg_fluorescence = current_avg;
            max_avg_index = i;
        end
    end

    % 根据说明，Fm值是产生最高平均荧光值的那一组中的第三个数据点
    Fm(j,1) = fluorescence_data(max_avg_index + 2);

end