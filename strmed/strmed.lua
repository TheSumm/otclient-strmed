--[[
  Icon Credits to: http://p.yusukekamiyamane.com/
]]

Version = '0.1 alpha'

StrmEd = { 
  modules = { }
}

local loadmodules = {
  'interface',
  'spriteviewer'
}

local scheduledLogMessages = { }

function StrmEd.log(text, color)
  if not modules.strmed_interface then
    table.insert(scheduledLogMessages, { text = text, color = color })
    return
  end

  if #scheduledLogMessages > 0 then
    for i = 1, #scheduledLogMessages do
      modules.strmed_interface.log(scheduledLogMessages[i].text, scheduledLogMessages[i].color)
    end
    scheduledLogMessages = { }
  end

  modules.strmed_interface.log(text, color)
end

function StrmEd.discoverModules()
  StrmEd.log('== StrmEd discovering modules.', LogColors.Event)
  StrmEd.modules = { }
  local discovered = 0
  for i = 1, #loadmodules do
    local tmpModule = loadmodules[i]
    local module = g_modules.getModule(tmpModule)
    if not module then
      module = g_modules.discoverModule(string.format('strmed_%s/%s.otmod', tmpModule, tmpModule))
    end
    if module then
      table.insert(StrmEd.modules, module)
      discovered = discovered + 1
    end
  end
  StrmEd.log(tr('==   Discovered %i modules.', discovered), LogColors.Default)
end

function StrmEd.loadModules()
  StrmEd.log('== StrmEd loading modules.', LogColors.Event)
  for i = 1, #StrmEd.modules do
    local module = StrmEd.modules[i]
    if not module:isLoaded() then
      module:load()
      StrmEd.log(string.format('==   Module \'%s\' loaded.', module:getName()), LogColors.Default)
    else
      StrmEd.log(string.format('==   Module \'%s\' already loaded.', module:getName()), LogColors.Default)
    end
  end
end

function StrmEd.unloadModules()
  StrmEd.log('== StrmEd unloading modules.', LogColors.Event)
  for i = #StrmEd.modules, 1, -1 do
    local module = StrmEd.modules[i]
    if module:canUnload() then
      module:unload()
      StrmEd.log(string.format('==   Module \'%s\' unloaded.', module:getName()), LogColors.Default)
    else
      StrmEd.log(string.format('==   Module \'%s\' cannot be unloaded.', module:getName()), LogColors.Default)
    end
  end
  StrmEd.modules = { }
end

function StrmEd.init()
  StrmEd.log(tr('[[ StrmEd %s by Summ ]]', Version), LogColors.Event)
  StrmEd.log('== StrmEd starting up.', LogColors.Event)
  StrmEd.discoverModules()
  StrmEd.loadModules()

  StrmEd.log('== StrmEd loaded successfully.', LogColors.Success)
  StrmEd.log('', LogColors.Event)

  if #scheduledLogMessages > 0 then
    for i = 1, #scheduledLogMessages do
      StrmEd.log(scheduledLogMessages[i].text, scheduledLogMessages[i].color)
    end
    scheduledLogMessages = { }
  end
end

function StrmEd.terminate()
  StrmEd.unloadModules()
end
