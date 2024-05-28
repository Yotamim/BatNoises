%% load insects like behaviour
xlsx_path = "C:\Users\yotam\Documents\tag insects 4.xlsx";
tags_of_interesting_activity = readtable(xlsx_path);
tags_of_interesting_activity = tags_of_interesting_activity(sum(table2array(tags_of_interesting_activity(:,2:end)) == -1,2) ~= 6,:);
tags_of_interesting_activity.keys = replace(tags_of_interesting_activity.Var1, ".png'", "");
tags_of_interesting_activity = renamevars(tags_of_interesting_activity, ["Var1","Var2","Var3","Var4","Var5","Var6","Var7"], ["png_name", "t1i", "t1f", "t2i", "t2f", "t3i", "t3f"]);
%%
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")

keys = res_table.audio_path;
keys = replace(replace(keys, "C:\Users\yotam\Desktop\ProjectsData\bat04\", ""), ".wav", "");
[intersection_keys,~,intersection_inds_tag] = intersect(keys, tags_of_interesting_activity.keys);

res_table_interesting = res_table(contains(keys, intersection_keys),:);
res_table_interesting.keys = (keys(contains(keys, intersection_keys)));
tags_of_interesting_activity_intersected = tags_of_interesting_activity(intersection_inds_tag,:);

res_table_interesting = join(res_table_interesting, tags_of_interesting_activity_intersected, "Keys","keys");

time_lims_extention = 0.25;
inds_to_keep = (res_table_interesting.t1i-time_lims_extention <= res_table_interesting.times(:,1) & res_table_interesting.times(:,1) <= res_table_interesting.t1f+time_lims_extention) |...
    (res_table_interesting.t2i-time_lims_extention <= res_table_interesting.times(:,1) & res_table_interesting.times(:,1) <= res_table_interesting.t2f+time_lims_extention) | ...
    (res_table_interesting.t3i-time_lims_extention <= res_table_interesting.times(:,1) & res_table_interesting.times(:,1) <= res_table_interesting.t3f+time_lims_extention);

res_table_interesting = res_table_interesting(inds_to_keep,:);
sum(res_table_interesting.num_peaks == 2)
% figure; hold on
% bins = [7.7:0.01:8.2]*1e4;
% histogram(res_table_interesting(res_table_interesting.num_peaks == 2, :).tx_freq_from_filtered_tx_fft, bins)
% histogram(res_table_interesting(res_table_interesting.num_peaks == 2, :).rx_freq, bins)
% 
% figure; hold on
% scatter(res_table_interesting(res_table_interesting.num_peaks == 2, :).tx_freq_from_filtered_tx_fft, ...
%     res_table_interesting(res_table_interesting.num_peaks == 2, :).rx_freq, '.')
save("only_perches.mat", "res_table_interesting")




