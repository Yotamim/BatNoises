function [xy_corr, pval] = Hist2dAsImage(x_data, y_data, nbins, min_color, percent_used_data)
[X,im_axis_cell] = hist3([x_data, y_data], "nbins", nbins, 'CdataMode','auto', "edgecolor", "None");
imagesc(im_axis_cell{1}, im_axis_cell{2}, X.', [min_color,max(X(:))])
set(gca, "YDir", "normal")
colormap jet
[xy_corr, pval] = corr(x_data, y_data);
end