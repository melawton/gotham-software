function varargout = Gotham3D_sim(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',          mfilename, ...
                   'gui_Singleton',     gui_Singleton, ...
                   'gui_OpeningFcn',    @Gotham3D_sim_OpeningFcn, ...
                   'gui_OutputFcn',     @Gotham3D_sim_OutputFcn, ...
                   'gui_LayoutFcn',     [], ...
                   'gui_Callback',      []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before Gotham3D_sim is made visible.
function Gotham3D_sim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gotham3D_sim (see VARARGIN)

% Choose default command line output for Gotham3D_sim
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Gotham3D_sim_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = getappdata(hObject, 'n');

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% --- Executes on button press in reset_button.

function reset_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% x coordinate and y coordinate are global letting them be called and
% changed from multiple functions
global xc_coord;
global yc_coord;
global zc_coord;
global current;
%Erases the list for the x and y coordinates
xc_coord=[];
yc_coord=[];
zc_coord=[];


% --- Executes on button press in enter_button.
function enter_button_Callback(hObject, eventdata, handles)
% hObject    handle to enter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%declares the x and y coordiantes as global
global xc_coord;
global yc_coord;
global zc_coord;
global numCoils;
global xc_str;
global yc_str;
global zc_str;
global current;
global curr_str;
global t;
global result;
global displayResult;

%Find Object Handles
xc_handle = findobj('Tag','xc_input');
yc_handle = findobj('Tag','yc_input');
zc_handle = findobj('Tag','zc_input');
curr_handle = findobj('Tag','curr_input');
num_coils_handle = findobj('Tag','numCoils');
listbox3_handle = findobj('Tag','listbox3');
xc = str2double(get(xc_handle,'String')); %x coordinate of coil
yc = str2double(get(yc_handle,'String')); %y coordinate of coil
zc = str2double(get(zc_handle,'String')); %z coordinate of coil
curr = str2double(get(curr_handle,'String')); %current going through coil
num_coils = str2double(get(num_coils_handle,'String')); %number of coils

%Adds the x and y to the end of the global variable
 result = '';
% for k = 1:end
    xc_coord(end+1)=xc;
    yc_coord(end+1)=yc;
    zc_coord(end+1)=zc;
    current(end+1)=curr;   
    
    xc_str = num2str(xc_coord);
    yc_str = num2str(yc_coord);
    zc_str = num2str(zc_coord);
    curr_str = num2str(curr);
    assignin('base','Xcoor',xc_coord);
   
    result = strcat(result, xc_str, yc_str, zc_str, curr_str);
%to verify the values of current coils
    assignin('base','XCoord',xc_str);
    assignin('base','YCoord',yc_str);
    assignin('base','ZCoord',zc_str);
    assignin('base','Current',curr_str);
    assignin('base','result', result);
    displayResult = evalin('base', result);
    set(listbox3_handle, 'String', displayResult);
%     set(listbox3_handle, 'String', result);
% end

% f = figure;
% result = [xc_str;yc_str; zc_str; curr_str];
% t = uitable('Parent', f, 'Data',result);

function plot_button_Callback(~, eventdata, handles, varargin)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%x and y are global variables
global xc_coord;
global yc_coord;
global zc_coord;
global current;

%Find Object Handles
x_handle = findobj('Tag','x_input');
y_handle = findobj('Tag','y_input');
z_handle = findobj('Tag','z_input');

x = str2double(get(x_handle,'String')); %x coordinate
y = str2double(get(y_handle,'String')); %y coordinate
z = str2double(get(z_handle,'String')); %z coordinate
x(end)=[];
y(end)=[];
z(end)=[];

counter = 1; %counter for referencing elements from the global arrays
Bfield = 0;
n=length(xc_coord);%n number of coils
numcurrcoils = 5;
magfieldmatrix = zeros(10,10,10);


if length(xc_coord) < 1
    ME = MException('Gotham3d_sim:notEnoughInputs','Please enter a coordinate');
	throw(ME);
    exit;
end

if length(yc_coord) < 1
    ME = MException('Gotham3d_sim:notEnoughInputs','Please enter a coordinate');
	throw(ME);
    exit;
end

if length(zc_coord) < 1
    ME = MException('Gotham3d_sim:notEnoughInputs','Please enter a coordinate');
	throw(ME);
    exit;
end

for coil = 1 : numcurrcoils
    
    mu0 = 4.*pi.*10^(-7);
    coilradius = .5; %radius of coil
 
    
    I = current(n); %current supply
    heightcoil = 2; % height of coil
    numcoils = 5; % number of coils per coil
    heightpercoil = heightcoil/numcoils; %height of each coil
    heightinc = heightpercoil/360; %height increase for each theta
    theta = 0;
   
    

    for x = 1:10
        x1 = (x - xc_coord(n)); %from point to center in x direction
        for y = 1:10
            y1 = (y - yc_coord(n));
            for z = 1:10
               z1 = (z - zc_coord(n));
                 for theta = 0:30:360
                    if theta == 0
                        vector = [x1 y1 z1]; %vector
                        vectordx = [1 1 0];
                        normvectordx = vectordx./norm(vectordx);
                        normvector = vector./norm(vector); 
                        R = sqrt((x1).^2 + y1.^2 + z1.^2)- coilradius;
                        dlxdr = (cross(normvectordx,normvector));
                        Bfield = norm(mu0.*(I.*dlxdr)./R.^3); 
                        magfieldmatrix(x,y,z) =  + Bfield;
                    elseif (theta > 0) && (90 >= theta)
                        deltay = coilradius.*sind(theta);
                        deltax = coilradius.*cosd(theta);
                        deltaz = heightinc.*theta;
                        y2 = y1 + deltay;
                        x2 = x1 + deltax;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vectordx = [deltax deltay deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        vector = [x2 y2 z2];
                        normvector = vector./norm(vector);
                        dlxdr = (cross(normvectordx,normvector));
                        Bfield = norm((mu0.*(I*dlxdr))./R.^3);
                        magfieldmatrix(x,y,z) =  + Bfield;
                    elseif (theta > 90) && (180 >= theta)
                        deltay = coilradius.*(1-cosd(theta));
                        deltax = coilradius.*(1+sind(theta));
                        deltaz = heightinc.*theta;
                        y2 = y2 + deltay;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vectordx = [deltax deltay deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        vector = [x2 y2 z2];
                        normvector = vector./norm(vector);
                        dlxdr = cross(normvectordx,normvector);
                        Bfield = norm(mu0.*(I*dlxdr)./R.^3); 
                        magfieldmatrix(x,y,z) =  + Bfield;
                    elseif (theta > 180) && (270 >= theta)
                        deltay = coilradius.*(-cosd(theta));
                        deltax = coilradius.*(2-sind(theta));
                        deltaz = heightinc.*theta;
                        x2 = x1 + deltax;
                        y2 = y2 + deltay;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vectordx = [deltax deltay deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        vector = [x2 y2 z2];
                        normvector = vector./norm(vector);
                        dlxdr = cross(normvectordx,normvector);
                        Bfield = norm(mu0.*(I*dlxdr)./R.^3);  
                        magfieldmatrix(x,y,z) =  + Bfield;
                    else
                        deltay = coilradius.*(1-cosd(theta));
                        deltax = coilradius.*(1+sind(theta));
                        deltaz = heightinc.*theta;
                        x2 = x1 + deltax;
                        y2 = y2 + deltay;
                        z2 = z1 + deltaz;
                        R = sqrt(x2.^2 + y2.^2 + z2.^2);
                        vector = [x2 y2 z2];
                        vectordx = [deltax deltay deltaz];
                        normvectordx = vectordx./norm(vectordx);
                        normvector = vector./norm(vector);
                        dlxdr = cross(normvectordx,normvector);
                        Bfield = norm(mu0.*(I*dlxdr)./R.^3); 
                        magfieldmatrix(x,y,z) =  + Bfield;
                    end
                end
            end
        end
    end
end


hold all;

plane = magfieldmatrix(:,:,5);
hm = HeatMap(plane,'DisplayRange',100);


result_handle = findobj('Tag','result');
debug_handle = findobj('Tag','debug');

%this line is for debugging
%the '7' in there is a placeholder, feel free to change it
set(debug_handle, 'String', num2str(xc_coord(1))); 
 
%this line outputs the result to the GUI
%change the '9' to 'result' when it's ready
set(result_handle, 'String', num2str(9)); 

 %hm = HeatMap(plane, 'DisplayRange', 0.00001);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%Don't change anything below this

function result_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function result_CreateFcn(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function debug_Callback(hObject, eventdata, handles)
% hObject    handle to debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of debug as text
%        str2double(get(hObject,'String')) returns contents of debug as a double


% --- Executes during object creation, after setting all properties.
function debug_CreateFcn(hObject, eventdata, handles)
% hObject    handle to debug (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function x_input_Callback(hObject, eventdata, handles)
% hObject    handle to x_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_input as text
%        str2double(get(hObject,'String')) returns contents of x_input as a double


% --- Executes during object creation, after setting all properties.
function x_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_input_Callback(hObject, eventdata, handles)
% hObject    handle to y_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_input as text
%        str2double(get(hObject,'String')) returns contents of y_input as a double


% --- Executes during object creation, after setting all properties.
function y_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% 



function z_input_Callback(hObject, eventdata, handles)
% hObject    handle to z_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_input as text
%        str2double(get(hObject,'String')) returns contents of z_input as a double


% --- Executes during object creation, after setting all properties.
function z_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xc_input_Callback(hObject, eventdata, handles)
% hObject    handle to xc_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xc_input as text
%        str2double(get(hObject,'String')) returns contents of xc_input as a double



% --- Executes during object creation, after setting all properties.
function xc_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xc_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zc_input_Callback(hObject, eventdata, handles)
% hObject    handle to zc_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of zc_input as text
%        str2double(get(hObject,'String')) returns contents of zc_input as a double


% --- Executes during object creation, after setting all properties.
function zc_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zc_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function yc_input_Callback(hObject, eventdata, handles)
% hObject    handle to yc_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yc_input as text
%        str2double(get(hObject,'String')) returns contents of yc_input as a double


% --- Executes during object creation, after setting all properties.
function yc_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yc_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function curr_input_Callback(hObject, eventdata, handles)
% hObject    handle to curr_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of curr_input as text
%        str2double(get(hObject,'String')) returns contents of curr_input as a double


% --- Executes during object creation, after setting all properties.
function curr_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to curr_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%<<<<<<< HEAD



% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
% 
% global coor;
% coor[0] = x_coor;
% coor[1] = y_coor;
% set(handles.Table,'coor',coor);
% 
% 


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2
% if (get(hobject, 'Value')== get(hObject, 'Max'))
%     
%     filelocation = get(handles.MAT_file, 'string');
%     
%     loadfile = [

% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable3.
function uitable3_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable3 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
%=======
%>>>>>>> origin/master


% --- Executes on selection change in listbox3.
function listbox3_Callback(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox3


% --- Executes during object creation, after setting all properties.
function listbox3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on listbox3 and none of its controls.
function listbox3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to listbox3 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function numCoils_Callback(hObject, eventdata, handles)
% hObject    handle to numCoils (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numCoils as text
%        str2double(get(hObject,'String')) returns contents of numCoils as a double


% --- Executes during object creation, after setting all properties.
function numCoils_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numCoils (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



