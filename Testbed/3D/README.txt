This directory holds all code needed to run the 3D testbed.

To run the program, open up the "Gotham3D_sim.fig" file in matlab and hit the "plot" button

To edit the GUI you have to go to the matlab command window and type in "guide('Gotham3D_sim.fig')"

The "Debug" box that says "foo" by default is used for debugging and finding errors in the code. Basically, the
box will display the value of any variable you want it to. To access it, look at line 264 (as of 1/30/2015) in 
the .m file, under the comment "%this line is for debugging". Change the "x" variable in "num2str(x)" to output 
the value of x to the GUI. For example, if I want to examine the value that is currently in being stored in 
the first position of the xc_coord list, the entire line would read "set(handles.debug, 'String', num2str(xc_coord(1)));".