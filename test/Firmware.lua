function NtpService:patch()
    local url_segments = self:get_url_segments()
    local redis_key_prefix = string.format("Redfish:%s", table.concat(url_segments, ":"))
    self:set_scope(redis_key_prefix)
    local request_uri = self:get_request().path
    local request_body = self:get_json()
    local response_body = {}
    local extended_info = {}
    local redis_keys_to_watch = {}
    local property_modified = {}

    NtpService_resource_handler:PATCH({
            redfish_handler = self,
            request_uri = request_uri,
            url_segments = url_segments,
            redis_key_prefix = redis_key_prefix,
            request_body = request_body,
            response_body = response_body,
            extended_info = extended_info,
            redis_keys_to_watch = redis_keys_to_watch,
            property_modified = property_modified,
        })

    --handle status code and response_body
    if next(extended_info) then
        if next(property_modified) then
            self:add_error_body(response_body, 200, unpack(extended_info))
            self:update_lastmodified(redis_key_prefix, os.time())
        else
            response_body = {}
            self:add_error_body(response_body, 400, unpack(extended_info))
            self:send_error_body(response_body)
        end
    else
        response_body = {}
        self:set_status(204)
        self:update_lastmodified(redis_key_prefix, os.time())
    end

    self:set_response(response_body)
    self:set_type(constants.NTP_SERVICE_TYPE)
    self:set_context(constants.NTP_SERVICE_CONTEXT)
    self:set_allow_header("GET, PATCH")
    self:output()
end
