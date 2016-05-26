classdef Julabo
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        serialID
        set_to
        version
    end
    
    methods
        function obj = Julabo()
            serialID = instrfind('Type', 'serial', 'Port', 'COM3', 'Tag', '','BaudRate', 4800, 'Parity','Even','FlowControl','hardware','DataBits',7,'StopBits',1,'Terminator','CR');
            if isempty(serialID)
                serialID = serial('COM3','BaudRate', 4800, 'Parity','Even','FlowControl','hardware','DataBits',7,'StopBits',1,'Terminator','CR');
            else
                fclose(serialID);
                serialID = serialID(1);
            end
            fopen(serialID);
            obj.serialID = serialID;
            obj.version = query(serialID,'version');
        end
        
        function setPnt(obj,set_to)
            obj.set_to = set_to;
            fprintf(obj.serialID,'out_sp_00 %2.2f',set_to,'async');
            pause(0.3);
            fprintf(obj.serialID,'out_mode_01 0','async');
            pause(0.3);
        end
        
        function start(obj)
           fprintf(obj.serialID,'out_mode_05 1','async');
           pause(0.3);
        end
        
        function stop(obj)
           fprintf(obj.serialID,'out_mode_05 0','async');
           pause(0.3);
        end
        
        function t = extTemp(obj)
           t = query(obj.serialID,'in_pv_02'); 
        end
    end
end

