classdef DTSLayer < nnet.layer.Layer...
     & nnet.layer.Formattable
    % 自定义网络层：将输入数据拆分并转置格式
    % 输入格式：TCB (117x128xB)
    % 输出格式：SCB (128x117xB)

    properties
        % 定义层的属性
    end

    methods
        function layer = DTSLayer(name)
            % 构造函数：初始化层并指定名字
            % 输入参数：
            % - name: 层的名称

            layer.Name = name;
            layer.Description = '针对LSTM的通道转空间数据的自定义层';
            layer.NumInputs = 1;  % 定义输入接口数量
            layer.NumOutputs = 1; % 定义输出接口数量
        end

        function [out] = predict(layer,input)

            % 转置为 CBT 格式，显式指定维度
            %out1 = permute(split1, [2, 3, 1]); % [C, B, T]，此处 [1, B, 47]
            out = dlarray(input,"SBC");

        end
    end
end