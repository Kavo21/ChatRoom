local FirmwareInventoryHandler = class("FirmwareInventoryHandler", RedfishHandler)

local FirmwareInventory_Collection_resource_handler = require("resource_handler")("FirmwareInventory_Collection")

local FirmwareInventory_Instance_resource_handler = require("resource_handler")("FirmwareInventory_Instance")

local yield = coroutine.yield

function FirmwareInventoryHandler:get(id)

	local response = {}

	if id == CONFIG.SERVICE_PREFIX .. "/UpdateService/FirmwareInventory" then
		self:get_collection(response)
	else
		self:get_instance(response)
	end

	self:set_response(response)

	self:set_allow_header("GET")
    
	self:output()
end
