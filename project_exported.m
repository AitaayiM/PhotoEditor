classdef project_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure              matlab.ui.Figure
        Panel_2               matlab.ui.container.Panel
        Button_13             matlab.ui.control.Button
        Button_12             matlab.ui.control.Button
        Button_11             matlab.ui.control.Button
        Button_10             matlab.ui.control.Button
        Button_9              matlab.ui.control.Button
        Button_8              matlab.ui.control.StateButton
        Button_7              matlab.ui.control.StateButton
        Panel                 matlab.ui.container.Panel
        DarkgreenLabel        matlab.ui.control.Label
        DarkgreenLabel_2      matlab.ui.control.Label
        DarkblueLabel         matlab.ui.control.Label
        DarkblueLabel_2       matlab.ui.control.Label
        DarkredLabel          matlab.ui.control.Label
        DarkredLabel_2        matlab.ui.control.Label
        lightblueLabel        matlab.ui.control.Label
        lightblueLabel_2      matlab.ui.control.Label
        lightgreenLabel       matlab.ui.control.Label
        lightgreenLabel_2     matlab.ui.control.Label
        lightredLabel_2       matlab.ui.control.Label
        lightredLabel         matlab.ui.control.Label
        lightredSlider_6      matlab.ui.control.Slider
        lightredSlider_5      matlab.ui.control.Slider
        lightredSlider_4      matlab.ui.control.Slider
        lightredSlider_3      matlab.ui.control.Slider
        lightredSlider_2      matlab.ui.control.Slider
        lightredSlider        matlab.ui.control.Slider
        Button_6              matlab.ui.control.StateButton
        Button_5              matlab.ui.control.StateButton
        AITAAYILabel_2        matlab.ui.control.Label
        AITAAYILabel          matlab.ui.control.Label
        PhotoEditorLabel      matlab.ui.control.Label
        TypeDropDownLabel_11  matlab.ui.control.Label
        TypeDropDown_4        matlab.ui.control.DropDown
        TypeDropDownLabel_10  matlab.ui.control.Label
        NoiseSlider           matlab.ui.control.Slider
        NoiseSliderLabel      matlab.ui.control.Label
        FilterSliderLabel_3   matlab.ui.control.Label
        TypeDropDownLabel_9   matlab.ui.control.Label
        TypeDropDownLabel_8   matlab.ui.control.Label
        TypeDropDown_3        matlab.ui.control.DropDown
        TypeDropDownLabel_7   matlab.ui.control.Label
        TypeDropDownLabel_6   matlab.ui.control.Label
        TypeDropDown_2        matlab.ui.control.DropDown
        Switch                matlab.ui.control.Switch
        TypeDropDownLabel_5   matlab.ui.control.Label
        TypeDropDownLabel_4   matlab.ui.control.Label
        TypeDropDown          matlab.ui.control.DropDown
        TypeDropDownLabel     matlab.ui.control.Label
        Button                matlab.ui.control.StateButton
        TypeDropDownLabel_3   matlab.ui.control.Label
        UIAxes                matlab.ui.control.UIAxes
    end

    
    properties (Access = private)
        file
        Noise;
        Image 
        Modified
        TmpEffect
        diffImage
        imageErosion
        ImagePrevious
        hist='Off';
        Create=0;
        ErosionCreate=0;
        erosion='Cube';
        filter='Median';
        gaussian;
        Red=1;
        Green=1;
        Blue=1;
        greyScale=0;
        customize='RGB';
        customizePrevious='RGB';
        previous='Median';
        periority=1;
        lowR=0.01;
        lowG=0.01;
        lowB=0.01;
        highR=0.51;
        highG=0.51;
        highB=0.51;
        colorPeriority=0;
        stack;
        nStack;
        imageConv0;
        imageConv1;
        imageConv2;
        imageConv3;
        imageConv4;
    end
    
    properties (Access = public)
        GaussianSliderLabel         matlab.ui.control.Label
        GaussianSlider              matlab.ui.control.Slider
        FilterSliderLabel_2     matlab.ui.control.Label
        Button_3             matlab.ui.control.StateButton
        Button_2             matlab.ui.control.StateButton
        Button_4             matlab.ui.control.Button
    end
    
    methods (Access = private)
        
        function DisplayHist(app,red,green,blue,grey)
            cla(app.UIAxes,'reset');
            if strcmp(app.hist,'On')==1
                app.Red=red;
                app.Green=green;
                app.Blue=blue;
                app.greyScale=grey;
                %histogram
                R=app.Modified(:,:,1);
                G=app.Modified(:,:,2);
                B=app.Modified(:,:,3);
                app.TmpEffect=cat(3,R*red,G*green,B*blue); % Cutomize
                if red==1                
                    h=histogram(R(:),'Parent',app.UIAxes);
                    h.FaceColor=[1 0 0];
                end
                xlim(app.UIAxes,[0 255]);
                ylim(app.UIAxes,[0 30000]);
                xticks(app.UIAxes,0:50:250);
                yticks(app.UIAxes,0:5000:30000);
                hold(app.UIAxes,"on");
                if green==1
                    h=histogram(G(:),'Parent',app.UIAxes);
                    h.FaceColor=[0 1 0];
                end
                if blue==1
                    h=histogram(B(:),'Parent',app.UIAxes);
                    h.FaceColor=[0 0 1];
                end
                if grey==1
                    GreyScale=rgb2gray(app.Modified);
                    app.TmpEffect=GreyScale;
                    h=histogram(GreyScale(:),'Parent',app.UIAxes);
                    h.FaceColor=[0.5 0.5 0.5];
                end
                hold(app.UIAxes,"Off");         
            elseif strcmp(app.hist,'Off')==1
                I = imshow(app.TmpEffect,'Parent',app.UIAxes,'XData',[1 app.UIAxes.Position(3)],'YData',[1 app.UIAxes.Position(4)]);
                %set the axis limits
                app.UIAxes.XLim=[0 I.XData(2)];
            end
            app.stack.push(app.TmpEffect);
        end
        
        function createSigma(app)
            % Create GaussianSliderLabel
            app.GaussianSliderLabel = uilabel(app.UIFigure);
            app.GaussianSliderLabel.HorizontalAlignment = 'right';
            app.GaussianSliderLabel.FontSize = 18;
            app.GaussianSliderLabel.FontColor = [0.8 0.8 0.8];
            app.GaussianSliderLabel.Position = [26 214 56 23];
            app.GaussianSliderLabel.Text = 'Sigma';

            % Create GaussianSlider
            app.GaussianSlider = uislider(app.UIFigure);
            app.GaussianSlider.ValueChangedFcn = createCallbackFcn(app, @GaussianSliderValueChanged, true);
            app.GaussianSlider.FontColor = [0.8 0.8 0.8];
            app.GaussianSlider.Position = [95 227 218 3];

            % Create FilterSliderLabel_2
            app.FilterSliderLabel_2 = uilabel(app.UIFigure);
            app.FilterSliderLabel_2.HorizontalAlignment = 'right';
            app.FilterSliderLabel_2.FontSize = 18;
            app.FilterSliderLabel_2.FontColor = [0.3922 0.8314 0.0745];
            app.FilterSliderLabel_2.Position = [25 213 56 23];
            app.FilterSliderLabel_2.Text = 'Sigma';
        end
        
        function medium(app)
            app.TmpEffect=app.Modified;
            if and(app.Noise>0 , app.gaussian>0)
                imNoise=imnoise(app.TmpEffect,"gaussian",app.Noise);
                x=int64(app.gaussian);
                app.TmpEffect=imfilter(imNoise,ones(x));
                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
            end   
        end
        
        function gaussianF(app)
            app.TmpEffect=app.Modified;
            if app.gaussian>0
                app.TmpEffect=imgaussfilt(app.TmpEffect,app.gaussian);
                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
            end
        end
        
        function medianF(app)
            app.TmpEffect=app.Modified;
            if app.Noise>0
                %convert the RGB image to grayscale and process the one plane
                %process the three color planes independently and combine the result
                %use medfilt3() instead of medfilt2() (this is probably not a good idea!)
                %convert the RGB image to some other color systems such as L*ab or HSV, and extract one of the representation panes and work with tha
                HSV = rgb2hsv(app.TmpEffect);
                H = HSV(:,:,1);
                imNoise=imnoise(H,"gaussian",app.Noise);
                app.TmpEffect=medfilt2(imNoise);
                HSV1 = app.TmpEffect; 
                HSV1(:,:,2:3) = 1;
                app.TmpEffect=HSV1;
                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
            end
        end
        
        function createErosion(app)
            % Create Button_2
            app.Button_2 = uibutton(app.UIFigure, 'state');
            app.Button_2.ValueChangedFcn = createCallbackFcn(app, @ButtonValueChanged_2, true);
            app.Button_2.Text = '';
            app.Button_2.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_2.FontColor = [0.0196 0.0196 0.1804];
            app.Button_2.Position = [345 12 215 155];

            % Create Button_3
            app.Button_3 = uibutton(app.UIFigure, 'state');
            app.Button_3.ValueChangedFcn = createCallbackFcn(app, @ButtonValueChanged_3, true);
            app.Button_3.Text = '';
            app.Button_3.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_3.FontColor = [0.0196 0.0196 0.1804];
            app.Button_3.Position = [568 12 215 155];

            % Create Button_4
            app.Button_4 = uibutton(app.UIFigure, 'push');
            app.Button_4.ButtonPushedFcn = createCallbackFcn(app, @Button_4Pushed, true);
            app.Button_4.Icon = fullfile(fileparts(mfilename('fullpath')), 'reset1.png');
            app.Button_4.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_4.Position = [221 303 46 24];
            app.Button_4.Text = '';
        end
        
        function ButtonValueChanged_2(app, event)
            app.TmpEffect=app.ImagePrevious;
            app.Modified=app.TmpEffect;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end
        
        function ButtonValueChanged_3(app, event)
            app.TmpEffect=app.imageErosion;
            app.Modified=app.TmpEffect;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.Button_5.Visible="off";
            app.Button_6.Visible="off";
            app.Panel.Visible="off";
            app.Button_7.Visible="off";
            app.Button_8.Visible="off";
            app.Panel_2.Visible="off";
        end

        % Value changed function: Button
        function ButtonValueChanged(app, event)
            [app.file,path]=uigetfile({'*.jpg';'*.png';'*.gif';'*.bmp';'*.tif'},'file selector');
            pathImage= strcat(path,app.file);
            if isempty(pathImage)==0
                app.UIFigure.Visible="on";
                app.Image=imread(pathImage);
                app.Modified=app.Image;
                app.TmpEffect=app.Modified;
                app.stack=CStack(app.Image);
                app.nStack=CStack();
                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
                app.TypeDropDown_2.Value='RGB';
                app.Red=1;
                app.Green=1;
                app.Blue=1;
                app.greyScale=0;
                app.customize='RGB';
                app.customizePrevious='RGB';
                app.Button_5.Visible="on";
                app.Button_6.Visible="on";
                app.Button_7.Visible="on";
                app.Button_8.Visible="on";
                if app.ErosionCreate==1
                    delete(app.Button_2);
                    delete(app.Button_3);
                    delete(app.Button_4);
                    app.ErosionCreate=0;
                end
                if strcmp(app.Panel_2.Visible,"on")==1
                    app.Panel_2.Visible="off";
                end
            end
        end

        % Value changed function: TypeDropDown
        function TypeDropDownValueChanged(app, event)
            value = app.TypeDropDown.Value;
            if app.file~=0
                if strcmp(value,'Original')==1
                    app.TmpEffect=app.Image;
                    DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
                elseif strcmp(value,'Egalisation')==1
                    app.TmpEffect=histeq(app.Image);
                    DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
                end
            end
        end

        % Value changed function: Switch
        function SwitchValueChanged(app, event)
            app.hist = app.Switch.Value;
            if app.file~=0
                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
            end
        end

        % Value changed function: TypeDropDown_2
        function TypeDropDown_2ValueChanged(app, event)
            app.customize = app.TypeDropDown_2.Value;
            %xlim(app.UIAxes,[0 255]);
              %  ylim(app.UIAxes,[0 30000]);
               % xticks(app.UIAxes,0:50:250);
            %    yticks(app.UIAxes,0:5000:30000);
             %   hold(app.UIAxes,"on");
            if app.file~=0
                app.customizePrevious=app.customize;
                switch app.customize
                    case 'RGB'
                        app.Red=1;
                        app.Green=1;
                        app.Blue=1;
                        app.greyScale=0;
                        if strcmp(app.hist,'Off')==1
                            %histogram
                            R=app.Modified(:,:,1);
                            G=app.Modified(:,:,2);
                            B=app.Modified(:,:,3);
                            app.TmpEffect=cat(3,R*app.Red,G*app.Green,B*app.Blue); % Cutomize
                            h.FaceColor=[1 0 0];
                            h.FaceColor=[0 1 0];
                            h.FaceColor=[0 0 1];
                        end
                        DisplayHist(app,1,1,1,0);
                    case 'Red'
                        app.Red=1;
                        app.Green=0;
                        app.Blue=0;
                        app.greyScale=0;
                        if strcmp(app.hist,'Off')==1
                            %histogram
                            R=app.Modified(:,:,1);
                            G=app.Modified(:,:,2);
                            B=app.Modified(:,:,3);
                            app.TmpEffect=cat(3,R*app.Red,G*app.Green,B*app.Blue); % Cutomize
                            h.FaceColor=[1 0 0];
                        end
                        DisplayHist(app,1,0,0,0);
                    case 'Green'
                        app.Red=0;
                        app.Green=1;
                        app.Blue=0;
                        app.greyScale=0;
                        if strcmp(app.hist,'Off')==1
                            %histogram
                            R=app.Modified(:,:,1);
                            G=app.Modified(:,:,2);
                            B=app.Modified(:,:,3);
                            app.TmpEffect=cat(3,R*app.Red,G*app.Green,B*app.Blue); % Cutomize
                            h.FaceColor=[0 1 0];
                        end
                        DisplayHist(app,0,1,0,0);
                    case 'Blue'
                        app.Red=0;
                        app.Green=0;
                        app.Blue=1;
                        app.greyScale=0;
                        if strcmp(app.hist,'Off')==1
                            %histogram
                            R=app.Modified(:,:,1);
                            G=app.Modified(:,:,2);
                            B=app.Modified(:,:,3);
                            app.TmpEffect=cat(3,R*app.Red,G*app.Green,B*app.Blue); % Cutomize
                            h.FaceColor=[0 0 1];
                        end
                        DisplayHist(app,0,0,1,0);
                    case 'To Grey'
                        app.Red=0;
                        app.Green=0;
                        app.Blue=0;
                        app.greyScale=1;
                        if strcmp(app.hist,'Off')==1
                            %histogram
                            R=app.Modified(:,:,1);
                            G=app.Modified(:,:,2);
                            B=app.Modified(:,:,3);
                            app.TmpEffect=cat(3,R*app.Red,G*app.Green,B*app.Blue); % Cutomize
                            GreyScale=rgb2gray(app.Modified);
                            app.TmpEffect=GreyScale;
                            h.FaceColor=[0.5 0.5 0.5];
                        end
                        DisplayHist(app,0,0,0,1);
                end
            else
                app.TypeDropDown_2.Value=app.customizePrevious;
                app.customize=app.customizePrevious;
            end
        end

        % Callback function
        function GaussianSliderValueChanged(app, event)
            app.gaussian = app.GaussianSlider.Value;
            if and(app.file~=0 , app.gaussian>0)
                switch app.filter
                    case 'Medium'
                        medium(app);
                    case 'Gaussian'
                        gaussianF(app);
                    case 'Median'
                        medianF(app);
                end
            end    
        end

        % Value changed function: TypeDropDown_3
        function TypeDropDown_3ValueChanged(app, event)
            app.filter = app.TypeDropDown_3.Value;
            if app.file~=0
                switch app.filter
                    case 'Medium'
                        if app.ErosionCreate==1
                            delete(app.Button_2);
                            delete(app.Button_3);
                            delete(app.Button_4);
                            app.ErosionCreate=0;
                        end
                        if app.Create==0
                            createSigma(app);
                            app.Create=1;
                        end
                        medium(app);
                    case 'Gaussian'
                        if app.ErosionCreate==1
                            delete(app.Button_2);
                            delete(app.Button_3);
                            delete(app.Button_4);
                            app.ErosionCreate=0;
                        end
                        if app.Create==0
                            createSigma(app);
                            app.Create=1;
                        end
                        gaussianF(app);
                    case 'Median'
                        if app.ErosionCreate==1
                            delete(app.Button_2);
                            delete(app.Button_3);
                            delete(app.Button_4);
                            app.ErosionCreate=0;
                        end
                        if app.Create==1
                            %delete
                            delete(app.GaussianSlider);
                            delete(app.GaussianSliderLabel);
                            delete(app.FilterSliderLabel_2);
                            app.Create=0;
                        end
                        %realise
                        medianF(app);
                    case 'Morphological'
                        if strcmp(app.customize,'To Grey')~=1
                            if app.Create==1
                                %delete
                                delete(app.GaussianSlider);
                                delete(app.GaussianSliderLabel);
                                delete(app.FilterSliderLabel_2);
                                app.Create=0;
                            end
                            [file2,path]=uigetfile({'*.jpg';'*.png';'*.gif';'*.bmp';'*.tif'},'file selector');
                            if file2~=0
                                app.UIFigure.Visible="on";
                                pathImage= strcat(path,file2);
                                app.imageErosion=imread(pathImage);
                                imageEr=imresize(app.imageErosion,[155 215]);
                                if strcmp(app.Panel.Visible,'on')
                                    app.Panel.Visible='off';
                                    app.colorPeriority=app.colorPeriority+1;
                                    app.Modified=app.TmpEffect;
                                end
                                if strcmp(app.Panel_2.Visible,"on")==1
                                    app.Panel_2.Visible="off";
                                end
                                createErosion(app);
                                app.ErosionCreate=1;
                                app.ImagePrevious=app.TmpEffect;
                                TmpImage=imresize(app.TmpEffect,[155 215]);
                                app.Button_2.Icon=TmpImage;
                                app.Button_3.Icon=imageEr;
                                app.diffImage = imabsdiff(TmpImage, imageEr);
                                app.TmpEffect=app.diffImage;
                                app.Modified=app.TmpEffect;
                                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
                            else
                                app.TypeDropDown_3.Value=app.previous;
                                app.filter=app.previous;
                            end
                        else
                            app.TypeDropDown_3.Value=app.previous;
                            app.filter=app.previous;
                        end
                end
                app.previous=app.filter;
            end
        end

        % Value changed function: NoiseSlider
        function NoiseSliderValueChanged(app, event)
            app.Noise = app.NoiseSlider.Value;
            if and(app.file~=0 , app.Noise>0)
                switch app.filter
                    case 'Medium'
                        app.customize=app.customizePrevious;
                        app.TypeDropDown_2.Value=app.customizePrevious;
                        medium(app);
                    case 'Gaussian'
                        app.customize=app.customizePrevious;
                        app.TypeDropDown_2.Value=app.customizePrevious;
                        gaussianF(app);
                    case 'Median'
                        app.customize='To Grey';
                        app.TypeDropDown_2.Value='To Grey';
                        medianF(app);
                end
            end
        end

        % Value changed function: TypeDropDown_4
        function TypeDropDown_4ValueChanged(app, event)
            value = app.TypeDropDown_4.Value;
            if app.file~=0
                Tmp=app.TmpEffect;
                switch value
                    case 'Normal'
                        app.TmpEffect=Tmp;
                        DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
                    case 'Amplitude'
                        FS=fft2(double(Tmp));
                        module=abs(fftshift(FS)); 
                        Max=max(max(max(abs(module))));
                        imshow(module*255/Max,'Parent',app.UIAxes,'XData',[1 app.UIAxes.Position(3)],'YData',[1 app.UIAxes.Position(4)]);
                    case 'Phase'
                        FS=fft2(double(Tmp));
                        phase=angle(fftshift(FS));
                        imshow(phase,'Parent',app.UIAxes,'XData',[1 app.UIAxes.Position(3)],'YData',[1 app.UIAxes.Position(4)]);
                end
            end
        end

        % Callback function
        function Button_4Pushed(app, event)
            app.TmpEffect=app.diffImage;
            app.Modified=app.TmpEffect;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Value changed function: Button_5
        function Button_5ValueChanged(app, event)
            val=mod(app.periority,2);
            if strcmp(app.Panel_2.Visible,"on")==1
                app.Panel_2.Visible="off";
            else                 
                if strcmp(app.Panel.Visible,'on')
                    app.Panel.Visible='off';
                    app.colorPeriority=app.colorPeriority+1;
                    app.Modified=app.TmpEffect;
                end
                if strcmp(app.filter,'Morphological')==1
                    app.Button_2.Visible="off";
                    app.Button_3.Visible="off";
                end
                for value=0:4
                    switch value
                    case 0
                            app.periority=app.periority+1;
                            app.imageConv0=app.TmpEffect;
                            imageConv=imresize(app.TmpEffect,[84 145]);
                            app.Button_9.Icon=imageConv;
                        case 1
                            % Filter the image.  Need to cast to single so it can be floating point
                            % which allows the image to have negative values.
                            kernel=[1 1 1; 1 1 1; 1 1 1]/9;
                            imageConv = imfilter(app.TmpEffect, kernel);
                            app.imageConv1=imageConv;
                            imageConv=imresize(imageConv,[84 145]);
                            app.Button_10.Icon=imageConv;
                        case 2
                            kernel=[0 -1 0; -1 4 -1; 0 -1 0];
                            imageConv = imfilter(app.TmpEffect, kernel);
                            app.imageConv2=imageConv;
                            imageConv=imresize(imageConv,[84 145]);
                            app.Button_11.Icon=imageConv;
                        case 3
                            kernel=[0 -1 0; 1 5 -1; 0 -1 0];
                            imageConv = imfilter(app.TmpEffect, kernel);
                            app.imageConv3=imageConv;
                            imageConv=imresize(imageConv,[84 145]);
                            app.Button_12.Icon=imageConv;
                        case 4
                            kernel=[-2 -1 0; -1 1 1; 0 1 2];
                            imageConv = imfilter(app.TmpEffect, kernel);
                            app.imageConv4=imageConv;
                            imageConv=imresize(imageConv,[84 145]);
                            app.Button_13.Icon=imageConv;
                    end
                end
                app.Panel_2.Visible="on";
            end
        end

        % Value changed function: lightredSlider
        function lightredSliderValueChanged(app, event)
            app.lowR = app.lightredSlider.Value;
            app.TmpEffect=imadjust(app.Modified,[app.lowR app.lowG app.lowB; app.highR app.highG app.highB]);
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Value changed function: lightredSlider_2
        function lightredSlider_2ValueChanged(app, event)
            app.lowG = app.lightredSlider_2.Value;
            app.TmpEffect=imadjust(app.Modified,[app.lowR app.lowG app.lowB; app.highR app.highG app.highB]);
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Value changed function: lightredSlider_3
        function lightredSlider_3ValueChanged(app, event)
            app.lowG = app.lightredSlider_3.Value;
            app.TmpEffect=imadjust(app.Modified,[app.lowR app.lowG app.lowB; app.highR app.highG app.highB]);
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Value changed function: lightredSlider_6
        function lightredSlider_6ValueChanged(app, event)
            app.highR = app.lightredSlider_6.Value;
            app.TmpEffect=imadjust(app.Modified,[app.lowR app.lowG app.lowB; app.highR app.highG app.highB]);
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Value changed function: lightredSlider_5
        function lightredSlider_5ValueChanged(app, event)
            app.highG = app.lightredSlider_5.Value;
            app.TmpEffect=imadjust(app.Modified,[app.lowR app.lowG app.lowB; app.highR app.highG app.highB]);
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Value changed function: lightredSlider_4
        function lightredSlider_4ValueChanged(app, event)
            app.highB = app.lightredSlider_4.Value;
            app.TmpEffect=imadjust(app.Modified,[app.lowR app.lowG app.lowB; app.highR app.highG app.highB]);
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Value changed function: Button_6
        function Button_6ValueChanged(app, event)
            value=mod(app.colorPeriority,2);
            if strcmp(app.Panel_2.Visible,"on")==1
                app.Panel_2.Visible="off";
            end
            if value==0
                if strcmp(app.filter,'Morphological')==1
                    app.Button_2.Visible="off";
                    app.Button_3.Visible="off";
                end
                app.Panel.Visible="on";
            else
                app.Panel.Visible="off";
                if strcmp(app.filter,'Morphological')==1
                    app.Button_2.Visible="on";
                    app.Button_3.Visible="on";
                end
                app.Modified=app.TmpEffect;
            end
            app.colorPeriority=app.colorPeriority+1;
        end

        % Value changed function: Button_7
        function Button_7ValueChanged(app, event)
            if ~app.stack.isempty()
                app.TmpEffect=app.stack.pop();
                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
                app.nStack.push(app.stack.pop());
            end
        end

        % Value changed function: Button_8
        function Button_8ValueChanged(app, event)
            if ~app.nStack.isempty()
                app.TmpEffect=app.nStack.pop();
                DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
            end           
        end

        % Button pushed function: Button_9
        function Button_9Pushed(app, event)
            app.TmpEffect=app.imageConv0;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Button pushed function: Button_10
        function Button_10Pushed(app, event)
            app.TmpEffect=app.imageConv1;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Button pushed function: Button_11
        function Button_11Pushed(app, event)
            app.TmpEffect=app.imageConv2;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Button pushed function: Button_12
        function Button_12Pushed(app, event)
            app.TmpEffect=app.imageConv3;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end

        % Button pushed function: Button_13
        function Button_13Pushed(app, event)
            app.TmpEffect=app.imageConv4;
            DisplayHist(app,app.Red,app.Green,app.Blue,app.greyScale);
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Get the file path for locating images
            pathToMLAPP = fileparts(mfilename('fullpath'));

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [0.0196 0.0196 0.1804];
            app.UIFigure.Position = [100 100 827 502];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            app.UIAxes.XColor = [0.8 0.8 0.8];
            app.UIAxes.XTick = [];
            app.UIAxes.YColor = [0.8 0.8 0.8];
            app.UIAxes.YTick = [];
            app.UIAxes.Color = [0.0196 0.0196 0.1804];
            app.UIAxes.Position = [328 177 455 294];

            % Create TypeDropDownLabel_3
            app.TypeDropDownLabel_3 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_3.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDownLabel_3.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_3.FontName = 'Arial';
            app.TypeDropDownLabel_3.FontSize = 18;
            app.TypeDropDownLabel_3.FontColor = [1 1 1];
            app.TypeDropDownLabel_3.Position = [36 428 44 23];
            app.TypeDropDownLabel_3.Text = 'Type';

            % Create Button
            app.Button = uibutton(app.UIFigure, 'state');
            app.Button.ValueChangedFcn = createCallbackFcn(app, @ButtonValueChanged, true);
            app.Button.Icon = fullfile(pathToMLAPP, 'upload.png');
            app.Button.Text = '';
            app.Button.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button.FontColor = [0.0196 0.0196 0.1804];
            app.Button.Position = [237 389 84 62];

            % Create TypeDropDownLabel
            app.TypeDropDownLabel = uilabel(app.UIFigure);
            app.TypeDropDownLabel.HorizontalAlignment = 'right';
            app.TypeDropDownLabel.FontName = 'Arial';
            app.TypeDropDownLabel.FontSize = 18;
            app.TypeDropDownLabel.FontColor = [0.3922 0.8314 0.0745];
            app.TypeDropDownLabel.Position = [35 427 44 23];
            app.TypeDropDownLabel.Text = 'Type';

            % Create TypeDropDown
            app.TypeDropDown = uidropdown(app.UIFigure);
            app.TypeDropDown.Items = {'Original', 'Egalisation'};
            app.TypeDropDown.ValueChangedFcn = createCallbackFcn(app, @TypeDropDownValueChanged, true);
            app.TypeDropDown.FontName = 'Utsaah';
            app.TypeDropDown.FontSize = 18;
            app.TypeDropDown.FontColor = [0.8 0.8 0.8];
            app.TypeDropDown.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDown.Position = [88 426 100 24];
            app.TypeDropDown.Value = 'Original';

            % Create TypeDropDownLabel_4
            app.TypeDropDownLabel_4 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_4.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDownLabel_4.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_4.FontName = 'Arial';
            app.TypeDropDownLabel_4.FontSize = 18;
            app.TypeDropDownLabel_4.FontColor = [1 1 1];
            app.TypeDropDownLabel_4.Position = [35 386 87 23];
            app.TypeDropDownLabel_4.Text = 'Histogram';

            % Create TypeDropDownLabel_5
            app.TypeDropDownLabel_5 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_5.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_5.FontName = 'Arial';
            app.TypeDropDownLabel_5.FontSize = 18;
            app.TypeDropDownLabel_5.FontColor = [0.3922 0.8314 0.0745];
            app.TypeDropDownLabel_5.Position = [34 385 87 23];
            app.TypeDropDownLabel_5.Text = 'Histogram';

            % Create Switch
            app.Switch = uiswitch(app.UIFigure, 'slider');
            app.Switch.Items = {'On', 'Off'};
            app.Switch.ValueChangedFcn = createCallbackFcn(app, @SwitchValueChanged, true);
            app.Switch.FontColor = [0.8 0.8 0.8];
            app.Switch.Position = [152 386 45 20];

            % Create TypeDropDown_2
            app.TypeDropDown_2 = uidropdown(app.UIFigure);
            app.TypeDropDown_2.Items = {'RGB', 'Red', 'Green', 'Blue', 'To Grey'};
            app.TypeDropDown_2.ValueChangedFcn = createCallbackFcn(app, @TypeDropDown_2ValueChanged, true);
            app.TypeDropDown_2.FontName = 'Utsaah';
            app.TypeDropDown_2.FontSize = 18;
            app.TypeDropDown_2.FontColor = [0.8 0.8 0.8];
            app.TypeDropDown_2.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDown_2.Position = [132 344 100 24];
            app.TypeDropDown_2.Value = 'RGB';

            % Create TypeDropDownLabel_6
            app.TypeDropDownLabel_6 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_6.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDownLabel_6.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_6.FontName = 'Arial';
            app.TypeDropDownLabel_6.FontSize = 18;
            app.TypeDropDownLabel_6.FontColor = [1 1 1];
            app.TypeDropDownLabel_6.Position = [34 346 90 23];
            app.TypeDropDownLabel_6.Text = 'Customize';

            % Create TypeDropDownLabel_7
            app.TypeDropDownLabel_7 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_7.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_7.FontName = 'Arial';
            app.TypeDropDownLabel_7.FontSize = 18;
            app.TypeDropDownLabel_7.FontColor = [0.3922 0.8314 0.0745];
            app.TypeDropDownLabel_7.Position = [35 347 90 23];
            app.TypeDropDownLabel_7.Text = 'Customize';

            % Create TypeDropDown_3
            app.TypeDropDown_3 = uidropdown(app.UIFigure);
            app.TypeDropDown_3.Items = {'Medium', 'Gaussian', 'Median', 'Morphological'};
            app.TypeDropDown_3.ValueChangedFcn = createCallbackFcn(app, @TypeDropDown_3ValueChanged, true);
            app.TypeDropDown_3.FontName = 'Utsaah';
            app.TypeDropDown_3.FontSize = 18;
            app.TypeDropDown_3.FontColor = [0.8 0.8 0.8];
            app.TypeDropDown_3.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDown_3.Position = [90 303 120 24];
            app.TypeDropDown_3.Value = 'Median';

            % Create TypeDropDownLabel_8
            app.TypeDropDownLabel_8 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_8.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDownLabel_8.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_8.FontName = 'Arial';
            app.TypeDropDownLabel_8.FontSize = 18;
            app.TypeDropDownLabel_8.FontColor = [1 1 1];
            app.TypeDropDownLabel_8.Position = [36 303 45 23];
            app.TypeDropDownLabel_8.Text = 'Filter';

            % Create TypeDropDownLabel_9
            app.TypeDropDownLabel_9 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_9.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_9.FontName = 'Arial';
            app.TypeDropDownLabel_9.FontSize = 18;
            app.TypeDropDownLabel_9.FontColor = [0.3922 0.8314 0.0745];
            app.TypeDropDownLabel_9.Position = [37 304 45 23];
            app.TypeDropDownLabel_9.Text = 'Filter';

            % Create FilterSliderLabel_3
            app.FilterSliderLabel_3 = uilabel(app.UIFigure);
            app.FilterSliderLabel_3.HorizontalAlignment = 'right';
            app.FilterSliderLabel_3.FontSize = 18;
            app.FilterSliderLabel_3.FontColor = [0.8 0.8 0.8];
            app.FilterSliderLabel_3.Position = [30 265 51 23];
            app.FilterSliderLabel_3.Text = 'Noise';

            % Create NoiseSliderLabel
            app.NoiseSliderLabel = uilabel(app.UIFigure);
            app.NoiseSliderLabel.HorizontalAlignment = 'right';
            app.NoiseSliderLabel.FontSize = 18;
            app.NoiseSliderLabel.FontColor = [0 1 0];
            app.NoiseSliderLabel.Position = [29 266 51 23];
            app.NoiseSliderLabel.Text = 'Noise';

            % Create NoiseSlider
            app.NoiseSlider = uislider(app.UIFigure);
            app.NoiseSlider.Limits = [0 1];
            app.NoiseSlider.ValueChangedFcn = createCallbackFcn(app, @NoiseSliderValueChanged, true);
            app.NoiseSlider.FontColor = [0.8 0.8 0.8];
            app.NoiseSlider.Position = [93 276 218 3];

            % Create TypeDropDownLabel_10
            app.TypeDropDownLabel_10 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_10.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_10.FontName = 'Arial';
            app.TypeDropDownLabel_10.FontSize = 18;
            app.TypeDropDownLabel_10.FontColor = [1 1 1];
            app.TypeDropDownLabel_10.Position = [29 154 79 23];
            app.TypeDropDownLabel_10.Text = 'spectrum';

            % Create TypeDropDown_4
            app.TypeDropDown_4 = uidropdown(app.UIFigure);
            app.TypeDropDown_4.Items = {'Normal', 'Amplitude', 'Phase'};
            app.TypeDropDown_4.ValueChangedFcn = createCallbackFcn(app, @TypeDropDown_4ValueChanged, true);
            app.TypeDropDown_4.FontName = 'Utsaah';
            app.TypeDropDown_4.FontSize = 18;
            app.TypeDropDown_4.FontColor = [0.8 0.8 0.8];
            app.TypeDropDown_4.BackgroundColor = [0.0196 0.0196 0.1804];
            app.TypeDropDown_4.Position = [116 153 120 24];
            app.TypeDropDown_4.Value = 'Normal';

            % Create TypeDropDownLabel_11
            app.TypeDropDownLabel_11 = uilabel(app.UIFigure);
            app.TypeDropDownLabel_11.HorizontalAlignment = 'right';
            app.TypeDropDownLabel_11.FontName = 'Arial';
            app.TypeDropDownLabel_11.FontSize = 18;
            app.TypeDropDownLabel_11.FontColor = [0.3922 0.8314 0.0745];
            app.TypeDropDownLabel_11.Position = [30 155 79 23];
            app.TypeDropDownLabel_11.Text = 'spectrum';

            % Create PhotoEditorLabel
            app.PhotoEditorLabel = uilabel(app.UIFigure);
            app.PhotoEditorLabel.FontName = 'Rosewood Std Regular';
            app.PhotoEditorLabel.FontSize = 36;
            app.PhotoEditorLabel.FontColor = [0.3294 0.5686 0.1608];
            app.PhotoEditorLabel.Position = [37 31 233 49];
            app.PhotoEditorLabel.Text = 'Photo Editor';

            % Create AITAAYILabel
            app.AITAAYILabel = uilabel(app.UIFigure);
            app.AITAAYILabel.FontName = 'Orator Std';
            app.AITAAYILabel.FontSize = 18;
            app.AITAAYILabel.FontColor = [0.8 0.8 0.8];
            app.AITAAYILabel.Position = [108 18 81 24];
            app.AITAAYILabel.Text = 'AITAAYI';

            % Create AITAAYILabel_2
            app.AITAAYILabel_2 = uilabel(app.UIFigure);
            app.AITAAYILabel_2.FontName = 'Orator Std';
            app.AITAAYILabel_2.FontSize = 18;
            app.AITAAYILabel_2.FontColor = [0.3294 0.1333 0.1333];
            app.AITAAYILabel_2.Position = [109 19 81 24];
            app.AITAAYILabel_2.Text = 'AITAAYI';

            % Create Button_5
            app.Button_5 = uibutton(app.UIFigure, 'state');
            app.Button_5.ValueChangedFcn = createCallbackFcn(app, @Button_5ValueChanged, true);
            app.Button_5.Icon = 'next3.png';
            app.Button_5.Text = '';
            app.Button_5.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_5.FontColor = [0.0196 0.0196 0.1804];
            app.Button_5.Position = [782 290 35 39];

            % Create Button_6
            app.Button_6 = uibutton(app.UIFigure, 'state');
            app.Button_6.ValueChangedFcn = createCallbackFcn(app, @Button_6ValueChanged, true);
            app.Button_6.Icon = fullfile(pathToMLAPP, 'colors.png');
            app.Button_6.Text = '';
            app.Button_6.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_6.FontColor = [0.0196 0.0196 0.1804];
            app.Button_6.Position = [782 339 35 39];

            % Create Panel
            app.Panel = uipanel(app.UIFigure);
            app.Panel.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Panel.Position = [310 9 518 169];

            % Create lightredSlider
            app.lightredSlider = uislider(app.Panel);
            app.lightredSlider.Limits = [0 0.49];
            app.lightredSlider.ValueChangedFcn = createCallbackFcn(app, @lightredSliderValueChanged, true);
            app.lightredSlider.FontColor = [0.8 0.8 0.8];
            app.lightredSlider.Position = [98 150 140 3];
            app.lightredSlider.Value = 0.01;

            % Create lightredSlider_2
            app.lightredSlider_2 = uislider(app.Panel);
            app.lightredSlider_2.Limits = [0 0.49];
            app.lightredSlider_2.ValueChangedFcn = createCallbackFcn(app, @lightredSlider_2ValueChanged, true);
            app.lightredSlider_2.FontColor = [0.8 0.8 0.8];
            app.lightredSlider_2.Position = [98 95 140 3];
            app.lightredSlider_2.Value = 0.01;

            % Create lightredSlider_3
            app.lightredSlider_3 = uislider(app.Panel);
            app.lightredSlider_3.Limits = [0 0.49];
            app.lightredSlider_3.ValueChangedFcn = createCallbackFcn(app, @lightredSlider_3ValueChanged, true);
            app.lightredSlider_3.FontColor = [0.8 0.8 0.8];
            app.lightredSlider_3.Position = [98 40 140 3];
            app.lightredSlider_3.Value = 0.01;

            % Create lightredSlider_4
            app.lightredSlider_4 = uislider(app.Panel);
            app.lightredSlider_4.Limits = [0.5 0.99];
            app.lightredSlider_4.MajorTicks = [0.5 0.99];
            app.lightredSlider_4.ValueChangedFcn = createCallbackFcn(app, @lightredSlider_4ValueChanged, true);
            app.lightredSlider_4.FontColor = [0.8 0.8 0.8];
            app.lightredSlider_4.Position = [361 40 140 3];
            app.lightredSlider_4.Value = 0.51;

            % Create lightredSlider_5
            app.lightredSlider_5 = uislider(app.Panel);
            app.lightredSlider_5.Limits = [0.5 0.99];
            app.lightredSlider_5.MajorTicks = [0.5 0.99];
            app.lightredSlider_5.ValueChangedFcn = createCallbackFcn(app, @lightredSlider_5ValueChanged, true);
            app.lightredSlider_5.FontColor = [0.8 0.8 0.8];
            app.lightredSlider_5.Position = [361 95 140 3];
            app.lightredSlider_5.Value = 0.51;

            % Create lightredSlider_6
            app.lightredSlider_6 = uislider(app.Panel);
            app.lightredSlider_6.Limits = [0.5 0.99];
            app.lightredSlider_6.MajorTicks = [0.5 0.99];
            app.lightredSlider_6.ValueChangedFcn = createCallbackFcn(app, @lightredSlider_6ValueChanged, true);
            app.lightredSlider_6.FontColor = [0.8 0.8 0.8];
            app.lightredSlider_6.Position = [361 150 140 3];
            app.lightredSlider_6.Value = 0.51;

            % Create lightredLabel
            app.lightredLabel = uilabel(app.Panel);
            app.lightredLabel.FontSize = 18;
            app.lightredLabel.FontColor = [1 1 1];
            app.lightredLabel.Position = [4 140 75 23];
            app.lightredLabel.Text = 'light red';

            % Create lightredLabel_2
            app.lightredLabel_2 = uilabel(app.Panel);
            app.lightredLabel_2.FontSize = 18;
            app.lightredLabel_2.FontColor = [0.3922 0.8314 0.0745];
            app.lightredLabel_2.Position = [5 141 75 23];
            app.lightredLabel_2.Text = 'light red';

            % Create lightgreenLabel_2
            app.lightgreenLabel_2 = uilabel(app.Panel);
            app.lightgreenLabel_2.FontSize = 18;
            app.lightgreenLabel_2.FontColor = [1 1 1];
            app.lightgreenLabel_2.Position = [6 84 89 23];
            app.lightgreenLabel_2.Text = 'light green';

            % Create lightgreenLabel
            app.lightgreenLabel = uilabel(app.Panel);
            app.lightgreenLabel.FontSize = 18;
            app.lightgreenLabel.FontColor = [0.3922 0.8314 0.0745];
            app.lightgreenLabel.Position = [7 85 89 23];
            app.lightgreenLabel.Text = 'light green';

            % Create lightblueLabel_2
            app.lightblueLabel_2 = uilabel(app.Panel);
            app.lightblueLabel_2.FontSize = 18;
            app.lightblueLabel_2.FontColor = [1 1 1];
            app.lightblueLabel_2.Position = [9 29 77 23];
            app.lightblueLabel_2.Text = 'light blue';

            % Create lightblueLabel
            app.lightblueLabel = uilabel(app.Panel);
            app.lightblueLabel.FontSize = 18;
            app.lightblueLabel.FontColor = [0.3922 0.8314 0.0745];
            app.lightblueLabel.Position = [10 30 77 23];
            app.lightblueLabel.Text = 'light blue';

            % Create DarkredLabel_2
            app.DarkredLabel_2 = uilabel(app.Panel);
            app.DarkredLabel_2.FontSize = 18;
            app.DarkredLabel_2.FontColor = [1 1 1];
            app.DarkredLabel_2.Position = [262 139 75 23];
            app.DarkredLabel_2.Text = 'Dark red';

            % Create DarkredLabel
            app.DarkredLabel = uilabel(app.Panel);
            app.DarkredLabel.FontSize = 18;
            app.DarkredLabel.FontColor = [0.3922 0.8314 0.0745];
            app.DarkredLabel.Position = [263 140 75 23];
            app.DarkredLabel.Text = 'Dark red';

            % Create DarkblueLabel_2
            app.DarkblueLabel_2 = uilabel(app.Panel);
            app.DarkblueLabel_2.FontSize = 18;
            app.DarkblueLabel_2.FontColor = [1 1 1];
            app.DarkblueLabel_2.Position = [267 28 82 23];
            app.DarkblueLabel_2.Text = 'Dark blue';

            % Create DarkblueLabel
            app.DarkblueLabel = uilabel(app.Panel);
            app.DarkblueLabel.FontSize = 18;
            app.DarkblueLabel.FontColor = [0.3922 0.8314 0.0745];
            app.DarkblueLabel.Position = [268 27 82 23];
            app.DarkblueLabel.Text = 'Dark blue';

            % Create DarkgreenLabel_2
            app.DarkgreenLabel_2 = uilabel(app.Panel);
            app.DarkgreenLabel_2.FontSize = 18;
            app.DarkgreenLabel_2.FontColor = [1 1 1];
            app.DarkgreenLabel_2.Position = [264 83 94 23];
            app.DarkgreenLabel_2.Text = 'Dark green';

            % Create DarkgreenLabel
            app.DarkgreenLabel = uilabel(app.Panel);
            app.DarkgreenLabel.FontSize = 18;
            app.DarkgreenLabel.FontColor = [0.3922 0.8314 0.0745];
            app.DarkgreenLabel.Position = [265 84 94 23];
            app.DarkgreenLabel.Text = 'Dark green';

            % Create Button_7
            app.Button_7 = uibutton(app.UIFigure, 'state');
            app.Button_7.ValueChangedFcn = createCallbackFcn(app, @Button_7ValueChanged, true);
            app.Button_7.Icon = 'previous1.png';
            app.Button_7.Text = '';
            app.Button_7.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_7.FontColor = [0.0196 0.0196 0.1804];
            app.Button_7.Position = [4 461 35 39];

            % Create Button_8
            app.Button_8 = uibutton(app.UIFigure, 'state');
            app.Button_8.ValueChangedFcn = createCallbackFcn(app, @Button_8ValueChanged, true);
            app.Button_8.Icon = fullfile(pathToMLAPP, 'next.png');
            app.Button_8.Text = '';
            app.Button_8.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_8.FontColor = [0.0196 0.0196 0.1804];
            app.Button_8.Position = [44 461 35 39];

            % Create Panel_2
            app.Panel_2 = uipanel(app.UIFigure);
            app.Panel_2.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Panel_2.Position = [310 9 518 178];

            % Create Button_9
            app.Button_9 = uibutton(app.Panel_2, 'push');
            app.Button_9.ButtonPushedFcn = createCallbackFcn(app, @Button_9Pushed, true);
            app.Button_9.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_9.Position = [38 91 145 84];
            app.Button_9.Text = '';

            % Create Button_10
            app.Button_10 = uibutton(app.Panel_2, 'push');
            app.Button_10.ButtonPushedFcn = createCallbackFcn(app, @Button_10Pushed, true);
            app.Button_10.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_10.Position = [188 91 145 84];
            app.Button_10.Text = '';

            % Create Button_11
            app.Button_11 = uibutton(app.Panel_2, 'push');
            app.Button_11.ButtonPushedFcn = createCallbackFcn(app, @Button_11Pushed, true);
            app.Button_11.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_11.Position = [337 91 145 84];
            app.Button_11.Text = '';

            % Create Button_12
            app.Button_12 = uibutton(app.Panel_2, 'push');
            app.Button_12.ButtonPushedFcn = createCallbackFcn(app, @Button_12Pushed, true);
            app.Button_12.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_12.Position = [114 4 145 84];
            app.Button_12.Text = '';

            % Create Button_13
            app.Button_13 = uibutton(app.Panel_2, 'push');
            app.Button_13.ButtonPushedFcn = createCallbackFcn(app, @Button_13Pushed, true);
            app.Button_13.BackgroundColor = [0.0196 0.0196 0.1804];
            app.Button_13.Position = [263 4 145 84];
            app.Button_13.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = project_exported

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