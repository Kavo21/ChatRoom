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
            }
        }
    end,
