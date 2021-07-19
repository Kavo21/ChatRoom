local RedfishHandler = require("redfish-handler")

local CONSTANTS = require("constants")

local CONFIG = require("config")

local utils = require("utils")

local turbo = require("turbo")

local _ = require("underscore")

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

function FirmwareInventoryHandler:get_collection(response_body)
	local collection_exists = self:parent_exists()
	self:assertTrue_404(collection_exists)
	local redis_key_prefix = "Redfish:UpdateService:FirmwareInventory:"
	self:set_scope("Redfish:"..table.concat(self.url_segments,':'))
	self:set_context("SoftwareInventoryCollection.SoftwareInventoryCollection")
	self:set_type(CONSTANTS.SOFTWARE_INVENTORY_COLLECTION_TYPE)

	FirmwareInventory_Collection_resource_handler:GET({
		redfish_handler = self,
		request_body = nil,
		response_body = response_body,
		extended_info = nil,
		redis_keys_to_watch = nil,
		property_modified = nil,
		url_segments = self.url_segments,
		redis_key_prefix = redis_key_prefix,
	})
end


