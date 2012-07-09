function Fromt_loading(v1)
global Mani

if v1==1
    fprintf(Mani,'C007 2500+0+0 3000 3000 3000')
    pause(2)
    % Wheretogo(1)
    fprintf(Mani,'C007 -500+0+0 3000 3000 3000')
    pause(2)
    Injector(-20)
    pause(30)
    Injector(20)
    pause(1)
    fprintf(Mani,'C007 2500+0+0 3000 3000 3000')
    
    
elseif v1==2
    fprintf(Mani,'C007 2500+0+0 3000 3000 3000')
    pause(2)
    % Wheretogo(1)
    fprintf(Mani,'C007 -500+0+0 3000 3000 3000')
    pause(2)
    Injector(30)
    pause(10)
    Injector(-30)
    pause(1)
    fprintf(Mani,'C007 2500+0+0 3000 3000 3000')

else
    display('Front-load: Invalid command code. 1-loading, 2-unloading')
    
end

end