
GUI = {}
GUI.gpu = nil
GUI.screen = nil
GUI.screenSize = {}
GUI.layout = nil
GUI.drawable = {}
GUI.mediaSubSystem = nil

function GUI:New()
	c = {}
    -- get first T1 GPU avialable from PCI-Interface
    c.gpu = computer.getPCIDevices(classes.GPUT1)[1]
    if not c.gpu then
        c.gpu = computer.getPCIDevices(classes.BUILD_GPU_T2_C)[1]
        if not c.gpu then 
            error("No GPU T1 or T2 found!")
        end
    end

    -- if no screen found, try to find large screen from component network
    local comp = component.findComponent(classes.Screen)[1]
    c.mediaSubSystem = computer.media
    if not comp then
        error("No Screen found!")
    else
        c.screen = component.proxy(comp)
    end

    c.gpu:bindScreen(c.screen)
    c.layout = Layout:new({x = 0, y = 0}, c.gpu:getScreenSize(), "horizontal", 10)
    c.screenSize = c.gpu:getScreenSize()
    setmetatable(c, self)
    self.__index = self
	return c
end


function GUI:drawBox(position, color, radius, margin, size) 
    size = size or "auto"
    radius = radius or 10
    margin = margin or 5
	outerMargins = outerMargins or 5
	if (type(outerMargins) == "number") then 
		outerMargins = {x = outerMargins, y = outerMargins}	
	end	
	position = {position.x + outerMargins.x, position.y + outerMargins.y}	
    return Box:New(position, size, color, margin, padding, true, radius, true)
end


function GUI:Draw()    
    for k,v in pairs(self.drawable) do
        v:Draw(self.gpu)
    end
    
    self.layout:Draw(self.gpu)

    self.gpu:flush()
end