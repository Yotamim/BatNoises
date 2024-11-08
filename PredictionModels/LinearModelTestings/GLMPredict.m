function [pred_vals, coef_table,bic_val, mdl] =  GLMPredict(X_table, pred_name)
y_ind = strcmp(X_table.Properties.VariableNames,pred_name);
x_ind = ~strcmp(X_table.Properties.VariableNames,pred_name) & ~contains(X_table.Properties.VariableNames,"movement");
X_array = str2double(X_table(:,x_ind).Variables);
y_array = str2double(X_table(:,y_ind).Variables);
var_names = [X_table.Properties.VariableNames(x_ind), X_table.Properties.VariableNames(y_ind)];
X_array = (X_array-mean(X_array,1))./std(X_array,1);
mdl = fitglm(X_array, y_array, "linear", "VarNames", var_names, "Intercept", true);
coef_table = mdl.Coefficients;
pred_vals = mdl.Fitted.Response;
bic_val = mdl.ModelCriterion.BIC;

end