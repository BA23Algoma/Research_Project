classdef TrialId
    
    properties
        
        blockNum;
        mazeFileNamePrefix;
        participantId;
        tourType;
        
    end
    
    methods
        
        function obj = TrialId(ParticipantId, MazeFileNamePrefix, BlockNum, TourType)
            
            obj.participantId = ParticipantId;
            obj.mazeFileNamePrefix = MazeFileNamePrefix;
            obj.blockNum = BlockNum;
            obj.tourType = TourType;            
            
        end
        
    end
    
end