tag_path = "C:\Users\yotam\Desktop\TagKatarinaFromat\katerina_tags\";
tag_table = LoadAllTagData(tag_path);
tag_table = renamevars(tag_table, "rx_freq", "rx_freq_tagged");
tag_table = renamevars(tag_table, "tx_freq", "tx_freq_tagged");
tag_table.key = tag_table.audio_path+num2str(tag_table.times(:,1));
bat_num_col = zeros(height(tag_table),1);
bat_num_col(contains(tag_table.audio_path, "bat02")) = 2;
bat_num_col(contains(tag_table.audio_path, "bat04")) = 4;
bat_num_col(contains(tag_table.audio_path, "data")) = 5;
tag_table.bat_num = bat_num_col;
% base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
% load(base_res_path + "agg_res_table.mat")
% res_table.key = replace(res_table.audio_path, "C:\Users\yotam\Desktop\ProjectsData", "C:\Users\Sinisa\Desktop\TagCalls\bat_audios")+num2str(res_table.times(:,1));
% A= join(tag_table, res_table, "key","key");
