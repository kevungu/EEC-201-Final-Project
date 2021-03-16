function y = voiceRec(speaker)
CB = 32;
%Initialize the training data
for i=1:speaker   %17 training files
   file=sprintf('s%d.wav',i); %Inputs training file
   [s,Fs]=audioread(file);
   v=mfcc(s,Fs); %Extract mfccs from training file
   code{i}=vqlbg(v,CB); %Compilation of trained data through vector quantization
end

%Initialize the testing data
nameList={'1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21'};
if speaker > 0
    file=sprintf('t%d.wav',speaker);
    [s,Fs]=audioread(file);
    v=mfcc(s,Fs);
    distmin=inf;  %initial distance is infinity
    k=0;
    %Matches the testing data to the trainging data
    for i=1:length(code)
        %calculate the distance between MFCC and codebook
        d=disteu(v,code{i});    
        %calculate the distortion
        dist=sum(min(d,[],2))/size(d,1);
        if dist < distmin
            distmin=dist;   %Find the smallest distortion
            k=i;
        end
    end
%Display speaker number. If the the smallest distortion is too large, there
%is no speaker found
    threshold = 6;
    if distmin < threshold
        result = nameList{k};
        y = str2double(result);
    else
        y = 0;
        result = 0;
    end
else %Return 0 if Speaker input is below 0
    y = 0;
end
end