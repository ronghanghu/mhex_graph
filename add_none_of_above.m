function synsets_augmented = add_none_of_above(synsets, add_noa_to_root)
% synsets_augmented = add_none_of_above(synsets)
%   Adding a 'none-of-above' node to each branch node and root node. Such
%   'none-of-above' nodes are added at the end of synsets.
%
%   synsets is the original (input) synsets
%   add_noa_to_root flag decides whether or not to add a 'none-of-above' child
%   to root node. default is false.
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

if ~exist('add_noa_to_root', 'var')
  add_noa_to_root = false;
end

% find root node (the node without parent)
root = 0;
if ~add_noa_to_root
  is_root = true(length(synsets), 1);
  for v = 1:length(synsets)
    is_root(synsets(v).children) = false;
  end
  root = find(is_root);
  assert(length(root) == 1);
  fprintf('root synset is\n');
  disp(synsets(root));
end

synsets_augmented = synsets;

fprintf('adding none-of-above nodes...\n');
count = 0;
for v = 1:length(synsets)
  % for all branch nodes, add 'none-of-above' child
  if ~isempty(synsets(v).children)
    if ~add_noa_to_root && (v == root)
      fprintf('skipped root node\n');
      continue
    end

    % create new synset
    % changing WNID from nxxxxxxxx to dxxxxxxx to represent 'dummy' synset
    noa_synset = synsets(v);
    noa_synset.WNID(1) = 'd';
    noa_synset.children = [];
    if isfield(noa_synset, 'num_children')
      noa_synset.num_children = 0;
    end
    
    synsets_augmented = cat(1, synsets_augmented, noa_synset);
    insert_idx = length(synsets_augmented);
    
    % append new 'none-of-above' node to the children
    synsets_augmented(v).children = [synsets(v).children, insert_idx];
    
    count = count + 1;
  end
end

fprintf('done. added %d none-of-above children\n', count);

end