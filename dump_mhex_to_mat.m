function dump_mhex_to_mat(G, filename, include_root)
% dump_mhex_to_mat(G)
%
%   G is MHEX Graph handle
%   filename is the fullpath of output dump file

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
% 
% This file is part of the MHEX Graph code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

% typically you do not want to have weights for root in MHEX since it does
% not affect anything, also you don't want to calculate root probability
% since it is always 1
if ~exist('include_root', 'var')
  include_root = false;
end

% the first matrix multiplication, turning num_v raw category scores into
% num_leaf raw assignment scores
% matrix size: num_leaf * num_v
M1 = single(G.S);

% the second matrix multiplication, turning num_leaf assignment
% probabilities into num_v marginal category probabilities
% matrix size: num_v * num_leaf
M2 = single(G.E_des_i(:, G.leaves));

if ~include_root
  is_root = ((1:G.num_v) == G.root);
  M1 = M1(:, ~is_root);
  M2 = M2(~is_root, :);
end

save(filename, 'M1', 'M2', '-v7');
fprintf('successfully dumped MHEX Graph to %s\n', filename);

end
