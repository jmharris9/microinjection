function ProsilicaPreview(command_number)
global ttttt
global video_taking_NO
global video_taking
global conversion

conversion=0;
% global h3

if command_number=='help'
    display('0= initilization')
    display('0.5= fluorescent image')
    display('1= run')
    display('2= stop')
    return
end

if command_number==0
    ProsilicaCamera('initialize')
    pause(0.3)
    ProsilicaCamera('initialize')
    pause(0.3)
    ProsilicaCamera('initialize')
    pause(0.3)
%     ProsilicaCamera('setExposure', 50000)
%     the above is for fluorescent sigal
    ProsilicaCamera('setExposure', 200)
    ProsilicaCamera('setRegion', 0,512,0,512,2,2)
%     ProsilicaCamera('setRegion', 0,1024,0,1024,1,1)
    pause(0.1)
    ttttt=timer('TimerFcn',@testtimer, 'Period', 0.2, 'ExecutionMode', 'fixedRate');
    display('finish initiation')
end

if command_number==0.5
    ProsilicaCamera('initialize')
    pause(0.3)
    ProsilicaCamera('initialize')
    pause(0.3)
    ProsilicaCamera('initialize')
    pause(0.3)
    ProsilicaCamera('setExposure', 5000)
%     the above is for fluorescent sigal
    ProsilicaCamera('setRegion', 0,512,0,512,2,2)
    pause(0.1)
    AcumularValores=zeros(10,1);
    AcumularTiempos=zeros(10,1);
    ttttt=timer('TimerFcn',@testtimer, 'Period', 0.3, 'ExecutionMode', 'fixedRate');
    display('finish initiation for fluorescent image')
end

if command_number==1
    if isempty(ttttt)
        display('please initialize the CCD first')
        return
    end
    %ProsilicaCamera('setExposure', 200)
    pause(0.001)
    figure
    display('Previewing')
    start(ttttt)
    return
end

if command_number==2
    if isempty(ttttt)
        display('please initialize the CCD first')
        return
    end
    display('Closed')
    stop(ttttt)
    close Figure 1
end

%--------------------------------video mode----------------

if command_number==10
    display('video mode')
    ProsilicaCamera('initialize')
    pause(0.3)
    ProsilicaCamera('initialize')
    pause(0.3)
    ProsilicaCamera('initialize')
    pause(0.3)
    %     ProsilicaCamera('setExposure', 50000)
    %     the above is for fluorescent sigal
    ProsilicaCamera('setExposure', 200)
    ProsilicaCamera('setRegion', 0,512,0,512,2,2)
    video_taking=timer('TimerFcn',@video_taker, 'Period', 0.2, 'ExecutionMode', 'fixedRate');

end
   
if command_number==11
    video_taking_NO=1;
    ProsilicaCamera('setExposure', 200)
    start(video_taking) 
    return
end

if command_number==12
    if isempty(video_taking)
        display('please initialize the video mode first')
        return
    end
    display('Closed')
    stop(video_taking)
    close Figure 1
end

if command_number==13
    conversion=1;
    video_taker
end
%     
    
end