classdef ViewMatrix
    methods (Static)
        function viewMatrix = lookAt(eyePosition, target, up)
            f = ViewMatrix.normalize(target - eyePosition);
            right = cross(up, f);
            u = cross(f, right);

            viewMatrix = eye(4);
            viewMatrix(1, 1:3) = right;
            viewMatrix(2, 1:3) = u;
            viewMatrix(3, 1:3) = -f;
            viewMatrix(4, 1:3) = -eyePosition(1:3);
        end

        function v = normalize(v)
            len = sqrt(v(1)^2 + v(2)^2 + v(3)^2);
            v = v / len;
        end
    end
end
