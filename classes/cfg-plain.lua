local plain = require("classes.plain")
local gatherer = require("core.gatherer")

local config = gatherer.geToml()
local merge = gatherer.merge

SILE.scratch = config.scratch
SILE.scratch.fonts = config.fonts

local class = pl.class(plain)
class._name = "cfg-plain"

class.defaultFrameset = config.frames.defaultFrameset or config.frames.right or plain.defaultFrameset

function class:_init(options)
  options = merge(options, config.options)

  for name, setting in pairs(config.settings) do 
    SILE.settings:set(name, setting)
  end

  plain._init(self, options)
  
  for id, frames in pairs(config.frames) do    
    self:defineMaster({ id = id, firstContentFrame = config.scratch.firstContentFrame[id] or "content", frames = frames })
  end

  for _, name in ipairs(config.packages) do 
    self:loadPackage(name)
  end

  self:loadPackage("twoside", { oddPageMaster = "right", evenPageMaster = "left" })

  if self:currentMaster() == "right" then
      self:mirrorMaster("right", "left")
  end
end

return class

