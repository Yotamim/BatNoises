function doppler_vec = PlotDopplerFromSpec(data, fs, config)
figure; subplot(2,3,1)
plot(abs(fftshift(fft(data))))
title("fft")

subplot(2,3,2)
[spec,freq,time] = stft(data,fs,Window=hann(128), FrequencyRange="centered", OverlapLength=0);
tresh = prctile(abs(spec(:)),0);
plot(freq,sum(abs(abs(spec.*(abs(spec)>=tresh))),2));
title("spec 128 prc 0")

subplot(2,3,3)
[spec,freq,time] = stft(data,fs,Window=hann(128), FrequencyRange="centered", OverlapLength=0);
tresh = prctile(abs(spec(:)),50);
plot(freq,sum(abs(abs(spec.*(abs(spec)>=tresh))),2));
title("spec 128 prc 50")

subplot(2,3,4)
[spec,freq,time] = stft(data,fs,Window=hann(128), FrequencyRange="centered", OverlapLength=0);
tresh = prctile(abs(spec(:)),92);
plot(freq,sum(abs(abs(spec.*(abs(spec)>=tresh))),2));
title("spec 128 prc 92")

subplot(2,3,5)
[spec,freq,time] = stft(data,fs,Window=hann(128), FrequencyRange="centered", OverlapLength=0);
tresh = prctile(abs(spec(:)),94);
plot(freq,sum(abs(abs(spec.*(abs(spec)>=tresh))),2));
title("spec 128 prc 94")

subplot(2,3,6)
[spec,freq,time] = stft(data,fs,Window=hann(128), FrequencyRange="centered", OverlapLength=0);
tresh = prctile(abs(spec(:)),97);
plot(freq,sum(abs(abs(spec.*(abs(spec)>=tresh))),2));
title("spec 128 prc 97")

set(gcf, "Position", 1.0e+03 *[0.0010    0.0490    1.5360    0.7408])

end