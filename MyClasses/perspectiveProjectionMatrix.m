function matrix = perspectiveProjectionMatrix(fov, aspect, znear, zfar)
    f = 1 / tan((fov / 2) * (pi / 180));
    matrix = [f/aspect, 0, 0, 0; 0, f, 0, 0; 0, 0, (zfar + znear) / (znear - zfar), -1; 0, 0, 2*zfar*znear / (znear - zfar), 0];
end
