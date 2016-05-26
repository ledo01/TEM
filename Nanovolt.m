classdef Nanovolt < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        k2182a
        volt
    end
    
    methods
        function obj = Nanovolt()
            K2182A = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 25, 'Tag', '');
            if isempty(K2182A)
                K2182A = gpib('ni', 0, 25);
            else
                fclose(K2182A);
                K2182A = K2182A(1);
            end
            fopen(K2182A);
            obj.k2182a = K2182A;
        end
        
        function v = getVolt(obj)
            v = query(obj.k2182a,'MEAS:VOLT?');
            obj.volt = v;
        end
            
    end
    
end

