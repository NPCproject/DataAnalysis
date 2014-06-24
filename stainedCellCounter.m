function varargout = stainedCellCounter(varargin)
% STAINEDCELLCOUNTER M-file for stainedCellCounter.fig
%      
%   This simple program allows the user to quickly input the number of
%   cells at each slice in a stack, which is shown iteratively to the user
%   until the end of the stack is reached. Once the end of the stack has
%   been reached, the data should be saved using the save button. 
%
%
%      STAINEDCELLCOUNTER, by itself, creates a new STAINEDCELLCOUNTER or raises the existing
%      singleton*.
%
%      H = STAINEDCELLCOUNTER returns the handle to a new STAINEDCELLCOUNTER or the handle to
%      the existing singleton*.
%
%      STAINEDCELLCOUNTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STAINEDCELLCOUNTER.M with the given input arguments.
%
%      STAINEDCELLCOUNTER('Property','Value',...) creates a new STAINEDCELLCOUNTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before stainedCellCounter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to stainedCellCounter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help stainedCellCounter

% Last Modified by GUIDE v2.5 23-Jun-2014 21:14:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @stainedCellCounter_OpeningFcn, ...
                   'gui_OutputFcn',  @stainedCellCounter_OutputFcn, ...
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

% --- Executes just before stainedCellCounter is made visible.
function stainedCellCounter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to stainedCellCounter (see VARARGIN)

% Choose default command line output for stainedCellCounter
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

% UIWAIT makes stainedCellCounter wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = stainedCellCounter_OutputFcn(hObject, eventdata, handles) 
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

[stksname, pathname, filterindex] = uigetfile('.mat', 'Please select .mat file that contains d6 stained cell data', 'MultiSelect', 'Off');
handles.stksname = stksname; 
handles.pathname = pathname;
handles.matname = makeMatName(stksname);

% Once a new mat file has been selected, the number of cell types is set to
% 0, so that the pop-up menus for type 1 and type 2 astrocytes are
% selectable again. 

handles.numtypes = 0;

% List d0 data variables in local environment. Using reexp, find all
% variables that are of the form d0.*_stk

S = whos('-file', [pathname, stksname], '-regexp', 'd[5-7].*_stk');
d6stks = {S.name};

set(handles.RedStk_select, 'String', d6stks);
set(handles.GreenStk_select, 'String', d6stks);
set(handles.BlueStk_select, 'String', d6stks);
set(handles.TxRedStk_select, 'String', d6stks);
set(handles.YFPStk_select, 'String', d6stks);

guidata(hObject, handles);

% --- Executes on button press in Open.
function Open_Callback(hObject, eventdata, handles)
% hObject    handle to Open (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load current stks into handles.Rimstack, handles.Gimstack,
% handles.Bimstack, and handles.RimstackName, handles.Gimstckname,
% handles.BimstackName

load([handles.pathname, handles.stksname]);

Rindex = get(handles.RedStk_select, 'Value');
Rimstacks = get(handles.RedStk_select, 'String');
RimstackName = Rimstacks{Rindex};
handles.Rimstack = eval(RimstackName);
handles.RimstackName = RimstackName;

Gindex = get(handles.GreenStk_select, 'Value');
Gimstacks = get(handles.GreenStk_select, 'String');
GimstackName = Gimstacks{Gindex};
handles.Gimstack = eval(GimstackName);
handles.GimstackName = GimstackName;

Bindex = get(handles.BlueStk_select, 'Value');
Bimstacks = get(handles.BlueStk_select, 'String');
BimstackName = Bimstacks{Bindex};
handles.Bimstack = eval(BimstackName);
handles.BimstackName = BimstackName;

TRindex = get(handles.TxRedStk_select, 'Value');
TRimstacks = get(handles.TxRedStk_select, 'String');
TRimstackName = TRimstacks{TRindex};
handles.TRimstack = eval(TRimstackName);
handles.TRimstackName = TRimstackName;

YFPindex = get(handles.YFPStk_select, 'Value');
YFPimstacks = get(handles.YFPStk_select, 'String');
YFPimstackName = Rimstacks{YFPindex};
handles.YFPimstack = eval(YFPimstackName);
handles.YFPimstackName = YFPimstackName;

% initializes variables in handles structure 
handles.totalnum = size(handles.Rimstack, 1);

type1AstrIndex = get(handles.type1AstrSelect, 'Value');
type1AstrName = handles.AstrNameList{type1AstrIndex};
type2AstrIndex = get(handles.type2AstrSelect, 'Value');
type2AstrName = handles.AstrNameList{type2AstrIndex};
handles.AstrNames={type1AstrName, type2AstrName};
handles.AstrIndices={type1AstrIndex, type2AstrIndex};

% Assume that the list of options has not changed: 
% {'None', 'CortA', 'Delta CortA', 'Efn CortA', 'Wnt CortA'}

if (type1AstrIndex==1)&&(type2AstrIndex~=1)
    display('Please move Astrocyte selection to the first popup menu and press Load again');
    handles.numtypes = 0;
    
elseif type1AstrIndex==1
    
    handles.numtypes = 4;
    handles.fieldsList = {'numTuj1_d6', 'numGFAP_d6', 'numDbl_d6', 'numUnst_d6'};
    
elseif type2AstrIndex==1
    
    handles.numtypes = 5;
    handles.fieldsList = {'numTuj1_d6', 'numGFAP_d6', 'numDbl_d6', 'numUnst_d6', ['num' type1AstrName '_d6']};
    
else
    
    handles.numtypes = 6;
    handles.fieldsList = {'numTuj1_d6', 'numGFAP_d6', 'numDbl_d6', 'numUnst_d6', ['num' type1AstrName '_d6'], ['num' type2AstrName '_d6']};
    
end

% Load corresponding dataFrame and save in handles object

load([handles.pathname, handles.matname]);
dataFrameName = makeDataFrameName(handles.RimstackName);
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

% --- Executes on key press with focus on Tuj1Num and none of its controls.
function Tuj1Num_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to Tuj1Num (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on UnstNum and none of its controls.
function UnstNum_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to UnstNum (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if (handles.numtypes==4)&&(strcmp(eventdata.Key,'return'))
    updateTable(hObject, handles);
    set(handles.type2AstrNum, 'String', '');
    uicontrol(handles.Tuj1Num);
end


% --- Executes on key press with focus on type1AstrNum and none of its controls.
function type1AstrNum_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to type1AstrNum (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

if (handles.numtypes==5)&&(strcmp(eventdata.Key,'return'))    
    updateTable(hObject, handles);
    set(handles.type2AstrNum, 'String', '');
    uicontrol(handles.Tuj1Num);
end

% --- Executes on key press with focus on type2AstrNum and none of its controls.
function type2AstrNum_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to type2AstrNum (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


if (handles.numtypes==6)&&(strcmp(eventdata.Key,'return'))
    updateTable(hObject, handles);
    set(handles.type2AstrNum, 'String', '');
    uicontrol(handles.Tuj1Num);
end


% --- Executes on button press in checkRed.
function checkRed_Callback(hObject, eventdata, handles)
% hObject    handle to checkRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currStatus = get(hObject, 'Value');

if currStatus

    set(handles.checkTxRed, 'Value', 0);
end

if handles.stkloaded
    handles = plotpictures(handles);
end
guidata(hObject, handles);


% --- Executes on button press in checkGreen.
function checkGreen_Callback(hObject, eventdata, handles)
% hObject    handle to checkGreen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currStatus = get(hObject, 'Value');

if currStatus

    set(handles.checkYFP, 'Value', 0);
end

if handles.stkloaded
    handles = plotpictures(handles);
end
guidata(hObject, handles);


% --- Executes on button press in checkBlue.
function checkBlue_Callback(hObject, eventdata, handles)
% hObject    handle to checkBlue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.stkloaded
    handles = plotpictures(handles);
end
guidata(hObject, handles);


% --- Executes on button press in checkTxRed.
function checkTxRed_Callback(hObject, eventdata, handles)
% hObject    handle to checkTxRed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currStatus = get(hObject, 'Value');

if currStatus

    set(handles.checkRed, 'Value', 0);
end

if handles.stkloaded
    handles = plotpictures(handles);
end
guidata(hObject, handles);

% --- Executes on button press in checkYFP.
function checkYFP_Callback(hObject, eventdata, handles)
% hObject    handle to checkYFP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

currStatus = get(hObject, 'Value');

if currStatus

    set(handles.checkGreen, 'Value', 0);

end

if handles.stkloaded
    handles = plotpictures(handles);
end
guidata(hObject, handles);


% --- Sets data frame data into uitable

function loadTableData(hObject, handles)
% dataFrame structure with data for the slide and well. sl#_w#_data
% handles structure with handles and user data (see GUIDATA)

% First, figure out how many cell types we are working with

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
   set(handles.slicenum, 'String', num2str(n));
   
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

dataFrameName = makeDataFrameName(handles.RimstackName);

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


function handles = plotpictures(handles)

n = handles.n;

% plot previous pictures in prev axes if n>1
if n > 1
    
    prevRGBim = cat(3, handles.Rimstack{n-1}, handles.Gimstack{n-1}, handles.Bimstack{n-1});
    imshow(prevRGBim, 'Parent', handles.prev_axes1);

end

% Set all three channels depending on statuses of checkboxes

if get(handles.checkRed, 'Value')
    Rchannel = handles.Rimstack{n};
elseif get(handles.checkTxRed, 'Value')
    Rchannel = handles.TRimstack{n};
else
    Rchannel = 0 * handles.Rimstack{n};
end


if get(handles.checkGreen, 'Value')
    Gchannel = handles.Gimstack{n};
elseif get(handles.checkYFP, 'Value')
    Gchannel = handles.YFPimstack{n};
else
    Gchannel = 0 * handles.Gimstack{n};
end


if get(handles.checkBlue, 'Value')
    Bchannel = handles.Bimstack{n};
else
    Bchannel = 0 * Bchannel;
end


% plot current pictures in axes

currRGBim = cat(3, Rchannel, Gchannel, Bchannel);
imshow(currRGBim, 'Parent', handles.axes1);


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
            currRow = [handles.n]; %start with slice number
            
            handleNames={'handles.Tuj1Num', 'handles.GFAPNum', 'handles.DblNum', 'handles.UnstNum', 'handles.type1AstrNum', 'handles.type2AstrNum'};
            
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
                
                handles = plotpictures(handles);
                
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

function Tuj1Num_Callback(hObject, eventdata, handles)
% hObject    handle to Tuj1NumDisp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function Tuj1NumDisp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Tuj1NumDisp (see GCBO)
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

% --- Executes on selection change in RedStk_select.
function RedStk_select_Callback(hObject, eventdata, handles)
% hObject    handle to RedStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns RedStk_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        RedStk_select

% --- Executes during object creation, after setting all properties.
function RedStk_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RedStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function GFAPNum_Callback(hObject, eventdata, handles)
% hObject    handle to GFAPNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GFAPNum as text
%        str2double(get(hObject,'String')) returns contents of GFAPNum as a double


% --- Executes during object creation, after setting all properties.
function GFAPNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GFAPNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DblNum_Callback(hObject, eventdata, handles)
% hObject    handle to DblNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DblNum as text
%        str2double(get(hObject,'String')) returns contents of DblNum as a double


% --- Executes during object creation, after setting all properties.
function DblNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DblNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function UnstNum_Callback(hObject, eventdata, handles)
% hObject    handle to UnstNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of UnstNum as text
%        str2double(get(hObject,'String')) returns contents of UnstNum as a double


% --- Executes during object creation, after setting all properties.
function UnstNum_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UnstNum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Tuj1Num_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tuj1num (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in GreenStk_select.
function GreenStk_select_Callback(hObject, eventdata, handles)
% hObject    handle to GreenStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GreenStk_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GreenStk_select


% --- Executes during object creation, after setting all properties.
function GreenStk_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GreenStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BlueStk_select.
function BlueStk_select_Callback(hObject, eventdata, handles)
% hObject    handle to BlueStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BlueStk_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BlueStk_select


% --- Executes during object creation, after setting all properties.
function BlueStk_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BlueStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in TxRedStk_select.
function TxRedStk_select_Callback(hObject, eventdata, handles)
% hObject    handle to TxRedStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TxRedStk_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TxRedStk_select


% --- Executes during object creation, after setting all properties.
function TxRedStk_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TxRedStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in YFPStk_select.
function YFPStk_select_Callback(hObject, eventdata, handles)
% hObject    handle to YFPStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns YFPStk_select contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YFPStk_select


% --- Executes during object creation, after setting all properties.
function YFPStk_select_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YFPStk_select (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
