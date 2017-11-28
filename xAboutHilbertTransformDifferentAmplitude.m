% xAboutHilbertTransformDifferentAmplitude.m
% �����20171102������
% �ı������źŵĵ��ƶȣ������������ڲ�������������ڲ�����Hilbert�任�Լ�Hilbert����λ��Ӱ��
% ver��---
close all;clear;

%% @_@{���û�������}*************************************************
% ͼ�����Ʋ���
width=1280; height=800; period=128;

%% --���ȵ���
% ��Ծ���Ʒ��ȱ��
stepFunctionModulateFlag=1;
% �Գ��������ε��Ʒ��ȱ��
symmetricalArcModulateFlag=1;
% �ǶԳ��������ε��Ʒ��ȱ��
asymmetricalArcModulateFlag=1;

% �źŷ�Χ
numOfPeriods=8;
startOfSignal=1;
endOfSignal=startOfSignal+period*numOfPeriods-1;
lengthOfSignal=endOfSignal-startOfSignal+1;
% xTick & xTickLabel
xTick=zeros(1,numOfPeriods+1);
xTickLabel=cell(1,numOfPeriods+1);
for xt=0:numOfPeriods
    xTick(xt+1)=floor(xt*period); xTickLabel{xt+1}=num2str(xTick(xt+1));
end
xTick(end)=lengthOfSignal-1; xTickLabel{end}=num2str(lengthOfSignal-1);
% yTick & yTickLabel
yTickNum=8;
yTick=zeros(1,yTickNum+1);
yTickLabel=cell(1,yTickNum+1);
yTick(yTickNum/2+1)=0;
yTickLabel{yTickNum/2+1}='0';
for xt=1:yTickNum/2
    yTick(yTickNum/2+1+xt)=floor( xt*256/(yTickNum/2)); yTickLabel{yTickNum/2+1+xt}=num2str(yTick(yTickNum/2+1+xt)); 
    yTick(yTickNum/2+1-xt)=floor(-xt*256/(yTickNum/2)); yTickLabel{yTickNum/2+1-xt}=num2str(yTick(yTickNum/2+1-xt));
end
% xTickPart & xTickLabelPart for Fourier Spectrum
partNum=16;
xTickFourierSpectrum=zeros(1,partNum+1);
xTickLabelFourierSpectrum=cell(1,partNum+1);
for xt=0:partNum/2
    xTickFourierSpectrum(partNum/2+xt+1)=lengthOfSignal/2+1+xt+xt; xTickLabelFourierSpectrum{partNum/2+xt+1}=num2str(( xt+xt)*period/8);
    xTickFourierSpectrum(partNum/2-xt+1)=lengthOfSignal/2+1-xt-xt; xTickLabelFourierSpectrum{partNum/2-xt+1}=num2str((-xt-xt)*period/8);
end
xTickFourierSpectrum(partNum/2+1)=lengthOfSignal/2+1; xTickLabelFourierSpectrum{partNum/2+1}=num2str(0);

% ��λ�����ʾ��Ч����
upPhaseErrorBound=2; bottomPhaseErrorBound=-2;

% plot��������
plotLineType='';        % '' ʵ��
plotDottedLineType=':'; % ':'����

%% @_@{����24��ȫ������ͼ��(��һ����)}*******************************
%% --����24��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
% -��λ����������ź�
moveNumAll=24;
fringeListAllUnit=cell(moveNumAll,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllUnit{k} = floor(255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+1)/2);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractional=SelectNStepFring(fringeListAllUnit,moveNumPart);

%% --�������������λ
wrappedPhaseAll=GetWrapPhase(fringeListAllUnit,moveNumAll);
AB=GetABNormal(fringeListAllUnit,wrappedPhaseAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractional=GetWrapPhase(fringeListFractional,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbert=HilbertPerRow(fringeListFractional,moveNumPart);
wrappedPhaseFractionalHilbert=GetWrapPhaseWithHilbert(fringeListFractionalHilbert,moveNumPart);

%% --��ʾͼ��
% ��ʾ�źż���Hilbert�任
figure('name','Original Fringe','NumberTitle','off');
plot(fringeListFractional{2});hold on;
plot(imag(hilbert(fringeListFractional{1})),plotLineType,'MarkerSize',2);
title('Original Fringe and its Hilbert Transform');
legend('Original Fringe','HT','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);


%% @_@{��Ծʽ���Ʒ���}***********************************************
if stepFunctionModulateFlag==1
%% --���������źŷ���Ϊ��ȫ�Ұ��Ծ״̬
% ��Ծ����
filterStepAmplitude=[ones(1,lengthOfSignal/2) 2*ones(1,lengthOfSignal/2)];
fringeListAllStepAmplitude=cell(size(fringeListAllUnit));
fringeListFractionalStepAmplitude=cell(size(fringeListFractional));
% ������Hilbert�任
expectedHilbertOfFringeListFractionalStepAmplitude=cell(size(fringeListFractional));
for k=1:moveNumAll
    fringeListAllStepAmplitude{k}=floor((fringeListAllUnit{k}-255.0/4).*filterStepAmplitude+255.0/2);
end
for k=1:moveNumPart
    fringeListFractionalStepAmplitude{k}=floor((fringeListFractional{k}-255.0/4).*filterStepAmplitude+255.0/2);
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalStepAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterStepAmplitude;
end

%% --�������������λ
wrappedPhaseAllStepAmplitude=GetWrapPhase(fringeListAllStepAmplitude,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalStepAmplitude=GetWrapPhase(fringeListFractionalStepAmplitude,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertStepAmplitude=HilbertPerRow(fringeListFractionalStepAmplitude,moveNumPart);
wrappedPhaseFractionalHilbertStepAmplitude=GetWrapPhaseWithHilbert(fringeListFractionalHilbertStepAmplitude,moveNumPart);

%% --��ʾ��Ծ�������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ��Ծ��������Hilbert�任
htStepAmplitudeFilter=imag(hilbert(filterStepAmplitude));
figure('name','Step Function and its Hilbert Transform','NumberTitle','off');
plot(filterStepAmplitude,  plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
plot(htStepAmplitudeFilter,plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Step Function and its Hilbert Transform');
legend('Step Function','HT','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
% ��ʾ��Ծ������FourierƵ��
figure('name','Fourier Spectrum of Step Function','NumberTitle','off');
plot(abs(fftshift(fft(filterStepAmplitude))),plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Fourier Spectrum of Step Function');
xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);grid on;
set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);

% ��ʾ�źż���Hilbert�任
figure('name','Amplitude Modulated by Step Function','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalStepAmplitude{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalStepAmplitude{k}
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalStepAmplitude{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-160 256]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    plot(imag(hilbert(fringeListFractionalStepAmplitude{k}))-expectedHilbertOfFringeListFractionalStepAmplitude{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Amplitude Modulated by Step Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalStepAmplitude-wrappedPhaseAllStepAmplitude,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertStepAmplitude-wrappedPhaseAllStepAmplitude,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Amplitude Modulated by Step Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/��ԾʽHilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------stepAmplitudeModulate-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);

end

%% @_@{�Գ��������ε��Ʒ���}****************************************
if symmetricalArcModulateFlag==1
%% --�ԶԳ��������κ������������ź�
% �Գ��������κ���
arcCenter=0.5;
filterSymmetricalArcAmplitude=1-2.5*((0:lengthOfSignal-1)/lengthOfSignal-arcCenter).^2;
fringeListAllSymmetricalArcAmplitude=cell(size(fringeListAllUnit));
fringeListFractionalSymmetricalArcAmplitude=cell(size(fringeListFractional));
% ������Hilbert�任
expectedHilbertOfFringeListFractionalSymmetricalArcAmplitude=cell(size(fringeListFractional));
for k=1:moveNumAll
    fringeListAllSymmetricalArcAmplitude{k}=floor(fringeListAllUnit{k}.*filterSymmetricalArcAmplitude);
end
for k=1:moveNumPart
    fringeListFractionalSymmetricalArcAmplitude{k}=floor(fringeListFractional{k}.*filterSymmetricalArcAmplitude);
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalSymmetricalArcAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterSymmetricalArcAmplitude;
end

%% --�������������λ
wrappedPhaseAllSymmetricalArcAmplitude=GetWrapPhase(fringeListAllSymmetricalArcAmplitude,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalSymmetricalArcAmplitude=GetWrapPhase(fringeListFractionalSymmetricalArcAmplitude,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertSymmetricalArcAmplitude=HilbertPerRow(fringeListFractionalSymmetricalArcAmplitude,moveNumPart);
wrappedPhaseFractionalHilbertSymmetricalArcAmplitude=GetWrapPhaseWithHilbert(fringeListFractionalHilbertSymmetricalArcAmplitude,moveNumPart);

%% --��ʾ�Գ��������κ������������������źż���Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš��Գ��������κ��������ƺ����Ϻ���
figure('name','Symmetrical Arc Function','NumberTitle','off');
plot(filterSymmetricalArcAmplitude, plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Symmetrical Arc Function');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name','1/4 Step of Original Fringe & Modulated Signal by Symmetrical Arc Function','NumberTitle','off');
plot(fringeListFractional{1},                       plotLineType,'LineWidth',1.5,'MarkerSize',2);hold on;
plot(fringeListFractionalSymmetricalArcAmplitude{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title('1/4 Step of Original Fringe & Modulated Signal by Symmetrical Arc Function');
legend('Fringe Signal','Modulated Signal','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-32,160]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% �ֱ���ʾԭʼ�źš����ƺ����Ϻ������Գ��������κ�����Fourier�任
figure('name','Fourier Transform of Fringe Signal, Modulated Signal, Symmetrical Arc Function','NumberTitle','off');
% ԭʼ�ź�
subplot(3,1,1)
plot(abs(fftshift(fft(fringeListFractional{1}))),                       plotLineType,'LineWidth',1,'MarkerSize',2);
title('Fourier Spectrum of Fringe Signal');
xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);ylim([-2*10000,8*10000]);grid on;
set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);
% ���ƺ����Ϻ���
subplot(3,1,2)
plot(abs(fftshift(fft(fringeListFractionalSymmetricalArcAmplitude{1}))),plotLineType,'LineWidth',1,'MarkerSize',2);
title('Fourier Spectrum of Modulated Signal');
xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);ylim([-2*10000,8*10000]);grid on;
set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);
% �Գ��������κ���
subplot(3,1,3)
plot(abs(fftshift(fft(filterSymmetricalArcAmplitude))),              plotLineType,'LineWidth',1,'MarkerSize',2);
title('Fourier Spectrum of Symmetrical Arc Function');
xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);grid on;
set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);

% ��ʾ�Գ��������κ�������Hilbert�任
htSymmetricalArcAmplitudeFilter=imag(hilbert(filterSymmetricalArcAmplitude));
figure('name','Symmetrical Arc Function and its Hilbert Transform','NumberTitle','off');
plot(filterSymmetricalArcAmplitude,                 plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
plot(htSymmetricalArcAmplitudeFilter,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
title('Symmetrical Arc Function and its Hilbert Transform');
legend('Symmetrical Arc Function ','HT','Location','SouthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
figure('name','Amplitude Modulated by Symmetrical Arc Function','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalSymmetricalArcAmplitude{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalSymmetricalArcAmplitude{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalSymmetricalArcAmplitude{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-64-8 128]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    plot(imag(hilbert(fringeListFractionalSymmetricalArcAmplitude{k}))-expectedHilbertOfFringeListFractionalSymmetricalArcAmplitude{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Amplitude Modulated by Symmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalSymmetricalArcAmplitude    -wrappedPhaseAllSymmetricalArcAmplitude,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertSymmetricalArcAmplitude-wrappedPhaseAllSymmetricalArcAmplitude,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Amplitude Modulated by Symmetrical Arc Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/��ԾʽHilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------symmetricalArcModulate-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);
end

%% @_@{�ǶԳ��������ε��Ʒ���}**************************************
if asymmetricalArcModulateFlag==1
%% --�ԷǶԳ��������κ������������ź�
% �ǶԳ��������κ���
arcCenter=0.625;
filterAsymmetricalArcAmplitude=1-1.0*((0:lengthOfSignal-1)/lengthOfSignal-arcCenter).^2;
fringeListAllAsymmetricalArcAmplitude=cell(size(fringeListAllUnit));
fringeListFractionalAsymmetricalArcAmplitude=cell(size(fringeListFractional));
% ������Hilbert�任
expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude=cell(size(fringeListFractional));
for k=1:moveNumAll
    fringeListAllAsymmetricalArcAmplitude{k}=floor(fringeListAllUnit{k}.*filterAsymmetricalArcAmplitude);
end
for k=1:moveNumPart
    fringeListFractionalAsymmetricalArcAmplitude{k}=floor(fringeListFractional{k}.*filterAsymmetricalArcAmplitude);
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterAsymmetricalArcAmplitude;
end

%% --�������������λ
wrappedPhaseAllAsymmetricalArcAmplitude=GetWrapPhase(fringeListAllAsymmetricalArcAmplitude,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalAsymmetricalArcAmplitude=GetWrapPhase(fringeListFractionalAsymmetricalArcAmplitude,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcAmplitude=HilbertPerRow(fringeListFractionalAsymmetricalArcAmplitude,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcAmplitude=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcAmplitude,moveNumPart);

%% --��ʾ�ǶԳ��������κ������������������źż���Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš��ԳƷ��������κ��������ƺ����Ϻ���
figure('name','Asymmetrical Arc Function','NumberTitle','off');
plot(filterAsymmetricalArcAmplitude, plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Asymmetrical Arc Function');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name','1/4 Step of Original Fringe & Modulated Signal by Asymmetrical Arc Function','NumberTitle','off');
plot(fringeListFractional{1},                        plotLineType,'LineWidth',1.5,'MarkerSize',2);hold on;
plot(fringeListFractionalAsymmetricalArcAmplitude{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title('1/4 Step of Original Fringe & Modulated Signal by Asymmetrical Arc Function');
legend('Fringe Signal','Modulated Signal','Location','NorthWest');
xlim([0,lengthOfSignal-1]);ylim([-32,160]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
 
% �ֱ���ʾԭʼ�źš����ƺ����Ϻ������ǶԳ��������κ�����Fourier�任
figure('name','Fourier Transform of Fringe Signal, Modulated Signal, Asymmetrical Arc Function','NumberTitle','off');
% ԭʼ�ź�
subplot(3,1,1)
plot(abs(fftshift(fft(fringeListFractional{1}))),                        plotLineType,'LineWidth',1,'MarkerSize',2);
title('Fourier Spectrum of Fringe Signal');
xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);ylim([-2*10000,8*10000]);grid on;
set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);
% ���ƺ����Ϻ���
subplot(3,1,2)
plot(abs(fftshift(fft(fringeListFractionalAsymmetricalArcAmplitude{1}))),plotLineType,'LineWidth',1,'MarkerSize',2);
title('Fourier Spectrum of Modulated Signal');
xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);ylim([-2*10000,8*10000]);grid on;
set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);
% �ǶԳ��������κ���
subplot(3,1,3)
plot(abs(fftshift(fft(filterAsymmetricalArcAmplitude))),              plotLineType,'LineWidth',1,'MarkerSize',2);
title('Fourier Spectrum of Asymmetrical Arc Function');
xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);grid on;
set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);

% ��ʾ�ǶԳ��������κ�������Hilbert�任
htAsymmetricalArcAmplitudeFilter=imag(hilbert(filterAsymmetricalArcAmplitude));
figure('name','Asymmetrical Arc Function and its Hilbert Transform','NumberTitle','off');
plot(filterAsymmetricalArcAmplitude,  plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
plot(htAsymmetricalArcAmplitudeFilter,plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Asymmetrical Arc Function and its Hilbert Transform');
legend('Asymmetrical Arc Function ','HT','Location','SouthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalAsymmetricalArcAmplitude{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalAsymmetricalArcAmplitude{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-64-8 128]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    plot(imag(hilbert(fringeListFractionalAsymmetricalArcAmplitude{k}))-expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Amplitude Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcAmplitude-wrappedPhaseAllAsymmetricalArcAmplitude,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcAmplitude-wrappedPhaseAllAsymmetricalArcAmplitude,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Amplitude Modulated by Asymmetrical Arc Function)');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Location','NorthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/��ԾʽHilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------asymmetricalArcModulate-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);
end




