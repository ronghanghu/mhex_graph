load meta_200.mat;

synsets_200_original = synsets;

num_v = length(synsets);

% add parents to each node
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
idx_map = zeros(sum(keep), 1);
idx_map(keep) = 1:sum(keep);
synsets = synsets(keep);
for v = 1:length(synsets)
  synsets(v).children = idx_map(synsets(v).children);
  synsets(v).words = synsets(v).name;
end

save meta_200.mat synsets;
