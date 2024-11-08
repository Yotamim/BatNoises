function p_value = Brown_Forsythe(sample1, sample2)
% Levene's Test (Brown-Forsythe Test) to compare variances of two samples.
%
% Inputs:
% - sample1: A vector of data values for the first sample.
% - sample2: A vector of data values for the second sample.
%
% Output:
% - p_value: The p-value from the ANOVA on absolute deviations from the median.

    % Combine data and create group labels
    data = [sample1; sample2];
    group_labels = [ones(length(sample1), 1); 2 * ones(length(sample2), 1)]; % Labels: 1 for sample1, 2 for sample2

    % Calculate deviations from the median
    central_value1 = median(sample1);
    central_value2 = median(sample2);
    deviations = zeros(size(data));
    deviations(group_labels == 1) = abs(sample1 - central_value1);
    deviations(group_labels == 2) = abs(sample2 - central_value2);

    % Perform ANOVA on the absolute deviations
    p_value = anova1(deviations, group_labels, 'off'); % 'off' suppresses the ANOVA table output
end
