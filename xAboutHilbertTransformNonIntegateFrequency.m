% xAboutHilbertTransformNonIntegateFrequency.m
% �����20171106����һ
% �������������ڲ�����Hilbert�任�Լ�Hilbert����λ��Ӱ��
% ver��---
close all;clear;

%% ���û�������***************************************************
% ͼ�����Ʋ���
width=1024; height=800; period=64;

%% -Ƶ�ʵ���
% �������ڱ��
integatePeriodsFlag=1;
% ���������ڱ��
nonIntegatePeriodsFlag=1;

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
yTick=zeros(1,16+1);
yTickLabel=cell(1,16+1);
yTickLabel{9}='0';
for xt=1:8
    yTick(9+xt)=floor(xt*32);  yTickLabel{9+xt}=num2str(yTick(9+xt)); 
    yTick(9-xt)=floor(-xt*32); yTickLabel{9-xt}=num2str(yTick(9-xt));
end
% ��λ�����ʾ��Ч����
upPhaseErrorBound=2; bottomPhaseErrorBound=-2;

% plot��������
plotLineType=''; % ''ʵ�ߣ�':'������

%% {��������Ƶ��}******************************************************
% �������ڱ��
if integatePeriodsFlag==1
grayOrderStepFrequency =ceil(log(double(width/period))/log(2.0))+1;
preStepFrequency='E:\XUWENYU\3D Reconstruction\Phase Error Compensation\Code\fringeImages\39SameFrequency(T64)\I_';
gray_preStepFrequency='E:\XUWENYU\3D Reconstruction\Phase Error Compensation\Code\grayImages\28\I_';

% ��ȡȫ������ͼ��
moveNumAll=24;
grayListStepFrequency=ReadImages(gray_preStepFrequency,grayOrderStepFrequency+2,moveNumAll);% grayOrder����2�Զ��������źڰ�ͼƬ
fringeListAllStepFrequency=ReadImages(preStepFrequency,moveNumAll,0);
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    fringeListAllStepFrequency{k}=0.5*fringeListAllStepFrequency{k}(400,startOfSignal:endOfSignal);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListMoveNumStepFrequency=SelectNStepFring(fringeListAllStepFrequency,moveNumPart);

%% -�������������λ
wrappedPhaseAllStepFrequency=GetWrapPhase(fringeListAllStepFrequency,moveNumAll);
AB=GetABNormal(fringeListAllStepFrequency,wrappedPhaseAllStepFrequency);

%% -���������������ƵĿ�����λ
wrappedPhaseMoveNumStepFrequency=GetWrapPhase(fringeListMoveNumStepFrequency,moveNumPart);

%% -���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListMoveNumHilbertStepFrequency=HilbertPerRow(fringeListMoveNumStepFrequency,moveNumPart);
wrappedPhaseMoveNumHilbertStepFrequency=GetWrapPhaseWithHilbert(fringeListMoveNumHilbertStepFrequency,moveNumPart);

%% -��ʾ���������������������źż���Hilbert�任����λ���ͼ��
% ��ʾ�źż���Hilbert�任
% ��1/4����������
figure('name','1.Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumStepFrequency{1},                       plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumStepFrequency{1})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('Integate Periods of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��2/4����������
figure('name','2.Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumStepFrequency{2},                       plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumStepFrequency{2})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('2/4 Step of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��3/4����������
figure('name','3.Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumStepFrequency{3},                       plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumStepFrequency{3})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('3/4 Step of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��4/4����������
figure('name','4.Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumStepFrequency{4},                       plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumStepFrequency{4})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('4/4 Step of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Integate Periods)','NumberTitle','off');
% ������λ���
plot(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumStepFrequency       -wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound),...
    plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
% Hilbert����λ���
plot(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound),...
    plotLineType,'Color','g','MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',4);hold on;
title('Phase Error (Frequency Changed by Step Function)');
legend('Space Phase Error','HT Phase Error','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert����λ����ƽ��ֵ�����ֵ
fprintf('------------integatePeriods-------------\n');
fprintf('        Mean of Space Phase Error: %f\n',mean(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound)));
fprintf('Max positive of Space Phase Error: %f\n',max((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));
fprintf('Max negative of Space Phase Error: %f\n',min((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));
fprintf('           Mean of HT Phase Error: %f\n',mean(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound)));
fprintf('   Max positive of HT Phase Error: %f\n',max((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));
fprintf('   Max negetive of HT Phase Error: %f\n',min((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertStepFrequency-wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));

end


%% {����������}******************************************************
% ���������ڱ��
if nonIntegatePeriodsFlag==1
grayOrderSymmetricalArcFrequency =ceil(log(double(width/period))/log(2.0))+1;
preSymmetricalArcFrequency='E:\XUWENYU\3D Reconstruction\Phase Error Compensation\Code\fringeImages\39SameFrequency(T64)\I_';
gray_preSymmetricalArcFrequency='E:\XUWENYU\3D Reconstruction\Phase Error Compensation\Code\grayImages\28\I_';

% ��ȡȫ������ͼ��
moveNumAll=24;
grayListSymmetricalArcFrequency=ReadImages(gray_preSymmetricalArcFrequency,grayOrderSymmetricalArcFrequency+2,moveNumAll);% grayOrder����2�Զ��������źڰ�ͼƬ
fringeListAllSymmetricalArcFrequency=ReadImages(preSymmetricalArcFrequency,moveNumAll,0);
% ��ȡָ�����е��źţ���ֱ������Ϊ�����
for k=1:moveNumAll
    fringeListAllSymmetricalArcFrequency{k}=0.5*fringeListAllSymmetricalArcFrequency{k}(400,startOfSignal:endOfSignal-period/2);
end

% ��ȡ��������������ͼ��
moveNumPart=4;
fringeListMoveNumSymmetricalArcFrequency=SelectNStepFring(fringeListAllSymmetricalArcFrequency,moveNumPart);

%% -�������������λ
wrappedPhaseAllSymmetricalArcFrequency=GetWrapPhase(fringeListAllSymmetricalArcFrequency,moveNumAll);
AB=GetABNormal(fringeListAllSymmetricalArcFrequency,wrappedPhaseAllSymmetricalArcFrequency);

%% -���������������ƵĿ�����λ
wrappedPhaseMoveNumSymmetricalArcFrequency=GetWrapPhase(fringeListMoveNumSymmetricalArcFrequency,moveNumPart);

%% -���������������Ƶ�Hilbert�任��Hilbert����λ
fringeListMoveNumHilbertSymmetricalArcFrequency=HilbertPerRow(fringeListMoveNumSymmetricalArcFrequency,moveNumPart);
wrappedPhaseMoveNumHilbertSymmetricalArcFrequency=GetWrapPhaseWithHilbert(fringeListMoveNumHilbertSymmetricalArcFrequency,moveNumPart);

%% -��ʾ�����������������������źż���Hilbert�任����λ���ͼ��

% ��ʾ�źż���Hilbert�任
% ��1/4����������
figure('name','1.Non-Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumSymmetricalArcFrequency{1},             plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumSymmetricalArcFrequency{1})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('1/4 Step of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��2/4����������
figure('name','2.Non-Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumSymmetricalArcFrequency{2},             plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumSymmetricalArcFrequency{2})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('2/4 Step of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��3/4����������
figure('name','3.Non-Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumSymmetricalArcFrequency{3},             plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumSymmetricalArcFrequency{3})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('3/4 Step of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);
% ��4/4����������
figure('name','4.Non-Integate Periods of Original fringe','NumberTitle','off');
plot(fringeListMoveNumSymmetricalArcFrequency{4},             plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
plot(imag(hilbert(fringeListMoveNumSymmetricalArcFrequency{4})),...
    plotLineType,'Color',[0,0.8078,0.8196],'MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',6);hold on;
title('4/4 Step of Original fringe and its Hilbert Transform');
legend('Original fringe','HT','Location','NorthEast');
xlim([0,lengthOfSignal-1]);ylim([-96 192]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);
set(gca, 'YTick', yTick);set(gca, 'YTickLabel',yTickLabel);

% ��ʾ������λ��Hilbert����λ���
figure('name','Phase Error (Non-Integate Periods)','NumberTitle','off');
% ������λ���
plot(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumSymmetricalArcFrequency       -wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound),...
    plotLineType,'LineWidth',0.5,'MarkerSize',4);hold on;
% Hilbert����λ���
plot(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertStepFrequency          -wrappedPhaseAllStepFrequency,upPhaseErrorBound,bottomPhaseErrorBound),...
    plotLineType,'Color','g','MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',4);hold on;
% non integate Hilbert����λ���
plot(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound),...
    plotLineType,'Color','m','MarkerEdgeColor',[0.87,0.49,0],'LineWidth',0.5,'MarkerSize',4);hold on;

title('Phase Error (Non-Integate Periods)');
legend('Space Phase Error','HT Phase Error(Integate Periods)','HT Phase Error(Non-Integate Periods)','Location','SouthWest');
xlim([0,lengthOfSignal-1]);grid on;
set(gca, 'XTick', xTick);set(gca, 'XTickLabel',xTickLabel);

% ������������ʾ����/Hilbert����λ����ƽ��ֵ�����ֵ
fprintf('------------nonIntegatePeriods-------------\n');
fprintf('        Mean of Space Phase Error: %f\n',mean(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound)));
fprintf('Max positive of Space Phase Error: %f\n',max((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));
fprintf('Max negative of Space Phase Error: %f\n',min((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));
fprintf('           Mean of HT Phase Error: %f\n',mean(extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound)));
fprintf('   Max positive of HT Phase Error: %f\n',max((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));
fprintf('   Max negetive of HT Phase Error: %f\n',min((extractValidPhaseErrorWithBounds(wrappedPhaseMoveNumHilbertSymmetricalArcFrequency-wrappedPhaseAllSymmetricalArcFrequency,upPhaseErrorBound,bottomPhaseErrorBound))));

end

