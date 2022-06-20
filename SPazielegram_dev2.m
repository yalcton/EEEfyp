function [azigramConditioned, elegramConditioned, powerFinal,t,f] = SPazielegram_dev2(timeSP, Esp, Nsp, Zsp, srSP, tIntervalSpec, angleStepSpec, overlapSpec)
%%
%   --------------------------------------------------------------------- %
%
%   CC 19/10/19 V1
%   SPazielegram Plot azigram over 360 degrees and elegrams over 90
%   --------------------------------------------------------------------- %
%
%   e: event structure containing the SP accelerations to be processed
%   tInterval = time window length for spectrogram construction, default
%   100
%   angleStep = angle in degrees to search the spherical coordinates in
%   steps, default 10
%  
%
%   WTP 19/10/19 V1
%   Added in magnitude and data input from event structure
%
%   WTP 21/10/7
%   Removed plotting for speed and added overlap as input
 
%% -------------- 360 Deg Azigram/ 90 Deg Elegram Algorithm ---------------%
 
%   Set tInterval and  azimuthStep to defaults unless specified in call
if nargin == 1
    tInterval = 100;
    angleStep  = 10;
    overlap  = 2/3;
 
elseif nargin == 2
    tInterval = tIntervalSpec;
    angleStep  = 10;
    overlap  = 2/3;
   
elseif nargin == 7
    tInterval = tIntervalSpec;
    angleStep  = angleStepSpec;
    overlap  = 2/3;
    
elseif nargin == 8
    tInterval = tIntervalSpec;
    angleStep  = angleStepSpec;
    overlap  = overlapSpec;
end
%%
 
Nevent = 1;
for i = 1:Nevent
 
% ADD HERE YOUR ACCELERATION ENZ AND SAMPLE RATE FOR SP
 
% -------------- 360 Deg Azigram/ 90 Deg Elegram Algorithm ---------------%

dimt = size(Esp,1);
tInterval = tIntervalSpec;
sampleNumber = tInterval*srSP;
w  = hann(floor(sampleNumber)); % hanning window
 
%%
% Cartesian spectrograms
Zsp_use = SPremovelow(Zsp,srSP,1/tInterval);
Nsp_use = SPremovelow(Nsp,srSP,1/tInterval);
Esp_use = SPremovelow(Esp,srSP,1/tInterval);


[~,~,~,spectZ] = (spectrogram(Zsp_use, w, ...
            ceil(sampleNumber*overlap), ...
            [], ...
            srSP,'yaxis'));
       
[~,~,~,spectN] =  (spectrogram(Nsp_use, w, ...
            ceil(sampleNumber*overlap), ...
            [], ...
            srSP,'yaxis'));
       
[~,~,~,spectE] =  (spectrogram(Esp_use, w, ...
            ceil(sampleNumber*overlap), ...
            [], ...
            srSP,'yaxis'));
dimSpect1 = size(spectE, 1);
dimSpect2 = size(spectE, 2);
%%      
azigram = zeros(dimSpect1, dimSpect2);
power = zeros(dimSpect1, dimSpect2);
elevation_step = angleStep;
 
minAzim = 0;
maxAzim = 180;
 
azimuthSteps = minAzim:angleStep:maxAzim;
elevationSteps = -90:angleStep:90;
 
N_azimuth_steps = length(azimuthSteps);
N_elevation_steps = length(elevationSteps);
 
syntheticAxis = zeros(dimt,1);
powerSynth = zeros(dimSpect1 ,dimSpect2, N_azimuth_steps, N_elevation_steps);
 
for idx_elevation = 1 : N_elevation_steps
    idx_elevation
    for idx_azimuth = 1:N_azimuth_steps
       
        syntheticAxis = Zsp*cosd(elevationSteps(idx_elevation))+...
            (Nsp*cosd(azimuthSteps(idx_azimuth)) +...
            Esp*sind(azimuthSteps(idx_azimuth)))*sind(elevationSteps(idx_elevation));
       
        syntheticAxis = SPremovelow(syntheticAxis,srSP,2/tInterval);
       
        [~,f,t,powerSynth(:,:,idx_azimuth,idx_elevation)] = (spectrogram(syntheticAxis, w, ...
            ceil(sampleNumber*overlap), ...
            [], ...
            srSP,'yaxis'));
       
    end
end
 
%%
for elevIDX = 1:N_elevation_steps
    for time = 1:length(t)
        for freq = 1:length(f)
            [maxPower,idx] = max(abs(powerSynth(freq,time,:,elevIDX)));         
            azigram(freq,time,elevIDX) = minAzim + angleStep*(idx-1);
            power(freq,time,elevIDX) = maxPower;
        end
    end
end
 
%%
azigramFinal = zeros(dimSpect1 ,dimSpect2);
powerFinal = zeros(dimSpect1 ,dimSpect2);
elevationFinal = zeros(dimSpect1 ,dimSpect2);
 
for time = 1:length(t)
    for freq = 1:length(f)
        [maxPower,idx] = max(abs(power(freq,time,:)));      
        azigramFinal(freq,time) = azigram(freq,time,idx);
        powerFinal(freq,time) = maxPower;
       elevationFinal(freq,time) = -90 + angleStep*(idx-1);
    end
end
 
%%
elegramConditioned = zeros(dimSpect1 ,dimSpect2);
azigramConditioned = zeros(dimSpect1 ,dimSpect2);
 
azigramConditioned = azigramFinal;
elegramConditioned = elevationFinal;
 
[rowElePos,colElePos] = find(elevationFinal < 0);
for i=1:length(rowElePos)
    elegramConditioned(rowElePos(i),colElePos(i)) =...
        90 - abs(elegramConditioned(rowElePos(i),colElePos(i)));
end
 
[rowEleNeg,colEleNeg] = find(elevationFinal > 0);

elegramConditioned = atand(spectZ./(spectN+spectE));
for i=1:length(rowEleNeg)
    azigramConditioned(rowEleNeg(i),colEleNeg(i)) =...
        azigramConditioned(rowEleNeg(i),colEleNeg(i)) + 180;
    elegramConditioned(rowEleNeg(i),colEleNeg(i)) =...
        90 - (elegramConditioned(rowEleNeg(i),colEleNeg(i)));
end
end