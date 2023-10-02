classdef Collision
        
    methods (Static)                
        
        function [collisionFlag, next] = ClosestsWallCollision(player, walls)
            
            nWalls = numel(walls);
            collisionFlag = zeros(nWalls, 1);
            nextPos = zeros(nWalls, 2);
            
            for wallIndex = 1:nWalls
            
                [wallCollisionFlag, next] = Collision.WallCollision(player, walls(wallIndex));
                collisionFlag(wallIndex, 1) = wallCollisionFlag;
                nextPos(wallIndex, :) = next;                
                
            end
            
            if any(collisionFlag)
                            
                nextPos = nextPos(collisionFlag==1, :);
                dSqr = nextPos(:, 1).^2 + nextPos(:, 2).^2;
                
                [~, minIndex] = min(dSqr);
                next = nextPos(minIndex, :);
                
            else
                
                next = player.proposedPos;
                
            end
            
        end
        
        
        
        function [collisionFlag, next] = WallCollision(player, wall)
                        
            c = Collision.ClosestPointOnLine(player.previousPos, wall.p1, wall.p2);
            dSqr = (player.previousPos-c) * (player.previousPos-c)';
            
            % IF PLAYER ALREADY INTERSECTS LINE
            if dSqr <= player.bodyRadiusSquared
                
                [collisionFlag, next] = Collision.EndPointCollision(player, wall);
                
                
            % ELSE IF PLAYER DOES NOT ALREADY INTERSECTS LINE    
            else
            
                thisunitNormal = wall.unitNormal;
                
                d1 = (player.previousPos - wall.p1) * thisunitNormal';
                d2 = (player.proposedPos - wall.p1) * thisunitNormal';
                
                if sign(d1)==-1
                    
                    d1 = -d1;
                    d2 = -d2;
                    
                end
                
                t = (player.bodyRadius - d1) / (d2-d1);                
                
                % IF PLAYER WILL INTERSECT LINE
                if (t>=0) && (t<=1)
                    
                    tempNext = player.previousPos + (player.proposedPos - player.previousPos) * t;
                    
                    c = Collision.ClosestPointOnLine(tempNext, wall.p1, wall.p2);
                    
                    % IF PLAYER COLLIDES WITH SEGMENT
                    if Collision.IsPointOnSegment(c, wall.p1, wall.p2)
                        
                        collisionFlag = 1;
                        next = tempNext;
                        
                    % ELSE IF PLAYER COLLIDES WITH ENDPOINTS
                    else
                        
                        [collisionFlag, next] = Collision.EndPointCollision(player, wall);
                        
                    end
                    
                    
                % ELSE IF PLAYER WILL NOT INTERSECT LINE    
                else
                    
                    collisionFlag = 0;
                    next = player.proposedPos;
                    
                end
                
            end
            
        end
        
        
        function [collisionFlag, next] = EndPointCollision(player, wall)

            
            [collisionFlag1, tempNext1] = Collision.CirclePointCollision(player, wall.p1);
            [collisionFlag2, tempNext2] = Collision.CirclePointCollision(player, wall.p2);
            
            % IF PLAYER COLLIDES WITH FIRST ENDPOINT
            if collisionFlag1
                
                collisionFlag = 1;
                
                if collisionFlag2
                    
                    d1 = (player.previousPos - tempNext1) * (player.previousPos - tempNext1)';
                    d2 = (player.previousPos - tempNext2) * (player.previousPos - tempNext2)';
                    
                    if d1 > d2
                        
                        next = tempNext2;
                        
                    else
                        
                        next = tempNext1;
                        
                    end
                    
                else
                    
                    next = tempNext1;
                    
                end
                
                % IF PLAYER COLLIDES WITH SECOND ENDPOINT
            else
                
                if collisionFlag2
                    
                    collisionFlag = 1;
                    next = tempNext2;
                    
                else
                    
                    collisionFlag = 0;
                    next = player.proposedPos;
                    
                end
                
            end
            
        end
        
        
        function [collisionFlag, next] = SegmentWallCollision2(player, wall)
                        
            % Check initial conditions
            c = Collision.ClosestPointOnLine(player.previousPos, wall.p1, wall.p2);
            dSqr = (player.previousPos-c) * (player.previousPos-c)';
            
            if dSqr <= player.bodyRadiusSquared
                
                [collisionFlag1, tempNext1] = Collision.CirclePointCollision(player, wall.p1);
                [collisionFlag2, tempNext2] = Collision.CirclePointCollision(player, wall.p2);
                
                if collisionFlag1
                            
                    collisionFlag = 1;
                    
                    if collisionFlag2
                        
                        d1 = (player.previousPos - tempNext1) * (player.previousPos - tempNext1)';
                        d2 = (player.previousPos - tempNext2) * (player.previousPos - tempNext2)';
                        
                        if d1 > d2
                            
                            next = tempNext2;
                            
                        else
                            
                            next = tempNext1;
                            
                        end
                        
                    else
                        
                        next = tempNext1;
                        
                    end
                    
                else
                    
                    if collisionFlag2
                        
                        collisionFlag = 1;
                        next = tempNext2;
                        
                    else
                        
                        collisionFlag = 0;
                        next = player.proposedPos;
                        
                    end
                    
                end
                
            else
            
                thisunitNormal = wall.unitNormal;
                
                d1 = (player.previousPos - wall.p1) * thisunitNormal';
                d2 = (player.proposedPos - wall.p1) * thisunitNormal';
                
                if sign(d1)==-1
                    
                    d1 = -d1;
                    d2 = -d2;
                    
                end
                
                t = (player.bodyRadius - d1) / (d2-d1);
                
                if (t>=0) && (t<=1)
                    
                    tempNext = player.previousPos + (player.proposedPos - player.previousPos) * t;
                    
                    c = Collision.ClosestPointOnLine(tempNext, wall.p1, wall.p2);
                    
                    if Collision.IsPointOnSegment(c, wall.p1, wall.p2)
                        
                        collisionFlag = 1;
                        next = tempNext;
                        
                    else
                        
                        [collisionFlag1, tempNext1] = Collision.CirclePointCollision(player, wall.p1);
                        [collisionFlag2, tempNext2] = Collision.CirclePointCollision(player, wall.p2);
                        
                        if collisionFlag1
                            
                            collisionFlag = 1;
                            
                            if collisionFlag2
                                
                                d1 = (player.previousPos - tempNext1) * (player.previousPos - tempNext1)';
                                d2 = (player.previousPos - tempNext2) * (player.previousPos - tempNext2)';
                                
                                if d1 > d2
                                    
                                    next = tempNext2;
                                    
                                else
                                    
                                    next = tempNext1;
                                    
                                end
                                
                            else
                                
                                next = tempNext1;
                                
                            end
                            
                        else
                            
                            if collisionFlag2
                                
                                collisionFlag = 1;
                                next = tempNext2;
                                
                            else
                                
                                collisionFlag = 0;
                                next = player.proposedPos;
                                
                            end
                            
                        end
                        
                    end
                    
                else
                    
                    collisionFlag = 0;
                    next = player.proposedPos;
                    
                end
                
            end
            
        end
        
        
        function [collisionFlag, next] = WallCollisionVec(player, wallArray)
                        
            collisionFlag = zeros(wallArray.nWalls, 1);
            next = zeros(wallArray.nWalls, 2);
            
            c = Collision.ClosestPointOnLinesVec(player.previousPos, wallArray.p1, wallArray.p2);
            dSqr = (player.previousPos(1)-c(:, 1)).^2 + (player.previousPos(2)-c(:, 2)).^2;
                    
            % -------------------------------------
            % LEVEL 1 - Player already INTERSECTS wall's line
            myIndex1 = find(dSqr <= player.bodyRadiusSquared);
            [collisionFlag1, tempNext1] = Collision.CirclePointsCollisionVec(player, wallArray.p1(myIndex1, :));
            [collisionFlag2, tempNext2] = Collision.CirclePointsCollisionVec(player, wallArray.p2(myIndex1, :));
            
            %       LEVEL 2 - Player COLLIDES with BOTH endpoint circles
            myIndex2 = find(collisionFlag1 & collisionFlag2);
            d1 = (player.previousPos(1) - tempNext1(myIndex2, 1)).^2 + (player.previousPos(2) - tempNext1(myIndex2, 2)).^2;
            d2 = (player.previousPos(1) - tempNext2(myIndex2, 1)).^2 + (player.previousPos(2) - tempNext2(myIndex2, 2)).^2;            
            myIndex3 = find(d1 > d2);
            collisionFlag(myIndex1(myIndex2(myIndex3))) = 1;
            next(myIndex1(myIndex2(myIndex3)), :) = tempNext1(myIndex3, :);            
            myIndex3 = find(d2 >= d1);
            collisionFlag(myIndex1(myIndex2(myIndex3))) = 1;
            next(myIndex1(myIndex2(myIndex3)), :) = tempNext2(myIndex3, :);
            
            %       LEVEL 2 - Player COLLIDES with FIRST endpoint only
            myIndex2 = find( collisionFlag1==1 & collisionFlag2==0 );
            collisionFlag(myIndex1(myIndex2)) = 1;
            next(myIndex1(myIndex2), :) = tempNext1(myIndex2, :);
            
            %       LEVEL 2 - Player COLLIDES with SECOND endpoint only
            myIndex2 = find( collisionFlag1==0 & collisionFlag2==1 );
            collisionFlag(myIndex1(myIndex2)) = 1;
            next(myIndex1(myIndex2), :) = tempNext2(myIndex2, :);

            
            % -------------------------------------
            % LEVEL 1 - Player does NOT INTERSECT wall's line
            myIndex1 = find(dSqr > player.bodyRadiusSquared);
            
            d1 = [player.previousPos(1) - wallArray.p1(myIndex1, 1) player.previousPos(2) - wallArray.p1(myIndex1, 2)];
            d1 = d1 * wallArray.unitNormal(myIndex1, :)';
            d2 = [player.proposedPos(1) - wallArray.p1(myIndex1, 1) player.proposedPos(2) - wallArray.p1(myIndex1, 2)];
            d2 = d2 * wallArray.unitNormal(myIndex1, :)';
            
            signIndex = find(sign(d1)==-1);
            d1(signIndex) = -d1(signIndex);
            d2(signIndex) = -d2(signIndex);

            t = (player.bodyRadius - d1) ./ (d2-d1);
            
            %       LEVEL 2 - COLLISION
            myIndex2 = find( (t>=0) & (t<=1) );            
            
            tempNext = [player.previousPos(1) + (player.proposedPos(1) - player.previousPos(1)) * t(myIndex2) (player.proposedPos(2) - player.previousPos(2)) * t(myIndex2)];
            
            c = Collision.ClosestPointOnLinesVec(tempNext, wallArray.p1(myIndex2, :), wallArray.p2(myIndex2, :));            

            %               LEVEL 3 - Player COLLIDES with SEGMENT
            myIndex3 = find(IsPointOnSegmentsVec(c, wallArray.p1(myIndex2, :), wallArray.p2(myIndex2, :)));
            collisionFlag(myIndex1(myIndex2(myIndex3))) = 1;
            next(myIndex1(myIndex2(myIndex3)), :) = tempNext(myIndex3, :);
            
            %               LEVEL 3 - Player does NOT COLLIDE with SEGMENT
            myIndex3 = find(~IsPointOnSegmentsVec(c, wallArray.p1(myIndex2, :), wallArray.p2(myIndex2, :)));
            [collisionFlag1, tempNext1] = Collision.CirclePointsCollisionVec(player, wallArray(myIndex1(myIndex2(myIndex3))).p1);
            [collisionFlag2, tempNext2] = Collision.CirclePointsCollisionVec(player, wallArray(myIndex1(myIndex2(myIndex3))).p2);

            %                       LEVEL 4 - Player COLLIDES with BOTH ENDPOINTS 
            myIndex4 = find(collisionFlag1 & collisionFlag2);
            d1 = (player.previousPos - tempNext1(myIndex4, 1)).^2 + (player.previousPos - tempNext1(myIndex4, 2)).^2;
            d2 = (player.previousPos - tempNext2(myIndex4, 1)).^2 + (player.previousPos - tempNext2(myIndex4, 2)).^2;
            myIndex5 = find(d1 > d2);
            collisionFlag(myIndex1(myIndex2(myIndex3(myIndex4(myIndex5))))) = 1;
            next(myIndex1(myIndex2(myIndex3(myIndex4(myIndex5)))), :) = tempNext1(myIndex5, :);
            myIndex5 = find(d2 >= d1);
            collisionFlag(myIndex1(myIndex2(myIndex3(myIndex4(myIndex5))))) = 1;
            next(myIndex1(myIndex2(myIndex3(myIndex4(myIndex5)))), :) = tempNext2(myIndex5, :);
            
            %                       LEVEL 4 - Player COLLIDES with FIRST ENDPOINT
            myIndex2 = find( collisionFlag1==1 & collisionFlag2==0 );
            collisionFlag(myIndex1(myIndex2)) = 1;
            next(myIndex1(myIndex2), :) = tempNext1(myIndex2, :);
            
            %                       LEVEL 4 - Player COLLIDES with SECOND ENDPOINT
            myIndex2 = find( collisionFlag1==0 & collisionFlag2==1 );
            collisionFlag(myIndex1(myIndex2)) = 1;
            next(myIndex1(myIndex2), :) = tempNext2(myIndex2, :);

            
            %       LEVEL 2 - NO COLLISION
            myIndex2 = find( (t<0) & (t>1) );
            next(myIndex1(myIndex2), 1) = player.proposedPos(1);
            next(myIndex1(myIndex2), 2) = player.proposedPos(2);
            
        end
            
                    
%         function [collisionFlag, next] = SegmentWallsCollisionVec(player, wallArray, wallIndex)
%             
%             nWalls = numel(wallIndex);
%             
%             c = ClosestPointOnLinesVec(player.previousPos, wallArray.p1(wallIndex, :), wallArray.p2(wallIndex, :));
%             dSqr = (player.previousPos(1)-c(:, 1)).^2 + (player.previousPos(2)-c(:, 2)).^2;
%             
%             unitNormal = wallArray.unitNormal(wallIndex, :);
%             
%             previousPos = repmat(player.previousPos, [nWalls 1]);
%             proposedPos = repmat(player.proposedPos, [nWalls 1]);
%             next        = proposedPos;
%             
%             d1 = sum( (previousPos - p1) .* unitNormal, 2);
%             
%             negIndex = find(sign(d1)==-1);
%             unitNormal(negIndex, :) = -unitNormal(negIndex, :);
%             
%             d1 = sum( (previousPos - p1) .* unitNormal, 2);
%             d2 = sum( (proposedPos - p1) .* unitNormal, 2);
%             
%             t = (player.bodyRadius - d1) ./ (d2-d1);
%             
%             t2 = (0 - d1) ./ (d2-d1);
%             myIntersect = previousPos + (proposedPos - previousPos) .* [t2 t2];
%             
%             isPointInRect = Collision.IsPointsInRectVec(myIntersect, p1, p2);
%             
%             collisionFlag = (t>=0) & (t<=1) & isPointInRect;
%             collisionIndex = find(collisionFlag==1);
%             
%             if ~isempty(collisionIndex)
%                 
%                 next(collisionIndex, :) = previousPos(collisionIndex, :) + (proposedPos(collisionIndex, :) - previousPos(collisionIndex, :)) .* [t(collisionIndex) t(collisionIndex)];
%                 
%             end
%             
%         end
%         
        
        function [collisionFlag, next] = CircleWallCollision(player, wall)
            
            d1 = Collision.ClosestPointOnLine(wall.p1, player.previousPos, player.proposedPos);
            length1 = (d1 - wall.p1) * (d1 - wall.p1)';
            
            d2 = Collision.ClosestPointOnLine(wall.p2, player.previousPos, player.proposedPos);
            length2 = (d2 - wall.p2) * (d2 - wall.p2)';
            
            [~, iIndex] = min([length1 length2]);
            
            if iIndex == 1
                
                point = wall.p1;
                
            elseif iIndex == 2
                
                point = wall.p2;
                
            else
                
                error('Unknown point index');
                
            end
            
            [collisionFlag, next] = Collision.CirclePointCollision(player, point);
            
        end
        
        
        function [collisionFlag, next] = CircleWallsCollisionVec(player, wallArray, wallIndex)
            
            p = [wallArray.p1(wallIndex, :); wallArray.p2(wallIndex, :)];
            
            [collisionFlag, next] = Collision.CirclePointsCollisionVec(player, p);
            
        end
        
        
        function [collisionFlag, next] = CirclePointCollision(player, point)
                                    
            d = Collision.ClosestPointOnLine(point, player.previousPos, player.proposedPos);
            
            closestDistSquared = (point - d) * (point - d)';
            
            if (closestDistSquared <= player.bodyRadiusSquared) && (player.norm > 0.000001)
                
                collisionFlag = 1;
                
                backDist = realsqrt( player.bodyRadiusSquared - closestDistSquared );
                next = d - player.v  * backDist / player.norm;
                
            else
                
                collisionFlag = 0;
                next = player.proposedPos;
                
            end
            
        end
        
        
        function [collisionFlag, next] = CirclePointsCollisionVec(player, pointArray)
            
            nPoints = size(pointArray, 1);
            next = repmat(player.proposedPos, [nPoints, 1]);
            
            d = Collision.ClosestPointsOnLineVec(pointArray, player.previousPos, player.proposedPos);
            
            closestDistSquared = pointArray-d;
            closestDistSquared = closestDistSquared(:, 1).^2 + closestDistSquared(:, 2) .^2;
            
            collisionFlag = closestDistSquared <= player.bodyRadiusSquared;
            collisionIndex = find(collisionFlag==1);
            
            backDist = realsqrt( player.bodyRadiusSquared - closestDistSquared(collisionIndex)) / player.norm;
            next(collisionIndex, 1) = d(collisionIndex, 1) - player.v(1) .* backDist;
            next(collisionIndex, 2) = d(collisionIndex, 2) - player.v(2) .* backDist;
            
        end
        
        
        function [collisionFlag, next] = CircleLineCollision(player, wall)
            
            collisionFlag = 0;
            
            thisunitNormal = wall.unitNormal;
            
            d1 = (player.previousPos - wall.p1) * thisunitNormal';
            
            if sign(d1) == -1
                
                thisunitNormal = -thisunitNormal;
                d1 = (player.previousPos - wall.p1) * thisunitNormal';
                
            end
            
            d2 = (player.proposedPos - wall.p1) * thisunitNormal';
            
            t = (player.bodyRadius - d1) / (d2-d1);
            
            if (t>=0) && (t<=1)
                
                collisionFlag = 1;
                next = player.previousPos + (player.proposedPos - player.previousPos) * t;
                
            else
                
                next = player.proposedPos;
                
            end
            
        end
        
        
        
        function [collisionFlag, next] = CircleLinesCollisionVec(player, wallArray, wallIndex)
            
            nWalls = numel(wallIndex);
            p1 = wallArray.p1(wallIndex, :);
            %             p2 = wallArray.p2(wallIndex, :);
            unitNormal = wallArray.unitNormal(wallIndex, :);
            
            previousPos = repmat(player.previousPos, [nWalls 1]);
            proposedPos = repmat(player.proposedPos, [nWalls 1]);
            next        = proposedPos;
            
            d1 = sum( (previousPos - p1) .* unitNormal, 2);
            
            negIndex = find(sign(d1)==-1);
            unitNormal(negIndex, :) = -unitNormal(negIndex, :);
            
            d1 = sum( (previousPos - p1) .* unitNormal, 2);
            d2 = sum( (proposedPos - p1) .* unitNormal, 2);
            
            t = (player.bodyRadius - d1) ./ (d2-d1);
            
            collisionFlag = (t>=0) & (t<=1);
            collisionIndex = find(collisionFlag==1);
            
            if ~isempty(collisionIndex)
                
                next(collisionIndex, :) = previousPos(collisionIndex, :) + (proposedPos(collisionIndex, :) - previousPos(collisionIndex, :)) .* [t(collisionIndex) t(collisionIndex)];
                
            end
            
            
        end
        
        
        function d1 = ClosestPointOnLine(p1, l1, l2)
            
            a1 = l2(2) - l1(2);
            b1 = l1(1) - l2(1);
            
            c1 = a1  * l1(1) + b1 * l1(2);
            c2 = -b1 * p1(1) + a1 * p1(2);
            
            d = a1 * a1 - (-b1) * b1;
            
            if(d ~= 0)
                
                cx = (a1*c1 - b1*c2) / d;
                cy = (a1*c2 - (-b1)*c1) / d;
                d1 = [cx cy];
                
            else
                
                d1 = [p1(1) p1(2)];
                
            end
            
        end
        
        
        function c = ClosestPointsOnLineVec(pointArray, l1, l2)
            
            a1 = l2(2) - l1(2);
            b1 = l1(1) - l2(1);
            
            c1 = a1 .* l1(1) + b1 .* l1(2);
            c2 = -b1 .* pointArray(:, 1) + a1 .* pointArray(:, 2);
            
            d = a1.*a1 - (-b1).*b1;
            
            cx = (a1.*c1 - b1.*c2);
            cy = (a1.*c2 - (-b1).*c1);
            c = [cx cy] / d;
            
        end
        

        function c = ClosestPointOnLinesVec(point, l1, l2)
            
            a1 = l2(:, 2) - l1(:, 2);
            b1 = l1(:, 1) - l2(:, 1);
            
            c1 = a1 .* l1(:, 1) + b1 .* l1(:, 2);
            c2 = -b1 * point(1) + a1 * point(2);
            
            d = a1.*a1 - (-b1).*b1;
            
            cx = (a1.*c1 - b1.*c2);
            cy = (a1.*c2 - (-b1).*c1);
            c = [cx cy] ./ [d d];
            
        end
                
        
        function [collisionFlag, intersectPoint] = LineIntersect(p0,  p1,  p2,  p3)
            
            s1 = p1 - p0;
            s2 = p3 - p2;
            
            s = (-s1(2) * (p0(1) - p2(1)) + s1(1) * (p0(2) - p2(2))) / (-s2(1) * s1(2) + s1(1) * s2(2));
            t = ( s2(1) * (p0(2) - p2(2)) - s2(2) * (p0(1) - p2(1))) / (-s2(1) * s1(2) + s1(1) * s2(2));
            
            if (s >= 0 && s <= 1 && t >= 0 && t <= 1)
                
                collisionFlag = 1;
                intersectPoint = [p0(1) + (t * s1(1)) p0(2) + (t * s1(2))];
                
            else
                
                collisionFlag = 0;
                intersectPoint = [];
                
            end
            
        end
        
        
        function isPointOnSegment = IsPointOnSegment(point, p1, p2)
            
            l1 = (point - p1) * (point - p1)';
            l2 = (point - p2) * (point - p2)';
            l3 = (p1 - p2) * (p1 - p2)';
            
            if (l1 + l2) > l3
                
                isPointOnSegment = 0;
                
            else
                
                isPointOnSegment = 1;
                
            end
            
        end
        
        
        function isPointOnSegment = IsPointOnSegmentsVec(point, p1, p2)
            
            l1 = (point(1) - p1(:, 1)).^2 + (point(2) - p1(:, 2)).^2;
            l2 = (point(1) - p2(:, 1)).^2 + (point(2) - p2(:, 2)).^2;
            l3 = (p1(:, 1) - p2(:, 1)).^2 + (p1(:, 2) - p2(:, 2)).^2;
            
            isPointOnSegment = ~((l1 + l2) > l3);
                        
        end

        
        
        function isInRect = IsPointsInRectVec(pointArray, p1, p2)
            
            
            xMin = min([p1(:, 1) p2(:, 1)], [], 2);
            xMax = max([p1(:, 1) p2(:, 1)], [], 2);
            yMin = min([p1(:, 2) p2(:, 2)], [], 2);
            yMax = max([p1(:, 2) p2(:, 2)], [], 2);
            
            isInRect = (pointArray(:, 1) >= xMin) & (pointArray(:, 1) <= xMax) & (pointArray(:, 2) >= yMin) & (pointArray(:, 2) <= yMax);
            
        end
        
    end
    
end