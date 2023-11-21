function [minMax, boundingBox] = calculateBoundingBox(vertices, localTransform, globalTransform, projectionMatrix)

    %globalTransform = [globalTransform, 1];
    %globalTransform = reshape(globalTransform, 4, 1);

    vertices = [vertices; ones(1, size(vertices, 2))];

    combineTransform = globalTransform * localTransform;

    % Apply local and global transformations to vertices    
    transformedVertices = combineTransform * vertices;

    % Project vertices to 2D space using perspective projection
    projectedVertices = projectionMatrix * transformedVertices;

    % Normalize homogeneous coordinates
    projectedVertices = projectedVertices ./ projectedVertices(4, :);

    % Calculate bounding box in 2D space
    minX = min(projectedVertices(1, :));
    maxX = max(projectedVertices(1, :));
    minY = min(projectedVertices(2, :));
    maxY = max(projectedVertices(2, :));

    % Bounding box in screen coordinates
    minMax = [minX, minY, maxX, maxY];
    
    %-------------------Box Drawing Claculations------------------

    % Calculate min and max along each axis
    minCoords = min(transformedVertices(1:3, :), [], 2);
    maxCoords = max(transformedVertices(1:3, :), [], 2);

    % Construct the bounding box vertices
    boundingBox = [
        minCoords(1), minCoords(2), minCoords(3);
        minCoords(1), minCoords(2), maxCoords(3);
        minCoords(1), maxCoords(2), minCoords(3);
        minCoords(1), maxCoords(2), maxCoords(3);
        maxCoords(1), minCoords(2), minCoords(3);
        maxCoords(1), minCoords(2), maxCoords(3);
        maxCoords(1), maxCoords(2), minCoords(3);
        maxCoords(1), maxCoords(2), maxCoords(3);
    ]';
end
