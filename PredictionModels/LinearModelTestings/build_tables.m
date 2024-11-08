clear
base_fig_dir = "C:\Users\yotam\Desktop\FigsAndTables\figs_240921-continues-dop-delay\";
features_raw = string({"echo_doppler","delay"});
%     {'tx_diveded_by_rx'} {'max_doppler_diff'} {'rx_var'} {'echo_doppler'} 
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
movtype = ["woods", "field", "hunting"];
% emptyTable = cell2table(cell(length(rows), length(features_raw)), 'RowNames', rows, 'VariableNames', features_raw);
% bat_dict = struct();
% bat_dict.bat2 = 1; bat_dict.bat4 = 2; bat_dict.bat5 = 3;
for n_window = ["2_calls", "3_calls","4_calls","5_calls"]
    num_calls_back = str2double(extractBefore(n_window, "_calls"))-1;
    wind_features_raw = [];
    for i = 1:num_calls_back
        wind_features_raw = [wind_features_raw, features_raw+num2str(-i)];
    end
    wind_features_raw = repelem(wind_features_raw,2);
    wind_features_raw(2:2:end) = wind_features_raw(2:2:end) + "p_value";
    wind_features_raw(end+1) = "(Intercept)";
    
    for bat_num = ["2","4","5"]
        per_bat_empty_cell_array = cell(1, length(features_raw)+3);
        movement_counter = 0;
        rows_names = [];

        for movement = movtype %rows
            for ith_mdl = 1:length(all_mat_files)
                cur_name = all_mat_files{ith_mdl};
                [cur_filepath,cur_filename] = fileparts(cur_name);
                mdl_bat_str = split(extractBetween(cur_filepath, "FigsAndTables\","_calls"), "\");
                mdl_bat_str = mdl_bat_str{2};
                mdl_movement = extractBetween(string(cur_filename), "model_", "_");
                mdl_movement = mdl_movement{1};
                if bat_num == mdl_bat_str && movement == mdl_movement && contains(cur_name, n_window)
                    load(cur_name)
                    movement_counter = movement_counter+1;
                    rows_names = [rows_names; movement+num2str(movement_counter)];
                    for ith_feat = 1:length(wind_features_raw)
                        if any(contains(string(mdl.Coefficients.Row), wind_features_raw(ith_feat)))
                            per_bat_empty_cell_array{movement_counter, ith_feat} = num2str(mdl.Coefficients(wind_features_raw(ith_feat), "Estimate").Variables);
                        elseif contains(wind_features_raw(ith_feat),"p_value") && any(contains(string(mdl.Coefficients.Row), wind_features_raw(ith_feat-1)))
                            per_bat_empty_cell_array{movement_counter, ith_feat} = num2str(mdl.Coefficients(wind_features_raw(ith_feat-1), "pValue").Variables);   
                        else
                            per_bat_empty_cell_array{movement_counter, ith_feat} = "---";
                        end
                    end
                    per_bat_empty_cell_array{movement_counter, length(wind_features_raw)+1} = length(mdl.Residuals.Raw);
                    per_bat_empty_cell_array{movement_counter, length(wind_features_raw)+2} = num2str(vecnorm(mdl.Residuals.Raw)/sqrt(length(mdl.Residuals.Raw)));
                    per_bat_empty_cell_array{movement_counter, length(wind_features_raw)+3} = num2str(mdl.ModelCriterion.BIC);
                    per_bat_empty_cell_array = [per_bat_empty_cell_array;cell(1, length(wind_features_raw)+3)];
                end
            end
        end
%         per_bat_empty_cell_array = per_bat_empty_cell_array(cellfun(@(x) ~isempty(x), per_bat_empty_cell_array));
        per_bat_empty_cell_array(end,:) = [];
        features_to_format = FormatFeatures(wind_features_raw, prediction_name);
        bat_table = cell2table(per_bat_empty_cell_array,"VariableNames",[features_to_format, "data_points", "RMSE", "BIC"]);
        bat_table.movement_type = rows_names;
        bat_table = bat_table(:,[length(bat_table.Properties.VariableNames), 1:length(bat_table.Properties.VariableNames)-1]);
        if n_window == "2_calls"
            bat_table = bat_table(:,~contains(bat_table.Properties.VariableNames, "-2"));
        end
        bat_table = FormatTableForSaving(bat_table);
        
        writetable(bat_table, base_fig_dir+sprintf("bat%s_%s.xlsx",bat_num,n_window))
    end
end





