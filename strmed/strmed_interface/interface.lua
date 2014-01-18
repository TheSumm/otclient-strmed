editorWindow = nil
editorButton = nil
errorBox = nil
logBuffer = nil
widgetsPanel = nil

local maximumLogEntries = 1000

function init()
  editorWindow = g_ui.displayUI('interface')
  editorWindow:hide()

  editorButton = modules.client_topmenu.addLeftButton('strmedButton', tr('StrmEd - Object Editor'), '/strmed/images/editor', toggle)

  logBuffer = editorWindow:getChildById('logBuffer')
  widgetsPanel = editorWindow:getChildById('widgetsPanel')

  connect(g_game, {
    onGameStart = onGameStart,
    onGameEnd   = onGameEnd,
    onProtocolVersionChange = onProtocolVersionChange
  })

  if g_game.isOnline() then
    onGameStart()
  end
end

function terminate()
  disconnect(g_game, {
    onGameStart = onGameStart,
    onGameEnd   = onGameEnd,
    onProtocolVersionChange = onProtocolVersionChange
  })

  if errorBox then
    errorBox:destroy()
  end

  editorButton:destroy()
  editorWindow:destroy()
  editorButton = nil
  editorWindow = nil
end

function onGameStart()

end

function onGameEnd()

end

function onProtocolVersionChange()

end

function addWidget(id, tooltip, icon, callback)
  local widget = g_ui.createWidget('WidgetButton', widgetsPanel)
  widget:setIcon(icon)
  widget:setTooltip(tooltip)
  widget.onClick = callback

  return widget
end

function log(text, color)
  if logBuffer:getChildCount() > maximumLogEntries then
    logBuffer:getChildByIndex(1):destroy()
  end

  local color = color
  if not color then
    color = 'white'
  end

  local label = g_ui.createWidget('LogLabel', logBuffer)
  label:setText(text)
  label:setColor(color)
end

function hide()
  editorWindow:hide()
  editorButton:setOn(false)
end

function show()
  editorWindow:show()
  editorWindow:raise()
  editorButton:setOn(true)
end

function toggle()
  if g_game.getProtocolVersion() == 0 then
    if not errorBox then
      errorBox = displayErrorBox(tr('StrmEd Error'), 'No protocol version has been set yet.\nLog in or set a protocol version manually first.')
      connect(errorBox, {onOk = function() errorBox = nil end})
    end
    return
  end

  if editorWindow:isVisible() then
    hide()
  else
    show()
  end
end