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
                            return posthook_params.pl_replies[1]
                        end,
                    })
            end,
        }
        return {
            endpoint_settings = endpoint_settings,
        }
    end,

