clear; close all
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
load(base_res_path + "agg_res_table.mat")

bat_nums = [2,4,5];
color_vecs = jet(4);

res_table_2_peak = res_table(res_table.num_peaks == 2,:);
res_table_1_peak = res_table(res_table.num_peaks == 1,:);

strings_mvment = res_table_2_peak.movement_type;
strings_mvment = replace(string(strings_mvment),"fields", "field");
strings_mvment = replace(string(strings_mvment),"trees", "woods");
res_table_2_peak.movement_type = strings_mvment;

strings_mvment = res_table_1_peak.movement_type;
strings_mvment = replace(string(strings_mvment),"fields", "field");
strings_mvment = replace(string(strings_mvment),"trees", "woods");
res_table_1_peak.movement_type = strings_mvment;

unq_movments = unique(strings_mvment);

bin_edges = 6.5e4:100:8.5e4;
close all
for ith_bat = bat_nums
    axes = [];
    figure;
    subplot(1,2,1)
    lines = [];
    for ith_type = 1:length(unq_movments)
        lines = [lines; histogram(res_table_2_peak(string(res_table_2_peak.movement_type) == unq_movments(ith_type)...
            & res_table_2_peak.bat_num == ith_bat,:).tx_freq_from_filtered_tx_fft,...
            bin_edges,"Normalization","probability", "FaceColor",color_vecs(ith_type,:))];
        hold on
    end
    title("2 peaks")
    lgd = legend(unq_movments);
    lgd.ItemHitFcn = @hitcallback_ex1;

    subplot(1,2,2)
    lines = [];
    for ith_type = 1:length(unq_movments)
        lines = [lines; histogram(res_table_1_peak(string(res_table_1_peak.movement_type) == unq_movments(ith_type)...
            & res_table_1_peak.bat_num == ith_bat,:).raw_tx, ...
            bin_edges,"Normalization","probability", "FaceColor",color_vecs(ith_type,:))];
        hold on
    end
    title("1 peaks")
    lgd = legend(unq_movments);
    lgd.ItemHitFcn = @hitcallback_ex1;

    sgtitle("bat"+ith_bat+" tx freq")
end

% Click function callback
function hitcallback_ex1(src,evnt)

if strcmp(evnt.Peer.Visible,'on')
    evnt.Peer.Visible = 'off';
else
    evnt.Peer.Visible = 'on';
end

end
