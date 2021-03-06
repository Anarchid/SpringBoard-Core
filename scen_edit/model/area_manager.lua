AreaManager = Observable:extends{}

function AreaManager:init()
    self:super('init')
    self.areaIDCount = 0
    self.areas = {}
end

function AreaManager:addArea(area, areaID)
    if areaID == nil then
        areaID = self.areaIDCount + 1
    end
    self.areaIDCount = areaID
    self.areas[areaID] = area
    self:callListeners("onAreaAdded", areaID)
    return areaID
end

function AreaManager:removeArea(areaID)
    if self.areas[areaID] ~= nil then
        self.areas[areaID] = nil
        self:callListeners("onAreaRemoved", areaID)
    end
end

function AreaManager:setArea(areaID, value)
    assert(self.areas[areaID])
    self.areas[areaID] = value
    self:callListeners("onAreaChange", areaID, value)
end

function AreaManager:getArea(areaID)
    return self.areas[areaID]
end

function AreaManager:getAllAreas()
    local areas = {}
    for id, _ in pairs(self.areas) do
        table.insert(areas, id)
    end
    return areas
end

-- Utility functions
function AreaManager:GetAreaIn(x, z)
    local selected, dragDiffX, dragDiffZ
    for areaID, area in pairs(self.areas) do
        local pos = areaBridge.s11n:Get(areaID, "pos")
        if x >= area[1] and x < area[3] and z >= area[2] and z < area[4] then
            selected = areaID
            dragDiffX = pos.x - x
            dragDiffZ = pos.z - z
        end
    end
    return selected, dragDiffX, dragDiffZ
end
------------------------------------------------
-- Listener definition
------------------------------------------------
AreaManagerListener = LCS.class.abstract{}

function AreaManagerListener:onAreaAdded(areaID)
end

function AreaManagerListener:onAreaRemoved(areaID)
end

function AreaManagerListener:onAreaChange(areaID, area)
end
------------------------------------------------
-- End listener definition
------------------------------------------------
