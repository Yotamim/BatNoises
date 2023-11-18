tag_path = "C:\Users\yotam\Desktop\TagKatarinaFromat\katerina_tags\";
tag_table = LoadAllTagData(tag_path);
spec_and_fft_folder = "C:\Users\yotam\Desktop\ProjectsData\spec_and_ffts";
all_specs_and_ffts_paths = dir(spec_and_fft_folder);

all_audio_paths = tag_table.audio_path;
audio_names = cellfun(@(x) x{end},cellfun(@(x) split(x, "\"),all_audio_paths, UniformOutput=false), UniformOutput=false);
audio_keys = replace(audio_names, ".wav", "");
audio_keys = audio_keys + "__"+num2str(fix(tag_table.times(:,1)*1e4)/1e4)+"__"+num2str(fix(tag_table.times(:,2)*1e4)/1e4)+".mat";
audio_keys = replace(audio_keys, " ", "");


for i = 1:length(audio_keys)
    load(fullfile(spec_and_fft_folder,audio_keys(i)))
    EchoDetector(new_row, tag_table(i,:))
    close
end

