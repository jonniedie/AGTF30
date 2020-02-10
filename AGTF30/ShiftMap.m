% Very Rough shifting for off nonminal VSV correction.

% Get scalar for Wc 
Wc2 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.WcArray, 1.0,0.95);
Wc1 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.WcArray, 1.0,1.0);

WcRatio = Wc2/Wc1; % True for off nominal VSVs near full power

% Get scalar for PR
PR2 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.PRArray, 1.0,0.95);
PR1 = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.PRArray, 1.0,1.0);

PRRatio = (PR2-1)/(PR1-1); 

% Assume scalar for Efficiency (slight loss)
EffRatio = 0.98;

% plot baseline map
WcVals= [];
PRVals = [];
for i = 1:length(MWS.HPC.RVec)
    for j = 1:length(MWS.HPC.NcVec)
        %TMATS.PlotCMap(MWS.HPC.NcVec, MWS.HPC.WcArray, MWS.HPC.PRArray, MWS.HPC.EffArray)
        WcVal = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.WcArray, MWS.HPC.RVec(i),MWS.HPC.NcVec(j));
        WcVals = [WcVals, WcVal];
        PRVal = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.PRArray, MWS.HPC.RVec(i),MWS.HPC.NcVec(j));
        PRVals = [PRVals, PRVal];
    end
end
plot(WcVals,PRVals, 'o')

WcVals= [];
PRVals = [];
Lshift =  1;
Lstep = (1-PRRatio)/(length(MWS.HPC.NcVec));
% plot shifted map
for j = 1:length(MWS.HPC.NcVec)
    for i = 1:length(MWS.HPC.RVec)
        %TMATS.PlotCMap(MWS.HPC.NcVec, MWS.HPC.WcArray, MWS.HPC.PRArray, MWS.HPC.EffArray)
        WcVal = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, MWS.HPC.WcArray*WcRatio, MWS.HPC.RVec(i),MWS.HPC.NcVec(j));
        WcVals = [WcVals, WcVal];
        %PRVal = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, (MWS.HPC.PRArray-1)*PRRatio +1, MWS.HPC.RVec(i),MWS.HPC.NcVec(j));
        PRVal = interp2(MWS.HPC.RVec, MWS.HPC.NcVec, (MWS.HPC.PRArray-1)*Lshift +1, MWS.HPC.RVec(i),MWS.HPC.NcVec(j));
        PRVals = [PRVals, PRVal];  
    end
    MWS.HPC.NcVec(j)
    Lshift = max(Lshift - Lstep, PRRatio);
end

hold on;
plot(WcVals,PRVals, 'o')

% Create 3D map
WcMap = ones(13,11,2);
PRMap = ones(13,11,2);
EffMap = ones(13,11,2);

WcMap(:,:,1) = MWS.HPC.WcArray;
PRMap(:,:,1) = MWS.HPC.PRArray;
EffMap(:,:,1) = MWS.HPC.EffArray;

% -------------------------------------------
% Final maps for CompressorVG
WcMap(:,:,2) = MWS.HPC.WcArray * WcRatio;
PRMap(:,:,2) = MWS.HPC.PRArray * PRRatio;
EffMap(:,:,2) = MWS.HPC.EffArray * EffRatio;
% aribitrary alpha value you can use for compressorVG
Alpha = [1 2];
% Note: other values must be transfered over from previous compressor block
% this includes, bleed info, scalars NcVec and RVecs, etc. 




