
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


