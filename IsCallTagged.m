function is_call_tagged = IsCallTagged(s_time, e_time, audio_path, tagged_data_table)
is_call_tagged = any(tagged_data_table.times(:,1) == s_time);
end