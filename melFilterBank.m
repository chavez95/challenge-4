function H=melFilterBank(m,k,mel,fs)
h2m = @(hz)(1127*log(1+hz/700));
m2h = @(mel)(700*exp(mel/1127)-700);
% k is 0 < k < 257
% f is MEL[]
% m is position MEL(m)
c_f = m2h(h2m(0)+[0:m+1]*((h2m(fs/2)-h2m(0))/(m+1)));

H = zeros(m, k);
for i = 2:m+1
%     K = mel >= c_f(i) & mel <= c_f(i+1);
%     H(i,K) = (mel(K)-c_f(i))/(c_f(i+1)-c_f(i));
%     K = mel >= c_f(i+1) & mel <= c_f(i+2);
%     H(i,K) = (c_f(i+2)-mel(K))/(c_f(i+2)-c_f(i+1));
    for j = 1:k
        if j<mel(i-1)
            H(i,j) = 0;
        elseif (j>=mel(i-1)&&j<=mel(i))
            H(i,j) = (j-mel(i-1))/(mel(i)-mel(i-1));
        elseif (j>=mel(i+1)&&j<=mel(i))
            H(i,j) = (mel(i+1)-j)/(mel(i+1)-mel(i));
        elseif j>mel(i+1)
            H(i,j) = 0;
        end
    end
end