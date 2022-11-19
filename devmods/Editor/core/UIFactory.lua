---@class TCE.UIFactory
local UIFactory = class("UIFactory")
local ThemeUtil = require("core.ThemeUtil")
local UISpritePool = require("core.UISpritePool")

---newText
---@param parent UINode
---@param name string
---@param location table
---@param content string
---@param cfg table
---@return UIPanel
function UIFactory.newText(parent, name, location, content, cfg)
    local node = UIText.new(name)
    UIFactory.setLocation(node, location)
    node.text = content
    node.fontSize = 20
    node.horizontalOverflow = TextHorizontalOverflow.Overflow
    node.autoAdaptSize = true
    parent:addChild(node)
    UIFactory.setCommonByCfg(node, cfg)
    UIFactory.setTextByCfg(node, cfg)
    return node
end

---newPanel
---@param parent UINode
---@param name string
---@param location table
---@param cfg table
---@return UIPanel
function UIFactory.newPanel(parent, name, location, cfg)
    local node = UIPanel.new(name)
    UIFactory.setLocation(node, location)
    parent:addChild(node)
    UIFactory.setCommonByCfg(node, cfg)
    UIFactory.setImageByCfg(node, cfg)
    node.enableRenderTarget = true
    return node
end

function UIFactory.setCommonByCfg(node, cfg)
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
    if cfg.margins ~= nil then
        local autoStretchWidth = nil
        local autoStretchHeight = nil
        if cfg.margins[5] ~= nil then
            autoStretchWidth = cfg.margins[5]
        end
        if cfg.margins[6] ~= nil then
            autoStretchHeight = cfg.margins[6]
        end
        UIFactory.setMargins(node, cfg.margins[1], cfg.margins[2],
                cfg.margins[3], cfg.margins[4], autoStretchWidth, autoStretchHeight)
    end
    if cfg.marginsLR ~= nil then
        local autoStretch = nil
        if cfg.marginsLR[3] ~= nil then
            autoStretch = cfg.marginsLR[3]
        end
        UIFactory.setMarginsLR(node, cfg.marginsLR[1], cfg.marginsLR[2], autoStretch)
    end
    if cfg.marginsTB ~= nil then
        local autoStretch = false
        if cfg.marginsTB[3] ~= nil then
            autoStretch = cfg.marginsTB[3]
        end
        UIFactory.setMarginsTB(node, cfg.marginsTB[1], cfg.marginsTB[2], autoStretch)
    end
    if cfg.visible ~= nil then
        node.visible = cfg.visible
    end
end

function UIFactory.setTextByCfg(node, cfg)
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
function UIFactory.setImageByCfg(node, cfg)
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

---setLocation
---@param node UINode
---@param location table
function UIFactory.setLocation(node, location)
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
function UIFactory.setMargins(node, left, top, right, bottom, autoStretchWidth, autoStretchHeight)
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
function UIFactory.setMarginsLR(node, left, right, autoStretch)
    UIFactory.setMargins(node, left, nil, right, nil, autoStretch, nil)
end

---setMarginsTB
---@param node UINode
---@param top number
---@param bottom number
---@param autoStretch boolean
function UIFactory.setMarginsTB(node, top, bottom, autoStretch)
    UIFactory.setMargins(node, nil, top, nil, bottom, nil, autoStretch)
end

return UIFactory