function varargout = Gotham2D_sim(varargin)
% I am here
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',          mfilename, ...
                   'gui_Singleton',     gui_Singleton, ...
                   'gui_OpeningFcn',    @Gotham2D_sim_OpeningFcn, ...
                   'gui_OutputFcn',     @Gotham2D_sim_OutputFcn, ...
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

% --- Executes just before Gotham2D_sim is made visible.
function Gotham2D_sim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Gotham2D_sim (see VARARGIN)

% Choose default command line output for Gotham2D_sim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = Gotham2D_sim_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

function plot_button_Callback(hObject, eventdata, handles, varargin)
% hObject    handle to plot_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get user input from GUI
x = str2double(get(handles.x_input,'String')); %x coordinate
y = str2double(get(handles.y_input,'String')); %y coordinate
n = str2double(get(handles.n_input,'String')); %num of coils

xc_1 = str2double(get(handles.xc_1_input,'String')); %x coordinate of first coil
yc_1 = str2double(get(handles.yc_1_input,'String')); %y coordinate of first coil

xc_2 = str2double(get(handles.xc_2_input,'String')); %x coordinate of second coil
yc_2 = str2double(get(handles.yc_2_input,'String')); %y coordinate of second coil

xc_3 = str2double(get(handles.xc_3_input,'String')); %x coordinate of third coil
yc_3 = str2double(get(handles.yc_3_input,'String')); %y coordinate of third coil

xc_coord = [xc_1, xc_2, xc_3];
yc_coord = [yc_1, yc_2, yc_3];

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



function n_input_Callback(hObject, eventdata, handles)
% hObject    handle to n_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of n_input as text
%        str2double(get(hObject,'String')) returns contents of n_input as a double


% --- Executes during object creation, after setting all properties.
function n_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to n_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xc_1_input_Callback(hObject, eventdata, handles)
% hObject    handle to xc_1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xc_1_input as text
%        str2double(get(hObject,'String')) returns contents of xc_1_input as a double


% --- Executes during object creation, after setting all properties.
function xc_1_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xc_1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yc_1_input_Callback(hObject, eventdata, handles)
% hObject    handle to yc_1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yc_1_input as text
%        str2double(get(hObject,'String')) returns contents of yc_1_input as a double


% --- Executes during object creation, after setting all properties.
function yc_1_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yc_1_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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



function xc_2_input_Callback(hObject, eventdata, handles)
% hObject    handle to xc_2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xc_2_input as text
%        str2double(get(hObject,'String')) returns contents of xc_2_input as a double


% --- Executes during object creation, after setting all properties.
function xc_2_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xc_2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yc_2_input_Callback(hObject, eventdata, handles)
% hObject    handle to yc_2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yc_2_input as text
%        str2double(get(hObject,'String')) returns contents of yc_2_input as a double


% --- Executes during object creation, after setting all properties.
function yc_2_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yc_2_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xc_3_input_Callback(hObject, eventdata, handles)
% hObject    handle to xc_3_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xc_3_input as text
%        str2double(get(hObject,'String')) returns contents of xc_3_input as a double


% --- Executes during object creation, after setting all properties.
function xc_3_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xc_3_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yc_3_input_Callback(hObject, eventdata, handles)
% hObject    handle to yc_3_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yc_3_input as text
%        str2double(get(hObject,'String')) returns contents of yc_3_input as a double


% --- Executes during object creation, after setting all properties.
function yc_3_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yc_3_input (see GCBO)
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
