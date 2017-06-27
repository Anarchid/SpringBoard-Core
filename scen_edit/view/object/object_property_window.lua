SB.Include(Path.Join(SB_VIEW_DIR, "editor.lua"))

ObjectPropertyWindow = Editor:extends{}
Editor.Register({
    name = "objectPropertyWindow",
    editor = ObjectPropertyWindow,
    tab = "Objects",
    caption = "Properties",
    tooltip = "Edit object properties",
    image = SB_IMG_DIR .. "anatomy.png",
})

function ObjectPropertyWindow:init()
    self:super("init")
    self.rules = {}
    self.objectKeys = { "health", "mass" }
    self.unitKeys = {"tooltip", "maxHealth", "stockpile", "experience", "fuel", "team", "neutral", "maxRange", "harvestStorage", "capture", --[["paralyze",]] "build"}

    self:AddControl("pos-sep", {
        Label:New {
            caption = "Position",
        },
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })
    self:AddField(GroupField({
        NumericField({
            name = "posX",
            title = "X:",
            tooltip = "Position (x)",
            value = 1,
            minValue = 0,
            maxValue = Game.mapSizeX,
            step = 1,
            width = 100,
            decimals = 0,
        }),
        NumericField({
            name = "posY",
            title = "Y:",
            tooltip = "Position (y)",
            value = 0,
            step = 1,
            width = 100,
            decimals = 0,
        }),
        NumericField({
            name = "posZ",
            title = "Z:",
            tooltip = "Position (z)",
            value = 1,
            minValue = 0,
            maxValue = Game.mapSizeZ,
            step = 1,
            width = 100,
            decimals = 0,
        }),
        BooleanField({
            name = "stickToGround",
            title = "S",
            tooltip = "Stick to ground",
            width = 50,
            value = true,
        }),
        BooleanField({
            name = "avgPos",
            title = "G",
            tooltip = "Alter the position of the object selection as a group.",
            width = 50,
            value = true,
        }),
    }))

    self:AddControl("angle-sep", {
        Label:New {
            caption = "Angle",
        },
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })
    self:AddField(GroupField({
        NumericField({
            name = "angleX",
            title = "X:",
            tooltip = "X angle",
            value = 0,
            step = 0.2,
            width = 100,
        }),
        NumericField({
            name = "angleY",
            title = "Y:",
            tooltip = "Y angle",
            value = 0,
            step = 0.2,
            width = 100,
        }),
        NumericField({
            name = "angleZ",
            title = "Z:",
            tooltip = "Z angle",
            value = 0,
            step = 0.2,
            width = 100,
        }),
        Field({
            name = "btn-align-ground",
            width = 150,
            components = {
                Button:New {
                    caption = "Align",
                    x = 0,
                    width = 135,
                    height = 30,
                    tooltip = "Align to heightmap",
                    OnClick = {
                        function()
                            local selection = SB.view.selectionManager:GetSelection()
                            local objectID, bridge
                            if #selection.units > 0 then
                                objectID = selection.units[1]
                                bridge = unitBridge
                            elseif #selection.features > 0 then
                                objectID = selection.features[1]
                                bridge = featureBridge
                            end
                            local x, z = self.fields["posX"].value, self.fields["posZ"].value
                            local dirX, dirY, dirZ = Spring.GetGroundNormal(x, z)
                            local frontDir = bridge.s11n:Get(objectID, "dir")
                            local upDir =    {x=dirX,  y=dirY,  z=dirZ}
                            local rightDir = CrossProduct(frontDir, upDir)
                            frontDir = CrossProduct(upDir, rightDir)
                            self:OnFieldChange("dir", frontDir)
                            --self:OnFieldChange("dir", {x=1, y=0, z=0})
                        end
                    }
                },
            }
        })
    }))

    self:AddControl("vel-sep", {
        Label:New {
            caption = "Velocity",
        },
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })
    self:AddField(GroupField({
        NumericField({
            name = "velX",
            title = "X:",
            tooltip = "Velocity (x)",
            value = 1,
            step = 1,
            width = 100,
        }),
        NumericField({
            name = "velY",
            title = "Y:",
            tooltip = "Velocity (y)",
            value = 0,
            step = 1,
            width = 100,
        }),
        NumericField({
            name = "velZ",
            title = "Z:",
            tooltip = "Velocity (z)",
            value = 1,
            step = 1,
            width = 100,
        }),
    }))

    self:AddField(NumericField({
        name = "mass",
        title = "Mass:",
        tooltip = "Object mass",
        value = 1,
        step = 1,
        width = 100,
    }))

    self:AddControl("health-sep", {
        Label:New {
            caption = "Health",
        },
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })
    self:AddField(GroupField({
        NumericField({
            name = "health",
            title = "Health:",
            tooltip = "Health",
            minValue = 1,
            value = 1,
            step = 10,
            width = 160,
        }),
        NumericField({
            name = "maxHealth",
            title = "Max:",
            tooltip = "Max health",
            minValue = 1,
            value = 1,
            step = 10,
            width = 160,
        })
    }))
    self:AddField(GroupField({
        NumericField({
            name = "capture",
            title = "Capture:",
            tooltip = "Capture",
            minValue = 0,
            maxValue = 1,
            value = 1,
            step = 0.001,
            width = 160,
        }),
        NumericField({
            name = "build",
            title = "Build:",
            tooltip = "Build health",
            minValue = 0,
            maxValue = 1,
            value = 1,
            step = 0.001,
            width = 160,
        }),
--         NumericField({
--             name = "paralyze",
--             title = "Paralyze:",
--             tooltip = "Paralyze",
--             minValue = 0,
--             value = 1,
--             step = 10,
--             width = 150,
--         }),
    }))

    self:AddControl("state-sep", {
        Label:New {
            caption = "State",
        },
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })
    self:AddField(GroupField({
        ChoiceField({
            name = "fireState",
            title = "",
            tooltip = "Fire state",
            items = {0, 1, 2},
            captions = {"Hold fire", "Return fire", "Fire at will"},
            width = 100,
        }),
        ChoiceField({
            name = "moveState",
            title = "",
            tooltip = "Move state",
            items = {0, 1, 2},
            captions = {"Hold pos", "Maneuver", "Roam"},
            width = 100,
        }),
        BooleanField({
            name = "active",
            title = "Active",
            tooltip = "Active/passive unit",
            width = 100,
        }),
        BooleanField({
            name = "repeat",
            title = "Repeat",
            tooltip = "Should the unit repeat orders",
            width = 100,
        }),
    }))
    self:AddField(GroupField({
        BooleanField({
            name = "cloak",
            title = "Cloak",
            tooltip = "Cloak state",
            width = 100,
        }),
        BooleanField({
            name = "trajectory",
            title = "Trajectory",
            tooltip = "Shoot using a trajectory",
            width = 100,
        }),
        BooleanField({
            name = "autoRepairLevel",
            title = "Auto repair",
            tooltip = "Auto repair level",
            width = 100,
        }),
        BooleanField({
            name = "loopbackAttack",
            title = "Loopback",
            tooltip = "Loopback attack",
            width = 100,
        }),
    }))

    self:AddField(BooleanField({
        name = "autoLand",
        title = "Auto land",
        tooltip = "Auto land",
        width = 100,
    }))

    local teamIDs = GetField(SB.model.teamManager:getAllTeams(), "id")
    for i = 1, #teamIDs do
        teamIDs[i] = tostring(teamIDs[i])
    end
    local teamCaptions = GetField(SB.model.teamManager:getAllTeams(), "name")
    self:AddField(ChoiceField({
        name = "team",
        items = teamIDs,
        captions = teamCaptions,
        title = "Team: ",
    }))

    self:AddField(StringField({
        name = "tooltip",
        title = "Tooltip:",
        tooltip = "Tooltip",
        value = "",
    }))

    self:AddField(NumericField({
        name = "stockpile",
        title = "Stockpile:",
        tooltip = "Stockpile",
        minValue = 0,
        value = 1,
        step = 1,
    }))

    self:AddField(NumericField({
        name = "experience",
        title = "Experience:",
        tooltip = "Experience",
        minValue = 0,
        value = 1,
        step = 0.01,
    }))

    self:AddField(BooleanField({
        name = "neutral",
        title = "Neutral:",
        tooltip = "Neutral",
        value = false,
    }))

    self:AddField(NumericField({
        name = "fuel",
        title = "Fuel:",
        tooltip = "Fuel",
        minValue = 0,
        value = 1,
        step = 1,
    }))

    self:AddField(NumericField({
        name = "maxRange",
        title = "Max range:",
        tooltip = "Max unit engagement range",
        minValue = 0,
        value = 1,
        step = 1,
    }))

    self:AddControl("metal-sep", {
        Label:New {
            caption = "Metal",
        },
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })
    self:AddField(GroupField({
        NumericField({
            name = "metalMake",
            title = "Make:",
            tooltip = "Metal make",
            value = 0,
            step = 0.2,
            width = 200,
        }),
        NumericField({
            name = "metalUse",
            title = "Use:",
            tooltip = "Metal use",
            value = 0,
            step = 0.2,
            width = 200,
        }),
    }))
    self:AddControl("energy-sep", {
        Label:New {
            caption = "Energy",
        },
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })
    self:AddField(GroupField({
        NumericField({
            name = "energyMake",
            title = "Make:",
            tooltip = "Energy make",
            value = 0,
            step = 0.2,
            width = 200,
        }),
        NumericField({
            name = "energyUse",
            title = "Use:",
            tooltip = "Energy use",
            value = 0,
            step = 0.2,
            width = 200,
        }),
    }))
    self:AddControl("energy-end", {
        Line:New {
            x = 50,
            width = self.VALUE_POS,
        }
    })

    self:AddField(NumericField({
        name = "harvestStorage",
        title = "Harvest storage:",
        tooltip = "Harvest storage (metal)",
        minValue = 0,
        value = 1,
        step = 1,
    }))

    local children = {}

    table.insert(children,
        ScrollPanel:New {
            x = 0,
            y = "0%",
            bottom = 30,
            right = 0,
            borderColor = {0,0,0,0},
            horizontalScrollbar = false,
            children = { self.stackPanel },
        }
    )

    self:Finalize(children)
    SB.view.selectionManager:addListener(self)
    self:OnSelectionChanged(SB.view.selectionManager:GetSelection())
    SB.commandManager:addListener(self)
end

function CrossProduct(u, v)
    return {x = u.y * v.z - u.z * v.x,
            y = u.z * v.x - u.x * v.z,
            z = u.x * v.y - u.y * v.x}
end

function ObjectPropertyWindow:OnCommandExecuted()
    if not self._startedChanging then
        self:OnSelectionChanged(SB.view.selectionManager:GetSelection())
    end
end

function ObjectPropertyWindow:OnStartChange(name)
    SB.commandManager:execute(SetMultipleCommandModeCommand(true))
end

function ObjectPropertyWindow:OnEndChange(name)
    SB.commandManager:execute(SetMultipleCommandModeCommand(false))
end

function ObjectPropertyWindow:IsObjectKey(name)
    for _, key in pairs(self.objectKeys) do
        if key == name then
            return true
        end
    end
    if name == "pos" or name == "dir" or name == "rot" or name == "vel" then
        return true
    end
    return false
end

function ObjectPropertyWindow:IsFeatureKey(name)
    if self:IsObjectKey(name) then
        return true
    end
    return false
end

function ObjectPropertyWindow:IsUnitKey(name)
    if self:IsObjectKey(name) or name == "resources" then
        return true
    end
    for _, key in pairs(self.unitKeys) do
        if key == name then
            return true
        end
    end
    return false
end

function ObjectPropertyWindow:AddObjectRules(objectID, bridge)
    if #self.rules > 0 then
        self:RemoveField("rule-sep")
    end
    for _, rule in pairs(self.rules) do
        self:RemoveField(rule)
    end
    self.rules = {}
    local addedRule = false
    for rule, value in pairs(bridge.s11n:Get(objectID, "rules")) do
        if not addedRule then
            addedRule = true
            self:AddControl("rule-sep", {
                Label:New {
                    caption = "Rules",
                },
                Line:New {
                    x = 50,
                    width = self.VALUE_POS,
                }
            })
        end
        local ruleName = "rule_" .. rule
        if type(value) == "string" then
            self:AddField(StringField({
                name = ruleName,
                title = rule .. ":",
                tooltip = "Rule (" .. rule .. ")",
                value = tostring(value),
            }))
        else
            self:AddField(NumericField({
                name = ruleName,
                title = rule .. ":",
                tooltip = "Rule (" .. rule .. ")",
                value = value,
            }))
        end
        table.insert(self.rules, ruleName)
    end
end

function ObjectPropertyWindow:_GetAveragePos()
    local selection = SB.view.selectionManager:GetSelection()
    local avg = {x=0, y=0, z=0}
    for _, objectID in pairs(selection.units) do
        local pos = unitBridge.s11n:Get(objectID, "pos")
        avg.x = avg.x + pos.x
        avg.y = avg.y + pos.y
        avg.z = avg.z + pos.z
    end
    for _, objectID in pairs(selection.features) do
        local pos = featureBridge.s11n:Get(objectID, "pos")
        avg.x = avg.x + pos.x
        avg.y = avg.y + pos.y
        avg.z = avg.z + pos.z
    end
    avg.x = avg.x / (#selection.units + #selection.features)
    avg.y = avg.y / (#selection.units + #selection.features)
    avg.z = avg.z / (#selection.units + #selection.features)
    return avg
end

function ObjectPropertyWindow:OnSelectionChanged(selection)
    self.selectionChanging = true
    local objectID, bridge
    local keys
    if #selection.units > 0 then
        objectID = selection.units[1]
        bridge = unitBridge
        keys = SB.deepcopy(self.unitKeys)
        for _, value in pairs(self.objectKeys) do
            table.insert(keys, value)
        end
        self:SetInvisibleFields()
    elseif #selection.features > 0 then
        objectID = selection.features[1]
        bridge = featureBridge
        keys = self.objectKeys
        self:SetInvisibleFields(unpack(self.unitKeys))
    end
    if objectID then
        if bridge == unitBridge then
            self:AddObjectRules(objectID, bridge)
        end
        for _, key in pairs(keys) do
            if key == "fuel" then -- FIXME: fuel is aircraft only
                local maxFuel = bridge.ObjectDefs[bridge.spGetObjectDefID(objectID)].maxFuel
            end
            local value = bridge.s11n:Get(objectID, key)
            self:Set(key, value)
        end
        local pos
        if self.fields["avgPos"].value then
            pos = self:_GetAveragePos()
        else
            pos = bridge.s11n:Get(objectID, "pos")
        end
        self:Set("posX", pos.x)
        self:Set("posY", pos.y)
        self:Set("posZ", pos.z)

        local vel = bridge.s11n:Get(objectID, "vel")
        self:Set("velX", vel.x)
        self:Set("velY", vel.y)
        self:Set("velZ", vel.z)

        local rot = bridge.s11n:Get(objectID, "rot")
        local dir = bridge.s11n:Get(objectID, "dir")
        self:Set("angleX", math.deg(rot.x))
        self:Set("angleY", math.deg(rot.y))
        self:Set("angleZ", math.deg(rot.z))

        if bridge == unitBridge then
            local resources = bridge.s11n:Get(objectID, "resources")
            local metalMake, metalUse, energyMake, energyUse = resources.metalMake, resources.metalUse, resources.energyMake, resources.energyUse
            self:Set("metalMake",  metalMake)
            self:Set("metalUse",   metalUse)
            self:Set("energyMake", energyMake)
            self:Set("energyUse",  energyUse)

            local states = bridge.s11n:Get(objectID, "states")
            Log.Debug("ACTIVE", states.active)
            self:Set("fireState",       states.fireState)
            self:Set("moveState",       states.moveState)
            self:Set("repeat",          states["repeat"])
            self:Set("cloak",           states.cloak)
            self:Set("active",          states.active)
            self:Set("trajectory",      states.trajectory)
            self:Set("autoLand",        states.autoLand)
            self:Set("autoRepairLevel", states.autoRepairLevel)
            self:Set("loopbackAttack",  states.loopbackAttack)
        end
    end
    self.selectionChanging = false
end

function ObjectPropertyWindow:OnFieldChange(name, value)
    if self.selectionChanging then
        return
    end

    local selection = SB.view.selectionManager:GetSelection()
    if #selection.units == 0 and #selection.features == 0 then
        return
    end

    if name == "avgPos" then
        self:OnSelectionChanged(selection)
        return
    end

    if name == "stickToGround" then
        if value then
            self:OnFieldChange("movectrl", false)
            self:OnFieldChange("gravity", 1)
            -- Force refreshing the position
            self:OnFieldChange("posX", self.fields["posX"].value)
        end
        return
    end

    local commands = {}
    if name == "posX" or name == "posY" or name == "posZ" then
        local avg
        if self.fields["avgPos"].value then
            avg = self:_GetAveragePos()
        else
            avg = { x=0, y=0, z=0}
        end

        if name == "posX" then
            value = { x = self.fields["posX"].value - avg.x }
        elseif name == "posY" then
            if self.fields["stickToGround"].value then
                self:Set("stickToGround", false)
            end
            value = { y = self.fields["posY"].value - avg.y }
        elseif name == "posZ" then
            value = { z = self.fields["posZ"].value - avg.z }
        end
        name = "pos"
    end
    if name == "velX" or name == "velY" or name == "velZ" then
        value = { x = self.fields["velX"].value,
                  y = self.fields["velY"].value,
                  z = self.fields["velZ"].value }
        name = "vel"
    end
    if name == "angleX" or name == "angleY" or name == "angleZ" then
        local angleX = math.rad(self.fields["angleX"].value)
        local angleY = math.rad(self.fields["angleY"].value)
        local angleZ = math.rad(self.fields["angleZ"].value)
        value = { x = angleX,
                  y = angleY,
                  z = angleZ }
        name = "rot"
    end
    if name:sub(1, #"rule_") == "rule_" then
        local rule = name:sub(#"rule_"+1)
        name = "rules"
        value = {
            [rule] = value
        }
    end
    if name == "metalMake" or name == "metalUse" or name == "energyMake" or name == "energyUse" then
        name = "resources"
        value = { metalMake  = self.fields["metalMake"].value,
                  metalUse   = self.fields["metalUse"].value,
                  energyMake = self.fields["energyMake"].value,
                  energyUse  = self.fields["energyUse"].value }
    end
    if name == "fireState" or name == "moveState" or name == "repeat" or name == "cloak" or name == "active" or name == "trajectory" or name == "autoLand" or name == "autoRepairLevel" or name == "loopbackAttack" then
        name = "states"
        value = { fireState         = self.fields["fireState"].value,
                  moveState         = self.fields["moveState"].value,
                  ["repeat"]        = self.fields["repeat"].value,
                  cloak             = self.fields["cloak"].value,
                  active            = self.fields["active"].value,
                  trajectory        = self.fields["trajectory"].value,
                  autoLand          = self.fields["autoLand"].value,
                  autoRepairLevel   = self.fields["autoRepairLevel"].value,
                  loopbackAttack    = self.fields["loopbackAttack"].value,
        }
    end
    -- HACK: needs cleanup
    if self:IsUnitKey(name) or name == "gravity" or name == "movectrl" or name == "rules" or name == "resources" or name == "states" then
        for _, command in pairs(self:GetCommands(selection.units, name, value, unitBridge)) do
            table.insert(commands, command)
        end
    end
    if self:IsFeatureKey(name) then
        for _, command in pairs(self:GetCommands(selection.features, name, value, featureBridge)) do
            table.insert(commands, command)
        end
    end
    local compoundCommand = CompoundCommand(commands)
    SB.commandManager:execute(compoundCommand)
end

function ObjectPropertyWindow:GetCommands(objectIDs, name, value, bridge)
    local commands = {}
    for _, objectID in pairs(objectIDs) do
        local modelID = bridge.getObjectModelID(objectID)
        if name ~= "pos" then
            table.insert(commands, bridge.SetObjectParamCommand(modelID, name, value))
        else
            local pos = bridge.s11n:Get(objectID, "pos")
            for coordName, coordValue in pairs(value) do
                if self.fields["avgPos"].value then
                    pos[coordName] = pos[coordName] + coordValue
                else
                    pos[coordName] = coordValue
                end
            end
            if self.fields["stickToGround"].value then
                pos.y = Spring.GetGroundHeight(pos.x, pos.z)
            end
            table.insert(commands, bridge.SetObjectParamCommand(modelID, name, pos))
            if bridge == unitBridge then
                table.insert(commands, bridge.SetObjectParamCommand(modelID, "movectrl", true))
                table.insert(commands, bridge.SetObjectParamCommand(modelID, "gravity", 0))
            elseif bridge == featureBridge then
                --table.insert(commands, bridge.SetObjectParamCommand(modelID, "lockPos", false))
            end
        end
    end
    return commands
end
