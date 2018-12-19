function closestmatch = runTest(x,fs)
% x - signal of uknown digit
% fs - sampling rate

load trainMFCC.mat trainMFCC
ukwnMffc = mfccFunc(x,fs);
numOfRefereces = size(trainMFCC,1);
numOfCoef = size(ukwnMffc,1);
distMat = zeros(numOfRefereces,1);

for i = 1:numOfRefereces
    tempRef = trainMFCC{i,1};
    totalDist = 0;
    for j = 1:numOfCoef
        dist = dtwTwoDigits(ukwnMffc(j,:)',tempRef(j,:)');
        totalDist = totalDist + dist;
    end
    %disp([' total distance ',num2str(totalDist),' iteration ', num2str(i), ...
    %   ' guess ', num2str(floor((i-0.1)/4)) ])
   distMat(i,1) = totalDist;

end
    % find smallest distance
     [m,i] = min(distMat);
     closestmatch =  trainMFCC{i,2};
     %disp(['digit is ',num2str(closestmatch)]);
end

