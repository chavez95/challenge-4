function distance = dtwTwoDigits(A,B)
% calculates minimum distance to convert unknown digit to know digit 

if(size(A,1) < 1 || size(A,2) < 1)
    distance = 1000000;
    return
end
if(size(B,1) < 1 || size(B,2) < 1)
    distance = 1000000;
    return
end
m = size(A,1);
n = size(B,1);
distMatrix = zeros(m,n);

% these calculation must be done first because the distance calculations
% inside the matrix depend on them. 

% calculating the distance for the first in distance matrix
distMatrix(1,1) = abs(A(1) - B(1));

% calculating distance for first column 
for i = 2:m
    distMatrix(i,1) = abs(A(i) - B(1)) + distMatrix(i-1,1);
end

% calculating distance for first row
for i = 2:n
    distMatrix(1,i) = abs(A(1) - B(i)) + distMatrix(1,i-1);
end


% calculating distance for the inner elements of the distance matrix.
for i = 2:m
    for j = 2:n
        distMatrix(i,j) = abs(A(i) - B(j)) +  min([distMatrix(i-1,j-1),distMatrix(i-1,j),distMatrix(i,j-1)]);
    end
end

% time to calculate minimum distance

distance = distMatrix(m,n);
i = m;
j = n;

while ~(i == 1)  && ~(j == 1)
    
    [MIN,I] = min([distMatrix(i-1,j-1),distMatrix(i-1,j),distMatrix(i,j-1)]);
    if I == 1
        i = i -1;
        j = j- 1;
        distance = distance + MIN;
    elseif I == 2
        i = i -1;
        distance = distance + MIN;
    elseif I == 3
        j = j- 1;
        distance = distance + MIN;
    end   
end

if i ~= 1
    distance = distance + sum(distMatrix(i:-1:1,1));
elseif j ~= 1
    distance = distance + sum(distMatrix(1,j:-1:1));
end


end

