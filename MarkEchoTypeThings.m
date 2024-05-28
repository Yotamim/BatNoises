function marks = MarkEchoTypeThings(X,n_window,jth_features_comb)
vecc = 0:3:(n_window-2)*3;
echos = X(:,1+vecc);
times = X(:,2+vecc)-X(:,3+vecc);

figure; plot(times(:,1), echos(:,1), ".-")

end