function []=demoCoinRecognition(demoMode)
%demoCoinRecognition Startet ein Demo-Lauf zum Testen der Muenzerkennung.  
%
%   demoCoinRecognition(demoMode) displays the grayscale image I.
%
% I/O Spec
%   demoMode     0: TrainingSet wird eingelsen und Klassifikator werden
%                   mit diesem trainiert. Anschliessend wird eine
%                   Klassifikation durchgefuehrt.
%
%                1: Klassifikation mit bereits trainierten Klassifikatoren
%                   wird durchgefuehrt.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEMO COINRECOGNITION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Training der Klassifikatoren

if nargin<1
    demoMode=0;
end

if demoMode==0
    %Erstellen des TrainingSets und erstellen der Klassifikatoren
    buildTrainingsSet('collection',1,'_low',[0 1 2 3],'normal');
end

%% Klassifikation von Testbildern

% Testbild1
disp(' ')
disp('Testbild 1')
imgPath='coin/TestData_low/test1.jpg';
% Extrahieren der Coins
coins=getCoinsFromImage(imgPath,135/4);
%Klassifizierung
[coins labels result1 result2] = classifyCoin(coins,imgPath);
input('Weiter mit Enter....')

% Testbild2
disp(' ')
disp('Testbild 2')
imgPath='coin/TestData_low/test2.jpg';
% Extrahieren der Coins
coins=getCoinsFromImage(imgPath,135/4);
%Klassifizierung
[coins labels result1 result2] = classifyCoin(coins,imgPath);
input('Weiter mit Enter....')


% Testbild3
disp(' ')
disp('Testbild 3')
imgPath='coin/TestData_low/test3.jpg';
% Extrahieren der Coins
coins=getCoinsFromImage(imgPath,135/4);
%Klassifizierung
[coins labels result1 result2] = classifyCoin(coins,imgPath);
input('Weiter mit Enter....')


%Klassifizierungsrate mittels CrossValidation
disp(' ')
disp('CrossValidation:')
[meanPrecision Precision]=crossval();
meanPrecision


disp(['Die Cross-Validation ergibt: Von durchschnittlich ' num2str((meanPrecision(1)*100)) '% der Münzen']);
disp('im Trainingsset wird der richtige Wert erkannt.')
end

