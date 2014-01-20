spriteviewerWindow = nil
spriteviewerButton = nil

local spriteCount = 0
local spriteViewOffset = 0
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

  connect(g_sprites, { onLoadSpr = onLoadSprites })

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

  g_mouse.bindAutoPress(spriteviewerWindow:getChildById('buttonPrev'), decreaseSpriteOffset, 100, MouseLeftButton)
  g_mouse.bindAutoPress(spriteviewerWindow:getChildById('buttonNext'), increaseSpriteOffset, 100, MouseLeftButton)

  g_keyboard.bindKeyPress("Left", decreaseSpriteOffset, spriteviewerWindow)
  g_keyboard.bindKeyPress("Right", increaseSpriteOffset, spriteviewerWindow)

  connect(spriteviewerWindow:getChildById('transparentCheckBox'), { onClick = toggleTransparency })

  if g_sprites.isLoaded() then
    onLoadSprites()
  end
end

function terminate()
  disconnect(g_sprites, { onLoadSpr = onLoadSprites })

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

function updateSpriteView()
  local spriteAmount = spriteViewSettings.rowCount * spriteViewSettings.columnCount
  for i = 1, spriteAmount do
    local spriteId = spriteViewOffset + i
    local spriteWidget = spriteView:getChildById(string.format('sprite%i', i))
    spriteWidget:setSpriteId(spriteId)
    if spriteWidget:hasSprite() then
      spriteWidget:setBorderWidth(0)
    else
      spriteWidget:setBorderWidth(2)
    end
    spriteWidget:setTooltip(string.format('SpriteId: %i%s', spriteId, (not spriteWidget:hasSprite() and '\nNULL' or '')))
  end
end

function onLoadSprites()
  spriteCount = g_sprites.getSpritesCount()
  setSpriteViewOffset(0)
end

function setSpriteViewOffset(offset)
  if not g_sprites.isLoaded() then
    return
  end

  local spriteAmount = spriteViewSettings.rowCount * spriteViewSettings.columnCount
  spriteViewOffset = math.max(0, math.min(offset, spriteCount - spriteAmount))
  spriteviewerWindow:getChildById('spriteViewLabel'):setText(string.format('%i - %i  [%i]', spriteViewOffset + 1, math.min(spriteViewOffset + spriteAmount, spriteCount), spriteCount))
  updateSpriteView()
end

function increaseSpriteOffset()
  setSpriteViewOffset(spriteViewOffset + 1)
end

function decreaseSpriteOffset()
  setSpriteViewOffset(spriteViewOffset - 1)
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

  setSpriteViewOffset(newOffset - 1)
end