Drawable = {}
Drawable.position = nil
Drawable.size = nil
Drawable.color = nil
Drawable.margin = nil
Drawable.padding = nil
Drawable.isRounded = nil
Drawable.type = ""
Drawable.fixedHeight = nil
Drawable.fixedWidth = nil
Drawable.autoResize = nil

function Drawable:New(position, size, color, margin, padding, autoresize)
	d = {}
    margin = margin or {w = 0, x = 0, y = 0, z = 0}
    padding = padding or {w = 0, x = 0, y = 0, z = 0}
    autoresize = autoresize or false
    
    d.margin = margin
    d.padding = padding
    d.position = position
    d.size = size
    d.color = color
    d.autoresize = autoresize
    self.__index = self
    setmetatable(d, self)
	return d
end

ProgressBar = Drawable:New({x=0,y=0}, {x=0,y=0}, {0,0,0,0}, 0, 0, 0, true)
ProgressBar.progress = 0
ProgressBar.fontSize = 0
ProgressBar.monoSpace = true
ProgressBar.textColor = {0,0,0,1}
ProgressBar.progressColor = {1,1,1,1}
ProgressBar.layout = nil
ProgressBar.text = ""
function ProgressBar:New(position, size, color, margin, padding, autoresize, text, textColor, progressColor, progress)
    g = Drawable:New(position, size, color, margin, padding, autoresize)
    g.progress = progress or 0
    g.fontSize = 30
    g.monoSpace = true
    g.textColor = textColor
    g.progressColor = progressColor
    g.fixedHeight = 100
    g.text = text
    g.layout = Layout:new({x=self.position.x + 40, y = self.position.y + 120}, {x=self.size.x, y=self.size.y - 120}, "vertical", 30) 

    self.__index = self
    setmetatable(g, self)
    return g
end

function ProgressBar:Draw(gpu)
    drawBox = {}
    drawBox.color = self.color
    drawBox.hasCenteredOrigin = false
    drawBox.isRounded = true
    drawBox.position = {x = self.position.x, y = self.position.y + 80}
    drawBox.radii = {w = 50, x =50, y = 50, z = 50}
    drawBox.size = self.size
    gpu:drawBox(drawBox)

    drawBox = {}
    drawBox.color = self.progressColor
    drawBox.hasCenteredOrigin = false
    drawBox.isRounded = true
    drawBox.position = {x = self.position.x, y = self.position.y + 80}
    drawBox.radii = {w = 50, x =50, y = 50, z = 50}
    drawBox.size = {x = self.size.x * self.progress, y = self.size.y}
    gpu:drawBox(drawBox) 

    local progress = math.floor(self.progress * 100)
    gpu:drawText({x = self.position.x + 30, y = self.position.y}, self.text, self.fontSize, self.textColor, self.monoSpace)
    gpu:drawText({x = self.position.x + 60, y = self.position.y + 110}, progress.."%", self.fontSize, {0,0,0,1}, self.monoSpace)
end

Text = Drawable:New({x=0,y=0}, {x=0,y=0}, {0,0,0,0}, 0, 0, 0, true)
Text.content = ""
Text.fontSize = 0
Text.monoSpace = true
function Text:New(position, size, color, margin, padding, autoresize, content, fontSize, monoSpace)
    f = Drawable:New(position, size, color, margin, padding, autoresize)
    f.content = content
    f.fontSize = fontSize
    f.monoSpace = monoSpace
    self.__index = self
    setmetatable(f, self)
    return f
end

function Text:Draw(gpu)
    gpu:drawText(self.position, self.content, self.fontSize, self.color, self.monoSpace)
end


Box = Drawable:New({x=0,y=0}, {x=0,y=0}, {0,0,0,0}, 0, 0, 0, true)
Box.radius = 0
Box.isRounded = false
function Box:New(position, size, color, margin, padding, autoresize, radius, isRounded) 
    a = Drawable:New(position, size, color, margin, padding, autoresize)
    a.radius = radius or 0
    a.isRounded = isRounded or false
    self.__index = self
    setmetatable(a, self)
    return a
end

function Box:Draw(gpu) 
    drawBox = {}
    drawBox.color = self.color
    drawBox.hasCenteredOrigin = false
    drawBox.isRounded = self.isRounded
    drawBox.position = self.position
    drawBox.radii = {w = self.radius, x = self.radius, y = self.radius, z = self.radius}
    drawBox.size = self.size
    gpu:drawBox(drawBox)
end

InfoBox = Box:New({x=0,y=0}, {x=0,y=0}, {0,0,0,0}, 0, 0, 0, true, 20, true)
InfoBox.type ="info"
InfoBox.title = ""
InfoBox.icon = "info.png"
InfoBox.content = ""
InfoBox.titleBgColor = nil
InfoBox.layout = nil
InfoBox.titleColor = nil

function InfoBox:New(position, size, type, title, content)
    local color = Colors.Info
    local icon = "info.png"
    local titleBgColor = Colors.InfoBack
    local titleColor = Colors.White

    if (type == "warning") then
        icon = "warning.png"
        color = Colors.Warning
        titleBgColor = Colors.WarningBack
    end

    if (type == "danger") then
        icon = "danger.png"
        color = Colors.Danger
        titleBgColor = Colors.DangerBack
    end

    if (type == "panel") then
        icon = ""
        color = Colors.Panel
        titleBgColor = Colors.PanelBack
        titleColor = Colors.Black
    end

    b = Box:New(position, size, color, 10, 10, true, 20, true)
    b.type = type
    b.icon = icon
    b.title = title
    b.color = color
    b.titleBgColor = titleBgColor
    b.titleColor = titleColor
    b.content = content
    -- The minus on Y size is due to title
    b.layout = Layout:new({x=self.position.x + 40, y = self.position.y + 120}, {x=self.size.x, y=self.size.y - 120}, "horizontal", 30) 
    self.__index = self
    setmetatable(b, self) 

    return b
end 

function InfoBox:AddLayoutToContent(layout)
    b.layout:AddLayout(layout)
end

function InfoBox:AddElementToContent(element)
    b.layout:AddElement(element)
end

function InfoBox:Draw(gpu)

    drawBox = {}
    drawBox.color = self.color
    drawBox.hasCenteredOrigin = false
    drawBox.isRounded = self.isRounded
    drawBox.position = self.position
    drawBox.radii = {w = self.radius, x = self.radius, y = self.radius, z = self.radius}
    drawBox.size = self.size
    gpu:drawBox(drawBox)

    local titleSize = gpu:measureText(self.title, 20, true)
    drawBox = {}
    drawBox.color = self.titleBgColor
    drawBox.hasCenteredOrigin = false
    drawBox.isRounded = self.isRounded
    drawBox.radii = {w = self.radius, x = self.radius, y = self.radius, z = self.radius}
    drawBox.position = {x=self.position.x + 15, self.position.y + 15}
    drawBox.size = {x= self.size.x - 60, y = titleSize.y + 40}
    gpu:drawBox(drawBox)

    gpu:drawText({x=self.position.x + 100, y = self.position.y + 37}, self.title, 20, self.titleColor, true)
    if (self.icon ~= "") then
        gpu:drawRect({x=self.position.x + 25, y = self.position.y + 20}, {64,64}, {1,1,1,1}, "file:/"..self.icon, 0)
    end

    -- Refresh the position before drawing.
    self.layout.position = {x=self.position.x + 40, y = self.position.y + 120}
    self.layout.size = {x=self.size.x - 60, y=self.size.y - 120}
    if (self.content ~= "") then
        self.layout:AddElement(Text:New({x=0, y=0}, {x=0, y=0}, {0,0,0,1}, 0, 0, true, self.content, 20, true))
    end
    self.layout:SetSize()
    self.layout:AlignElement()
    self.layout:Draw(gpu)

end