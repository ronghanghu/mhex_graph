function max_ov = max_overlap(G)
% Omega = imagenet.max_overlap(G)
%   Calculate the maximum overlap of MHEX Graph (to compare with HEX Graph)
%
%   G is MHEX Graph handle
%   max_ov is the maximum overlap

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
% 
% This file is part of the MHEX Graph code and is available 
% under the terms of the Simplified BSD License provided in 
% LICENSE. Please retain this notice and LICENSE if you use 
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

% descendents including itself
E_des_i = single(G.E_des_i);

% generate exclusion using "exclusion whenever possible" by putting a
% exclusion edge between any two classes that do not share a descendent
E_exc = (E_des_i * E_des_i' == 0);
% E_exc = false(G.num_v);
% for v1 = 1:G.num_v
%   for v2 = 1:G.num_v
% %     E_exc(v1, v2) = ~any(E_des_i(v1, :) & E_des_i(v2, :));
%     E_exc(v1, v2) = (E_des_i(v1, :) * E_des_i(v2, :)' == 0);
%   end
% end

E_ov = ~(G.E_anc_i | G.E_des_i | E_exc);
max_ov = max(sum(E_ov));

end

