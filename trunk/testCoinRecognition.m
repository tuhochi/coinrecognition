
%Pfad des Testfiles
%Unbekanntes Testfile
imgPath='coin/TestData_low/test1.jpg';
imgPath='coin/TestData_low/test2.jpg';
%imgPath='coin/TestData_low/test3.jpg';

%Vom TrainingSet
%imgPath='coin/TrainingsData_low/1euroV/1eurozahl.jpg';

%Extrahieren der Coins
coins=getCoinsFromImage(imgPath,135/4);

%Klassifizierung
[coins labels result1 result2] = classifyCoin(coins,imgPath);



