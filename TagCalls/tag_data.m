clear
warning off all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")
bat_nums = 5;
config = GetConfig;
for bat_num = bat_nums 
    TagDataPerBat(res_table(res_table.bat_num == bat_num,:), config);
end