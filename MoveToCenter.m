function MoveToCenter(v1,v2)
global XYStage

str = ['GR,' num2str(v1) ',' num2str(v2)];

fprintf(XYStage,str);
pause(0.5)

end