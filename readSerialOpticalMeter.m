%% Settings
plotsOn = true;
shutdownSystem = false;
% backupFolder = sprintf('Power_Meter_BKP_%s%s',datestr(now,'dd-mm-yyyy_HH-MM-SS'),'\');
% savedDataFolder = pwd;
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
% bkpPath = strcat(pwd,'\',backupFolder);
% if exist(bkpPath,'dir') == 0
%     mkdir(bkpPath);
% end
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
            close all
            figure('Color',[measureIndex/255,measureIndex/255,measureIndex/255],'Position',[1920 1 1366 1094],'MenuBar','none','Name','');
            fwrite(serialport,dataQuery);
            pause(delay);
            flowSize = serialport.BytesAvailable();
            pause;
            rawData(measureIndex) = str2double(char(fread(serialport,flowSize))');
            fprintf('Measure Number: %i, Raw Value: %1.3e [W]\n',measureIndex,rawData(measureIndex));
            fwrite(serialport,flushInput);
            A(measureIndex) = rawData(measureIndex);
            %   if ~rem(measureIndex,20)
            %     beep();
            %     beep();
            %   end
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
%% Notification
% for beepTimes = 1:3
%     beep();
%     pause(0.2);
% end
%% Close Port
fclose(serialport);
%% Save data
% save(sprintf('%s%sPower_Meter_Save_%s.mat',savedDataFolder,'\',datestr(now,'dd-mm-yyyy_HH-MM-SS')));
%% Plots
% if plotsOn
%     close(gcf);
%     fontSize = 15;
%     figure('color','white');
%     plot(1:measureIndex-1,rawData(1:measureIndex-1),'-bs'); grid on; axis square;
%     title('Laser Response - Stability Response','FontSize',fontSize,'FontWeight','Bold');
%     xlabel('Measure Number','FontSize',fontSize,'FontWeight','Bold');
%     ylabel('Power Units [W]','FontSize',fontSize,'FontWeight','Bold');
%     set(gca,'FontSize',fontSize,'FontWeight','Bold');
% end
%% Self shutdown
if shutdownSystem
    dos('shutdown -s'); %Admin privilages required
    exit;
end