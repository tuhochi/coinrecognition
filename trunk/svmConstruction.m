function [] = svmConstruction(typeSVM, samples, labels)
%whitePatch TrainingSet wird eingelesen und Klassifikatoren trainiert.  
%
%   svmConstruction(typeSVM, samples, labels ,testMode)
%                       Hier wird eine SVM des angegebenen Typs erstellt
%                       und die Parameter werden 
% I/O Spec
%   typeSVM     SVM Type
%               1:    SVM mit linearem Kernel
%               2:    SVM mit polynomiellen-Kernel
%               else:   SVM mit RBF-Kernel
%
%   samples     Feature Matrix, wobei einzelne Feature-Vektoren als Spalten
%               eingetragen sind
%
%   labels      Label Vector mit der Klassenzuweisung der einzelnen
%               Feature-Vektoren als Zeilen-Vektor


disp(['Anzahl der Feature-Vektoren: ' num2str(size(samples,1))]);
disp(['Größe eines Feature-Vektors: ' num2str(size(samples,2))]);

%% SVM erstellen
switch typeSVM
    case 1
        %Linearer Kernel
        disp('Lineare SVM wird erstellt')
        [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = LinearSVC(samples, labels); 
    case 2
        %Poly-Kernel
        disp('Poly SVM wird erstellt')
        [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = PolySVC(samples, labels);
    otherwise
        %RBF-Kernel
        disp('RBF SVM wird erstellt')
        [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = RbfSVC(samples, labels);    
end
%% SVM Parameter abspeichern
save( 'SVMClassifier' ,'AlphaY' ,'SVs' ,'Bias' ,'Parameters' ,'nSV' ,'nLabel');

end

