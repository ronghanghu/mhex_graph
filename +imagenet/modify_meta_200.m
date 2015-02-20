function synsets = modify_meta_200(synsets)
% synsets = imagenet.modify_meta_200(synsets)
%   Modify the ILSVRC DET 200 classes synsets to remove those single
%   classes
%
%   synsets are ImageNET DET 200 synsets

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
%
% This file is part of the MHEX Graph code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

num_v = length(synsets);

% add parents to each node, and also add the field 'words'
for v = 1:length(synsets)
  v_children = synsets(v).children;
  for vid = 1:length(v_children)
    v_child = v_children(vid);
    if ~isfield(synsets(v_child), 'parents')
      synsets(v_child).parents = v;
    else
      synsets(v_child).parents = [synsets(v_child).parents, v];
    end
  end
  synsets(v).words = synsets(v).name;
end

% remove those nodes that are both root and leaf
is_root = false(length(synsets), 1);
is_leaf = false(length(synsets), 1);
for v = 1:num_v
  is_root(v) = isempty(synsets(v).parents);
  is_leaf(v) = isempty(synsets(v).children);
end
is_both = is_root & is_leaf;

synsets = rmfield(synsets, 'parents');
keep = ~is_both;
idx_map = zeros(length(keep), 1);
idx_map(keep) = 1:sum(keep);
synsets = synsets(keep);
for v = 1:length(synsets)
  synsets(v).children = idx_map(synsets(v).children);
  assert(all(synsets(v).children > 0));
end

% remove those leaf nodes that are not in the first 200 classes
det_num = 200;
in_det = (1:length(synsets) <= det_num)';
is_leaf = false(length(synsets), 1);
for v = 1:length(synsets)
  is_leaf(v) = isempty(synsets(v).children);
end
keep = in_det | (~is_leaf);
idx_map = zeros(length(keep), 1);
idx_map(keep) = 1:sum(keep);
synsets = synsets(keep);
for v = 1:length(synsets)
  synsets(v).children = idx_map(synsets(v).children);
  synsets(v).children = synsets(v).children(synsets(v).children > 0);
end

end