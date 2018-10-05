function varargout = GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);

if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function GUI_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

guidata(hObject, handles);

function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
%% Settings
plotsOn = true;
shutdownSystem = false;
backupFolder = sprintf('Power_Meter_BKP_%s%s',datestr(now,'dd-mm-yyyy_HH-MM-SS'),'\');
savedDataFolder = pwd;
%% Initialize Serial Object
COMPort = 'COM3';
serialport = serial(COMPort);
serialport.BaudRate = 9600;
serialport.DataBits = 8;
serialport.Parity = 'none';
serialport.StopBits = 1;
serialport.FlowControl = 'software'; % Must be set to 'software' for the 1830-c device
serialport.Terminator = 'CR';
serialport.Timeout = 1;
%% Device Commands
terminator = '\r\n'; % Must be included in order to excecute the command
buzzOn = sprintf(strcat('B1',terminator));
buzzOff = sprintf(strcat('B0',terminator));
echoModeOn = sprintf(strcat('E1',terminator));
echoModeOff = sprintf(strcat('E0',terminator));
flushInput = sprintf(strcat('C',terminator));
statusQuery = sprintf(strcat('Q?',terminator));
dataQuery = sprintf(strcat('D?',terminator));
%% Test Communication
if strcmp(serialport.Status,'closed')
    fopen(serialport);
end
fwrite(serialport,buzzOn); % Initial buzzer indication
pause(0.25);
fwrite(serialport,buzzOff);
%% Set mode
fwrite(serialport,echoModeOff);
%% Generate directories
bkpPath = strcat(pwd,'\',backupFolder);
if exist(bkpPath,'dir') == 0
    mkdir(bkpPath);
end
%% Read Raw Measurements
totalMeasurements = 2;
delay = 0.1; %[seconds] % Allows COM to execute multiple querys and readings
rawData = zeros(1,totalMeasurements);
fwrite(serialport,flushInput);
measureIndex = 1;
currentMeasure = 1;
disconnectionNumber = 0;
tic;
while measureIndex < totalMeasurements
    try
        for measureIndex = currentMeasure: totalMeasurements
            for i = 0:20:40
                L = i;
                pause(1)
                set ( gcf, 'Color', [L/255 L/255 L/255] )
                set(gcf,'Units', 'pixels');
                set(gcf,'Position', [1366 0 1366 1094]);
                varargout{1} = handles.output;
            end
            fwrite(serialport,dataQuery);
            pause(delay);
            flowSize = serialport.BytesAvailable();
            pause(0.1);
            rawData(measureIndex) = str2double(char(fread(serialport,flowSize))');
            fprintf('Measure Number: %i, Raw Value: %1.3e [W]\n',measureIndex,rawData(measureIndex));
            fwrite(serialport,flushInput);
        end
    catch
        fclose(serialport);
        disconnectionNumber = disconnectionNumber + 1;
        currentMeasure = measureIndex;
        fprintf('Failed to connect to serial port at measure: %i. Disconnection: %i.\n',currentMeasure,disconnectionNumber);
        fprintf('System will reconnect to specified port.\n');
        if strcmp(serialport.Status,'closed')
            fopen(serialport);
        end
        fwrite(serialport,flushInput);
        save(strcat(bkpPath,'dataBackup_',num2str(disconnectionNumber),'.mat'));
    end
end
elapsedTime = toc;

%% Close Port
fclose(serialport);
%% Save data
save(sprintf('%s%sPower_Meter_Save_%s.mat',savedDataFolder,'\',datestr(now,'dd-mm-yyyy_HH-MM-SS')));
%% Self shutdown
if shutdownSystem
    dos('shutdown -s'); %Admin privilages required
    exit;
end