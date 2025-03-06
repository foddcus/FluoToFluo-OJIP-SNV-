
%定义一个对此数据储存格式，继承了Datastore的定义与接口
classdef PairedImageDatastore < matlab.io.Datastore & ...
        matlab.io.datastore.Shuffleable & ...
        matlab.io.datastore.MiniBatchable
    % PairedImageDatastore A datastore to provide pairs of images.
    %
    %   This datastore allows mini-batching and shuffling of matching pairs of
    %   images in two folders while, preserving the pairing of images.

    % Copyright 2020 The MathWorks, Inc.

    %依赖属性，
    properties (Dependent)
        MiniBatchSize
    end

    %内部属性
    properties (SetAccess = protected)
        A
        B
        dataA
        dataB
        NumObservations
        MiniBatchSize_

        %后面五个参数，需要在函数中设置
        Augmenter
        PreSize
        CropSize
        ARange
        BRange
    end


    %静态方法，提供全局访问
    methods (Static)
        function [inputs, remaining] = parseInputs(varargin)
            %创建实例，函数输入解析器inputParser
            parser = inputParser();
            % Remaining inputs should be for the imageAugmenter
            %添加默认参数
            parser.KeepUnmatched = true;

            %这个得根据数据集和模型进行修改
            parser.addParameter('PreSize', 128);
            parser.addParameter('CropSize', 128);
            parser.addParameter('ARange', 128);
            parser.addParameter('BRange', 128);

            %替换参数，解析器输入，解析器输入函数可以判断输入值的类型和大小等是否满足条件。
            parser.parse(varargin{:});

            %替换后输出参数
            %Result属性，返回有匹配的输入解析器模式
            inputs = parser.Results;
            %Unmatched属性，返回无匹配的的输入解析器模式，就是和输入和输出匹配的话就返回空，只返回不匹配的字段
            %这里不匹配的被预设会数据增强的函数；
            remaining = parser.Unmatched;
        end
    end

    %主函数
    methods
        function obj = PairedImageDatastore(A, B, miniBatchSize, varargin)
            % Create a PairedImageDatastore
            %
            % Args:
            %   A               - array data of input
            %   B               - array data of output
            %   miniBatchSize   - Number of image pairs to provide in each
            %                       minibatch
            % TODO list optional name-value pairs PreSize, CropSize,
            % Mirror
            %

            %断言操作，如果为假则报错
            %判断两个数据库的数量是否一致
            assert(size(A,1) == size(B,1), ...
                'p2p:datastore:notMatched', ...
                'Number of files in A and B folders do not match');
            obj.NumObservations = size(A,1);
            obj.A=A;
            obj.B=B;


            %构建数据库
            obj.dataA = arrayDatastore(obj.A','IterationDimension',2,'OutputType','cell');
            obj.dataB = arrayDatastore(obj.B','IterationDimension',2,'OutputType','cell');
            obj.MiniBatchSize = miniBatchSize;


            % Handle optional arguments
            %创建实例体
            [inputs, remaining] = obj.parseInputs(varargin{:});

            obj.ARange = inputs.ARange;
            obj.BRange = inputs.BRange;
            obj.Augmenter = imageDataAugmenter(remaining);%将不同的设置进行批量变化
            obj.PreSize = inputs.PreSize;
            obj.CropSize = inputs.CropSize;
            

        end


        %%该结构体的功能
        %判断是否还有未提取的数据
        function tf = hasdata(obj)
            tf = obj.dataA.hasdata() && obj.dataB.hasdata();
        end

        %读取数据
        function data = read(obj)
            dataA = obj.dataA.read();
            dataB = obj.dataB.read();

            % for batch size 1 imagedatastore doesn't wrap in a cell
            %当批次为1时，imagedatastore 不会将数据封装到cell中，这里手动添加；
            if ~iscell(dataA)
                dataA = {dataA};
                dataB = {dataB};
            end

            %将图像进行翻转增强等：
            %该函数transformImagePair的主要作用是对两组图像（dataA和dataB）
            % 应用一系列相匹配的变换。这些变换包括调整图像大小、应用图像增强（如旋转、翻转等），
            % 以及随机裁剪图像。该函数特别适用于准备用于深度学习训练的图像对，
            %  % 其中每对图像可能需要以相同的方式进行处理以保持它们之间的一致性。
            % [transformedA, transformedB] = ...
            %      p2p.data.transformImagePair(dataA, dataB, ...
            %                                  obj.PreSize, obj.CropSize, ...
            %                                  obj.Augmenter);
            % %归一化
            %  [A, B] = obj.normaliseImages(transformedA, transformedB);

            data = table(dataA, dataB);
        end

        %将数据储存恢复原本状态
        function reset(obj)
            obj.dataA.reset();
            obj.dataB.reset();
        end

        function objNew = shuffle(obj)
            objNew = obj.copy();           
            numObservations = objNew.NumObservations;

            obj.dataA.reset();
            obj.dataB.reset();
            idx = randperm(numObservations);
            objNew.A = obj.A(idx,:);
            objNew.B = obj.B(idx,:);

            %重新构建数据库
            obj.dataA = arrayDatastore(objNew.A','IterationDimension',2,'OutputType','cell');
            obj.dataB = arrayDatastore(objNew.B','IterationDimension',2,'OutputType','cell');
            
        end

        % %归一化，这里归一化至【-1，1】
        % function [aOut, bOut] = normaliseImages(obj, aIn, bIn)
        %     aOut = cellfun(@(x) 2*(single(x)/obj.ARange) - 1, aIn, 'UniformOutput', false);
        %     bOut = cellfun(@(x) 2*(single(x)/obj.BRange) - 1, bIn, 'UniformOutput', false);
        % end

        function val = get.MiniBatchSize(obj)
            val = obj.MiniBatchSize_;
        end

        function set.MiniBatchSize(obj, val)
            obj.dataA.ReadSize = val;
            obj.dataB.ReadSize = val;
            obj.MiniBatchSize_ = val;
        end

    end

end