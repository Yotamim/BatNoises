close all; clear; clc; warning off all
config = GetConfig();

base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")

movement_type = "water";
bat_num = 4;
mov_type_table = res_table(string(res_table.movement_type) == movement_type & res_table.bat_num == bat_num ,:);
unq_audios = unique(mov_type_table.audio_path);

for ith_audio = 1:length(unq_audios)
    filter_spec = MarkInsects(unq_audios(ith_audio), config);
    filter_spec1 = pow2db(abs(filter_spec));
    title(movement_type + " bat num "+ num2str(bat_num))
    close
end

