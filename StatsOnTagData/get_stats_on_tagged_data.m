tag_path = "C:\Users\yotam\Desktop\ProjectsData\tags";
tag_table = LoadAllTagData(tag_path);
tag_table = renamevars(tag_table, "rx_freq", "rx_freq_tagged");
tag_table = renamevars(tag_table, "tx_freq", "tx_freq_tagged");
tag_table.key = tag_table.audio_path+num2str(tag_table.times(:,1));

base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")
res_table.key = res_table.audio_path+num2str(res_table.times(:,1));
joined_table = join(tag_table, res_table, "Keys","key");

num_tagged = height(joined_table);
num_detection_problem = sum(joined_table.detection_problem == 1);
num_echo_tagged = sum(joined_table.rx_freq_tagged ~= -1);

rmse_rx = RmseSpecificVar(joined_table, "rx_freq", "rx_freq_tagged");

relv_inds = joined_table.rx_freq_tagged ~= -1 & ~isnan(joined_table.rx_freq);

fp_echo_detection = sum(joined_table.rx_freq_tagged == -1 & ~isnan(joined_table.rx_freq))/height(joined_table)
tp_echo_detection = sum(joined_table.rx_freq_tagged ~= -1 & ~isnan(joined_table.rx_freq))/height(joined_table)
tn_echo_detection = sum(joined_table.rx_freq_tagged == -1 & isnan(joined_table.rx_freq))/height(joined_table)
fn_echo_detection = sum(joined_table.rx_freq_tagged ~= -1 & isnan(joined_table.rx_freq))/height(joined_table)



aa_table = joined_table(relv_inds, :);

figure;
scatter(aa_table.rx_freq_tagged, aa_table.rx_freq); hold on
plot([min(aa_table.rx_freq_tagged), max(aa_table.rx_freq_tagged)], [min(aa_table.rx_freq_tagged), max(aa_table.rx_freq_tagged)])
figure; 
hist(aa_table.rx_freq_tagged-aa_table.rx_freq,30)


