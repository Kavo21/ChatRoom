local config = require("config")
local default_constants = require("default_constants")
local utils = require("utils")
local redis_lua = require("redis")
local yield = coroutine.yield

return {
    resource_definitions = function()
        return {
            settings = function(resource_object)
                resource_object:set_data_value("turboredis_timeout", 15) 
                resource_object:set_data_value("redfish_redis_key_prefix", {
                        string.format("Redfish:%s:%s", "UpdateService", "FirmwareInventory")
                    })
                resource_object:set_data_value("redfish_resource_uri_pattern", {
                        string.format("^%s/UpdateService/FirmwareInventory$", config.SERVICE_PREFIX),
                    })
                resource_object:set_data_value("redfish_resource_superordinate", "UpdateService")
                resource_object:set_data_value("redfish_resource_subordinate", nil)
            end,
        }
    end,
    property_definitions = function()
        return {
            endpoint_settings = {
                ["Description"] = function(property_object)
                    property_object:set_data_value("redis_lua_access_posthook", {
                            GET = function(posthook_params)
                                return "Collection of Firmware Inventory resources available to the UpdateService"
                            end,
                        })
                end,
                ["Name"] = function(property_object)
                    property_object:set_data_value("redis_lua_access_posthook", {
                            GET = function(posthook_params)
                                return "Firmware Inventory Collection"
                            end,
                        })
                end,
                ["Members"] = function(property_object)
                    property_object:set_data_value("redis_lua_access_prehook", {
                        GET = function(prehook_params)
                            yield(prehook_params.pl:keys(string.format("%s*:Name", prehook_params.redis_key_prefix)))
                        end,
                    })
                    property_object:set_data_value("redis_lua_access_posthook", {
                            GET = function(posthook_params)
                                return utils.getODataIDArray(posthook_params.pl_replies[1], 1)
                            end,
                        })
                end,
                ["Members@odata.count"] = function(property_object)
                    property_object:set_data_value("redis_lua_access_prehook", {
                        GET = function(prehook_params)
                            yield(prehook_params.pl:keys(string.format("%s*:Name", prehook_params.redis_key_prefix)))
                        end,
                    })
                    property_object:set_data_value("redis_lua_access_posthook", {
                            GET = function(posthook_params)
                                return #posthook_params.pl_replies[1]
                            end,
                        })
                end,
            }
        }
    end,
    operations = function()
        return {
            GET = function(operations_params)
                local db_access_clients = operations_params.db_access_clients
                local response_body = operations_params.response_body
                local response_data = db_access_clients:redis_lua_access()
                utils.copy_table_endpoint(response_body, response_data, {"Description"})
                utils.copy_table_endpoint(response_body, response_data, {"Name"})
                utils.copy_table_endpoint(response_body, response_data, {"Members"})
                utils.copy_table_endpoint(response_body, response_data, {"Members@odata.count"})
            end,
        }
    end,
}
