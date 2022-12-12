function [analog_val] = digitizer(digital_val)
    % NEED TO MAKE THIS A TWO BIT QUANTIZER
    % 00 -> -3, 01 -> -1, 10 -> 1, 11 -> 3   
    if digital_val == "1"
        analog_val = 2.5;
    else
        analog_val = -2.5;
    end
    return;
end