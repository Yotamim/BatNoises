base_tags_dir = "C:\Users\yotam\Desktop\ProjectsData\tags\katerina_tags\";
ls_dir = string(ls(base_tags_dir));
ls_dir = ls_dir(contains(ls_dir, "wetrans"));
ls_dir = replace(ls_dir, " ", "");
all_dirs = base_tags_dir + ls_dir;
agg_table = [];
for ith_dir = 1:length(all_dirs)
    ith_dir_files = string(ls(all_dirs(ith_dir)));
    ith_dir_files = ith_dir_files(3:end);
    for ith_file = 1:length(ith_dir_files)
        disp(ith_file)
        load(fullfile(all_dirs(ith_dir), ith_dir_files(ith_file)))
        t = ParseSingleTagFile(ud_struct);
        agg_table = [agg_table; t];
    end
end

%%
base_tags_dir = "C:\Users\yotam\Desktop\OldthingsForBats\TagKatarinaFromat\katerina_tags";
ls_dir = string(ls(base_tags_dir));
all_files = fullfile(base_tags_dir,ls_dir(3:end));
agg_table = [];
for ith_file = 1:length(all_files)
    disp(ith_file)
    load(all_files(ith_file))
    t = ParseSingleTagFile(ud_struct);
    agg_table = [agg_table; t];
end
% writetable(agg_table, fullfile(base_tags_dir, "agg_tags.csv"))



