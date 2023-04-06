function bat_config = GetBatConfig()
bat_config.bat_pulse_freq = 80000; %hz
bat_config.rel_speed_of_bat = 20; %m/s
bat_config.bat_dynamic_range = [-20*1e3, 20*1e3]; %hz
bat_config.chirp_range = 15000;
end



