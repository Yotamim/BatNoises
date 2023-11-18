function all_gps_data  = LoadGpsData(bat_num_str)
base_gps_data = "C:\Users\yotam\Desktop\ProjectsData\gps_data\";
all_gps_matfiles = dir(base_gps_data);
all_gps_data = [];
for i = 3:length(all_gps_matfiles)
    if ~contains(all_gps_matfiles(i).name, "180"+bat_num_str)
        continue
    end
    cur_gps_data = load(base_gps_data + all_gps_matfiles(i).name);
    cur_gps_data = cur_gps_data.data;
    gps_table = cur_gps_data.track;
    
    all_gps_data = [all_gps_data;gps_table];
end

string_arr = load(base_gps_data+"bat_"+bat_num_str+"_txt");
string_arr = string_arr.("bat_"+bat_num_str+"_txt");
string_arr = split(string_arr," ");
string_arr(:,3) = string_arr(:,2);
string_arr(:,[1,2]) = split(string_arr(:,1), "-");
types_of_movements = cell(height(all_gps_data),1);
for ith_line = 1:size(string_arr,1)
    line = string_arr(ith_line,:);
    edge_1 = str2num(line(1));
    edge_2 = str2num(line(2));
    for j = min(edge_1,edge_2):max(edge_1,edge_2)
        try
            types_of_movements{j} = line(3);
        catch
            continue
        end
    end
end
all_gps_data.movement_type = types_of_movements;
end