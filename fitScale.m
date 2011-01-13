function [ destValue ] = fitScale( srcRange, destRange, value)
% Berechnet einen Wert ueber die Verschiebung zweier Skalierungen
% srcRange ist ein Vector mit min/max der eingabe Skala
% srcRange ist ein Vector mit min/max der ausgabe Skala
% value ist der zu berechnende Wert
% destValue ist der berechnete Wert (value in destRange)

if min(value)<srcRange(1) || max(value)>srcRange(2) 
    warning('vale out of Range!!')
end

% Bsp.: srcRange=[30 60]; destRange= [0.6 1]; value = 60
destScale=destRange(2)-destRange(1);    % 0.4
scale= (srcRange(2)-srcRange(1))/destScale;       % 75
destValue= ((value-srcRange(1))/scale)+destRange(1)% 1

end

