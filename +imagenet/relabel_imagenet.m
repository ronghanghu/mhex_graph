function relabel_imagenet(G, input_file, save_file, relabel_percent)
% relabel_imagenet(G, input_file, save_file, relabel_percent)
%   a tool to relabel imagenet leaf labels to their immediate parent to
%   reproduce the experiment in HEX paper.
%
%   G is MHEX Graph handle
%   input_file is the original imagenet label file, and should look like
%   save_file is output relabeled file
%   relabel_percent is the probability of relabeling an instance

% AUTORIGHTS
% ---------------------------------------------------------
% Copyright (c) 2015, Ronghang Hu (huronghang@hotmail.com)
%
% This file is part of the MHEX Graph code and is available
% under the terms of the Simplified BSD License provided in
% LICENSE. Please retain this notice and LICENSE if you use
% this file (or any portion of it) in your project.
% ---------------------------------------------------------

fprintf(['Please make sure that labels in input_file is'...
  ' the SAME ORDER as in ILSVRC Devkit. The Caffe file is NOT.'...
  ' see http://caffe.berkeleyvision.org/gathered/examples/imagenet.html'...
  ' for details.\n']);

fprintf('input file: %s\n', input_file);
fprintf('save file: %s\n', save_file);
fprintf('relabel precent: %3.f\n', relabel_percent);

assert(relabel_percent >= 0 && relabel_percent <= 1);

fid_i = fopen(input_file, 'r');
fid_s = fopen(save_file, 'w');

count_all = 0;
count_relabeled = 0;

fprintf('relabeling...');

line_in = fgetl(fid_i);
while ischar(line_in)
  % read and parse
  C = strsplit(line_in);
  im_path = C{1};
  im_label = str2double(C{2});
  % change from 0-indexed to 1-indexed
  im_label = im_label + 1;
  % decide randomly whether to relabel
  if relabel_percent > 0 && rand(1) <= relabel_percent
    % relabel to its parent
    parents = G.synsets(im_label).parents;
    assert(~isempty(parents));
    num_parents = length(parents);
    im_label = parents(randsample(num_parents, 1));
    count_relabeled = count_relabeled + 1;
  end
  % change back from 1-indexed to 0-indexed
  im_label = im_label - 1;
  fprintf(fid_s, '%s %d\n', im_path, im_label);
  count_all = count_all + 1;
  
  % get new line
  line_in = fgetl(fid_i);
end

fclose(fid_i);
fclose(fid_s);

fprintf('done\n');

fprintf('relabeled %d / %d = %.3f instances\n', count_relabeled, ...
  count_all, count_relabeled / count_all);
fprintf('saved to %s\n', save_file);

end