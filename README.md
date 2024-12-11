# FIN_GUI
This project is a GUI Kit for FIN Satisfactory mod written in Lua. It is still in an experimental phase and can contains bugs and some other monstruosity which will be fixed over time :)
The big idea is to implement layouting and most common controls for people to user freely. 

# Get Started
Clone this repository, and copy those files on a hard disk you have on your computer. If you need to find your harddisk UUID, you can use this code : 
```lua
fs = filesystem;
fs.initFileSystem("/dev");
for k,v in pairs(fs.children("/dev")) do
	print(v)
end
```

Get the ID of your disk, you'll be using it one time to mount the disk on your filesystem : 
```lua
fs.mount("/dev/{DISK_ID}/","/")
fs.doFile("/Colors.lua")
fs.doFile("/Constructor.lua")
fs.doFile("/GUI.lua")
fs.doFile("/Drawable.lua")
fs.doFile("/Layout.lua")
```

And that's pretty much it, you now have access to the whole library.


### How to use
Right now, the system is based upon 3 main components :
* GUI : The component using the FIN GPU to render things. Nothing really complicated here, just some abstraction to get screeens, GPU, MediaSubSystem and so on.
* Layout : This one is a bit trickier and needs to be reworked. The layout is a invisible component which holds either a layout, or a drawable. Its job consists to resize and position every elements according to its settings (horizontal, vertical, width, height...)
* Drawable : Represents every component we can draw on the screen. Right now, ProgressBar, InfoBox, and Box are the only one availables.

#### Notes
All the code I produce usually uses a convention used on Unity some time ago, to differentiate local and parameters from class variables : 
* l_ : is a local variable
* p_ : is a parameter
There sole purpose is to let me reuse the same variable names without confusing there provenance.

This one code will get you started
```lua
-- Create the GUI object, it will fetch the GPU (T1 or T2) and the screen. It will spill and error if it can't find anything.
local l_gui = GUI:New()

-- The GUI contains a default layout, horizontal with the screens size.
-- Setting the size of this layout to nil, it will be recalculated as soon as it is inside another element with a known size.
l_verticalLayout = Layout:new({x=0,y=0}, nil, "vertical", 5)
-- /!\ At the moment, there is some limitations due to the size calculations. We have to add the layout before anything else, or the elements we add will be calculated with a size of 0, since this layout doesn't have a size yet.
l_gui.layout:AddLayout(l_layout)
l_layout:AddElement(InfoBox:New({x=0,y=0}, {x=0,y=0}, "info", "Here is some info !", "And some content you can put with it :)"))
l_layout:AddElement(InfoBox:New({x=0,y=0}, {x=0,y=0}, "warning", "Here is some info !", "And some content you can put with it :)"))
l_layout:AddElement(InfoBox:New({x=0,y=0}, {x=0,y=0}, "danger", "Here is some info !", "And some content you can put with it :)"))
l_gui:Draw()
```

This code should get you a screen with 3 boxes, info, warning and danger. 
Here is another example with the progress bar : 
```lua
local l_gui = GUI:New()

-- This one is a bit trickier, we'll create a box first, and add it to the main layout of the GUI :
l_mainPanel = InfoBox:New(
	{x=0,y=0}, {x=100,y=100}, "panel", 
	"Some main panel", "")
l_gui.layout:AddElement(l_mainPanel)
-- Then, we'll use our InfoBox content layout, and add any element you'd like to it, progressBar for this example.
l_mainPanel.layout:AddElement(ProgressBar:New(
		{0,0}, {0,0}, Colors.Info, 0, 0, true, 
		"A progress Bar", Colors.Black, Colors.InfoBack, 
		l_constructor.Progress
	))

-- Drawing do the trick here, cause the mainPanel is contained inside the main GUI Layout. Some the GUI can recalculate everyone from top to bottom
l_gui:Draw()
```

To get the progress bar going, you would need to loop over the events, and update your progress accordingly, then draw again. 

# Limitations
Right now, there is a big limitation : scale isn't something we use in our calculations. As a result, small screen would get very big progress bar/title etc... and big screen would be really small. All fixed elements height needs to be scaled accordingly. This is the next project with a big refactor of the project :)
