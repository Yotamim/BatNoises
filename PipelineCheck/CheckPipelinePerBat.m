function CheckPipelinePerBat(bat_res_table, config)

unique_audios = unique(bat_res_table.audio_path);
for unqa = 1:length(unique_audios)
    cur_audio_ind = randi(length(unique_audios));
    cur_audio_path = unique_audios(cur_audio_ind);
    cur_audio_path_table = bat_res_table(bat_res_table.audio_path == cur_audio_path, :);

    PlotPipeCheckForAudio(cur_audio_path, cur_audio_path_table, config)
end
a = 1

end