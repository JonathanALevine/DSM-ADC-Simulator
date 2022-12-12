function [clock_vals] = myClock(clock_times, clock_frequency)
    clock_vals = 0.5*(square(2*pi*clock_frequency*clock_times-pi)+1);
end