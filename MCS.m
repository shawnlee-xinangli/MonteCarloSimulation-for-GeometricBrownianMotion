%������ӵ��һ����ʼ�۸�Ϊ$20�Ĺ�Ʊ����Ķ�Ϊ$20���ʲ������껯������Ϊ20%����Ʊ�۸�Ĳ�����Ϊ40%��
% ��ͨ��ģ��ù�Ʊ��һ�꣨252�������գ��м۸�ı仯���õ���һ���ļ۸�����֤����ϼ��β����˶���
StartPrice    = 20;      %�趨��ʼ�۸�
ExpReturn     = 0.2;     %�껯������
ExpCovariance = 0.4^2;   %�۸񲨶��ķ���
NumObs        = 252;     %�۲����Ϊ252�Σ���Ϊһ����252��������
NumSim        = 10000;   %ʵ�����Ϊ10000�Σ�Ҳ����ȡ��10000��
RetIntervals  = 1/252;   %����������Ϊ��λ��ÿ�������ջ��һ���������ÿ1/252����һ������

%ͨ��Matlab���Դ���portsimģ��õ������ʹ���ʱ�����еľ���
RetSeries = squeeze(portsim(ExpReturn, ExpCovariance, NumObs,RetIntervals, NumSim, 'Expected'));
%�����õ��㷨�Ҳ²����ȵõ���һ��252*1����������Ȼ������ظ�ȡ��10000�εõ�һ��252*10000�ľ���
%squeeze�����ǽ�252*1*10000����ά������252*10000�Ķ�ά������Ϊ��������ֻ��һ���ʲ�������ֱ��ת�ɶ�ά��

StockPrices = ret2tick(RetSeries, StartPrice*ones(1,NumSim));
%��Matlab��ret2stick�����������ʾ����Ϊ����ʲ��۸�ľ��󣬲���ע�⣺�ú���Ĭ��ʹ��simpleҲ���ǵ���ģ��,Ҳ����S(t+1)= S(t)*(1+R(t))��


SampMean = mean(StockPrices(end,:))  %�õ�10000������������ֵ����ֵ������253��Ĺ�Ʊ�ļ۸�Ҳ���Ǿ������һ������Ԫ�صľ�ֵ
SampVar = var(StockPrices(end,:))    %�õ�10000�������ķ���

ExpValue = StartPrice*exp(ExpReturn)                                         %�����ϵ�����ֵ
ExpVar = StartPrice*StartPrice*exp(2*ExpReturn)*(exp((ExpCovariance)) - 1)   %�����ϵķ�������鼮��ֱ���հ�Ĺ�ʽ����
%��������ֵ��ʵ��ֵ֮��Ĳ����С������ʵ�������Ʊ�ļ۸�ı仯ȷʵ���Ӽ��β����˶�

%һ��Ϊ��ͼ��ָ����������͡�
[count, BinCenter] = hist(StockPrices(end,:), 30);
figure
bar(BinCenter, count/sum(count), 1, 'r')
xlabel('Terminal Stock Price')
ylabel('Probability')
title('Lognormal Terminal Stock Prices')