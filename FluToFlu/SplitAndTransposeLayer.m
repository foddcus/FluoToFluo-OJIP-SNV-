classdef SplitAndTransposeLayer < nnet.layer.Layer...
     & nnet.layer.Formattable
    % 自定义网络层：将输入数据拆分并转置格式
    % 输入格式：SCB (117x1xB)
    % 输出格式：TCB (117x1xB)

    properties
        % 定义层的属性

    end

    methods
        function layer = SplitAndTransposeLayer(name)
            % 构造函数：初始化层并指定名字
            % 输入参数：
            % - name: 层的名称

            layer.Name = name;
            layer.Description = '空间转时序输入数据的自定义层';
            layer.NumInputs = 1;  % 定义输入接口数量
            layer.NumOutputs = 1; % 定义输出接口数量

            % 设置拆分点 
        end

        function out = predict(layer,input)
            % 定义预测时的前向传播逻辑
           
            out=dlarray(input,'TCB');
        end
    end
end