    operations = function()
        return {
            GET = function(operations_params)
                local db_access_clients = operations_params.db_access_clients
                local response_body = operations_params.response_body
                local response_data = db_access_clients:redis_lua_access()
                utils.copy_table_endpoint(response_body, response_data, {"Status"})
            end,
        }
    end,
