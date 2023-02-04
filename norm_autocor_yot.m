function xcor_vec = norm_autocor_yot(data,L)
data_L_normed = data(1:L)/vecnorm(data(1:L));

xcor_vec = zeros(length(data)-L,1);
cumsum_vec = [0;cumsum(abs(data))];
for i = 1:length(xcor_vec)
    xcor_vec(i) = data_L_normed'*data(i:i+L-1)/(cumsum_vec(i+L)-cumsum_vec(i));
end

end
