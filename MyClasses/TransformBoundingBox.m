function transformedBox = TransformBoundingBox(boundingBox, viewMatrix, projectionMatrix)
    % Combine view and projection matrices
    modelViewProjection = projectionMatrix * viewMatrix;

    % Homogeneous coordinates of the bounding box vertices
    homogeneousVertices = [boundingBox; ones(1, size(boundingBox, 2))];

    % Transform vertices to screen coordinates
    screenCoords = modelViewProjection * homogeneousVertices;

    % Normalize by w-coordinate to get 2D screen coordinates
    normalizedCoords = screenCoords(1:3, :) ./ screenCoords(4, :);

    % Transpose for easier indexing
    transformedBox = normalizedCoords';
end
