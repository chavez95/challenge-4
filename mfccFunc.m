function mfcCoef = mfccFunc(x, fs)

%[x,fs] = audioread('recordings/9_jackson_7.wav');

if(size(x,2) > 100)
      x = x';
end
if(size(x,2) > 1)
      x = x(:,1);% + x(:,2);
end
totalSamples = size(x,1);
%%%%%%%%%%%% lowpass filter %%%%%%%%%%%%%%%%%%%%%%
N = length(x);
f = 3400;
k = round(N*f/fs);
lowPassFilt = zeros(size(x));
lowPassFilt(1:k) = ones(k,1);
lowPassFilt((N-k+1):N) = ones(k,1);
yyf = fft(x);
yy_lpf = yyf .* lowPassFilt;
yy_lp = real(ifft(yy_lpf));
x = yy_lp;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Alpha = 0.97;    % may change for optimatiztion 
y = zeros(totalSamples,1);
y(1) = x(1);

%preemphasis

for i = 2:totalSamples
    y(i) = x(i) - Alpha * x(i-1);
end
%}

frameSize = 0.03; % 25ms may change if necessary
blockSize = ceil(frameSize * fs);
hopSize = ceil(0.02 * fs); % 10ms
nfft = 2^nextpow2(blockSize);
K = nfft/2+1;

numOfBlocks = floor((totalSamples-blockSize)/hopSize);
frames = zeros(numOfBlocks,nfft);
zeroPad = nfft - mod(totalSamples,nfft); % how many samples need total samples
% a factor of blockSize
y = [y' zeros(1, zeroPad)]';    % pad signal with zeroPad

% framing 
for i = 1:numOfBlocks
    i_start = ((i-1)*hopSize) + 1;
    i_stop = i_start + nfft -1;
    frames(i,:) = y(i_start:i_stop);
end


win = hamming(nfft);
X = zeros(numOfBlocks, nfft);
MAG_x = zeros(numOfBlocks, nfft);
%X = zeros(numOfBlocks,512); % not sure if this is right 
%P = zeros(numOfBlocks,512); 

% windowing & fft
for i = 1:numOfBlocks
    %frames(i,:) = (win .* frames(i,:)')';
    temp =  frames(i,:) .* win';
    X(i,:) = fft(temp,nfft);
    MAG_x(i,:) = abs(X(i,:));
    %P(i,:) = (X(i,:) .* X(i,:))/blockSize;
end
MAG_x = MAG_x';

% mel scale
lowerFreq = 0;
upperFreq = fs/2;   
numOfFilters = 18;
N = 6;

melLow = 1127*log(1 + (lowerFreq/700));
melHigh = 1127*log(1 + (upperFreq/700));

MEL = linspace(melLow, melHigh, numOfFilters+2);
%MEL = linspace(lowerFreq, upperFreq, numOfFilters + 2);
%MEL = 1127*log(1 + (MEL/700));

MELINV = 700 * (exp(MEL/1127) - 1);
MELINV = floor((nfft+1)*MELINV/fs);

H = melFilterBank(numOfFilters, K, MELINV, fs);
MAG_x = MAG_x.^2./nfft;
FBE = log(H*MAG_x(1:K,:));
% computing DCT for first 12 filters

dctMatrix = zeros(N,numOfBlocks);
for i = 1:N
    dctMatrix(i,:) = cos((i-1)*(0:(numOfBlocks-1))/(numOfBlocks-1)*pi) * 2 / (2*(numOfBlocks-1));
end

mfcCoef = dctMatrix * FBE(2:end,:)';
end