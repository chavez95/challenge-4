    

    currtestFolder = ['audio0/'; 'audio1/' ;'audio2/'; 'audio3/'; 'audio4/'; 'audio5/' ;'audio6/' ;'audio7/' ;'audio8/'; 'audio9/']; % change between training set and testing set
    speaker = ['jack';'nico';'theo'];
    
  
    trainMFCC = cell(30,2);
    for i = 1:30
        trainMFCC{i,2} = mod(i-1,10);
    end

    for k = 1:3
    for j = 1:10
    alltestFolder = [currtestFolder(j,:) speaker(k,:)];
    testFiles=dir(fullfile(alltestFolder,'*.wav'));
    numFiles=length(testFiles);
    [x,fs]=audioread(fullfile(alltestFolder,testFiles(1).name));
    mfccSum = mfccFunc(x,fs);
    for i=2:6 %  number of files used to create training set
        [x,fs]=audioread(fullfile(alltestFolder,testFiles(i).name));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        mffcTBAdd = mfccFunc(x,fs);
        %{
        if size(mffcTBAdd,2) < size(mfccSum,2)
            incBy = size(mfccSum,2) - size(mffcTBAdd,2);
            mffcTBAdd = [mffcTBAdd zeros(12,incBy)];
        end
        
        if size(mfccSum,2) < size(mffcTBAdd,2)
            incBy = size(mffcTBAdd,2) - size(mfccSum,2);
            mfccSum = [mfccSum zeros(12,incBy)];
        end
        %}
        mfccSum = mfccSum + mffcTBAdd;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    
    mfccSum = mfccSum /6;
    trainMFCC{j+((k-1)*10),1} = mfccSum; %(1:12,1:17);
    end
    end
    save('trainMFCC.mat', 'trainMFCC');
    