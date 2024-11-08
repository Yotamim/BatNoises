clear
base_fig_dir = "C:\Users\yotam\Desktop\FigsAndTables\figs_240715-speed\";
features_raw = string({"speed"});

dir1 = dir(base_fig_dir);
all_mat_files = {};
for i = 3:length(dir1)
    dir2 = dir(fullfile(dir1(i).folder,dir1(i).name));
    for j = 3:length(dir2)
        dir3 = dir(fullfile(dir2(j).folder,dir2(j).name));
        for k = 3:length(dir3)
            if contains(dir3(k).name, ".m")
                all_mat_files{end+1} = fullfile(dir3(k).folder,dir3(k).name);
            end
        end
    end
end
all_mat_files = all_mat_files';
prediction_name = "tx_freq";

num_feat_comb = 4;
rows = ["bat2","bat4","bat5"].';

mvmet_types_yossi = ["vertical", "horizontal", "perching"];
mvmet_types = ["woods", "field", "hunting"];

table_all_bats = [];
for bat_str = ["2","4","5"]
    cur_bat_files = all_mat_files(extractBetween(string(all_mat_files), features_raw+"\","\2_calls") == bat_str);
    all_bat_info = [];
    model_stats = [];
    for ith_mdl = 1:length(cur_bat_files)
        cur_name = cur_bat_files{ith_mdl};
        [cur_filepath,cur_filename] = fileparts(cur_name);
        mdl_bat_str = split(extractBetween(cur_filepath, "FigsAndTables\","_calls"), "\");
        mdl_bat_str = mdl_bat_str{2};
        mdl_name = extractBefore(cur_filename, features_raw);
        temp = load(cur_name, mdl_name);
        mdl = temp.(mdl_name);
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
    all_names = replace(all_names, mvmet_types, mvmet_types_yossi);
    nums_bat_info = all_bat_info(:,2:3);
    nums_bat_info = nums_bat_info.';
    nums_bat_info = nums_bat_info(:).';
    cell_as_table = cellstr([["Bat", all_names, "RMSE", "BIC", "data_points"];[bat_str,nums_bat_info,model_stats]]);
    table_all_bats = [table_all_bats;cell2table(cell_as_table(2,:), "VariableNames",cell_as_table(1,:))];
end
writetable(table_all_bats, base_fig_dir+features_raw+"_"+sprintf("lme_table_for_paper.xlsx"))

%     %         per_bat_empty_cell_array = per_bat_empty_cell_array(cellfun(@(x) ~isempty(x), per_bat_empty_cell_array));
%     per_bat_empty_cell_array(end,:) = [];
%     features_to_format = FormatFeatures(wind_features_raw, prediction_name);
%     bat_table = cell2table(per_bat_empty_cell_array,"VariableNames",[features_to_format, "data_points", "RMSE", "BIC"]);
%     bat_table.movement_type = rows_names;
%     bat_table = bat_table(:,[length(bat_table.Properties.VariableNames), 1:length(bat_table.Properties.VariableNames)-1]);
%     if n_window == "2_calls"
%         bat_table = bat_table(:,~contains(bat_table.Properties.VariableNames, "-2"));
%     end
%     bat_table = FormatTableForSaving(bat_table);
%
%

