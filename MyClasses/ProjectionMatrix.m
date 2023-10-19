classdef ProjectionMatrix
    methods (Static)
        function projectionMatrix = perspective(fov, aspect, near, far)
            f = 1 / tan((fov * pi / 180) / 2);
            projectionMatrix = [
                f / aspect, 0, 0, 0;
                0, f, 0, 0;
                0, 0, (far + near) / (near - far), -1;
                0, 0, (2 * far * near) / (near - far), 0
            ];
        end
    end
end
