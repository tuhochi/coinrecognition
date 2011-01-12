function [] = svmConstruction(typeSVM, samples, labels )
%SVMCONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here

if(typeSVM==1)
    %Linearer Kernel
    disp('Lineare SVM wird erstellt')
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = LinearSVC(samples, labels); 
elseif(typeSVM==2)
    %Poly-Kernel
    disp('Poly SVM wird erstellt')
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = PolySVC(samples, labels);    
else
    %RBF-Kernel
    disp('RBF SVM wird erstellt')
    [AlphaY, SVs, Bias, Parameters, nSV, nLabel] = RbfSVC(samples, labels);    
end

%save SVMClassifierLin AlphaY SVs Bias Parameters nSV nLabel;
save SVMClassifier AlphaY SVs Bias Parameters nSV nLabel;
%[ClassRate, DecisionValue, Ns, ConfMatrix, PreLabels]= SVMTest(samples, labels, AlphaY, SVs, Bias,Parameters, nSV, nLabel);

end

