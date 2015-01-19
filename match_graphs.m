function [matched_1, matched_2] = match_graphs(G1, G2)
% [matched_1, matched_2] = match_graph(G1, G2)
%   Match leaves in Graph 1 to leaves in Graph 2
%
%   G1 and G2 are MHEX Graph handles
%   matched_1 and matched_2 are matched leaf indices (binary vector)

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
% 
% This file is part of the MHEX Graph code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

% convert WNID to numbers for efficient comparison
wnids_1 = zeros(G1.num_v, 1);
for v1 = 1:G1.num_v
  WNID = G1.synsets(v1).WNID;
  wnids_1(v1) = str2double(WNID(2:end-1));
end
wnids_2 = zeros(G2.num_v, 1);
for v2 = 1:G2.num_v
  WNID = G2.synsets(v2).WNID;
  wnids_2(v2) = str2double(WNID(2:end-1));
end

matched_1 = false(G1.num_leaf, 1);
matched_2 = false(G2.num_v, 1);
for vid1 = 1:G1.num_leaf
  if mod(vid1, 100) == 0
    fprintf('matching %d / %d\n', vid1, G1.num_leaf);
  end
  v1 = G1.leaves(vid1);
  for v2 = 1:G2.num_v;
    if wnids_1(v1) == wnids_2(v2)
      matched_1(v1) = true;
      matched_2 = matched_2 | G2.E_des_i(v2, :)';
    end
  end
end
matched_2 = matched_2(G2.leaves);

fprintf('%d / %d leaves in Graph 1 are matched to leaves in Graph 2\n', ...
  sum(matched_1), G1.num_leaf);
fprintf('%d / %d leaves in Graph 2 are matched to leaves in Graph 1\n', ...
  sum(matched_2), G2.num_leaf);

end