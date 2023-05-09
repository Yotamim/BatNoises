function [first_inds_of_continuum, second_ind_of_continuum] = GetContinuesInds(times)

inds_of_end_of_wavs = find(diff(times)<0);
inds_of_end_of_wavs = [inds_of_end_of_wavs; length(times)];
cur_start_wav = 1;
first_inds_of_continuum = [];
second_ind_of_continuum = [];
for i = 1:length(inds_of_end_of_wavs)
    cur_end_wav = inds_of_end_of_wavs(i);
    cur_wavfile_times = times(cur_start_wav:cur_end_wav);
    first_inds_of_continuum = [first_inds_of_continuum; diff(cur_wavfile_times)<0.3; false];
    second_ind_of_continuum = [second_ind_of_continuum; false; diff(cur_wavfile_times)<0.3];
    cur_start_wav = cur_end_wav+1;
end
first_inds_of_continuum = logical(first_inds_of_continuum);
second_ind_of_continuum = logical(second_ind_of_continuum);
end
