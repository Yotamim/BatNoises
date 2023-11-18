function DispRawPipelineStats(tagged_table)

num_tagged = height(tagged_table);
calls_table = tagged_table(tagged_table.tx_freq_tagged ~= -1,:);

num_calls_tagged = height(calls_table);
num_echos_tagged = sum(calls_table.rx_freq_tagged ~= -1);

calls_with_echo_tagged_table = calls_table(calls_table.rx_freq_tagged ~= -1,:);

doppler_freq_diff = calls_with_echo_tagged_table.rx_freq_tagged-calls_with_echo_tagged_table.tx_freq_tagged;
calls_with_doppler_tagged_table = calls_with_echo_tagged_table(doppler_freq_diff >100, :);
num_echo_with_dop = height(calls_with_doppler_tagged_table);
num_doppler_detected = sum(calls_with_doppler_tagged_table.alg_rx ~= -1);

% fprintf("num miss detect calls = %i \n",num_tagged-num_calls_tagged)
fprintf("num tagged calls = %i \n",num_calls_tagged)
fprintf("num tagged calls with no echo at all = %i \n",num_calls_tagged-num_echos_tagged)
fprintf("num tagged calls with echo at same freq as tx = %i \n",num_echos_tagged-num_echo_with_dop)
fprintf("num tagged calls with doppler echo = %i \n", num_echo_with_dop)
fprintf("echo detection pd = %i%% \n", fix(100*(num_doppler_detected/num_echo_with_dop)))


end