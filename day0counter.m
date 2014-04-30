function varargout = day0counter(varargin)
% DAY0COUNTER M-file for day0counter.fig
%      
%   This simple program allows the user to quickly input the number of
%   cells at each slice in a stack, which is shown iteratively to the user
%   until the end of the stack is reached. Once the end of the stack has
%   been reached, the data can be saved into the corresponding .mat file using
%   the save button. The program loads only one image file, so make sure
%   multichannel images are merged. 
%
%      DAY0COUNTER, by itself, creates a new DAY0COUNTER or raises the existing
%      singleton*.
%
%      H = DAY0COUNTER returns the handle to a new DAY0COUNTER or the handle to
%      the existing singleton*.
%
%      DAY0COUNTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DAY0COUNTER.M with the given input arguments.
%
%      DAY0COUNTER('Property','Value',...) creates a new DAY0COUNTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before day0counter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to day0counter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help day0counter

% Last Modified by GUIDE v2.5 29-Apr-2014 22:32:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @day0counter_OpeningFcn, ...
                   'gui_OutputFcn',  @day0counter_OutputFcn, ...
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

% --- Executes just before day0counter is made visible.
function day0counter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to day0counter (see VARARGIN)

% Choose default command line output for day0counter
handles.output = hObject;

% Set pop-up menu for Astrocyte types

AstrNameList =  {'None', 'CortA', 'DeltaA', 'EfnA', 'WntA'};
set(handles.type1AstrSelect, 'String', AstrNameList);
set(handles.type2AstrSelect, 'String', AstrNameList);
handles.AstrNameList = AstrNameList;
handles.numtypes = 0;
handles.stkloaded = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes day0counter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = day0counter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in loadmat.
function loadmat_Callback(hObject, eventdata, handles)
% hObject    handle to loadmat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[stksmatname, pathname, filterindex] = uigetfile('.mat', 'Please select .mat file that contains d0 stks data', 'MultiSelect', 'Off');
handles.stksmatname = stksmatname; 
handles.matname = makeMatName(stksmatname);
handles.pathname = pathname;

% Once a new mat file has been selected, the number of cell types is set to
% 0, so that the pop-up menus for type 1 and type 2 astrocytes are
% selectable again. 

handles.numtypes = 0;

% List d0 data variables in local environment. Using reexp, find all
% variables that are of the form d0.*_stk

load(strcat(pathname, stksmatname));
varlist = who;
d0stkIndices = regexp(varlist,'d0.*_stk');
d0stks = cell(0);

for i=1:size(varlist,1)
    if d0stkIndices{i}
        d0stks = [varlist{i}, d0stks];
    end
end

set(handles.TLstk_select, 'String', d0stks);
set(handles.FLstk_select, 'String', ['None', d0stks]);

guidata(hObject, handles);

% --- Executes on button press in Open.
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load image stacks into handles.TLimstack, handles.TLimstackname,
% handles.FLimstack, and handles.FLimstackname.

load([handles.pathname, handles.stksmatname]);
TLindex = get(handles.TLstk_select, 'Value');
TLimstacks = get(handles.TLstk_select, 'String');
TLimstackName = TLimstacks{TLindex};
TLimstack = eval(TLimstackName);
%TLimstack = dip_array(TLimstack); %convert to Matlab image array
handles.TLimstack=TLimstack;
handles.TLimstackName = TLimstackName;
TLimstacksize = size(handles.TLimstack,1);
 
FLindex = get(handles.FLstk_select, 'Value');
FLimstacks = get(handles.FLstk_select, 'String');
FLimstackName = FLimstacks{FLindex};

if strcmp(FLimstackName,'None')
    handles.FLimstack=0;
    handles.FLimstackName = FLimstackName;
else
    FLimstack = eval(FLimstackName);
    %FLimstack = dip_array(FLimstack); %convert to Matlab image array
    handles.FLimstack=FLimstack;
    handles.FLimstackName = FLimstackName;
    FLimstacksize = size(handles.FLimstack,1);
    
    if FLimstacksize ~= TLimstacksize
        error('The two stack sizes do not match');
    end
    
end

% initializes variables in handles structure 

handles.totalnum = TLimstacksize; %should always have a TL image
type1AstrIndex = get(handles.type1AstrSelect, 'Value');
type1AstrName = handles.AstrNameList{type1AstrIndex};
type2AstrIndex = get(handles.type2AstrSelect, 'Value');
type2AstrName = handles.AstrNameList{type2AstrIndex};
handles.AstrNames={type1AstrName, type2AstrName};
handles.AstrIndices={type1AstrIndex, type2AstrIndex};

% Assume that the list of options has not changed: 
% {'None', 'CortA', 'Delta CortA', 'Efn CortA', 'Wnt CortA'}

if (type1AstrIndex==1)&(type2AstrIndex~=1)
    display('Please move Astrocyte selection to the first popup menu and press Load again');
    handles.numtypes = 0;
    
elseif type1AstrIndex==1
    
    handles.numtypes = 1;
    handles.fieldsList = {'numNPCs_d0'};
    
elseif type2AstrIndex==1
    
    handles.numtypes = 2;
    handles.fieldsList = {'numNPCs_d0', ['num' type1AstrName '_d0']};
    
else
    
    handles.numtypes = 3;
    handles.fieldsList = {'numNPCs_d0', ['num' type1AstrName '_d0'], ['num' type2AstrName '_d0']};
    
end

% Load corresponding dataFrame and save in handles object

load([handles.pathname, handles.matname]);
dataFrameName = makeDataFrameName(handles.TLimstackName);
varlist = who;
DFexist = regexp(varlist,dataFrameName);

if ~isempty(DFexist)
    dataFrame = eval(dataFrameName);
    handles.dataFrame=dataFrame;
else
    error(['Data frame does not exist in ' matname ' file']);
end

% Load previous data if necessary

if get(handles.load_prev, 'Value')
    
    loadTableData(hObject, handles);
    handles = guidata(hObject); %retrieve data from loadTableData
        
    % load appropriate images into current window
    
    handles = plotpictures(handles);
    handles.stkloaded = 1;
    
else %nothing has yet been processed
    handles.n = 1;
    set(handles.uitable1,'Data',[]);
    handles = plotpictures(handles);
    handles.stkloaded = 1;
end

set(handles.slicenum, 'String', num2str(handles.n));

guidata(hObject, handles);


% --- Executes on selection change in type1AstrSelect.
function type1AstrSelect_Callback(hObject, eventdata, handles)
% hObject    handle to type1AstrSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns type1AstrSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type1AstrSelect

% Once type 1 astrocytes have been selected before opening the stack, this
% selection cannot be changed

if handles.numtypes
    prevtype=handles.AstrIndices{1};
    set(hObject, 'Value', prevtype)
end

% --- Executes on selection change in type2AstrSelect.
function type2AstrSelect_Callback(hObject, eventdata, handles)
% hObject    handle to type2AstrSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns type2AstrSelect contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type2AstrSelect

% Once type 2 astrocytes have been selected before opening the stack, you
% cannot change the selection

if handles.numtypes
    prevtype=handles.AstrIndices{2};
    set(hObject, 'Value', prevtype)
end

% --- Executes on key press with focus on NPCnum and none of its controls.
function NPCnum_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to NPCnum (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if (handles.numtypes==1)&(strcmp(eventdata.Key,'return'))
    updateTable(hObject, handles);
    set(handles.type2AstrNum, 'String', '');
    uicontrol(handles.NPCnum);
end

% --- Executes on key press with focus on type1AstrNum and none of its controls.
function type1AstrNum_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to type1AstrNum (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if (handles.numtypes==2)&(strcmp(eventdata.Key,'return'))    
    updateTable(hObject, handles);
    set(handles.type2AstrNum, 'String', '');
    uicontrol(handles.NPCnum);
end

% --- Executes on key press with focus on type2AstrNum and none of its controls.
function type2AstrNum_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to type2AstrNum (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


if (handles.numtypes==3)&(strcmp(eventdata.Key,'return'))
    updateTable(hObject, handles);
    set(handles.type2AstrNum, 'String', '');
    uicontrol(handles.NPCnum);
end

% --- Sets data frame data into uitable

function loadTableData(hObject, handles)
% dataFrame structure with data for the slide and well. sl#_w#_data
% handles structure with handles and user data (see GUIDATA)
% First, figure out how many cell typxes we are working with

numtypes = handles.numtypes;

% Pull out the relevant data vectors out of the data structure

if numtypes==0
    error(['Number of cell types not set'])
end

tabledata = getTableData(handles.dataFrame, handles.fieldsList);

% find and set n = size of data

n = size(tabledata,1);

% add slice number labels to data in table: 

sliceNumCol = [1:n];
tabledata = [sliceNumCol' tabledata];
set(handles.uitable1, 'Data', flipud(tabledata));

% set slice number indicator to next picture

handles.n = min(n+1, 247); % increment n by 1 and cap at 247. 
set(handles.slicenum, 'String', num2str(n));

guidata(hObject, handles);

% --- Executes on button press in undo.
function undo_Callback(hObject, eventdata, handles)
% hObject    handle to undo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.n == 1
    
   display('cannot go back');
    
else
    
   % roll n back by 1
   handles.n = handles.n - 1;
   n = handles.n;
   
   % roll displayed image back by 1
   handles = plotpictures(handles);
   
   % roll data in uitable1 back by 1
   tabledata = get(handles.uitable1, 'Data');
   tabledata = tabledata(2:n,:);
   set(handles.uitable1, 'Data', tabledata);

end

guidata(hObject, handles);


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Determine the dataFrameName

dataFrameName = makeDataFrameName(handles.TLimstackName);

% Get the data from the GUI

tabledata = flipud(get(handles.uitable1, 'Data'));

% Load the well data frame from the .mat file

load([handles.pathname, handles.matname]);

% Remove first column from tabledata: 

tabledata = tabledata(:, 2:end);

% Set the data in fieldsList into the data frame variable

dataFrame = setTableData(tabledata, handles.dataFrame, handles.fieldsList) %display it in command window

% Assign the value of dataFrame into dataFrameName

eval([dataFrameName '= dataFrame;']);

% Save the dataFrame (with the right 'sl#_w#_data' name) into the .mat file

save([handles.pathname,handles.matname], dataFrameName, '-append');


function outputhandles = plotpictures(handles)

n = handles.n;

%plot previous pictures in prev axes if n>1
if n > 1
    
    if strcmp(handles.FLimstackName,'None')
        prevIm=handles.TLimstack{n-1};
    else
        prevIm = combine2ch(handles.TLimstack{n-1}, handles.FLimstack{n-1});
    end
    
    imshow(prevIm, 'Parent', eval('handles.prev_axes1'));
    
end


%plot current pictures in axes

if strcmp(handles.FLimstackName,'None')
    currIm=handles.TLimstack{n};
else
    
    TLchannel = handles.TLimstack{n};
    FLchannel = handles.FLimstack{n};
    
    if ~get(handles.checkTL, 'Value')
        TLchannel = 0 * TLchannel;
    end
    
    if ~get(handles.checkFL, 'Value')
        FLchannel = 0 * FLchannel;
    end
    
    currIm = combine2ch(TLchannel, FLchannel);
end

imshow(currIm, 'Parent', eval('handles.axes1'));
outputhandles = handles;


% --- Saves inputted data into table
function updateTable(hObject, handles)        

% To make sure all the values in the edittext uicontrols are updated, we
% must first set the focus to another ui component and bring it back. I
% chose the ui component slicenum.

uicontrol(handles.slicenum) %Set focus to another control
uicontrol(hObject)  %Set it back

numtypes = handles.numtypes;

if handles.n <= handles.totalnum
        if handles.stkloaded
            
            % Adds new input value into the Data variable in uitable1, I've
            % also flipped the table data because the table won't scroll to
            % the bottom automatically. Since we want to check the data as
            % we go, it's usful to have the table look like a LIFO stack. 
            
            tabledata = flipud(get(handles.uitable1,'Data'));
            
            %read all inputs at each textbox
            currRow = [handles.n];
            
            handleNames={'handles.NPCnum', 'handles.type1AstrNum', 'handles.type2AstrNum'};
            
            for i=1:numtypes
                handlename = handleNames{i};
                currhandle = eval(handlename);
                currstr = get(currhandle, 'String');
                currnum = str2num(currstr); 
                
                if isempty(currnum) %checks to make sure that the entry is numeric
                    return;
                else
                    currRow = [currRow currnum];
                end
            end
            
            % resets all the handles to 0
            
            for i=1:numtypes
                set(eval(handleNames{i}), 'String', '0'); %set current handle to 0.
            end
            
            % sets the new data into the uitable & updates
            % handles.slicenum, and handles.n
            
            tabledata(handles.n,:) = currRow;
            set(handles.uitable1,'Data', flipud(tabledata));
            handles.n = handles.n + 1;
            set(handles.slicenum, 'String', num2str(handles.n)); %update slice label
            
            % tests to see if the end of the stack has been reached
            
            if handles.n <= handles.totalnum
                
                handles=plotpictures(handles);

            else
                display('No more pictures!');
            end
        else
            display('No Stack Loaded')
            
        end
    else
        display ('No more pictures!')
    end

guidata(hObject, handles);

% --- Executes when selected cell(s) is changed in uitable1.
function uitable1_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

tabledata = get(handles.uitable1,'Data');

if ~isempty(eventdata.Indices) % we need this check because updating the uitable re-triggers this callback, with a null vector in eventdata.Indices. 
    
    slicenum = tabledata(eventdata.Indices(1));
    
    % set handles.n
    
    handles.n = slicenum;
    set(handles.slicenum, 'String', num2str(handles.n));
    
    % display pictures
    
    handles = plotpictures(handles);

end

guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function type1AstrSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type1AstrSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function type2AstrSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type2AstrSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function NPCnum_Callback(hObject, eventdata, handles)
% hObject    handle to NPCnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function NPCnum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NPCnum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function type1AstrNum_Callback(hObject, eventdata, handles)
% hObject    handle to type1AstrNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function type1AstrNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type1AstrNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function type2AstrNum_Callback(hObject, eventdata, handles)
% hObject    handle to type2AstrNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function type2AstrNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type2AstrNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in load_prev.
function load_prev_Callback(hObject, eventdata, handles)
% hObject    handle to load_prev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of load_prev

% --- Executes on selection change in TLstk_select.
function TLstk_select_Callback(hObject, eventdata, handles)
% hObject    handle to TLstk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TLstk_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        TLstk_select

% --- Executes during object creation, after setting all properties.
function TLstk_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TLstk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in FLstk_select.
function FLstk_select_Callback(hObject, eventdata, handles)
% hObject    handle to FLstk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns FLstk_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        FLstk_select

% --- Executes during object creation, after setting all properties.
function FLstk_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FLstk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkTL.
function checkTL_Callback(hObject, eventdata, handles)
% hObject    handle to checkTL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkTL

if handles.stkloaded
    handles = plotpictures(handles);
end

guidata(hObject, handles);

% --- Executes on button press in checkFL.
function checkFL_Callback(hObject, eventdata, handles)
% hObject    handle to checkFL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkFL

if handles.stkloaded
    handles = plotpictures(handles);
end

guidata(hObject, handles);
