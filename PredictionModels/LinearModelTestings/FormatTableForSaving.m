function bat_table_reorder = FormatTableForSaving(bat_table)
bat_table_reorder = bat_table;
var_names = bat_table_reorder.Properties.VariableNames;
p_values_inds = find(contains(var_names, "p_value"));
feature_inds = p_values_inds-1;
bic_rmse_inds = find(contains(var_names, "BIC") | contains(var_names, "RMSE") );
bat_table_reorder(:,feature_inds) = cellfun(@(x) FindSignificantDigits(x), bat_table_reorder(:,feature_inds).Variables, 'UniformOutput',false);
bat_table_reorder(:,p_values_inds) = cellfun(@(x) FindSignificantDigits(x), bat_table_reorder(:,p_values_inds).Variables, 'UniformOutput',false);
% bat_table_reorder(:,bic_rmse_inds) = cellfun(@(x) FindSignificantDigits(x), bat_table_reorder(:,bic_rmse_inds).Variables, 'UniformOutput',false);
var_names_reorder = var_names;
% var_names_reorder(sort([feature_inds,p_values_inds])) = var_names([feature_inds,p_values_inds]);
bat_table_reorder = bat_table_reorder(:,var_names_reorder);

end


function out_string = FindSignificantDigits(string_1)
if length(string_1) == 1
    out_string = string_1;
else
add_minus = false;
string_chars = char(string_1);
if string_chars(1) == '-'
    string_chars(1) = [];
    add_minus = true;
end
idx = -1;
if string_chars(1) == "0"
    for i = 1:length(string_chars)
        if string_chars(i) ~= '0' && string_chars(i) ~= '.'
            idx = i;
            break
        end
    end
    if idx+1>length(string_chars)
        out_string = "0."+string_chars(idx);
    else
        out_string = "0."+string_chars(idx:idx+1);
    end
    first_char_significant = false;
elseif str2double(string_chars)>=10
    idx_dot = strfind(string_chars, ".")-2;
    out_string = string_chars(1)+"."+string_chars(2)+"e"+num2str(idx_dot);
    first_char_significant = true;
else
    out_string = string_chars(1:3);
    first_char_significant = true;
end
e_notation_num = idx-strfind(string_chars, ".")-1;
if contains(string_1, "e")
    if first_char_significant 
        out_string = out_string+"e-"+(extractAfter(string_1, "-"));
    else
        out_string = out_string+"e-"+num2str(e_notation_num+str2double(extractAfter(string_1, "-")));
    end
elseif e_notation_num > 0
    out_string = out_string+"e-"+num2str(e_notation_num);
end
if add_minus
    out_string = "-"+out_string;
end
out_string = char(out_string);
end
end