classdef TempSensor < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        temp;
        agilent;
        calib;
        tempFigure;
        colorPalette;
        DT
        T_H;
        T_C;
        RTD_pos;
    end
    
    methods
        function obj = TempSensor()
            
            %% Agilent
            Agilent = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 21, 'Tag', '');
            if isempty(Agilent)
                Agilent = gpib('ni', 0, 21);
            else
                fclose(Agilent);
                Agilent = Agilent(1);
            end
            fopen(Agilent);
            
            %% Calibration
            C = csvread('calibration.csv',1,0); %Fichier avec les valeurs de chaques RTD selon une
            %température donnée
            T = C(:,1);
            R = C(:,2:9);
            calibra = zeros(8,2);
            for i = 1:8;
                calibra(i,:) = polyfit(R(:,i),T,1); %Mesure l'équation de la droite de régression de
                %chaque RTD
            end
            
            %%
            obj.calib = calibra;
            obj.agilent = Agilent;
            obj.colorPalette = ['r','b','g','k','r','b','g','k'];
            obj.tempFigure = figure('Name', 'Temperatures');
            obj.temp = [];
            obj.RTD_pos=[-45 -30 -17 -5 5 17 30 45]/1000;
        end
        
        function r = getTemp(obj)
            r = zeros(1,8);
            R = str2num(query(obj.agilent,'MEAS:RES? (@101,102,103,104,105,106,107,108)'));
            for jj = 1:8
                r(jj) = obj.calib(jj,1)*R(jj) + obj.calib(jj,2);
            end
            obj.temp = [obj.temp;r];
        end
        
        function [dT,T_h0,T_c0] = getDT(obj)
            T_h(1:2)=polyfit(obj.RTD_pos(1:4),obj.temp(end,1:4),1);
            T_c(1:2)=polyfit(obj.RTD_pos(5:8),obj.temp(end,5:8),1);
            dT = T_h(2) - T_c(2);
            T_h0 = T_h(2);
            T_c0 = T_c(2);
        end
        
        function plotTemp(obj)
           figure(obj.tempFigure);
           for i=1:8
               subplot(2,4,i);
               title(['T' i]);
               plot(obj.temp(:,i));
           end
        end
        
        function r = state(obj)
           if (length(obj.temp) > 10)
               T = obj.temp(end-10:end,:);
               var = diff(T);
               if (var < 0.01) == ones(10,8)
                   r = true;
               else
                   r = false;
               end
           else
               r = false;
           end
        end
    end
end
