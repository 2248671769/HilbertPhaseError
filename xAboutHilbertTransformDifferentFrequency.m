% xAboutHilbertTransformDifferentFrequency.m
% �����20171106����һ
% �ı������źŵ�Ƶ�ʣ������������ڲ�������������ڲ�����Hilbert�任�Լ�Hilbert����λ��Ӱ��
% ver��---
close all;clear;

%% {���û�������}*********************************************************
% ͼ�����Ʋ���
width=1024; height=800; period=64;

%% -Ƶ�ʵ���
% ��Ծ����Ƶ�ʱ��
stepFrequencyModulateFlag=1;
% �Գ���������Ƶ�ʱ��
symmetricalArcFrequencyModulateFlag=1;
% �ǶԳ���������Ƶ�ʱ��
asymmetricalArcFrequencyModulateFlag=1;

% �źŷ�Χ
numOfPeriods=16;
startOfSignal=1;endOfSignal=width;
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
partNum=30;
xTickFourierSpectrum=zeros(1,partNum+1);
xTickLabelFourierSpectrum=cell(1,partNum+1);
for xt=0:partNum/2
    xTickFourierSpectrum(partNum/2+xt+1)=lengthOfSignal/2+1+xt+xt; xTickLabelFourierSpectrum{partNum/2+xt+1}=num2str( xt+xt);
    xTickFourierSpectrum(partNum/2-xt+1)=lengthOfSignal/2+1-xt-xt; xTickLabelFourierSpectrum{partNum/2-xt+1}=num2str(-xt-xt);
end
xTickFourierSpectrum(partNum/2+1)=lengthOfSignal/2+1; xTickLabelFourierSpectrum{partNum/2+1}=num2str(0);

% ��λ�����ʾ��Ч����
upPhaseErrorBound=2; bottomPhaseErrorBound=-2;

% plot��������
plotLineType='';        % '' ʵ��
plotDottedLineType=':'; % ':'����

%% {��Ծʽ����Ƶ��}******************************************************
% ��Ծ����Ƶ�ʱ��
if stepFrequencyModulateFlag==1
%% -����24����Ծʽ����Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllStepFrequency=cell(24,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    for i=1:lengthOfSignal
        if i<lengthOfSignal/2
            fringeListAllStepFrequency{k}(:,i)=floor(255.0/2*(cos((i-1-sf)/period*2*pi)+1)/2);
        else
            T1=period;T2=period*2;
            zz=(T1-T2)*(lengthOfSignal/2-1-sf)/T1;
            fringeListAllStepFrequency{k}(:,i)=floor(255.0/2*(cos((i-1-sf-zz)/T2 *2*pi)+1)/2);
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

%% -�������������λ
wrappedPhaseAllStepFrequency=GetWrapPhase(fringeListAllStepFrequency,moveNumAll);

%% -���������������ƵĿ�����λ
wrappedPhaseFractionalStepFrequency=GetWrapPhase(fringeListFractionalStepFrequency,moveNumPart);

%% -���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertStepFrequency=HilbertPerRow(fringeListFractionalStepFrequency,moveNumPart);
wrappedPhaseFractionalHilbertStepFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertStepFrequency,moveNumPart);

%% -��ʾ��Ծ�������������������źż���Hilbert�任����λ���ͼ��
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
fprintf('          Mean of Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('  Max positive of Space Phase Error: %+f\n',max(wrappedErrorSpace));
fprintf('  Max negative of Space Phase Error: %+f\n',min(wrappedErrorSpace));
fprintf('          RMSE of Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max(wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min(wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);
end


%% {�Գ���������Ƶ��}******************************************************
% �Գ���������Ƶ�ʱ��
if symmetricalArcFrequencyModulateFlag==1
%% -����24���Գ���������Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
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
expectedHilbertOfFringeListFractionalSymmetricalArcFrequency=cell(size(fringeListFractionalStepFrequency));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalSymmetricalArcFrequency{k}=255.0/2*(sin(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/lengthOfSignal))/period))/2;
end

%% -�������������λ
wrappedPhaseAllSymmetricalArcFrequency=GetWrapPhase(fringeListAllSymmetricalArcFrequency,moveNumAll);

%% -���������������ƵĿ�����λ
wrappedPhaseFractionalSymmetricalArcFrequency=GetWrapPhase(fringeListFractionalSymmetricalArcFrequency,moveNumPart);

%% -���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertSymmetricalArcFrequency=HilbertPerRow(fringeListFractionalSymmetricalArcFrequency,moveNumPart);
wrappedPhaseFractionalHilbertSymmetricalArcFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertSymmetricalArcFrequency,moveNumPart);

%% -��ʾ�Գ������������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�Գ�����
symmetricalArcFrequencyFunction=(0:lengthOfSignal-1)+100*sin(2*pi*(0:lengthOfSignal-1)/width);
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
fprintf('          Mean of Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('  Max positive of Space Phase Error: %+f\n',max(wrappedErrorSpace));
fprintf('  Max negative of Space Phase Error: %+f\n',min(wrappedErrorSpace));
fprintf('          RMSE of Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max(wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min(wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);

end


%% {�ǶԳ���������Ƶ��}******************************************************
% �ǶԳ���������Ƶ�ʱ��
if asymmetricalArcFrequencyModulateFlag==1
%% -����24���ǶԳ���������Ƶ��ȫ������ͼ�񲢴��г�ȡ��������������ͼ��
moveNumAll=24;
fringeListAllAsymmetricalArcFrequency=cell(24,1);
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllAsymmetricalArcFrequency{k}=floor(255.0/2*(cos(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(1.25*lengthOfSignal)))/period)+1)/2);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalAsymmetricalArcFrequency=SelectNStepFring(fringeListAllAsymmetricalArcFrequency,moveNumPart);
% ������Hilbert�任
expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency=cell(size(fringeListFractionalStepFrequency));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalAsymmetricalArcFrequency{k}=255.0/2*(sin(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(1.25*lengthOfSignal)))/period))/2;
end

%% -�������������λ
wrappedPhaseAllAsymmetricalArcFrequency=GetWrapPhase(fringeListAllAsymmetricalArcFrequency,moveNumAll);

%% -���������������ƵĿ�����λ
wrappedPhaseFractionalAsymmetricalArcFrequency=GetWrapPhase(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);

%% -���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAsymmetricalArcFrequency=HilbertPerRow(fringeListFractionalAsymmetricalArcFrequency,moveNumPart);
wrappedPhaseFractionalHilbertAsymmetricalArcFrequency=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAsymmetricalArcFrequency,moveNumPart);

%% -��ʾ�ǶԳ������������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�ǶԳ�����
symmetricalArcFrequencyFunction=(0:lengthOfSignal-1)+100*sin(2*pi*(0:lengthOfSignal-1)/(1.25*width));
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
fprintf('          Mean of Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('  Max positive of Space Phase Error: %+f\n',max(wrappedErrorSpace));
fprintf('  Max negative of Space Phase Error: %+f\n',min(wrappedErrorSpace));
fprintf('          RMSE of Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max(wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min(wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);

end





