Layout = {}
Layout.padding = 0
Layout.gpu = nil
function Layout:new(position, size, mode, margin) 
    e = {}
    mode = mode or "horizontal"
    setmetatable(e, self)
    self.__index = self
    e.mode = mode
    e.position = position
    if (size ~= nil) then
       e.size = size
    else
    	e.size = {x=0,y=0}
    end
    e.position = position
    e.elements = {}
    e.layouts = {}
    e.fixedWidth = nil
    e.fixedHeight = nil
    e.margin = margin or 0
    return e
end

function Layout:setFixedWidth(width)
    if (self.mode == "horizontal") then
        self.fixedWidth = width
        self.size = {x = width, y = self.size.y}
        self:SetSize()
        self:AlignElement()
    else
    	error("You cant fixed width of a vertical layout.")
    end
end

function Layout:setFixedHeight(height)
    if (self.mode == "vertical") then
        self.fixedHeight = height
        self.size = {x = self.size.x, y = height}
        self:SetSize()
        self:AlignElement()
    else
    	error("You cant fixed height of a horizontal layout.")
    end
end

function Layout:Draw(gpu)
    for k,v in pairs(self.elements) do
        v:Draw(gpu)
    end

    for k,v in pairs(self.layouts) do 
		v:Draw(gpu)
    end
end

function Layout:AlignElement()
    local len = #self.elements + #self.layouts
    local maxElementSizeX = self.size.x / len
    local maxElementSizeY = self.size.y / len
    local currentTakenWidth = 0
    for index, element in pairs(self.elements) do

        local l_X = self.position.x
    	local l_Y = self.position.y
        if (self.mode == "horizontal") then
            l_X = self.position.x + (index -1) * maxElementSizeX 
            if (self.valign == "middle") then
                l_Y = ((self.position.y + self.size.y) / 2) - (element.size.y / 2)
            end

            if (self.valign == "top") then
                l_Y = self.position.y
            end

            if (self.valign == "bottom") then
                l_Y = (self.position.y + self.size.y) - element.size.y
            end
        end
        if (self.mode == "vertical") then
            l_Y = self.position.y + (index -1) * maxElementSizeY

            if (self.align == "center") then
                l_X = ((self.position.x + self.size.x) / 2) - (element.size.x / 2)
            end

            if (self.align == "left") then
                l_X = self.position.x
            end

            if (self.align == "right") then
                l_X = (self.position.x + self.position.size) - element.size.x
            end
        end
		l_X = l_X + self.margin
		l_Y = l_Y + self.margin
		element.position = {x = l_X, y = l_Y}

    end
    
    for index, layout in pairs(self.layouts) do
        local l_X = 0
    	local l_Y = 0

        if (self.mode == "horizontal") then
            l_X = self.position.x + (index - 1 + #self.elements) * maxElementSizeX 
        end
        if (self.mode == "vertical") then
            l_Y = self.position.y + (index -1 + #self.elements) * maxElementSizeY
        end
		l_X = l_X + self.margin
		l_Y = l_Y + self.margin
		layout.position = {x = l_X, y = l_Y}
		layout:AlignElement()
		
    end
end

function Layout:SetSize() 
    local len = #self.elements + #self.layouts
    for index, element in pairs(self.elements) do 
        if (element.autoresize == false) then  goto continue  end
        
        if (self.mode == "horizontal") then
            local l_x = (self.size.x / len) - 2*self.margin
        	local l_y = self.size.y - 2*self.margin
        	element.size = {x = l_x, y = l_y}
        else
        	local l_x = self.size.x- 2*self.margin
        	local l_y = self.size.y / len- 2*self.margin
            element.size = {x = l_x, y = l_y}
        end

        if (element.fixedHeight ~= nil) then
            element.size.y = element.fixedHeight
        end

        if (element.fixedWidth ~= nil) then
            element.size.x = element.fixedWidth
        end
        ::continue::
    end
    
    for index, layout in pairs(self.layouts) do 
        local l_x = 0
        local l_y = 0
        if (self.mode == "horizontal") then
            if (layout.fixedWidth == nil) then
                l_x = (self.size.x / len) - 2*self.margin
                l_y = self.size.y - 2*self.margin
            else
                l_x = self.size.x - 2*self.margin
                l_y = self.size.y - 2*self.margin
            end
        else
            if (layout.fixedHeight == nil) then
                l_x = self.size.x- 2*self.margin
                l_y = self.size.y / len- 2*self.margin
            else
                l_x = self.size.x - 2*self.margin
                l_y = self.size.y - 2*self.margin
            end
        end
        layout.size = {x = l_x, y = l_y}
    end
end

function Layout:AddElement(element)
    table.insert(self.elements, element)
    self:SetSize()
    self:AlignElement()
end

function Layout:AddLayout(element)
    table.insert(self.layouts, element)
    local len = #self.layouts

    -- Recalculate every element size
    for index, layout in pairs(self.layouts) do 
    	layout:SetSize()
    end
    self:SetSize()
    self:AlignElement()
end
