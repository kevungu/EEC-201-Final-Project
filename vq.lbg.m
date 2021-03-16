function y=vqlbg(coeff,k)  %coeff is MFCC
%In this function, the output y is a codebook of size k.
%Y is a 20*k matrix, the k columns is a k-vector codebook
e=0.01;   %spliting parameter
%get the initial single-vector codebook by calculating the mean
y=mean(coeff,2);   
dis_ini=10000;   %Distortion We choose 10000 as the initial distortion
%Iterating a codebook size of K
for i= 1:log2(k)
    y=[y*(1+e),y*(1-e)];   %split y into y+ and y-
    while (1)   %Starting iteration
        %Get the distance between initial codebook and MFCC in samples
        d=disteu(coeff,y);  
        %Find whether each sample is closer to y+ or y-
        %ind indicates it
        [mindis,ind]=min(d,[],2);
        dis=0;  %prepare to calculate the distortion
        for j=1:2^i
            %Choose the samples that is closer to y+(then to y-)
            %Calculate the average value as the new centroid
            y(:,j)=mean(coeff(:,find(ind==j)),2);
            %Get the distance between new codebook and the samplers closer
            %to y+(then to y-)
            d_new=disteu(coeff(:,find(ind==j)),y(:,j));
            %add the distance together to calculate the distortion
            for p=1:length(d_new)
                dis=dis+d_new(p);
            end
            %Since there is a for loop, we will add distortion of
            %y+and distortion of y_  together
        end
        %check if the distortion is small enough
        if ((dis-dis_ini)/dis_ini)<e
            break;
        else
            dis_ini=dis;
        end
    end
end
