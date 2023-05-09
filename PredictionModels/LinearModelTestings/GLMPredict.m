function [pred_vals, coef_table,bic_val, mdl] =  GLMPredict(X_data,y, model_string)
if nargin<3
    model_string = "linear";
end
mdl = fitglm(X_data, y, model_string);
coef_table = mdl.Coefficients;
pred_vals = y-mdl.Residuals.Raw;
bic_val = mdl.ModelCriterion.BIC;

end