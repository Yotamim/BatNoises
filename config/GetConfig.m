function config = GetConfig()

config.spec_config = GetSpecConfiguration;
config.phys_config = GetPhysicalConfig;
config.bat_config = GetBatConfig;
config.plot_config = GetPlotConfig;
config.peak_detectors_config = GetPickDetectorsConfig;
config.other_config.min_duration_from_histogram = 0.045; %sec
config.other_config.max_duration_from_histogram = 0.1; %sec
end