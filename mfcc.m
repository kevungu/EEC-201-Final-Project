
%Inputs are the wave samples with their sampling frequencies.
%Output is the MFCC matrix of the sound. 
%The Matrix is 20*N, 20 is the number of coefficients, N is the number of
%frames.
function r=mfcc(s,Fs)

N=256;         %length of frame
M=100;   %overlapping 100 samples
nbframe=floor((length(s')-N)/M)+1;   %number of windows

h=hamming(N);

%Create a matrix to place the framed signals.
%Each column are the samples in a frame.

for i= 1 : N
    for j=1:nbframe
        S1(i,j)=s(((j-1)*M)+i);   
    end
end

% Adding hamming window
S2=diag(h)*S1;

%Now we start adding fast fourier transform
for i=1:nbframe
    S3(:,i)=fft(S2(:,i));
end

m=melfb(20,N,Fs);   %  Computing the Mel-scale spectrum
n2 = 1 + floor(N/2);
z = m * abs(S3(1:n2,:)).^2;
r=dct(log(z));   %MFCC
end