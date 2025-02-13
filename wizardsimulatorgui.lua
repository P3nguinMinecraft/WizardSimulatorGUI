-- Check out my GitHub! https://github.com/P3nguinMinecraft/WizardSimulatorGUI/
-- game:GetService("Players").LocalPlayer.Character.PrimaryPart.Position = Vector3.new(898.3, 4, -399) works best with autofarm dummy so you won't be seen (using fly and noclip)

if not game:IsLoaded() then game.Loaded:Wait() end

local placeID = 3089478851
if game.PlaceId ~= placeID then
   error("Stopped WSG, not in Wizard Simulator")
end

print("[WSG] Loading Wizard Simulator GUI")


getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- local vars
local Player = game:GetService("Players").LocalPlayer
local Humanoid = Player.Character:WaitForChild("Humanoid")
local RootPart = Player.Character:WaitForChild("HumanoidRootPart")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local GameGUI =  Player.PlayerGui.GameGui
local PickupGuiContainer = GameGUI.Pickup
local Level, Arena, PlayerPos
local SpellState = 1
local SelectedPet
local PetSlotOptions = {
   [1] = "Main",
   [2] = "Secondary (gamepass)",
   [3] = "Mount"
}
local SelectedPetSlotName
local SelectedPetSlot = 1
local DeletePetLockTimer = 0
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
local AutoReroll = false
local SelectedRarities = {}
local SelectedChestName = "Training Area Chest"
local SelectedChest = "Chest1"
local HomeTPBlack = false
local HomeTPTimer = 0
local LocationTPBlack = false
local LocationTPTimer = 0
local SelectedQuest = "LJ:1"
local AutoQuestToggle = false
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
local HitEnemies = {}
local ConnectedEnemyFolders = {}
local AutoFarmDelay = 1.5
local AutoFarmQuestToggle = false
local AutoRechargeToggle = false
local SpellRange = 100
local TrackGold = false
local TrackXP = false
local TrackedGold = 0
local TrackedXP = 0
local TrackedGoldTimer = 0
local TrackedXPTimer = 0
local GoldHours, GoldMinutes, GoldSeconds, GoldDurationString, GoldPerHour, XPHours, XPMinutes, XPSeconds, XPDurationString, XPPerHour
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
local NoSlow = false
local ApplyNoSlow = false
local NoSlowTimer = 0
local PlayerXPPercentage, PlayerLevel, PlayerTotalXP
local LevelTimer, LevelMinutes, LevelSeconds, LevelHours, LevelDuration

print("[WSG] Loading Window")

local Window = Rayfield:CreateWindow({
   Name = "Wizard Simulator",
   LoadingTitle = "Wizard Simulator GUI",
   LoadingSubtitle = "by penguin",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "wizardsimulatorgui", -- Create a custom folder for your hub/game
      FileName = "wizardsimulatorgui_config"
   },
   Discord = { 
      Enabled = true,
      Invite = "fWncS2vFxn", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
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

local CreditLabel2 = CreditTab:CreateLabel("Executor used for development: MacSploit, Delta (not affiliated!)")

local CreditLabel3 = CreditTab:CreateLabel("For questions, concerns, contact windows1267 on discord or join the discord server on the GitHub")

print("[WSG] Loading QOL Tab")

local QOLTab = Window:CreateTab("QOL", nil) -- Title, Image

local QOLSection1 = QOLTab:CreateSection("Pets")

local QOLInput1 = QOLTab:CreateInput({
   Name = "Select Pet",
   PlaceholderText = "Order in the Pet Menu",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      local num = tonumber(Text)
      if num ~= nil and num > 0 and math.floor(num) == num then
         SelectedPet = tonumber(Text)
      elseif Text == "" then
         SelectedPet = nil
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
      if SelectedPet and SelectedPet > 0 then
         if DeletePetLockTimer > 0 then 
            game:GetService("ReplicatedStorage").Remote.DeletePet:FireServer(SelectedPet)
            if AutoRerollToggle == true then
               game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("OpenPetChest"):InvokeServer(SelectedChest)
            end
         else
            Rayfield:Notify({
               Title = "Delete Pet Lock",
               Content = "Delete Pet Lock prevented you from deleting the selected pet. Press the button below to disable it for 1 minute.",
               Duration = 5,
               Image = nil,
               Actions = { -- Notification Buttons
                  Ignore = {
                     Name = "Disable Lock",
                     Callback = function()
                        DeletePetLockTimer = 60
                     end
                  },
               },
            })
         end
      else
         Rayfield:Notify({
            Title = "No Pet Selected!",
            Content = "You did not select a pet slot above!",
            Duration = 5,
            Image = nil,
            Actions = { -- Notification Buttons
            },
         })
      end
   end,
})

local QOLButton4 = QOLTab:CreateButton({
   Name = "Disable Delete Pet Lock",
   Callback = function()
      DeletePetLockTimer = 60
      Rayfield:Notify({
         Title = "Pet Lock Enabled",
         Content = "You may now delete pets for 60 seconds!",
         Duration = 5,
         Image = nil,
         Actions = { -- Notification Buttons
         },
      })
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

local QOLButton5 = QOLTab:CreateButton({
   Name = "Buy Chest",
   Callback = function()
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("OpenPetChest"):InvokeServer(SelectedChest)
   end,
})

local QOLParagraph3 = QOLTab:CreateParagraph({Title = "Auto Reroll", Content = "Automatically deletes the pet in the selected slot and buys another chest"})

local QOLButton5 = QOLTab:CreateButton({
   Name = "Reroll Pet",
   Callback = function()
      if SelectedPet and SelectedPet > 0 then
         if DeletePetLockTimer > 0 then 
            game:GetService("ReplicatedStorage").Remote.DeletePet:FireServer(SelectedPet)
            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("OpenPetChest"):InvokeServer(SelectedChest)
         else
            Rayfield:Notify({
               Title = "Delete Pet Lock",
               Content = "Delete Pet Lock prevented you from deleting the selected pet. Press the button above to disable it for 1 minute.",
               Duration = 5,
               Image = nil
            })
         end
      else
         Rayfield:Notify({
            Title = "No Pet Selected!",
            Content = "You did not select a pet slot above!",
            Duration = 5,
            Image = nil,
            Actions = { -- Notification Buttons
            },
         })
      end
   end,
})

local QOLToggle2 = QOLTab:CreateToggle({
   Name = "Roll Until Rarity",
   CurrentValue = false,
   Flag = "QOLToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoReroll = Value
   end,
})

local QOLDropdown3 = QOLTab:CreateDropdown({
   Name = "Select Chest",
   Options = {
      "COMMON",
      "RARE",
      "EPIC",
      "LEGENDARY",
      "GODLY"
   },
   CurrentOption = "COMMON",
   MultipleOptions = true,
   Flag = "QOLDropdown3",
   Callback = function(Option)
      SelectedRarities = Option
   end,
})

local QOLParagraph4 = QOLTab:CreateParagraph({Title = "Scamming", Content = "Removes all pets in your side and accepts, usually too fast for the other side to realize."})

local QOLButton6 = QOLTab:CreateButton({
   Name = "Scam",
   Callback = function()
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("TradeUpdate"):FireServer("UpdateOffer",1,0)
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("TradeUpdate"):FireServer("UpdateOffer",2,0)
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("TradeUpdate"):FireServer("UpdateOffer",3,0)
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("TradeUpdate"):FireServer("UpdateOffer",4,0)
      game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("TradeUpdate"):FireServer("SetReady", true)
   end,
})

local QOLSection3 = QOLTab:CreateSection("GUI Blockers")

local QOLToggle3 = QOLTab:CreateToggle({
   Name = "Remove Home TP Black Screen",
   CurrentValue = false,
   Flag = "QOLToggle3", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      HomeTPBlack = Value
   end,
})

local QOLToggle4 = QOLTab:CreateToggle({
   Name = "Remove Location TP Black Screen",
   CurrentValue = false,
   Flag = "QOLToggle4", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      LocationTPBlack = Value
   end,
})

local QOLToggle5 = QOLTab:CreateToggle({
   Name = "Spell No Slow",
   CurrentValue = false,
   Flag = "QOLToggle5", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      NoSlowToggle = Value
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
         Content = "Toggled!",
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

local AutoFarmButton1 = AutoFarmTab:CreateButton({
   Name = "Clear Hit Enemies",
   Callback = function()
      HitEnemies = {}
      Rayfield:Notify({
         Title = "Clear Hit Enemies",
         Content = "All tracked enemies cleared. This is really useful because this script tries to attack enemies through walls, and does not register if they are actually hit.",
         Duration = 5,
         Image = nil,
         Actions = { -- Notification Buttons
         },
      })
   end,
})

local AutoFarmParagraph2 = AutoFarmTab:CreateParagraph({Title = "Spell Delay", Content = "Spell Delay is the amount of time to cycle through ONE of your spells, so the amount of time to recharge the spell. You should have the same spell in both slots."})

local AutoFarmSlider1 = AutoFarmTab:CreateSlider({
   Name = "Spell Delay",
   Range = {0, 20},
   Increment = 0.1,
   Suffix = "sec",
   CurrentValue = 1.5,
   Flag = "AutoFarmSlider1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      AutoFarmDelay = Value
   end,
})

local AutoFarmParagraph3 = AutoFarmTab:CreateParagraph({Title = "Spell Range", Content = "Spell Range is the range of a certain spell (in studs) required to be able to hit an enemy. Just guess and check because the algorithm targets the closest enemy. I might code a function to help you determine range, or just a list."})

local AutoFarmSlider2 = AutoFarmTab:CreateSlider({
   Name = "Spell Range",
   Range = {0, 150},
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

local TrackerButton1 = TrackerTab:CreateButton({
   Name = "Toggle Trackers",
   Callback = function()
      ToggleGold()
      ToggleXP()
      Rayfield:Notify({
         Title = "Toggle Trackers",
         Content = "Toggled both Gold and XP trackers.",
         Duration = 5,
         Image = nil,
         Actions = { -- Notification Buttons
         },
      })
   end,
})

local TrackerButton2 = TrackerTab:CreateButton({
   Name = "Reset Trackers",
   Callback = function()
      ResetGold()
      ResetXP()
      Rayfield:Notify({
         Title = "Reset Trackers",
         Content = "Reset both Gold and XP trackers.",
         Duration = 5,
         Image = nil,
         Actions = { -- Notification Buttons
         },
      })
   end,
})

local TrackerSection1 = TrackerTab:CreateSection("Gold")

local TrackerLabel1 = TrackerTab:CreateLabel("Tracked Gold: 0")

local TrackerLabel2 = TrackerTab:CreateLabel("Tracked Duration: 0 seconds")

local TrackerLabel3 = TrackerTab:CreateLabel("Gold/Hour: 0")

local TrackerToggle1 = TrackerTab:CreateToggle({
   Name = "Track Gold",
   CurrentValue = false,
   Flag = "TrackerToggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      TrackGold = Value
   end,
})

local TrackerButton3 = TrackerTab:CreateButton({
   Name = "Reset Gold",
   Callback = function()
      ResetGold()
      Rayfield:Notify({
         Title = "Reset Gold",
         Content = "Tracked Gold has been reset for this session.",
         Duration = 5,
         Image = nil,
         Actions = { -- Notification Buttons
         },
      })
   end,
})

local TrackerSection2 = TrackerTab:CreateSection("XP")

local TrackerLabel4 = TrackerTab:CreateLabel("Tracked XP: 0")

local TrackerLabel5 = TrackerTab:CreateLabel("Tracked Duration: 0 seconds")

local TrackerLabel6 = TrackerTab:CreateLabel("XP/Hour: 0")

local TrackerToggle2 = TrackerTab:CreateToggle({
   Name = "Track XP",
   CurrentValue = false,
   Flag = "TrackerToggle2", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
      TrackXP = Value
   end,
})

local TrackerButton4 = TrackerTab:CreateButton({
   Name = "Reset XP",
   Callback = function()
      ResetXP()
      Rayfield:Notify({
         Title = "Reset XP",
         Content = "Tracked XP has been reset for this session.",
         Duration = 5,
         Image = nil,
         Actions = { -- Notification Buttons
         },
      })
   end,
})

local TrackerSection3 = TrackerTab:CreateSection("Levels")

local TrackerLabel7 = TrackerTab:CreateSection("A more accurate display of leveling than the default GUI bar")

local TrackerLabel8 = TrackerTab:CreateSection("Do note that these numbers are still a rough estimate")

local TrackerLabel9 = TrackerTab:CreateLabel("Level: 0")

local TrackerLabel10 = TrackerTab:CreateLabel("XP To Next Level: 0")

local TrackerLabel11 = TrackerTab:CreateLabel("Time to Next Level: No Data")

print("[WSG] Loading Tools Tab")

local ToolTab = Window:CreateTab("Tools", nil) -- Title, Image

local ToolParagraph1 = ToolTab:CreateParagraph({Title = "Small Things", Content = "These are probably availiable in other universal scripts but I find it easy to access here. Turning walkspeed on and keeping it at 16 will cancel the spell delay."})

local ToolLabel1 = ToolTab:CreateLabel("Walkspeed")

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
   Range = {0, 250},
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
   Name = "Dex v4",
   Callback = function()
      loadstring(game:GetObjects("rbxassetid://418957341")[1].Source)() -- Credit: Dex v4
   end,
})

local ToolButton7 = ToolTab:CreateButton({
   Name = "Dark Dex Mobile (Modded DDex v3)",
   Callback = function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/refs/heads/main/Universal/BypassedDarkDexV3.lua", true))() -- Credit: Modded Dark Dex v3 by Babyhamsta
   end,
})

print("[WSG] Loading Options Tab")

local OptionsTab = Window:CreateTab("Options", nil) -- Title, Image

local OptionsDropdown1 = OptionsTab:CreateDropdown({
   Name = "Themes",
   Options = {"Default","AmberGlow","Amethyst","Bloom","DarkBlue","Green","Light","Ocean","Serenity"},
   CurrentOption = {"Default"},
   MultipleOptions = false,
   Flag = "OptionsDropdown1",
   Callback = function(Options)
      Window.ModifyTheme(Options[1])
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

local DebugButton2 = DebugTab:CreateButton({
   Name = "Dump HitEnemies",
   Callback = function()
      print("Dumping HitEnemies Table")
      for i, v in pairs(HitEnemies) do
         print(i)
         print(v)
      end
      print("Done")
   end,
})

local DebugButton3 = DebugTab:CreateButton({
   Name = "Kill GUI",
   Callback = function()
      Rayfield:Destroy()
   end,
})

local DebugButton4 = DebugTab:CreateButton({
   Name = "Teleport to Position",
   Callback = function()
      Player.Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(903, 4.1, -400)))
   end,
})

local DebugButton5 = DebugTab:CreateButton({
   Name = "Print in console",
   Callback = function()
      print("hi")
   end,
})

print("[WSG] Loading Scripts")

-- level and position
spawn(function()
   while task.wait(0.1) do
      Level = Player.Level.Value
      if Level == "Boss" then
         Arena = Player.Level:FindFirstChild("Arena").Value
      end
      if Player and Player.Character then
         PlayerPos = Player.Character.PrimaryPart and Player.Character.PrimaryPart.Position
      end
   end
end)

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
   while task.wait(1) do
      if DeletePetLockTimer > 0 then
         DeletePetLockTimer = DeletePetLockTimer - 1
      end
   end
end)

-- home TP black
GameGUI.ChildAdded:Connect(function(Object)
   if Object.Name == "Frame" and HomeTPBlack == true then
      Object.Visible = false
      if HomeTPTimer == 0 then
         HomeTPTimer = 2
      end
   end
end)
spawn(function()
   while task.wait() do
      if HomeTPTimer == 2 then
            Rayfield:Notify({
            Title = "Teleporting...",
            Content = "",
            Duration = 1,
            Image = nil
         })
      end
      if HomeTPTimer > 0 then
         HomeTPTimer = HomeTPTimer - 1
         task.wait(1)
      end
   end
end)


-- location TP black
GameGUI:FindFirstChild("Black").ChildAdded:Connect(function()
   if LocationTPBlack == true then
      GameGUI.Black.Visible = false
      if LocationTPTimer == 0 then
         LocationTPTimer = 3
      end
   end
end)
spawn(function()
   while task.wait() do
      if LocationTPTimer == 3 then
            Rayfield:Notify({
            Title = "Teleporting...",
            Content = "",
            Duration = 2,
            Image = nil
         })
      end
      if LocationTPTimer > 0 then
         LocationTPTimer = LocationTPTimer - 1
         task.wait(1)
      end
   end
end)

-- health detector
Humanoid.HealthChanged:Connect(function()
    HealthPercentage = Humanoid.Health / Humanoid.MaxHealth * 100
end)


-- mana detector
spawn(function()
   while task.wait(0.1) do
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
   while task.wait(0.1) do
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
local function ConnectEnemyRemoved(Folder)
   if Folder and not ConnectedEnemyFolders[Folder] then
      ConnectedEnemyFolders[Folder] = Folder.ChildRemoved:Connect(function(DeletedEnemy)
         HitEnemies[DeletedEnemy] = nil
      end)
   end
end

spawn(function()
   while task.wait(AutoFarmDelay/2) do
      if PlayerPos and AutoFarmToggle then
         
         local TargetEnemy = nil
         local TargetDistance = AutoFarmTarget == "Farthest" and 0 or math.huge -- if targetting farthest default is 0, otherwise its math.huge
         for _, EnemyName in ipairs(AutoFarmEnemies) do
            -- search levels
            for _, LevelFolder in ipairs(Workspace.Levels:GetChildren()) do
               local LevelEnemiesFolder = LevelFolder:FindFirstChild("Enemies")
               if LevelEnemiesFolder then
                  ConnectEnemyRemoved(LevelEnemiesFolder)
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
                           elseif AutoFarmTarget == "Never Hit" then
                              if HitEnemies[Enemy] == nil and Distance < TargetDistance and Distance < SpellRange then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                              end
                           end
                        end
                     end
                  end
               end
            end

            -- search boss arenas
            for _, BossArenaFolder in ipairs(Workspace.BossArenas:GetChildren()) do
               local BossArenaEnemiesFolder = BossArenaFolder:FindFirstChild("Enemies")
               if BossArenaEnemiesFolder then
                  ConnectEnemyRemoved(BossArenaEnemiesFolder)
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
                           elseif AutoFarmTarget == "Never Hit" then
                              if HitEnemies[Enemy] == nil and Distance < TargetDistance and Distance < SpellRange then
                                 TargetEnemy = Enemy
                                 TargetDistance = Distance
                              end
                           end
                        end
                     end
                  end
               end
            end
         end
         

         -- perform attack
         if TargetEnemy and TargetDistance < SpellRange then
            if AutoFarmQuestToggle then 
               game:GetService("ReplicatedStorage").Remote.AcceptQuest:FireServer("CJ:4") 
            end
            game:GetService("ReplicatedStorage").Remote.CastSpell:FireServer(SpellState, TargetEnemy)
            -- log hit enemy
            if AutoFarmTarget == "Never Hit" then HitEnemies[TargetEnemy] = "hit" end
            SpellState = 3 - SpellState -- toggle between 1 and 2
         end
      end
   end
end)


-- auto recharge
spawn(function()
   while task.wait(0.1) do
      if AutoRechargeToggle == true and ManaPercentage < 30 then 
         game:GetService("ReplicatedStorage").Remote.Recharge:FireServer() 
         --RefillMana();
      end
   end
end)


-- trackers

local function ParseTrackerText(inputtext)
   local amount, abbreviation, TextType = inputtext:match("([%d]*[%.]*[%d]*)%s*([kMB]?)%s*(%a*)")
   if not TextType or TextType == "" then
      TextType = "Gold"
   end
   local Multiplier = Multipliers[abbreviation:upper()] or 1
   local TotalAmount = tonumber(amount) * Multiplier
   return TotalAmount, TextType
end

-- PickupGuiContainer.ChildAdded handler
PickupGuiContainer.ChildAdded:Connect(function(GuiFrame) 
   for _, TextLabel in ipairs(GuiFrame:GetChildren()) do
      if TextLabel.Name == "Amount" and TrackedElements[GuiFrame] ~= true then
         task.wait(0.1) -- wait for correct text
         local Amount, Type = ParseTrackerText(TextLabel.Text)
         
         -- Update Gold or XP depending on the type
         if Type == "Gold" then
            if TrackGold == true then
               TrackedGold = TrackedGold + Amount
               TrackerLabel1:Set("Tracked Gold: " .. string.format("%0.0f", TrackedGold):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
            end
         elseif Type == "XP" then
            if TrackXP == true then
               TrackedXP = TrackedXP + Amount
               TrackerLabel4:Set("Tracked XP: " .. string.format("%0.0f", TrackedXP):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
            end
         else
            Rayfield:Notify({
               Title = "Error",
               Content = "Statistic type is not 'Gold' or 'XP'! How did this happen?",
               Duration = 5,
               Image = nil,
               Actions = {
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

         -- Mark this GuiFrame as tracked
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

-- Tracker timer
spawn(function()
   while task.wait(1) do
      if TrackGold == true then
         TrackedGoldTimer = TrackedGoldTimer + 1
         GoldHours = math.floor(TrackedGoldTimer / 3600)
         GoldMinutes = math.floor((TrackedGoldTimer % 3600) / 60)
         GoldSeconds = TrackedGoldTimer % 60 

         if GoldHours > 0 then
            GoldDurationString = GoldHours .. " hour(s), " .. GoldMinutes .. " minute(s), and " .. GoldSeconds .. " second(s)"
         elseif GoldMinutes > 0 then
            GoldDurationString = GoldMinutes .. " minute(s) and " .. GoldSeconds .. " second(s)"
         else
            GoldDurationString = GoldSeconds .. " second(s)"
         end

         TrackerLabel2:Set("Tracked Duration: " .. GoldDurationString)

         GoldPerHour = math.floor(TrackedGold / TrackedGoldTimer * 3600)
         TrackerLabel3:Set("Gold/Hour: " .. string.format("%0.0f", GoldPerHour):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
      end

      if TrackXP == true then
         TrackedXPTimer = TrackedXPTimer + 1
         XPHours = math.floor(TrackedXPTimer / 3600)
         XPMinutes = math.floor((TrackedXPTimer % 3600) / 60)
         XPSeconds = TrackedXPTimer % 60 

         if XPHours > 0 then
            XPDurationString = XPHours .. " hour(s), " .. XPMinutes .. " minute(s), and " .. XPSeconds .. " second(s)"
         elseif XPMinutes > 0 then
            XPDurationString = XPMinutes .. " minute(s) and " .. XPSeconds .. " second(s)"
         else
            XPDurationString = XPSeconds .. " second(s)"
         end

         TrackerLabel5:Set("Tracked Duration: " .. XPDurationString)

         XPPerHour = math.floor(TrackedXP / TrackedXPTimer * 3600)
         TrackerLabel6:Set("XP/Hour: " .. string.format("%0.0f", XPPerHour):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
      end
   end
end)


-- walkspeed and jumppower management
spawn(function()
   while task.wait(0.01) do
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

-- refill mana (doesnt work rn)
function RefillMana()
   if level ~= "Boss" then
      game:GetService("ReplicatedStorage").Remote.TouchedRecharge:FireServer(Workspace.Levels.level:WaitForChild("SpawnPoint"))
   end
end

-- no slow activation and timer
game:GetService("ReplicatedStorage").Remote.CastSpell.OnClientEvent:Connect(function(plr)
   if plr == Player then
      NoSlowTimer = 9
   end
end)
spawn(function()
   while task.wait(0.1) do
      if NoSlowTimer > 0 then
         ApplyNoSlow = true
         NoSlowTimer = NoSlowTimer - 1
         if NoSlowTimer <= 0 then
            ApplyNoSlow = false
         end
         task.wait(1)
      end
   end
end)


-- no slow management
spawn(function()
   while task.wait(0.01) do
      if (ApplyNoSlow == true) then
         Humanoid.WalkSpeed = 16
      end
   end
end)


-- toggle and reset trackers
function ToggleGold()
   TrackGold = not TrackGold
   TrackerToggle1:Set(TrackGold)
end

function ToggleXP()
   TrackXP = not TrackXP
   TrackerToggle2:Set(TrackXP)
end

function ResetGold()
   TrackerLabel1:Set("Tracked Gold: 0")
   TrackedGold = 0
   TrackerLabel2:Set("Tracked Duration: 0 seconds")
   TrackedGoldTimer = 0
   TrackerLabel3:Set("Gold/Hour: 0")
   GoldPerHour = 0
end

function ResetXP()
   TrackerLabel4:Set("Tracked XP: 0")
   TrackedXP = 0
   TrackerLabel5:Set("Tracked Duration: 0 seconds")
   TrackedXPTimer = 0
   TrackerLabel6:Set("XP/Hour: 0")
   XPPerHour = 0   
end

-- xp stats
local function ParseTotalXPValue(value)
   local number, unit = value:match("/([%d%.]+)([KMBT]?)")
   number = tonumber(number)

   if unit == "K" then
       number = number * 1e3 -- Thousand
   elseif unit == "M" then
       number = number * 1e6 -- Million
   elseif unit == "B" then
       number = number * 1e9 -- Billion
   elseif unit == "T" then
       number = number * 1e12 -- Trillion
   end

   return number
end

-- unused rn
local function FormatValue(number)
    local unit = ""
    local formattedValue = number

    if number >= 1e12 then
        unit = "T"  -- Trillion
        formattedValue = number / 1e12
    elseif number >= 1e9 then
        unit = "B"  -- Billion
        formattedValue = number / 1e9
    elseif number >= 1e6 then
        unit = "M"  -- Million
        formattedValue = number / 1e6
    elseif number >= 1e3 then
        unit = "K"  -- Thousand
        formattedValue = number / 1e3
    end

    formattedValue = string.format("%.6g", formattedValue)

    return formattedValue .. unit
end


spawn(function()
   while task.wait(1) do
      local XPBar = GameGUI.Stats.ExperienceOutside.Bar
      local XPText = GameGUI.Stats.ExperienceOutside.Amount
      if XPBar and XPText then
         PlayerLevel = Player.leaderstats.Level.Value
         TrackerLabel9:Set("Level: " .. PlayerLevel)
         PlayerXPPercentage = XPBar.Size.X.Scale
         PlayerTotalXP = ParseTotalXPValue(XPText.Text)
         if not PlayerTotalXP then return end
         local MissingXP = round((1 - PlayerXPPercentage) * PlayerTotalXP)
         TrackerLabel10:Set("XP To Next Level: " .. string.format("%0.0f", MissingXP):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
         if XPPerHour and XPPerHour > 0 then
            LevelTimer = round(MissingXP / XPPerHour * 3600)
            LevelHours = math.floor(LevelTimer / 3600)
            LevelMinutes = math.floor((LevelTimer % 3600) / 60)
            LevelSeconds = LevelTimer % 60 

            if LevelHours > 0 then
               LevelDuration = LevelHours .. " hour(s), " .. LevelMinutes .. " minute(s), and " .. LevelSeconds .. " second(s)"
            elseif LevelMinutes > 0 then
               LevelDuration = LevelMinutes .. " minute(s) and " .. LevelSeconds .. " second(s)"
            else
               LevelDuration = LevelSeconds .. " second(s)"
            end

            TrackerLabel11:Set("Time To Next Level: " .. LevelDuration)
         end
      end
      if XPPerHour and XPPerHour <= 0 then
         TrackerLabel11:Set("Time To Next Level: No Data")
      end
   end
end)

-- autoreoll until rarity
spawn(function()
   while task.wait(0.1) do
      local PetGUI = GameGUI.Pets
      if PetGUI and AutoReroll == true then
         if SelectedPet and SelectedPet > 0 then
            if DeletePetLockTimer > 0 then 
               if PetGUI.Visible == true then
                  local slot = PetGUI.ListFrame.ListBackground.List:FindFirstChild(SelectedPet)
                  if slot then
                     local iscorrectrarity = false
                     for _,rarity in pairs(SelectedRarities) do
                        if rarity == slot.Rarity.Text then
                           iscorrectrarity = true
                           break
                        end
                     end
                     if iscorrectrarity == false then
                        game:GetService("ReplicatedStorage").Remote.DeletePet:FireServer(SelectedPet)
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("OpenPetChest"):InvokeServer(SelectedChest)
                     else
                        Rayfield:Notify({
                           Title = "Pet Found!",
                           Content = "A pet of the selected rarities has been rolled! Manually reroll a new pet if you don't want the pet in the slot.",
                           Duration = 5,
                           Image = nil
                        })
                        AutoReroll = false
                        QOLToggle2:Set(false)                     
                     end
                  else
                     Rayfield:Notify({
                        Title = "Pet Not Found",
                        Content = "Check that there is a pet in the inputted slot.",
                        Duration = 5,
                        Image = nil
                     })
                     AutoReroll = false
                     QOLToggle2:Set(false)   
                  end
               else
                  Rayfield:Notify({
                     Title = "Pet GUI Not Visible",
                     Content = "Open the Pet Menu so rarity can be seen.",
                     Duration = 5,
                     Image = nil
                  })
                  AutoReroll = false
                  QOLToggle2:Set(false)
               end
            else
               Rayfield:Notify({
                  Title = "Delete Pet Lock",
                  Content = "Delete Pet Lock prevented you from deleting the selected pet. Press the button above to disable it for 1 minute.",
                  Duration = 5,
                  Image = nil
               })
               AutoReroll = false
               QOLToggle2:Set(false)
            end
         else
            Rayfield:Notify({
               Title = "No Pet Selected!",
               Content = "You did not select a pet slot above!",
               Duration = 5,
               Image = nil,
               Actions = { -- Notification Buttons
               },
            })
            AutoReroll = false
            QOLToggle2:Set(false)
         end
      end
   end
end)

print("[WSG] Loaded!")
