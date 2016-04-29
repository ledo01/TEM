classdef Source
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        bk9201;
        volt;
        curr;
    end
    
    methods
        function obj = Source
            %% BK9201
            BK9201 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 9, 'Tag', '');
            if isempty(BK9201)
                BK9201 = gpib('ni', 0, 9);
            else
                fclose(BK9201);
                BK9201 = BK9201(1);
            end
            fopen(BK9201);
            obj.bk9201 = BK9201;
        end
        
        function setVoltage(obj,v)
            obj.volt = v;
            fwrite(obj.bk9201,['VOLT ',num2str(v)]);
        end
        
        function setCurrent(obj,c)
            obj.curr = c;
            fwrite(obj.bk9201,['CURR ',num2str(c)]);
        end
        
        function setSource(obj,v,c)
           obj.setVoltage(v);
           obj.setCurrent(c);
        end
        
        function on(obj)
           fwrite(obj.bk9201,'outp on'); 
        end
        
        function off(obj)
            fwrite(obj.bk9201,'outp off');
        end
    end
end

