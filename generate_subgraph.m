function [G_sub, idx_map_sub2whole, idx_map_whole2sub] = generate_subgraph(...
  G, indices)
% [G_sub, idx_map_sub2whole, idx_map_whole2sub] = generate_subgraph(G, indices)
%   generate a MHEX subgraph from a subset of variables
%
%   G is MHEX Graph handle
%   indices are indices (1-indexed) of variables from which the subgraph is
%   generated
%   G_sub is generated subgraph
%   idx_map_sub2whole is the index mapping from subgraph index to whole graph
%   index (both 1-indexed)
%   idx_map_whole2sub is the index mapping from whole graph index to subgraph
%   index (both 1-indexed, 0 for no match)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
% 
% This file is part of the MHEX Graph code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

if ~islogical(indices)
  temp = false(G.num_v, 1);
  temp(indices) = true;
  indices = temp;
else
  if size(indices, 1) <= size(indices, 2)
    indices = indices';
  end
  assert(size(indices, 1) == G.num_v);
  assert(size(indices, 2) == 1);
end

% remove ancestors
is_anc = any(G.E_anc(indices, :), 1)';
indices_reduced = indices & (~is_anc);
removed_vars = find(indices & ~(indices_reduced));
if ~isempty(removed_vars)
  fprintf('nodes ');
  fprintf('%d ', removed_vars);
  fprintf('in subgraph indices are removed because they are ')
  fprintf('ancestors of other variables in subgraph indices\n');
end

% generate index mapping vector
indices = indices_reduced;
indices = indices | any(G.E_anc(indices, :), 1)' | any(G.E_des(indices, :), 1)';
idx_map_sub2whole = find(indices);
num_v_sub = length(idx_map_sub2whole);
idx_map_whole2sub = zeros(G.num_v, 1);
idx_map_whole2sub(indices) = (1:num_v_sub)';

% generate sub graph
synsets_sub = G.synsets(indices);
synsets_sub = rmfield(synsets_sub, 'parents');
for v_sub = 1:num_v_sub
  synsets_sub(v_sub).children = ...
    update_children(synsets_sub(v_sub).children, idx_map_whole2sub);
end
G_sub = build_mhex_from_synsets(synsets_sub);

end

function children = update_children(children, idx_map_whole2sub)
  children = idx_map_whole2sub(children);
  children = children(children > 0);
end