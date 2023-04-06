function [closest_gps_time,speed,ind] = JoinGpsData2TxTime(start_time_of_audio, tx_time, gps_data)

tx_days_from_jesus = start_time_of_audio+tx_time/3600/24;
[~ ,ind] = min(abs(gps_data.time - tx_days_from_jesus));
closest_gps_time = gps_data.time(ind);
diff_from_closest = closest_gps_time-tx_days_from_jesus;
if diff_from_closest < 0 
    second_closest_ind = ind+1;
elseif diff_from_closest > 0 
    second_closest_ind = ind-1;
else
    second_closest_ind = ind;
end
speed = (gps_data.speed(ind)+gps_data.speed(second_closest_ind))/2;
% gps_data.speed(ind)
% gps_data.speed(second_closest_ind)

% speed = gps_data.speed(ind)+(gps_data.speed(second_closest_ind)-gps_data.speed(ind))*(tx_days_from_jesus-gps_data.time(ind))/(gps_data.time(second_closest_ind)-gps_data.time(ind));




end