-- Check out my GitHub! https://github.com/P3nguinMinecraft/WizardSimulatorGUI/

print("[WSG] Loading Wizard Simulator GUI")


getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- local vars
local Player = game:GetService("Players").LocalPlayer
local Humanoid = Player.Character:WaitForChild("Humanoid")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local SpellState = 1
local SelectedQuest = "LJ:1"
local AutoQuestToggle = false
local WalkspeedToggleOld = false
local WalkspeedToggle = false
local Walkspeed = 16
local JumpPowerToggle = false
local JumpPower = 50
local HPot, MPot
local HealthPercentage = Humanoid.Health / Humanoid.MaxHealth * 100
local PreviousMana, Mana, MaxMana, ManaPercentage
local AutoHealthToggle = false
local AutoManaToggle = false
local AutoHealthThreshold = 0
local AutoManaThreshold = 0
local AutoFarm = false
local AutoFarmQuest = false
local AutoFarmEnemyName = "Dummy"
local AutoFarmDelay = 2.2
local AutoFarmToggle = false
local SpellRange = 100

print("[WSG] Loading Window")

local Window = Rayfield:CreateWindow({
   Name = "Wizard Simulator",
   LoadingTitle = "Wizard Simulator GUI",
   LoadingSubtitle = "by penguin",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "wizardsimulatorgui", -- Create a custom folder for your hub/game
      FileName = "wizardsimulator_config"
   },
   Discord = { 
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = false -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key wiCH be saved, but if you change the key, they wiCH be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"HeCHo"} -- List of keys that wiCH be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("heCHo","key22")
   }
})

print("[WSG] Loading Info Tab")

local CreditTab = Window:CreateTab("Info", nil) -- Title, Image

local CreditLabel1 = CreditTab:CreateLabel("Developed by penguin586970")

local CreditLabel2 = CreditTab:CreateLabel("Executor used: MacSploit (not affiliated!)")

local CreditLabel3 = CreditTab:CreateLabel("For questions, concerns, contact windows1267 on discord")

print("[WSG] Loading Quest Tab")

local QuestTab = Window:CreateTab("Quest", nil) -- Title, Image

local QuestParagraph1 = QuestTab:CreateParagraph({Title = "Quest Manipulation", Content = "Give yourself quests with this function, no matter the distance and level you are! DO NOT SPAM THESE REMOTES! NOTE THAT THERE IS A SMALL COOLDOWN BETWEEN FINISHING AND RECEIVING A QUEST."})

local QuestDropdown1 = QuestTab:CreateDropdown({
   Name = "Select Quest",
   Options = {
      "LJ:1","LJ:2","LJ:3","LJ:4","LJ:5","LJ:6","LJ:7","LJ:8",
      "BT:1","BT:2","BT:3","BT:4","BT:5","BT:6","BT:7","BT:8","BT:9",
      "CH:1","CH:2","CH:3","CH:4","CH:5","CH:6","CH:7","CH:8",
      "LP:1","LP:2","LP:3","LP:4","LP:5","LP:6","LP:7","LP:8","LP:9","LP:10","LP:11","LP:12","LP:13",
      "WS:1","WS:2","WS:3","WS:4","WS:5","WS:6","WS:7","WS:8","WS:9","WS:10","WS:11",
      "OM:1","OM:2","OM:3","OM:4","OM:5","OM:6","OM:7","OM:8","OM:9","OM:10","OM:11",
      "VB:1","VB:2","VB:3","VB:4","VB:5","VB:6","VB:7","VB:8","VB:9","VB:10",
      "VD:1","VD:2","VD:3","VD:4","VD:5","VD:6","VD:7",
      "CJ:1","CJ:2","CJ:3","CJ:4","CJ:5","CJ:6","CJ:7","CJ:8","CJ:9","CJ:10","CJ:11"
   },
   CurrentOption = {"LJ:1"},
   MultipleOptions = false,
   Flag = "QuestDropdown1",
   Callback = function(Option)
      SelectedQuest = Option[1]
   end,
})

local QuestButton1 = QuestTab:CreateButton({
   Name = "Give Quest",
   Callback = function()
if SelectedQuest[1] then
         game:GetService("ReplicatedStorage").Remote.AcceptQuest:FireServer(SelectedQuest)
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "No quest selected! How did this happen?",
            Duration = 5,
            Image = nil,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "OK",
                  Callback = function()
               end
               },
            },
         })
      end
   end,
})

local QuestButton2 = QuestTab:CreateButton({
   Name = "Cancel Quest",
   Callback = function()
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CancelQuest"):FireServer()
   end,
})

local QuestToggle1 = QuestTab:CreateToggle({
   Name = "Auto Give Quest",
   CurrentValue = false,
   Flag = "QuestToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoQuestToggle = Value
   end,
})

local QuestParagraph2 = QuestTab:CreateParagraph({Title = "Auto Give", Content = "CJ:4 is Kill 1 Training Dummy (in Training World) but gives a ton of XP and Gold, useful for super fast progression in all game stages. Auto Give CJ:4 Quest function automatically gives you the quest whenever you press E or Q (assuming you one shot Dummies)."})

print("[WSG] Loading Potion Tab")

local PotionTab = Window:CreateTab("Potion", nil) -- Title, Image

local PotionParagraph1 = PotionTab:CreateParagraph({Title = "Potion Triggers", Content = "Click on the buttons to pick up a potion in the world (if avaliable) Use Auto Health/Mana to automatically pick up potions when value falls below threshold."})

local PotionParagraph2 = PotionTab:CreateParagraph({Title = "Replenish Rates", Content = "HP from Enemy Kill: 50%, HP from Spell: 25%, Mana: 30%. Replenish rate of potions spawned from enemy kills are RELATIVE to the player who killed the enemy's MAX HP/MANA."})

local PotionSection1 = PotionTab:CreateSection("Health")

local PotionButton1 = PotionTab:CreateButton({
   Name = "Get Health Potion",
   Callback = function()
      if HPot then firetouchinterest(Humanoid.LeftLeg, HPot.Forcefield, 0) end
   end,
})

local PotionToggle1 = PotionTab:CreateToggle({
   Name = "Auto Health",
   CurrentValue = false,
   Flag = "PotionToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoHealthToggle = Value
   end,
})

local PotionSlider1 = PotionTab:CreateSlider({
   Name = "Auto Health Threshold",
   Range = {0, 100},
   Increment = 1,
   Suffix = "% HP",
   CurrentValue = 50,
   Flag = "PotionSlider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoHealthThreshold = Value
   end,
})


local PotionSection2 = PotionTab:CreateSection("Mana")

local PotionButton2 = PotionTab:CreateButton({
   Name = "Get Mana Potion",
   Callback = function()
      if MPot then firetouchinterest(Humanoid.LeftLeg, MPot.Forcefield, 0) end
   end,
})

local PotionToggle2 = PotionTab:CreateToggle({
   Name = "Auto Mana",
   CurrentValue = false,
   Flag = "PotionToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoManaToggle = Value
   end,
})

local PotionSlider2 = PotionTab:CreateSlider({
   Name = "Auto Mana Threshold",
   Range = {0, 100},
   Increment = 1,
   Suffix = "% Mana",
   CurrentValue = 70,
   Flag = "PotionSlider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoManaThreshold = Value
   end,
})

print("[WSG] Loading Auto Farm Tab")

local AutoFarmTab = Window:CreateTab("Auto Farm", nil) -- Title, Image

local AutoFarmParagraph1 = AutoFarmTab:CreateParagraph({Title = "Auto Farm Function", Content = "Automatically farms an enemy, targetting the closest one that is within range of the spell chosen. Configure other settings below."})

local AutoFarmToggle1 = AutoFarmTab:CreateToggle({
   Name = "Auto Farm Toggle",
   CurrentValue = false,
   Flag = "AutoFarmToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoFarmToggle = Value
   end,
})

local AutoFarmSection1 = AutoFarmTab:CreateSection("Settings")

local AutoFarmDropdown1 = AutoFarmTab:CreateDropdown({
   Name = "Enemy Selection",
   Options = {
      "Dummy","DummyWarrior","DummyArcher","DummySpearman","DummyWizard",
      "GreenSlime","BigSlime","Spider","GiantSpider",
      "Wolf","Werewolf","Bear",
      "BeachCrab","RockCrab","Clam",
      "Jellyfish","IceJellyfish",
      "GreenPirate","RedPirate",
      "MagmaSlime","GiantMagmaSlime",
      "FireAnt","GiantFireAnt",
      "MagmaCrab","MagmaSpider","MagmaScorpion","Worm",
      "DummyKnight","DummyArcher2","DummySpearman2",
      "SmallWasp","Wasp",
      "SmallTreant","Treant",
      "RockScorpion","RockTitan",
      "SmallJello","Cupcake","Donut","BigJello","GummyWorm",
      "GingerbreadSoldier","GingerbreadWizard"},
   CurrentOption = {"Dummy"},
   MultipleOptions = false,
   Flag = "AutoFarmDropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
      AutoFarmEnemyName = Option[1]
   end,
})

local AutoFarmParagraph2 = AutoFarmTab:CreateParagraph({Title = "Spell Delay", Content = "Spell Delay is the amount of time to cycle through ONE of your spells plus some room because of staff cast animation delay. However, you should have the same spell in BOTH SLOTS."})

local AutoFarmSlider1 = AutoFarmTab:CreateSlider({
   Name = "Spell Delay",
   Range = {0, 10},
   Increment = 0.1,
   Suffix = "sec",
   CurrentValue = 2.2,
   Flag = "AutoFarmSlider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoFarmDelay = Value
   end,
})

local AutoFarmParagraph3 = AutoFarmTab:CreateParagraph({Title = "Spell Range", Content = "Spell Range is the range of a certain spell (in studs) required to be able to hit an enemy. Just guess and check because the algorithm targets the closest enemy. I might code a function to help you determine range, or just a list."})

local AutoFarmSlider2 = AutoFarmTab:CreateSlider({
   Name = "Spell Range",
   Range = {0, 200},
   Increment = 1,
   Suffix = "studs",
   CurrentValue = 100,
   Flag = "AutoFarmSlider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      SpellRange = Value
   end,
})

local AutoFarmParagraph4 = AutoFarmTab:CreateParagraph({Title = "Auto Farm Quest", Content = "This only auto gives the CJ:4 quest for when you auto farm Dummy. AFAIK this is the fastest grind method for XP and coins (correct me if I'm wrong) This is a replacement for Auto Give Quest (so turn it off). Fastest spell delay time is 2.2sec to make the quest register correctly."})

local AutoFarmToggle2 = AutoFarmTab:CreateToggle({
   Name = "Auto Farm Quest",
   CurrentValue = false,
   Flag = "AutoFarmToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoFarmQuest = Value
   end,
})

print("[WSG] Loading Tools Tab")

local ToolTab = Window:CreateTab("Tools", nil) -- Title, Image

local ToolParagraph1 = ToolTab:CreateParagraph({Title = "Small Things", Content = "These are probably availiable in other universal scripts but I find it easy to access here"})

local ToolLabel1 = ToolTab:CreateLabel("Walkspeed might break mounts but idk")

local ToolToggle1 = ToolTab:CreateToggle({
   Name = "Walkspeed Toggle",
   CurrentValue = false,
   Flag = "ToolToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      WalkspeedToggle = Value
   end,
})

local ToolSlider1 = ToolTab:CreateSlider({
   Name = "Walkspeed",
   Range = {0, 100},
   Increment = 1,
   Suffix = "Studs/Sec",
   CurrentValue = 16,
   Flag = "ToolSlider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      Walkspeed = Value
   end,
})

local ToolToggle2 = ToolTab:CreateToggle({
   Name = "Jump Power Toggle",
   CurrentValue = false,
   Flag = "ToolToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      JumpPowerToggle = Value
   end,
})

local ToolSlider2 = ToolTab:CreateSlider({
   Name = "Jump Power",
   Range = {0, 200},
   Increment = 1,
   Suffix = "Studs",
   CurrentValue = 50,
   Flag = "ToolSlider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      JumpPower = Value
   end,
})

local ToolSection1 = ToolTab:CreateSection("Universal Scripts")

local ToolButton1 = ToolTab:CreateButton({
   Name = "Infinite Yield",
   Callback = function()
      loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() -- Credit: Infinite Yield
   end,
})

local ToolButton2 = ToolTab:CreateButton({
   Name = "Remote Spy",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))() -- Credit: SimpleSpy v3
   end,
})

local ToolButton3 = ToolTab:CreateButton({
   Name = "Orca",
   Callback = function()
      loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"))() -- Credit: orca
   end,
})

local ToolButton4 = ToolTab:CreateButton({
   Name = "CMD-X",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))() -- Credit: CMD-X
   end,
})

local ToolButton5 = ToolTab:CreateButton({
   Name = "Dex",
   Callback = function()
      loadstring(game:HttpGet('https://ithinkimandrew.site/scripts/tools/dark-dex.lua'))()
   end,
})

print("[WSG] Loading Scripts")

-- input detector
UserInputService.InputBegan:Connect(function(input)
   if AutoQuestToggle then
      if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Q then
         game:GetService("ReplicatedStorage").Remote.AcceptQuest:FireServer("CJ:4")
      end
   end
end)


-- walkspeed and jumppower management
spawn(function()
   while wait(0.1) do
      if WalkspeedToggleOld == true and WalkspeedToggle == false then
         Humanoid.WalkSpeed = 16
      end
      if WalkspeedToggle then
         Humanoid.WalkSpeed = Walkspeed
      end
      if JumpPowerToggleOld == true and JumpPowerToggle ==false then
         Humanoid.JumpPower = 50
      end
      if JumpPowerToggle then
         Humanoid.JumpPower = JumpPower
      end
      WalkspeedToggleOld = WalkspeedToggle
      JumpPowerToggleOld = JumpPowerToggle
   end
end)


-- health detector
Humanoid.HealthChanged:Connect(function()
    HealthPercentage = Humanoid.Health / Humanoid.MaxHealth * 100
    print(HealthPercentage)
end)


-- mana detector
spawn(function()
   while wait(0.1) do
      Mana = Player.Mana.value
      MaxMana = Player.MaxMana.value
      if PreviousMana ~= Mana then
         ManaPercentage = Mana / MaxMana * 100
      end
      PreviousMana = Mana
   end
end)


-- auto potion loop
spawn(function()
   while wait(0.1) do
      local success1 = pcall(function()
         HPot = Workspace.Effects:FindFirstChild("HealthPotion")
      end)
      local success2 = pcall(function()
         MPot = Workspace.Effects:FindFirstChild("ManaPotion")
      end)
      if HPot then
         PotionButton1:Set("Get Health Potion - Avaliable")
      else
         PotionButton1:Set("Get Health Potion - Unavaliable")
      end
      if MPot then
         PotionButton2:Set("Get Mana Potion - Avaliable")
      else
         PotionButton2:Set("Get Mana Potion - Unavaliable")
      end
      if AutoHealthToggle == true and HealthPercentage < AutoHealthThreshold then
         if HPot then firetouchinterest(Humanoid.LeftLeg, HPot.Forcefield, 0) end
      end
      if AutoManaToggle == true and ManaPercentage < AutoManaThreshold then
         if MPot then firetouchinterest(Humanoid.LeftLeg, MPot.Forcefield, 0) end
      end
   end
end)


-- autofarm
spawn(function()
   while wait(AutoFarmDelay/2) do
      local PlayerPos = Player.Character.PrimaryPart and Player.Character.PrimaryPart.Position
      if PlayerPos and AutoFarmToggle then
         local Distances = {}  
         local ClosestEnemy = nil
         local ClosestDistance = math.huge -- big number go boom

         for i, LevelFolder in ipairs(Workspace.Levels:GetChildren()) do
            local EnemiesFolder = LevelFolder:FindFirstChild("Enemies")
            if EnemiesFolder then
               for j, Enemy in ipairs(EnemiesFolder:GetChildren()) do
                  if Enemy.Name == AutoFarmEnemyName then
                     local EnemyPos = Enemy.PrimaryPart and Enemy.PrimaryPart.Position
                     if EnemyPos then
                        local Distance = (PlayerPos - EnemyPos).magnitude
                        table.insert(Distances, Distance)

                        if Distance < ClosestDistance then
                           ClosestEnemy = Enemy
                           ClosestDistance = Distance
                        end
                     end
                  end
               end
            end
         end
         if (#Distances > 0) then
            table.sort(Distances)
            --print("Distances to Enemies:\n", table.concat(Distances, "\n"))
         end

         if ClosestEnemy and ClosestDistance < SpellRange then
            if AutoFarmQuest then
               game:GetService("ReplicatedStorage").Remote.AcceptQuest:FireServer("CJ:4")
            end
            game:GetService("ReplicatedStorage").Remote.CastSpell:FireServer(SpellState, ClosestEnemy)
            SpellState = SpellState == 1 and 2 or 1 -- toggle between 1 and 2
         end
      end
   end
end)

print("[WSG] Loaded!")
