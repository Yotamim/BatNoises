function Hist2dAsImage(x_data, y_data, nbins, min_color, percent_used_data)
figure;
[X,im_axis_cell] = hist3([x_data, y_data], "nbins", nbins, 'CdataMode','auto', "edgecolor", "None");
imagesc(im_axis_cell{1}, im_axis_cell{2}, X.', [min_color,max(X(:))])
set(gca, "YDir", "normal")
colormap jet
[xy_corr, pval] = corr(x_data, y_data);
title(sprintf("corr = %.2f  pval= %.2e \n percent used data = %.2f", xy_corr, pval, percent_used_data))
end