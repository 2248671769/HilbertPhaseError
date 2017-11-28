% xAboutHilbertTransformNonIntegateFrequency.m
% �����20171106����һ
% �������������ڲ�����Hilbert�任�Լ�Hilbert����λ��Ӱ��
% ver��---
close all;clear;

%% @_@{���û�������}****************************************************
% ͼ�����Ʋ���
width=1024; height=800; period=128;

%% --Ƶ�ʵ���
% �������ڱ��
integatePeriodsFlag=1;
% ���������ڱ��
nonIntegatePeriodsFlag=1;

% �źŷ�Χ
numOfPeriods=8;
startOfSignal=1;
endOfSignal=startOfSignal+period*numOfPeriods-1;
lengthOfSignal=endOfSignal-startOfSignal+1;
% xTick & xTickLabel
xTick=zeros(1,numOfPeriods+2);
xTickLabel=cell(1,numOfPeriods+2);
for xt=0:numOfPeriods
    xTick(xt+1)=floor(xt*period); xTickLabel{xt+1}=num2str(xTick(xt+1));
end
xTick(end-1)=lengthOfSignal-1-period/2; xTickLabel{end-1}=num2str(lengthOfSignal-1-period/2);
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

%% @_@{��������Ƶ��}****************************************************
% �������ڱ��
if integatePeriodsFlag==1
%% --�����������ڵ�λ����������ź�
moveNumAll=24;
fringeListAllIntegatePeriods=cell(moveNumAll,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllIntegatePeriods{k} = floor(255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+1)/2);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalIntegatePeriods=SelectNStepFring(fringeListAllIntegatePeriods,moveNumPart);
expectedHilbertOfFringeListFractionalIntegatePeriods=cell(size(fringeListFractionalIntegatePeriods));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalIntegatePeriods{k}=255.0/2*(sin(((1:lengthOfSignal)-sf)/period*2*pi))/2;
end

%% --�������������λ
wrappedPhaseAllIntegatePeriods=GetWrapPhase(fringeListAllIntegatePeriods,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalIntegatePeriods=GetWrapPhase(fringeListFractionalIntegatePeriods,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertIntegatePeriods=HilbertPerRow(fringeListFractionalIntegatePeriods,moveNumPart);
wrappedPhaseFractionalHilbertIntegatePeriods=GetWrapPhaseWithHilbert(fringeListFractionalHilbertIntegatePeriods,moveNumPart);

%% --��ʾ���������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ���������źż���Hilbert�任
figure('name','Integate Periods of Signal and its Hilbert Transform','NumberTitle','off');
% ���������ź�
plot(fringeListFractionalIntegatePeriods{1},                       plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ����Hilbert�任���
plot(expectedHilbertOfFringeListFractionalIntegatePeriods{1},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% ʵ��Hilbert�任���
plot(imag(hilbert(fringeListFractionalIntegatePeriods{1})),        plotLineType,'Color','m','LineWidth',0.5,'MarkerSize',2);
title('Integate Periods of Signal and its Hilbert Transform');
legend('Signal','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��ʾ���������źŵ�FourierƵ��
figure('name','Fourier Spectrum of Integate Periods of Signal','NumberTitle','off');
plot(abs(fftshift(fft(fringeListFractionalIntegatePeriods{1}))),plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Fourier Spectrum of Integate Periods of Signal');
% xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);grid on;
xlim([0,lengthOfSignal-1]);grid on;
% set(gca, 'XTick', xTickFourierSpectrum);set(gca, 'XTickLabel',xTickLabelFourierSpectrum);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
figure('name','Integate Periods of Original Fringe','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalIntegatePeriods{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalIntegatePeriods{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalIntegatePeriods{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-96 160]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Integate Periods)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalIntegatePeriods-wrappedPhaseAllIntegatePeriods,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertIntegatePeriods-wrappedPhaseAllIntegatePeriods,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'Color','g','MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Frequency Changed by Step Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------integatePeriods-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);

end


%% @_@{����������}******************************************************
% ���������ڱ��
if nonIntegatePeriodsFlag==1
%% --���ɷ��������ڵ�λ����������ź�
moveNumAll=24;
fringeListAllNonIntegatePeriods=cell(moveNumAll,1);
for k=1:moveNumAll
    fringeListAllNonIntegatePeriods{k}=fringeListAllIntegatePeriods{k}(startOfSignal:endOfSignal-period/2);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListFractionalNonIntegatePeriods=SelectNStepFring(fringeListAllNonIntegatePeriods,moveNumPart);
expectedHilbertOfFringeListFractionalNonIntegatePeriods=cell(size(fringeListFractionalIntegatePeriods));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    expectedHilbertOfFringeListFractionalNonIntegatePeriods{k}=255.0/2*(sin(((1:lengthOfSignal-period/2)-sf)/period*2*pi))/2;
end

%% --�������������λ
wrappedPhaseAllNonIntegatePeriods=GetWrapPhase(fringeListAllNonIntegatePeriods,moveNumAll);

%% --���������������ƵĿ�����λ
wrappedPhaseFractionalNonIntegatePeriods=GetWrapPhase(fringeListFractionalNonIntegatePeriods,moveNumPart);

%% --���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertNonIntegatePeriods=HilbertPerRow(fringeListFractionalNonIntegatePeriods,moveNumPart);
wrappedPhaseFractionalHilbertNonIntegatePeriods=GetWrapPhaseWithHilbert(fringeListFractionalHilbertNonIntegatePeriods,moveNumPart);

%% --��ʾ�����������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�����������źż���Hilbert�任
figure('name','Non-Integate Periods of Signal and its Hilbert Transform','NumberTitle','off');
% �����������ź�
plot(fringeListFractionalNonIntegatePeriods{1},                       plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ����Hilbert�任���
plot(expectedHilbertOfFringeListFractionalNonIntegatePeriods{1},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% ʵ��Hilbert�任���
plot(imag(hilbert(fringeListFractionalNonIntegatePeriods{1})),        plotLineType,'Color','m','LineWidth',0.5,'MarkerSize',2);
title('Non-Integate Periods of Signal and its Hilbert Transform');
legend('Signal','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��ʾ���������źŵ�FourierƵ��
figure('name','Fourier Spectrum of Non-Integate Periods of Signal','NumberTitle','off');
plot(abs(fftshift(fft(fringeListFractionalNonIntegatePeriods{1}))),plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Fourier Spectrum of Non-Integate Periods of Signal');
% xlim([min(xTickFourierSpectrum),max(xTickFourierSpectrum)]);
grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ��ʾ�źż���Hilbert�任
figure('name','Non-Integate Periods of Original Fringe','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    % �����ź�
    plot(fringeListFractionalNonIntegatePeriods{k},                       plotLineType,'LineWidth',1.0);hold on;
    % ����Hilbert�任���
    plot(expectedHilbertOfFringeListFractionalNonIntegatePeriods{k},plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
    % ʵ��Hilbert�任���
    plot(imag(hilbert(fringeListFractionalNonIntegatePeriods{k})),        plotLineType,'Color','m','LineWidth',1.0);
    title(sprintf('%d/%d Step of Original Fringe and its Hilbert Transform',k,moveNumPart));
    if k==moveNumPart
        legend('Original Fringe','Expected HT','Actual HT','Location','SouthOutside','Orientation','Horizontal');
    end
    xlim([0,lengthOfSignal-1]);ylim([-96 160]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

% ��ʾHilbert�任����ֵ��ʵ��ֵ�������������
figure('name','Fringe Error between Expected HT and Actual HT','NumberTitle','off');
for k=1:moveNumPart
    subplot(moveNumPart,1,k);
    plot(imag(hilbert(fringeListFractionalNonIntegatePeriods{k}))-expectedHilbertOfFringeListFractionalNonIntegatePeriods{k},plotLineType,'Color',[0,0,153]/255,'LineWidth',1.0);
    title(sprintf('%d/%d Step of Fringe Error between Expected HT and Actual HT',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Non-Integate Periods)','NumberTitle','off');
% ������λ���
wrappedErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalNonIntegatePeriods    -wrappedPhaseAllNonIntegatePeriods,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorSpace,plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ���������ڵ�Hilbert����λ���
wrappedErrorHT=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertNonIntegatePeriods-wrappedPhaseAllNonIntegatePeriods,upPhaseErrorBound,bottomPhaseErrorBound);
plot(wrappedErrorHT,   plotLineType,'LineWidth',0.5,'MarkerSize',2);
title('Phase Error (Non-Integate Periods)');
legend('Space Phase Error','HT Phase Error','Location','SouthEast');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert����λ����ƽ��ֵ����ֵ�������
fprintf('------------nonIntegatePeriods-------------\n');
fprintf('        Mean of   Space Phase Error: %+f\n',mean(wrappedErrorSpace));
fprintf('Max positive of   Space Phase Error: %+f\n',max( wrappedErrorSpace));
fprintf('Max negative of   Space Phase Error: %+f\n',min( wrappedErrorSpace));
fprintf('        RMSE of   Space Phase Error: %+f\n',sqrt(sum((wrappedErrorSpace-mean(wrappedErrorSpace)).^2))/lengthOfSignal);
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(wrappedErrorHT));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max( wrappedErrorHT));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min( wrappedErrorHT));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((wrappedErrorHT-mean(wrappedErrorHT)).^2))/lengthOfSignal);

end

