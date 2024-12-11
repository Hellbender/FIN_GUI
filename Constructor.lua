Constructor = {}
Constructor.recipe = nil
Constructor.ingredients = nil
Constructor.machine = nil
Constructor.products = nil
Constructor.prodPerMin = {}
Constructor.consumePerMin = {}
function Constructor:New(p_Machine)
	c = {}
	c.machine = p_Machine
	c.recipe = c.machine:getRecipe()
	c.ingredients = c.recipe:getIngredients()
	c.products = c.recipe:getProducts()
	c.prodPerMin = {}
	c.consumePerMin = {}
	for k,v in pairs(c.products) do
		if (c.prodPerMin[v.Type.Name] == nil) then
			c.prodPerMin[v.Type.Name] = v.Amount * (60 / c.recipe.Duration)
		end
	end
	for k,v in pairs(c.ingredients) do
		if (c.consumePerMin[v.Type.Name] == nil) then
			c.consumePerMin[v.Type.Name] = v.Amount * (60 / c.recipe.Duration)
		end
	end
	setmetatable(c, self)
	c.__index = self
	return c
end

Constructor.DebugRecipe = function(self) 
	print("Recipe : "..self.recipe.name)
	print("Duration : "..self.recipe.duration)	
	for k,v in pairs(self.consumePerMin) do
		print(v.." "..k.." consumed per min")
	end
	
	for k,v in pairs(self.prodPerMin) do
		print(v.." "..k.." produced per min")
	end
	print("----------")
end