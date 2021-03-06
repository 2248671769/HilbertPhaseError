% xCropImage.m
% 徐文宇，20171108
% 裁剪论文图片
% ver:---
close all;clear;

folder=   'E:\XUWENYU\Mathmatics\论文参考图片\';
folderDst='E:\XUWENYU\Mathmatics\论文参考图片\Dst\';

%% 基础大众
fileListsA={...
    '102.png',...
    '103.png',...
    '201.png',...
    '202.png',...
    '205.png',...
    '206.png',...
    '207.png',...
    '208.png',...
    '211.png',...
    '212.png',...
    '213.png',...
    '214.png',...
    '217.png',...
    '218-0.png',...
    '218-1.png',...
    '221.png',...
    '222-0.png',...
    '222-1.png',...
    '223.png',...
    '225.png',...
    '226.png',...
    '227.png',...
    '230.png',...
    '231-0.png',...
    '231-1.png',...
    '234.png',...
    '235-0.png',...
    '235-1.png',...
    };

% 0:490,60:780,:
for k=1:length(fileListsA)
    [image,map,transparency]=imread([folder fileListsA{k}],'BackgroundColor','none');
    imageDst=image(90:490,60:780,:);
    imwrite(imageDst,[folderDst fileListsA{k}]);
    imshow(imageDst);
end

%% 下边多一点
fileListsB={...
    '105.png',...
    '107.png'...
    };

% 90:503,60:780,:
for k=1:length(fileListsB)
    [image,map,transparency]=imread([folder fileListsB{k}],'BackgroundColor','none');
    imageDst=image(90:503,60:780,:);
    imwrite(imageDst,[folderDst fileListsB{k}]);
    imshow(imageDst);
end

%% 下边多一点，两边再宽点
fileListsB2={...
    '104.png',...
    '106.png'...
    };

% 90:503,60:780,:
for k=1:length(fileListsB2)
    [image,map,transparency]=imread([folder fileListsB2{k}],'BackgroundColor','none');
    imageDst=image(90:503,57:793,:);
    imwrite(imageDst,[folderDst fileListsB2{k}]);
    imshow(imageDst);
end

%% 下边少一点
fileListsC={...
    '108.png',...
    '109.png'...
    };

% 0:473,60:780,:
for k=1:length(fileListsC)
    [image,map,transparency]=imread([folder fileListsC{k}],'BackgroundColor','none');
    imageDst=image(90:473,60:780,:);
    imwrite(imageDst,[folderDst fileListsC{k}]);
    imshow(imageDst);
end

%% 下边要多好多
fileListsD={...
    '203.png',...
    '209.png',...
    '215.png',...
    '219.png',...
    '224.png',...
    '228.png',...
    '232.png'...
    };

% 123:913,60:780,:
for k=1:length(fileListsD)
    [image,map,transparency]=imread([folder fileListsD{k}],'BackgroundColor','none');
    imageDst=image(123:913,60:780,:);
    imwrite(imageDst,[folderDst fileListsD{k}]);
    imshow(imageDst);
end

%% 下边要多好多,头少尾多
fileListsE={...
    '204.png',...
    '210.png',...
    '216.png',...
    '220.png',...
    '229.png',...
    '233.png'...  
    };

% 123:913,60:780,:
for k=1:length(fileListsE)
    [image,map,transparency]=imread([folder fileListsE{k}],'BackgroundColor','none');
    imageDst=image(127:933,60:780,:);
    imwrite(imageDst,[folderDst fileListsE{k}]);
    imshow(imageDst);
end

%% 所有

fileLists={...
    '102.png',...
    '103.png',...
    '104.png',...
    '105.png',...
    '106.png',...
    '107.png',...
    '108.png',...
    '109.png',...
    '201.png',...
    '202.png',...
    '203.png',...
    '204.png',...
    '205.png',...
    '206.png',...
    '207.png',...
    '208.png',...
    '209.png',...
    '210.png',...
    '211.png',...
    '212.png',...
    '213.png',...
    '214.png',...
    '215.png',...
    '216.png',...
    '217.png',...
    '218-0.png',...
    '218-1.png',...
    '219.png',...
    '220.png',...
    '221.png',...
    '222-0.png',...
    '222-1.png',...
    '223.png',...
    '224.png',...
    '225.png',...
    '226.png',...
    '227.png',...
    '228.png',...
    '229.png',...
    '230.png',...
    '231-0.png',...
    '231-1.png',...
    '232.png',...
    '233.png',...
    '234-0.png',...
    '234.png',...
    '235-1.png',...
    };

close all;

