

Bildverstehen LU
*****************
* M�NZERKENNUNG *
*****************
* Gruppe:       *
*****************


Entwicklungsumgebung:
Das Programm wurde erfolgreich in MATLAB R2010b (32-bit-Version!!!) unter Windows2007 (32-bit) und WindowsXP getestet.
F�r die SVM wird die Toolbox OSU-SVM verwendet.

!!!!!VORSICHT!!!!!
Es kann zu Problemen bei 64-Bit Versionen kommen!

Um eine Demo der Muenzerkennung zu starten muss demoCoinRecognition(demoMode) ausgef�hrt werden.
Der DemoMode bietet folgende M�glichkeiten:
	0: Es wird KEIN TrainingsSet erstellt, sondern eine bereits trainierte SVM zur Klassifikation verwendet.
	1: Es wird ein TrainingsSet erstellt und eine SVM trainiert. Danach erfolgt eine Test-Klassifikation.

Ablauf der Demo:

	(1) TrainingsDaten werden eingelesen, Features extrahiert, TrainingsSet erstellt und Klassifikatoren trainiert (je nach DemoMode)
	(2) Es werden 3 Testbilder klassifiziert und ausgewertet
	(3) Es wird CrossValidation ausgef�hrt um die tats�chliche Klassifizierungsrate zu ermitteln

Projektmitglieder und Aufgabenaufteilung:

Entwickler & Programmierer:
	Roman Hochst�ger
	Christoph Fuchs

Dokumentation:
	Martin

Maskotchen:
	Andreas