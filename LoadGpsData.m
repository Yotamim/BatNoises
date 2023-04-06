function all_gps_data  = LoadGpsData()
base_gps_data = "C:\Users\yotam\Desktop\ProjectsData\gps_data\";
all_gps_matfiles = dir(base_gps_data);
all_gps_data = [];
for i = 3:length(all_gps_matfiles)
    if ~contains(all_gps_matfiles(i).name, "1805")
        continue
    end
    cur_gps_data = load(base_gps_data + all_gps_matfiles(i).name);
    cur_gps_data = cur_gps_data.data;
    gps_table = cur_gps_data.track;
    
%     disp(gps_table.time(1)*3600*24 - ...
%         etime(datevec(datetime(cur_gps_data.timeStart)), datevec(datetime("31-Dec--1 00:00:00"))) )
    all_gps_data = [all_gps_data;gps_table];
end
end