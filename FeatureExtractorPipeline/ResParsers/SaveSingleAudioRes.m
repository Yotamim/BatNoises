function SaveSingleAudioRes(git_info, res_cell_per_audio, base_res_path)

if ~isfolder(base_res_path+string(datetime("today")))
    mkdir(base_res_path+string(datetime("today")))
end

if ~isequal(exist(base_res_path+string(datetime("today"))+ "\git_info.m",'file'),2) 
   save(base_res_path+string(datetime("today"))+ "\git_info.m","git_info")
end
cn = ColumnNames2Inds();
audio_string = res_cell_per_audio{1,cn.audio_path};
split_string = split(audio_string, "\");
audio_folder = split_string{end-1};

if ~isfolder(base_res_path+string(datetime("today"))+"\"+audio_folder)
    mkdir(base_res_path+string(datetime("today"))+"\"+audio_folder)
end

audio_name = split_string{end}(1:end-4);
audio_name = replace(audio_name,".","_");
save(base_res_path+string(datetime("today"))+"\"+audio_folder+"\"+audio_name ,"res_cell_per_audio")

end