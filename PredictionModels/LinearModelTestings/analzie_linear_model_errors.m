clear; close all
analyzie_aggregate_results
load("C:\Users\yotam\Desktop\figs\"+"models_res.mat")
base_res_path = "C:\Users\yotam\Desktop\MatlabProjects\BatNoises\results\08-Apr-2023\";
% load(base_res_path + "agg_res_table.mat")
figure;
for i = [2,4,5]
    c_model = best_bic_per_bat(best_bic_per_bat.bat_num == i,:);
    X_mat = c_model.X{1};
    X_features = string(c_model.features{1});
    X_features = X_features(~contains(X_features,"bias"));
    X_table = array2table(X_mat,'VariableNames',X_features);
    y = c_model.y{1};

    [pred_vals, ~,~] =  GLMPredict(X_mat,y);
    err = y-pred_vals;
    tind = abs(err)>500;
    nexttile()
    [xy_corr, pval] = Hist2dAsImage(y-mean(y), err, [200,200], 1, 1);
    title("bat: "+num2str(i)+sprintf("corr: %.2f", xy_corr))
    %     figure;
%     for j = 1:length(X_features)
%         jth_feature = X_features(j);
%         nexttile()
%         title("feature: "+replace(jth_feature, "_", " ")+" corr: "+num2str(xy_corr))
%     end
end

[pred_vals, coef_table,bic_val] = GLMPredict(err, y-mean(y));
mdl = fitglm(err, y-mean(y));
xx = [-500:1:500];
yy = xx*mdl.Coefficients.Estimate(2)+mdl.Coefficients.Estimate(2);
figure;
plot(err,y-mean(y) , "."); hold on;
plot(xx,yy);
figure;
[xy_corr, pval] = Hist2dAsImage(err,y-mean(y), [200,200], 1, 1);





pred_vals-err
b5 = models_tables(models_tables.bat_num == 5,:);

figure;
plot(y, "."); hold on;
plot(pred_vals, "."); hold on;
title("bat"+i)
xlabel("actual tx")
ylabel("pred tx")


figure;
plot(y, abs(y-pred_vals), ".")
figure;
title("bat"+i)