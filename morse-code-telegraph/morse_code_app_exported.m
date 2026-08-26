classdef morse_code_app_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        SendMessageButton              matlab.ui.control.Button
        PhotoresistorCalibrationPanel  matlab.ui.container.Panel
        ThresholdVoltsEditField        matlab.ui.control.NumericEditField
        ThresholdVoltsEditFieldLabel   matlab.ui.control.Label
        CalibrateBrightButton          matlab.ui.control.Button
        CalibrationDimButton           matlab.ui.control.Button
        BrightReadingVoltsEditField    matlab.ui.control.NumericEditField
        BrightReadingVoltsEditFieldLabel  matlab.ui.control.Label
        DimReadingVoltsEditField       matlab.ui.control.NumericEditField
        DimReadingVoltsEditFieldLabel  matlab.ui.control.Label
        RecordingPanel                 matlab.ui.container.Panel
        RecordingLamp                  matlab.ui.control.Lamp
        RecordingLampLabel             matlab.ui.control.Label
        StartRecordingButton           matlab.ui.control.Button
        RecordingTimesEditField        matlab.ui.control.NumericEditField
        RecordingTimesEditFieldLabel   matlab.ui.control.Label
        DelayTimemsEditField           matlab.ui.control.NumericEditField
        DelayTimemsEditFieldLabel      matlab.ui.control.Label
        MorseCodeRecorderandTransmitterLabel  matlab.ui.control.Label
        origSignal                     matlab.ui.control.UIAxes
        cleanSignal                    matlab.ui.control.UIAxes
    end


    
    properties (Access = private)
        board = arduino(); % Description hippity hoppity this is now a property
        msg;
    end
    
    methods (Access = public)
        
        function thresh = calcThresh(app)
            thresh = (app.DimReadingVoltsEditField.Value + app.BrightReadingVoltsEditField.Value) / 2;
            app.ThresholdVoltsEditField.Value = thresh;
        end
        
        function out = cleanSig(app, input)
            if input >= app.ThresholdVoltsEditField.Value
                out = 0; % volts, non-input (pr is not covered)
            else
                out = 5; % volts input (pr is covered)
            end
        end
        
        function [] = plotLines(app)
            
            hold(app.origSignal, 'on');
            yline(app.origSignal, app.DimReadingVoltsEditField.Value, 'green', 'Dim');
            yline(app.origSignal, app.BrightReadingVoltsEditField.Value, 'green', 'Bright');
            yline(app.origSignal, app.ThresholdVoltsEditField.Value, 'green', 'Threshold');
            hold(app.origSignal, 'off');
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            clc;
            clear;
            close all;
            
        end

        % Button pushed function: CalibrationDimButton
        function CalibrationDimButtonPushed(app, event)
            avg = 0;
            for i = 1:10
                avg = avg + app.board.readVoltage("A0");
                pause(0.25);
            end

            avg = avg / i;

            app.DimReadingVoltsEditField.Value = avg;
            
            calcThresh(app);
            
        end

        % Button pushed function: CalibrateBrightButton
        function CalibrateBrightButtonPushed(app, event)
            
            avg = 0;
            for i = 1:10
                avg = avg + app.board.readVoltage("A0");
                pause(0.25);
            end

            avg = avg / i;

            app.BrightReadingVoltsEditField.Value = avg;

            calcThresh(app);
        end

        % Button pushed function: StartRecordingButton
        function StartRecordingButtonPushed(app, event)
            if (app.BrightReadingVoltsEditField.Value == 0) || (app.DimReadingVoltsEditField.Value == 0)
                error("Need to calibrate before recording");
            end % catching the user if they don't calibrate first
              
            
            interval = app.DelayTimemsEditField.Value;
            time = app.RecordingTimesEditField.Value * 1000; %time is in seconds, interval is in ms
            ir = round(time / interval); % number of total readings
            

            readings = zeros(1, ir);
            cleanReadings = zeros(1, ir);

            x = 1:ir;
            
            ylim(app.origSignal, [(app.DimReadingVoltsEditField.Value - 0.1), (app.BrightReadingVoltsEditField.Value + 0.1)]);
            ylim(app.cleanSignal, [-0.1, 5.1]);

            app.RecordingLamp.Color = "red";

            for i = 1:ir
                readings(i) = readVoltage(app.board, "A0");
                cleanReadings(i) = cleanSig(app, readings(i));

                plot(app.origSignal, x, readings);
                plot(app.cleanSignal, x, cleanReadings);
                plotLines(app);

                pause(interval / 1000); %bc interval is in ms
            end
            
            app.RecordingLamp.Color = "white";

            app.msg = cleanReadings;
            
        end

        % Button pushed function: SendMessageButton
        function SendMessageButtonPushed(app, event)
            signals = app.msg;
            len = length(signals);
            pins = ["D3", "D5", "D6"];


            if len < 1 %makes sure there's actually a message recorded
                disp("no message recorded. Please record a message first");
                return
            end
            
            x = 1:len;

            for i = 1:len;
                %sending with the LEDs
                testLED(app.board, signals(i));

                % code to plot the follow line
                plot(app.cleanSignal, x, signals);
                hold(app.cleanSignal, 'on');
                xline(app.cleanSignal, i, 'green');
                hold(app.cleanSignal, 'off');

            end
            
            testLED(app.board, 0);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 836 720];
            app.UIFigure.Name = 'MATLAB App';

            % Create cleanSignal
            app.cleanSignal = uiaxes(app.UIFigure);
            title(app.cleanSignal, 'Cleaned Message')
            xlabel(app.cleanSignal, 'Time [S]')
            ylabel(app.cleanSignal, 'PR Voltage [V]')
            zlabel(app.cleanSignal, 'Z')
            app.cleanSignal.Position = [457 68 337 248];

            % Create origSignal
            app.origSignal = uiaxes(app.UIFigure);
            title(app.origSignal, 'Original Signal')
            xlabel(app.origSignal, 'Time [s]')
            ylabel(app.origSignal, 'PR Voltage [Volts]')
            zlabel(app.origSignal, 'Z')
            app.origSignal.XTick = [0 1 2 3 4 5];
            app.origSignal.XTickLabel = {'0'; '20'; '40'; '60'; '80'; '100'};
            app.origSignal.YTick = [0 1 2 3 4 5];
            app.origSignal.YTickLabel = {'0'; '1'; '1.5'; '2'; '2.5'; '5'};
            app.origSignal.Position = [38 81 307 235];

            % Create MorseCodeRecorderandTransmitterLabel
            app.MorseCodeRecorderandTransmitterLabel = uilabel(app.UIFigure);
            app.MorseCodeRecorderandTransmitterLabel.HorizontalAlignment = 'center';
            app.MorseCodeRecorderandTransmitterLabel.FontName = 'Arial';
            app.MorseCodeRecorderandTransmitterLabel.FontSize = 24;
            app.MorseCodeRecorderandTransmitterLabel.Position = [80 617 663 92];
            app.MorseCodeRecorderandTransmitterLabel.Text = 'Morse Code Recorder and Transmitter';

            % Create RecordingPanel
            app.RecordingPanel = uipanel(app.UIFigure);
            app.RecordingPanel.Title = 'Recording';
            app.RecordingPanel.Position = [63 334 260 221];

            % Create DelayTimemsEditFieldLabel
            app.DelayTimemsEditFieldLabel = uilabel(app.RecordingPanel);
            app.DelayTimemsEditFieldLabel.HorizontalAlignment = 'right';
            app.DelayTimemsEditFieldLabel.Position = [38 139 91 22];
            app.DelayTimemsEditFieldLabel.Text = 'Delay Time [ms]';

            % Create DelayTimemsEditField
            app.DelayTimemsEditField = uieditfield(app.RecordingPanel, 'numeric');
            app.DelayTimemsEditField.Position = [144 139 100 22];
            app.DelayTimemsEditField.Value = 25;

            % Create RecordingTimesEditFieldLabel
            app.RecordingTimesEditFieldLabel = uilabel(app.RecordingPanel);
            app.RecordingTimesEditFieldLabel.HorizontalAlignment = 'right';
            app.RecordingTimesEditFieldLabel.Position = [26 89 105 22];
            app.RecordingTimesEditFieldLabel.Text = 'Recording Time [s]';

            % Create RecordingTimesEditField
            app.RecordingTimesEditField = uieditfield(app.RecordingPanel, 'numeric');
            app.RecordingTimesEditField.Position = [146 89 100 22];
            app.RecordingTimesEditField.Value = 5;

            % Create StartRecordingButton
            app.StartRecordingButton = uibutton(app.RecordingPanel, 'push');
            app.StartRecordingButton.ButtonPushedFcn = createCallbackFcn(app, @StartRecordingButtonPushed, true);
            app.StartRecordingButton.Position = [16 20 100 23];
            app.StartRecordingButton.Text = 'Start Recording';

            % Create RecordingLampLabel
            app.RecordingLampLabel = uilabel(app.RecordingPanel);
            app.RecordingLampLabel.HorizontalAlignment = 'right';
            app.RecordingLampLabel.Position = [134 21 60 22];
            app.RecordingLampLabel.Text = 'Recording';

            % Create RecordingLamp
            app.RecordingLamp = uilamp(app.RecordingPanel);
            app.RecordingLamp.Position = [209 21 20 20];
            app.RecordingLamp.Color = [1 1 1];

            % Create PhotoresistorCalibrationPanel
            app.PhotoresistorCalibrationPanel = uipanel(app.UIFigure);
            app.PhotoresistorCalibrationPanel.Title = 'Photoresistor Calibration';
            app.PhotoresistorCalibrationPanel.Position = [500 334 260 221];

            % Create DimReadingVoltsEditFieldLabel
            app.DimReadingVoltsEditFieldLabel = uilabel(app.PhotoresistorCalibrationPanel);
            app.DimReadingVoltsEditFieldLabel.HorizontalAlignment = 'right';
            app.DimReadingVoltsEditFieldLabel.Position = [17 109 110 22];
            app.DimReadingVoltsEditFieldLabel.Text = 'Dim Reading [Volts]';

            % Create DimReadingVoltsEditField
            app.DimReadingVoltsEditField = uieditfield(app.PhotoresistorCalibrationPanel, 'numeric');
            app.DimReadingVoltsEditField.Position = [142 109 100 22];

            % Create BrightReadingVoltsEditFieldLabel
            app.BrightReadingVoltsEditFieldLabel = uilabel(app.PhotoresistorCalibrationPanel);
            app.BrightReadingVoltsEditFieldLabel.HorizontalAlignment = 'right';
            app.BrightReadingVoltsEditFieldLabel.Position = [8 69 120 22];
            app.BrightReadingVoltsEditFieldLabel.Text = 'Bright Reading [Volts]';

            % Create BrightReadingVoltsEditField
            app.BrightReadingVoltsEditField = uieditfield(app.PhotoresistorCalibrationPanel, 'numeric');
            app.BrightReadingVoltsEditField.Position = [143 69 100 22];

            % Create CalibrationDimButton
            app.CalibrationDimButton = uibutton(app.PhotoresistorCalibrationPanel, 'push');
            app.CalibrationDimButton.ButtonPushedFcn = createCallbackFcn(app, @CalibrationDimButtonPushed, true);
            app.CalibrationDimButton.Position = [27 159 100 23];
            app.CalibrationDimButton.Text = 'Calibration Dim';

            % Create CalibrateBrightButton
            app.CalibrateBrightButton = uibutton(app.PhotoresistorCalibrationPanel, 'push');
            app.CalibrateBrightButton.ButtonPushedFcn = createCallbackFcn(app, @CalibrateBrightButtonPushed, true);
            app.CalibrateBrightButton.Position = [141 159 100 23];
            app.CalibrateBrightButton.Text = 'Calibrate Bright';

            % Create ThresholdVoltsEditFieldLabel
            app.ThresholdVoltsEditFieldLabel = uilabel(app.PhotoresistorCalibrationPanel);
            app.ThresholdVoltsEditFieldLabel.HorizontalAlignment = 'right';
            app.ThresholdVoltsEditFieldLabel.Position = [32 32 94 22];
            app.ThresholdVoltsEditFieldLabel.Text = 'Threshold [Volts]';

            % Create ThresholdVoltsEditField
            app.ThresholdVoltsEditField = uieditfield(app.PhotoresistorCalibrationPanel, 'numeric');
            app.ThresholdVoltsEditField.Position = [141 32 100 22];

            % Create SendMessageButton
            app.SendMessageButton = uibutton(app.UIFigure, 'push');
            app.SendMessageButton.ButtonPushedFcn = createCallbackFcn(app, @SendMessageButtonPushed, true);
            app.SendMessageButton.Position = [551 23 170 23];
            app.SendMessageButton.Text = 'Send Message';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = morse_code_app_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end