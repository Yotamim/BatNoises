agg_table = readtable("C:\Users\yotam\Desktop\ProjectsData\tags\katerina_tags\agg_tags.csv");
% agg_table = readtable("C:\Users\yotam\Desktop\OldthingsForBats\TagKatarinaFromat\katerina_tags\agg_tags.csv");
agg_table.audio_path = replace(agg_table.audio_path, "C:\Users\Sinisa\Desktop\TagCalls\bat_audios\", "C:\Users\yotam\Desktop\ProjectsData\");
bats_nums = zeros(height(agg_table),1);
bats_nums(contains(string(extractBetween(agg_table.audio_path, "ProjectsData\", "\")), "4")) = 4;
bats_nums(contains(string(extractBetween(agg_table.audio_path, "ProjectsData\", "\")), "2")) = 2;
bats_nums(bats_nums == 0) = 5;
agg_table.bat_nums = bats_nums;

temp = sort([agg_table.tx_freq, agg_table.rx_freq], 2,"ascend");
agg_table.tx_freq = temp(:,1);
agg_table.rx_freq = temp(:,2);
temp = sort([agg_table.delay_points_1, agg_table.delay_points_2], 2,"ascend");
agg_table.delay_points_1 = temp(:,1);
agg_table.delay_points_2 = temp(:,2);

figure; hold on
bins = [7e4:10:8.5e4];
histogram(agg_table(agg_table.tx_freq ~= -1,:).tx_freq, bins)
histogram(agg_table(agg_table.rx_freq ~= -1,:).rx_freq, bins)

figure; hold on
inds = agg_table.tx_freq ~= -1 & agg_table.rx_freq ~= -1;
scatter(agg_table(inds,:).tx_freq, agg_table(inds,:).rx_freq, '.')

fprintf("num valid tags %i \n", sum(inds))
fprintf("num tags with diff rx tx %i \n", sum(abs(agg_table(inds,:).rx_freq-agg_table(inds,:).tx_freq) >= 200) )


config = GetConfig;
agg_table.times = [agg_table.times_1,agg_table.times_2];
agg_table.num_peaks = 2*ones(height(agg_table));
agg_table.tx_freq_from_filtered_tx_fft = agg_table.tx_freq;

%%
for ith = 1:height(agg_table)
SingleWavTagging(agg_table.audio_path{ith}, agg_table(ith,:), config)
close
end
agg_table(19,:)
