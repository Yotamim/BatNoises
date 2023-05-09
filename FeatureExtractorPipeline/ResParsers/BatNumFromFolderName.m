function bat_num = BatNumFromFolderName(fold_name)
if contains(fold_name, "bat")
    bat_num = split(fold_name, "bat");
    bat_num = str2num(bat_num{2});

else
    bat_num = 5;
end
end
