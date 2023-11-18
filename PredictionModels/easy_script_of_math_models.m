target = X_table.("desired_rx_freq-1");
t1 = X_table.("tx_freq_from_filtered_tx_fft-1");
v1 = X_table.("speed-1");
v0 = X_table.("speed-0");
r1 = X_table.("tx_freq_from_filtered_tx_fft-1")+X_table.("echo_doppler-1");
dop1 = r1-t1;
alpha1 = r1./t1;
beta1 = dop1./t1;
% 
% t2 = X_table.("tx_freq_from_filtered_tx_fft-2");
% v2 = X_table.("speed-2");
% r2 = X_table.("tx_freq_from_filtered_tx_fft-2")+X_table.("echo_doppler-2");
% dop2 = r2-t2;
% alpha2 = r2./t2;
% beta2 = dop2./t2;

figure; scatter(target./alpha1-t1, X_table.("tx_freq_diff"), ".")
figure; Hist2dAsImage(target./alpha1-t1, X_table.("tx_freq_diff"), [80,80],1,1)

figure; scatter(target./(1+(v0/v1)*beta1)-t1, X_table.("tx_freq")-t1, ".")
figure; Hist2dAsImage(target./(1+(v0./v1).*beta1)-t1, X_table.("tx_freq")-t1, [80,80],1,1)

dt01 = -t1+target.*t1.*v1./v0./r1;
dt12 = -t2+target.*t2.*v2./v1./r2;

figure; scatter(beta1, r1-t1, ".")

X_table.beta1 = beta1;
X_table.beta2 = beta2;