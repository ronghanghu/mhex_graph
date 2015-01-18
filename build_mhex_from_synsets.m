function G = build_mhex_from_synsets(synsets)
% G = build_mhex_from_synsets(synsets)
%   Build a Modified Hierarchy Exclusion (MHEX) Graph from ImageNET synsets
%
%   synsets is ImageNET synsets
%   G is MHEX Graph handle

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
fprintf('total synset number: %d\n', num_v);

% add parents to each node
for v = 1:num_v
  v_children = synsets(v).children;
  for vid = 1:length(v_children)
    v_child = v_children(vid);
    if ~isfield(synsets(v_child), 'parents')
      synsets(v_child).parents = v;
    else
      synsets(v_child).parents = [synsets(v_child).parents, v];
    end
  end
end

% find root node
root = -1;
for v = 1:num_v
  if isempty(synsets(v).parents)
    % assume there is only one root in the hierarchy
    if root > 0
      error('there are multiple roots in this hierarchy');
    end
    root = v;
    fprintf('root synset: %s\n', synsets(v).words);
  end
end

% find leaf nodes
leaves = [];
for v = 1:num_v
  if isempty(synsets(v).children)
    leaves = cat(1, leaves, v);
  end
end
num_leaf = length(leaves);
fprintf('leaf synset number: %d\n', num_leaf);

% add descendents to each node. the descendents of a node are its children
% and the descendents of each child
% initialize descendents with children
E_des = false(num_v);
for v = 1:num_v
  v_children = synsets(v).children;
  E_des(v, v_children) = true;
end
% use depth-first search and recursively collect descendents from children
node_visited = false(num_v, 1);
v = root;
while true
  v_children = synsets(v).children;
  children_visited = node_visited(v_children);
  
  % if this node has unvisited children, then go down. otherwise visit
  % this node
  if ~isempty(v_children) && ~all(children_visited)
    % pick the first child to go down
    vid = find(~children_visited, 1);
    v = v_children(vid);
  else
    % reached a leaf node or a branch node whose children have all been
    % visited. this node should have not been visited at this moment
    assert(~node_visited(v));
    % visit this node, collect descendents from its children (if any)
    for vid = 1:length(v_children)
      v_child = v_children(vid);
      E_des(v, :) = E_des(v, :) | E_des(v_child, :);
    end
    node_visited(v) = true;
    
    % if this node is not root, then go up. otherwise stop
    if ~isempty(synsets(v).parents)
      % pick a parent to go up
      v = synsets(v).parents(1);
    else
      % reaching root, all nodes should have been visited
      assert(all(node_visited));
      break
    end
  end
end

% add ancestors to each node. the ancestors of a node is those who have
% this node as descendent
E_anc = false(num_v);
for v = 1:num_v
  E_anc(v, E_des(:, v)) = true;
end

% ancestors and descendents plus the node itself
E_des_i = E_des | logical(eye(num_v));
E_anc_i = E_anc | logical(eye(num_v));

% list state space
num_s = num_leaf;
S = false(num_s, num_v);
for sid = 1:num_s
  % each legal assignment corresponds to a leaf node being turned on
  vid = sid;
  v_leaf = leaves(vid);
  S(sid, v_leaf) = true;
  S(sid, E_anc(v_leaf, :)) = true;
end

% add fields to MHEX Graph G
G.num_v = num_v;
G.num_leaf = num_leaf;
G.num_s = num_s;

G.synsets = synsets;
G.root = root;
G.leaves = leaves;
G.E_des = E_des;
G.E_anc = E_anc;
G.E_des_i = E_des_i;
G.E_anc_i = E_anc_i;
G.S = S;

end