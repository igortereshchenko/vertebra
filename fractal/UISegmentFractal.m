function UISegmentFractal

global f       
global hImage  
global hNoEdges
global hWindows
global hThreshold
global hEstimated


f = figure('Position', [100 100 340 250]);


uicontrol(f, ...
  'Style', 'text', ... 
  'String',' Calculation of local fractal dimensions', ...
  'HorizontalAlignmen', 'center', ...
  'Position', [50 220 230 18]);


uicontrol(f, ...
  'Style', 'text', ... 
  'String',' Image : ', ...
  'HorizontalAlignmen', 'left', ...
  'Position', [15 170 50 18]);


hImage = uicontrol(f, ...   
  'Style', 'edit', ... 
  'String', '', ...
  'HorizontalAlignmen', 'left', ...
  'Position', [80 170 150 20]);  

uicontrol(f, ...  
  'Style', 'pushbutton', ... 
  'String', 'Browse', ... 
  'Position', [240 170 80 20], ... 
  'Callback', 'getFileSF');  

uicontrol(f, ...
  'Style', 'text', ... 
  'String',' No Edge : ', ...
  'HorizontalAlignmen', 'left', ...
  'Position', [15 145 100 18]);

hNoEdges = uicontrol(f, ...   
  'Style', 'edit', ... 
  'String', '40', ...       
  'HorizontalAlignmen', 'left', ...
  'Position', [130 145 50 18]);  
  

hWindows = uicontrol(f, ...   
  'Style', 'checkbox', ... 
  'String', 'Display windows', ...
  'HorizontalAlignmen', 'left', ...
  'Position', [15 120 125 18]);  
  
 uicontrol(f, ...
  'Style', 'text', ... 
  'String',' Threshold size: ', ...
  'HorizontalAlignmen', 'left', ...
  'Position', [150 120 115 18]);

hThreshold = uicontrol(f, ...   
  'Style', 'edit', ... 
  'String', '1.2', ...
  'HorizontalAlignmen', 'left', ...
  'Position', [275 120 35 18]);  


hEstimated = uicontrol(f, ...   
  'Style', 'checkbox', ... 
  'String', ' Estimation algorithm only', ...
  'HorizontalAlignmen', 'left', ...
  'Position', [15 95 300 18]);  
  

uicontrol(f, ...   
  'Style', 'pushbutton', ... 
  'String', 'Start Calculation', ... 
  'Position', [60 40 90 25], ... 
  'Callback', 'go_segmentImage');  


uicontrol(f, ...   
  'Style', 'pushbutton', ... 
  'String', 'Exit', ... 
  'Position', [160 40 90 25],... 
  'Callback', 'close_interface');  



