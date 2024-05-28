clear; close all;
%% Load and prepare data
data_preperation_script
base_fig_dir = "C:\Users\yotam\Desktop\FigsAndTables\figs_240526-rx_to_tx_rat\";
res_table_2_peaks.max_doppler_diff = res_table_2_peaks.max_doppler-res_table_2_peaks.tx_freq_from_filtered_tx_fft;
%% Pre loop
threshold_dict_sig = struct("tx_freq_from_filtered_tx_fft", [77000,81000], "rx_freq", [78500,82000], "durations", [0,0.15]);

features_combinations = {
%     {"echo_doppler", "movement_type"},
      {"tx_diveded_by_rx", "movement_type"},
%     {"tx_freq_from_filtered_tx_fft", "target_divided_by_rx", "echo_doppler", "movement_type"},
%     {"target_divided_by_rx", "echo_doppler", "movement_type"},
%     {"target_divided_by_rx", "diff_from_desired", "movement_type"}};
};
prediction_name = "tx_freq";


n_windows = [2,3,4,5];
bat_nums = [2,4,5];

for bat_num = bat_nums
    for ith_window = 1:length(n_windows)
        for jj = 1:length(features_combinations)
            n_window = n_windows(ith_window);
            features = features_combinations{jj};

            cont_inds_cell = GetNContinuesInds(all_tx_time,res_table_2_peaks.bat_num, n_window);
            [X_lsboost, y_lsboost, var_names, cont_inds_as_rows_passing_thrsholds, vaild_inds, cur_bat_gps_match] = ...
                ContIndsAndFeatures2XData(res_table_2_peaks, threshold_dict_sig, cont_inds_cell,...
                features, n_window, bat_num, prediction_name);
            vaild_inds = vaild_inds(:,1);
            y = y_lsboost(:,1);

            var_names{end+1} = prediction_name;
            X_table = array2table([X_lsboost(vaild_inds,:),y(vaild_inds,:)],'VariableNames',string(var_names(2:end).'));
            unq_mvmt = unique(X_table.("movement_type-1"));
            for ith_type = 1:length(unq_mvmt)
                type_of_movement = unq_mvmt(ith_type);
%                 if ~all(vaild_inds)
%                     continue
%                 end
                [pred_vals, coef_table, bic_val, mdl] = GLMPredict(X_table(strcmp(X_table.("movement_type-1"),type_of_movement),:), prediction_name);
                figure;
                plot(pred_vals, mdl.Variables.(prediction_name), "."); hold on; 
                plot([min([pred_vals;mdl.Variables.(prediction_name)]),max([pred_vals;mdl.Variables.(prediction_name)])],...
                    [min([pred_vals;mdl.Variables.(prediction_name)]),max([pred_vals;mdl.Variables.(prediction_name)])])
                xlabel("predicted values [Hz]")
                ylabel("true values [Hz]")
                title_movment = sprintf("movement type: %s", type_of_movement);
                title_bat_num = sprintf("bat number %i", bat_num);
                title_num_calls = sprintf("number of past calls used = %i", n_window-1);
                title_features_used = sprintf("features used: %s", join(string(FormatFeatures(features, prediction_name)), ", "));
                title_string = sprintf("Pred vs True, %s\n%s\n%s\n%s", title_bat_num, title_features_used, title_num_calls, title_movment);
                title(title_string) 
                fig_name = replace(join(string(FormatFeatures(features, prediction_name)), "_"), " ", "_");
                fig_name = replace(fig_name, "/", "_by_");
                fig_name = replace(fig_name, "(", ""); fig_name = replace(fig_name, ")", "");
                full_dir = base_fig_dir+sprintf("%i\\%i_calls\\", bat_num, n_window);
                savefig(full_dir+type_of_movement+"_"+fig_name)
                close
                save(full_dir+"model_"+type_of_movement+"_"+fig_name, "mdl")
            end
        end
    end
end

