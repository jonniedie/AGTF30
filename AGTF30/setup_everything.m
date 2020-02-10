%		setup_everything.m
% *************************************************************************
% written by Jeffryes Chapman
% NASA Glenn Research Center, Cleveland, OH
% Aug 15th, 2016
%
% This function calls all inputs for the AGTF30 engine simulation
% *************************************************************************
clear MWS
addpath(genpath(fullfile(pwd, '..', '..', '..', 'TMATS_v1_2_0')))


Input.UseExcel = 1;
Input.LoadBus = 1;
% Input.ICPoint = 'auto';
AGTF30.setup_simulation(Input);

MWS.In.ICss = [MWS.In.ICss, 1];

ShiftMap()

clear Input;
