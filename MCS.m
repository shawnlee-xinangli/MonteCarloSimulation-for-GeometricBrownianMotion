%假设你拥有一个初始价格为$20的股票（标的额为$20的资产），年化收益率为20%，股票价格的波动率为40%。
% 现通过模拟该股票在一年（252个交易日）中价格的变化，得到它一年后的价格，来验证其符合几何布朗运动。
StartPrice    = 20;      %设定初始价格
ExpReturn     = 0.2;     %年化收益率
ExpCovariance = 0.4^2;   %价格波动的方差
NumObs        = 252;     %观察次数为252次，因为一年有252个交易日
NumSim        = 10000;   %实验次数为10000次，也就是取样10000次
RetIntervals  = 1/252;   %收益间隔以年为单位，每个交易日获得一次收益就是每1/252年获得一次收益

%通过Matlab中自带的portsim模块得到收益率关于时间序列的矩阵
RetSeries = squeeze(portsim(ExpReturn, ExpCovariance, NumObs,RetIntervals, NumSim, 'Expected'));
%他内置的算法我猜测是先得到了一个252*1的列向量，然后随机重复取样10000次得到一个252*10000的矩阵
%squeeze函数是将252*1*10000的三维矩阵变成252*10000的二维矩阵，因为我们这里只有一种资产，所以直接转成二维。

StockPrices = ret2tick(RetSeries, StartPrice*ones(1,NumSim));
%用Matlab中ret2stick函数将收益率矩阵变为标的资产价格的矩阵，并且注意：该函数默认使用simple也就是单利模型,也就是S(t+1)= S(t)*(1+R(t))。


SampMean = mean(StockPrices(end,:))  %得到10000组样本的期望值（均值），第253天的股票的价格，也就是矩阵最后一行所有元素的均值
SampVar = var(StockPrices(end,:))    %得到10000组样本的方差

ExpValue = StartPrice*exp(ExpReturn)                                         %理论上的期望值
ExpVar = StartPrice*StartPrice*exp(2*ExpReturn)*(exp((ExpCovariance)) - 1)   %理论上的方差（查阅书籍，直接照搬的公式。）
%发现理论值与实际值之间的差异很小，所以实验表明股票的价格的变化确实服从几何布朗运动

%一下为作图的指令，不多做解释。
[count, BinCenter] = hist(StockPrices(end,:), 30);
figure
bar(BinCenter, count/sum(count), 1, 'r')
xlabel('Terminal Stock Price')
ylabel('Probability')
title('Lognormal Terminal Stock Prices')