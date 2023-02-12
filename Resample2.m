function resig = Resample2(sig,upsample,downsample)
if upsample*downsample<2^31
    resig = resample(sig,upsample,downsample);
else
    
    sig1half=sig(1:floor(length(sig)/2));
    sig2half=sig(floor(length(sig)/2):end);
    resig1half=Resample2(sig1half,floor(upsample/2),length(sig1half));
    resig2half=Resample2(sig2half,upsample-floor(upsample/2),length(sig2half));
    resig=[resig1half;resig2half];

end