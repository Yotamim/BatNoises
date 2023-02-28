function peak_detectors_config = GetPickDetectorsConfig()

peak_detectors_config.min_peak_height_initial_dop = 0.075;
peak_detectors_config.min_peak_height_secondary_dop= 0.015;
peak_detectors_config.min_peaks_freq_dist_secondary_dop = 1500;
peak_detectors_config.min_peaks_prominance_secondary_dop = 0.05;
end