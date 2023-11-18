bat_nums = [2,4,5];
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")
new_res_table = [];
for ith_bat_num = bat_nums 
    bat_i_table = res_table(res_table.bat_num == ith_bat_num ,:);
    gps_table = LoadGpsData(ith_bat_num);
    gps_table_movement_type = gps_table(:,["time","movement_type"]);
    bat_i_table_with_gps = join(bat_i_table, gps_table_movement_type,"LeftKeys","closest_gps_time","RightKeys","time");
    new_res_table = vertcat(new_res_table,bat_i_table_with_gps);
end
res_table = new_res_table;
save(base_res_path + "agg_res_table.mat", "res_table")