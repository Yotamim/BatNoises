function agg_tag_data = LoadAllTagData(tag_path)

tagged_data_list = dir(fullfile(tag_path, "*.mat"));
empty_tag_table = EmptyTagTable();

agg_tag_data = [];
for ith_tag_row = 1:length(tagged_data_list)
    struct_row = load(fullfile(tagged_data_list(ith_tag_row).folder,tagged_data_list(ith_tag_row).name)).ud_struct;
    tag_row = ParseTaggedRow(struct_row, empty_tag_table);
    agg_tag_data = [agg_tag_data; tag_row];
end

end
