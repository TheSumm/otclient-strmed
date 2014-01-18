spriteviewerWindow = nil
spriteviewerButton = nil

local transparency = false
local spriteViewSettings = {
    rowCount = 7,
    columnCount = 10,
    spriteSize = 32,
    spacing = 2
}

function init()
  spriteviewerWindow = g_ui.displayUI('spriteviewer')
  spriteviewerWindow:hide()

  spriteviewerButton = modules.strmed_interface.addWidget('spriteviewer', 'Sprite Viewer', '/strmed/images/spriteviewer', toggle)

  spriteView = spriteviewerWindow:getChildById('spriteView')
  spriteView:setWidth(spriteViewSettings.columnCount * spriteViewSettings.spriteSize + spriteViewSettings.spacing * (spriteViewSettings.columnCount - 1))
  spriteView:setHeight(spriteViewSettings.rowCount * spriteViewSettings.spriteSize + spriteViewSettings.spacing * (spriteViewSettings.rowCount - 1))
  
  local spriteViewLayout = spriteView:getLayout()
  spriteViewLayout:setNumColumns(spriteViewSettings.columnCount)
  spriteViewLayout:setNumLines(spriteViewSettings.rowCount)
  spriteViewLayout:setCellSpacing(spriteViewSettings.spacing)
  spriteViewLayout:setCellSize(string.format('%i %i', spriteViewSettings.spriteSize, spriteViewSettings.spriteSize))
  
  for row = 1, spriteViewSettings.rowCount do
    for col = 1, spriteViewSettings.columnCount do
      local widget = g_ui.createWidget('Sprite', spriteView)
      widget:setSize(string.format('%i %i', spriteViewSettings.spriteSize, spriteViewSettings.spriteSize))
      widget:setId(string.format('sprite%i', (row - 1) * spriteViewSettings.columnCount + col))
    end
  end
  
  g_mouse.bindAutoPress(spriteviewerWindow:getChildById('buttonPrev'), decreaseSpriteOffset, 50, MouseLeftButton)
  g_mouse.bindAutoPress(spriteviewerWindow:getChildById('buttonNext'), increaseSpriteOffset, 50, MouseLeftButton)

  g_keyboard.bindKeyPress("Left", decreaseSpriteOffset, spriteviewerWindow)
  g_keyboard.bindKeyPress("Right", increaseSpriteOffset, spriteviewerWindow)

  connect(spriteviewerWindow:getChildById('transparentCheckBox'), { onClick = toggleTransparency })

  onSpritesLoaded()
end

function terminate()
  spriteView:destroy()
  spriteviewerWindow:destroy()
  spriteviewerButton:destroy()
end

function hide()
  spriteviewerWindow:hide()
  spriteviewerButton:setOn(false)
end

function show()
  spriteviewerWindow:show()
  spriteviewerWindow:raise()
  spriteviewerWindow:focus()
  spriteviewerButton:setOn(true)
end

function toggle()
  if spriteviewerWindow:isVisible() then
    hide()
  else
    show()
  end
end


function updatespriteView()
  local spriteAmount = spriteViewSettings.rowCount * spriteViewSettings.columnCount
  for i = 1, spriteAmount do
    local spriteId = spriteViewOffset + i
    local spriteWidget = spriteView:getChildById(string.format('sprite%i', i))
    if spriteId > spritesCount then
      spriteWidget:setVisible(false)
    else
      spriteWidget:setSpriteId(spriteId)
      if not spriteWidget:isVisible() then
        spriteWidget:setVisible(true)
      end
    end
  end  
end

function onSpritesLoaded()
  if not g_sprites.isLoaded() then
    return
  end
  
  spritesCount = g_sprites.getSpritesCount()
  setspriteViewOffset(0)
end

function setspriteViewOffset(offset)
  if not g_sprites.isLoaded() then
    return
  end
  
  local spriteAmount = spriteViewSettings.rowCount * spriteViewSettings.columnCount
  spriteViewOffset = math.max(0, math.min(offset, spritesCount - spriteAmount))
  spriteviewerWindow:getChildById('spriteViewLabel'):setText(string.format('%i - %i  [%i]', spriteViewOffset + 1, math.min(spriteViewOffset + spriteAmount, spritesCount), spritesCount))
  updatespriteView()
end

function increaseSpriteOffset()
  setspriteViewOffset(spriteViewOffset + 1)
end

function decreaseSpriteOffset()
  setspriteViewOffset(spriteViewOffset - 1)
end

function toggleTransparency()
  transparency = not transparency
  local spriteAmount = spriteViewSettings.rowCount * spriteViewSettings.columnCount
  for i = 1, spriteAmount do
    local spriteWidget = spriteView:getChildById(string.format('sprite%i', i))
    spriteWidget:setOn(transparency)
  end
end

function jumpOffset()
  local widget = spriteviewerWindow:getChildById('jumpOffsetText')
  local newOffset = tonumber(widget:getText())
  widget:setFocusable(false)
  widget:setText('')
  if not newOffset then
    return
  end
  
  setspriteViewOffset(newOffset - 1)
end