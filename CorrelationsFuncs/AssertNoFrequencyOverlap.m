function [echo_freq_range, tx_freq_range, assertion_res] = AssertNoFrequencyOverlap(filt1, filt2,tx_freq_range, echo_freq_range)
assertion_res = false;
if filt1.FrequencyResponse == "bandpass"
    filter_echo = [filt1.StopbandFrequency1,filt1.StopbandFrequency2];
else
    filter_echo = [filt1.StopbandFrequency];
end 
filter_tx = [filt2.StopbandFrequency1,filt2.StopbandFrequency2];

if filter_tx(2) >= filter_echo(1)
    assertion_res = true;
    overlap_in_freq = filter_tx(2)-filter_echo(1);
    tx_freq_range(2) = tx_freq_range(2)-overlap_in_freq/2;
    echo_freq_range(1) = echo_freq_range(1)+overlap_in_freq/2;
end

end