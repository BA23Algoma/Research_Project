classdef SkyboxVertices
    properties (Constant)
        vertices = single([
            % positions
            -1,  1, -1,
            -1, -1, -1,
             1, -1, -1,
             1, -1, -1,
             1,  1, -1,
            -1,  1, -1,

            -1, -1,  1,
            -1, -1, -1,
            -1,  1, -1,
            -1,  1, -1,
            -1,  1,  1,
            -1, -1,  1,

             1, -1, -1,
             1, -1,  1,
             1,  1,  1,
             1,  1,  1,
             1,  1, -1,
             1, -1, -1,

            -1, -1,  1,
            -1,  1,  1,
             1,  1,  1,
             1,  1,  1,
             1, -1,  1,
            -1, -1,  1,

            -1,  1, -1,
             1,  1, -1,
             1,  1,  1,
             1,  1,  1,
            -1,  1,  1,
            -1,  1, -1,

            -1, -1, -1,
            -1, -1,  1,
             1, -1, -1,
             1, -1, -1,
            -1, -1,  1,
             1, -1,  1
        ]);
    end
end