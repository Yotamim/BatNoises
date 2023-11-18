function rmse_val = RmseSpecificVar(j_table, alg_var, tag_var)

doppler_table = j_table(j_table.rx_freq_tagged ~= -1 & (j_table.rx_freq_tagged-j_table.tx_freq_tagged)>100 &...
    j_table.alg_rx ~= -1,:);
rmse_val = sqrt(sum(((doppler_table.(tag_var)-doppler_table.(alg_var)).^2))/height(doppler_table));


end