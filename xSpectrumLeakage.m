% xSpectrumLeakage.m
% �����20171108
% ����Ƶ��й©
% ver:---
close all;clear;

% plot��������
plotLineType='';        % '' ʵ��
plotDottedLineType=':'; % ':'����

%% @_@{���������ź�}*****************************************************
% ��������(ʱ����)
timeSample = 0.000625;
% ����Ƶ�ʣ��������ڵĵ���
frequencySample = 1/timeSample;
% ԭʼ�źŵ�Ƶ��
frequencySignal = 80;
% ÿ�����ڵĲ�������
samplingPointsNumEachPeriod = frequencySample / frequencySignal;

% ����������Ŀ
samplingPeriodNum = 8;

% ������ֹʱ��
timeStart = 0;
timeEnd = timeStart+samplingPeriodNum*samplingPointsNumEachPeriod *timeSample-timeSample;
% ����ʱ������
timeSequence = timeStart:timeSample:timeEnd;
% ����ʱ��
duration = timeEnd-timeStart+timeSample;
% ��������Ŀ
samplingPointsNum = duration/timeSample+1;
% ����Ƶ������
frequencySequency = 0:frequencySample/(samplingPointsNum-1):frequencySample-frequencySample/(samplingPointsNum-1);

% ��ԭʼ�źŽ��в���
dataSample = sin(2*pi*frequencySignal*timeSequence);%+2*sin(2*pi*40*t);
% �Բ����źŽ���Fourier�任
fftDataSample = fft(dataSample);

% ����ԭʼ�ź�
figure('name','Integate Periods of Signal','NumberTitle','off');
plot(timeSequence,dataSample,'*-');
title('Integate Periods of Signal');
grid on;
xlim([timeStart,timeStart+ceil(samplingPeriodNum)*samplingPointsNumEachPeriod *timeSample]);
ylim([min(dataSample)-0.1,max(dataSample)+0.1]);
% xTick & xTickLabel
xTick = timeStart:timeSample*samplingPointsNumEachPeriod:timeStart+ceil(samplingPeriodNum)*samplingPointsNumEachPeriod *timeSample;
xTickLabel = cell(1,ceil(samplingPeriodNum));
for k = 1:length(xTick)
    if k==1
        xTickLabel{k} = sprintf('%.4f',xTick(k));
    else
        xTickLabel{k} = sprintf('[%d]%.4f',k-1,xTick(k));
    end
end
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
xlabel('Time (/$s$)','Interpreter','latex');
ylabel('Amplitude');

% ����Ƶ��
figure('name','Fourier Spectrum (Integate Periods of Signal)','NumberTitle','off');
stem(frequencySequency-frequencySample/2,abs(fftshift(fftDataSample)));
title('Fourier Spectrum (Integate Periods of Signal)');
grid on;
xlim([min(frequencySequency-frequencySample/2),max(frequencySequency-frequencySample/2)]);
% xTick & xTickLabel
xTick2 = [-ceil(frequencySample/2):frequencySignal*2:-frequencySignal*2,-frequencySignal,...
    0,frequencySignal,frequencySignal*2:frequencySignal*2:ceil(frequencySample/2)];
xTickLabel2 = cell(1,length(xTick2));
for k = 1:length(xTick2)
  xTickLabel2{k} = num2str(xTick2(k));
end
set(gca, 'XTick', xTick2);set(gca, 'XTickLabel',xTickLabel2);
xlabel('Frequency (/$Hz$)','Interpreter','latex');
ylabel('Magnitude');

% ��ʾ���������źż���Hilbert�任
figure('name','Integate Periods of Signal and its Hilbert Transform','NumberTitle','off');
% ���������ź�
plot(timeSequence,dataSample,                       plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ����Hilbert�任���
expectedHilbert=-cos(2*pi*frequencySignal*timeSequence);
plot(timeSequence,expectedHilbert,plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% ʵ��Hilbert�任���
plot(timeSequence,imag(hilbert(dataSample)),        plotLineType,'Color','m','LineWidth',0.5,'MarkerSize',2);
title('Integate Periods of Signal and its Hilbert Transform');
legend('Signal','Expected HT','Actual HT','Location','southoutside','Orientation','horizontal');
xlim([timeStart,timeStart+ceil(samplingPeriodNum)*samplingPointsNumEachPeriod *timeSample]);
ylim([min(dataSample)-0.1,max(dataSample)+0.1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
grid on;


%% @_@{�����������ź�}**************************************************
% ��������(ʱ����)
timeSample = 0.000625;
% ����Ƶ�ʣ��������ڵĵ���
frequencySample = 1/timeSample;
% ԭʼ�źŵ�Ƶ��
frequencySignal = 80;
% ÿ�����ڵĲ�������
samplingPointsNumEachPeriod = frequencySample / frequencySignal;

% ����������Ŀ
samplingPeriodNum = 8.5;

% ������ֹʱ��
timeStart = 0;
timeEnd = timeStart+samplingPeriodNum*samplingPointsNumEachPeriod *timeSample-timeSample;
% ����ʱ������
timeSequence = timeStart:timeSample:timeEnd;
% ����ʱ��
duration = timeEnd-timeStart+timeSample;
% ��������Ŀ
samplingPointsNum = duration/timeSample+1;
% ����Ƶ������
frequencySequency = 0:frequencySample/(samplingPointsNum-1):frequencySample-frequencySample/(samplingPointsNum-1);

% ��ԭʼ�źŽ��в���
dataSample = sin(2*pi*frequencySignal*timeSequence);%+2*sin(2*pi*40*t);
% �Բ����źŽ���Fourier�任
fftDataSample = fft(dataSample);

% ����ԭʼ�ź�
figure('name','Non-Integate Periods of Signal','NumberTitle','off');
plot(timeSequence,dataSample,'*-');
title('Non-Integate Periods of Signal');
grid on;
xlim([timeStart,timeStart+ceil(samplingPeriodNum)*samplingPointsNumEachPeriod *timeSample]);
ylim([min(dataSample)-0.1,max(dataSample)+0.1]);
% xTick & xTickLabel
xTick = timeStart:timeSample*samplingPointsNumEachPeriod:timeStart+ceil(samplingPeriodNum)*samplingPointsNumEachPeriod *timeSample;
xTickLabel = cell(1,ceil(samplingPeriodNum));
for k = 1:length(xTick)
    if k==1
        xTickLabel{k} = sprintf('%.4f',xTick(k));
    else
        xTickLabel{k} = sprintf('[%d]%.4f',k-1,xTick(k));
    end
end
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
xlabel('Time (/$s$)','Interpreter','latex');
ylabel('Amplitude');

% ����Ƶ��
figure('name','Fourier Spectrum (Non-Integate Periods of Signal)','NumberTitle','off');
stem(frequencySequency-frequencySample/2,abs(fftshift(fftDataSample)));
title('Fourier Spectrum (Non-Integate Periods of Signal)');
grid on;
xlim([min(frequencySequency-frequencySample/2),max(frequencySequency-frequencySample/2)]);
% xTick & xTickLabel
xTick2 = [-ceil(frequencySample/2):frequencySignal*2:-frequencySignal*2,-frequencySignal,...
    0,frequencySignal,frequencySignal*2:frequencySignal*2:ceil(frequencySample/2)];
xTickLabel2 = cell(1,length(xTick2));
for k = 1:length(xTick2)
  xTickLabel2{k} = num2str(xTick2(k));
end
set(gca, 'XTick', xTick2);set(gca, 'XTickLabel',xTickLabel2);
xlabel('Frequency (/$Hz$)','Interpreter','latex');
ylabel('Magnitude');

% ��ʾ�����������źż���Hilbert�任
figure('name','Non-Integate Periods of Signal and its Hilbert Transform','NumberTitle','off');
% �����������ź�
plot(timeSequence,dataSample,                       plotLineType,'LineWidth',0.5,'MarkerSize',2);hold on;
% ����Hilbert�任���
expectedHilbert=-cos(2*pi*frequencySignal*timeSequence);
plot(timeSequence,expectedHilbert,plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% ʵ��Hilbert�任���
plot(timeSequence,imag(hilbert(dataSample)),        plotLineType,'Color','m','LineWidth',0.5,'MarkerSize',2);
title('Non-Integate Periods of Signal and its Hilbert Transform');
legend('Signal','Expected HT','Actual HT','Location','southoutside','Orientation','horizontal');
xlim([timeStart,timeStart+ceil(samplingPeriodNum)*samplingPointsNumEachPeriod *timeSample]);
ylim([min(imag(hilbert(dataSample)))-0.1,max(imag(hilbert(dataSample)))+0.1]);
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
grid on;

