clear
base_fig_dir = "C:\Users\yotam\Desktop\FigsAndTables\figs_240719-rx_var_bat_num\";
features_raw = string({"rx_var", "movement_type", "bat_num"});

dir1 = dir(base_fig_dir);
all_mat_files = {};
for k = 3:length(dir1)
    if contains(dir1(k).name, ".m")
        all_mat_files{end+1} = fullfile(dir1(k).folder,dir1(k).name);
    end
end
all_mat_files = all_mat_files';
prediction_name = "tx_freq";

num_feat_comb = 4;

table_all_bats = [];
bat_strings = ["2","4","5"];
all_bat_info = [];
model_stats = [];
for ith_mdl = 1:length(all_mat_files)
    cur_name = all_mat_files{ith_mdl};
    [cur_filepath,cur_mdl_name] = fileparts(cur_name);
    temp = load(cur_name, cur_mdl_name);
    mdl = temp.(cur_mdl_name);
    %         for ith_thing = string(mdl.Coefficients.Name.')
    %             mdl.Coefficients.Estimate(ith_thing == string(mdl.Coefficients.Name.'))
    %             mdl.Coefficients.pValue(ith_thing == string(mdl.Coefficients.Name.'))
    %             mdl.Coefficients.Name(ith_thing == string(mdl.Coefficients.Name.'))
    %
    %         end
    agg_info = [mdl.Coefficients.Name, num2cell(mdl.Coefficients.Estimate), num2cell(mdl.Coefficients.pValue)];
    %
    %         per_bat_empty_cell_array{movement_counter, length(wind_features_raw)+1} = length(mdl.Residuals.Raw);
    RMSE = num2str(vecnorm(mdl.Residuals.Raw)/sqrt(length(mdl.Residuals.Raw)));
    BIC = num2str(mdl.ModelCriterion.BIC);
    data_points = mdl.NumObservations;

    model_stats = [model_stats; {RMSE}, {BIC}, {data_points}];
    all_bat_info = [all_bat_info ;agg_info];
end
[~,l,~] = unique(all_bat_info(:,1), "rows");
model_stats = model_stats(1,:);
all_bat_info = all_bat_info(l,:);
all_names = repelem(string(all_bat_info(:,1).'),2);
all_names = replace(replace(all_names, "(",""),")","");
all_names = replace(all_names, "movement_type1_","");
all_names(2:2:end) = all_names(2:2:end)+"_p_value";
% all_names = replace(all_names, mvmet_types, mvmet_types_yossi);
nums_bat_info = all_bat_info(:,2:3);
nums_bat_info = nums_bat_info.';
nums_bat_info = nums_bat_info(:).';
cell_as_table = cellstr([[all_names, "RMSE", "BIC", "data_points"];[nums_bat_info,model_stats]]);
table_all_bats = [table_all_bats;cell2table(cell_as_table(2,:), "VariableNames",cell_as_table(1,:))];

writetable(table_all_bats, base_fig_dir+"_"+sprintf("lme_table_for_paper.xlsx"))

