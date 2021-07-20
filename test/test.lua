return {
    resource_definitions = function()
        return {
            settings = function(resource_object)
                resource_object:set_data_value("turboredis_timeout", 15)
                resource_object:set_data_value("default_property_size", 500)
                resource_object:set_data_value("redfish_redis_key_prefix", {
                        string.format("Redfish:%s:%s:%s", "UpdateService", "FirmwareInventory")
                    })
                resource_object:set_data_value("redfish_resource_uri_pattern", {
                        string.format("^%s/UpdateService/FirmwareInventory/([^/]+)$", config.SERVICE_PREFIX),
                    })
                resource_object:set_data_value("redfish_resource_superordinate", "UpdateService")
                resource_object:set_data_value("redfish_resource_subordinate", nil)
            end,
        }
    end,
