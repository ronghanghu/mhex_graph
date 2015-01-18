function view_multiple_parents(G)
% view_multiple_parents(G)
%   inspect those nodes who have multiple parents
%
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

synsets = G.synsets;
num_v = G.num_v;

count = 0;
for v = 1:num_v
  if length(synsets(v).parents) > 1
    count = count + 1;
    fprintf('No. %d %s\nhas multiple parents:\n', count, synsets(v).words);
    for vid = 1:length(synsets(v).parents)
      v_parent = synsets(v).parents(vid);
      fprintf('\t%s\n', synsets(v_parent).words);
    end
  end
end

end