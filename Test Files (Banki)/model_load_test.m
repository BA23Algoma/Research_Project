objtest = LoadOBJFile("C:\Users\olude\Desktop\Research Project\Research_Project\Textures\D_Rock_Formation_CM.obj");
faces = objtest{1}.faces;
uvCoord = objtest{1}.texcoords;
uvCoordtest = objtest{1}.texcoords(:, 3);


