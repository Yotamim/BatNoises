function inds_proper_gps = GetValidIndsForModelFromGPS(res_table_2_peaks)
inds_proper_gps = abs(res_table_2_peaks.diff_from_closest_gps) < 10;
end