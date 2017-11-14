% xFringeContinuation.m
% ���������ģ��������Ң�ṩ��20171110
% �ܷ������ź�Ƶ��й¶��Ӱ�죬Hilbert����λ���Ŵ�
% �����۵���λ�߽����˵�����ȱʧ�������źŽ������أ��ټ���Hilbert����λ�����������λ�����ƽ��ֵ��ʵ����λ����
% ver:---
% �������裺
% 1.��ȡ[24�����������λwp24]��[4��������λwp4]
% 2.��ȡ[��һ�����4��Hilbert����λwpnHT4]
% 3.����[wp4]��[wpnHT4]��[��ֵ��λmeanOfwp4AndwpnHT4],�������ֵ��[wp24]����λ���
% 4.�Թ�һ����������źŵı߽����˷ֱ������������
% 5.����[�������غ��Hilbert����λwpncHT4]������[wp4]��[wpncHT4]��[��ֵ��λmeanOfwp4AndwpncHT4]���������ֵ��[wp24]����λ���
% 6.�Ƚ�����������λ���
close all;clear;

%% {���û�������}*************************************************
% ͼ�����Ʋ���
width=1024; height=800; period=64;

%% -�ź����ر��
% ��Ծʽ��ǶԳ��������β��з��ȵ��Ʊ��
amplitudeModulatedFlag=0;
% ȫ���ƣ���Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���
modulatedGroupFlag=1;

% �źŷ�Χ
numOfPeriods=16;
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
% xTickContinuation & xTickLabelkContinuation
xTickContinuation=zeros(1,numOfPeriods+1);
xTickLabelContinuation=cell(1,numOfPeriods+1);
for xt=0:numOfPeriods
    xTickContinuation(xt+1)=floor(xt*period*2); xTickLabelContinuation{xt+1}=num2str(xTickContinuation(xt+1));
end
xTickContinuation(end)=lengthOfSignal*2-1; xTickLabelContinuation{end}=num2str(xTickContinuation(end));

% ��λ�����ʾ��Ч����
upPhaseErrorBound=2; bottomPhaseErrorBound=-2;

% plot��������
plotLineType='';        % '' ʵ��
plotDottedLineType=':'; % ':'����

%% {���ɸ�������ź�}********************************************
% -��λ����������ź�
moveNumAll=24;
fringeListAllUnit=cell(moveNumAll,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllUnit{k} = floor(255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+1)/2);
end

%% -��Ծʽ��ǶԳ��������β��з��ȵ����ź�
fringeListAllAmplitudeModulated=cell(moveNumAll,1);
% ��Ծ����
filterStepAmplitude=[ones(1,lengthOfSignal/2) 2*ones(1,lengthOfSignal/2)];
% �ǶԳ��������κ���
arcCenter=0.625;
filterAsymmetricalArcAmplitude=1-1.0*((0:lengthOfSignal-1)/lengthOfSignal-arcCenter).^2;
for k=1:moveNumAll
    fringeListAllAmplitudeModulated{k}=fringeListAllUnit{k}.*filterStepAmplitude.*filterAsymmetricalArcAmplitude;
end

%% -��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ����ź�
fringeListAllModulatedGroup=cell(moveNumAll,1);
for k=1:moveNumAll
    sf=-period*(k-1)/moveNumAll;
    fringeListAllModulatedGroup{k}=255.0/2*(cos(2*pi*((0:lengthOfSignal-1)-sf+100*sin(2*pi*(0:lengthOfSignal-1)/(1.25*lengthOfSignal)))/period)+1)/2 ...
         .*filterStepAmplitude.*filterAsymmetricalArcAmplitude;
end

%% -��ȡ������Ƶ������ź�
moveNumPart=4;
% -��λ����������ź�
fringeListFractionalUnit=SelectNStepFring(fringeListAllUnit,moveNumPart);
% -��Ծʽ��ǶԳ��������β��з��ȵ���
fringeListFractionalAmplitudeModulated=SelectNStepFring(fringeListAllAmplitudeModulated,moveNumPart);
% -��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���
fringeListFractionalModulatedGroup=SelectNStepFring(fringeListAllModulatedGroup,moveNumPart);

%% -�������������λ
% ��λ����
wrappedPhaseAllUnit=GetWrapPhase(fringeListAllUnit,moveNumAll);
ABAllUnit=GetABNormal(fringeListAllUnit,wrappedPhaseAllUnit);
% ��Ծʽ��ǶԳ��������β��з��ȵ���
wrappedPhaseAllAmplitudeModulated=GetWrapPhase(fringeListAllAmplitudeModulated,moveNumAll);
ABAllAmplitudeModulated=GetABNormal(fringeListAllAmplitudeModulated,wrappedPhaseAllAmplitudeModulated);
% ��Ծʽ��ǶԳ��������β��з��ȵ���
wrappedPhaseAllModulatedGroup=GetWrapPhase(fringeListAllModulatedGroup,moveNumAll);
ABAllModulatedGroup=GetABNormal(fringeListAllModulatedGroup,wrappedPhaseAllModulatedGroup);

%% -������������(��λ����������ź�)�Ŀ�����λ
wrappedPhaseFractionalUnit=GetWrapPhase(fringeListFractionalUnit,moveNumPart);

%% -��ʾ�����ź�
for k=1:moveNumPart
    figure('name',sprintf('%d/%d Step of Fringe Signal (Modulated Group)',k,moveNumPart),'NumberTitle','off');
    % -��λ����������ź�
    plot(fringeListFractionalUnit{k},':','LineWidth',1.5);hold on;
    % -��Ծʽ��ǶԳ��������β��з��ȵ����ź�
    plot(fringeListFractionalAmplitudeModulated{k},'b');
    % -��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ����ź�
    plot(fringeListFractionalModulatedGroup{k},'LineWidth',2);
    title(sprintf('%d/%d Step of Fringe Signal (Modulated Group)',k,moveNumPart));
    legend('Unit Fringe','Amplitude Modulated','Modulated Group');
    xlim([0,lengthOfSignal-1]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
end

%% *****************************************************************
if amplitudeModulatedFlag==1
%% [Hilbert]-[����]-(��Ծʽ��ǶԳ��������β��з��ȵ����ź�)*
%% -������������(��Ծʽ��ǶԳ��������β��з��ȵ���)�Ŀ�����λ
wrappedPhaseFractionalAmplitudeModulated=GetWrapPhase(fringeListFractionalAmplitudeModulated,moveNumPart);
ABFractionalAmplitudeModulated=GetABNormal(fringeListFractionalAmplitudeModulated,wrappedPhaseFractionalAmplitudeModulated);

%% -[Hilbert]-���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertAmplitudeModulated=HilbertPerRow(fringeListFractionalAmplitudeModulated,moveNumPart);
wrappedPhaseFractionalHilbertAmplitudeModulated=GetWrapPhaseWithHilbert(fringeListFractionalHilbertAmplitudeModulated,moveNumPart);

% %% -��ʾHilbert�任
% for k=1:moveNumPart
%     figure('name',sprintf('%d/%d Hilbert Transform of Fringe Signal (Amplitude Modulated)',k,moveNumPart),'NumberTitle','off');
%     % -��Ծʽ��ǶԳ��������β��з��ȵ����ź�
%     plot(fringeListFractionalAmplitudeModulated{k});hold on;
%     % -Hilbert�任
%     plot(imag(hilbert(fringeListFractionalAmplitudeModulated{k})),'LineWidth',1.5);
%     title(sprintf('%d/%d Hilbert Transform of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
%     legend('Amplitude Modulated','Hilbert Transform','Location','SouthWest');
%     xlim([0,lengthOfSignal-1]);grid on;
%     set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
%     set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% end

%% -��һ������(fringe-A)/B����һ����Ŀ�����λ
fringeListAllNormalizationAmplitudeModulated=NormalizeFringe(fringeListAllAmplitudeModulated,moveNumAll,ABAllAmplitudeModulated);
wrappedPhaseAllNormalizationAmplitudeModulated=GetWrapPhase(fringeListAllNormalizationAmplitudeModulated,moveNumAll);

%% -��һ������(fringe-A)/B����һ����Ŀ�����λ
fringeListFractionalNormalizationAmplitudeModulated=NormalizeFringe(fringeListFractionalAmplitudeModulated,moveNumPart,ABFractionalAmplitudeModulated);
wrappedPhaseFractionalNormalizationAmplitudeModulated=GetWrapPhase(fringeListFractionalNormalizationAmplitudeModulated,moveNumPart);
for k=1:moveNumPart
    figure('name',sprintf('%d/%d Step of Normalization of Fringe Signal (Amplitude Modulated)',k,moveNumPart),'NumberTitle','off');
    % -��Ծʽ��ǶԳ��������β��з��ȵ����ź�
    subplot(2,1,1);
    plot(fringeListFractionalAmplitudeModulated{k});hold on;
    title(sprintf('%d/%d Step of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);ylim([0,256]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
    % -��һ������(fringe-A)/B
    subplot(2,1,2);
    plot(fringeListFractionalNormalizationAmplitudeModulated{k},'m','LineWidth',1.5);hold on;
    sf=-period*(k-1)/moveNumPart;
    plot(cos(((0:lengthOfSignal-1)-sf)/period*2*pi),plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);
    title(sprintf('%d/%d Step of Normalization of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
    legend('Normalizaion','Ideal Cosine','Location','SouthOutside','Orientation','Horizontal');
    xlim([0,lengthOfSignal-1]);ylim([-1.05,1.05]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

% %% -{����}
% fringeListFractionalContinuationAmplitudeModulated=cell(size(fringeListFractionalAmplitudeModulated));
% for k=1:moveNumPart
%     sf=-period*(k-1)/moveNumPart;
%     fringeListAllUnit{k} = floor(255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+1)/2);
%     fringeListFractionalContinuationAmplitudeModulated{k}=[ ...
%         fringeListFractionalNormalizationAmplitudeModulated{k}, ...
%         cos(((lengthOfSignal)-sf)/period*2*pi), ...
%         (mod(k,2)*(mod(k,2)+1)-1)*fliplr(fringeListFractionalNormalizationAmplitudeModulated{k}(1:lengthOfSignal))
%         ];
%     
%     figure('name',sprintf('%d/%d Step of Continuation of Fringe Signal (Amplitude Modulated)',k,moveNumPart),'NumberTitle','off');
%     % -��Ծʽ��ǶԳ��������β��з��ȵ����ź�
%     plot(fringeListFractionalNormalizationAmplitudeModulated{k});hold on;
%     % -Hilbert�任
%     plot(imag(hilbert(fringeListFractionalNormalizationAmplitudeModulated{k})),plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);
%     % -����
%     plot(lengthOfSignal:lengthOfSignal*2, fringeListFractionalContinuationAmplitudeModulated{k}(lengthOfSignal:lengthOfSignal*2),'m','LineWidth',1.0);
%     % -Hilbert�任(����)
%     plot(imag(hilbert(fringeListFractionalContinuationAmplitudeModulated{k})),'LineWidth',1.5);
%     title(sprintf('%d/%d Step of Continuation of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
%     legend('Amplitude Modulated','Hilbert Transform','Continuation','Hilbert Transform(Continuation)','Location','NorthEast');
%     xlim([0,lengthOfSignal*2-1]);grid on;
%     set(gca, 'XTick', xTickContinuation);set(gca, 'XTickLabel',xTickLabelContinuation);
% %     set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% 
% end

%% -[Hilbert]-�����һ����������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertNormalizationAmplitudeModulated=HilbertPerRow(fringeListFractionalNormalizationAmplitudeModulated,moveNumPart);
wrappedPhaseFractionalHilbertNormalizationAmplitudeModulated=GetWrapPhaseWithHilbert(fringeListFractionalHilbertNormalizationAmplitudeModulated,moveNumPart);

%% -��һ�����ƽ����λ=(��һ����Ŀ�����λ+��һ����Hilbert����λ)/2
wrappedPhaseFractionalMeanNormalization=(wrappedPhaseFractionalNormalizationAmplitudeModulated+wrappedPhaseFractionalHilbertNormalizationAmplitudeModulated)/2.0;

%% -��ʾ��һ�������λ
figure('name','Phase after Normalization (Amplitude Modulated)','NumberTitle','off');
% 24�����ƹ�һ��������������λ
plot(wrappedPhaseAllNormalizationAmplitudeModulated, plotDottedLineType,'LineWidth',1.5);hold on;
% �������ƹ�һ����Ŀ�����λ
plot(wrappedPhaseFractionalNormalizationAmplitudeModulated, plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% �������ƹ�һ�����Hilbert����λ
plot(wrappedPhaseFractionalHilbertNormalizationAmplitudeModulated,       plotLineType,'Color','g','LineWidth',1.0);hold on;
% �������ƹ�һ�����ƽ����λ
plot(wrappedPhaseFractionalMeanNormalization,       plotLineType,'Color','m','LineWidth',1.0);
title('Phase Error after Normalization (Amplitude Modulated)');
legend( ...
    sprintf('Space Phase after Normalization (Ideal %d Steps)',moveNumAll), ...
    sprintf('Space Phase after Normalization (%d Steps)',moveNumPart), ...
    sprintf('Hilbert Phase after Normalization (%d Steps Amplitude Modulated)',moveNumPart), ...
    sprintf('Mean Phase after Normalization (%d Steps Amplitude Modulated)',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% -��ʾ��һ�������λ���
figure('name','Phase Error after Normalization (Amplitude Modulated)','NumberTitle','off');
% �������ƹ�һ����Ŀ�����λ���
phaseErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalNormalizationAmplitudeModulated-wrappedPhaseAllNormalizationAmplitudeModulated,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseErrorSpace, plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% �������ƹ�һ�����Hilbert����λ���
phaseErrorHilbert=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertNormalizationAmplitudeModulated-wrappedPhaseAllNormalizationAmplitudeModulated,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseErrorHilbert,     plotLineType,'Color','g','LineWidth',1.0);hold on;
% �������ƹ�һ�����ƽ����λ���
phaseErrorMean=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalMeanNormalization-wrappedPhaseAllNormalizationAmplitudeModulated,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseErrorMean,        plotLineType,'Color','m','LineWidth',1.0);
title(sprintf('Phase Error after Normalization (%d Steps Amplitude Modulated)',moveNumPart));
legend( ...
    'Space Phase Error after Normalization', ...
    'Hilbert Phase Error after Normalization', ...
    'Mean  Phase Error after Normalization');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/ƽ����λ����ƽ��ֵ����ֵ�������
% �������ƹ�һ����Ŀ�����λ���
fprintf('------------Phase Error after Normalization (%d Steps Amplitude Modulated)-------------\n',moveNumPart);
fprintf('          Mean of Space Phase Error: %+f\n',mean(phaseErrorSpace));
fprintf('  Max positive of Space Phase Error: %+f\n',max(phaseErrorSpace));
fprintf('  Max negative of Space Phase Error: %+f\n',min(phaseErrorSpace));
fprintf('          RMSE of Space Phase Error: %+f\n',sqrt(sum((phaseErrorSpace  -mean(phaseErrorSpace))  .^2))/lengthOfSignal);
% �������ƹ�һ�����Hilbert����λ���
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(phaseErrorHilbert));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max(phaseErrorHilbert));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min(phaseErrorHilbert));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((phaseErrorHilbert-mean(phaseErrorHilbert)).^2))/lengthOfSignal);
% �������ƹ�һ�����ƽ����λ���
fprintf('           Mean of Mean Phase Error: %+f\n',mean(phaseErrorMean));
fprintf('   Max positive of Mean Phase Error: %+f\n',max(phaseErrorMean));
fprintf('   Max negetive of Mean Phase Error: %+f\n',min(phaseErrorMean));
fprintf('           RMSE of Mean Phase Error: %+f\n',sqrt(sum((phaseErrorMean   -mean(phaseErrorMean))   .^2))/lengthOfSignal);
end

%% *****************************************************************
if modulatedGroupFlag==1
%% [Hilbert]-[����]-(ȫ���ƣ���Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���)*
%% -������������(ȫ����)�Ŀ�����λ
wrappedPhaseFractionalModulatedGroup=GetWrapPhase(fringeListFractionalModulatedGroup,moveNumPart);
ABFractionalModulatedGroup=GetABNormal(fringeListFractionalModulatedGroup,wrappedPhaseFractionalModulatedGroup);

%% -[Hilbert]-���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertModulatedGroup=HilbertPerRow(fringeListFractionalModulatedGroup,moveNumPart);
wrappedPhaseFractionalHilbertModulatedGroup=GetWrapPhaseWithHilbert(fringeListFractionalHilbertModulatedGroup,moveNumPart);

% %% -��ʾHilbert�任
% for k=1:moveNumPart
%     figure('name',sprintf('%d/%d Hilbert Transform of Fringe Signal (Amplitude Modulated)',k,moveNumPart),'NumberTitle','off');
%     % -��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���
%     plot(fringeListFractionalModulatedGroup{k});hold on;
%     % -Hilbert�任
%     plot(imag(hilbert(fringeListFractionalModulatedGroup{k})),'LineWidth',1.5);
%     title(sprintf('%d/%d Hilbert Transform of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
%     legend('Amplitude Modulated','Hilbert Transform','Location','SouthWest');
%     xlim([0,lengthOfSignal-1]);grid on;
%     set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
%     set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% end

%% -��һ������(fringe-A)/B����һ����Ŀ�����λ
fringeListAllNormalizationModulatedGroup=NormalizeFringe(fringeListAllModulatedGroup,moveNumAll,ABAllModulatedGroup);
wrappedPhaseAllNormalizationModulatedGroup=GetWrapPhase(fringeListAllNormalizationModulatedGroup,moveNumAll);

%% -��һ������(fringe-A)/B����һ����Ŀ�����λ
fringeListFractionalNormalizationModulatedGroup=NormalizeFringe(fringeListFractionalModulatedGroup,moveNumPart,ABFractionalModulatedGroup);
wrappedPhaseFractionalNormalizationModulatedGroup=GetWrapPhase(fringeListFractionalNormalizationModulatedGroup,moveNumPart);
for k=1:moveNumPart
    figure('name',sprintf('%d/%d Step of Normalization of Fringe Signal (Amplitude Modulated)',k,moveNumPart),'NumberTitle','off');
    % -��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���
    subplot(2,1,1);
    plot(fringeListFractionalModulatedGroup{k});hold on;
    title(sprintf('%d/%d Step of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
    xlim([0,lengthOfSignal-1]);ylim([0,256]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
    set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
    % -��һ������(fringe-A)/B
    subplot(2,1,2);
    plot(fringeListFractionalNormalizationModulatedGroup{k},'m','LineWidth',1.5);hold on;
    sf=-period*(k-1)/moveNumPart;
    plot(cos(((0:lengthOfSignal-1)-sf)/period*2*pi),plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);
    title(sprintf('%d/%d Step of Normalization of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
    legend('Normalizaion','Ideal Cosine','Location','SouthOutside','Orientation','Horizontal');
    xlim([0,lengthOfSignal-1]);ylim([-1.05,1.05]);grid on;
    set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
end

%% -{����}
fringeListFractionalContinuationModulatedGroup=cell(size(fringeListFractionalModulatedGroup));
for k=1:moveNumPart
    sf=-period*(k-1)/moveNumPart;
    fringeListAllUnit{k} = floor(255*0.5*(cos(((0:lengthOfSignal-1)-sf)/period*2*pi)+1)/2);
    fringeListFractionalContinuationModulatedGroup{k}=[ ...
        fringeListFractionalNormalizationModulatedGroup{k}, ...
        cos(2*pi*((lengthOfSignal)-sf+100*sin(2*pi*(lengthOfSignal)/(1.25*lengthOfSignal)))/period), ...
        (mod(k,2)*(mod(k,2)+1)-1)*fliplr(fringeListFractionalNormalizationModulatedGroup{k}(1:lengthOfSignal))
        ];
    
    figure('name',sprintf('%d/%d Step of Continuation of Fringe Signal (Amplitude Modulated)',k,moveNumPart),'NumberTitle','off');
    % -��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���
    plot(fringeListFractionalNormalizationModulatedGroup{k});hold on;
    % -Hilbert�任
    plot(imag(hilbert(fringeListFractionalNormalizationModulatedGroup{k})),plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);
    % -����
    plot(lengthOfSignal:lengthOfSignal*2, fringeListFractionalContinuationModulatedGroup{k}(lengthOfSignal:lengthOfSignal*2),'m','LineWidth',1.0);
    % -Hilbert�任(����)
    plot(imag(hilbert(fringeListFractionalContinuationModulatedGroup{k})),'LineWidth',1.5);
    title(sprintf('%d/%d Step of Continuation of Fringe Signal (Amplitude Modulated)',k,moveNumPart));
    legend('Amplitude Modulated','Hilbert Transform','Continuation','Hilbert Transform(Continuation)','Location','NorthEast');
    xlim([0,lengthOfSignal*2-1]);grid on;
    set(gca, 'XTick', xTickContinuation);set(gca, 'XTickLabel',xTickLabelContinuation);
%     set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

end

%% -[Hilbert]-�����һ����������������Ƶ�Hilbert�任��Hilbert����λ
fringeListFractionalHilbertNormalizationModulatedGroup=HilbertPerRow(fringeListFractionalNormalizationModulatedGroup,moveNumPart);
wrappedPhaseFractionalHilbertNormalizationModulatedGroup=GetWrapPhaseWithHilbert(fringeListFractionalHilbertNormalizationModulatedGroup,moveNumPart);

%% -��һ�����ƽ����λ=(��һ����Ŀ�����λ+��һ����Hilbert����λ)/2
wrappedPhaseFractionalMeanNormalization=(wrappedPhaseFractionalNormalizationModulatedGroup+wrappedPhaseFractionalHilbertNormalizationModulatedGroup)/2.0;

%% -��ʾ��һ�������λ
figure('name','Phase after Normalization (Modulated Group)','NumberTitle','off');
% 24�����ƹ�һ��������������λ
plot(wrappedPhaseAllNormalizationModulatedGroup, plotDottedLineType,'LineWidth',1.5);hold on;
% �������ƹ�һ����Ŀ�����λ
plot(wrappedPhaseFractionalNormalizationModulatedGroup, plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% �������ƹ�һ�����Hilbert����λ
plot(wrappedPhaseFractionalHilbertNormalizationModulatedGroup,       plotLineType,'Color','g','LineWidth',1.0);hold on;
% �������ƹ�һ�����ƽ����λ
plot(wrappedPhaseFractionalMeanNormalization,       plotLineType,'Color','m','LineWidth',1.0);
title('Phase Error after Normalization (Modulated Group)');
legend( ...
    sprintf('Space Phase after Normalization (Ideal %d Steps)',moveNumAll), ...
    sprintf('Space Phase after Normalization (%d Steps)',moveNumPart), ...
    sprintf('Hilbert Phase after Normalization (%d Steps Modulated Group)',moveNumPart), ...
    sprintf('Mean Phase after Normalization (%d Steps Modulated Group)',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% -��ʾ��һ�������λ���
figure('name','Phase Error after Normalization (Modulated Group)','NumberTitle','off');
% �������ƹ�һ����Ŀ�����λ���
phaseErrorSpace=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalNormalizationModulatedGroup-wrappedPhaseAllNormalizationModulatedGroup,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseErrorSpace, plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% �������ƹ�һ�����Hilbert����λ���
phaseErrorHilbert=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalHilbertNormalizationModulatedGroup-wrappedPhaseAllNormalizationModulatedGroup,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseErrorHilbert,     plotLineType,'Color','g','LineWidth',1.0);hold on;
% �������ƹ�һ�����ƽ����λ���
phaseErrorMean=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalMeanNormalization-wrappedPhaseAllNormalizationModulatedGroup,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseErrorMean,        plotLineType,'Color','m','LineWidth',1.0);
title(sprintf('Phase Error after Normalization (%d Steps Modulated Group)',moveNumPart));
legend( ...
    'Space Phase Error after Normalization', ...
    'Hilbert Phase Error after Normalization', ...
    'Mean  Phase Error after Normalization');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert��/ƽ����λ����ƽ��ֵ����ֵ�������
% �������ƹ�һ����Ŀ�����λ���
fprintf('------------Phase Error after Normalization (%d Steps Modulated Group)-------------\n',moveNumPart);
fprintf('          Mean of Space Phase Error: %+f\n',mean(phaseErrorSpace));
fprintf('  Max positive of Space Phase Error: %+f\n',max(phaseErrorSpace));
fprintf('  Max negative of Space Phase Error: %+f\n',min(phaseErrorSpace));
fprintf('          RMSE of Space Phase Error: %+f\n',sqrt(sum((phaseErrorSpace  -mean(phaseErrorSpace))  .^2))/lengthOfSignal);
% �������ƹ�һ�����Hilbert����λ���
fprintf('        Mean of Hilbert Phase Error: %+f\n',mean(phaseErrorHilbert));
fprintf('Max positive of Hilbert Phase Error: %+f\n',max(phaseErrorHilbert));
fprintf('Max negetive of Hilbert Phase Error: %+f\n',min(phaseErrorHilbert));
fprintf('        RMSE of Hilbert Phase Error: %+f\n',sqrt(sum((phaseErrorHilbert-mean(phaseErrorHilbert)).^2))/lengthOfSignal);
% �������ƹ�һ�����ƽ����λ���
fprintf('           Mean of Mean Phase Error: %+f\n',mean(phaseErrorMean));
fprintf('   Max positive of Mean Phase Error: %+f\n',max(phaseErrorMean));
fprintf('   Max negetive of Mean Phase Error: %+f\n',min(phaseErrorMean));
fprintf('           RMSE of Mean Phase Error: %+f\n',sqrt(sum((phaseErrorMean   -mean(phaseErrorMean))   .^2))/lengthOfSignal);

end

return

%% {Hilbert}-{����}-(��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���)*

%% -������������(��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���)�Ŀ�����λ
wrappedPhaseFractionalModulatedGroup=GetWrapPhase(fringeListFractionalModulatedGroup,moveNumPart);
% 
% %% -���������������Ƶ�Hilbert�任��Hilbert����λ
% fringeListFractionalHilbertModulatedGroup=HilbertPerRow(fringeListFractionalModulatedGroup,moveNumPart);
% wrappedPhaseFractionalHilbertModulatedGroup=GetWrapPhaseWithHilbert(fringeListFractionalHilbertModulatedGroup,moveNumPart);

%% {��ʾͼ��}*****************************************************

%% -��ʾ�۵���λ
figure('name','Wrapped Phase (Amplitude and Frequency Modulated Group)','NumberTitle','off');
% -���������λ
plot(wrappedPhaseAllModulatedGroup,           plotLineType,'LineWidth',1.0);hold on;
% ��������(��λ����������ź�)�Ŀ�����λ
plot(wrappedPhaseFractionalUnit, plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% ��������(��Ծʽ��ǶԳ��������β��з��ȵ���)�Ŀ�����λ
plot(wrappedPhaseFractionalAmplitudeModulated,plotLineType,'Color','g','LineWidth',1.0);hold on;
% ��������(��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���)�Ŀ�����λ
plot(wrappedPhaseFractionalModulatedGroup,plotLineType,'Color','m','LineWidth',1.0);
title('Phase Error (Amplitude and Frequency Modulated Group)');
legend('Ideal Space Phase', ...
    sprintf('Space Phase (%d Steps Unit)',moveNumPart), ...
    sprintf('Space Phase (%d Steps Amplitude Modulated)',moveNumPart), ...
    sprintf('Space Phase (%d Steps Modulated Group)',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

%% -��ʾ��λ���
figure('name','Phase Error (Amplitude and Frequency Modulated Group)','NumberTitle','off');
% ��������(��λ����������ź�)�Ŀ�����λ���
phaseError1=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalUnit-wrappedPhaseAllModulatedGroup,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseError1, plotDottedLineType,'Color',[0,0,153]/255,'LineWidth',1.5);hold on;
% ��������(��Ծʽ��ǶԳ��������β��з��ȵ���)�Ŀ�����λ���
phaseError2=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalAmplitudeModulated-wrappedPhaseAllModulatedGroup,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseError2,plotLineType,'Color','g','LineWidth',1.0);hold on;
% ��������(��Ծʽ��ǶԳ��������β��з��ȵ��Ƽ��ǶԳ���������Ƶ�ʵ���)�Ŀ�����λ���
phaseError3=extractValidPhaseErrorWithBounds(wrappedPhaseFractionalModulatedGroup-wrappedPhaseAllModulatedGroup,upPhaseErrorBound,bottomPhaseErrorBound);
plot(phaseError3,plotLineType,'Color','m','LineWidth',1.0);
title('Space Phase Error (Amplitude and Frequency Modulated Group)');
legend( ...
    sprintf('Space Phase Error (%d Steps Unit)',moveNumPart), ...
    sprintf('Space Phase Error (%d Steps Amplitude Modulated)',moveNumPart), ...
    sprintf('Space Phase Error (%d Steps Amplitude Modulated)',moveNumPart));
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

return;

grayList=ReadImages(gray_pre,grayOrder+2,moveNumAll);% grayOrder����2�Զ��������źڰ�ͼƬ
fringeListAll=ReadImages(pre,moveNumAll,0);


% ----------------------------------------

Pixelwidth = 48;
Fractional = 24;
ImageStart = 1;
pre = 'E:\XUWENYU\3D Reconstruction\Phase Error Compensation\Code\fringeImages\6\Left__';

FringeList24 = ReadImages(pre,Fractional,ImageStart);

% FringeList24 = CutFringe(FringeList24,1272);
FringeList24  = SubFringeListData(FringeList24,200,200,1000,1000);

Width = size(FringeList24{1},2);

Phase24 = GetWrapPhase(FringeList24,Fractional);

AB = GetABNormal(FringeList24,Phase24);

Fractional = 4;

FringeList6 = SelectNStepFring(FringeList24,Fractional);

Phase6 = GetWrapPhase(FringeList6,Fractional);


% ��һ��
FringeListNormalize6 = NormalizeFringe(FringeList6,Fractional,AB);


HTFLNorm6 = HilbertPerRow(FringeListNormalize6,Fractional);
% �ý�ȡ�������ͼ����λ
Phase6HT = GetWrapPhaseWithHilbert(HTFLNorm6,Fractional);

% q��ƽ����λ
MeanPhase6 = (Phase6 + Phase6HT)/2;

% %--------------------------------------------------------------- �·�������
% ѡ��һ��׼ȷ�ĳ�ʼ��λ
P = Phase6(400,Width);
%  BackCount = zeros(Fractional,1);
[ContiFLNorm6, BackCount]= ContinFringeListBack(FringeListNormalize6,Fractional,Pixelwidth,P,Phase6);

%  FrontCount = zeros(Fractional,1);
P = Phase6(400,1);
[ContiFLNorm6, FrontCount]= ContinFringeListFront(ContiFLNorm6,Fractional,Pixelwidth,P,Phase6);

% �����غ������ͼ����HT
HTConFLNorm6 = HilbertPerRowWithLength(ContiFLNorm6,Fractional,Width,FrontCount,BackCount);

% ��HT�������ͼ��ȡ������ǰ�Ŀ��
HTConFLNormCut6 = CutFringeList(HTConFLNorm6,Width,FrontCount,BackCount);

% �ý�ȡ�������ͼ����λ
Phase6HT = GetWrapPhaseWithHilbert(HTConFLNormCut6,Fractional);

% q��ƽ����λ
ConMeanPhase6 = (Phase6 + Phase6HT)/2;


start = 100;
over = 101;
number = 1;
for i = start : over
    figure('Name',sprintf('Line: %d',i));
%     myplot(extractValidPhaseErrorWithBounds(MeanPhase6-Phase24,     upBoundOfPhaseError,bottomBoundOfPhaseError),i,number);
    plot(extractValidPhaseErrorWithBounds(MeanPhase6(i,:)-Phase24(i,:),     upBoundOfPhaseError,bottomBoundOfPhaseError),'--.');
    hold on;
%     myplot(extractValidPhaseErrorWithBounds(ConMeanPhase6-Phase24,  upBoundOfPhaseError,bottomBoundOfPhaseError),i,number);
    plot(extractValidPhaseErrorWithBounds(ConMeanPhase6(i,:)-Phase24(i,:),  upBoundOfPhaseError,bottomBoundOfPhaseError),'LineWidth',1.2);
    grid on;
    xlim([-1,1001]);
    title(sprintf('%d-Steps of Mean Phase Error on Hilbert Domain',Fractional));
    legend('Non-Integate Periods','Integate Periods after Continuation')
    number=number+1;
end

% Spherical Gradient Illumination

%---------------------------------------------------------------------------------------------------------
% x:��ȡ5��Ԫ��
% ��phase�д�startIndex ��ʼȡ5��Ԫ�����arr
% forward ��ʾ����ǰ�����������������Ĭ����ǰ
function [arr] = FillArrWith5Ele(phase,startIndex,arr,forward)
if nargin == 3
    forward = 1;
end
if forward == 1
    arr(1,:)=phase(1,startIndex-4:startIndex);
else
    arr(1,:)=phase(1,startIndex:startIndex+4);
end
end

% x:���۵���λ����λ���ƶ�
% ��phase��ȥindex����Ԫ�ط���arr�ĵ�һ��λ�ã�����Ԫ�����κ���һ��λ��
% % forward ��ʾ����ǰ�����������������Ĭ����ǰ
function [arr] = MoveOneStep(phase,startIndex,arr,forward)
if nargin == 3
    forward = 1;
end
pha = phase(1,startIndex);
% ���������ǰԪ�ش���3��˵����ʱ������λͼ�Ĳ���Ͳ��Ƚ��紦����ʱӦ��Խ��
if pha > 3.0
    FillArrWith5Ele(phase,startIndex,arr,forward);
    return;
end
arr = [pha arr(1,1:4)];
end

% x:��������߽�����ڷ�ֵλ��
% ����λͼ������һ����������λ�����ֵ���ڵ�λ��
% Pos ��һ�����飬ÿ��Ԫ�ؼ�¼һ���и�������������λ��λ��
function [Pos] = FindMaxPhasePos(Phase,startIndex,Forward)
if nargin == 2
    Forward = 1;
end;
height = size(Phase,1);
Pos = zeros(height,1);
Width = size(Phase,2);
if Forward == 1%��ǰ����
    for h = 1 : height
        for i = startIndex : -1 : 1
            pha0 = Phase(h,i);
            pha1 = Phase(h,i-1);
            if (pha1 - pha0) > 0 && abs(pha1 - pha0) > pi
                Pos(h,1) = i - 1;
                %                    return;
                break;
            end
        end
    end
else%������
    for h = 1 : height
        for i = startIndex : Width
            pha0 = Phase(h,i);
            pha1 = Phase(h,i+1);
            if (pha1 - pha0) < 0 && abs(pha1 - pha0) > pi
                Pos(h,1) = i;
                %                        return;
                break;
            end
        end
    end
end
end

% x:--
% ����λͼ����һ���������������λ�ô�����λP��Ӧ����λ���ڵ�λ������
% startIndex�ǿ�ʼ���ҵ�λ��
% Forward ����ǰ����������
function [Pos] = FindCorresPhasePos(Phase,startIndex,Forward)
if nargin == 2
    Forward = 1;
end;
height = size(Phase,1);
Pos = zeros(height,1);
Width = size(Phase,2);
if Forward == 1%��ǰ����
    for h = 1 : height
        if startIndex(h,1)==Width-2
            Pos(h,1) = Width-2;
            continue;
        end;
        for i = startIndex(h,1) : -1 : 1
            pha = Phase(h,i);
            if (pha - Phase(h,Width)) < 0
                Pos(h,1) = i + 1;
                %                             return;
                break;
            end
        end
    end
else%������
    for h = 1 : height
        if startIndex(h,1)==2%�����ʼ��������������2��˵����һ����λ���ڷ�ֵ״̬
            Pos(h,1) = 2;
            continue;
        end
        for i = startIndex(h,1) : Width
            pha = Phase(h,i);
            if (pha - Phase(h,1)) > 0
                Pos(h,1) = i - 1;
                %                             return;
                break;
            end
        end
    end
end
end


% ---------------------------------------------------------------------------------------------
% ���ߺ���
% ---------------------------------------------------------------------------------------------
% x:���۵���λ���ҳ���λ��Ӧ������λ��
function [Pos] = FindPosByPhase(Phase,startIndex,threshold,forward)
%
% ��λ�� startIndex ������λֵP �� Phase �е���һ������������Pֵ��Ȼ������ֵ����Ӧ����������
if nargin == 3
    forward = 1;
end;
Pos = 0;
Pha = Phase(1,startIndex);
Num = size(Phase,1);
arr = zeros(1,5);
arr = FillArrWith5Ele(Phase,startIndex,arr,forward);
if forward == 1
    startIndex = startIndex - 5;
else
    startIndex = startIndex + 5;
end;

for i  = 1 : Num
    if abs(mean(arr)-Pha) < threshold
        if forward == 1
            Pos = startIndex + 3;
        else
            Pos = startIndex - 3;
        end;
        return ;
    end;
    display(abs(mean(arr)-Pha));
    arr = MoveOneStep(Phase,startIndex,arr);
    
    if forward == 1
        startIndex = startIndex - 1;
    else
        startIndex = startIndex + 1;
    end;
end;

end

% x:�������أ������۵���λ��©ȱ�������������źŽ�������
function [res] = BlitData(image,src,length,dst,front)
% image ������ͼ��
% src �ǿ�ʼ��
% length ����Ҫ��src ��ʼ����src�У������Ƶ�����
% dst �ǰ�length���е����ݿ�������Ŀ������
% �����������Ǵ�ͼ���src�п�ʼ��ȡ length ������ӵ���dstΪ��ʼ�����ĺ���
% front �� 1 ��ʾ�ڰ����ݸ��Ƶ�ͼ��ͷ����0��ʾ�����ݸ��Ƶ�ͼ��β��
if nargin == 4
    front = 0;
end;
res = image;
height = size(image,1);
width = size(image,2);

if front == 0%�ѿ���������ӵ�ͼ��β��
    for h = 1 : height
        if src(h,1) > width || length(h,1) <= 0
            %                 display('����ͼ����');
            continue;
        end;
        res(h,dst:dst+length(h,1)-1) = image(h, src(h,1):src(h,1) + length(h,1) - 1);
    end;
else%�ѿ���������ӵ�ͼ��ͷ��
    for h = 1 : height
        if src(h,1) > width || length(h,1) <= 0
            %                         display('����ͼ����');
            continue;
        end;
        res(h,1:length(h,1)+width) = [image(h, src(h,1):src(h,1) + length(h,1) - 1) image(h,:)];
    end;
end;
end

% 
function [images] = CutFringeList(FringeList,Width,FrontCount,BackCount)
%     �� FringList ��ȡ��ָ���Ŀ�� width
Num = size(FringeList,1);
RowNum = size(FringeList{1,1},1);
images = cell(Num,1);
for i = 1 : Num
    for r = 1 : RowNum
        front = FrontCount(r,1);
        if front<0
            front = 0;
        end;
        images{i}(r,:) = FringeList{i}(r,front+1:front + Width);
    end;
end;
end

% function [Pos] = MaxIntencityPos(image,startIndex)
%     Num = size(image,2);
%     Inten = image(1,startIndex);
%     for i = startIndex : Num
%         if image(1,startIndex)
%     end;
% end

function [ContiFLNorm, BackCount] = ContinFringeListBack(FringeList,Fractional,Pixelwidth,P,Phase)
% ������ͼ��Ԫ������������أ��������
% Pixelwidth ���������ڵ����ؿ��
% P �����������е�һ������ͼ�����һ�е���λֵ
%     BackCount = zeros(Fractional,1);
ContiFLNorm = FringeList;
Width = size(FringeList{1},2);
%     src  = Width - Pixelwidth;
%     threshold = 0.15;
%     src  = FindPosByPhase(Phase,Width,threshold);
pos = FindMaxPhasePos(Phase,Width);%��ǰ���������λ����λ��
src = FindCorresPhasePos(Phase,pos);
src = src + 1;
length = pos - src + 1;
BackCount = length;
%     P  = P + pi;
for index = 1 : Fractional
    %             Ph =P + (index-1) * 2*pi/Fractional;
    %             Ph = mod(Ph,2*pi);
    %             length = floor(Pixelwidth -  Ph * Pixelwidth / (2 * pi));
    %             if length<0
    %                 length = 0;
    %             end;
    ContiFLNorm{index} = BlitData(FringeList{index},src,length,Width+1,0);
    %             BackCount(index,1)=length;
end;
end

function [ContiFLNorm,FrontCount] = ContinFringeListFront(FringeList,Fractional,Pixelwidth,P,Phase)
% ������ͼ��Ԫ������������أ���ǰ������
% Pixelwidth ���������ڵ����ؿ��
% P �����������е�һ������ͼ�����һ�е���λֵ
%     FrontCount = zeros(Fractional,1);
ContiFLNorm = FringeList;
%     P = P + pi;

src =1 + FindMaxPhasePos(Phase,1,0);%��һ��������С��λ����λ��
pos = FindCorresPhasePos(Phase,src,0);
pos = pos -1;
length = pos - src + 1;
FrontCount = length;
for index = 1 : Fractional
    %             Ph =P + (index-1) * 2*pi/Fractional;
    %             Ph = mod(Ph,2*pi);
    %             length = floor(Ph * Pixelwidth / (2 * pi));
    %             if length<0
    %                 length = 0;
    %             end;
    %             src  = Pixelwidth - length;
    ContiFLNorm{index} = BlitData(FringeList{index},src,length,1,1);
    %             FrontCount(index,1) = length;
end;
end


function [FL6Cut] = CutFringe(FringeList,Width)
Num = size(FringeList,1);
FL6Cut = cell(Num,1);
for i = 1 : Num
    FL6Cut{i} = FringeList{i}(:,1:Width);
end;
end


function [FringeListHT] = HilbertPerRowWithLength(FringeList,Fractional,Width,FrontLen,BackLen)

FringeListHT = cell(Fractional,1);
RowNum = size(FringeList{1,1},1);
for k = 1 : Fractional
    for r=1:RowNum
        front = FrontLen(r,1);
        if front < 0
            front =0;
        end;
        rr = FringeList{k}(r,1:Width + BackLen(r,1) + front);
        temp = hilbert(rr);
        FringeListHT{k}(r,1:Width + BackLen(r,1) + front) = -imag(temp);
    end
end
end