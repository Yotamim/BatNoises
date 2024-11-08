function [mdls_cell, mdl_field] =  GLMEPredict(X_table, pred_name)

y_ind = strcmp(X_table.Properties.VariableNames,pred_name);
y_array = str2double(X_table(:,y_ind).Variables);

x_ind_num = ~strcmp(X_table.Properties.VariableNames,pred_name) & ~contains(X_table.Properties.VariableNames,"movement");
X_array_num = str2double(X_table(:,x_ind_num).Variables);

x_ind_cat = contains(X_table.Properties.VariableNames,"movement");
X_array_cat = X_table(:,x_ind_cat ).Variables;

var_names = [X_table.Properties.VariableNames(x_ind_num), X_table.Properties.VariableNames(x_ind_cat), X_table.Properties.VariableNames(y_ind)];
var_names = replace(var_names, "-", "");
X_table = cell2table([num2cell(X_array_num),cellstr(X_array_cat), num2cell(y_array)], "VariableNames", string(var_names));
% X_table.movement_type1 = nominal(X_table.movement_type1);
cats = ["2", "4", "5"];
mdls_cell = cell(1,length(cats));
X_table.bat_num = string(X_table.bat_num);
X_table.movement_type1 = categorical(X_table.movement_type1);
for ref_var = cats 
%     X_table.movement_type1 = categorical(X_table.movement_type1, {char(cats(cats == ref_var)), char(cats(cats ~= ref_var))});
    X_table.bat_num = categorical(X_table.bat_num, [{char(cats(cats == ref_var))}, cellfun(@(x) char(x), cellstr(cats(cats ~= ref_var)), 'UniformOutput', false)]);
    mdls_cell{cats == ref_var} = fitglme(X_table, 'tx_freq ~ rx_var1 + movement_type1 +(1|bat_num)');
    %     mdls_cell{cats == ref_var} = fitglme(X_table, sprintf('tx_freq ~ %s', join(string(var_names(~contains(var_names,pred_name))), " + ")));
end
% mdl_woods = mdls_cell{cats == "woods"};
% mdl_field = mdls_cell{cats == "field"};
mdl_field = cats;
mdl_woods = mdls_cell;
end