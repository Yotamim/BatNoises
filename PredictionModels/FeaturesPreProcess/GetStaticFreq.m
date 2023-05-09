function static_freq_struct = GetStaticFreq(res_table_1_peak)
bat_nums = unique(res_table_1_peak.bat_num);
for i = 1:length(bat_nums)
    cur_static_tx = res_table_1_peak(bat_nums(i) == res_table_1_peak.bat_num,:).raw_tx;
    static_freq_struct.("bat"+num2str(bat_nums(i))) = median(cur_static_tx);
end

