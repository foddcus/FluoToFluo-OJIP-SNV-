function translatedImage = translate(p2pModel, inputImage, varargin)
% translate    Apply a generator to an image.
%
% Args:
%   p2pModel    - struct containing a pix2pix generator as produced by the
%                 output of p2p.train
%   inputImage  - Input image to be translated
%   
%   translate also accepts the following Name-Value pairs:
%
%       ExecutionEnvironment - What processor to use for image translation,
%                              "auto", "cpu", or, "gpu" (default: "auto")
%       ARange               - Maximum numeric value of input image, used
%                              for input scaling (default: 255)
%   
% Returns:
%   translatedImage - Image translated by the generator model
%
% Note:
%   The input image must be a suitable size for the generator model
%
% See also: p2p.train
    
% Copyright 2020 The MathWorks, Inc.
    
    networkInput = prepImageForNetwork(inputImage);
    translatedImage = p2pModel.g.forward(networkInput);%（省略了tanh）
    


end



function networkInput = prepImageForNetwork(input)
    % cast to single, scale and put on the gpu as appropriate
    networkInput =input;
    networkInput = dlarray(networkInput, 'SCB');
end