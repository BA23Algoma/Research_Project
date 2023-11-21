function onScreen = IsBoundingBoxOnScreen(boundingBox, viewMatrix, projectionMatrix)
    % Transform bounding box to screen coordinates
    transformedBox = TransformBoundingBox(boundingBox, viewMatrix, projectionMatrix);

    % Check if any part of the bounding box is on screen
    screenWidth = Screen('WindowSize', windowIndex, 1);
    screenHeight = Screen('WindowSize', windowIndex, 2);

    onScreen = all(transformedBox(1, :) < screenWidth) && ...
                all(transformedBox(2, :) > 0) && ...
                all(transformedBox(3, :) < screenHeight) && ...
                all(transformedBox(4, :) > 0);
end
