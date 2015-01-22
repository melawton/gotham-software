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
global current;

xc = str2double(get(handles.xc_input,'String')); %x coordinate of coil
yc = str2double(get(handles.yc_input,'String')); %y coordinate of coil
zc = str2double(get(handles.zc_input,'String')); %z coordinate of coil
curr = str2double(get(handles.curr_input,'String')); %current going through coil
%Adds the x and y to the end of the global variable
xc_coord(end+1)=xc;
yc_coord(end+1)=yc;
zc_coord(end+1)=zc;
current(end+1)=curr;



function plot_button_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%x and y are global variables
global xc_coord;
global yc_coord;
global zc_coord;
global current;

x = str2double(get(handles.x_input,'String')); %x coordinate
y = str2double(get(handles.y_input,'String')); %y coordinate
z = str2double(get(handles.z_input,'String')); %z coordinate

n=length(xc_coord);%n number of coils
%% 
%Constants
mu = 4.*pi.*10^(-7); %vacuum permiability
mur = 1.25663753.*10.^(-6);

I = 100; %current in amps     
r = 0.5; %radius in cm
nc = 10; %number of coils in a loop
m = I.*pi.*r.^2; 

plane = zeros(100); %set up a 100 by 100 matrix
test = [1 2;3 4]; %ignore this line

% Calculate data

for k = 1:n
    
    x_cur = xc_coord(k);
    y_cur = yc_coord(k);
    
    for i = 1:100 %plots B field values on a grid
         dy = 0;
         dx = 0;
            dy = (i-y_cur)./1000;
            for j = 1:100
                dx = (j-x_cur)./1000;
                R = sqrt(dx.^2 + dy.^2);
                if R ~= 0
                   B = (mur.*mu.*m.*n)./(4.*pi.*R.^3);
                   plane(j,i) = plane(j,i) + B; %Magfield at that point
                else      
                   B = mur.*mu.*n./(2.*r);
                   plane(j,i) = plane(j,i) + B;
                end
            end 
     end
end

 result = plane(x,y); %find the B-field at the designated point
 
 %Outputs
 
 set(handles.debug, 'String', num2str(xc_coord(1))); %test
 set(handles.result, 'String', num2str(result)); %outputs result

 hm = HeatMap(plane, 'DisplayRange', 0.00001);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



function result_Callback(hObject, eventdata, handles)
% hObject    handle to result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of result as text
%        str2double(get(hObject,'String')) returns contents of result as a double


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

