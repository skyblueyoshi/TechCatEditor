---@class TCE.UIUtil
local UIUtil = class("UIUtil")
local ThemeUtil = require("core.ThemeUtil")
local UISpritePool = require("core.UISpritePool")
local Constant = require("config.Constant")

---@param parent UINode
---@param name string
---@param location table
---@param content string
---@param cfg table
---@return UIPanel
function UIUtil.newText(parent, name, location, content, cfg)
    local node = UIText.new(name)
    parent:addChild(node)
    UIUtil.setText(node, location, content, cfg)
    return node
end

---@param parent UINode
---@param name string
---@param location table
---@param content string
---@param cfg table
---@return UIPanel
function UIUtil.ensureText(parent, name, location, content, cfg)
    local node = parent:getChild(name)
    if not node:valid() then
        return UIUtil.newText(parent, name, location, content, cfg)
    else
        UIUtil.setText(node, location, content, cfg)
    end
    return node
end

---@param nodeParam UINode
---@param location table
---@param content string
---@param cfg table
---@return UIPanel
function UIUtil.setText(nodeParam, location, content, cfg)
    local node = UIText.cast(nodeParam)
    UIUtil.setLocation(node, location)
    node.text = content
    node.color = ThemeUtil.getColor("FONT_COLOR")
    node.fontSize = Constant.DEFAULT_FONT_SIZE
    node.horizontalOverflow = TextHorizontalOverflow.Overflow
    node.isBatchMode = false
    UIUtil.setCommonByCfg(node, cfg)
    UIUtil.setTextByCfg(node, cfg)
end

---newInputField
---@param parent UINode
---@param name string
---@param location table
---@param content string
---@param cfg table
---@return UIInputField
function UIUtil.newInputField(parent, name, location, content, cfg)
    local node = UIInputField.new(name)
    parent:addChild(node)
    UIUtil.setInputField(node, location, content, cfg)
    return node
end

---@param parent UINode
---@param name string
---@param location table
---@param content string
---@param cfg table
---@return UIInputField
function UIUtil.ensureInputField(parent, name, location, content, cfg)
    local node = parent:getChild(name)
    if not node:valid() then
        return UIUtil.newInputField(parent, name, location, content, cfg)
    else
        UIUtil.setInputField(node, location, content, cfg)
    end
    return node
end

---newInputField
---@param nodeParam UINode
---@param location table
---@param content string
---@param cfg table
function UIUtil.setInputField(nodeParam, location, content, cfg)
    local node = UIInputField.cast(nodeParam)
    UIUtil.setLocation(node, location)
    node.text = content
    node.color = ThemeUtil.getColor("FONT_COLOR")
    node.fontSize = Constant.DEFAULT_FONT_SIZE
    UIUtil.setCommonByCfg(node, cfg)
    UIUtil.setTextByCfg(node, cfg)
    UIUtil.setInputFieldByCfg(node, cfg)
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
    parent:addChild(node)
    UIUtil.setPanel(node, location, cfg, cacheRT, touchable)
    return node
end

---@param nodeParam UINode
---@param location table
---@param cfg table
---@param cacheRT boolean
---@param touchable boolean
---@return UIPanel
function UIUtil.setPanel(nodeParam, location, cfg, cacheRT, touchable)
    local node = UIPanel.cast(nodeParam)
    UIUtil.setLocation(node, location)
    UIUtil.setCommonByCfg(node, cfg)
    UIUtil.setImageByCfg(node, cfg)
    if cacheRT ~= nil then
        node.enableRenderTarget = cacheRT
    end
    if touchable ~= nil then
        node.touchable = touchable
    end
    node.textBatchRendering = false
end

---@param parent UINode
---@param name string
---@param location table
---@param cfg table
---@param cacheRT boolean
---@param touchable boolean
---@return UIPanel
function UIUtil.ensurePanel(parent, name, location, cfg, cacheRT, touchable)
    local node = parent:getChild(name)
    if not node:valid() then
        return UIUtil.newPanel(parent, name, location, cfg, cacheRT, touchable)
    else
        UIUtil.setPanel(node, location, cfg, cacheRT, touchable)
    end
    return node
end

---setCommonByCfg
---@param node UINode
---@param cfg table
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
    if cfg.widthRate ~= nil then
        node.widthRate = cfg.widthRate
    end
    if cfg.heightRate ~= nil then
        node.heightRate = cfg.heightRate
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
    if cfg.autoAdaptSize == nil then
        node.autoAdaptSize = true
    else
        node.autoAdaptSize = cfg.autoAdaptSize
    end
end

function UIUtil.setInputFieldByCfg(node, cfg)
    if cfg == nil then
        return
    end
    if cfg.isSelectAllFirstClicked ~= nil then
        node.isSelectAllFirstClicked = cfg.isSelectAllFirstClicked
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

    local imgBorder = node:getChild("__border")
    if cfg.borderColor ~= nil then
        if not imgBorder:valid() then
            imgBorder = UIImage.new("__border")
            node:addChild(imgBorder)
        end
        imgBorder:setLeftMargin(0, true)
        imgBorder:setRightMargin(0, true)
        imgBorder:setTopMargin(0, true)
        imgBorder:setBottomMargin(0, true)
        imgBorder:setAutoStretch(true, true)
        imgBorder.sprite = UISpritePool.getInstance():get("white_border")
        imgBorder.sprite.color = ThemeUtil.getColor(cfg.borderColor)
    else
        if imgBorder:valid() then
            node:removeChild(imgBorder)
        end
    end
end

---setPanelColor
---@param panel UINode
---@param bgColor string
function UIUtil.setPanelColor(panel, bgColor)
    local sprite = UIPanel.cast(panel).sprite
    local targetColor = ThemeUtil.getColor(bgColor)
    if sprite.color ~= targetColor then
        sprite.color = targetColor
        panel:flushRender()
    end
end

function UIUtil.setPanelDisplay(panel, selected, pointed, selectedColor, pointedColor)
    local sd = panel:getChild("sd")
    if selected then
        sd.visible = true
        selectedColor = selectedColor or "SD"
        UIUtil.setPanelColor(sd, selectedColor)
    elseif pointed then
        sd.visible = true
        pointedColor = pointedColor or "BD"
        UIUtil.setPanelColor(sd, pointedColor)
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

---@param panelList UINode
---@param proxy any
---@param isVertical boolean
---@param cfg table
---@return Size
function UIUtil.getTableViewInnerSize(panelList, proxy, isVertical, cfg)
    local sv = UIScrollView.cast(panelList)
    local panelItem = sv:getChild("panel_item")
    local pw, ph = panelItem.width, panelItem.height
    local isItemFillWidth = cfg.isItemFillWidth
    local isItemFillHeight = cfg.isItemFillHeight
    local isGrid = cfg.isGrid
    local count = 0
    if proxy._getTableElementCount ~= nil then
        count = proxy:_getTableElementCount()
    end
    if count == 0 then
        return Size.new(0, 0)
    end
    
    local vw, vh = sv.width, sv.height

    if isGrid then
        local gridPreLineCount = math.max(1, math.floor(vw / pw))
        if count <= gridPreLineCount then
            return Size.new(pw * count, ph)
        else
            local lines = math.ceil(count / gridPreLineCount)
            return Size.new(pw * gridPreLineCount, ph * lines)
        end
    end

    local function _getElementSize(index)
        local w, h = pw, ph
        if proxy._getTableElementSize ~= nil then
            w, h = proxy:_getTableElementSize(index)
        elseif not isGrid then
            if isItemFillWidth then
                w = vw
            end
            if isItemFillHeight then
                h = vh
            end
        end
        return w, h
    end

    local function _testLocation(testIndex, refX, refY, refWidth, refHeight, isRefNext)
        local x, y = 0.0, 0.0
        local w, h = _getElementSize(testIndex)
        if isVertical then
            x = refX
            if isRefNext then
                y = refY - h
            else
                y = refY + refHeight
            end
        else
            y = refY
            if isRefNext then
                x = refX - w
            else
                x = refX + refWidth
            end
        end
        return x, y, w, h
    end

    local refX, refY, refWidth, refHeight = 0, 0, 0, 0
    for i = 1, count do
        if i == 1 then
            refWidth, refHeight = _getElementSize(i)
        else
            refX, refY, refWidth, refHeight = _testLocation(i, refX, refY, refWidth, refHeight, false)
        end
    end

    local fullWidth, fullHeight = refX + refWidth, refY + refHeight
    return Size.new(fullWidth, fullHeight)
end

---@param panelList UINode
---@param proxy any
---@param isReload boolean
---@param isVertical boolean
---@param cfg table
---@return boolean
function UIUtil._updateTableView(panelList, proxy, isReload, isVertical, cfg)
    local sv = UIScrollView.cast(panelList)
    local panelItem = sv:getChild("panel_item")
    if not panelItem:valid() then
        assert(false)
        return false
    end
    panelItem.visible = false
    local pw, ph = panelItem.width, panelItem.height
    local vx, vy = -sv:getViewPosition().x, -sv:getViewPosition().y
    local vw, vh = sv.width, sv.height
    local vx2, vy2 = vx + vw, vy + vh

    --print(sv:getViewPosition())
    local isItemFillWidth = cfg.isItemFillWidth
    local isItemFillHeight = cfg.isItemFillHeight
    local isGrid = cfg.isGrid
    local gridPreLineCount = math.max(1, math.floor(vw / pw))

    if not sv:getChild("__inner"):valid() then
        local temp = UIPanel.new("__inner")
        sv:addChild(temp)
        isReload = true
    end
    local innerPanel = sv:getChild("__inner")

    -- 列表元素总数
    local count = 0
    if proxy._getTableElementCount ~= nil then
        count = proxy:_getTableElementCount()
    end
    ---@param node UINode
    local function _getNodeLocation(node)
        return node.positionX, node.positionY, node.width, node.height
    end

    local existIndexStart, existIndexEnd = 0, 0
    local existNodeStart, existNodeEnd = nil, nil
    local ex, ey, ew, eh = 0, 0, 0, 0
    local ex2, ey2, ew2, eh2 = 0, 0, 0, 0
    -- 获取已经存在的元素，索引范围
    for i = 1, innerPanel:getChildrenCount() do
        local tempItem = innerPanel:getChildByIndex(i - 1)
        local tag = tempItem.tag
        if tag > 0 then
            if existIndexStart == 0 then
                existIndexStart, existIndexEnd = tag, tag
                existNodeStart, existNodeEnd = tempItem, tempItem
                ex, ey, ew, eh = _getNodeLocation(tempItem)
                ex2, ey2, ew2, eh2 = ex, ey, ew, eh
            else
                if tag < existIndexStart then
                    existIndexStart = tag
                    existNodeStart = tempItem
                    ex, ey, ew, eh = _getNodeLocation(tempItem)
                end
                if tag > existIndexEnd then
                    existIndexEnd = tag
                    existNodeEnd = tempItem
                    ex2, ey2, ew2, eh2 = _getNodeLocation(tempItem)
                end
            end
        end
    end
    local existAny = existIndexStart ~= 0
    local changed = false

    local reserveNodeList = {}
    for i = 1, innerPanel:getChildrenCount() do
        local tempItem = innerPanel:getChildByIndex(i - 1)
        if tempItem.tag == 0 then
            table.insert(reserveNodeList, tempItem)
        end
    end

    ---@param node UINode
    local function _moveToReserve(node)
        node.visible = false
        if node.tag ~= 0 then
            node:removeAllListeners()
            node.tag = 0
            table.insert(reserveNodeList, node)
            changed = true
        end
    end

    local function _saveNode(index, node)
        --print("del:", index)
        if proxy._recycleTableElement ~= nil then
            proxy:_recycleTableElement(node, index)
        end
        _moveToReserve(node)
    end

    ---@return UINode
    local function _tryGetReserve()
        if #reserveNodeList > 0 then
            local tempItem = reserveNodeList[#reserveNodeList]
            table.remove(reserveNodeList, #reserveNodeList)
            return tempItem
        end
        return nil
    end

    local function _tryGetTargetItem(index)
        for i = 1, innerPanel:getChildrenCount() do
            local tempItem = innerPanel:getChildByIndex(i - 1)
            if tempItem.tag == index then
                return tempItem
            end
        end
        return nil
    end

    local function _ensureItem(index, x, y, w, h)
        local tempNode = _tryGetReserve()
        if tempNode == nil then
            tempNode = panelItem:clone()
            tempNode.name = "__item"
            innerPanel:addChild(tempNode)
        end
        tempNode.tag = index
        tempNode:setAnchorPoint(0, 0)
        tempNode.visible = true
        tempNode:setSize(w, h)
        tempNode:setPosition(x, y)
        tempNode:applyMargin()
        tempNode:removeAllListeners()

        return tempNode
    end

    local function _setItem(index, x, y, w, h)
        --print("new:", index)
        changed = true
        local tempItem = _ensureItem(index, x, y, w, h)
        if proxy._setTableElement ~= nil then
            proxy:_setTableElement(tempItem, index)
        end
    end

    -- 判断子区域是不是在可显示区域内
    local function _isLocationInDisplayArea(x, y, w, h)
        return x < vx2 and x + w > vx and y < vy2 and y + h > vy
    end

    local function _getElementSize(index)
        local w, h = pw, ph
        if proxy._getTableElementSize ~= nil then
            w, h = proxy:_getTableElementSize(index)
        elseif not isGrid then
            if isItemFillWidth then
                w = vw
            end
            if isItemFillHeight then
                h = vh
            end
        end
        return w, h
    end

    local function _testLocation(testIndex, refX, refY, refWidth, refHeight, isRefNext)
        local x, y = 0.0, 0.0
        local w, h = _getElementSize(testIndex)
        if isGrid then
            local xi = (testIndex - 1) % gridPreLineCount
            local yi = math.floor((testIndex - 1) / gridPreLineCount)
            return xi * w, yi * h, w, h
        else
            if isVertical then
                x = refX
                if isRefNext then
                    y = refY - h
                else
                    y = refY + refHeight
                end
            else
                y = refY
                if isRefNext then
                    x = refX - w
                else
                    x = refX + refWidth
                end
            end
        end
        return x, y, w, h
    end

    local showStart, showEnd = false, false
    if existAny then
        showStart = _isLocationInDisplayArea(ex, ey, ew, eh)
        showEnd = _isLocationInDisplayArea(ex2, ey2, ew2, eh2)
        if not showStart and not showEnd then
            isReload = true
        end
    end

    local showIndexStart, showIndexEnd = 0, 0
    if isReload or not existAny then
        for i = 1, innerPanel:getChildrenCount() do
            local temp = innerPanel:getChildByIndex(i - 1)
            _saveNode(temp.tag, temp)
        end

        local refX, refY, refWidth, refHeight = 0, 0, 0, 0
        for i = 1, count do
            if i == 1 then
                refWidth, refHeight = _getElementSize(i)
            else
                refX, refY, refWidth, refHeight = _testLocation(i, refX, refY, refWidth, refHeight, false)
            end

            if _isLocationInDisplayArea(refX, refY, refWidth, refHeight) then
                if showIndexStart == 0 then
                    showIndexStart = i
                end
                showIndexEnd = i
                _setItem(i, refX, refY, refWidth, refHeight)

            elseif not isReload and showIndexEnd > 0 then
                break
            end
        end

        if isReload then
            local fullWidth, fullHeight = refX + refWidth, refY + refHeight
            innerPanel:setSize(fullWidth, fullHeight)
            sv.viewSize = Size.new(fullWidth, fullHeight)
            --print(sv.viewSize)
        end
    else
        if not showStart then
            _saveNode(existIndexStart, existNodeStart)
        end
        if not showEnd then
            _saveNode(existIndexEnd, existNodeEnd)
        end

        local justAddStart, justAddEnd = false, false
        if showStart and showEnd then
            justAddStart, justAddEnd = true, true
        elseif showStart then
            justAddStart = true
        else
            justAddEnd = true
        end

        local function _innerCheck(_begin, _end, _dir, justAdd, _ex, _ey, _ew, _eh)
            local refX, refY, refWidth, refHeight = _ex, _ey, _ew, _eh
            local isRefNext = _dir == -1
            for i = _begin, _end, _dir do
                refX, refY, refWidth, refHeight = _testLocation(i, refX, refY, refWidth, refHeight, isRefNext)
                local ok = _isLocationInDisplayArea(refX, refY, refWidth, refHeight)
                local stop = true
                if justAdd then
                    if ok then
                        local tempItem = _tryGetTargetItem(i)
                        if tempItem == nil then
                            _setItem(i, refX, refY, refWidth, refHeight)
                            stop = false
                        end
                    end
                else
                    if not ok then
                        local tempItem = _tryGetTargetItem(i)
                        if tempItem ~= nil then
                            _saveNode(i, tempItem)
                            stop = false
                        end
                    end
                end
                if stop then
                    break
                end
            end
        end

        local function _check(borderIndex, minIndex, maxIndex, justAdd, _ex, _ey, _ew, _eh)
            _innerCheck(borderIndex - 1, minIndex, -1, justAdd, _ex, _ey, _ew, _eh)
            _innerCheck(borderIndex + 1, maxIndex, 1, justAdd, _ex, _ey, _ew, _eh)
        end

        --print("----------------")
        --print("_check", showStart, existIndexStart, 1, existIndexEnd, justAddStart)
        --print("_check", showEnd, existIndexEnd, existIndexStart, count, justAddEnd)
        _check(existIndexStart, 1, existIndexEnd, justAddStart, ex, ey, ew, eh)
        _check(existIndexEnd, existIndexStart, count, justAddEnd, ex2, ey2, ew2, eh2)

    end

    if changed then
        --print("all:", innerPanel:getChildrenCount())
    end

    return true
end

---_getTableElementSize(i)->Size
---_setTableElement(node, i)
---_getTableElementCount()->int
---_getTableElementPositionOffset(i)->Size
---
---@param panelList UINode
---@param proxy any
---@param isVertical boolean
---@param cfg table
---@return boolean
function UIUtil.createTableView(panelList, proxy, isVertical, cfg)
    if isVertical == nil then
        isVertical = true
    end

    local sv = UIScrollView.cast(panelList)

    sv:ScrollToLeft()
    sv:ScrollToTop()

    UIUtil._updateTableView(sv, proxy, true, isVertical, cfg)

    local listener = { UIUtil._updateTableView, sv, proxy, false, isVertical, cfg }
    --local reloadListener = { UIUtil._updateTableView, sv, proxy, true, isVertical, cfg }

    sv:addScrollingListener(listener)
    --sv:addResizeListener(reloadListener)
end

---getAllValidElements
---@param panelList UINode
---@return UINode[]
function UIUtil.getAllValidElements(panelList)
    local results = {}
    local innerPanel = panelList:getChild("__inner")
    for i = 1, innerPanel:getChildrenCount() do
        local tempItem = innerPanel:getChildByIndex(i - 1)
        if tempItem.tag > 0 then
            table.insert(results, tempItem)
        end
    end
    return results
end

---getItemAtIndex
---@param panelList UINode
---@param index number
---@return UINode
function UIUtil.getItemAtIndex(panelList, index)
    local innerPanel = panelList:getChild("__inner")
    for i = 1, innerPanel:getChildrenCount() do
        local tempItem = innerPanel:getChildByIndex(i - 1)
        local tag = tempItem.tag
        if tag > 0 and index == tag then
            return tempItem
        end
    end
    return nil
end

return UIUtil