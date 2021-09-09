property_definitions = function(definitions_params)

        local endpoint_settings = {
            ["Name"] = function(property_object)
                 property_object:set_data_value("redis_lua_access_prehook", {
                        GET = function(prehook_params)
                            prehook_params.pl:get(string.format("%s:Name", prehook_params.redis_key_prefix))
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

