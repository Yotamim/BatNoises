function rmse_val = RmseSpecificVar(j_table, alg_var, tag_var)

relv_inds = j_table.(tag_var) ~= -1 & ~isnan(j_table.(alg_var));
rmse_val = sqrt(sum(((j_table(relv_inds,:).(tag_var)-j_table(relv_inds,:).(alg_var)).^2))/sum(relv_inds));

end