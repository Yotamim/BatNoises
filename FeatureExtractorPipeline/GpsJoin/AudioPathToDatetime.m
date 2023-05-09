function audio_date = AudioPathToDatetime(audio_path)
if contains(audio_path, "U_U")
    split_audio = split(audio_path, "\");
    split_audio = split(split_audio{end}, "U");
    au_start = split_audio{end-1};
    au_start(end) = [];
    if contains(au_start, ".")
        au_start = replace(au_start, ".", "_");
    end
    if length(au_start) == 20 & au_start(17) == "_" & au_start(15) == "_"
        au_start = au_start(1:15)+"0"+au_start(16:20);
    end
    audio_date = datetime(au_start, InputFormat="yy_MM_dd_HH_mm_ss_SSS");
else
    split_audio = split(audio_path, "_");
    au_start = split_audio{end-2};
    audio_date = datetime(au_start, InputFormat="ddMMyyHHmmssSSS");
end
end