function [] = svmConstruction(typeSVM, samples, labels ,testMode)
%SVMCONSTRUCTION Summary of this function goes here
%   Detailed explanation goes here
% testMode 0= normal, 1= crossval mode
if nargin<4
    testMode=0;
end

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
if testMode==0
    save SVMClassifier AlphaY SVs Bias Parameters nSV nLabel;
else
    save( [getenv('COMPUTERNAME') '-SVMClassifier'] ,'AlphaY' ,'SVs' ,'Bias' ,'Parameters' ,'nSV' ,'nLabel');
end
%[ClassRate, DecisionValue, Ns, ConfMatrix, PreLabels]= SVMTest(samples, labels, AlphaY, SVs, Bias,Parameters, nSV, nLabel);

end

