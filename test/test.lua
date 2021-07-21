return {
    property_definitions = function()
                return {
                    endpoint_settings = {
                        ["ServiceEnabled"] = function(property_object)
                            property_object:set_data_value("redis_lua_access_prehook", {})
                            property_object:set_data_value("redis_lua_access_posthook", {})
                            property_object:set_data_value("turboredis_access_prehook", {})
                            property_object:set_data_value("turboredis_access_posthook", {})
                            property_object:set_data_value("readonly", false)
                            property_object:set_data_value("property_type", {"boolean", "nil"})
                            property_object:set_data_value("property_size", 500)
                        end,
                        ["Status"] = {
                            ["Status"] = function(property_object)
                                property_object:set_data_value("redis_lua_access_prehook", {})
                                property_object:set_data_value("redis_lua_access_posthook", {})
                                property_object:set_data_value("turboredis_access_prehook", {})
                                property_object:set_data_value("turboredis_access_posthook", {})
                                property_object:set_data_value("readonly", false)
                                property_object:set_data_value("property_type", {"boolean", "nil"})
                                property_object:set_data_value("property_size", 500)
                            end,
                       },
                 },
            }
     end,
