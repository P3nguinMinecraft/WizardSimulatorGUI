-- Check out my GitHub! https://github.com/P3nguinMinecraft/WizardSimulatorGUI/
-- game:GetService("Players").LocalPlayer.Character.PrimaryPart.Position = {898.3, 4, -399} works best with autofarm dummy so you won't be seen (using fly and noclip)

print("[WSG] Loading Wizard Simulator GUI")


getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- local vars
local Player = game:GetService("Players").LocalPlayer
local Humanoid = Player.Character:WaitForChild("Humanoid")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local PickupGuiContainer = game:GetService("Players").LocalPlayer.PlayerGui.GameGui.Pickup
local SpellState = 1
local SelectedPet = 0
local PetSlotOptions = {
   [1] = "Main",
   [2] = "Secondary (gamepass)",
   [3] = "Mount"
}
local SelectedPetSlotName
local SelectedPetSlot = 1
local DeletePetLock = false
local DeletePetLockOld = false
local ChestOptions = {
   ["Chest1"] = "Training Area Chest",
   ["Chest2"] = "Werewolf Chest",
   ["Chest3"] = "Deep Seas Chest",
   ["Chest4"] = "Magma Chest",
   ["Chest5"] = "Castle Chest",
   ["Chest6"] = "Candy Chest",
   ["CheapMountChest"] = "Cheap Mount Chest",
   ["MountChest"] = "Mount Chest"
}
local SelectedChestName = "Training Area Chest"
local SelectedChest = "Chest1"
local AutoRerollToggle = false
local SelectedQuest = "LJ:1"
local AutoQuestToggle = false
local TrackGold = false
local TrackXP = false
local HPot, MPot
local HealthPercentage = Humanoid.Health / Humanoid.MaxHealth * 100
local PreviousMana, Mana, MaxMana, ManaPercentage
local AutoHealthToggle = false
local AutoManaToggle = false
local AutoHealthThreshold = 0
local AutoManaThreshold = 0
local AutoFarmToggle = false
local AutoFarmEnemyOptions = {
   ["Dummy"] = "[1] Training Dummy",
   ["DummyWarrior"] = "[3] Dummy Warrior",
   ["DummyArcher"] = "[6] Dummy Archer",
   ["DummySpearman"] = "[8] Dummy Spearman",
   ["DummyWizard"] = "[12] Dummy Wizard",
   ["EarthGolem"] = "[24] Earth Golem",
   ["Stone3"] = "[24] Summoned Earth Rock",
   ["DummyKing"] = "Dummy King",
   ["GreenSlime"] = "[12] Green Slime",
   ["BigSlime"] = "[17] Giant Green Slime",
   ["Spider"] = "[15] Spider",
   ["GiantSpider"] = "[20] Big Spider",
   ["Wolf"] = "[22] Wolf",
   ["Werewolf"] = "[25] Werewolf",
   ["Bear"] = "[26] Bear",
   ["StoneGolem"] = "[32] Stone Golem",
   ["Stone1"] = "[32] Summoned Rock",
   ["Lumberjack"] = "Lumberjack",
   ["GiantWerewolf"] = "Lumberjack? (Werewolf)",
   ["BeachCrab"] = "[28] Beach Crab",
   ["Clam"] = "[30] Clam",
   ["RockCrab"] = "[32] Rock Crab",
   ["Jellyfish"] = "[35] Jellyfish",
   ["IceJellyfish"] = "[36] Ice Jellyfish",
   ["GreenPirate"] = "[38] Green Pirate",
   ["RedPirate"] = "[39] Red Pirate",
   ["WaterGolem"] = "[42] Water Golem",
   ["Stone4"] = "[42] Summoned Water Rock",
   ["KingPirate"] = "Pirate King",
   ["MagmaSlime"] = "[40] Magma Slime",
   ["GiantMagmaSlime"] = "[43] Giant Magma Slime",
   ["FireAnt"] = "[43] Fire Ant",
   ["GiantFireAnt"] = "[46] Giant Fire Ant",
   ["MagmaCrab"] = "[48] Magma Crab",
   ["MagmaSpider"] = "[49] Magma Spider",
   ["MagmaScorpion"] = "[51] Magma Scorpion",
   ["Worm"] = "[53] Magma Worm",
   ["MagmaGolem"] = "[54] Magma Golem",
   ["Stone2"] = "[54] Summoned Magma Rock",
   ["MagmaKing"] = "Magma King",
   ["MagmaEater"] = "Magma Eater",
   ["DummyKnight"] = "[58] Elite Dummy Knight",
   ["DummyArcher2"] = "[60] Elite Dummy Archer",
   ["DummySpearman2"] = "[62] Elite Dummy Spearman",
   ["SmallWasp"] = "[64] Wasp",
   ["Wasp"] = "[66] Giant Wasp",
   ["SmallTreant"] = "[66] Stumpant",
   ["Treant"] = "[68] Treant",
   ["RockScorpion"] = "[69] Rock Scorpion",
   ["RockTitan"] = "[71] Rock Titan",
   ["SmallJello"] = "[74] Small Jello",
   ["Cupcake"] = "[75] Cupcake",
   ["Donut"] = "[77] Donut",
   ["BigJello"] = "[78] Big Jello",
   ["GummyWorm"] = "[80] Gummy Worm",
   ["GingerbreadSoldier"] = "[81] Gingerbread Soldier",
   ["GingerbreadWizard"] = "[82] Gingerbread Wizard",
   ["CandyGolem"] = "[84] Candy Golem",
   ["StaticWaypoint"] = "Candy Chomper (also targets gates)"
}
local AutoFarmEnemyNames = {"[1] Training Dummy"}
local AutoFarmEnemies = {"Dummy"}
local AutoFarmTarget = "Closest"
local AutoFarmDelay = 2.2
local AutoFarmQuestToggle = false
local AutoRechargeToggle = false
local SpellRange = 100
local TrackedGold = 0
local TrackedXP = 0
local Multipliers = {
   K = 1000, -- Thousand
   M = 1000000, -- Million
   B = 1000000000, -- Billion
}
local TrackedElements = {}
local WalkspeedToggleOld = false
local WalkspeedToggle = false
local Walkspeed = 16
local JumpPowerToggle = false
local JumpPower = 50

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
      Key = {"random"} -- List of keys that wiCH be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("heCHo","key22")
   }
})

print("[WSG] Loading Info Tab")

local CreditTab = Window:CreateTab("Info", nil) -- Title, Image

local CreditLabel1 = CreditTab:CreateLabel("Developed by penguin586970")

local CreditLabel2 = CreditTab:CreateLabel("Executor used: MacSploit (not affiliated!)")

local CreditLabel3 = CreditTab:CreateLabel("For questions, concerns, contact windows1267 on discord")

print("[WSG] Loading QOL Tab")

local QOLTab = Window:CreateTab("QOL", nil) -- Title, Image

local QOLSection1 = QOLTab:CreateSection("Pets")

local QOLInput1 = QOLTab:CreateInput({
   Name = "Select Pet",
   PlaceholderText = "Order in the Pet Menu",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      if tonumber(Text) ~= nil and tonumber(Text) > 0 then
         SelectedPet = tonumber(Text)
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Has to be a positive integer",
            Duration = 5,
            Image = nil,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "Debug",
                  Callback = function()
                     print("Inputted Text is:")
                     print(Text)
                  end
               },
            },
         })
      end
   end,
})

local QOLParagraph1 = QOLTab:CreateParagraph({Title = "Equip/Unequip Pets", Content = "Enter the pet number, or the order of the pet when it appears in the pet menu."})

local QOLDropdown1 = QOLTab:CreateDropdown({
   Name = "Pet Slot",
   Options = PetSlotOptions,
   CurrentOption = PetSlotOptions[1],
   MultipleOptions = false,
   Flag = "QOLDropdown1",
   Callback = function(Option)
      SelectedPetSlotName = Option[1]
      for i, v in pairs(PetSlotOptions) do
         if v == SelectedPetSlotName then
            SelectedPetSlot = i
            break
         end
      end
   end,
})

local QOLButton1 = QOLTab:CreateButton({
   Name = "Equip Pet",
   Callback = function()
      if SelectedPet and SelectedPetSlot then 
         game:GetService("ReplicatedStorage").Remote.EquipPet:FireServer(SelectedPet,SelectedPetSlot)
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "Pet Number or Pet Slot missing!",
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

local QOLButton2 = QOLTab:CreateButton({
   Name = "Unequip Pet",
   Callback = function()
      game:GetService("ReplicatedStorage").Remote.EquipPet:FireServer(0,SelectedPetSlot)
   end,
})

local QOLParagraph2 = QOLTab:CreateParagraph({Title = "Delete Pet", Content = "Select the slot you want to delete (in Select Pet Input), after deleting, next pet will move to that slot. There is an extra toggle that is required to delete pets."})

local QOLButton3 = QOLTab:CreateButton({
   Name = "Delete Pet",
   Callback = function()
      if DeletePetLock == true then 
         game:GetService("ReplicatedStorage").Remote.DeletePet:FireServer(SelectedPet)
         if AutoRerollToggle == true then
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("OpenPetChest"):InvokeServer(SelectedChest)
         end
      else
         Rayfield:Notify({
            Title = "Delete Pet Lock",
            Content = "Delete Pet Lock prevented you from deleting SelectedPet. Press the button to disable it for 1 minute.",
            Duration = 5,
            Image = nil,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "Disable Lock",
                  Callback = function()
                     DeletePetLock = true
                  end
               },
            },
         })
      end
   end,
})

local QOLSection2 = QOLTab:CreateSection("Chests")

local QOLDropdown2 = QOLTab:CreateDropdown({
   Name = "Select Chest",
   Options = {
      "Training Area Chest",
      "Werewolf Chest",
      "Deep Seas Chest",
      "Magma Chest",
      "Castle Chest",
      "Candy Chest",
      "Cheap Mount Chest",
      "Mount Chest"
   },
   CurrentOption = "Training Area Chest",
   MultipleOptions = false,
   Flag = "QOLDropdown2",
   Callback = function(Option)
      SelectedChestName = Option[1]
      for i, v in pairs(ChestOptions) do
         if v == SelectedChestName then
            SelectedChest = i
            break
         end
      end
   end,
})

local QOLButton4 = QOLTab:CreateButton({
   Name = "Buy Chest",
   Callback = function()
   print(SelectedChest)
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("OpenPetChest"):InvokeServer(SelectedChest)
   end,
})

local QOLParagraph3 = QOLTab:CreateParagraph({Title = "Auto Reroll", Content = "Automatically buys another chest (selected) after you delete a pet (using Delete Pet button)"})

local QOLToggle1 = QOLTab:CreateToggle({
   Name = "Auto Reroll",
   CurrentValue = false,
   Flag = "QOLToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoRerollToggle = Value
   end,
})

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
      if SelectedQuest then
         game:GetService("ReplicatedStorage").Remote.AcceptQuest:FireServer(SelectedQuest)
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "No quest selected! How did this happen?",
            Duration = 5,
            Image = nil,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "Debug",
                  Callback = function()
                  print('Selected Quest: ')
                  print(SelectedQuest)
               end},
            },
         })
      end
   end,
})

local QuestKeybind1 = QuestTab:CreateKeybind({
   Name = "Keybind", 
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "QuestKeybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
      if SelectedQuest then
            game:GetService("ReplicatedStorage").Remote.AcceptQuest:FireServer(SelectedQuest)
      else
         Rayfield:Notify({
            Title = "Error",
            Content = "No quest selected! How did this happen?",
            Duration = 5,
            Image = nil,
            Actions = { -- Notification Buttons
               Ignore = {
                  Name = "Debug",
                  Callback = function()
                  print('Selected Quest: ')
                  print(SelectedQuest)
               end},
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

local QuestKeybind2 = QuestTab:CreateKeybind({
   Name = "Keybind",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "QuestKeybind2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
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

local PotionKeybind1 = PotionTab:CreateKeybind({
   Name = "Keybind",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "PotionKeybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
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

local PotionKeybind2 = PotionTab:CreateKeybind({
   Name = "Keybind",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "PotionKeybind2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
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

local AutoFarmKeybind1 = AutoFarmTab:CreateKeybind({
   Name = "Keybind",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "AutoFarmKeybind1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Keybind)
      AutoFarmToggle = not AutoFarmToggle
      AutoFarmToggle1:Set(AutoFarmToggle)
      Rayfield:Notify({
         Title = "Auto Farm Keybind",
         Content = AutoFarmToggle,
         Duration = 5,
         Image = nil,
         Actions = { -- Notification Buttons
         },
      })
   end,
})


local AutoFarmSection1 = AutoFarmTab:CreateSection("Settings")

local AutoFarmDropdown1 = AutoFarmTab:CreateDropdown({
   Name = "Enemy Selection",
   Options = {
      "[1] Training Dummy",
      "[3] Dummy Warrior",
      "[6] Dummy Archer",
      "[8] Dummy Spearman",
      "[12] Dummy Wizard",
      "[24] Earth Golem",
      "[24] Summoned Earth Rock",
      "Dummy King",
      "[12] Green Slime",
      "[17] Giant Green Slime",
      "[15] Spider",
      "[20] Big Spider",
      "[22] Wolf",
      "[25] Werewolf",
      "[26] Bear",
      "[32] Stone Golem",
      "[32] Summoned Rock",
      "Lumberjack",
      "Lumberjack? (Werewolf)",
      "[28] Beach Crab",
      "[30] Clam",
      "[32] Rock Crab",
      "[35] Jellyfish",
      "[36] Ice Jellyfish",
      "[38] Green Pirate",
      "[39] Red Pirate",
      "[42] Water Golem",
      "[42] Summoned Water Rock",
      "Pirate King",
      "[40] Magma Slime",
      "[43] Giant Magma Slime",
      "[43] Fire Ant",
      "[46] Giant Fire Ant",
      "[48] Magma Crab",
      "[49] Magma Spider",
      "[51] Magma Scorpion",
      "[53] Magma Worm",
      "[54] Magma Golem",
      "[54] Summoned Magma Rock",
      "Magma King",
      "Magma Eater",
      "[58] Elite Dummy Knight",
      "[60] Elite Dummy Archer",
      "[62] Elite Dummy Spearman",
      "[64] Wasp",
      "[66] Giant Wasp",
      "[66] Stumpant",
      "[68] Treant",
      "[69] Rock Scorpion",
      "[71] Rock Titan",
      "[74] Small Jello",
      "[75] Cupcake",
      "[77] Donut",
      "[78] Big Jello",
      "[80] Gummy Worm",
      "[81] Gingerbread Soldier",
      "[82] Gingerbread Wizard",
      "[84] Candy Golem",
      "Candy Chomper (also targets gates)"
   },
   CurrentOption = {"[1] Training Dummy"},
   MultipleOptions = true,
   Flag = "AutoFarmDropdown1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Options)
      AutoFarmEnemyNames = {}
      AutoFarmEnemies = {}
      for _, Option in ipairs(Options) do
         table.insert(AutoFarmEnemyNames, Option)
      end
      for _, SelectedEnemyName in ipairs(AutoFarmEnemyNames) do
         for Identifier, SelectionName in pairs(AutoFarmEnemyOptions) do
            if SelectionName ==  SelectedEnemyName then
               table.insert(AutoFarmEnemies, Identifier)
               break
            end
         end
      end
   end,
})

local AutoFarmDropdown2 = AutoFarmTab:CreateDropdown({
   Name = "Target Method",
   Options = {"Closest","Farthest","Never Hit"},
   CurrentOption = {"Closest"},
   MultipleOptions = false,
   Flag = "AutoFarmDropdown2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Option)
      AutoFarmTarget = Option[1]
   end,
})

local AutoFarmParagraph2 = AutoFarmTab:CreateParagraph({Title = "Spell Delay", Content = "Spell Delay is the amount of time to cycle through ONE of your spells, so the amount of time to recharge the spell. You should have the same spell in both slots."})

local AutoFarmSlider1 = AutoFarmTab:CreateSlider({
   Name = "Spell Delay",
   Range = {0, 10},
   Increment = 0.1,
   Suffix = "sec",
   CurrentValue = 0.5,
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
   CurrentValue = 85,
   Flag = "AutoFarmSlider2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      SpellRange = Value
   end,
})

local AutoFarmParagraph4 = AutoFarmTab:CreateParagraph({Title = "Auto Farm Quest", Content = "This only auto gives the CJ:4 quest for when you auto farm Dummy. AFAIK this is the fastest grind method for XP and coins (correct me if I'm wrong) This is a replacement for Auto Give Quest (so turn it off)."})

local AutoFarmToggle2 = AutoFarmTab:CreateToggle({
   Name = "Auto Farm Quest",
   CurrentValue = false,
   Flag = "AutoFarmToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoFarmQuestToggle = Value
   end,
})

local AutoFarmToggle3 = AutoFarmTab:CreateToggle({
   Name = "Auto Recharge at 30% (I think it requires gamepass)",
   CurrentValue = false,
   Flag = "AutoFarmToggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoRechargeToggle = Value
   end,
})

print("[WSG] Loading Tracker Tab")

local TrackerTab = Window:CreateTab("Tracker", nil) -- Title, Image

local TrackerSection1 = TrackerTab:CreateSection("Gold")

local TrackerLabel1 = TrackerTab:CreateLabel("Tracked Gold: 0")

local TrackerToggle1 = TrackerTab:CreateToggle({
   Name = "Track Gold",
   CurrentValue = false,
   Flag = "TrackerToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      TrackGold = Value
   end,
})

local TrackerButton1 = TrackerTab:CreateButton({
   Name = "Reset Gold",
   Callback = function()
      TrackerLabel1:Set("Tracked Gold: 0")
      TrackedGold = 0
      Rayfield:Notify({
         Title = "Reset Gold",
         Content = "Tracked Gold has been reset for this session.",
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
   end,
})

local TrackerSection2 = TrackerTab:CreateSection("XP")

local TrackerLabel2 = TrackerTab:CreateLabel("Tracked XP: 0")

local TrackerToggle2 = TrackerTab:CreateToggle({
   Name = "Track XP",
   CurrentValue = false,
   Flag = "TrackerToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      TrackXP = Value
   end,
})

local TrackerButton1 = TrackerTab:CreateButton({
   Name = "Reset XP",
   Callback = function()
      TrackerLabel2:Set("Tracked XP: 0")
      TrackedXP = 0
      Rayfield:Notify({
         Title = "Reset XP",
         Content = "Tracked XP has been reset for this session.",
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
   Name = "Remote Spy (Simple Spy v3)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))() -- Credit: SimpleSpy v3
   end,
})

local ToolButton3 = ToolTab:CreateButton({
   Name = "Remote Spy (Simple Spy v2.2)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))() -- Credit: SimpleSpy v3
   end,
})

local ToolButton4 = ToolTab:CreateButton({
   Name = "Orca",
   Callback = function()
      loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"))() -- Credit: orca
   end,
})

local ToolButton5 = ToolTab:CreateButton({
   Name = "CMD-X",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source",true))() -- Credit: CMD-X
   end,
})

local ToolButton6 = ToolTab:CreateButton({
   Name = "Dex",
   Callback = function()
      loadstring(game:HttpGet('https://ithinkimandrew.site/scripts/tools/dark-dex.lua'))()
   end,
})

print("[WSG] Loading Debug Tab")

local DebugTab = Window:CreateTab("Debug", nil) -- Title, Image

local DebugButton1 = DebugTab:CreateButton({
   Name = "Reset All Keybinds",
   Callback = function()
      QuestKeybind1:Set("F") -- Keybind (string)
      QuestKeybind2:Set("F") -- Keybind (string)
      PotionKeybind1:Set("F") -- Keybind (string)
      PotionKeybind2:Set("F") -- Keybind (string)
      AutoFarmKeybind1:Set("F") -- Keybind (string)
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


-- pet lock
spawn(function()
   while wait(0.1) do
      if DeletePetLockOld ~= DeletePetLock then
         wait(60)
         DeletePetLock = false
      end
      DeletePetLockOld = DeletePetLock
   end
end)


-- health detector
Humanoid.HealthChanged:Connect(function()
    HealthPercentage = Humanoid.Health / Humanoid.MaxHealth * 100
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
         local TargetEnemy = nil
         local TargetDistance = AutoFarmTarget == "Closest" and math.huge or 0 -- if targetting closest targetdistance is big number,
         local SeenEnemies = {}
         for _, EnemyName in ipairs(AutoFarmEnemies) do
            print(EnemyName)
            -- Search levels
            for _, LevelFolder in ipairs(Workspace.Levels:GetChildren()) do
               local LevelEnemiesFolder = LevelFolder:FindFirstChild("Enemies")
               if LevelEnemiesFolder then
                  for _, Enemy in ipairs(LevelEnemiesFolder:GetChildren()) do
                     if Enemy.Name == EnemyName then
                        local EnemyPos = Enemy.PrimaryPart and Enemy.PrimaryPart.Position
                        if EnemyPos then
                           local Distance = (PlayerPos - EnemyPos).magnitude

                           if AutoFarmTarget == "Closest" then
                              if Distance < TargetDistance then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                              end
                           elseif AutoFarmTarget == "Farthest" then
                              if Distance > TargetDistance then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                              end
                           elseif AutoFarmTarget == "NotHitBefore" then
                              if not SeenEnemies[Enemy] then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                                 SeenEnemies[Enemy] = true
                              end
                           end
                        end
                     end
                  end
               end
            end

            -- Search boss arenas
            for _, BossArenaFolder in ipairs(Workspace.BossArenas:GetChildren()) do
               local BossArenaEnemiesFolder = BossArenaFolder:FindFirstChild("Enemies")
               if BossArenaEnemiesFolder then
                  for _, Enemy in ipairs(BossArenaEnemiesFolder:GetChildren()) do
                     if Enemy.Name == EnemyName then
                        local EnemyPos = Enemy.PrimaryPart and Enemy.PrimaryPart.Position
                        if EnemyPos then
                           local Distance = (PlayerPos - EnemyPos).magnitude

                           if AutoFarmTarget == "Closest" then
                              if Distance < TargetDistance and Distance < SpellRange then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                              end
                           elseif AutoFarmTarget == "Farthest" then
                              if Distance > TargetDistance and Distance < SpellRange then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                              end
                           elseif AutoFarmTarget == "NotHitBefore" then
                              if not SeenEnemies[Enemy] and Distance < SpellRange then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                                 SeenEnemies[Enemy] = true
                              end
                           end
                        end
                     end
                  end
               end
            end
         end

         -- check if enemy is dead
         if TargetEnemy then
            if not TargetEnemy.Parent then
               SeenEnemies[TargetEnemy] = nil -- Remove the enemy from the SeenEnemies list
            end
         end

         -- perform attack
         if TargetEnemy and TargetDistance < SpellRange then
            if AutoFarmQuestToggle then 
               game:GetService("ReplicatedStorage").Remote.AcceptQuest:FireServer("CJ:4") 
            end
            game:GetService("ReplicatedStorage").Remote.CastSpell:FireServer(SpellState, TargetEnemy)
            SpellState = SpellState == 1 and 2 or 1 -- toggle between 1 and 2
         end
      end
   end
end)


-- auto recharge
spawn(function()
   while wait(0.1) do
      if AutoRechargeToggle == true and ManaPercentage < 30 then game:GetService("ReplicatedStorage").Remote.Recharge:FireServer() end
   end
end)


-- trackers
local function ParseText(inputtext)
   local amount, abbreviation, TextType = inputtext:match("([%d]*[%.]*[%d]*)%s*([KMB]?)%s*(%a*)")
   if not TextType or TextType == "" then
      TextType = "Gold"
   end
   local Multiplier = Multipliers[abbreviation:upper()] or 1
   local TotalAmount = tonumber(amount) * Multiplier
   return TotalAmount, TextType
end
-- DIRECTORY FOR CODING PURPOSES: PickupGuiContainer (game.Players.LocalPlayer.PlayerGui.GameGui.Pickup).PickupFrame.Amount(text)
PickupGuiContainer.ChildAdded:Connect(function(GuiFrame) 
   for _, TextLabel in ipairs(GuiFrame:GetChildren()) do
      if TextLabel.Name == "Amount" and TrackedElements[GuiFrame] ~= true then
         wait(0.1) -- because if its instant the text is "Explosion" for some fucking reason
         local Amount, Type = ParseText(TextLabel.Text)
         print("Text: " .. TextLabel.Text)
         -- update display here for now its just output
         print(Amount .. " " .. Type)
         if Type == "Gold" then
            if TrackGold == true then
               TrackedGold = TrackedGold + Amount
               TrackerLabel1:Set("Tracked Gold: " .. string.format("%0.0f", TrackedGold):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
            end
         elseif Type == "XP" then
            if TrackXP == true then
               TrackedXP = TrackedXP + Amount
               TrackerLabel2:Set("Tracked XP: " .. string.format("%0.0f", TrackedXP):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
            end
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "Statistic type is not 'Gold' or 'XP'! How did this happen?",
               Duration = 5,
               Image = nil,
               Actions = { -- Notification Buttons
                  Ignore = {
                     Name = "Debug",
                     Callback = function()
                        print("Raw:")
                        print(TextLabel.Text)
                        print("Amount:")
                        print(Amount)
                        print("Type:")
                        print(Type)
                     end
                  },
               },
            })
         end

         -- tracked deletion
         TrackedElements[GuiFrame] = true
         GuiFrame.AncestryChanged:Connect(function(_, parent)
            if parent == nil then
               TrackedElements[GuiFrame] = nil
            end
         end)
         break
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


print("[WSG] Loaded!")
