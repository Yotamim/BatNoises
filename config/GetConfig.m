function config = GetConfig()

config.spec_config = GetSpecConfiguration;
config.phys_config = GetPhysicalConfig;
config.bat_config = GetBatConfig;
config.plot_config = GetPlotConfig;
config.peak_detectors_config = GetPickDetectorsConfig;
% config.other_config.min_duration_from_histogram = 0.045; %sec
config.other_config.min_duration_from_histogram = 0.015;
config.other_config.max_duration_from_histogram = 0.1; %sec

config.mode = "tagged_data_only"; %sec
tag_path = "C:\Users\yotam\Desktop\ProjectsData\tags";
tag_table = LoadAllTagData(tag_path);
tag_table.key = tag_table.audio_path+num2str(tag_table.times(:,1));
config.tagged_data_table = tag_table;

end