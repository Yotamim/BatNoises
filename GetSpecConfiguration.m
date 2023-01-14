function spec_config = GetSpecConfiguration()

spec_config.window = hann(256);
spec_config.overlap = 0;
spec_config.freq_range = "onesided";
spec_config.fft_length = 2048;
end