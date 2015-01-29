function correct_imagenet_labels(G_1k, input_file, save_file)

warning(['This tool is deprecated. Do not use it' ...
  ' unless you know what is happening.']);

synsets_leaves = G_1k.synsets(G_1k.leaves);
WNID_cell = cell(length(synsets_leaves), 1);
for v = 1:length(synsets_leaves);
  WNID_cell{v} = synsets_leaves(v).WNID;
end
[~, idx_original] = sort(WNID_cell);

fid_i = fopen(input_file, 'r');
fid_s = fopen(save_file, 'w');

count_all = 0;

fprintf('correcting...');

line_in = fgetl(fid_i);
while ischar(line_in)
  % read and parse
  C = strsplit(line_in);
  im_path = C{1};
  im_label = str2double(C{2});
  % change from 0-indexed to 1-indexed
  im_label = im_label + 1;

  % correct labels
  im_label = idx_original(im_label);

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

fprintf('corrected %d instances\n', count_all);
fprintf('saved to %s\n', save_file);

end