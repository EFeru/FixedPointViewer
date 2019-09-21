function varargout = FixedPointViewer(varargin)
% FIXEDPOINTVIEWER MATLAB code for FixedPointViewer.fig
%      FIXEDPOINTVIEWER, by itself, creates a new FIXEDPOINTVIEWER or raises the existing
%      singleton*.
%
%      H = FIXEDPOINTVIEWER returns the handle to a new FIXEDPOINTVIEWER or the handle to
%      the existing singleton*.
%
%      FIXEDPOINTVIEWER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIXEDPOINTVIEWER.M with the given input arguments.
%
%      FIXEDPOINTVIEWER('Property','Value',...) creates a new FIXEDPOINTVIEWER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FixedPointViewer_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FixedPointViewer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FixedPointViewer

% Last Modified by GUIDE v2.5 20-Sep-2019 09:54:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FixedPointViewer_OpeningFcn, ...
                   'gui_OutputFcn',  @FixedPointViewer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% Display error function
% =========================================================================
function display_error()

str_err = ['At least one of the fixdt parameters does not meet the criterias:' newline ...
    ' • Signed = {0,1} (boolean)' newline ...
    ' • WordLegth > 0 (strictly positive)' newline ...
    ' • FractionLenght >= 0 (positive)'];
  errordlg(str_err,'Error');

  
% Read fixdt parameters function
% =========================================================================
function read_fixdtParam(handleRead, handleWrite)

% Read parameters
str             = get(handleRead,'String');
str_split       = split(str,',');
fixdtP.Sign     = str2double(str_split(1));
fixdtP.Word     = str2double(str_split(2));
fixdtP.Frac     = str2double(str_split(3));

% Check for correcteness
if ((fixdtP.Sign ~= 0 && fixdtP.Sign ~= 1) || fixdtP.Word <= 0 || fixdtP.Frac < 0)
    display_error();
    return;
end


fixdtP.floatMax = (2^(fixdtP.Word-fixdtP.Sign) - 1) / 2^fixdtP.Frac;
fixdtP.floatMin = -fixdtP.Sign * (2^(fixdtP.Word -1)) / 2^fixdtP.Frac;
fixdtP.floatPre = 1 / 2^fixdtP.Frac;

valDetails = sprintf('Max: \t %f \nMin: \t %G \nRes: \t %s ', fixdtP.floatMax, fixdtP.floatMin, num2str(fixdtP.floatPre) );
set(handleWrite,'String',valDetails);

% Set values to UserData
set(handleRead, 'UserData', fixdtP);



% Update float calculation
% =========================================================================
function update_float_calc(handles, handleParam, handleRead, handleWrite)

% Read fixdt parameters
read_fixdtParam(handleParam(1), handleParam(2));
fixdtP = get(handleParam(1), 'UserData');

% Read fixdt value
u_fixdtStr  = get(handleRead,'String');
u_fixdt     = str2double(split(u_fixdtStr,','));

% Calculate
y_floatStr  = '';
y_float     = zeros(size(u_fixdt));
for k = 1:length(u_fixdt)
    
    % Check for input out of range
    if (u_fixdt(k) < 0 || u_fixdt(k) > (2^fixdtP.Word - 1))
        errordlg('Value out of range','Error');
        return;
    end
    
    % Caculate float
    if (u_fixdt(k) > (2^(fixdtP.Word - fixdtP.Sign)-1))
        y_float(k) = -(2^fixdtP.Word - u_fixdt(k)) / 2^fixdtP.Frac;     % negative value
    else
        y_float(k) =  u_fixdt(k) / 2^fixdtP.Frac;                  % positive value
    end
    
    % Create string
    if k < length(u_fixdt)
        y_floatStr = strcat(y_floatStr, num2str(y_float(k)), ", ");
    else
        y_floatStr = strcat(y_floatStr, num2str(y_float(k)));
    end
    
end

% Write to float text
set(handleWrite, 'String', y_floatStr);
plotData(handles);


% Update fixdt calculation
% =========================================================================
function update_fixdt_calc(handles, handleParam, handleRead, handleWrite)

% Read fixdt parameters
read_fixdtParam(handleParam(1), handleParam(2));
fixdtP = get(handleParam(1), 'UserData');

% Read float value
u_floatStr  = get(handleRead,'String');
u_float     = str2double(split(u_floatStr,','));

% Calculate
y_fixdtStr  = '';
y_fixdt     = zeros(size(u_float));
for k = 1:length(u_float)
    
    % Check for input out of range
    if (u_float(k) > fixdtP.floatMax || u_float(k) < fixdtP.floatMin)
        errordlg('Value out of range','Error');
        return;
    end
    
    % Caculate fixdt
    if (u_float(k) < 0)
        y_fixdt(k) = 2^fixdtP.Word + floor(u_float(k) * 2^fixdtP.Frac); % negative value
    else
        y_fixdt(k) = floor(u_float(k) * 2^fixdtP.Frac);               % positive value
    end
    
    % Create string
    if k < length(u_float)
        y_fixdtStr = strcat(y_fixdtStr, num2str(y_fixdt(k)), ", ");
    else
        y_fixdtStr = strcat(y_fixdtStr, num2str(y_fixdt(k)));
    end
    
end

set(handleWrite, 'String', y_fixdtStr);
plotData(handles);


% FIXDT UPDATE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function update_fixdt_val(handles)

% Set handles
handleParam     = [handles.edit_valParam handles.text_valDetails];
handleRead      = handles.edit_floatVal;
handleWrite     = handles.edit_fixdtVal;

% Call function
update_fixdt_calc(handles, handleParam, handleRead, handleWrite);


function update_fixdt_XAxis(handles)

% Set handles
handleParam     = [handles.edit_XAParam handles.text_XADetails];
handleRead      = handles.edit_floatXA;
handleWrite     = handles.edit_fixdtXA;

% Call function
update_fixdt_calc(handles, handleParam, handleRead, handleWrite);



function update_fixdt_YAxis(handles)

% Set handles
handleParam     = [handles.edit_YAParam handles.text_YADetails];
handleRead      = handles.edit_floatYA;
handleWrite     = handles.edit_fixdtYA;

% Call function
update_fixdt_calc(handles, handleParam, handleRead, handleWrite);


% FLOAT UPDATE FUNCTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function update_float_val(handles)

% Set handles
handleParam     = [handles.edit_valParam handles.text_valDetails];
handleRead      = handles.edit_fixdtVal;
handleWrite     = handles.edit_floatVal;

% Call function
update_float_calc(handles, handleParam, handleRead, handleWrite);


function update_float_XAxis(handles)

% Set handles
handleParam     = [handles.edit_XAParam handles.text_XADetails];
handleRead      = handles.edit_fixdtXA;
handleWrite     = handles.edit_floatXA;

% Call function
update_float_calc(handles, handleParam, handleRead, handleWrite);


function update_float_YAxis(handles)

% Set handles
handleParam     = [handles.edit_YAParam handles.text_YADetails];
handleRead      = handles.edit_fixdtYA;
handleWrite     = handles.edit_floatYA;

% Call function
update_float_calc(handles, handleParam, handleRead, handleWrite);


function plotData(handles)


% Set default color, linewidth, fontsize, markersize
color   = 'b';
lw      = 1.5;
fs      = 10;
ms      = 20;

% Check what data to plot
b_plotFloatData = get(handles.radioPlotFloat, 'Value');
if b_plotFloatData
    
    handleReadVal   = handles.edit_floatVal;
    handleReadXA    = handles.edit_floatXA;
    handleReadYA    = handles.edit_floatYA;
    
else
    
    handleReadVal   = handles.edit_fixdtVal;
    handleReadXA    = handles.edit_fixdtXA;
    handleReadYA    = handles.edit_fixdtYA;
    
end 


% Check input data
z = get(handles.check_XA, 'Value') + get(handles.check_YA, 'Value');

switch z

    case 0      % Only Values to be plot
    
        u_ValStr    = get(handleReadVal,'String');
        u_Val       = str2double(split(u_ValStr,','));
        plot(handles.axesFig, u_Val,...
            'Marker', '.',...
            'MarkerSize',ms,...
            'Color', color,...
            'Linewidth', lw);
        grid on;
        handles.axesFig.FontSize = fs; 
        xlabel('XAxis','FontSize',fs,'FontWeight','bold');
        ylabel('Values','FontSize',fs,'FontWeight','bold');         
        
    case 1      % 1D map to be plot
        
        u_ValStr    = get(handleReadVal,    'String');
        u_XAStr     = get(handleReadXA,     'String');
        u_Val       = str2double(split(u_ValStr,','));
        u_XA        = str2double(split(u_XAStr,','));
        
        if (length(u_Val) == length(u_XA))
            
            plot(handles.axesFig, u_XA, u_Val,...
                'Marker', '.',...
                'MarkerSize',ms,...
                'Color', color,...
                'Linewidth', lw);
            grid on;
            handles.axesFig.FontSize = fs;
            xlabel('XAxis','FontSize',fs,'FontWeight','bold');
            ylabel('Values','FontSize',fs,'FontWeight','bold');          
              
        else
           
            cla(handles.axesFig);
            str = sprintf('Data cannot be displayed.\nNumbers of data points do not match.');
            text(handles.axesFig, 0.2, 0.5, 0.5, str, 'Color','red');
            
        end
        
    otherwise       % 2D surface to be plot
        
        u_ValStr    = get(handleReadVal,    'String');
        u_XAStr     = get(handleReadXA,     'String');
        u_YAStr     = get(handleReadYA,     'String');
        u_Val       = str2double(split(u_ValStr,','));
        u_XA        = str2double(split(u_XAStr,','));
        u_YA        = str2double(split(u_YAStr,','));
        
        if (length(u_Val) == length(u_XA)*length(u_YA) && length(u_Val) > 1)
            
            yn = length(u_YA);
            xn = length(u_XA);
            Z = zeros(yn, xn);
            for k = 1:yn
                Z(k,:) = u_Val((k-1)*xn+1:k*xn);
            end
            
            s = surf(handles.axesFig, u_XA, u_YA, Z);
            grid on;
            handles.axesFig.FontSize = fs;
            xlabel('XAxis','FontSize',fs,'FontWeight','bold');
            ylabel('YAxis','FontSize',fs,'FontWeight','bold');
            zlabel('Values','FontSize',fs,'FontWeight','bold');
            
            % Set view settings graph
            s.EdgeColor = 'interp';
            colormap jet
            alpha(0.8)
            camlight
            grid on
            lighting gouraud         
            
        elseif (length(u_XA)==length(u_Val) && length(u_XA)==length(u_YA))
            
            plot3(handles.axesFig, u_XA, u_YA, u_Val,...
                'Marker', '.',...
                'MarkerSize',ms,...
                'Color', color,...
                'Linewidth', lw);
            grid on;
            handles.axesFig.FontSize = fs;
            xlabel('XAxis','FontSize',fs,'FontWeight','bold');
            ylabel('YAxis','FontSize',fs,'FontWeight','bold');
            zlabel('Values','FontSize',fs,'FontWeight','bold');
            
        else
            
            cla(handles.axesFig);
            str = sprintf('Data cannot be displayed.\nNumbers of data points do not match.');
            text(handles.axesFig, 0.2, 0.5, 0.5, str, 'Color','red');
            
        end
        
end


% --- Executes just before FixedPointViewer is made visible.
function FixedPointViewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FixedPointViewer (see VARARGIN)

% Fixdt default parameters
% handles.fixdtS = 1;         % Sign
% handles.fixdtW = 16;        % Word length
% handles.fixdtF = 4;         % Fraction length

% Set default parameters
% str = [num2str(handles.fixdtS) ', ' num2str(handles.fixdtW) ', ' num2str(handles.fixdtF)];
% set(handles.edit_valParam,'String',str);

% Read fixdt parameters
read_fixdtParam(handles.edit_valParam, handles.text_valDetails);
read_fixdtParam(handles.edit_XAParam, handles.text_XADetails);
read_fixdtParam(handles.edit_YAParam, handles.text_YADetails);

% Load default example
popupExample_Callback(hObject, eventdata, handles);

% Choose default command line output for FixedPointViewer
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FixedPointViewer wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FixedPointViewer_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% FIXDT PARAMS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit_valParam_Callback(hObject, eventdata, handles)
% hObject    handle to edit_valParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_valParam as text
%        str2double(get(hObject,'String')) returns contents of edit_valParam as a double

update_fixdt_val(handles);

% --- Executes during object creation, after setting all properties.
function edit_valParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_valParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_XAParam_Callback(hObject, eventdata, handles)
% hObject    handle to edit_XAParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_XAParam as text
%        str2double(get(hObject,'String')) returns contents of edit_XAParam as a double

update_fixdt_XAxis(handles);


% --- Executes during object creation, after setting all properties.
function edit_XAParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_XAParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_YAParam_Callback(hObject, eventdata, handles)
% hObject    handle to edit_YAParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_YAParam as text
%        str2double(get(hObject,'String')) returns contents of edit_YAParam as a double

update_fixdt_YAxis(handles);


% --- Executes during object creation, after setting all properties.
function edit_YAParam_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_YAParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% FIXDT VALUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function edit_fixdtVal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fixdtVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fixdtVal as text
%        str2double(get(hObject,'String')) returns contents of edit_fixdtVal as a double

update_float_val(handles);

% --- Executes during object creation, after setting all properties.
function edit_fixdtVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fixdtVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_fixdtXA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fixdtXA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fixdtXA as text
%        str2double(get(hObject,'String')) returns contents of edit_fixdtXA as a double

update_float_XAxis(handles);

% --- Executes during object creation, after setting all properties.
function edit_fixdtXA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fixdtXA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_fixdtYA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_fixdtYA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_fixdtYA as text
%        str2double(get(hObject,'String')) returns contents of edit_fixdtYA as a double

update_float_YAxis(handles);

% --- Executes during object creation, after setting all properties.
function edit_fixdtYA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_fixdtYA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% FLOAT VALUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function edit_floatVal_Callback(hObject, eventdata, handles)
% hObject    handle to edit_floatVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_floatVal as text
%        str2double(get(hObject,'String')) returns contents of edit_floatVal as a double

update_fixdt_val(handles);


% --- Executes during object creation, after setting all properties.
function edit_floatVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_floatVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_floatXA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_floatXA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_floatXA as text
%        str2double(get(hObject,'String')) returns contents of edit_floatXA as a double

update_fixdt_XAxis(handles);


% --- Executes during object creation, after setting all properties.
function edit_floatXA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_floatXA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_floatYA_Callback(hObject, eventdata, handles)
% hObject    handle to edit_floatYA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_floatYA as text
%        str2double(get(hObject,'String')) returns contents of edit_floatYA as a double

update_fixdt_YAxis(handles);


% --- Executes during object creation, after setting all properties.
function edit_floatYA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_floatYA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% OTHER UI CONTROLS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function axesFig_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axesFig (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axesFig

% --- Executes on button press in buttonClear.
function buttonClear_Callback(hObject, eventdata, handles)
% hObject    handle to buttonClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.edit_floatVal,      'String', '0');
set(handles.edit_floatXA,       'String', '0');
set(handles.edit_floatYA,       'String', '0');

set(handles.edit_fixdtVal,      'String', '0');
set(handles.edit_fixdtXA,       'String', '0');
set(handles.edit_fixdtYA,       'String', '0');

% --- Executes on button press in check_XA.
function check_XA_Callback(hObject, eventdata, handles)
% hObject    handle to check_XA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_XA

if (get(handles.check_XA,'Value'))
    set(handles.edit_XAParam,       'Enable', 'on');
    set(handles.text_XADetails,     'Enable', 'on');    
    set(handles.text_floatXAxis,    'Enable', 'on');
    set(handles.edit_floatXA,       'Enable', 'on');
    set(handles.text_fixdtXAxis,    'Enable', 'on');
    set(handles.edit_fixdtXA,       'Enable', 'on'); 
    
    set(handles.check_YA,           'Enable', 'on');   
    
else
    set(handles.edit_XAParam,       'Enable', 'off');
    set(handles.text_XADetails,     'Enable', 'off');    
    set(handles.text_floatXAxis,    'Enable', 'off');
    set(handles.edit_floatXA,       'Enable', 'off');
    set(handles.text_fixdtXAxis,    'Enable', 'off');
    set(handles.edit_fixdtXA,       'Enable', 'off');
    
    set(handles.check_YA,           'Value', 0);  
    check_YA_Callback(hObject, eventdata, handles);
    set(handles.check_YA,           'Enable', 'off');
    
end

% --- Executes on button press in check_YA.
function check_YA_Callback(hObject, eventdata, handles)
% hObject    handle to check_YA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of check_YA

if (get(handles.check_YA,'Value'))
    set(handles.edit_YAParam,       'Enable', 'on');
    set(handles.text_YADetails,     'Enable', 'on');    
    set(handles.text_floatYAxis,    'Enable', 'on');
    set(handles.edit_floatYA,       'Enable', 'on');
    set(handles.text_fixdtYAxis,    'Enable', 'on');
    set(handles.edit_fixdtYA,       'Enable', 'on');    
else
    set(handles.edit_YAParam,       'Enable', 'off');
    set(handles.text_YADetails,     'Enable', 'off');    
    set(handles.text_floatYAxis,    'Enable', 'off');
    set(handles.edit_floatYA,       'Enable', 'off');
    set(handles.text_fixdtYAxis,    'Enable', 'off');
    set(handles.edit_fixdtYA,       'Enable', 'off');  
end

% --- Executes on button press in radioPlotFloat.
function radioPlotFloat_Callback(hObject, eventdata, handles)
% hObject    handle to radioPlotFloat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioPlotFloat
plotData(handles);

% --- Executes on button press in radioPlotFixdt.
function radioPlotFixdt_Callback(hObject, eventdata, handles)
% hObject    handle to radioPlotFixdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radioPlotFixdt
plotData(handles);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function fileGUI_Callback(hObject, eventdata, handles)
% hObject    handle to fileGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function saveGUI_Callback(hObject, eventdata, handles)
% hObject    handle to saveGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveas(gcf,'snapshot.png');
strMsg = sprintf('View successfully saved as ''snapshot.png''.\nPlease check your current folder.');
msgbox(strMsg,'Success','Help','help');

% --------------------------------------------------------------------
function exitGUI_Callback(hObject, eventdata, handles)
% hObject    handle to exitGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all force

% --------------------------------------------------------------------
function helpGUI_Callback(hObject, eventdata, handles)
% hObject    handle to helpGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function gettingStartedGUI_Callback(hObject, eventdata, handles)
% hObject    handle to gettingStartedGUI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

helpStr = ['------------------------- GENERAL INFO----------------------------------' newline ...
    'With this tool the user can view and convert fixed-point data.' newline ...
    'The tool works by first setting the fixed-point parameters in top-right and then inserting the correspondig float or fixed-point data to be converted.' newline newline ...
    '------------------------- PARAMETERS ----------------------------------' newline ...
    'The parameters are in the form (Sign, Word, Fraction):' newline ...
    ' • Sign: 1 (default) | 0 ' newline ...
    '    Sign specified as a boolean. A value of 1, indicates a signed data type. A value of 0 indicates an unsigned data type.' newline ...
    ' • Word length: 16 (default) | scalar integer' newline ...
    '    Word length, in bits, specified as a scalar integer.' newline ...
    ' • Fraction length: 4 (default) | scalar integer' newline ...
    '    Fraction length specified as a scalar integer.' newline newline ...
    '------------------------------ DATA -------------------------------------' newline ...
    'The data can be filled in the bottom-left (float data) or in the bottom-right (fixed-point data).' newline ...
    'In case of any data is updated or changed the correspondig fields will be automatically updated.' newline newline ...
    '----------------------------- EXAMPLES -----------------------------------' newline ...
    'The tool offers 2 examples:' newline ...
    ' • Example 1: illustrates how to view and update a 2D surface map.' newline ...
    ' • Example 2: illustrates how to view and update a 1D map.'];

msgbox(helpStr, 'Getting Started', 'Help', 'help');


% --- Executes on selection change in popupExample.
function popupExample_Callback(hObject, eventdata, handles)
% hObject    handle to popupExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupExample contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupExample

if get(handles.popupExample,'Value') == 1    % Peaks example
    
    % Set checkboxes
    set(handles.check_XA,           'Value', 1);
    set(handles.check_YA,           'Value', 1);
    set(handles.check_YA,           'Enable', 'on');
    check_XA_Callback(hObject, eventdata, handles);
    check_YA_Callback(hObject, eventdata, handles);
    
    % Set fixdt params
    set(handles.edit_valParam,      'String', '1, 16, 4');
    set(handles.edit_XAParam,       'String', '1, 16, 4');
    set(handles.edit_YAParam,       'String', '1, 16, 4');
    
    % Prepare data
    n       = 30;
    data    = peaks(n);
    val     = reshape(data',1,n*n);
    XA      = 1:n;
    YA      = 1:n;
    
    % Convert to string
    valStr  = strjoin(string(val),  ', ');
    XAStr   = strjoin(string(XA),   ', ');
    YAStr   = strjoin(string(YA),   ', ');
    
    % Write data to GUI
    set(handles.edit_floatVal,      'String', valStr);
    set(handles.edit_floatXA,       'String', XAStr);
    set(handles.edit_floatYA,       'String', YAStr);
    
    % Update fixdt values and plot data
    update_fixdt_val(handles);
    update_fixdt_XAxis(handles);
    update_fixdt_YAxis(handles);
    
else                            % Curve example   
    
    % Set checkboxes
    set(handles.check_XA,           'Value', 1);
    set(handles.check_YA,           'Value', 0);
    check_YA_Callback(hObject, eventdata, handles);   
    
    % Prepare data
    val     = [0, 0, 3, 13, 50, 100, 150, 200, 225, 240, 250, 250];
    XA      = [6400, 6720, 7040, 7360, 7680, 8000, 8320, 8640, 8960, 9280, 9600, 9920 ];
    
    % Set fixdt params
    set(handles.edit_valParam,      'String', '0, 10, 0');
    set(handles.edit_XAParam,       'String', '1, 16, 4');
    
    % Convert to string
    valStr  = strjoin(string(val),  ', ');
    XAStr   = strjoin(string(XA),   ', ');
    
    % Write data to GUI
    set(handles.edit_fixdtVal,      'String', valStr);
    set(handles.edit_fixdtXA,       'String', XAStr);
    
    % Update fixdt values and plot data
    update_float_val(handles);
    update_float_XAxis(handles);
    
end

% --- Executes during object creation, after setting all properties.
function popupExample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupExample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
