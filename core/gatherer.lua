local lfs = require "lfs"
local inspect = require"inspect" 
local toml = require 'toml'
local datafile = require "datafile"

toml.strict = false -- to enable more lua-friendly features (like mixed arrays)

local function fileExist(f)
    if io.open(f) ~= nil then
        return true
    else
        return false
    end
end

local function super(file, typeofreturn) --  parses toml files
    local raw

    if type(file) == "userdata" then
        raw = file:read("*all")
    elseif fileExist(file) and type(file) == "string" then
        raw = assert(io.open(tostring(file), "r")):read("*all")
    end

    if typeofreturn == "string" then -- to show it as verbatim in the documentation
        string.gsub(raw, "\n", "\n\n\n")
        return raw
    end

    local status
    local input, output = {}, {}

    status, input = pcall(toml.parse, raw)

    if status then
        for i, j in pairs(input) do
            output[i] = j
        end
    end

    return output
end

local function merge(fallback, localfile, count) -- it runs through both files and compare each item at the lowest level
    local T, count = fallback, count or 0

    if localfile == nil or localfile == false then
        return fallback
    end

    for key, value in pairs(fallback) do -- overwrites any value declared in the localfile
        if type(value) == "table" and localfile[key] then
            T[key], count = merge(T[key], localfile[key], count)
        elseif localfile[key] ~= nil and localfile[key] ~= "" then
            T[key] = localfile[key]
        elseif localfile[key] == nil then
            T[key] = fallback[key]
        end
    end

    for key, value in pairs(localfile) do -- writes anything else from localfile which is not in default
        if not fallback[key] then
            T[key] = value
        end
    end

    return T, count + 1
end

local function geToml()
    local home, config, layoutConfig = os.getenv("HOME"), {}, {}
    local dotsile = home .. "/.config/sile/"
    local default = datafile.open("config/default.toml")
    local locDefault = dotsile .. "default.toml"
    local settings = lfs.currentdir() .. "/settings.toml"

    if not fileExist(dotsile) then  lfs.mkdir(dotsile) end
    if not fileExist(dotsile.."default.toml") then os.execute("cp " .. datafile.path("config/default.toml") .. " " .. dotsile) end

    config = merge(super(default), super(locDefault))

    if fileExist(settings) then
        config = merge(config, super(settings))
    end

    if config.debug.showconfig then print(inspect(config)) end
    return config
end

return { merge = merge, geToml = geToml }

