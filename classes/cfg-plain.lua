local plain = require("classes.plain")
local gatherer = require("core.gatherer")

local config = gatherer.geToml()
local merge = gatherer.merge

for item, content in pairs(config.scratch) do
  SILE.scratch[item] = content
end

SILE.scratch.fonts = config.fonts

local class = pl.class(plain)
class._name = "cfg-plain"

class.defaultFrameset = config.frames.defaultFrameset or config.frames.right or plain.defaultFrameset

function class:_init(options)
  options = merge(config.options, options)
  plain._init(self, options)

  SILE.languageSupport.loadLanguage(config.settings["document.language"])

  for _, name in ipairs(config.packages) do 
    self:loadPackage(name)
  end

  for id, frames in pairs(config.frames) do    
    self:defineMaster({ id = id, firstContentFrame = config.scratch.firstContentFrame[id] or "content", frames = frames })
  end

  for name, setting in pairs(config.settings) do 
    SILE.settings:set(name, setting)
  end

  self:loadPackage("twoside", { oddPageMaster = "right", evenPageMaster = "left" })

  if self:currentMaster() == "right" then
      self:mirrorMaster("right", "left")
  end
end

function class:finish()
  if self.packages.pdf then
    for key, value in pairs(config.meta) do
      SILE.call("pdf:metadata", { key = key, value = value})
    end
  end  
  return plain.finish(self)
end

return class
