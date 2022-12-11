function [sequence] = myInputSequence(clock_times)
    fundamental = 2.5*1e6;

    power_fundamental = 1;

    sequence = power_fundamental*sin(2*pi*fundamental*clock_times) + 1;
end