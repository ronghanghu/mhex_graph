function dump_mhex_to_mat(G, filename)
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

% the first matrix multiplication, turning num_v raw category scores into
% num_leaf raw assignment scores
% matrix size: num_leaf * num_v
M1 = double(G.S);

% the second matrix multiplication, turning num_leaf assignment
% probabilities into num_v marginal category probabilities
% matrix size: num_v * num_leaf
M2 = double(G.E_des_i(:, G.leaves));

save(filename, 'M1', 'M2', '-v7.3');
fprintf('successfully dumped MHEX Graph to %s\n', filename);

end

