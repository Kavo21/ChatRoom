return {
    resource_definitions = function(definitions_params)

        local settings = function(resource_object)
            resource_object:set_data_value("turboredis_timeout", 15) -- sec
            resource_object:set_data_value("redfish_redis_key_prefix", {
                    string.format("Redfish:%s", "Managers")
                })
            resource_object:set_data_value("redfish_resource_uri_pattern", {
                    string.format("^%s/Managers$", config.SERVICE_PREFIX),
                })
            resource_object:set_data_value("redfish_resource_superordinate", "ServiceRoot")
            resource_object:set_data_value("redfish_resource_subordinate", {
                    "ManagersInstance",
                })
        end

        return {
            settings = settings,
        }
    end,
