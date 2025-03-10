function [transformedA, transformedB] = transformImagePair(imagesA, imagesB, preSize, cropSize, augmenter)
% transformImagePair    Apply a matching set of transformations to images
%
% Args:
%   imagesA     - cell array of images to transform
%   imagesB     - cell array of images to transform
%   preSize     - [1x2] dimensions to initially resize image to
%   cropSize    - [1x2] dimensions to crop image to
%   augment     - imageDataAugmenter to use for image transforms
%
% Returns:
%   transformedA - cell array of transformed images A
%   transformedB - cell array of transformed images B

% Copyright 2020 The MathWorks, Inc.

    % Default to identity transform
    transformedA = imagesA;
    transformedB = imagesB;
    
    % Apply a resize opertion 缩放操作
    if ~isempty(preSize)
        %cellfun：对元胞数组中的每个元胞应用函数
        transformedA = cellfun(@(im) imresize(im, preSize), ...
                                transformedA, ...
                                'UniformOutput', false);
        %注，uniformOutput属性为true时，返回的说名称-数值的格式
        transformedB = cellfun(@(im) imresize(im, preSize), ...
                                transformedB, ...
                                'UniformOutput', false);
    end
    
    % Apply the imageDataAugmenter
    %augmentPair 它的作用是对输入的两幅图像 X 和 Y 执行相同的图像增强操作。
    if ~isempty(augmenter)
       [transformedA, transformedB] = augmenter.augmentPair(transformedA, transformedB);
    end
    
    % Apply a random crop， 随机裁剪
    if ~isempty(cropSize)
        [transformedA, transformedB] = randCrop(transformedA, transformedB, cropSize);
    end
    
end

function [imOut1, imOut2] = randCrop(im1, im2, cropSize)
    rect = augmentedImageDatastore.randCropRect(im1, cropSize);
    doCrop = @(im) augmentedImageDatastore.cropGivenDiscreteValuedRect(im, rect);
    imOut1 = cellfun(doCrop, im1, 'UniformOutput', false);
    imOut2 = cellfun(doCrop, im2, 'UniformOutput', false);
    
end