local config = require("config")
local utils = require("utils")
local otii_utils = require("otii_utils")
local env_managers_name = utils.get_env_managers_name()

return {
    resource_definitions = function(definitions_params)
        local settings = function(resource_object)
            resource_object:set_data_value("turboredis_timeout", 15)
            resource_object:set_data_value("redfish_redis_key_prefix", {
                    string.format("Redfish:%s:%s:%s", "Managers", env_managers_name, "NtpService"),
                })
            resource_object:set_data_value("redfish_resource_uri_pattern", {
                    string.format("^%s/Managers/([^/]+)/NtpService$", config.SERVICE_PREFIX),
                })
            resource_object:set_data_value("redfish_resource_superordinate", {
                    "ManagersInstance",
                })
            resource_object:set_data_value("redfish_resource_subordinate", nil)
        end

        return {
            settings = settings,
        }
    end,
    property_definitions = function(definitions_params)
        local endpoint_settings = {
            ["ServiceEnabled"] = function(property_object)
                property_object:set_data_value("redis_lua_access_cache_enabled", false)
                property_object:set_data_value("redis_lua_access_prehook", {
                    GET = function(prehook_params)
                        prehook_params.pl:get(string.format("%s:ServiceEnabled", prehook_params.redis_key_prefix))
                    end,
                })
                property_object:set_data_value("redis_lua_access_posthook", {
                    GET = function(posthook_params)
                        return otii_utils.toboolean(posthook_params.pl_replies[1])
                    end,
                })
                property_object:set_data_value("readonly", false)
                property_object:set_data_value("property_type",  {"boolean"})
                property_object:set_data_value("turboredis_access_prehook", {
                    PATCH = function(prehook_params)
                        if prehook_params.request_body_value ~= nil then
                            prehook_params.pl:set(string.format("PATCH:%s", prehook_params.redis_key_prefix), prehook_params.request_body_value)
                            table.insert(prehook_params.redis_keys_to_watch, string.format("PATCH_FINISH:%s", prehook_params.redis_key_prefix))
                        end
                    end,
                })
            end,
        }

        return {
            endpoint_settings = endpoint_settings,
        }
    end,
    operation_definitions = function(definitions_params)
        local operation = {
            GET = function(operations_params)
                local response_body = operations_params.response_body
                local db_access_clients = operations_params.db_access_clients
                local response_data = db_access_clients:redis_lua_access()
                utils.copy_table_endpoint(response_body, response_data, {"ServiceEnabled"})
            end,
            PATCH = function(operations_params)
                local db_access_clients = operations_params.db_access_clients
                local response_data = db_access_clients:turboredis_access()
            end,
        }

        return {
            operation = operation,
        }
    end,
}
