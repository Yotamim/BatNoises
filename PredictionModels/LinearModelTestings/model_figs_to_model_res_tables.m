clear; close all
base_figs_dir = "C:\Users\yotam\Desktop\figs\";
all_figs_files = dir(base_figs_dir);
bats_nums = [2,4,5];
all_models_res = [];
for ith_fig = 3:length(all_figs_files)
    cur_fig_name = all_figs_files(ith_fig).name;
    if ~contains(cur_fig_name, ".fig")
        continue
    end
    cur_fig = openfig(base_figs_dir+cur_fig_name);
    cur_user_data = cur_fig.UserData;
    cur_used_features = cur_user_data{1,2}.VarNames;
    cur_user_data = [cur_user_data, cellfun(@(x) x.VarNames, cur_user_data(:,2), 'UniformOutput', false)];
    user_data_len = length(cur_user_data);
    axises = get(gcf, "Children");
    for i = 1:length(axises)
        gca_data = get(axises(i), "UserData");
        gca_data_length = length(gca_data);
        cur_user_data(length(axises)+1-i,user_data_len+1:user_data_len+gca_data_length) = gca_data(:) ;
    end
    all_models_res = [all_models_res; cur_user_data];
    close
end
models_tables = cell2table(all_models_res,"VariableNames",["bat_num","coef_table","BIC",...
    "num_prev_calls","features", "data_rows", "valid_inds", "X", "y", "bat_num_a"]) ;
best_bic_per_bat = [];
for kth_bat = bats_nums
    cur_bat_models_table = models_tables(models_tables.bat_num == kth_bat,:);
    [~,ir] = min(cur_bat_models_table.BIC);
    best_bic_per_bat = [best_bic_per_bat;cur_bat_models_table(ir,:)];
end

save("C:\Users\yotam\Desktop\figs\"+"models_res","best_bic_per_bat","models_tables" )


