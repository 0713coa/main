-- ================================================================================
-- Map Speed piece
-- ================================================================================
local MarketplaceService = game:GetService("MarketplaceService")
local placeInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local mapName = placeInfo.Name
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local ServerId = game.JobId 
local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId
local StarterPlayer = game:GetService("StarterPlayer")
local player = game:GetService("Players").LocalPlayer
local data = player:WaitForChild("Data")
local rootPart = character:WaitForChild("HumanoidRootPart")

local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

_G.scriptVersion = "v1.0.0"

local placeName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

local Window = Library:CreateWindow{
    Title = `{placeName} | TovixHub {_G.scriptVersion}`,
    SubTitle = "by Toixhub",
    TabWidth = 160,
    Size = UDim2.fromOffset(830, 525),
    Resize = true,
    MinSize = Vector2.new(470, 380),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.G
}

local Tabs = {
    Main = Window:CreateTab{
        Title = "Main",
        Icon = "house"
    },
    Self = Window:CreateTab{
        Title = "Self",
        Icon = "user"
    },
    Server = Window:CreateTab{
        Title = "Server",
        Icon = "Server"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Options = Library.Options

-- =========================== Auto Farm ===================================

local AutoFarmToggle = Tabs.Main:AddToggle("AutoFarmToggle", {
    Title = "Auto Farm",
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        print("AutoFarm Toggle:", _G.AutoFarm)
    end
})

local MonsterDropdown = Tabs.Main:AddDropdown("MonsterDropdown", {
    Title = "Select Monster",
    Values = {},
    Multi = false,
    Default = nil,
})   

MonsterDropdown:OnChanged(function(Value)
    print("เลือกมอนสเตอร์:", Value)
end)

local UpdateButton = Tabs.Main:AddButton({
    Title = "Update Monster",
    Callback = function()
        local monsterNames = {}
        for _, v in pairs(game:GetService("Workspace").Monster:GetDescendants()) do
            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                if v.Name ~= "" and not table.find(monsterNames, v.Name) then
                    table.insert(monsterNames, v.Name)
                end
            end
        end
        MonsterDropdown:SetValues(monsterNames)
        if #monsterNames > 0 and not MonsterDropdown.Value then
            MonsterDropdown:SetValue(monsterNames[1])
        end
    end
})

-- =========================== AutoDun ===================================

local AutoDunToggle = Tabs.Main:AddToggle("AutoDunToggle", {
    Title = "AutoDun",
    Default = false,
    Callback = function(Value)
        _G.AutoDun = Value
        print("AutoDun Toggle:", _G.AutoDun)
    end
})

-- รายชื่อมอนสเตอร์หรือโฟลเดอร์ที่ไม่ต้องการให้วาร์ปไปหา
local blacklist = {
    ["Asta [LV.789]"] = true,
    Bandit = true,
    Boss = true,
    ["Curse Person [LV.777]"] = true,
    ["GokuNoob [LV.555]"] = true,
    Kraken = true,
    Kung = true,
    Megumi = true,
    ["PangKung [LV950]"] = true,
    ["Real Aizen [Level 1300]"] = true,
    wade = true,
    Villagers = true,
    Uji = true,
    ["Solo Man [LV.777]"] = true,
    ["Small Frieren [LV.555]"] = true,
    ["Six kagayno [Lv.1500]"] = true,
    ["Shark Meet Soul [LV 1100]"] = true,
    ["SeniorGokuNoob [LV.888]"] = true,
    ["Senior Asta [LV.989]"] = true,
    Savage = true,
}

_G.AutoFarm = false
_G.AutoDun = false

-- ลูปสำหรับ AutoFarm
spawn(function()
    while true do
        task.wait()
        if _G.AutoFarm then
            pcall(function()
                for _, v in pairs(game:GetService("Workspace").Monster:GetDescendants()) do
                    if v.Name == MonsterDropdown.Value then
                        if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            repeat
                                task.wait()
                                if game.Players.LocalPlayer.Character and
                                   game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and
                                   v:FindFirstChild("HumanoidRootPart") then
                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                                        v.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                end
                            until _G.AutoFarm == false or v.Humanoid.Health <= 0 or v.Name ~= MonsterDropdown.Value
                        end
                    end
                end
            end)
        end
    end
end)

-- ลูปสำหรับ AutoDun
spawn(function()
    while true do 
        task.wait()
        if _G.AutoDun then
            pcall(function()
                for _, monster in pairs(workspace.Monster:GetChildren()) do
                    if not blacklist[monster.Name] then
                        if monster:FindFirstChild("Humanoid") and monster.Humanoid.Health > 0 then
                            local hrp = monster:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                repeat
                                    task.wait()
                                    local char = game.Players.LocalPlayer.Character
                                    if char and char:FindFirstChild("HumanoidRootPart") then
                                        char.HumanoidRootPart.CFrame = hrp.CFrame * CFrame.new(0, 9, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                    end
                                until not _G.AutoDun or monster.Humanoid.Health <= 0 or not monster:IsDescendantOf(workspace)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ======================================== Tp Island ============================================


local Dropdown = Tabs.Main:AddDropdown("DungeonSelector", {
    Title = "Select Dungeon",
    Values = {"Hot And Cool", "Meteorite City", "Songkran City", "Store Garden City"},
    Multi = false,
    Default = 1,
})
local SelectedDungeon = "Hot And Cool"
Dropdown:SetValue(SelectedDungeon)
Dropdown:OnChanged(function(Value)
    SelectedDungeon = Value
end)

local function warpAndInteract()
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    local portal = workspace:FindFirstChild("Other") and workspace.Other:FindFirstChild("Dungeon Portal")

    if portal then
        HumanoidRootPart.CFrame = portal.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.5)
        for _, v in pairs(portal:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                fireproximityprompt(v)
                break
            end
        end
    end
end

local function ClickUISpawn()
    local success = false

    if SelectedDungeon == "Songkran City" then
        local button = workspace:FindFirstChild("Other")
            and workspace.Other:FindFirstChild("Dungeon Portal")
            and workspace.Other["Dungeon Portal"]:FindFirstChild("Script")
            and workspace.Other["Dungeon Portal"].Script:FindFirstChild("Select Dungeon")
            and workspace.Other["Dungeon Portal"].Script["Select Dungeon"]:FindFirstChild("Main")
            and workspace.Other["Dungeon Portal"].Script["Select Dungeon"].Main:FindFirstChild("Songkran City ")
            and workspace.Other["Dungeon Portal"].Script["Select Dungeon"].Main["Songkran City "]:FindFirstChild("Button")

        if button and button.Visible and (button:IsA("TextButton") or button:IsA("ImageButton")) then
            GuiService.SelectedObject = button
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait(0.5)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
            success = true
        end
    else
        local path
        local uiPath = PlayerGUI
        local uiExists = true

        if SelectedDungeon == "Hot And Cool" then
            path = {"Select Dungeon", "Main", "Hot And Cool", "Button"}
        elseif SelectedDungeon == "Meteorite City" then
            path = {"Select Dungeon", "Main", "Meteorite City", "Button"}
        elseif SelectedDungeon == "Store Garden City" then
            path = {"Select Dungeon", "Main", "Store Garden City", "Button"}
        end

        for _, p in ipairs(path) do
            if uiPath:FindFirstChild(p) then
                uiPath = uiPath[p]
            else
                uiExists = false
                break
            end
        end

        if uiExists and uiPath.Visible and (uiPath:IsA("ImageButton") or uiPath:IsA("TextButton")) then
            GuiService.SelectedObject = uiPath
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
            task.wait(0.5)
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.BackSlash, false, game)
            task.wait(0.1)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.BackSlash, false, game)
            success = true
        end
    end

    if not success then
        warpAndInteract()
    end

    return success
end

local AutoClickToggle = Tabs.Main:AddToggle("AutoClickToggle", {
    Title = "Auto Click Dungeon",
    Default = false,
    Callback = function(Value)
        if Value then
            task.spawn(function()
                while Options.AutoClickToggle.Value do
                    local clicked = ClickUISpawn()
                    if clicked then
                        task.wait(30)
                    else
                        task.wait(3)
                    end
                end
            end)
        end
    end
})

-- ======================================== Tp Island ============================================

local function getUniqueIslandNames()
    local islandNames = {}
    local seenNames = {}
    local islandFolder = workspace:FindFirstChild("Island")
    if islandFolder then
        for _, island in pairs(islandFolder:GetChildren()) do
            if island:IsA("Model") and not seenNames[island.Name] then
                table.insert(islandNames, island.Name)
                seenNames[island.Name] = true
            end
        end
    end
    return islandNames
end

local IslandSection = Tabs.Main:AddSection(">> Island Teleport <<")

local IslandDropdown = IslandSection:AddDropdown("IslandDropdown", {
    Title = "Select Island",
    Values = getUniqueIslandNames(),
    Multi = false,
    Default = nil,
})

local islandNames = getUniqueIslandNames()
if #islandNames > 0 then
    IslandDropdown:SetValue(islandNames[1])
end

local selectedIsland = IslandDropdown.Value or islandNames[1] or "None"

IslandDropdown:OnChanged(function(Value)
    selectedIsland = Value
    print("เลือกเกาะ:", Value)
end)

local islandFolder = workspace:FindFirstChild("Island")
if islandFolder then
    islandFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            local updatedIslandNames = getUniqueIslandNames()
            IslandDropdown:SetValues(updatedIslandNames)
            if #updatedIslandNames > 0 and not IslandDropdown.Value then
                IslandDropdown:SetValue(updatedIslandNames[1])
            end
        end
    end)

    islandFolder.ChildRemoved:Connect(function(child)
        if child:IsA("Model") then
            local updatedIslandNames = getUniqueIslandNames()
            IslandDropdown:SetValues(updatedIslandNames)
            if #updatedIslandNames > 0 and not IslandDropdown.Value then
                IslandDropdown:SetValue(updatedIslandNames[1])
            end
        end
    end)
end

IslandSection:AddButton({
    Title = "Teleport To Island",
    Description = "วาร์ปไปยังเกาะที่เลือก",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการวาร์ป",
            Content = "คุณต้องการวาร์ปไปยังเกาะ '" .. (selectedIsland or "ไม่เลือก") .. "' หรือไม่?",
            Buttons = {
                {
                    Title = "ยืนยัน",
                    Callback = function()
                        local islandModel = workspace.Island:FindFirstChild(selectedIsland)
                        if islandModel and islandModel:IsA("Model") then
                            local part = islandModel:FindFirstChildWhichIsA("BasePart")
                            if part then
                                character:MoveTo(part.Position)
                            end
                        end
                    end
                },
                {
                    Title = "ยกเลิก",
                    Callback = function()
                    end
                }
            }
        })
    end
})

-- ======================================== Tp NPC ==============================================

local function getUniqueNPCNames()
    local NPCNames = {}
    local seenNames = {}
    local npcFolder = workspace:FindFirstChild("NPC")
    if npcFolder then
        for _, NPC in pairs(npcFolder:GetChildren()) do
            if NPC:IsA("Model") and not seenNames[NPC.Name] then
                table.insert(NPCNames, NPC.Name)
                seenNames[NPC.Name] = true
            end
        end
    end
    return NPCNames
end

local NPCSection = Tabs.Main:AddSection(">> NPC Teleport <<")

local NPCDropdown = NPCSection:AddDropdown("NPCDropdown", {
    Title = "Select NPC",
    Values = getUniqueNPCNames(),
    Multi = false,
    Default = nil,
})

local npcNames = getUniqueNPCNames()
if #npcNames > 0 then
    NPCDropdown:SetValue(npcNames[1])
end

local selectedNPC = NPCDropdown.Value or npcNames[1] or "None"

NPCDropdown:OnChanged(function(Value)
    selectedNPC = Value
end)

local npcFolder = workspace:FindFirstChild("NPC")
if npcFolder then
    npcFolder.ChildAdded:Connect(function(child)
        if child:IsA("Model") then
            local updatedNPCNames = getUniqueNPCNames()
            NPCDropdown:SetValues(updatedNPCNames)
            if #updatedNPCNames > 0 and not NPCDropdown.Value then
                NPCDropdown:SetValue(updatedNPCNames[1])
            end
        end
    end)

    npcFolder.ChildRemoved:Connect(function(child)
        if child:IsA("Model") then
            local updatedNPCNames = getUniqueNPCNames()
            NPCDropdown:SetValues(updatedNPCNames)
            if #updatedNPCNames > 0 and not NPCDropdown.Value then
                NPCDropdown:SetValue(updatedNPCNames[1])
            end
        end
    end)
end

NPCSection:AddButton({
    Title = "Teleport To NPC",
    Description = "วาร์ปไปยัง NPC ที่เลือก",
    Callback = function()
        Window:Dialog({
            Title = "ยืนยันการวาร์ป",
            Content = "คุณต้องการวาร์ปไปยัง NPC '" .. (selectedNPC or "ไม่เลือก") .. "' หรือไม่?",
            Buttons = {
                {
                    Title = "ยืนยัน",
                    Callback = function()
                        local NPCModel = workspace.NPC:FindFirstChild(selectedNPC)
                        if NPCModel and NPCModel:IsA("Model") then
                            local part = NPCModel:FindFirstChildWhichIsA("BasePart")
                            if part then
                                character:MoveTo(part.Position)
                            end
                        end
                    end
                },
                {
                    Title = "ยกเลิก",
                    Callback = function()
                    end
                }
            }
        })
    end
})

-- ======================================== Self ==============================================

local AttackSection = Tabs.Self:AddSection(">> Attack <<")

local AttackToggle = Tabs.Self:AddToggle("AttackToggle", {
    Title = "Auto Attack",
    Default = false
})
Options.AttackToggle = AttackToggle

local OneHitToggle = Tabs.Self:AddToggle("OneHitToggle", {
    Title = "One Pan Man",
    Default = false
})
Options.OneHitToggle = OneHitToggle

local function activateTools()
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, v in ipairs(character:GetChildren()) do
            if v:IsA("Tool") then
                v:Activate()
            end
        end
    end
end

local function checkMonsterHealth(monsterSubLevel)
    local humanoid = monsterSubLevel:FindFirstChild("Humanoid")
    if humanoid then
        spawn(function()
            while humanoid and humanoid.Health > 0 and Options.OneHitToggle.Value do
                if humanoid.Health < humanoid.MaxHealth then
                    humanoid.Health = 0
                    break
                end
                wait(.1)
            end
        end)
    end
end

local function scanMonsterFolder()
    local monsterFolder = game:GetService("Workspace"):FindFirstChild("Monster")
    if monsterFolder then
        for i, monster in pairs(monsterFolder:GetChildren()) do
            for i, subMonster in pairs(monster:GetChildren()) do
                if subMonster:IsA("Model") then
                    checkMonsterHealth(subMonster)
                end
            end
        end
    end
end

spawn(function()
    while true do
        if Options.AttackToggle.Value then
            activateTools()
        end
        if Options.OneHitToggle.Value then
            scanMonsterFolder()
        end
        wait(.1)
    end
end)

game:GetService("Workspace").ChildAdded:Connect(function(child)
    if child.Name == "Monster" and Options.OneHitToggle.Value then
        child.ChildAdded:Connect(function(monster)
            monster.DescendantAdded:Connect(function(subMonster)
                if subMonster:IsA("Model") then
                    checkMonsterHealth(subMonster)
                end
            end)
        end)
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if Options.AttackToggle.Value then
        activateTools()
    end
end)

AttackToggle:OnChanged(function()
end)

OneHitToggle:OnChanged(function()
end)

-- ======================================== Self weapon =====================================================

local AttackSection = Tabs.Self:AddSection(">> Weapon <<")

local function getFolderNamesFromInventory()
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    local folders = {}
    
    if inventory then
        for _, folder in pairs(inventory:GetChildren()) do
            if folder:IsA("Folder") then
                table.insert(folders, folder.Name)
            end
        end
    end
    return folders
end

local function findToolInBackpack(folderName)
    local backpack = LocalPlayer.Backpack
    local inventory = LocalPlayer:FindFirstChild("Inventory")
    
    local success, result = pcall(function()
        if inventory and inventory:FindFirstChild(folderName) then
            for _, item in pairs(backpack:GetChildren()) do
                if inventory[folderName]:FindFirstChild(item.Name) then
                    return item.Name
                end
            end
        end
        return nil
    end)
    
    if not success then
        return nil
    end
    return result
end

local Dropdown = Tabs.Self:AddDropdown("SelectFolder", {
    Title = "Select Weapon",
    Values = getFolderNamesFromInventory(),
    Multi = false,
    Default = nil,
    Callback = function(folderName)
        if folderName then
            local selectedTool = findToolInBackpack(folderName)
            if selectedTool then
                _G.Weapon = selectedTool
                if _G.AutoEquipped and LocalPlayer.Character then
                    pcall(function()
                        local tool = LocalPlayer.Backpack:FindFirstChild(selectedTool)
                        if tool then
                            LocalPlayer.Character.Humanoid:EquipTool(tool)
                        end
                    end)
                end
            else
                _G.Weapon = nil
            end
        else
            _G.Weapon = nil
        end
    end
})

local function updateDropdownValues()
    local newValues = getFolderNamesFromInventory()
    Dropdown:SetValues(newValues)
end

local AutoEquipToggle = Tabs.Self:AddToggle("AutoEquipToggle", {
    Title = "Auto Equip Weapon",
    Default = false,
    Callback = function(state)
        _G.AutoEquipped = state
        if state and _G.Weapon then
            pcall(function()
                local tool = LocalPlayer.Backpack:FindFirstChild(_G.Weapon)
                if tool and LocalPlayer.Character then
                    LocalPlayer.Character.Humanoid:EquipTool(tool)
                end
            end)
        end
    end
})

spawn(function()
    while true do
        if _G.AutoEquipped and _G.Weapon then
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    local tool = LocalPlayer.Backpack:FindFirstChild(_G.Weapon)
                    if tool and tool.Parent ~= LocalPlayer.Character then
                        LocalPlayer.Character.Humanoid:EquipTool(tool)
                    end
                end
            end)
        end
        wait(.1)
    end
end)

LocalPlayer.CharacterAdded:Connect(function(character)
    if _G.AutoEquipped and _G.Weapon then
        wait(.1)
        pcall(function()
            local tool = LocalPlayer.Backpack:FindFirstChild(_G.Weapon)
            if tool then
                character.Humanoid:EquipTool(tool)
            end
        end)
    end
end)

LocalPlayer:WaitForChild("Inventory").ChildAdded:Connect(function(child)
    if child:IsA("Folder") then
        updateDropdownValues()
    end
end)
LocalPlayer:WaitForChild("Inventory").ChildRemoved:Connect(function(child)
    if child:IsA("Folder") then
        updateDropdownValues()
    end
end)

_G.AutoEquipped = false
_G.Weapon = nil

-- ======================================== Auto Equip Weapon All ==============================================

local EquipWeaponToggle = Tabs.Self:AddToggle("EquipWeaponToggle", {
    Title = "Auto Equip Weapon All",
    Default = false
})
Options.EquipWeaponToggle = EquipWeaponToggle

local function equipAllWeapon()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local backpack = player:FindFirstChild("Backpack")
    
    if character and backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                tool.Parent = character
            end
        end
    end
end
spawn(function()
    while true do
        if Options.EquipWeaponToggle.Value then
            equipAllWeapon()
        end
        task.wait(0.1)
    end
end)

game.Players.LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.2)
    if Options.EquipWeaponToggle.Value then
        equipAllWeapon()
    end
end)

EquipWeaponToggle:OnChanged(function()
    if Options.EquipWeaponToggle.Value then
        equipAllWeapon()
    end
end)

-- ================================================================================
-- Server
-- ================================================================================

local ServerSection = Tabs.Server:AddSection(">> Server <<")

Tabs.Server:AddButton{
    Title = "Server ID",
    Description = "แสดงและคัดลอก Server ID",
    Callback = function()
        Window:Dialog{
            Title = "Server ID",
            Content = "Server ID: " .. ServerId,
            Buttons = {
                {
                    Title = "Copy📋",
                    Callback = function()
                        setclipboard(ServerId)
                    end
                },
                {
                    Title = "Close❌",
                    Callback = function()
                    end
                }
            }
        }
    end
}

local Input = Tabs.Server:AddInput("ServerJoin", {
    Title = "Join Server",
    Default = "",
    Placeholder = "Enter Server ID here",
    Numeric = false,
    Finished = true, 
    Callback = function(ServerId)
        TeleportService:TeleportToPlaceInstance(PlaceId, ServerId, game.Players.LocalPlayer)
    end
})

Input:OnChanged(function()
end)

local ServerSection = Tabs.Server:AddSection(">> Fake All <<")

local CoinsInput = Tabs.Server:AddInput("Coins Input", {
    Title = "Coins",
    Default = tostring(data.Coins.Value),
    Placeholder = "Enter Coins Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Coins.Value = tonumber(Value) 
    end
})

CoinsInput:OnChanged(function()
end)

local DefenceInput = Tabs.Server:AddInput("Defence Input", {
    Title = "Defence",
    Default = tostring(data.Defence.Value),
    Placeholder = "Enter Defence Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Defence.Value = tonumber(Value) 
    end
})

DefenceInput:OnChanged(function()
end)

local ExpInput = Tabs.Server:AddInput("Exp Input", {
    Title = "Exp",
    Default = tostring(data.Exp.Value),
    Placeholder = "Enter Exp Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Exp.Value = tonumber(Value)
    end
})

ExpInput:OnChanged(function()
end)

local LevelsInput = Tabs.Server:AddInput("Levels Input", {
    Title = "Levels",
    Default = tostring(data.Levels.Value),
    Placeholder = "Enter Levels Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Levels.Value = tonumber(Value)
    end
})

LevelsInput:OnChanged(function()
end)

local MeleeInput = Tabs.Server:AddInput("Melee Input", {
    Title = "Melee",
    Default = tostring(data.Melee.Value),
    Placeholder = "Enter Melee Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Melee.Value = tonumber(Value)
    end
})

MeleeInput:OnChanged(function()
end)

local PointInput = Tabs.Server:AddInput("Point Input", {
    Title = "Point",
    Default = tostring(data.Point.Value),
    Placeholder = "Enter Point Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Point.Value = tonumber(Value)
    end
})

PointInput:OnChanged(function()
end)

local PowerInput = Tabs.Server:AddInput("Power Input", {
    Title = "Power",
    Default = tostring(data.Power.Value),
    Placeholder = "Enter Power Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Power.Value = tonumber(Value)
    end
})

PowerInput:OnChanged(function()
end)

local SetSpawnInput = Tabs.Server:AddInput("SetSpawn Input", {
    Title = "SetSpawn",
    Default = tostring(data.SetSpawn.Value),
    Placeholder = "Enter SetSpawn Value",
    Numeric = false,
    Finished = true,
    Callback = function(Value)
        data.SetSpawn.Value = (Value:lower() == "true")
    end
})

SetSpawnInput:OnChanged(function()
end)

local SpritInput = Tabs.Server:AddInput("Sprit Input", {
    Title = "Sprit",
    Default = tostring(data.Sprit.Value),
    Placeholder = "Enter Sprit Value",
    Numeric = true,
    Finished = true, 
    Callback = function(Value)
        data.Sprit.Value = tonumber(Value) 
    end
})

SpritInput:OnChanged(function()
end)

local SwordInput = Tabs.Server:AddInput("Sword Input", {
    Title = "Sword",
    Default = tostring(data.Sword.Value),
    Placeholder = "Enter Sword Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Sword.Value = tonumber(Value)
    end
})

SwordInput:OnChanged(function()
end)

local WaterInput = Tabs.Server:AddInput("Water Input", {
    Title = "Water",
    Default = tostring(data.Water.Value),
    Placeholder = "Enter Water Value",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        data.Water.Value = tonumber(Value)
    end
})

WaterInput:OnChanged(function()
end)

-- ================================== copy =======================================================

local ServerSection = Tabs.Server:AddSection(">> Clone Outfit <<")

local originalOutfit = {}
local selectedPlayer = nil
local Dropdown = nil

local function SaveOriginalOutfit()
    originalOutfit = {}

    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic")
            or item:IsA("CharacterMesh") or item:IsA("BodyColors") then
            table.insert(originalOutfit, item:Clone())
        end
    end
end

local function RestoreOriginalOutfit()
    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic")
            or item:IsA("CharacterMesh") or item:IsA("BodyColors") then
            item:Destroy()
        end
    end

    for _, item in pairs(originalOutfit) do
        item:Clone().Parent = LocalPlayer.Character
    end
end

local function ResetToDefaultStarterOutfit()
    LocalPlayer:LoadCharacter()
end

local function CopyFullOutfitFromPlayer(targetName)
    local targetPlayer = Players:FindFirstChild(targetName)
    if not targetPlayer or not targetPlayer.Character then
        return
    end

    for _, item in pairs(LocalPlayer.Character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic")
            or item:IsA("CharacterMesh") or item:IsA("BodyColors") then
            item:Destroy()
        end
    end

    for _, item in pairs(targetPlayer.Character:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Shirt") or item:IsA("Pants") or item:IsA("ShirtGraphic")
            or item:IsA("CharacterMesh") or item:IsA("BodyColors") then
            item:Clone().Parent = LocalPlayer.Character
        end
    end
end

local function RefreshPlayerList()
    local names = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(names, plr.Name)
        end
    end

    if #names > 0 then
        selectedPlayer = names[1]
        Dropdown:SetValues(names)
        Dropdown:SetValue(selectedPlayer)
    else
        selectedPlayer = "ไม่มีผู้เล่น"
        Dropdown:SetValues({"ไม่มีผู้เล่น"})
        Dropdown:SetValue("ไม่มีผู้เล่น")
    end
end

Dropdown = Tabs.Server:AddDropdown("PlayerDropdown", {
    Title = "เลือกผู้เล่น",
    Values = {"ไม่มีผู้เล่น"},
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Value)
    selectedPlayer = Value
end)

RefreshPlayerList()

Tabs.Server:AddButton{
    Title = "ก็อปชุดทั้งหมด",
    Description = "คัดลอกชุดของผู้เล่นที่เลือก",
    Callback = function()
        if selectedPlayer == nil or selectedPlayer == "ไม่มีผู้เล่น" then return end

        Window:Dialog{
            Title = "ยืนยัน",
            Content = "คุณต้องการก็อปปี้ชุดของ " .. selectedPlayer .. " ใช่ไหม?",
            Buttons = {
                {
                    Title = "ยืนยัน",
                    Callback = function()
                        SaveOriginalOutfit()
                        CopyFullOutfitFromPlayer(selectedPlayer)
                    end
                },
                {
                    Title = "ยกเลิก",
                    Callback = function()
                        print("ยกเลิกการก็อป")
                    end
                }
            }
        }
    end
}

Tabs.Server:AddButton{
    Title = "รีเฟรชชื่อผู้เล่น",
    Description = "อัปเดตรายชื่อผู้เล่นใหม่",
    Callback = function()
        RefreshPlayerList()
    end
}

-- ======================================== Tp Boat ==============================================

local boatFolder = workspace:WaitForChild("Boat")
local boatNames = {}
local SelectedBoatName = nil
local Dropdown = nil

local function UpdateBoatList()
    boatNames = {}
    for _, boat in pairs(boatFolder:GetChildren()) do
        if boat:IsA("Model") then
            table.insert(boatNames, boat.Name)
        end
    end

    if Dropdown then
        Dropdown:SetValues(boatNames)
        SelectedBoatName = boatNames[1]
    end
end

Dropdown = Tabs.Main:AddDropdown("BoatDropdown", {
    Title = "Select Boat",
    Values = boatNames,
    Multi = false,
    Default = 1,
})

Dropdown:OnChanged(function(Value)
    SelectedBoatName = Value
end)

Tabs.Main:AddButton{
    Title = "Update Boat List",
    Description = "Refresh the list of available boats",
    Callback = function()
        UpdateBoatList()
    end
}

Tabs.Main:AddButton{
    Title = "Bring Selected Boat",
    Description = "Bring the selected boat to your character",
    Callback = function()
        if not SelectedBoatName then
            return
        end

        local boat = boatFolder:FindFirstChild(SelectedBoatName)
        if boat and boat:IsA("Model") then
            if not boat.PrimaryPart then
                boat.PrimaryPart = boat:FindFirstChildWhichIsA("BasePart")
            end
            if boat.PrimaryPart then
                boat:SetPrimaryPartCFrame(CFrame.new(rootPart.Position + Vector3.new(5, 0, 0)))
            end
        end
    end
}

Tabs.Main:AddButton{
    Title = "Bring All Boats",
    Description = "Move all boats near your character",
    Callback = function()
        local offset = 0
        for _, boat in pairs(boatFolder:GetChildren()) do
            if boat:IsA("Model") then
                if not boat.PrimaryPart then
                    boat.PrimaryPart = boat:FindFirstChildWhichIsA("BasePart")
                end
                if boat.PrimaryPart then
                    boat:SetPrimaryPartCFrame(CFrame.new(rootPart.Position + Vector3.new(offset, 0, 10)))
                    offset += 10
                end
            end
        end
    end
}

UpdateBoatList()

Options.AutoFarmToggle:SetValue(false)
Options.AutoDunToggle:SetValue(false)
Options.AutoClickToggle:SetValue(false)
Options.AttackToggle:SetValue(false)
Options.OneHitToggle:SetValue(false)
Options.EquipWeaponToggle:SetValue(false)
Options.AutoEquipToggle:SetValue(false)
