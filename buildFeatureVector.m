function [ featureVeuclid featureVsvm kreisCoeff coeff imgPolar] = buildFeatureVector(imgGray, maxDim, svmDim )
%buildFeatureVector Fuer ein Grauwertbild werden zwei Feature-Vektoren erstellt.  
%
%   buildFeatureVector(imgGray, maxDim, svmDim)
%                       Ein Grauwertbild wird zuerst in Polar-Koordinaten
%                       umgewandelt und danach DFT-Koeffizienten
%                       berechnet. Die Anzahl der Koeffizienten werden
%                       durch die Variable maxDim angegen. Aus den
%                       berechneten Koeffizienten werden zwei
%                       Feature-Vektoren erstellt. Fuer den euklidischen
%                       Klassifikator werden alle berechneten Koeffizienten
%                       herangezogen. Fuer den SVM-Klassifikator werden
%                       weniger Koeffizienten herangezogen. Die Anzahl
%                       entspricht der Variable svmDim.
%                       Das Ausgangsbild wird in zehn Abschnitte unterteilt, 
%                       wobei fuer jeden Teil die entsprechenden
%                       DFT-Koeffizienten durch Mittelwert und Varianz
%                       zusammengefasst werden.
%                       Es ist zu beachten, dass niemals der erste
%                       DFT-Koeffizient (mittlerer Grauwert)beachtet wird.
%
% I/O Spec
%   imgGray     Ein Grauwertbild dessen Features berechnet werden sollen
%               
%
%   maxDim      Maximale Anzahl der DFT-Koeffizienten, welche berechnet
%               werden sollen. All diese Koeffizienten werden fuer den
%               Euklidischen Klassifikator verwendet.
%
%
%   svmDim      Anzahl der DFT-Koeffizienten die fuer den SVM-Klassifikator
%               verwendet werden sollen.
%
%
%   featureVeuclid   Feature-Vektor der fuer den Euklidischen Klassifikator
%                    verwendet wird.
%
%
%   featureVsvm      Feature-Vektor der fuer den SVM Klassifikator
%                    verwendet wird.
%
%
%   kreisCoeff       Zusammengefasste DFT-Koeffizienten fuer die zehn
%                    Abschnitte.
%
%
%   coeff            Alle DFT-Koeffizienten des Polarbildes.
%
%
%   imgPolar        Das berechnete 2D-Polarbild vom ausgegangenen
%                   Grauwertbild.

%Transformation in Polar-Koordinaten
imgPolar=imgCartToLogpolar(imgGray);

% Polartransformiete Bilder muessen noch zugeschnitten werden (y-Achse)
d=round((size(imgPolar,1)-(size(imgPolar,1)/sqrt(2)))/4  *1.2);% Abstand auf der Y Achse (unten und oben)// +20%
imgPolar=imgPolar(d:end-d,:);

%DFT-Koeffiziente
coeff=calcCoeff(imgPolar,maxDim+1);

%k-Kreise berechnen
maxR = size(imgPolar,1);
K=10; %Anzahl der Kreise
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

