function manipulator(v1,v2)
ManiCOM = 1;
Mani= serial(['COM' num2str(ManiCOM)],'Terminator','CR');
set(Mani,'timeout',0.5)
fopen(Mani);

fprintf(syr,'C0000')


fclose(Mani)

end