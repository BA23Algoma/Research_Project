% Function to create a rotation matrix from Euler angles
function R = euler2rotmat(angles)
    % Convert Euler angles to rotation matrix
    alpha = angles(1);
    beta = angles(2);
    gamma = angles(3);

    Rx = [1, 0, 0; 0, cosd(alpha), -sind(alpha); 0, sind(alpha), cosd(alpha)];
    Ry = [cosd(beta), 0, sind(beta); 0, 1, 0; -sind(beta), 0, cosd(beta)];
    Rz = [cosd(gamma), -sind(gamma), 0; sind(gamma), cosd(gamma), 0; 0, 0, 1];

    % Combine rotations about X, Y, and Z axes
    R = eye(4);
    R(1:3, 1:3) = Rz * Ry * Rx;
end

