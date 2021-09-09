local config = require("config")
local constants = require("constants")
local utils = require("utils")
local RedfishHandler = require("redfish-handler")
local NtpService = class("NtpService", RedfishHandler)
local NtpService_resource_handler = require("resource_handler")("NtpService")

function NtpService:get()
    local response_body = {}
    local url_segments = self:get_url_segments()
    local redis_key_prefix = string.format("Redfish:%s", table.concat(url_segments, ":"))

    NtpService_resource_handler:GET({
        redfish_handler = self,
        response_body = response_body,
        url_segments = url_segments,
        redis_key_prefix = redis_key_prefix,
    })

    self:set_response(response_body)
    self:set_type(constants.NTP_SERVICE_TYPE)
    self:set_context(constants.NTP_SERVICE_CONTEXT)
    self:set_allow_header("GET, PATCH")
    self:output()
end
