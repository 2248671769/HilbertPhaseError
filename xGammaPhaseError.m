% xGammaPhaseError.m
% �����20171114������
% ģ��gammaЧӦ���ı������źŵĵ��ƶȣ��������Ƶ��ƶȹ�һ������Hilbert�任�Լ�Hilbert����λ��Ӱ��
% ver��---
close all;clear;

%% @_@{���û�������}-�������S�S�S�S
% ͼ�����Ʋ���
width=1024; height=800; period=128;

%% --���Ʊ��
% �ԷǶԳ���������Ƶ���ź�[��������]���,��һ��: S3/B
asymmetricalArcFrequencyModulateNormWithDividingBFlag=1;
% % �Գ��������ε��Ʒ��ȱ��
symmetricalArcModulateFlag=0;
% �ǶԳ��������ε��Ʒ���Gamma��������Ӧ���Ʊ��,��һ����(S2-A)/B
asymmetricalArcModulateNormWithABFlag=0;
% �ǶԳ��������ε��Ʒ���Gamma��������Ӧ���Ʊ��,��һ����S2/B
asymmetricalArcModulateNormWithDividingBFlag=0;
% ��ֵΪ�ķַ��ȵİ����Gamma��������Ӧ���Ʊ��,��һ����(S1-A)/B}
halfAmplitudeNormWithABFlag=0;
% ��ֵΪ�ķַ��ȵİ����Gamma��������Ӧ���Ʊ��,��һ����S1-A
halfAmplitudeNormWithSubtractingAFlag=0;
% ��ֵΪ�ķַ��ȵİ����Gamma��������Ӧ���Ʊ��,��һ����S1/B
halfAmplitudeNormWithDividingBFlag=0;
% ��ֵΪ0��Gamma��������Ӧ�������Ʊ��,��һ����S0/B
unit0NormWithDividingBFlag=0;
 

% �źŷ�Χ
numOfPeriods=8;
startOfSignal=1;
endOfSignal=startOfSignal+period*numOfPeriods-1;
lengthOfSignal=endOfSignal-startOfSignal+1;

% ����������
horizontalIndex=0:lengthOfSignal-1;

% xTick & xTickLabel
if mod(lengthOfSignal,period)==0
    xTick=zeros(1,numOfPeriods+1);
    xTickLabel=cell(1,numOfPeriods+1);
    for xt=0:numOfPeriods
        xTick(xt+1)=floor(xt*period); xTickLabel{xt+1}=num2str(xTick(xt+1));
    end
    xTick(end)=lengthOfSignal-1; xTickLabel{end}=num2str(lengthOfSignal-1);
else
    xTick=zeros(1,numOfPeriods+2);
    xTickLabel=cell(1,numOfPeriods+2);
    for xt=0:numOfPeriods
        xTick(xt+1)=floor(xt*period); xTickLabel{xt+1}=num2str(xTick(xt+1));
    end
    xTick(end)=lengthOfSignal-1; xTickLabel{end}=num2str(lengthOfSignal-1);
end
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

%% --Gamma����
gamma=3.0;
filterGamma=255*power((0:255)/255,gamma);
figure('name','Gamma Curve','NumberTitle','off');
plot(filterGamma,plotLineType,'LineWidth',1,'MarkerSize',2);hold on;
plot((0:256-1),'g-.','LineWidth',0.5);
title(sprintf('Gamma Curve ($\\gamma$=%1.2f)',gamma),'Interpreter','latex');
xlim([0,256]);ylim([0,256]);grid on;
set(gca, 'XTick', yTick);set(gca, 'XTickLabel',yTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);


%% @_@{����24��ȫ������ͼ��(��һ����)}��������������������
%% --����24��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
% -��λ����������ź�
moveNumAll=24;
fringeListAllUnit=cell(moveNumAll,1);
fringeListAllUnitGamma=cell(moveNumAll,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllUnit{k} = floor(255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+1)/2);
    fringeListAllUnitGamma{k} =floor(filterGamma(floor(fringeListAllUnit{k})+1));
%     255*0.5*power(floor((255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+1)/2))/255,gamma);   
end

% -��ʾgammaЧӦǰ��������ź�
figure('name','Gamma Effect for Unit Fringes','NumberTitle','off');
plot(fringeListAllUnit{1});hold on;
plot(fringeListAllUnitGamma{1},plotLineType,'MarkerSize',2);
title(sprintf('Gamma Effect ($\\gamma$=%1.2f) for Unit Fringes',gamma),'Interpreter','latex');
legend('Original Fringe','Gamma Effect','Location','NorthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% -�������������λ
wrappedPhaseAllUnit=GetWrapPhase(fringeListAllUnit,moveNumAll);

% -�������������λ[GammaЧӦ)
wrappedPhaseAllGamma=GetWrapPhase(fringeListAllUnitGamma,moveNumAll);

% ��ȡ��������������ͼ��
moveNumPart=3;
fringeListFractional=SelectNStepFring(fringeListAllUnit,moveNumPart);
fringeListGammaFractional=SelectNStepFring(fringeListAllUnitGamma,moveNumPart);

%% --�������������λ
% wrappedPhaseAll0=GetWrapPhase(fringeListAllUnit,moveNumAll);
% AB=GetABNormal(fringeListAllUnit,wrappedPhaseAllGamma);

%% --���������������ƵĿ�����λ
wrappedPhaseGammaFractional=GetWrapPhase(fringeListGammaFractional,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListGammaFractionalHilbert=HilbertPerRow(fringeListGammaFractional,moveNumPart);
wrappedPhaseGammaFractionalHilbert=GetWrapPhaseWithHilbert(fringeListGammaFractionalHilbert,moveNumPart);

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma Effect) for Unit Fringes','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseGammaFractional    -wrappedPhaseAllUnit,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseGammaFractionalHilbert-wrappedPhaseAllUnit,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,plotDottedLineType,'LineWidth',1.5,'MarkerSize',2);hold on;
% ��ֵ��λ���
plot((wrappedErrorSpace+wrappedErrorHT)/2,plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Gamma Phase Error ($\\gamma$=%1.2f) for Unit Fringes',gamma),'Interpreter','latex');
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);


%% @_@{�Գ��������ε��Ʒ���}��������������������������
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
    fringeListAllSymmetricalArcAmplitude{k}=floor((fringeListAllUnit{k}-255.0/4).*filterSymmetricalArcAmplitude+255.0/2);
end
for k=1:moveNumPart
    fringeListFractionalSymmetricalArcAmplitude{k}=floor(fringeListFractional{k}.*filterSymmetricalArcAmplitude);
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalSymmetricalArcAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterSymmetricalArcAmplitude;
end

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
    xlim([0,lengthOfSignal-1]);ylim([-160 256]);grid on;
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
plot(extractValidPhaseErrorWithBounds(wrappedPhaseFractional                              -wrappedPhaseAllGamma,upPhaseErrorBound,bottomPhaseErrorBound),...
    plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
plot(extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertSymmetricalArcAmplitude-wrappedPhaseAllGamma,upPhaseErrorBound,bottomPhaseErrorBound),...
    plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Amplitude Modulated by Symmetrical Arc Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/��ԾʽHilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------symmetricalArcModulate-------------\n');
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractional-wrappedPhaseAllGamma,upPhaseErrorBound,bottomPhaseErrorBound);
fprintf('          Mean of Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('  Max positive of Space Phase Error: %+f\n',max( phasepedErrorSpace));
fprintf('  Max negative of Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('          RMSE of Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertSymmetricalArcAmplitude-wrappedPhaseAllGamma,upPhaseErrorBound,bottomPhaseErrorBound);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( phasepedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);
end

%% @_@{�ǶԳ��������ε��Ʒ���Gamma��������Ӧ���Ʊ��,��һ����(S2-A)/B}����������������������
if asymmetricalArcModulateNormWithABFlag==1
%% --�ԷǶԳ��������κ������������ź�
% �ǶԳ��������κ���
arcCenter=0.625;
filterAsymmetricalArcAmplitude=1-1.0*((0:lengthOfSignal-1)/lengthOfSignal-arcCenter).^2;
fringeListAllAsymmetricalArcAmplitude=cell(moveNumAll,1);
fringeListAllAsymmetricalArcAmplitudeGamma=cell(moveNumAll,1);
% ������Hilbert�任
% expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude=cell(moveNumPart,1);
for k=1:moveNumAll
    fringeListAllAsymmetricalArcAmplitude{k}=floor(fringeListAllUnit{k}.*filterAsymmetricalArcAmplitude);
    fringeListAllAsymmetricalArcAmplitudeGamma{k}=floor(filterGamma(floor(fringeListAllAsymmetricalArcAmplitude{k})+1));
end
% for k=1:moveNumPart
%     fringeListFractionalAsymmetricalArcAmplitude{k}=floor(fringeListFractional{k}.*filterAsymmetricalArcAmplitude);
%     sf=-period*(k-1)/moveNumPart;
% %     expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterAsymmetricalArcAmplitude;
% end

% ��ȡ��������������ͼ��
fringeListFractionalAsymmetricalArcAmplitude     =SelectNStepFring(fringeListAllAsymmetricalArcAmplitude     ,moveNumPart);
fringeListFractionalAsymmetricalArcAmplitudeGamma=SelectNStepFring(fringeListAllAsymmetricalArcAmplitudeGamma,moveNumPart);

%% --�������������λ[Gamma]
wrappedPhaseAllAsymmetricalArcAmplitudeGamma=GetWrapPhase(fringeListAllAsymmetricalArcAmplitudeGamma,moveNumAll);

%% --���������������ƵĿ�����λ[Gamma]
wrappedPhaseFractionalAsymmetricalArcAmplitudeGamma=GetWrapPhase(fringeListFractionalAsymmetricalArcAmplitudeGamma,moveNumPart);

%% --����������������[Gamma]��Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcAmplitudeGamma=HilbertPerRow(fringeListFractionalAsymmetricalArcAmplitudeGamma,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGamma=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcAmplitudeGamma,moveNumPart);

%% --��ʾ�ǶԳ��������κ������������������ź�[Gamma]����Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš��ԳƷ��������κ��������ƺ����Ϻ���
figure('name','Asymmetrical Arc Function','NumberTitle','off');
plot(filterAsymmetricalArcAmplitude, plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Asymmetrical Arc Function');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name',sprintf('1/%d Step of Original Fringe & Modulated Signal by Asymmetrical Arc Function [Gamma]',moveNumPart),'NumberTitle','off');
plot(fringeListFractional{1},                             plotLineType,'LineWidth',1.5,'MarkerSize',2);hold on;
plot(fringeListFractionalAsymmetricalArcAmplitude{1},     plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
plot(fringeListFractionalAsymmetricalArcAmplitudeGamma{1},plotLineType,'Color','m','LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringes [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
legend('Fringe Signal','Modulated Signal','Modulated Signal [Gamma]','Location','NorthWest');
xlim([0,lengthOfSignal-1]);ylim([-32,160]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% [Gamma without Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma] (Amplitude Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcAmplitudeGamma-wrappedPhaseAllAsymmetricalArcAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGamma-wrappedPhaseAllAsymmetricalArcAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
% ƽ����λ���
wrappedErrorMean=(wrappedErrorSpace+wrappedErrorHT)/2;
plot(wrappedErrorMean,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','NorthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% --���ź�[Gamma]��һ��[Normalization]����(S-A)/B����һ��������������λ��Hilbert����λ��ƽ����λ
% �����ź�[Gamma]
ABAllAmplitudeModulatedGamma=GetABNormal(fringeListAllAsymmetricalArcAmplitudeGamma,wrappedPhaseAllAsymmetricalArcAmplitudeGamma);
fringeListAllAsymmetricalArcAmplitudeGammaNorm=NormalizeFringe(fringeListAllAsymmetricalArcAmplitudeGamma,moveNumAll,ABAllAmplitudeModulatedGamma);
wrappedPhaseAllAsymmetricalArcAmplitudeGammaNorm=GetWrapPhase(fringeListAllAsymmetricalArcAmplitudeGammaNorm,moveNumAll);
% �����ź�[Gamma]
ABFractionalAmplitudeModulatedGamma=GetABNormal(fringeListFractionalAsymmetricalArcAmplitudeGamma,wrappedPhaseFractionalAsymmetricalArcAmplitudeGamma);
fringeListFractionalAsymmetricalArcAmplitudeGammaNorm=NormalizeFringe(fringeListFractionalAsymmetricalArcAmplitudeGamma,moveNumPart,ABFractionalAmplitudeModulatedGamma);
wrappedPhaseFractionalAsymmetricalArcAmplitudeGammaNorm=GetWrapPhase(fringeListFractionalAsymmetricalArcAmplitudeGammaNorm,moveNumPart);
% �����ź�Hilbert[Gamma]
fringeListFractionalHilbertAsymmetricalArcAmplitudeGammaNorm=HilbertPerRow(fringeListFractionalAsymmetricalArcAmplitudeGammaNorm,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGammaNorm=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcAmplitudeGammaNorm,moveNumPart);

% ��ʾ��һ��[Normalization]���ź�
figure('name',sprintf('1/%d Step of Fringe Modulated by Asymmetrical Arc Function [Gamma/Normalization: (S-A)/B]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalAsymmetricalArcAmplitudeGammaNorm{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringe Modulated by Asymmetrical Arc Function [Gamma/Normalization: (S-A)/B]',moveNumPart));
xlim([0,lengthOfSignal-1]);ylim([-1,1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma with Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma/Normalization: (S-A)/B] (Amplitude Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpaceNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcAmplitudeGammaNorm-wrappedPhaseAllAsymmetricalArcAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHTNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGammaNorm-wrappedPhaseAllAsymmetricalArcAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ƽ����λ���
wrappedErrorMeanNorm=(wrappedErrorSpaceNorm+wrappedErrorHTNorm)/2;
plot(wrappedErrorMeanNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error [Gamma ($\\gamma$=%1.2f)/Normalization: (S-A)/B]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','NorthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end

%% @_@{�ǶԳ��������ε��Ʒ���Gamma��������Ӧ���Ʊ��,��һ����S2/B}����������������������
if asymmetricalArcModulateNormWithDividingBFlag==1
%% --�ԷǶԳ��������κ������������ź�
% �ǶԳ��������κ���
arcCenter=0.625;
filterAsymmetricalArcAmplitude=1-1.0*((0:lengthOfSignal-1)/lengthOfSignal-arcCenter).^2;
fringeListAllAsymmetricalArcAmplitude=cell(moveNumAll,1);
fringeListAllAsymmetricalArcAmplitudeGamma=cell(moveNumAll,1);
% ������Hilbert�任
% expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude=cell(moveNumPart,1);
for k=1:moveNumAll
    fringeListAllAsymmetricalArcAmplitude{k}=floor(fringeListAllUnit{k}.*filterAsymmetricalArcAmplitude);
    fringeListAllAsymmetricalArcAmplitudeGamma{k}=floor(filterGamma(floor(fringeListAllAsymmetricalArcAmplitude{k})+1));
end
% for k=1:moveNumPart
%     fringeListFractionalAsymmetricalArcAmplitude{k}=floor(fringeListFractional{k}.*filterAsymmetricalArcAmplitude);
%     sf=-period*(k-1)/moveNumPart;
% %     expectedHilbertOfFringeListFractionalAsymmetricalArcAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterAsymmetricalArcAmplitude;
% end

% ��ȡ��������������ͼ��
fringeListFractionalAsymmetricalArcAmplitude     =SelectNStepFring(fringeListAllAsymmetricalArcAmplitude     ,moveNumPart);
fringeListFractionalAsymmetricalArcAmplitudeGamma=SelectNStepFring(fringeListAllAsymmetricalArcAmplitudeGamma,moveNumPart);

%% --�������������λ[Gamma]
wrappedPhaseAllAsymmetricalArcAmplitudeGamma=GetWrapPhase(fringeListAllAsymmetricalArcAmplitudeGamma,moveNumAll);

%% --���������������ƵĿ�����λ[Gamma]
wrappedPhaseFractionalAsymmetricalArcAmplitudeGamma=GetWrapPhase(fringeListFractionalAsymmetricalArcAmplitudeGamma,moveNumPart);

%% --����������������[Gamma]��Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcAmplitudeGamma=HilbertPerRow(fringeListFractionalAsymmetricalArcAmplitudeGamma,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGamma=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcAmplitudeGamma,moveNumPart);

%% --��ʾ�ǶԳ��������κ������������������ź�[Gamma]����Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš��ԳƷ��������κ��������ƺ����Ϻ���
figure('name','Asymmetrical Arc Function','NumberTitle','off');
plot(filterAsymmetricalArcAmplitude, plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Asymmetrical Arc Function');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name',sprintf('1/%d Step of Original Fringe & Modulated Signal by Asymmetrical Arc Function [Gamma]',moveNumPart),'NumberTitle','off');
plot(fringeListFractional{1},                             plotLineType,'LineWidth',1.5,'MarkerSize',2);hold on;
plot(fringeListFractionalAsymmetricalArcAmplitude{1},     plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
plot(fringeListFractionalAsymmetricalArcAmplitudeGamma{1},plotLineType,'Color','m','LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringes [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
legend('Fringe Signal','Modulated Signal','Modulated Signal [Gamma]','Location','NorthWest');
xlim([0,lengthOfSignal-1]);ylim([-32,160]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% [Gamma without Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma] (Amplitude Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcAmplitudeGamma-wrappedPhaseAllAsymmetricalArcAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGamma-wrappedPhaseAllAsymmetricalArcAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
% ƽ����λ���
wrappedErrorMean=(wrappedErrorSpace+wrappedErrorHT)/2;
plot(wrappedErrorMean,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','NorthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% --���ź�[Gamma]��һ��[Normalization]����S/B����һ��������������λ��Hilbert����λ��ƽ����λ
% �����ź�[Gamma]
ABAllAmplitudeModulatedGamma=GetABNormal(fringeListAllAsymmetricalArcAmplitudeGamma,wrappedPhaseAllAsymmetricalArcAmplitudeGamma);
% fringeListAllAsymmetricalArcAmplitudeGammaNorm=NormalizeFringe(fringeListAllAsymmetricalArcAmplitudeGamma,moveNumAll,ABAllAmplitudeModulatedGamma);
for k=1:moveNumAll
    fringeListAllAsymmetricalArcAmplitudeGammaNorm{k}=fringeListAllAsymmetricalArcAmplitudeGamma{k}./ABAllAmplitudeModulatedGamma{2};
end
wrappedPhaseAllAsymmetricalArcAmplitudeGammaNorm=GetWrapPhase(fringeListAllAsymmetricalArcAmplitudeGammaNorm,moveNumAll);
% �����ź�[Gamma]
ABFractionalAmplitudeModulatedGamma=GetABNormal(fringeListFractionalAsymmetricalArcAmplitudeGamma,wrappedPhaseFractionalAsymmetricalArcAmplitudeGamma);
% fringeListFractionalAsymmetricalArcAmplitudeGammaNorm=NormalizeFringe(fringeListFractionalAsymmetricalArcAmplitudeGamma,moveNumPart,ABFractionalAmplitudeModulatedGamma);
for k=1:moveNumPart
    fringeListFractionalAsymmetricalArcAmplitudeGammaNorm{k}=fringeListFractionalAsymmetricalArcAmplitudeGammaNorm{k}./ABFractionalAmplitudeModulatedGamma{2};
end
wrappedPhaseFractionalAsymmetricalArcAmplitudeGammaNorm=GetWrapPhase(fringeListFractionalAsymmetricalArcAmplitudeGammaNorm,moveNumPart);
% �����ź�Hilbert[Gamma]
fringeListFractionalHilbertAsymmetricalArcAmplitudeGammaNorm=HilbertPerRow(fringeListFractionalAsymmetricalArcAmplitudeGammaNorm,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGammaNorm=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcAmplitudeGammaNorm,moveNumPart);

% ��ʾ��һ��[Normalization]���ź�
figure('name',sprintf('1/%d Step of Fringe Modulated by Asymmetrical Arc Function [Gamma/Normalization: S/B]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalAsymmetricalArcAmplitudeGammaNorm{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringe Modulated by Asymmetrical Arc Function [Gamma/Normalization: S/B]',moveNumPart));
xlim([0,lengthOfSignal-1]);ylim([-1,1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma with Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma/Normalization: S/B] (Amplitude Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpaceNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcAmplitudeGammaNorm-wrappedPhaseAllAsymmetricalArcAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHTNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcAmplitudeGammaNorm-wrappedPhaseAllAsymmetricalArcAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ƽ����λ���
wrappedErrorMeanNorm=(wrappedErrorSpaceNorm+wrappedErrorHTNorm)/2;
plot(wrappedErrorMeanNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error [Gamma ($\\gamma$=%1.2f)/Normalization: S/B]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','NorthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end

%% @_@{��ֵΪ�ķַ��ȵİ����Gamma��������Ӧ���Ʊ��,��һ����(S1-A)/B}������������������������
if halfAmplitudeNormWithABFlag==1
%% --�ԷǶԳ��������κ������������ź�
fringeListAllHalfAmplitude=cell(moveNumAll,1);
fringeListAllHalfAmplitudeGamma=cell(moveNumAll,1);
% ������Hilbert�任
% expectedHilbertOfFringeListFractionalHalfAmplitude=cell(moveNumPart,1);
for k=1:moveNumAll
    fringeListAllHalfAmplitude{k}=floor(fringeListAllUnit{k});
    fringeListAllHalfAmplitudeGamma{k}=floor(filterGamma(floor(fringeListAllHalfAmplitude{k})+1));
end
% for k=1:moveNumPart
%     fringeListFractionalHalfAmplitude{k}=floor(fringeListFractional{k}.*filterHalfAmplitude);
%     sf=-period*(k-1)/moveNumPart;
% %     expectedHilbertOfFringeListFractionalHalfAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterHalfAmplitude;
% end

% ��ȡ��������������ͼ��
fringeListFractionalHalfAmplitude     =SelectNStepFring(fringeListAllHalfAmplitude     ,moveNumPart);
fringeListFractionalHalfAmplitudeGamma=SelectNStepFring(fringeListAllHalfAmplitudeGamma,moveNumPart);

%% --�������������λ[Gamma]
wrappedPhaseAllHalfAmplitudeGamma=GetWrapPhase(fringeListAllHalfAmplitudeGamma,moveNumAll);

%% --���������������ƵĿ�����λ[Gamma]
wrappedPhaseFractionalHalfAmplitudeGamma=GetWrapPhase(fringeListFractionalHalfAmplitudeGamma,moveNumPart);

%% --����������������[Gamma]��Hilbert�任��Hilbert����λ
fringeListFractionalHilbertHalfAmplitudeGamma=HilbertPerRow(fringeListFractionalHalfAmplitudeGamma,moveNumPart);
wrappedPhaseFractionalHilbertHalfAmplitudeGamma=GetWrapPhaseWithHilbert(fringeListFractionalHilbertHalfAmplitudeGamma,moveNumPart);

%% --��ʾ�������������ź�[Gamma]����Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name',sprintf('1/%d Step of Original Fringe (Half Amplitude) [Gamma]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalHalfAmplitude{1},     plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
plot(fringeListFractionalHalfAmplitudeGamma{1},plotLineType,'Color','m','LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringes (Half Amplitude) [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
legend('Fringe Signal','Fringe Signal [Gamma]','Location','NorthWest');
xlim([0,lengthOfSignal-1]);ylim([-32,160]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% ��ʾ�����۵���λ
figure('name','Wrapped Phase (Half Amplitude) [Gamma/Normalization: (S-A)/B]','NumberTitle','off');
plot(wrappedPhaseAllHalfAmplitudeGamma,plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Wrapped Phase (Unit0 Amplitude) [Gamma/Normalization: (S-A)/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma without Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma]','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHalfAmplitudeGamma-wrappedPhaseAllHalfAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertHalfAmplitudeGamma-wrappedPhaseAllHalfAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
% ƽ����λ���
wrappedErrorMean=(wrappedErrorSpace+wrappedErrorHT)/2;
plot(wrappedErrorMean,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Half Amplitude) [Gamma ($\\gamma$=%1.2f)]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% ���ź�[Gamma]��һ��[Normalization]����(S-A)/B����һ��������������λ��Hilbert����λ��ƽ����λ
% �����ź�[Gamma]
ABAllAmplitudeModulatedGamma=GetABNormal(fringeListAllHalfAmplitudeGamma,wrappedPhaseAllHalfAmplitudeGamma);
% ��ʾ������ǿA
figure('name','Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: (S-A)/B]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{1},plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: (S-A)/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
% ��ʾ���ƶ�B
figure('name','Amplitude B (Unit0 Amplitude) [Gamma/Normalization: (S-A)/B]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{2},plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Amplitude B (Unit0 Amplitude) [Gamma/Normalization: (S-A)/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
fringeListAllHalfAmplitudeGammaNorm=cell(size(fringeListAllHalfAmplitudeGamma));
for k=1:moveNumAll
    fringeListAllHalfAmplitudeGammaNorm{k}=(fringeListAllHalfAmplitudeGamma{k}-ABAllAmplitudeModulatedGamma{1})./ABAllAmplitudeModulatedGamma{2};
end
% fringeListAllHalfAmplitudeGammaNorm=NormalizeFringe(fringeListAllHalfAmplitudeGamma,moveNumAll,ABAllAmplitudeModulatedGamma);
wrappedPhaseAllHalfAmplitudeGammaNorm=GetWrapPhase(fringeListAllHalfAmplitudeGammaNorm,moveNumAll);
% �����ź�[Gamma]
ABFractionalAmplitudeModulatedGamma=GetABNormal(fringeListFractionalHalfAmplitudeGamma,wrappedPhaseFractionalHalfAmplitudeGamma);
fringeListFractionalHalfAmplitudeGammaNorm=cell(size(fringeListFractionalHalfAmplitudeGamma));
for k=1:moveNumPart
    fringeListFractionalHalfAmplitudeGammaNorm{k}=(fringeListFractionalHalfAmplitudeGamma{k}-ABFractionalAmplitudeModulatedGamma{1})./ABFractionalAmplitudeModulatedGamma{2};
end
% fringeListFractionalHalfAmplitudeGammaNorm=NormalizeFringe(fringeListFractionalHalfAmplitudeGamma,moveNumPart,ABFractionalAmplitudeModulatedGamma);
wrappedPhaseFractionalHalfAmplitudeGammaNorm=GetWrapPhase(fringeListFractionalHalfAmplitudeGammaNorm,moveNumPart);
% �����ź�Hilbert[Gamma]
fringeListFractionalHilbertHalfAmplitudeGammaNorm=HilbertPerRow(fringeListFractionalHalfAmplitudeGammaNorm,moveNumPart);
wrappedPhaseFractionalHilbertHalfAmplitudeGammaNorm=GetWrapPhaseWithHilbert(fringeListFractionalHilbertHalfAmplitudeGammaNorm,moveNumPart);

% ��ʾ��һ��[Normalization]���ź�
figure('name',sprintf('1/%d Step of Fringe (Half Amplitude) [Gamma/Normalization: (S-A)/B]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalHalfAmplitudeGammaNorm{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringe (Half Amplitude) [Gamma/Normalization: (S-A)/B]',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma with Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma/Normalization: (S-A)/B] (Half Amplitude)','NumberTitle','off');
% ������λ���
wrappedErrorSpaceNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHalfAmplitudeGammaNorm-wrappedPhaseAllHalfAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHTNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertHalfAmplitudeGammaNorm-wrappedPhaseAllHalfAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ƽ����λ���
wrappedErrorMeanNorm=(wrappedErrorSpaceNorm+wrappedErrorHTNorm)/2;
plot(wrappedErrorMeanNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Half Amplitude) [Gamma ($\\gamma$=%1.2f)/Normalization: (S-A)/B]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end

%% @_@{��ֵΪ�ķַ��ȵİ����Gamma��������Ӧ���Ʊ��,��һ����S1-A}������������������������
if halfAmplitudeNormWithSubtractingAFlag==1
%% --�ԷǶԳ��������κ������������ź�
fringeListAllHalfAmplitude=cell(moveNumAll,1);
fringeListAllHalfAmplitudeGamma=cell(moveNumAll,1);
% ������Hilbert�任
% expectedHilbertOfFringeListFractionalHalfAmplitude=cell(moveNumPart,1);
for k=1:moveNumAll
    fringeListAllHalfAmplitude{k}=floor(fringeListAllUnit{k});
    fringeListAllHalfAmplitudeGamma{k}=floor(filterGamma(floor(fringeListAllHalfAmplitude{k})+1));
end
% for k=1:moveNumPart
%     fringeListFractionalHalfAmplitude{k}=floor(fringeListFractional{k}.*filterHalfAmplitude);
%     sf=-period*(k-1)/moveNumPart;
% %     expectedHilbertOfFringeListFractionalHalfAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterHalfAmplitude;
% end

% ��ȡ��������������ͼ��
fringeListFractionalHalfAmplitude     =SelectNStepFring(fringeListAllHalfAmplitude     ,moveNumPart);
fringeListFractionalHalfAmplitudeGamma=SelectNStepFring(fringeListAllHalfAmplitudeGamma,moveNumPart);

%% --�������������λ[Gamma]
wrappedPhaseAllHalfAmplitudeGamma=GetWrapPhase(fringeListAllHalfAmplitudeGamma,moveNumAll);

%% --���������������ƵĿ�����λ[Gamma]
wrappedPhaseFractionalHalfAmplitudeGamma=GetWrapPhase(fringeListFractionalHalfAmplitudeGamma,moveNumPart);

%% --����������������[Gamma]��Hilbert�任��Hilbert����λ
fringeListFractionalHilbertHalfAmplitudeGamma=HilbertPerRow(fringeListFractionalHalfAmplitudeGamma,moveNumPart);
wrappedPhaseFractionalHilbertHalfAmplitudeGamma=GetWrapPhaseWithHilbert(fringeListFractionalHilbertHalfAmplitudeGamma,moveNumPart);

%% --��ʾ�������������ź�[Gamma]����Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name',sprintf('1/%d Step of Original Fringe (Half Amplitude) [Gamma]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalHalfAmplitude{1},     plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
plot(fringeListFractionalHalfAmplitudeGamma{1},plotLineType,'Color','m','LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringes (Half Amplitude) [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
legend('Fringe Signal','Fringe Signal [Gamma]','Location','NorthWest');
xlim([0,lengthOfSignal-1]);ylim([-32,160]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% ��ʾ�����۵���λ
figure('name','Wrapped Phase (Half Amplitude) [Gamma/Normalization: S-A]','NumberTitle','off');
plot(wrappedPhaseAllHalfAmplitudeGamma,plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Wrapped Phase (Unit0 Amplitude) [Gamma/Normalization: S-A]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma without Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma]','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHalfAmplitudeGamma-wrappedPhaseAllHalfAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertHalfAmplitudeGamma-wrappedPhaseAllHalfAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
% ƽ����λ���
wrappedErrorMean=(wrappedErrorSpace+wrappedErrorHT)/2;
plot(wrappedErrorMean,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Half Amplitude) [Gamma ($\\gamma$=%1.2f)]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% ���ź�[Gamma]��һ��[Normalization]����(S-A)����һ��������������λ��Hilbert����λ��ƽ����λ
% �����ź�[Gamma]
ABAllAmplitudeModulatedGamma=GetABNormal(fringeListAllHalfAmplitudeGamma,wrappedPhaseAllHalfAmplitudeGamma);
% ��ʾ������ǿA
figure('name','Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: S-A]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{1},plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: S-A]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
% ��ʾ���ƶ�B
figure('name','Amplitude B (Unit0 Amplitude) [Gamma/Normalization: S-A]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{2},plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Amplitude B (Unit0 Amplitude) [Gamma/Normalization: S-A]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
fringeListAllHalfAmplitudeGammaNorm=cell(size(fringeListAllHalfAmplitudeGamma));
for k=1:moveNumAll
    fringeListAllHalfAmplitudeGammaNorm{k}=fringeListAllHalfAmplitudeGamma{k}-ABAllAmplitudeModulatedGamma{1};
end
% fringeListAllHalfAmplitudeGammaNorm=NormalizeFringe(fringeListAllHalfAmplitudeGamma,moveNumAll,ABAllAmplitudeModulatedGamma);
wrappedPhaseAllHalfAmplitudeGammaNorm=GetWrapPhase(fringeListAllHalfAmplitudeGammaNorm,moveNumAll);
% �����ź�[Gamma]
ABFractionalAmplitudeModulatedGamma=GetABNormal(fringeListFractionalHalfAmplitudeGamma,wrappedPhaseFractionalHalfAmplitudeGamma);
fringeListFractionalHalfAmplitudeGammaNorm=cell(size(fringeListFractionalHalfAmplitudeGamma));
for k=1:moveNumPart
    fringeListFractionalHalfAmplitudeGammaNorm{k}=fringeListFractionalHalfAmplitudeGamma{k}-ABFractionalAmplitudeModulatedGamma{1};
end
% fringeListFractionalHalfAmplitudeGammaNorm=NormalizeFringe(fringeListFractionalHalfAmplitudeGamma,moveNumPart,ABFractionalAmplitudeModulatedGamma);
wrappedPhaseFractionalHalfAmplitudeGammaNorm=GetWrapPhase(fringeListFractionalHalfAmplitudeGammaNorm,moveNumPart);
% �����ź�Hilbert[Gamma]
fringeListFractionalHilbertHalfAmplitudeGammaNorm=HilbertPerRow(fringeListFractionalHalfAmplitudeGammaNorm,moveNumPart);
wrappedPhaseFractionalHilbertHalfAmplitudeGammaNorm=GetWrapPhaseWithHilbert(fringeListFractionalHilbertHalfAmplitudeGammaNorm,moveNumPart);

% ��ʾ��һ��[Normalization]���ź�
figure('name',sprintf('1/%d Step of Fringe (Half Amplitude) [Gamma/Normalization: S-A]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalHalfAmplitudeGammaNorm{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringe (Half Amplitude) [Gamma/Normalization: S-A]',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma with Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma/Normalization: S-A] (Half Amplitude)','NumberTitle','off');
% ������λ���
wrappedErrorSpaceNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHalfAmplitudeGammaNorm-wrappedPhaseAllHalfAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHTNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertHalfAmplitudeGammaNorm-wrappedPhaseAllHalfAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ƽ����λ���
wrappedErrorMeanNorm=(wrappedErrorSpaceNorm+wrappedErrorHTNorm)/2;
plot(wrappedErrorMeanNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Half Amplitude) [Gamma ($\\gamma$=%1.2f)/Normalization: S-A]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end

%% @_@{��ֵΪ�ķַ��ȵİ����Gamma��������Ӧ���Ʊ��,��һ����S1/B}������������������������
if halfAmplitudeNormWithDividingBFlag==1
%% --�ԷǶԳ��������κ������������ź�
fringeListAllHalfAmplitude=cell(moveNumAll,1);
fringeListAllHalfAmplitudeGamma=cell(moveNumAll,1);
% ������Hilbert�任
% expectedHilbertOfFringeListFractionalHalfAmplitude=cell(moveNumPart,1);
for k=1:moveNumAll
    fringeListAllHalfAmplitude{k}=floor(fringeListAllUnit{k});
    fringeListAllHalfAmplitudeGamma{k}=floor(filterGamma(floor(fringeListAllHalfAmplitude{k})+1));
end
% for k=1:moveNumPart
%     fringeListFractionalHalfAmplitude{k}=floor(fringeListFractional{k}.*filterHalfAmplitude);
%     sf=-period*(k-1)/moveNumPart;
% %     expectedHilbertOfFringeListFractionalHalfAmplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterHalfAmplitude;
% end

% ��ȡ��������������ͼ��
fringeListFractionalHalfAmplitude     =SelectNStepFring(fringeListAllHalfAmplitude     ,moveNumPart);
fringeListFractionalHalfAmplitudeGamma=SelectNStepFring(fringeListAllHalfAmplitudeGamma,moveNumPart);

%% --�������������λ[Gamma]
wrappedPhaseAllHalfAmplitudeGamma=GetWrapPhase(fringeListAllHalfAmplitudeGamma,moveNumAll);

%% --���������������ƵĿ�����λ[Gamma]
wrappedPhaseFractionalHalfAmplitudeGamma=GetWrapPhase(fringeListFractionalHalfAmplitudeGamma,moveNumPart);

%% --����������������[Gamma]��Hilbert�任��Hilbert����λ
fringeListFractionalHilbertHalfAmplitudeGamma=HilbertPerRow(fringeListFractionalHalfAmplitudeGamma,moveNumPart);
wrappedPhaseFractionalHilbertHalfAmplitudeGamma=GetWrapPhaseWithHilbert(fringeListFractionalHilbertHalfAmplitudeGamma,moveNumPart);

%% --��ʾ�������������ź�[Gamma]����Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name',sprintf('1/%d Step of Original Fringe (Half Amplitude) [Gamma]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalHalfAmplitude{1},     plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
plot(fringeListFractionalHalfAmplitudeGamma{1},plotLineType,'Color','m','LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringes (Half Amplitude) [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
legend('Fringe Signal','Fringe Signal [Gamma]','Location','NorthWest');
xlim([0,lengthOfSignal-1]);ylim([-32,160]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% ��ʾ�����۵���λ
figure('name','Wrapped Phase (Half Amplitude) [Gamma/Normalization: S-A]','NumberTitle','off');
plot(wrappedPhaseAllHalfAmplitudeGamma,plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Wrapped Phase (Unit0 Amplitude) [Gamma/Normalization: S-A]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma without Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma]','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHalfAmplitudeGamma-wrappedPhaseAllHalfAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertHalfAmplitudeGamma-wrappedPhaseAllHalfAmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
% ƽ����λ���
wrappedErrorMean=(wrappedErrorSpace+wrappedErrorHT)/2;
plot(wrappedErrorMean,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Half Amplitude) [Gamma ($\\gamma$=%1.2f)]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% ���ź�[Gamma]��һ��[Normalization]����(S/B)����һ��������������λ��Hilbert����λ��ƽ����λ
% �����ź�[Gamma]
ABAllAmplitudeModulatedGamma=GetABNormal(fringeListAllHalfAmplitudeGamma,wrappedPhaseAllHalfAmplitudeGamma);
% ��ʾ������ǿA
figure('name','Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: S-A]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{1},plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: S-A]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
% ��ʾ���ƶ�B
figure('name','Amplitude B (Unit0 Amplitude) [Gamma/Normalization: S/B]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{2},plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Amplitude B (Unit0 Amplitude) [Gamma/Normalization: S/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
fringeListAllHalfAmplitudeGammaNorm=cell(size(fringeListAllHalfAmplitudeGamma));
for k=1:moveNumAll
    fringeListAllHalfAmplitudeGammaNorm{k}=fringeListAllHalfAmplitudeGamma{k}./ABAllAmplitudeModulatedGamma{2};
end
% fringeListAllHalfAmplitudeGammaNorm=NormalizeFringe(fringeListAllHalfAmplitudeGamma,moveNumAll,ABAllAmplitudeModulatedGamma);
wrappedPhaseAllHalfAmplitudeGammaNorm=GetWrapPhase(fringeListAllHalfAmplitudeGammaNorm,moveNumAll);
% �����ź�[Gamma]
ABFractionalAmplitudeModulatedGamma=GetABNormal(fringeListFractionalHalfAmplitudeGamma,wrappedPhaseFractionalHalfAmplitudeGamma);
fringeListFractionalHalfAmplitudeGammaNorm=cell(size(fringeListFractionalHalfAmplitudeGamma));
for k=1:moveNumPart
    fringeListFractionalHalfAmplitudeGammaNorm{k}=fringeListFractionalHalfAmplitudeGamma{k}./ABFractionalAmplitudeModulatedGamma{2};
end
% fringeListFractionalHalfAmplitudeGammaNorm=NormalizeFringe(fringeListFractionalHalfAmplitudeGamma,moveNumPart,ABFractionalAmplitudeModulatedGamma);
wrappedPhaseFractionalHalfAmplitudeGammaNorm=GetWrapPhase(fringeListFractionalHalfAmplitudeGammaNorm,moveNumPart);
% �����ź�Hilbert[Gamma]
fringeListFractionalHilbertHalfAmplitudeGammaNorm=HilbertPerRow(fringeListFractionalHalfAmplitudeGammaNorm,moveNumPart);
wrappedPhaseFractionalHilbertHalfAmplitudeGammaNorm=GetWrapPhaseWithHilbert(fringeListFractionalHilbertHalfAmplitudeGammaNorm,moveNumPart);

% ��ʾ��һ��[Normalization]���ź�
figure('name',sprintf('1/%d Step of Fringe (Half Amplitude) [Gamma/Normalization: S/B]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalHalfAmplitudeGammaNorm{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringe (Half Amplitude) [Gamma/Normalization: S/B]',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma with Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma/Normalization: S/B] (Half Amplitude)','NumberTitle','off');
% ������λ���
wrappedErrorSpaceNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHalfAmplitudeGammaNorm-wrappedPhaseAllHalfAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHTNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertHalfAmplitudeGammaNorm-wrappedPhaseAllHalfAmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ƽ����λ���
wrappedErrorMeanNorm=(wrappedErrorSpaceNorm+wrappedErrorHTNorm)/2;
plot(wrappedErrorMeanNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Half Amplitude) [Gamma ($\\gamma$=%1.2f)/Normalization: S/B]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end


%% @_@{��ֵΪ0��Gamma��������Ӧ�������Ʊ��,��һ����S0/B}������������������������
if unit0NormWithDividingBFlag==1
%% --�ԷǶԳ��������κ������������ź�
fringeListAllUnit0Amplitude=cell(moveNumAll,1);
fringeListAllUnit0AmplitudeGamma=cell(moveNumAll,1);
% ������Hilbert�任
% expectedHilbertOfFringeListFractionalUnit0Amplitude=cell(moveNumPart,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllUnit0Amplitude{k}=floor(255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+0)/1);
    fringeListAllUnit0AmplitudeGamma{k}=floor(...
        ( (fringeListAllUnit0Amplitude{k}>0)-(fringeListAllUnit0Amplitude{k}<0) ).*...
        filterGamma(abs(fringeListAllUnit0Amplitude{k})+1));
end
% for k=1:moveNumPart
%     fringeListFractionalUnit0Amplitude{k}=floor(fringeListFractional{k}.*filterUnit0Amplitude);
%     sf=-period*(k-1)/moveNumPart;
% %     expectedHilbertOfFringeListFractionalUnit0Amplitude{k}=255.0/2*(sin(((0:lengthOfSignal-1)-sf)/period*2*pi))/2.*filterUnit0Amplitude;
% end

% ��ȡ��������������ͼ��
fringeListFractionalUnit0Amplitude     =SelectNStepFring(fringeListAllUnit0Amplitude     ,moveNumPart);
fringeListFractionalUnit0AmplitudeGamma=SelectNStepFring(fringeListAllUnit0AmplitudeGamma,moveNumPart);

%% --�������������λ[Gamma]
wrappedPhaseAllUnit0AmplitudeGamma=GetWrapPhase(fringeListAllUnit0AmplitudeGamma,moveNumAll);

%% --���������������ƵĿ�����λ[Gamma]
wrappedPhaseFractionalUnit0AmplitudeGamma=GetWrapPhase(fringeListFractionalUnit0AmplitudeGamma,moveNumPart);

%% --����������������[Gamma]��Hilbert�任��Hilbert����λ
fringeListFractionalHilbertUnit0AmplitudeGamma=HilbertPerRow(fringeListFractionalUnit0AmplitudeGamma,moveNumPart);
wrappedPhaseFractionalHilbertUnit0AmplitudeGamma=GetWrapPhaseWithHilbert(fringeListFractionalHilbertUnit0AmplitudeGamma,moveNumPart);

%% --��ʾ�������������ź�[Gamma]����Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name',sprintf('1/%d Step of Original Fringe (Unit0 Amplitude) [Gamma]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalUnit0Amplitude{1},     plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
plot(fringeListFractionalUnit0AmplitudeGamma{1},plotLineType,'Color','m','LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringes (Unit0 Amplitude) [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
legend('Fringe Signal','Fringe Signal [Gamma]','Location','NorthWest');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-32,160]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% ��ʾ�����۵���λ
figure('name','Wrapped Phase (Unit0 Amplitude) [Gamma/Normalization: S/B]','NumberTitle','off');
plot(wrappedPhaseAllUnit0AmplitudeGamma,plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Wrapped Phase (Unit0 Amplitude) [Gamma/Normalization: S/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma without Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma]','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalUnit0AmplitudeGamma-wrappedPhaseAllUnit0AmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertUnit0AmplitudeGamma-wrappedPhaseAllUnit0AmplitudeGamma,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
% ƽ����λ���
wrappedErrorMean=(wrappedErrorSpace+wrappedErrorHT)/2;
plot(wrappedErrorMean,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Unit0 Amplitude) [Gamma ($\\gamma$=%1.2f)]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% --���ź�[Gamma]��һ��[Normalization]����(S/B)����һ��������������λ��Hilbert����λ��ƽ����λ
% �����ź�[Gamma]
ABAllAmplitudeModulatedGamma=GetABNormal(fringeListAllUnit0AmplitudeGamma,wrappedPhaseAllUnit0AmplitudeGamma);
% ��ʾ������ǿA
figure('name','Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: S/B]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{1},plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Background Illumination A (Unit0 Amplitude) [Gamma/Normalization: S/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
% ��ʾ���ƶ�B
figure('name','Amplitude B (Unit0 Amplitude) [Gamma/Normalization: S/B]','NumberTitle','off');
plot(ABAllAmplitudeModulatedGamma{2},plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Amplitude B (Unit0 Amplitude) [Gamma/Normalization: S/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

fringeListAllUnit0AmplitudeGammaNorm=cell(size(fringeListAllUnit0AmplitudeGamma));
for k=1:moveNumAll
    fringeListAllUnit0AmplitudeGammaNorm{k}=fringeListAllUnit0AmplitudeGamma{k}./ABAllAmplitudeModulatedGamma{2};
end
% fringeListAllUnit0AmplitudeGammaNorm=NormalizeFringe(fringeListAllUnit0AmplitudeGamma,moveNumAll,ABAllAmplitudeModulatedGamma);
wrappedPhaseAllUnit0AmplitudeGammaNorm=GetWrapPhase(fringeListAllUnit0AmplitudeGammaNorm,moveNumAll);
% �����ź�[Gamma]
ABFractionalAmplitudeModulatedGamma=GetABNormal(fringeListFractionalUnit0AmplitudeGamma,wrappedPhaseFractionalUnit0AmplitudeGamma);
fringeListFractionalUnit0AmplitudeGammaNorm=cell(size(fringeListFractionalUnit0AmplitudeGamma));
for k=1:moveNumPart
    fringeListFractionalUnit0AmplitudeGammaNorm{k}=fringeListFractionalUnit0AmplitudeGamma{k}./ABFractionalAmplitudeModulatedGamma{2};
end
% fringeListFractionalUnit0AmplitudeGammaNorm=NormalizeFringe(fringeListFractionalUnit0AmplitudeGamma,moveNumPart,ABFractionalAmplitudeModulatedGamma);
wrappedPhaseFractionalUnit0AmplitudeGammaNorm=GetWrapPhase(fringeListFractionalUnit0AmplitudeGammaNorm,moveNumPart);
% �����ź�Hilbert[Gamma]
fringeListFractionalHilbertUnit0AmplitudeGammaNorm=HilbertPerRow(fringeListFractionalUnit0AmplitudeGammaNorm,moveNumPart);
wrappedPhaseFractionalHilbertUnit0AmplitudeGammaNorm=GetWrapPhaseWithHilbert(fringeListFractionalHilbertUnit0AmplitudeGammaNorm,moveNumPart);

% ��ʾ��һ��[Normalization]���ź�
figure('name',sprintf('1/%d Step of Fringe (Unit0 Amplitude) [Gamma/Normalization: S/B]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalUnit0AmplitudeGammaNorm{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringe (Unit0 Amplitude) [Gamma/Normalization: S/B]',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma with Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma/Normalization: S/B] (Unit0 Amplitude)','NumberTitle','off');
% ������λ���
wrappedErrorSpaceNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalUnit0AmplitudeGammaNorm-wrappedPhaseAllUnit0AmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHTNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertUnit0AmplitudeGammaNorm-wrappedPhaseAllUnit0AmplitudeGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ƽ����λ���
wrappedErrorMeanNorm=(wrappedErrorSpaceNorm+wrappedErrorHTNorm)/2;
plot(wrappedErrorMeanNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Unit0 Amplitude) [Gamma ($\\gamma$=%1.2f)/Normalization: S/B]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end

%% @_@{�ԷǶԳ���������Ƶ���ź�[��������],��һ��: S3/B}********************
% �ԷǶԳ���������Ƶ���ź�[��������]���,��һ��: S3/B
if asymmetricalArcFrequencyModulateNormWithDividingBFlag==1
disp('asymmetricalArcFrequencyModulateDividingB');
asymmetricalArcFactor=1.25;
lengthEnd=lengthOfSignal;
    
%% --����24���ǶԳ���������Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllAsymmetricalArcFrequency=cell(24,1);
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllAsymmetricalArcFrequency{k}=(255.0/1*(cos(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period)+1)/2);
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
fringeListAllAsymmetricalArcFrequencyGamma=cell(size(fringeListAllAsymmetricalArcFrequency));
for k=1:moveNumAll
    fringeListAllAsymmetricalArcFrequency{k}=fringeListAllAsymmetricalArcFrequency{k}(eachPeriodFringeStartIndex(1):eachPeriodFringeStartIndex(end)-1);
    % Gamma��������Ӧ
    fringeListAllAsymmetricalArcFrequencyGamma{k}=floor(filterGamma(floor(fringeListAllAsymmetricalArcFrequency{k})+1));
end

%% --���¼������������λ
wrappedPhaseAllAsymmetricalArcFrequency     =GetWrapPhase(fringeListAllAsymmetricalArcFrequency,     moveNumAll);
wrappedPhaseAllAsymmetricalArcFrequencyGamma=GetWrapPhase(fringeListAllAsymmetricalArcFrequencyGamma,moveNumAll);

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalAsymmetricalArcFrequency     =SelectNStepFring(fringeListAllAsymmetricalArcFrequency,     moveNumPart);
fringeListFractionalAsymmetricalArcFrequencyGamma=SelectNStepFring(fringeListAllAsymmetricalArcFrequencyGamma,moveNumPart);
% % ������Hilbert�任
% expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency=cell(size(fringeListFractionalAsymmetricalArcFrequency));
% for k=1:moveNumPart
%     sf=-period*(k-1)/moveNumPart;
%     expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=255.0/2*(sin(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(asymmetricalArcFactor*lengthOfSignal)))/period))/2;
%     expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}(eachPeriodFringeStartIndex(1):eachPeriodFringeStartIndex(end)-1);
% end

% ���Ĳ���ֵ
lengthOfSignal=eachPeriodFringeStartIndex(end)-eachPeriodFringeStartIndex(1);
lengthEnd=lengthOfSignal;
eachPeriodFringeStartIndex=eachPeriodFringeStartIndex-eachPeriodFringeStartIndex(1)+1;
eachPeriodFringeStartIndex(end)=eachPeriodFringeStartIndex(end)-1;

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalAsymmetricalArcFrequency     =GetWrapPhase(fringeListFractionalAsymmetricalArcFrequency,     moveNumPart);
wrappedPhaseFractionalAsymmetricalArcFrequencyGamma=GetWrapPhase(fringeListFractionalAsymmetricalArcFrequencyGamma,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcFrequency     =HilbertPerRow(fringeListFractionalAsymmetricalArcFrequency,     moveNumPart);
fringeListFractionalHilbertAsymmetricalArcFrequencyGamma=HilbertPerRow(fringeListFractionalAsymmetricalArcFrequencyGamma,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcFrequency     =GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcFrequency,     moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcFrequencyGamma=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcFrequencyGamma,moveNumPart);

%% --��ʾ�ǶԳ������������������������źż���Hilbert�任����λ���ͼ��
% �����ʾԭʼ�źš����ƺ����Ϻ���
figure('name',sprintf('1/%d Step of Original Fringe & Frequency-Modulated Signal by Asymmetrical Arc Function [Gamma]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalAsymmetricalArcFrequency{1},     plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
plot(fringeListFractionalAsymmetricalArcFrequencyGamma{1},plotLineType,'Color','m','LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringes [Gamma ($\\gamma$=%1.2f)]',moveNumPart,gamma),'Interpreter','latex');
legend('Modulated Signal','Modulated Signal [Gamma]','Location','NorthWest');
xlim([0,lengthOfSignal-1]);grid on;%ylim([-32,160]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% [Gamma without Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma] (Frequency Modulated by Asymmetrical Arc Function)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcFrequencyGamma    -wrappedPhaseAllAsymmetricalArcFrequencyGamma,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcFrequencyGamma-wrappedPhaseAllAsymmetricalArcFrequencyGamma,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
% ƽ����λ���
wrappedErrorMean=(wrappedErrorSpace+wrappedErrorHT)/2;
plot(wrappedErrorMean,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Asymmetrical Arc Frequency) [Gamma ($\\gamma$=%1.2f)]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% ���ź�[Gamma]��һ��[Normalization]����S/B����һ��������������λ��Hilbert����λ��ƽ����λ
% �����ź�[Gamma]
ABAllFrequencyModulatedGamma=GetABNormal(fringeListAllAsymmetricalArcFrequencyGamma,wrappedPhaseAllAsymmetricalArcFrequencyGamma);
% ��ʾ������ǿA
figure('name','Background Illumination A (Asymmetrical Arc Frequency) [Gamma/Normalization: S/B]','NumberTitle','off');
plot(ABAllFrequencyModulatedGamma{1},plotLineType,'LineWidth',1.0,'MarkerSize',2);
title('Background Illumination A (Asymmetrical Arc Frequency) [Gamma/Normalization: S/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
% ��ʾ���ƶ�B
figure('name','Frequency B (Asymmetrical Arc Frequency) [Gamma/Normalization: S/B]','NumberTitle','off');
plot(ABAllFrequencyModulatedGamma{2},plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Frequency B (Asymmetrical Arc Frequency) [Gamma/Normalization: S/B]');
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
fringeListAllAsymmetricalArcFrequencyGammaNorm=cell(size(fringeListAllAsymmetricalArcFrequencyGamma));
for k=1:moveNumAll
    fringeListAllAsymmetricalArcFrequencyGammaNorm{k}=fringeListAllAsymmetricalArcFrequencyGamma{k}./ABAllFrequencyModulatedGamma{2};
end
% fringeListAllAsymmetricalArcFrequencyGammaNorm=NormalizeFringe(fringeListAllAsymmetricalArcFrequencyGamma,moveNumAll,ABAllFrequencyModulatedGamma);
wrappedPhaseAllAsymmetricalArcFrequencyGammaNorm=GetWrapPhase(fringeListAllAsymmetricalArcFrequencyGammaNorm,moveNumAll);
% �����ź�[Gamma]
ABFractionalFrequencyModulatedGamma=GetABNormal(fringeListFractionalAsymmetricalArcFrequencyGamma,wrappedPhaseFractionalAsymmetricalArcFrequencyGamma);
fringeListFractionalAsymmetricalArcFrequencyGammaNorm=cell(size(fringeListFractionalAsymmetricalArcFrequencyGamma));
for k=1:moveNumPart
    fringeListFractionalAsymmetricalArcFrequencyGammaNorm{k}=fringeListFractionalAsymmetricalArcFrequencyGamma{k}./ABFractionalFrequencyModulatedGamma{2};
end
% fringeListFractionalAsymmetricalArcFrequencyGammaNorm=NormalizeFringe(fringeListFractionalAsymmetricalArcFrequencyGamma,moveNumPart,ABFractionalFrequencyModulatedGamma);
wrappedPhaseFractionalAsymmetricalArcFrequencyGammaNorm=GetWrapPhase(fringeListFractionalAsymmetricalArcFrequencyGammaNorm,moveNumPart);
% �����ź�Hilbert[Gamma]
fringeListFractionalHilbertAsymmetricalArcFrequencyGammaNorm=HilbertPerRow(fringeListFractionalAsymmetricalArcFrequencyGammaNorm,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcFrequencyGammaNorm=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcFrequencyGammaNorm,moveNumPart);

% ��ʾ��һ��[Normalization]���ź�
figure('name',sprintf('1/%d Step of Fringe (Asymmetrical Arc Frequency) [Gamma/Normalization: S/B]',moveNumPart),'NumberTitle','off');
plot(fringeListFractionalAsymmetricalArcFrequencyGammaNorm{1},plotLineType,'LineWidth',1.5,'MarkerSize',2);
title(sprintf('1/%d Step of Fringe (Asymmetrical Arc Frequency) [Gamma/Normalization: S/B]',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;% ylim([-1,1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% [Gamma with Normalization)��ʾ������λ��Hilbert����λ���
figure('name','Phase Error [Gamma/Normalization: S/B] (Asymmetrical Arc Frequency)','NumberTitle','off');
% ������λ���
wrappedErrorSpaceNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAsymmetricalArcFrequencyGammaNorm-wrappedPhaseAllAsymmetricalArcFrequencyGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);  
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHTNorm=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertAsymmetricalArcFrequencyGammaNorm-wrappedPhaseAllAsymmetricalArcFrequencyGammaNorm,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHTNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ƽ����λ���
wrappedErrorMeanNorm=(wrappedErrorSpaceNorm+wrappedErrorHTNorm)/2;
plot(wrappedErrorMeanNorm,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title(sprintf('Phase Error (Asymmetrical Arc Frequency) [Gamma ($\\gamma$=%1.2f)/Normalization: S/B]',gamma),'Interpreter','latex');
% ����Գ��������ε��Ʒ��ȱ��Ϊ1������ʾ��Hilbert����λ���
legend('Space Phase Error','HT Phase Error','Mean Phase Error','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

end


