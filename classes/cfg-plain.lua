local plain = require("classes.plain")

local gatherer = require("core.gatherer")
local config = gatherer.geToml()
local merge = gatherer.merge

SILE.scratch = config.scratch

local class = pl.class(plain)
class._name = "cfg-plain"

class.defaultFrameset = config.frames.defaultFrameset or plain.defaultFrameset

function class:_init(options)
  options = merge(options, config.options)

  for name, setting in pairs(config.settings) do 
    SILE.settings:set(name, setting)
  end

  plain._init(self, options)

  for _, name in ipairs(config.scratch.packages) do 
    self:loadPackage(name)
  end
end

return class

