function SaveSingleAudioRes(git_info, res_cell_per_audio, base_res_path)

if ~isfolder(base_res_path+string(datetime("today")))
    mkdir(base_res_path+string(datetime("today")))
end

if ~isequal(exist(base_res_path+string(datetime("today"))+ "\git_info.m",'file'),2) 
   save(base_res_path+string(datetime("today"))+ "\git_info.m","git_info")
end

audio_string = res_cell_per_audio{1,4};
split_string = split(audio_string, "\");
audio_folder = split_string{7};

if ~isfolder(base_res_path+string(datetime("today"))+"\"+audio_folder)
    mkdir(base_res_path+string(datetime("today"))+"\"+audio_folder)
end

audio_name = split_string{8}(1:end-4);
save(base_res_path+string(datetime("today"))+"\"+audio_folder+"\"+audio_name ,"res_cell_per_audio")

end