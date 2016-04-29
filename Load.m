classdef Load < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bk8600;
        rl;
        volt;
        curr;
        pow;
    end
    
    methods
        function obj = Load
            %% BK8600
            BK8600 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 8, 'Tag', '');
            if isempty(BK8600)
                BK8600 = gpib('ni', 0, 8);
            else
                fclose(BK8600);
                BK8600 = BK8600(1);
            end
            fopen(BK8600);
            obj.bk8600 = BK8600;
            
            fwrite(obj.bk8600,'FUNC RES');
        end
        
        function setLoad(obj,r)
           obj.rl = r ;
           fwrite(obj.bk8600,['RES ',num2str(r)]);
        end
        
        function on(obj)
            fwrite(obj.bk8600,'INP ON');
        end
        
        function off(obj)
            fwrite(obj.bk8600,'INP OFF');
        end
        
        function [p,v,c] = getPower(obj)
            obj.volt = str2double(query(obj.bk8600,'MEAS:VOLT?'));
            obj.curr = str2double(query(obj.bk8600,'MEAS:CURR?'));
            obj.pow = obj.volt * obj.curr;
            p = obj.pow;
            v = obj.volt;
            c = obj.curr;
        end
    end
end

