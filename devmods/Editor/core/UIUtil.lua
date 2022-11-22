---@class TCE.UIUtil
local UIUtil = class("UIUtil")
local ThemeUtil = require("core.ThemeUtil")
local UISpritePool = require("core.UISpritePool")

---newText
---@param parent UINode
---@param name string
---@param location table
---@param content string
---@param cfg table
---@return UIPanel
function UIUtil.newText(parent, name, location, content, cfg)
    local node = UIText.new(name)
    UIUtil.setLocation(node, location)
    node.text = content
    node.fontSize = 20
    node.horizontalOverflow = TextHorizontalOverflow.Overflow
    node.autoAdaptSize = true
    parent:addChild(node)
    UIUtil.setCommonByCfg(node, cfg)
    UIUtil.setTextByCfg(node, cfg)
    return node
end

---newPanel
---@param parent UINode
---@param name string
---@param location table
---@param cfg table
---@param cacheRT boolean
---@param touchable boolean
---@return UIPanel
function UIUtil.newPanel(parent, name, location, cfg, cacheRT, touchable)
    local node = UIPanel.new(name)
    UIUtil.setLocation(node, location)
    parent:addChild(node)
    UIUtil.setCommonByCfg(node, cfg)
    UIUtil.setImageByCfg(node, cfg)
    if cacheRT ~= nil  then
        --node.enableRenderTarget = cacheRT
    end
    if touchable ~= nil then
        node.touchable = touchable
    end
    return node
end

function UIUtil.setCommonByCfg(node, cfg)
    if cfg == nil then
        return
    end
    if cfg.anchorPoint ~= nil then
        node:setAnchorPoint(cfg.anchorPoint[1], cfg.anchorPoint[2])
    end
    if cfg.positionY ~= nil then
        node.positionY = cfg.positionY
    end
    if cfg.positionX ~= nil then
        node.positionX = cfg.positionX
    end
    if cfg.size ~= nil then
        node.size = cfg.size
    end
    if cfg.touchable ~= nil then
        node.touchable = cfg.touchable
    end
    if cfg.layout then
        if cfg.layout == "CENTER" then
            cfg.margins = { 0, 0, 0, 0, false, false }
        elseif cfg.layout == "CENTER_W" then
            cfg.margins = { 0, nil, 0, nil, false, false }
        elseif cfg.layout == "CENTER_H" then
            cfg.margins = { nil, 0, nil, 0, false, false }
        elseif cfg.layout == "FULL" then
            cfg.margins = { 0, 0, 0, 0, true, true }
        elseif cfg.layout == "FULL_W" then
            cfg.margins = { 0, nil, 0, nil, true, false }
        elseif cfg.layout == "FULL_H" then
            cfg.margins = { nil, 0, nil, 0, false, true }
        end
    end
    if cfg.margins ~= nil then
        local autoStretchWidth = nil
        local autoStretchHeight = nil
        if cfg.margins[5] ~= nil then
            autoStretchWidth = cfg.margins[5]
        end
        if cfg.margins[6] ~= nil then
            autoStretchHeight = cfg.margins[6]
        end
        UIUtil.setMargins(node, cfg.margins[1], cfg.margins[2],
                cfg.margins[3], cfg.margins[4], autoStretchWidth, autoStretchHeight)
    end
    if cfg.marginsLR ~= nil then
        local autoStretch = nil
        if cfg.marginsLR[3] ~= nil then
            autoStretch = cfg.marginsLR[3]
        end
        UIUtil.setMarginsLR(node, cfg.marginsLR[1], cfg.marginsLR[2], autoStretch)
    end
    if cfg.marginsTB ~= nil then
        local autoStretch = false
        if cfg.marginsTB[3] ~= nil then
            autoStretch = cfg.marginsTB[3]
        end
        UIUtil.setMarginsTB(node, cfg.marginsTB[1], cfg.marginsTB[2], autoStretch)
    end
    if cfg.visible ~= nil then
        node.visible = cfg.visible
    end
end

function UIUtil.setTextByCfg(node, cfg)
    if cfg == nil then
        return
    end
    if cfg.color ~= nil then
        node.color = cfg.color
    end
    if cfg.fontSize ~= nil then
        node.fontSize = cfg.fontSize
    end
    if cfg.isRichText ~= nil then
        node.isRichText = cfg.isRichText
    end
    if cfg.autoAdaptSize ~= nil then
        node.autoAdaptSize = cfg.autoAdaptSize
    end
    if cfg.horizontalOverflow ~= nil then
        node.horizontalOverflow = cfg.horizontalOverflow
    end
end

---setImageCfg
---@param node UIPanel
---@param cfg table
function UIUtil.setImageByCfg(node, cfg)
    if cfg == nil then
        return
    end

    if cfg.bgColor ~= nil then
        node.sprite = UISpritePool.getInstance():get("white")
        node.sprite.color = ThemeUtil.getColor(cfg.bgColor)
    end

    if cfg.borderColor ~= nil then
        local imgBorder = UIImage.new("__border")
        imgBorder:setLeftMargin(0, true)
        imgBorder:setRightMargin(0, true)
        imgBorder:setTopMargin(0, true)
        imgBorder:setBottomMargin(0, true)
        imgBorder:setAutoStretch(true, true)
        imgBorder.sprite = UISpritePool.getInstance():get("white_border")
        imgBorder.sprite.color = ThemeUtil.getColor(cfg.borderColor)
        node:addChild(imgBorder)
    end
end

function UIUtil.setPanelColor(panel, bgColor)
    UIPanel.cast(panel).sprite.color = ThemeUtil.getColor(bgColor)
end

function UIUtil.setPanelDisplay(panel, selected, pointed)
    local sd = panel:getChild("sd")
    if selected then
        sd.visible = true
        UIUtil.setPanelColor(sd, "SD")
    elseif pointed then
        sd.visible = true
        UIUtil.setPanelColor(sd, "BD")
    else
        sd.visible = false
    end
end

---setLocation
---@param node UINode
---@param location table
function UIUtil.setLocation(node, location)
    if location then
        if #location >= 2 then
            local x, y = location[1], location[2]
            if x ~= nil and y ~= nil then
                node.position = Vector2.new(x, y)
            elseif x ~= nil then
                node.positionX = x
            elseif y ~= nil then
                node.positionY = y
            end
        end
        if #location >= 4 then
            local w, h = location[3], location[4]
            if w ~= nil and h ~= nil then
                node.size = Size.new(w, h)
            elseif w ~= nil then
                node.width = w
            elseif h ~= nil then
                node.height = h
            end
        end
    end
end

---@param node UINode
---@param left number
---@param top number
---@param right number
---@param bottom number
---@param autoStretchWidth boolean
---@param autoStretchHeight boolean
function UIUtil.setMargins(node, left, top, right, bottom, autoStretchWidth, autoStretchHeight)
    if left ~= nil then
        node:setLeftMargin(left, true)
    else
        node:setLeftMargin(0, false)
    end
    if top ~= nil then
        node:setTopMargin(top, true)
    else
        node:setTopMargin(0, false)
    end
    if right ~= nil then
        node:setRightMargin(right, true)
    else
        node:setRightMargin(0, false)
    end
    if bottom ~= nil then
        node:setBottomMargin(bottom, true)
    else
        node:setBottomMargin(0, false)
    end
    if autoStretchWidth == nil then
        if left ~= nil and right ~= nil then
            autoStretchWidth = true
        else
            autoStretchWidth = false
        end
    end
    if autoStretchHeight == nil then
        if top ~= nil and bottom ~= nil then
            autoStretchHeight = true
        else
            autoStretchHeight = false
        end
    end
    node.autoStretchWidth = autoStretchWidth
    node.autoStretchHeight = autoStretchHeight
end

---setMarginsLR
---@param node UINode
---@param left number
---@param right number
---@param autoStretch boolean
function UIUtil.setMarginsLR(node, left, right, autoStretch)
    UIUtil.setMargins(node, left, nil, right, nil, autoStretch, nil)
end

---setMarginsTB
---@param node UINode
---@param top number
---@param bottom number
---@param autoStretch boolean
function UIUtil.setMarginsTB(node, top, bottom, autoStretch)
    UIUtil.setMargins(node, nil, top, nil, bottom, nil, autoStretch)
end

---setTable
---
---_getTableElementSize(i)->Size
---_setTableElement(node, i)
---_getTableElementCount()->int
---_getTableElementPositionOffset(i)->Size
---
---@param panelList UINode
---@param proxy any
---@param isVertical boolean
---@param countPreLine number
---@return boolean
function UIUtil.setTable(panelList, proxy, isVertical, countPreLine)
    if not panelList:getChild("panel_item"):valid() then
        return false
    end
    isVertical = isVertical or true
    countPreLine = countPreLine or 1

    local sv = UIScrollView.cast(panelList)
    sv:ScrollToLeft()
    sv:ScrollToTop()

    local count = 0
    local panelItem = panelList:getChild("panel_item")
    panelItem.visible = false
    local lastCount = panelList:getChildrenCount()
    local childrenToRemoved = {}
    for i = 1, lastCount do
        local child = panelList:getChildByIndex(i - 1)
        if child.name ~= "panel_item" then
            table.insert(childrenToRemoved, child)
        end
    end
    ---@param child UINode
    for _, child in pairs(childrenToRemoved) do
        panelList:removeChild(child)
    end
    childrenToRemoved = {}

    if proxy._getTableElementCount == nil then
        count = 0
    else
        count = proxy:_getTableElementCount()
    end
    local offsetX = 0
    local offsetY = 0
    local maxX = 0
    local maxY = 0
    local indexPreLine = 1
    for i = 1, count do
        local itemName = string.format("panel_item_%d", i)
        local tempItem = panelList:getChild(itemName)
        local needCreate = false

        if tempItem:valid() then
            panelList:removeChild(tempItem)
            needCreate = true
        else
            needCreate = true
        end

        if needCreate then
            tempItem = panelItem:clone()
            tempItem.name = itemName
            panelList:addChild(tempItem, i)
        end
        tempItem:setAnchorPoint(0, 0)
        tempItem.visible = true
        if proxy._getTableElementSize ~= nil then
            local size = proxy:_getTableElementSize(i)
            if size ~= nil then
                tempItem.size = size
                tempItem:applyMargin()
            end
        end
        tempItem:setPosition(offsetX, offsetY)
        if proxy._setTableElement ~= nil then
            proxy:_setTableElement(tempItem, i)
        end
        local offsetWidth = tempItem.width
        local offsetHeight = tempItem.height
        if proxy._getTableElementPositionOffset ~= nil then
            local size = proxy:_getTableElementPositionOffset(i)
            offsetWidth, offsetHeight = size.width, size.height
        end
        maxX = tempItem.positionX + offsetWidth
        maxY = tempItem.positionY + offsetHeight
        if indexPreLine >= countPreLine then
            indexPreLine = 1
            if isVertical then
                offsetY = offsetY + offsetHeight
                offsetX = 0
            else
                offsetX = offsetX + offsetWidth
                offsetY = 0
            end
        else
            indexPreLine = indexPreLine + 1
            if isVertical then
                offsetX = offsetX + offsetWidth
            else
                offsetY = offsetY + offsetHeight
            end
        end
    end
    maxX = math.max(maxX, sv.width)
    maxY = math.max(maxY, sv.height)
    sv.viewSize = Size.new(maxX, maxY)

    sv:ScrollToLeft()
    sv:ScrollToTop()

    return true
end

---getTableElement
---@param uiTable UIScrollView
---@param index number
function UIUtil.getTableElement(uiTable, index)
    return uiTable:getChildByTag(index)
end

return UIUtil