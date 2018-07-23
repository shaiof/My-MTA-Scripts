definedObjects = {
	1007,1017,1006,1142,1143,1144,1145,1004,1032,
	1011,1005,1012,1050,1058,1044,1049,1060,1033,
	1000,1016,1002,1043,1014,1015,1147,1163,1038,
	1139,1158,1138,1146,1164,1150,1023,1001,1061,
	1103,1003,1151,1152,1048,1153,1047,1052,1055,
	1051,1093,1095,1036,1040,1090,1094,1162,1119,
	1070,1072,1039,1069,1132,1129,1031,1026,1128,
	1172,1165,1161,1140,1141,1159,1157,1057,1054,
	1056,1166,1148,1171,1149,1170,1168,1167,1053,
	1173,1155,1169,1156,1154,1160,1091,1087,1131,
	1088,1068,1067,1130
}

shaders = {}
addEventHandler('onClientResourceStart',resourceRoot,function()
	setTimer(function()
		for i,v in pairs(getElementsByType('vehicle')) do
			for k,e in pairs(getAttachedElements(v)) do
				if isElementOnScreen(e) then
						shaders[e] = shaders[e] or dxCreateShader('shader.fx',0,0,false,'object')
					if getElementData(v,'changeColor') == true then
						local r,g,b = getElementData(v,'r'),getElementData(v,'g'),getElementData(v,'b')
						setColor(e,r,g,b)
					else
						local r,g,b = getVehicleColor(v,true)
						setColor(e,r,g,b)
					end
				else
					for p,y in pairs(getAttachedElements(v)) do
						if shaders[y] then
							for i,vB in pairs(engineGetModelTextureNames(getElementModel(y))) do
								engineRemoveShaderFromWorldTexture(shaders[y],vB)
							end
						end
					end
				end
			end
		end
	end,50,0)
end)

function setColor(object,r,g,b)
	if shaders[object] then
		if shaders[object] then
			dxSetShaderValue(shaders[object],"red",(tonumber(r)/255)/4.3)
			dxSetShaderValue(shaders[object],"green",(tonumber(g)/255)/4.3)
			dxSetShaderValue(shaders[object],"blue",(tonumber(b)/255)/4.3)
			dxSetShaderValue(shaders[object],"alpha",1)
			local model = getElementModel(object)
			for u,o in pairs(definedObjects) do
				if (model == o) then
					if shaders[object] then
						if shaders[object] then
							engineApplyShaderToWorldTexture(shaders[object],'*',object)
						end
					end
				end
			end
		end
	end
end