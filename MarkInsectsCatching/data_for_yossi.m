xlsx_path = "C:\Users\yotam\Documents\tag insects 4.xlsx";
tags_of_perching_hunting_4 = readtable(xlsx_path);
tags_of_perching_hunting_4 = tags_of_perching_hunting_4(sum(table2array(tags_of_perching_hunting_4(:,2:end)) == -1,2) ~= 6,:);
tags_of_perching_hunting_4 = renamevars(tags_of_perching_hunting_4, ["Var1","Var2","Var3","Var4","Var5","Var6","Var7"], ["wav_full_path", "t1i", "t1f", "t2i", "t2f", "t3i", "t3f"]);
tags_of_perching_hunting_4.bat_num = 4*ones(height(tags_of_perching_hunting_4),1);

%
xlsx_path = "C:\Users\yotam\Documents\tag insects 5.xlsx";
tags_of_perching_hunting_5 = readtable(xlsx_path);
tags_of_perching_hunting_5 = tags_of_perching_hunting_5(sum(table2array(tags_of_perching_hunting_5(:,2:end)) == -1,2) ~= 6,:);
tags_of_perching_hunting_5.Var6 = -1*ones(height(tags_of_perching_hunting_5),1);
tags_of_perching_hunting_5.Var7 = -1*ones(height(tags_of_perching_hunting_5),1);
tags_of_perching_hunting_5 = renamevars(tags_of_perching_hunting_5, ["Var1","Var2","Var3","Var4","Var5","Var6","Var7"], ["wav_full_path", "t1i", "t1f", "t2i", "t2f", "t3i", "t3f"]);
tags_of_perching_hunting_5.bat_num = 5*ones(height(tags_of_perching_hunting_5),1);

%
tags_of_perching_hunting = [tags_of_perching_hunting_5; tags_of_perching_hunting_4];
drop_inds = tags_of_perching_hunting.t1i == -1 & tags_of_perching_hunting.t1f == -1 & ...
tags_of_perching_hunting.t2i == -1 & tags_of_perching_hunting.t2f == -1 & ...
tags_of_perching_hunting.t3i == -1 & tags_of_perching_hunting.t3f == -1;
tags_of_perching_hunting = tags_of_perching_hunting(~drop_inds, :);

writetable(tags_of_perching_hunting, "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\MarkInsectsCatching\perching_hunting.xlsx")

