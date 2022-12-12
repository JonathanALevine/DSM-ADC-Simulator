function [digital_out] = comparator(integrator_val)
%     NEED TO MAKE THIS A TWO BIT ADC
    if integrator_val < 0
        digital_out = "0";
    else
        digital_out = "1";
    end
    return;
end