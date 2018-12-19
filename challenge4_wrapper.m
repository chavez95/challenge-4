% Wrapper for Challenge 4. This code specifies the input and output specifications
% which the TA's use and expect for your final submission
clear all

testFolder = 'audio/0';
testFiles=dir(fullfile(testFolder,'*.wav'));
numFiles=length(testFiles);

output=cell(numFiles,2);

for i=1:numFiles
    [x,fs]=audioread(fullfile(testFolder,testFiles(i).name));
    
    % Identify what digit what spoken through your code
    class= runTest(x,fs);    % Say this is what you've found out, can lie between 0 and 9
    
    
    output(i,1)={testFiles(i).name};
    output(i,2)={class};
end

