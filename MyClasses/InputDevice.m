classdef InputDevice
    
    properties
        
        deviceType;
        platformType;
        
    end
    
    properties (Constant)
       
        piOver180 = pi/180;
        validDeviceTypes = {'KEYBOARD', 'JOYSTICK'};
        validPlatformsTypes = {'PC', 'MAC'};
        
    end
    
    methods
        
        function obj = InputDevice(varargin)
            
            
            obj.deviceType = varargin{1};
            
        end
        
        function obj = set.deviceType(obj, DeviceType)
            
            if ischar(DeviceType)
                
                if any(strcmp(DeviceType, obj.validDeviceTypes))
                    
                    obj.deviceType = DeviceType;
                    
                else
                    
                    error('Valud input devices are either KEYBOARD or JOYSTICK');
                    
                end
                
            else
                
                error('Input device specification must be a string');
                
            end
            
        end
        
        
        function obj = set.platformType(obj, PlatformType)
            
            if ischar(PlatformType)
                
                if any(strcmp(PlatformType, obj.validPlatformsTypes))
                    
                    obj.platformType = PlatformType;
                    
                else
                    
                    error('Valid platform types are either PC or MAC');
                    
                end
                
            else
                
                error('Input device specification must be a string');
                
            end
            
        end
        
        
    end    
    
end