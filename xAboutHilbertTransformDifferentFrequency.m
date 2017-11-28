% xAboutHilbertTransformDifferentFrequency.m
% �����20171106����һ
% �ı������źŵ�Ƶ�ʣ������������ڲ�������������ڲ�����Hilbert�任�Լ�Hilbert����λ��Ӱ��
% ver��---
close all;clear;

%% @_@{���û�������}*********************************************************
% ͼ�����Ʋ���
width=1024; height=800; period=128;

%% --��Ծ����Ƶ�ʱ��
stepFrequencyModulateFlag=0;
%% --�Գ���������Ƶ�ʱ��
symmetricalArcFrequencyModulateFlag=0;
%% --�ǶԳ���������Ƶ�ʱ��
asymmetricalArcFrequencyModulateFlag=0;
%% --�ԷǶԳ���������Ƶ���ź�[����������]��������λ����Hilbert�任����
asymmetricalArcFrequencyModulateEachPeriodFlag=0;
%% --�ǶԳ���������Ƶ�����ر��
asymmetricalArcFrequencyModulateContinuationFlag=0;
%% --�ԷǶԳ���������Ƶ���ź�[����������]��������λ����Hilbert�任����
asymmetricalArcFrequencyModulateEachPeriodFlag=1;

% �źŷ�Χ
numOfPeriods=8;
startOfSignal=1;endOfSignal=numOfPeriods*period;
lengthOfSignal=endOfSignal-startOfSignal+1;

% ����������
horizontalIndex=0:lengthOfSignal-1;

% xTick & xTickLabel
if mod(lengthOfSignal,period)==0
    xTick=zeros(1,numOfPeriods+1);
    xTickLabel=cell(1,numOfPeriods+1);
    for k=0:numOfPeriods
        xTick(k+1)=floor(k*period); xTickLabel{k+1}=num2str(xTick(k+1));
    end
    xTick(end)=lengthOfSignal-1; xTickLabel{end}=num2str(lengthOfSignal-1);
else
    xTick=zeros(1,numOfPeriods+2);
    xTickLabel=cell(1,numOfPeriods+2);
    for k=0:numOfPeriods
        xTick(k+1)=floor(k*period); xTickLabel{k+1}=num2str(xTick(k+1));
    end
    xTick(end)=lengthOfSignal-1; xTickLabel{end}=num2str(lengthOfSignal-1);
end
% yTick & yTickLabel
yTickNum=8;
yTick=zeros(1,yTickNum+1);
yTickLabel=cell(1,yTickNum+1);
yTick(yTickNum/2+1)=0;
yTickLabel{yTickNum/2+1}='0';
for k=1:yTickNum/2
    yTick(yTickNum/2+1+k)=floor( k*256/(yTickNum/2)); yTickLabel{yTickNum/2+1+k}=num2str(yTick(yTickNum/2+1+k)); 
    yTick(yTickNum/2+1-k)=floor(-k*256/(yTickNum/2)); yTickLabel{yTickNum/2+1-k}=num2str(yTick(yTickNum/2+1-k));
end
% xTickPart & xTickLabelPart for Fourier Spectrum
partNum=30;
xTickFourierSpectrum=zeros(1,partNum+1);
xTickLabelFourierSpectrum=cell(1,partNum+1);
for k=0:partNum/2
    xTickFourierSpectrum(partNum/2+k+1)=lengthOfSignal/2+1+k+k; xTickLabelFourierSpectrum{partNum/2+k+1}=num2str( k+k);
    xTickFourierSpectrum(partNum/2-k+1)=lengthOfSignal/2+1-k-k; xTickLabelFourierSpectrum{partNum/2-k+1}=num2str(-k-k);
end
xTickFourierSpectrum(partNum/2+1)=lengthOfSignal/2+1; xTickLabelFourierSpectrum{partNum/2+1}=num2str(0);

% ��λ�����ʾ��Ч����
upPhaseErrorBound=7; bottomPhaseErrorBound=-7;

% plot��������
plotLineType='';        % '' ʵ��
plotDottedLineType=':'; % ':'����

%% @_@{��Ծʽ����Ƶ��}******************************************************
% ��Ծ����Ƶ�ʱ��
if stepFrequencyModulateFlag==1
%% --����24����Ծʽ����Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllStepFrequency=cell(24,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    for i=1:lengthOfSignal
        if i<lengthOfSignal/2
%             fringeListAllStepFrequency{k}(:,i)=floor(255.0/2*(cos((i-1-sf)/period*2*pi)+1)/2);
            fringeListAllStepFrequency{k}(:,i)=floor(255.0/2*(cos((i-1-sf)/period*2*pi)+0)/2);
        else
            T1=period;T2=period*2;
            zz=(T1-T2)*(lengthOfSignal/2-1-sf)/T1;
%             fringeListAllStepFrequency{k}(:,i)=floor(255.0/2*(cos((i-1-sf-zz)/T2 *2*pi)+1)/2);
            fringeListAllStepFrequency{k}(:,i)=floor(255.0/2*(cos((i-1-sf-zz)/T2 *2*pi)+0)/2);
        end
    end
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalStepFrequency=SelectNStepFring(fringeListAllStepFrequency,moveNumPart);
% ������Hilbert�任
expectedHilbertOfFringeListFractionalStepFrequency=cell(size(fringeListFractionalStepFrequency));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    for i=1:lengthOfSignal
        if i<lengthOfSignal/2
            expectedHilbertOfFringeListFractionalStepFrequency{k}(:,i)=255.0/2*(sin((i-1-sf)/period*2*pi))/2;
        else
            T1=period;T2=period*2;
            zz=(T1-T2)*(lengthOfSignal/2-1-sf)/T1;
            expectedHilbertOfFringeListFractionalStepFrequency{k}(:,i)=255.0/2*(sin((i-1-sf-zz)/T2*2*pi))/2;
        end
    end
end

%% --�������������λ
wrappedPhaseAllStepFrequency=GetWrapPhase(fringeListAllStepFrequency,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalStepFrequency=GetWrapPhase(fringeListFractionalStepFrequency,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertStepFrequency=HilbertPerRow(fringeListFractionalStepFrequency,moveNumPart);
wrappedPhaseFractionalHilbertStepFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertStepFrequency,moveNumPart);

%% --��ʾ��Ծ�������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�źż���Hilbert�任
figure('name','Frequency Modulated by Step Function','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalStepFrequency{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalStepFrequency{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalStepFrequency{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-64-8 128+8]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    plot(imag(hilbert(fringeListFractionalStepFrequency{k}))-expectedHilbertOfFringeListFractionalStepFrequency{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Frequency Modulated by Step Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalStepFrequency    -wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Frequency Modulated by Step Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/��ԾʽHilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------stepFrequencyModulate-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);
end


%% @_@{�Գ���������Ƶ��}******************************************************
% �Գ���������Ƶ�ʱ��
if symmetricalArcFrequencyModulateFlag==1
%% --����24���Գ���������Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllSymmetricalArcFrequency=cell(24,1);
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllSymmetricalArcFrequency{k}=floor(255.0/2*(cos(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/lengthOfSignal))/period)+1)/2);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalSymmetricalArcFrequency=SelectNStepFring(fringeListAllSymmetricalArcFrequency,moveNumPart);
% ������Hilbert�任
expectedHilbertOfFringeListFractionalSymmetricalArcFrequency=cell(size(fringeListFractionalSymmetricalArcFrequency));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalSymmetricalArcFrequency{k}=255.0/2*(sin(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/lengthOfSignal))/period))/2;
end

%% --�������������λ
wrappedPhaseAllSymmetricalArcFrequency=GetWrapPhase(fringeListAllSymmetricalArcFrequency,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalSymmetricalArcFrequency=GetWrapPhase(fringeListFractionalSymmetricalArcFrequency,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertSymmetricalArcFrequency=HilbertPerRow(fringeListFractionalSymmetricalArcFrequency,moveNumPart);
wrappedPhaseFractionalHilbertSymmetricalArcFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertSymmetricalArcFrequency,moveNumPart);

%% --��ʾ�Գ������������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�Գ�����
symmetricalArcFrequencyFunction=(0:lengthOfSignal-1)+100*sin(2*pi*(0:lengthOfSignal-1)/lengthOfSignal);
figure('name','Symmetrical Arc Function','NumberTitle','off');
plot(symmetricalArcFrequencyFunction,plotLineType,'LineWidth',1,'MarkerSize',2);hold on;
plot((0:lengthOfSignal-1),'g-.','LineWidth',0.5);
title('Symmetrical Arc Function');
xlim([0,lengthOfSignal-1]);ylim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', xTick);set(gca, 'YTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
figure('name','Frequency Modulated by Symmetrical Arc Function','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalSymmetricalArcFrequency{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalSymmetricalArcFrequency{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalSymmetricalArcFrequency{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-64-8 128+8]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % ���߽�������ϱ�Ӧһ�£�����ֵΪ0��
    plot(zeros(1,lengthOfSignal),plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    % ���ܹ�ʽ����ȡ����Ӱ�죬��ʽ���������в���1������ֵ����
    % plot(imag(hilbert(fringeListFractionalSymmetricalArcFrequency{k}))-expectedHilbertOfFringeListFractionalSymmetricalArcFrequency{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Frequency Modulated by Symmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalSymmetricalArcFrequency    -wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Frequency Modulated by Symmetrical Arc Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/�Գ�����ʽHilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------symmetricalArcFrequencyModulate-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);

end


%% @_@{�ǶԳ���������Ƶ��,��������}******************************************************
% �ǶԳ���������Ƶ�ʱ��
if asymmetricalArcFrequencyModulateFlag==1
    asymmetricalArcFactor=1.25;
    lengthEnd=lengthOfSignal;
    
%% --����24���ǶԳ���������Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllAsymmetricalArcFrequency=cell(24,1);
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllAsymmetricalArcFrequency{k}=(255.0/2*(cos(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period)+0)/2);
    fringeListAllAsymmetricalArcFrequency{k}=fringeListAllAsymmetricalArcFrequency{k}(1:lengthEnd);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalAsymmetricalArcFrequency=SelectNStepFring(fringeListAllAsymmetricalArcFrequency,moveNumPart);
% ������Hilbert�任
expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency=cell(size(fringeListFractionalAsymmetricalArcFrequency));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=255.0/2*(sin(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period))/2;
    expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}(1:lengthEnd);
end

%% --�������������λ
wrappedPhaseAllAsymmetricalArcFrequency=GetWrapPhase(fringeListAllAsymmetricalArcFrequency,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalAsymmetricalArcFrequency=GetWrapPhase(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcFrequency=HilbertPerRow(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcFrequency,moveNumPart);

%% --��ʾ�ǶԳ������������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�ǶԳ�����
symmetricalArcFrequencyFunction=(0:lengthOfSignal-1)+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal));
figure('name','Asymmetrical Arc Function','NumberTitle','off');
plot(symmetricalArcFrequencyFunction,plotLineType,'LineWidth',1,'MarkerSize',2);hold on;
plot((0:lengthOfSignal-1),'g-.','LineWidth',0.5);
title('Asymmetrical Arc Function');
xlim([0,lengthOfSignal-1]);ylim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', xTick);set(gca, 'YTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
figure('name','Frequency Modulated by Asymmetrical Arc Function','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalAsymmetricalArcFrequency{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-128-8 128+8]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    plot(imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k}))-expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Frequency Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcFrequency    -wrappedPhaseAllAsymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcFrequency-wrappedPhaseAllAsymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Frequency Modulated by Asymmetrical Arc Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/�ǶԳ�����ʽHilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------asymmetricalArcFrequencyModulate-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);

end


%% @_@{���ԶԷǶԳƵ�Ƶ���з�ֵ����}***********************************
if asymmetricalArcFrequencyModulateContinuationFlag==1
asymmetricalArcFactor=1.5;
%% --����24���ǶԳ���������Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllAsymmetricalArcFrequency=cell(24,1);
% ��ʼ��λ
initialPhase=0;
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    sf=initialPhase-period*(k-1)/moveNumAll;
    fringeListAllAsymmetricalArcFrequency{k}=floor(255.0/2*(cos(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period)+0)/2);
    fringeListAllAsymmetricalArcFrequency{k}=fringeListAllAsymmetricalArcFrequency{k};
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalAsymmetricalArcFrequency=SelectNStepFring(fringeListAllAsymmetricalArcFrequency,moveNumPart);
% ������Hilbert�任
expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency=cell(size(fringeListFractionalAsymmetricalArcFrequency));
for k=1:moveNumPart
    sf=initialPhase-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=255.0/2*(sin(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period))/2;
    expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k};
end

%% --�������������λ
wrappedPhaseAllAsymmetricalArcFrequency=GetWrapPhase(fringeListAllAsymmetricalArcFrequency,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalAsymmetricalArcFrequency=GetWrapPhase(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcFrequency=HilbertPerRow(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcFrequency,moveNumPart);

%% --��ʾ�ǶԳ������������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�ǶԳ�����
symmetricalArcFrequencyFunction=(0:lengthOfSignal-1)+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal));
figure('name','Asymmetrical Arc Function','NumberTitle','off');
plot(horizontalIndex,symmetricalArcFrequencyFunction,plotLineType,'LineWidth',1,'MarkerSize',2);hold on;
plot((0:lengthOfSignal-1),'g-.','LineWidth',0.5);
title('Asymmetrical Arc Function');
xlim([0,lengthOfSignal-1]);ylim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', xTick);set(gca, 'YTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
figure('name','Frequency Modulated by Asymmetrical Arc Function','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(horizontalIndex,fringeListFractionalAsymmetricalArcFrequency{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(horizontalIndex,expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(horizontalIndex,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
    if k==moveNumPart
        legend({'Original Fringe','Expected HT','Actual HT'},'Location','NorthEast','Orientation','Horizontal','FontSize',9);
        set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    end
    
    xlim([0,lengthOfSignal-1]);ylim([-64-32 64+32]);grid on;
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

figure('name','Continuation Analysis','NumberTitle','off');
subplot(moveNumPart+1,1,1);hold on;
plot(horizontalIndex,wrappedPhaseFractionalAsymmetricalArcFrequency);
title('Wrapped Phase');
xlim([0,lengthOfSignal]);
ylim([-pi-pi/8,pi+pi/8]);grid on;
set(gca, 'XTick',xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick',-pi:pi/2:pi);
a=gca;
a.TickLabelInterpreter = 'latex';
S = sym(-pi:pi/2:pi); % S = sym(round(vpa(S/pi*2))*pi/2);
a.YTickLabel = strcat('$',arrayfun(@latex, S, 'UniformOutput', false),'$');

%% �����۵���λ�б߽����˵Ĳ���λ��(��Ӧ�������źŵĲ���)���������źŽ����������ڲ���
% ���غ���۵���λ
wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation=wrappedPhaseFractionalAsymmetricalArcFrequency;
%% ������(�Ҷ�)->>>>->>>>
% �����۵���λ������ұ߽���ٽ������˵�һ������λ��
wrappedPhaseEndPeakIndex=lengthOfSignal;
for p=lengthOfSignal-1:-1:1
    if wrappedPhaseFractionalAsymmetricalArcFrequency(p+1)-wrappedPhaseFractionalAsymmetricalArcFrequency(p)<-pi/2
        wrappedPhaseEndPeakIndex=p;
        break;
    end
end
fprintf('1st Index of Trough at the  End  of Wrapped Phase: %d\n',wrappedPhaseEndPeakIndex);
hold on;plot(wrappedPhaseEndPeakIndex-1,wrappedPhaseFractionalAsymmetricalArcFrequency(p),'ro');
text(wrappedPhaseEndPeakIndex+5,wrappedPhaseFractionalAsymmetricalArcFrequency(p),num2str(wrappedPhaseEndPeakIndex));

% ��������λֵ
wrappedPhaseEnd=wrappedPhaseFractionalAsymmetricalArcFrequency(end);
% ���ٽ������˲���λ�����������˶�Ӧ��λ������
continuationEndSinceFromIndex=0;
% ÿ�����ƽ�������Ҫ���ز���ĳ���
continuationEndLength=zeros(moveNumPart,1);
% �۵���λ���ɽ�����ӳ����ǰһ������ͬ��ֵ������֮��ľ��볤��(����>=0)
continuationEndMapDistance=0;
% ���ٽ������˲������һ��λ�ô���ʼ��������������һ��С�ڵ��ڽ�������λֵ��λ��ֵ
for p=wrappedPhaseEndPeakIndex-1:-1:1
    if wrappedPhaseFractionalAsymmetricalArcFrequency(p)<=wrappedPhaseEnd
        continuationEndSinceFromIndex=p+1;
        continuationEndMapDistance=wrappedPhaseEndPeakIndex-1-continuationEndSinceFromIndex+1;
        
        % ���������Ѿ�����λ���壬���ܻ������λֵ���ٽ������˲�����һ��λ�ô�����λֵҪ�󣬼�����λ���볤��
        if continuationEndMapDistance<0
            continuationEndSinceFromIndex=p-continuationEndMapDistance;
            continuationEndMapDistance=0;
        end
        break
    end
end

% ����̫�٣�δ�ҵ�λ�ã�ֱ�ӷ���
if continuationEndSinceFromIndex==0
    disp('##Error: continuationEndSinceFromIndex=0');
    return
end

% ���ˮƽ������,�Ա�������һ�������۵���λ�е�ӳ��λ��
plot([lengthOfSignal-1,continuationEndSinceFromIndex-1],[wrappedPhaseEnd,wrappedPhaseEnd],plotDottedLineType,'Color','g','LineWidth',1.5);
% ���۵���λ�У�����״����صĸ��ƽڶΣ�ע�ⲻ������λ�ķ�ֵ��
plot((continuationEndSinceFromIndex:wrappedPhaseEndPeakIndex-1)-1, ...
    wrappedPhaseFractionalAsymmetricalArcFrequency(continuationEndSinceFromIndex:wrappedPhaseEndPeakIndex-1),...
    plotDottedLineType,'Color','m','LineWidth',2);
% (��һ������)���۵���λ���������������״θ������أ���������Ϊ��ӳ��λ�����ٽ������˲��岨��(�����������)
wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation=[wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation,...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(continuationEndSinceFromIndex:wrappedPhaseEndPeakIndex-1)];
plot(lengthOfSignal-1:lengthOfSignal+continuationEndMapDistance-1,...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(lengthOfSignal:lengthOfSignal+continuationEndMapDistance),...
    plotDottedLineType,'Color','m','LineWidth',2);
% (�ڶ�������)�ο�ǰһ�����ز������ڽ����������ڸ�������,���ٽ������˲��岨��(���������)��������(�����������)
wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation=[wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation,...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(wrappedPhaseEndPeakIndex:lengthOfSignal+continuationEndMapDistance)];
plot(lengthOfSignal+continuationEndMapDistance-1:lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex,...
             wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(lengthOfSignal+continuationEndMapDistance:end),...
             plotDottedLineType,'Color','b','LineWidth',2);

xlim([0,lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex]);
fprintf('       Mapped Index at the  End  of Wrapped Phase: %d\n',continuationEndSinceFromIndex);
fprintf('Continuation Length at the  End  of Wrapped Phase: %d\n',continuationEndMapDistance);

% ������λ����С�κ��ٸ����۵���λ�ֳ����ε���ֵ�����ݸ���ֵλ�ô���Ӧ���������еڶ������ز���
fringeListContinuationFractionalAsymmetricalArcFrequency=cell(size(fringeListFractionalAsymmetricalArcFrequency));
for k=1:moveNumPart
    fringeListContinuationFractionalAsymmetricalArcFrequency{k}=fringeListFractionalAsymmetricalArcFrequency{k};
end
phaseSegmentThreshold=pi:-2*pi/moveNumPart:-pi+2*pi/moveNumPart;
for k=1:moveNumPart
    subplot(moveNumPart+1,1,k+1);hold on;
    % ԭʼ�����ź�
    plot(horizontalIndex,fringeListContinuationFractionalAsymmetricalArcFrequency{k},plotLineType,'LineWidth',1.0);
    % ����״����صĸ��ƽڶΣ�ӳ��λ�����ٽ������˲��岨��(�����������)
    plot((continuationEndSinceFromIndex:wrappedPhaseEndPeakIndex-1)-1,...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}(continuationEndSinceFromIndex:wrappedPhaseEndPeakIndex-1),...
        plotDottedLineType,'Color','m','LineWidth',2);
    % (��һ������)���������״θ������أ���������Ϊ����λӳ��λ������λ�ٽ������˲��岨��(�����������)
    % �˴����ؽ��е�һ�������ź�������������λ��
    fringeListContinuationFractionalAsymmetricalArcFrequency{k}=[fringeListContinuationFractionalAsymmetricalArcFrequency{k},...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}(continuationEndSinceFromIndex:wrappedPhaseEndPeakIndex-1)];
    plot(lengthOfSignal-1:lengthOfSignal+continuationEndMapDistance-1,...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}(lengthOfSignal:lengthOfSignal+continuationEndMapDistance),...
        plotDottedLineType,'Color','m','LineWidth',2);
    
    % (�ڶ�������)���۵���λ��λ�ֳ�moveNumPart�ӶΣ��������Ʋ���������ؽ������ز��룬���غ�Ľ�����λ���źŲ��ȴ�
    % �����۵���λ�ֳ����ε���ֵλ�ô���Ӧ���������еڶ������ز���
    if k==1 % ��һ�����Ʋο�ǰһ�����ز������ڽ���������������
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}=[fringeListContinuationFractionalAsymmetricalArcFrequency{k},...
            fringeListContinuationFractionalAsymmetricalArcFrequency{k}(wrappedPhaseEndPeakIndex:lengthOfSignal+continuationEndMapDistance)];
        plot(lengthOfSignal+continuationEndMapDistance-1:lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex,...
            fringeListContinuationFractionalAsymmetricalArcFrequency{k}(lengthOfSignal+continuationEndMapDistance:end),...
            plotDottedLineType,'Color','b','LineWidth',2);
    else % �������ƽ��в��ֽڶθ�������
        for p=wrappedPhaseEndPeakIndex+1:lengthOfSignal+continuationEndMapDistance
            if wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(p)>=phaseSegmentThreshold(k)
                fringeListContinuationFractionalAsymmetricalArcFrequency{k}=[fringeListContinuationFractionalAsymmetricalArcFrequency{k},...
                    fringeListContinuationFractionalAsymmetricalArcFrequency{k}(wrappedPhaseEndPeakIndex:p)];
                plot(lengthOfSignal+continuationEndMapDistance-1:lengthOfSignal+continuationEndMapDistance+p-wrappedPhaseEndPeakIndex,...
                    fringeListContinuationFractionalAsymmetricalArcFrequency{k}(lengthOfSignal+continuationEndMapDistance:end),...
                    plotDottedLineType,'Color','b','LineWidth',2);
                break;
            end
        end
    end
    
    % ÿ�����ƽ�������Ҫ���ز���ĳ���
    continuationEndLength(k)=length(fringeListContinuationFractionalAsymmetricalArcFrequency{k})-lengthOfSignal;
    
    title(sprintf('%d/%d Step of Original Fringe',k,moveNumPart));
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
    if k==moveNumPart
        set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    end
    
    xlim([0,length(fringeListContinuationFractionalAsymmetricalArcFrequency{1})]);ylim([-64-32 64+32]);grid on;
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end
% ������(�Ҷ�)-<<<<-<<<<

%% ��ʼ��(���)-<<<<-<<<<
% �����۵���λ�������߽���ٽ������˵�һ������λ�ã�
wrappedPhaseStartPeakIndex=1;
for p=1:1:lengthOfSignal-1
    if wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(p+1)-wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(p)<-pi/2
        wrappedPhaseStartPeakIndex=p;
        break;
    end
end
fprintf('1st Index of Trough at the Start of Wrapped Phase: %d\n',wrappedPhaseStartPeakIndex);
subplot(moveNumPart+1,1,1);
plot(wrappedPhaseStartPeakIndex-1,wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(p),'ro');
text(wrappedPhaseStartPeakIndex+5,wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(p),num2str(wrappedPhaseStartPeakIndex));

% ��ʼ����λֵ
wrappedPhaseStart=wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(1);
% ���ٽ���ʼ�˲���λ���Ҳ�����ʼ�˶�Ӧ��λ������
continuationStartSinceFromIndex=0;
% ÿ�����ƽ�������Ҫ���ز���ĳ���
continuationStartLength=zeros(moveNumPart,1);
% �۵���λ������ʼ��ӳ����ǰһ������ͬ��ֵ������֮��ľ��볤��(����>=0)
continuationStartMapDistance=0;
% ���ٽ���ʼ�˲������һ��λ�ô���ʼ��������������һ��С�ڵ�����ʼ����λֵ��λ��ֵ
for p=wrappedPhaseStartPeakIndex+1:1:lengthOfSignal-1
    if wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(p)>=wrappedPhaseStart
        continuationStartSinceFromIndex=p-1;
        continuationStartMapDistance=continuationStartSinceFromIndex-1-wrappedPhaseStartPeakIndex+1;
        
        % ����ʼ���Ѿ�����λ���壬���ܻ������λֵ���ٽ���ʼ�˲�����һ��λ�ô�����λֵҪ�󣬼�����λ���볤��
        if continuationStartMapDistance<0
            continuationStartSinceFromIndex=p-continuationStartMapDistance;
            continuationStartMapDistance=0;
        end      
        break
    end
end

% ���ˮƽ������,�Ա�������һ�������۵���λ�е�ӳ��λ��
subplot(moveNumPart+1,1,1);
plot([0,continuationStartSinceFromIndex-1],[wrappedPhaseStart,wrappedPhaseStart],plotDottedLineType,'Color','g','LineWidth',1.5);
% ���۵���λ�У�����״����صĸ��ƽڶΣ�ע�ⲻ������λ�ķ�ֵ��
plot((wrappedPhaseStartPeakIndex+1:continuationStartSinceFromIndex)-1, ...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(wrappedPhaseStartPeakIndex+1:continuationStartSinceFromIndex),...
    plotDottedLineType,'Color','m','LineWidth',2);
% (��һ������)���۵���λ��ʼ�����������״θ������أ���������Ϊ���ٽ���ʼ�˲��岨��(�����������)��ӳ��λ��
wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation=[wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(wrappedPhaseStartPeakIndex+1:continuationStartSinceFromIndex),...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation];
plot(-(continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex):1:0,...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(1:continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex+1),...
    plotDottedLineType,'Color','m','LineWidth',2);
% (�ڶ�������)�ο�ǰһ�����ز������ڽ����������ڸ�������,��ʼ�������ٽ���ʼ�˲���(���������)
wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation=[wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(1:continuationStartSinceFromIndex),...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation];
plot(-continuationStartSinceFromIndex*2+wrappedPhaseStartPeakIndex:1:-(continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex),...
    wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(1:continuationStartSinceFromIndex+1),...
    plotDottedLineType,'Color','b','LineWidth',2);

xlim([-continuationStartSinceFromIndex*2+wrappedPhaseStartPeakIndex,lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex]);
fprintf('       Mapped Index at the Start of Wrapped Phase: %d\n',continuationStartSinceFromIndex);
fprintf('Continuation Length at the Start of Wrapped Phase: %d\n',continuationStartMapDistance);

% �۵���λ�ֳ����ε���ֵ�����ݸ���ֵλ�ô���Ӧ���������еڶ������ز���
phaseSegmentThreshold=pi:-2*pi/moveNumPart:-pi+2*pi/moveNumPart;
for k=1:moveNumPart
    subplot(moveNumPart+1,1,k+1);hold on;
    % ����״����صĸ��ƽڶ�
    plot((wrappedPhaseStartPeakIndex+1:continuationStartSinceFromIndex)-1, ...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}(wrappedPhaseStartPeakIndex+1:continuationStartSinceFromIndex),...
        plotDottedLineType,'Color','m','LineWidth',2);
    % (��һ������)���ź���ʼ�����������״θ������أ���������Ϊ���ٽ���ʼ�˲��岨��(�����������)��ӳ��λ��
    fringeListContinuationFractionalAsymmetricalArcFrequency{k}=[fringeListContinuationFractionalAsymmetricalArcFrequency{k}(wrappedPhaseStartPeakIndex+1:continuationStartSinceFromIndex),...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}];
    plot(-(continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex):1:0,...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}(1:continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex+1),...
        plotDottedLineType,'Color','m','LineWidth',2);
    
    % (�ڶ�������)���۵���λ��λ�ֳ�moveNumPart�ӶΣ��������Ʋ���������ؽ������ز��룬���غ����ʼ��λ���źŲ��ȴ�
    % �����۵���λ�ֳ����ε���ֵλ�ô���Ӧ���������еڶ������ز���
    if k==1 % ��һ�����Ʋο�ǰһ�����ز������ڽ���������������
%         fringeListFractionalAsymmetricalArcFrequency{k}=[fringeListFractionalAsymmetricalArcFrequency{k}(1:continuationStartSinceFromIndex),...
%             fringeListFractionalAsymmetricalArcFrequency{k}];
%         plot(-continuationStartSinceFromIndex*2+wrappedPhaseStartPeakIndex:1:-(continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex),...
%             fringeListFractionalAsymmetricalArcFrequency{k}(1:continuationStartSinceFromIndex+1),...
%             plotDottedLineType,'Color','b','LineWidth',2);
    else % �������ƽ��в��ֽڶθ�������
        for p=2*continuationStartSinceFromIndex:-1:1
            if wrappedPhaseFractionalAsymmetricalArcFrequencyContinuation(p)<=phaseSegmentThreshold(k)
                fringeListContinuationFractionalAsymmetricalArcFrequency{k}=[fringeListContinuationFractionalAsymmetricalArcFrequency{k}(p:2*continuationStartSinceFromIndex),...
                    fringeListContinuationFractionalAsymmetricalArcFrequency{k}];
                plot(-(continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex)-(2*continuationStartSinceFromIndex-p)-1:-(continuationStartSinceFromIndex-wrappedPhaseStartPeakIndex),...
                    fringeListContinuationFractionalAsymmetricalArcFrequency{k}(1:2*continuationStartSinceFromIndex+1-p+1),...
                    plotDottedLineType,'Color','b','LineWidth',2);
                break;
            end
        end
    end
    
    % ÿ�����ƽ�������Ҫ���ز���ĳ���
    continuationStartLength(k)=length(fringeListContinuationFractionalAsymmetricalArcFrequency{k})-lengthOfSignal-continuationEndLength(k);

    title(sprintf('%d/%d Step of Original Fringe',k,moveNumPart));
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
    if k==moveNumPart
        set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    end
    
    xlim([-continuationStartSinceFromIndex*2+wrappedPhaseStartPeakIndex,lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex]);
    ylim([-64-32 64+32]);grid on;
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end
% ��ʼ��(���)-<<<<-<<<<

%% ��ʾ���غ�������źż���Hilbert�任
lengthOfContinuousSignal=zeros(moveNumPart,1);length(fringeListContinuationFractionalAsymmetricalArcFrequency{k});
htContinuousSignal=cell(size(fringeListContinuationFractionalAsymmetricalArcFrequency));
figure('name','Continuous Fringes & its Hilbert Transfrom (Frequency Modulated by Asymmetrical Arc Function)','NumberTitle','off');
for k=1:moveNumPart
    lengthOfContinuousSignal(k)=length(fringeListContinuationFractionalAsymmetricalArcFrequency{k});

    subplot(moveNumPart,1,k);
    % �����ź�
    plot(0:lengthOfSignal-1,fringeListContinuationFractionalAsymmetricalArcFrequency{k}(continuationStartLength(k)+1:continuationStartLength(k)+lengthOfSignal),...
        plotLineType,'Color','b','LineWidth',1.0);hold on;
    % ���غ��ʵ��Hilbert�任���
    htContinuousSignal{k}=imag(hilbert(fringeListContinuationFractionalAsymmetricalArcFrequency{k}));
    plot(0:lengthOfSignal-1,htContinuousSignal{k}(continuationStartLength(k)+1:continuationStartLength(k)+lengthOfSignal),...
        plotLineType,'Color','m','LineWidth',1.0);hold on;

    % ����Hilbert�任���
    plot(horizontalIndex,expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ԭʼʵ��Hilbert�任���
    plot(horizontalIndex,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k})),        plotLineType,'Color','g','LineWidth',1.0);

    title(sprintf('%d/%d Step of Continuous Fringes & its Hilbert Transfrom',k,moveNumPart));
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
    if k==moveNumPart
        set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
        legend('Original Fringe','Actual HT(Continuation)','Expected HT','Actual HT','Location','NorthEast','Orientation','Horizontal');
    end
    
    % ʹ�����߻��ƽ�����źż���Hilbert�任
    plot(-continuationStartLength(k):0,fringeListContinuationFractionalAsymmetricalArcFrequency{k}(1:continuationStartLength(k)+1),...
        plotDottedLineType,'Color','b','LineWidth',1.5);hold on;
    plot(lengthOfSignal-1:lengthOfContinuousSignal(k)-continuationStartLength(k)-1,fringeListContinuationFractionalAsymmetricalArcFrequency{k}(continuationStartLength(k)+lengthOfSignal:end),...
        plotDottedLineType,'Color','b','LineWidth',1.5);hold on;
    plot(-continuationStartLength(k):0,htContinuousSignal{k}(1:continuationStartLength(k)+1),...
        plotDottedLineType,'Color','m','LineWidth',1.5);hold on;
    plot(lengthOfSignal-1:lengthOfContinuousSignal(k)-continuationStartLength(k)-1,htContinuousSignal{k}(continuationStartLength(k)+lengthOfSignal:end),...
        plotDottedLineType,'Color','m','LineWidth',1.5);hold on;

    xlim([-continuationStartSinceFromIndex*2+wrappedPhaseStartPeakIndex,lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex]);
    ylim([-64-32 64+32]);grid on;
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
    
    % ��ȡHilbert�任������
    htContinuousSignal{k}=htContinuousSignal{k}(continuationStartLength(k)+1:continuationStartLength(k)+lengthOfSignal);

end

% ��ʾ����ǰ��Hilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT (Including Continuation)','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);hold on;
    plot(horizontalIndex,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k}))-expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
%     htContinuousSignal=imag(hilbert(fringeListContinuationFractionalAsymmetricalArcFrequency{k}));
    plot(horizontalIndex,htContinuousSignal{k}-expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    if k==moveNumPart
        set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
        legend('Original Fringe Error','Continuous Fringe Error','Location','NorthEast','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

%% --�����������غ��������Ƶ�Hilbert����λ
% fringeListFractionalHilbertStepFrequency=HilbertPerRow(fringeListFractionalStepFrequency,moveNumPart);
for k=1:moveNumPart
    htContinuousSignal{k}=-htContinuousSignal{k};
end
wrappedPhaseFractionalHilbertContinuous=GetWrapPhaseWithHilbert(htContinuousSignal,moveNumPart);

% ��ʾ������λ������Hilbert����λ���
figure('name','Continuous Phase Error (Frequency Modulated by Step Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcFrequency-wrappedPhaseAllAsymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ����Hilbert����λ���
wrappedErrorHTContinuous=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertContinuous-wrappedPhaseAllAsymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTContinuous,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Continuous Phase Error (Frequency Modulated by Step Function)');
legend('Space Phase Error','Continuous HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);


%% �������źŽ������߷�ת������Hilbert�任���ٽ�ȡHilbert�任������
fringeListContinuationFlipFractionalAsymmetricalArcFrequency=cell(size(fringeListContinuationFractionalAsymmetricalArcFrequency));
htContinuousFlipSignal=cell(size(fringeListContinuationFractionalAsymmetricalArcFrequency));
figure('name','Continuous Fringes & its Hilbert Transfrom (Frequency Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% �������ת
% for k=1:moveNumPart
%     flip0=fliplr(fringeListContinuationFractionalAsymmetricalArcFrequency{k});
%     fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}=[...
%         flip0(1)*2-flip0(2),...
%         flip0,...
%         fringeListContinuationFractionalAsymmetricalArcFrequency{k}(2:end),...
%         fringeListContinuationFractionalAsymmetricalArcFrequency{k}(end)*2-fringeListContinuationFractionalAsymmetricalArcFrequency{k}(end-1),...
%         flip0(1:end-1)];
%     
%     subplot(moveNumPart,1,k);hold on;
%     plot(0:lengthOfContinuousSignal(k),fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}(1:lengthOfContinuousSignal(k)+1),...
%         plotDottedLineType,'Color','b','LineWidth',1.0);hold on;
%     plot(lengthOfContinuousSignal(k):lengthOfContinuousSignal(k)*2,fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}(lengthOfContinuousSignal(k)+1:lengthOfContinuousSignal(k)*2+1),...
%         plotLineType,'Color','b','LineWidth',1.0);hold on;
%     plot(lengthOfContinuousSignal(k)*2:lengthOfContinuousSignal(k)*3-1,fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}(lengthOfContinuousSignal(k)*2+1:lengthOfContinuousSignal(k)*3),...
%         plotDottedLineType,'Color','b','LineWidth',1.0);hold on;
%     
%     title(sprintf('%d/%d Step of Continuous & Flip Fringes & its Hilbert Transfrom',k,moveNumPart));
%     %     xlim([-lengthOfContinuousSignal(k) lengthOfContinuousSignal(k)*2];
%     %     set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
%     %     if k==moveNumPart
%     %         set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
%     %     end
%     
%     htContinuousFlipSignal{k}=imag(hilbert(fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}));
%     plot(0:lengthOfContinuousSignal(k),htContinuousFlipSignal{k}(1:lengthOfContinuousSignal(k)+1),...
%         plotDottedLineType,'Color','m','LineWidth',1.0);hold on;
%     plot(lengthOfContinuousSignal(k):lengthOfContinuousSignal(k)*2,htContinuousFlipSignal{k}(lengthOfContinuousSignal(k)+1:lengthOfContinuousSignal(k)*2+1),...
%         plotLineType,'Color','m','LineWidth',1.0);hold on;
%     plot(lengthOfContinuousSignal(k)*2:lengthOfContinuousSignal(k)*3-1,htContinuousFlipSignal{k}(lengthOfContinuousSignal(k)*2+1:lengthOfContinuousSignal(k)*3),...
%         plotDottedLineType,'Color','m','LineWidth',1.0);hold on;
%     
%     % ��ȡ����
%     htContinuousFlipSignal{k}=htContinuousFlipSignal{k}(lengthOfContinuousSignal(k)+continuationStartLength(k)+1:lengthOfContinuousSignal(k)+continuationStartLength(k)+lengthOfSignal);
% end
% �����Ҳ෭ת
for k=1:moveNumPart
    flip0=fliplr(fringeListContinuationFractionalAsymmetricalArcFrequency{k});
    fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}=[...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k},...
        fringeListContinuationFractionalAsymmetricalArcFrequency{k}(end)*2-fringeListContinuationFractionalAsymmetricalArcFrequency{k}(end-1),...
        flip0(1:end-1)];
    
    subplot(moveNumPart,1,k);hold on;
    plot(0:lengthOfContinuousSignal(k),fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}(1:lengthOfContinuousSignal(k)+1),...
        plotLineType,'Color','b','LineWidth',1.0);hold on;
    plot(lengthOfContinuousSignal(k):lengthOfContinuousSignal(k)*2-1,fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}(lengthOfContinuousSignal(k)+1:lengthOfContinuousSignal(k)*2),...
        plotDottedLineType,'Color','b','LineWidth',1.0);hold on;
    
    title(sprintf('%d/%d Step of Continuous & Flip Fringes & its Hilbert Transfrom',k,moveNumPart));
    %     xlim([-lengthOfContinuousSignal(k) lengthOfContinuousSignal(k)*2];
    %     set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
    %     if k==moveNumPart
    %         set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    %     end
    
    htContinuousFlipSignal{k}=imag(hilbert(fringeListContinuationFlipFractionalAsymmetricalArcFrequency{k}));
    plot(0:lengthOfContinuousSignal(k),htContinuousFlipSignal{k}(1:lengthOfContinuousSignal(k)+1),...
        plotLineType,'Color','m','LineWidth',1.0);hold on;
    plot(lengthOfContinuousSignal(k):lengthOfContinuousSignal(k)*2-1,htContinuousFlipSignal{k}(lengthOfContinuousSignal(k)+1:lengthOfContinuousSignal(k)*2),...
        plotDottedLineType,'Color','m','LineWidth',1.0);hold on;
    
    % ��ȡ����
    htContinuousFlipSignal{k}=htContinuousFlipSignal{k}(continuationStartLength(k)+1:continuationStartLength(k)+lengthOfSignal);
end

% ��ʾ[���غ�]��&[���ؼ���ת��]��Hilbert�任�ԱȽ��
figure('name','Fringe Error between Expected HT and Actual HT (Including Continuation & Flip)','NumberTitle','off');
for k=1:moveNumPart
    lengthOfContinuousSignal(k)=length(fringeListContinuationFractionalAsymmetricalArcFrequency{k});

    subplot(moveNumPart,1,k);hold on;
    % �����ź�
    plot(horizontalIndex,fringeListContinuationFractionalAsymmetricalArcFrequency{k}(continuationStartLength(k)+1:continuationStartLength(k)+lengthOfSignal),...
        plotLineType,'Color','b','LineWidth',1.0);hold on;
    % ���غ��ʵ��Hilbert�任���
    plot(horizontalIndex,-htContinuousSignal{k},plotLineType,'Color','m','LineWidth',1.0);
    % ���ؼ���ת���ʵ��Hilbert�任���
    plot(horizontalIndex,htContinuousFlipSignal{k},plotLineType,'Color','r','LineWidth',1.5);

    % ����Hilbert�任���
    plot(horizontalIndex,expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);
    % ԭʼʵ��Hilbert�任���
    plot(horizontalIndex,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k})),        plotLineType,'Color','g','LineWidth',1.0);

    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT (Including Continuation & Flip)',k,moveNumPart));
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
    if k==moveNumPart
        set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
        legend('Original Fringe','Actual HT(Continuation)','Actual HT(Continuation & Flip)','Expected HT','Actual HT','Location','NorthEast','Orientation','Horizontal');
    end
    
    % ʹ�����߻��ƽ�����źż���Hilbert�任
    plot(-continuationStartLength(k):0,fringeListContinuationFractionalAsymmetricalArcFrequency{k}(1:continuationStartLength(k)+1),...
        plotDottedLineType,'Color','b','LineWidth',1.5);hold on;
    plot(lengthOfSignal-1:lengthOfContinuousSignal(k)-continuationStartLength(k)-1,fringeListContinuationFractionalAsymmetricalArcFrequency{k}(continuationStartLength(k)+lengthOfSignal:end),...
        plotDottedLineType,'Color','b','LineWidth',1.5);hold on;

    xlim([-continuationStartSinceFromIndex*2+wrappedPhaseStartPeakIndex,lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex]);
    ylim([-64-32 64+32]);grid on;
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾ[���غ�]��&[���ؼ���ת��]��Hilbert�任������Hilbert�任������źŲ�
figure('name','Hilbert Phase Error (Continuous & Flip Fringes)','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);hold on;
    % ���غ��ʵ��Hilbert�任����Ա�
    plot(horizontalIndex,-htContinuousSignal{k}-expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    % ���ؼ���ת���ʵ��Hilbert�任����Ա�
    plot(horizontalIndex,htContinuousFlipSignal{k}-expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotLineType,'Color','m','LineWidth',1.5);hold on;
%     % ԭʼʵ��Hilbert�任����Ա�
%     plot(horizontalIndex,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k})),        plotLineType,'Color','g','LineWidth',1.0);

    title(sprintf('%d/%d Step of Hilbert Phase Error (Continuous & Flip Fringes)',k,moveNumPart));
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',[]);
    if k==moveNumPart
        set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
        legend('Actual HT(Continuation)','Actual HT(Continuation & Flip)','Location','NorthEast','Orientation','Horizontal');
    end

    xlim([-continuationStartSinceFromIndex*2+wrappedPhaseStartPeakIndex,lengthOfSignal+continuationEndMapDistance+lengthOfSignal+continuationEndMapDistance-wrappedPhaseEndPeakIndex]);
%     ylim([-64-32 64+32]);
    grid on;
%     set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end


%% --�����������ؼ���ת���������Ƶ�Hilbert����λ
% fringeListFractionalHilbertStepFrequency=HilbertPerRow(fringeListFractionalStepFrequency,moveNumPart);
for k=1:moveNumPart
    htContinuousFlipSignal{k}=-htContinuousFlipSignal{k};
end
wrappedPhaseFractionalHilbertContinuousFlip=GetWrapPhaseWithHilbert(htContinuousFlipSignal,moveNumPart);

% ��ʾ������λ�����ط�תHilbert����λ���
figure('name','Continuous & Flip Phase Error (Frequency Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcFrequency-wrappedPhaseAllAsymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ����Hilbert����λ���
wrappedErrorHTContinuousFlip=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertContinuousFlip-wrappedPhaseAllAsymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTContinuousFlip,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Continuous & Flip Phase Error (Frequency Modulated by Step Function)');
legend('Space Phase Error','Continuous & Flip HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end

%% @_@{�ԷǶԳ���������Ƶ���ź�[����������]��������λ����Hilbert�任����}********************
% �ǶԳ���������Ƶ��[����������]����λ����Hilbert�任�������
if asymmetricalArcFrequencyModulateEachPeriodFlag==1
asymmetricalArcFactor=1.25;
lengthEnd=lengthOfSignal;
    
%% --����24���ǶԳ���������Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllAsymmetricalArcFrequency=cell(24,1);
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllAsymmetricalArcFrequency{k}=(255.0/2*(cos(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period)+0)/2);
    fringeListAllAsymmetricalArcFrequency{k}=fringeListAllAsymmetricalArcFrequency{k}(1:lengthEnd);
end


%% --�������������λ
wrappedPhaseAllAsymmetricalArcFrequency=GetWrapPhase(fringeListAllAsymmetricalArcFrequency,moveNumAll);

%% --���������۵���λ��������ѡ���ź�
periodNumber=0;
eachPeriodFringeStartIndex=zeros(1,1);
for p=1:lengthEnd-1
    if wrappedPhaseAllAsymmetricalArcFrequency(p+1)-wrappedPhaseAllAsymmetricalArcFrequency(p)<-pi/2
        periodNumber=periodNumber+1;
        eachPeriodFringeStartIndex(periodNumber)=p+1;
    end
end

% ��ȡ�ź�
for k=1:moveNumAll
    fringeListAllAsymmetricalArcFrequency{k}=fringeListAllAsymmetricalArcFrequency{k}(eachPeriodFringeStartIndex(1):eachPeriodFringeStartIndex(end)-1);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalAsymmetricalArcFrequency=SelectNStepFring(fringeListAllAsymmetricalArcFrequency,moveNumPart);
% ������Hilbert�任
expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency=cell(size(fringeListFractionalAsymmetricalArcFrequency));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=255.0/2*(sin(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period))/2;
    expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}(eachPeriodFringeStartIndex(1):eachPeriodFringeStartIndex(end)-1);
end

% ���Ĳ���ֵ
lengthOfSignal=eachPeriodFringeStartIndex(end)-eachPeriodFringeStartIndex(1);
lengthEnd=lengthOfSignal;
eachPeriodFringeStartIndex=eachPeriodFringeStartIndex-eachPeriodFringeStartIndex(1)+1;
eachPeriodFringeStartIndex(end)=eachPeriodFringeStartIndex(end)-1;

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalAsymmetricalArcFrequency=GetWrapPhase(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcFrequency=HilbertPerRow(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcFrequency,moveNumPart);

%% --��ʾ�ǶԳ������������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�ǶԳ�����
symmetricalArcFrequencyFunction=(0:lengthOfSignal-1)+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal));
figure('name','Asymmetrical Arc Function','NumberTitle','off');
plot(symmetricalArcFrequencyFunction,plotLineType,'LineWidth',1,'MarkerSize',2);hold on;
plot((0:lengthOfSignal-1),'g-.','LineWidth',0.5);
title('Asymmetrical Arc Function');
xlim([0,lengthOfSignal-1]);ylim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', xTick);set(gca, 'YTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
figure('name','Frequency Modulated by Asymmetrical Arc Function','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalAsymmetricalArcFrequency{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-128-8 128+8]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    plot(imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{k}))-expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ�����۵���λ
figure('name','Wrapped Phase','NumberTitle','off');
plot(wrappedPhaseAllAsymmetricalArcFrequency,plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Wrapped Phase');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ����ʵ����������ʾ��1�������źš�Hilbert�任
figure('name','Each Period of First Step Fringe Modulated by Asymmetrical Arc Function','NumberTitle','off');
% htFlip=zeros(1,length(fringeListFractionalAsymmetricalArcFrequency{1}));
for p=1:periodNumber-1
    if mod(p,2)==1
        % �����������ź�
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1,fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)),...
            plotLineType,'Color',[0,128,0]/255,'LineWidth',1.0);hold on;   
        % ȫ��Hilbert�任
        if p==1
            plot(0:lengthEnd-1,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{1})),        plotLineType,'Color','b','LineWidth',1.0);hold on;
        end

        % ����Hilbert�任
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1,expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)),...
            plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
        % ʵ��Hilbert�任���
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1-2,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)-2))),...
            plotLineType,'Color',[0,206,209]/255,'LineWidth',1.0);hold on;
        
        % ����
        htFlip=imag(hilbert(...
            [fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)-1),...
            fliplr(fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)-2))]));
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1-2,htFlip(1:eachPeriodFringeStartIndex(p+1)-1-eachPeriodFringeStartIndex(p)),...
            plotLineType,'Color',[255,0,0]/255,'LineWidth',1.0);hold on;
    else
        % �����������ź�
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1,fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)),...
            plotDottedLineType,'Color',[0,128,0]/255,'LineWidth',1.5);hold on;
        % ����Hilbert�任
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1,expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)),...
            plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
        % ʵ��Hilbert�任���
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1-2,imag(hilbert(fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)-2))),...
            plotLineType,'Color',[0,206,209]/255,'LineWidth',1.0);hold on;
        
        % ����
        htFlip=imag(hilbert(...
            [fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)-1),...
            fliplr(fringeListFractionalAsymmetricalArcFrequency{1}(eachPeriodFringeStartIndex(p):eachPeriodFringeStartIndex(p+1)-2))]));
        plot(eachPeriodFringeStartIndex(p)-1:eachPeriodFringeStartIndex(p+1)-1-2,htFlip(1:eachPeriodFringeStartIndex(p+1)-1-eachPeriodFringeStartIndex(p)),...
            plotLineType,'Color',[255,0,0]/255,'LineWidth',1.0);hold on;
    end
    
    if p==1
        legend('Original Fringe','All Actual HT','All Expected HT','Actual HT (Per Period)','Truncated Flip HT (Per Period)','Location','SouthOutside','Orientation','Horizontal');
    end
end
title('Each Period of First Step Fringe Modulated by Asymmetrical Arc Function');
xlim([0,lengthOfSignal-1]);ylim([-64-16 64+16]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

end



