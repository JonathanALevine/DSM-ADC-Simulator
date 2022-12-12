function [sequence] = myInputSequence(clock_times)
    fundamental = 2.5*1e6;
%     fundamental = 0;

    power_fundamental = 1;

    sequence = power_fundamental*sin(2*pi*fundamental*clock_times) + 1;
%     sequence = zeros(1, length(clock_times));
%     sequence(:) = power_fundamental;
    return;
end