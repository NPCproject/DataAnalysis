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

% Last Modified by GUIDE v2.5 28-Mar-2014 11:49:53

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

if (type1AstrIndex==1)&&(type2AstrIndex~=1)
    display('Please move Astrocyte selection to the first popup menu and press Load again');
    handles.numtypes = 0;
    
elseif type1AstrIndex==1
    
    handles.numtypes = 1;
    
elseif type2AstrIndex==1
    
    handles.numtypes = 2;
    
else
    
    handles.numtypes = 3;
    
end

% Load previous data if necessary

if get(handles.load_prev, 'Value')
    
    load([handles.pathname, handles.matname]); % reload data mat file
    dataFrame = eval(makeDataFrameName(TLimstackName));
    loadTableData(dataFrame, hObject, handles);
    handles = guidata(hObject); %retrieve data from loadTableData
    
    % set currIm first: 
    
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

function loadTableData(dataFrame, hObject, handles)
% dataFrame structure with data for the slide and well. sl#_w#_data
% handles structure with handles and user data (see GUIDATA)

% First, figure out how many cell types we are working with

numtypes = handles.numtypes;

% Pull out the relevant data vectors out of the data structure
if numtypes==0
    error(['Number of cell types not set'])
end

if numtypes>=1
    
    NPCData = dataFrame.numNPCs_d0;
    
    if isscalar(NPCData) % i.e. if no data has been entered yet
        tabledata=[];
        set(handles.uitable1,'Data',tabledata);
    else
        tabledata = NPCData'; % NPC data is horizontal vector
        set(handles.uitable1,'Data', flipud(tabledata));
    end

end

if numtypes>=2
    
    type1Index = handles.AstrIndices{1};
    type1AstrName = handles.AstrNameList{type1Index};
    d0type1AstrDataName = ['num' type1AstrName '_d0'];
    d0type1AstrData = getfield(dataFrame, d0type1AstrDataName);
    
    if isscalar(d0type1AstrData) || ~isequal(size(NPCData), size(d0type1AstrData))
        tabledata=[];
        set(handles.uitable1, 'Data', tabledata);
    else
        tabledata = [tabledata d0type1AstrData']; %append d0type1AstrData to tabledata
        set(handles.uitable1,'Data', flipud(tabledata));
    end
end

if numtypes>=3
    
    type2Index = handles.AstrIndices{2};
    type2AstrName = handles.AstrNameList{type2Index};
    d0type2AstrDataName = ['num' type2AstrName '_d0'];
    d0type2AstrData = getfield(dataFrame, d0type2AstrDataName);
    
    if isscalar(d0type2AstrData) || ~isequal(size(NPCData), size(d0type1AstrData), size(d0type2AstrData))
        tabledata=[];
        set(handles.uitable1,'Data',tabledata);
    else
        tabledata = [tabledata d0type2AstrData']; %append d0type2AstrData to tabledata
        set(handles.uitable1,'Data', flipud(tabledata));
    end
end

% set n = size of data
n = size(tabledata,1)+1;
handles.n = n;
  
% set slice number indicator
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

% First, figure out how many cell types we are working with

numtypes = handles.numtypes;

% Parse the matlab table data into different vectors & save into sl#_w#
% data structure

dataFrameName = makeDataFrameName(handles.TLimstackName);
load([handles.pathname, handles.matname], dataFrameName);

switch numtypes
    case 1    
        
        tabledata = flipud(get(handles.uitable1, 'Data'));
        tabledata = tabledata';
        
        % Save this data to NPCData field in data variable in .mat file.
        
        eval([dataFrameName '.numNPCs_d0 = tabledata']);
        save([handles.pathname, handles.matname], dataFrameName, '-append');
        
    case 2
        
        tabledata = flipud(get(handles.uitable1, 'Data'));
        tabledata = tabledata';
        
        type1AstrName = handles.AstrNames{1};
        type1AstrName_d0 = ['num' type1AstrName '_d0'];
        
        eval([dataFrameName '.numNPCs_d0 = tabledata(1,:)']);
        eval([dataFrameName '.' type1AstrName_d0 '=tabledata(2,:)']);
        
    case 3
        
        tabledata = flipud(get(handles.uitable1, 'Data'));
        tabledata = tabledata';
        
        type1AstrName = handles.AstrNames{1};
        type1AstrName_d0 = ['num' type1AstrName '_d0'];
        type2AstrName = handles.AstrNames{2};
        type2AstrName_d0 = ['num' type1AstrName '_d0'];
        
        eval([dataFrameName '.numNPCs_d0 = tabledata(1,:)']);
        eval([dataFrameName '.' type1AstrName_d0 '=tabledata(2,:)']);
        eval([dataFrameName '.' type2AstrName_d0 '=tabledata(3,:)']);
        
        
    otherwise
        
        error(['Number of cell types not set'])
end

save([handles.pathname,handles.matname], dataFrameName, '-append');

% Save the sl#_w#_data structure into the .mat file


function outputhandles=plotpictures(handles)

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
    currIm = combine2ch(handles.TLimstack{n}, handles.FLimstack{n});
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
            
            tabledata = get(handles.uitable1,'Data');
            
            %read all inputs at each textbox
            allrows = [];
            
            handleNames={'handles.NPCnum', 'handles.type1AstrNum', 'handles.type2AstrNum'};
            
            for i=1:numtypes
                handlename = handleNames{i};
                currhandle = eval(handlename);
                currstr = get(currhandle, 'String');
                currnum = str2num(currstr);
                allrows = [allrows currnum];
                set(currhandle, 'String', '0'); %set current handle to 0.
            end
            
            tabledata = [flipud(tabledata); allrows];
            set(handles.uitable1,'Data', flipud(tabledata));
            
            handles.n = handles.n + 1;
            set(handles.slicenum, 'String', num2str(handles.n)); %update slice label
            
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
