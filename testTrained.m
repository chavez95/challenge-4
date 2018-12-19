

    %load trainMFCC.mat trainedMfcc % uncomment when ready to test 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    % Wrapper for Challenge 4. This code specifies the input and output specifications
    % which he TA's use and expect for your final submissionclear 
    mynum = 9;
    alltestFolder = 'recordings/9'; % change between training set and testing set
    testFiles=dir(fullfile(alltestFolder,'*.wav'));
    numFiles=length(testFiles);
    output=cell(numFiles,2);
    trainCells = cell(numFiles,2);
    for i=1:numFiles
        [x,fs]=audioread(fullfile(alltestFolder,testFiles(i).name));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %mffcSet = mfccFunc(x,fs);
        
        %disp(testFiles(i).name);   
        class = runTest(x,fs); % comment out when training
        
        %trainCells{i,1} = mffcSet(1:12,:);  % uncomment when training. creating reference mfcc
        %trainCells{i,2} = testFiles(i).name(1);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Identify what digit what spoken through your 
        %codeclass=0;    
        % Say this is what you've found out, can lie between 0 and 9
       output(i,1)={testFiles(i).name};output(i,2)={class};
    end
   % save('trainFile.mat','trainCells'); uncomment to train
    
    outtt = output(:,2);
    outtt = cell2mat(outtt);
    outtt = outtt(outtt == mynum);