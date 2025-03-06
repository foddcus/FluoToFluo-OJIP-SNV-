classdef SplitLayer < nnet.layer.Layer...
     & nnet.layer.Formattable
    % 自定义网络层：将输入数据拆分并转置格式
    % 输入格式：SCB (117x1xB)
    % 输出格式：CBT (1xBxT)

    properties
        % 定义层的属性
        SplitPoints= [47, 86] % 拆分点
    end

    methods
        function layer = SplitLayer(name,SplitNum)
            % 构造函数：初始化层并指定名字
            % 输入参数：
            % - name: 层的名称

            layer.Name = name;
            layer.Description = '拆分并转置输入数据的自定义层';
            layer.NumInputs = 1;  % 定义输入接口数量
            layer.NumOutputs = 4; % 定义输出接口数量

            % 设置拆分点
            layer.SplitPoints = SplitNum; % 对应 S 的拆分点
        end

        function [out1, out2, out3, out4] = predict(layer, input)

            % 拆分输入数据
            split1 = input( :, :,1:layer.SplitPoints(1));          % S=1~47
            split2 = input(:, :,layer.SplitPoints(1)+1:layer.SplitPoints(2)); % S=48~86
            split3 = input( :, :, layer.SplitPoints(2)+1:end);     % S=87~117

            % 转置为 CBT 格式，显式指定维度
            %out1 = permute(split1, [2, 3, 1]); % [C, B, T]，此处 [1, B, 47]
            out1 = dlarray(split1,"CBT");


           % out2 = permute(split2, [2, 3, 1]); % [C, B, T]，此处 [1, B, 39]
            out2 = dlarray(split2,"CBT");

           % out3 = permute(split3, [2, 3, 1]); % [C, B, T]，此处 [1, B, 31]
            out3 = dlarray(split3,"CBT");

            out4=dlarray(input,'CBT');
        end
    end
end