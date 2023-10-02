**********************************************************
Oct. 27th 2014, VizirLabs

by Stéphane Rainville (stephane.rainville@vizirlabs.com)

Matlab Source code for MazeExp.exe (X64)
**********************************************************

- Requirements to run source code in interpreted mode in Matlab:

	- Install PsychToolbox
	- Put 'MyClasses' in Matlab path
	- Run 'MazeExp.m' from command prompt (must run from 'MazeExp.m' current directory or put folder containing 'MazeExp.m' in Matlab path, as well as the '/Mazes', and '/Textures' folders)


- Requirements to compile source code in Matlab:

	- Matlab 2012b or higher + MATLAB Compiler toolbox + PsychToolbox
	- Put 'MyClasses' in Matlab path
	- Create project (using 'deploytool') containing 'MazeExp.m' as the main file
	- Put 'InitializeMatlabOpenGL_SR.m' in /PsychToolbox/PsychOpenGL/MOGL/core
	- Add 'freeglut.dll (X64)', 'glmGetConst.m', 'oglconst.mat' (all in PsychOpenGL folder and subfolders) as shared resources in the project
	- Add 'mazeExpConfig.txt' and 'mazeExpGUI.fig' as a shared resource
	- Build project
	
	