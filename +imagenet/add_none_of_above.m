function synsets_augmented = add_none_of_above(synsets)
% synsets_augmented = add_none_of_above(synsets)
%   Adding a 'none-of-above' node to each branch node and root node. Such
%   'none-of-above' nodes are added at the end of synsets.
%
%   synsets is the original (input) synsets
%   synsets_augmented is the augmented (output) synsets with
%   'none-of-above' nodes

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
%
% This file is part of the MHEX Graph code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

synsets_augmented = synsets;

count = 0;
for v = 1:length(synsets)
  % for all branch nodes, add 'none-of-above' child
  if ~isempty(synsets(v).children)
    % create new synset
    % replacing WNID from nxxxxxxxx to dxxxxxxx to represent 'dummy' synset
    noa_synset = synsets(v);
    noa_synset.WNID(1) = 'd';
    synsets_augmented = cat(1, synsets_augmented, noa_synset);
    insert_idx = length(synsets_augmented);
    
    % append new 'none-of-above' node to the children
    synsets_augmented(v).children = [synsets(v).children, insert_idx];
    
    count = count + 1;
  end
end

fprintf('added %d none-of-above children\n', count);

end