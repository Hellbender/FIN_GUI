function GetComponents(query)
	l_components = {}
	components = component.findComponent(query)
	for k,v in pairs(components) do
		l_components[k] = component.proxy(v)
	end
	
	return l_components
end
