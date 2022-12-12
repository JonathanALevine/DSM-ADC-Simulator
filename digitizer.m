function [analog_val] = digitizer(digital_val)
    if digital_val == "00"
        analog_val = -3;
    elseif digital_val == "01"
        analog_val = -1;
    elseif digital_val == "10"
        analog_val = 1;
    else
        analog_val = 3;
    end
    return;
end