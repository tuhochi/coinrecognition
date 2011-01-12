function [ featureVeuclid featureVsvm kreisCoeff] = buildFeatureVector(imgGray, maxDim, svmDim )
%BUILDFEATUREVECTOR Summary of this function goes here
%   Detailed explanation goes here

%Transformation in Polar-Koordinaten
imgPolar=imgCartToLogpolar(imgGray);

% Polartransformiete Bilder muessen noch zugeschnitten werden (y-Achse)
d=round((size(imgPolar,1)-(size(imgPolar,1)/sqrt(2)))/4  *1.2);% Abstand auf der Y Achse (unten und oben)// +20%
imgPolar=imgPolar(d:end-2*d,:);

%DFT-Koeffiziente
coeff=calcCoeff(imgPolar,maxDim+1);


%k-Kreise berechnen
maxR = size(imgPolar,1);
K=15; %Anzahl der Kreise
featureVeuclid=[];
featureVsvm=[];
kreisCoeff=[];
for i=1:K
    %Kreisradien
    k(i,:)=int16([(i-1)/K*maxR+1 i/K*maxR]);
    %Koeffizienten pro Kreis
    %kCoeff=coeff(k(i,1):k(i,2),2:end);
    
    %Nur Realanteil der Koeffizienten
    kCoeff=abs(coeff(k(i,1):k(i,2),2:end));
    
    if size(kCoeff,1)==1
        i;
    end
    %Mittelwert und Standardabweichung
    m=mean(kCoeff,1);
    v=var(kCoeff,1);
    %Summe
    s=sum(kCoeff,1);
    featureVeuclid=[featureVeuclid m v];
    featureVsvm=[featureVsvm m(:,1:svmDim) v(:,1:svmDim)];
    kreisCoeff=[kreisCoeff; m];
    
    
end


end

