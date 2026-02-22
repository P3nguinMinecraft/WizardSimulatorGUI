-- Wizard Simulator GUI
-- GitHub: https://github.com/P3nguinMinecraft/WizardSimulatorGUI/
-- Tip: game:GetService("Players").LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(898.3, 4, -399))
--      works best with autofarm dummy so you won't be seen (use fly + noclip)

if not game:IsLoaded() then game.Loaded:Wait() end

local placeID = 3089478851
if game.PlaceId ~= placeID then
	warn("Stopped WSG, not in Wizard Simulator")
	return
end

print("[WSG] Loading Wizard Simulator GUI")

-- ──────────────────────────────────────────────
--  Services
-- ──────────────────────────────────────────────
local Players         = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService      = game:GetService("RunService")
local VirtualUser     = game:GetService("VirtualUser")

local Player    = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ──────────────────────────────────────────────
--  Anti-Idle
-- ──────────────────────────────────────────────
local function antidle()
	local speaker = Player
	if getconnections then
		for _, connection in pairs(getconnections(speaker.Idled)) do
			if connection["Disable"] then
				connection["Disable"](connection)
			elseif connection["Disconnect"] then
				connection["Disconnect"](connection)
			end
		end
	else
		speaker.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end
end
antidle()

-- ──────────────────────────────────────────────
--  Rayfield
-- ──────────────────────────────────────────────
getgenv().SecureMode = true
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- ──────────────────────────────────────────────
--  Local references
-- ──────────────────────────────────────────────
local GameGUI             = Player.PlayerGui.GameGui
local PickupGuiContainer  = GameGUI.Pickup
local Humanoid            = Player.Character:WaitForChild("Humanoid")
local RootPart            = Player.Character:WaitForChild("HumanoidRootPart")

-- ──────────────────────────────────────────────
--  State
-- ──────────────────────────────────────────────
local vars = {
	Level                = nil,
	Arena                = nil,
	PlayerPos            = nil,
	SpellState           = 1,
	SelectedPet          = nil,
	SelectedPetSlotName  = nil,
	SelectedPetSlot      = 1,
	DeletePetLockTimer   = 0,
	AutoReroll           = false,
	SelectedRarities     = {},
	SelectedChestName    = "Training Area Chest",
	SelectedChest        = "Chest1",
	HomeTPBlack          = false,
	HomeTPTimer          = 0,
	LocationTPBlack      = false,
	LocationTPTimer      = 0,
	NoStop               = false,
	SelectedQuest        = "LJ:1",
	AutoQuestToggle      = false,
	HPot                 = nil,
	MPot                 = nil,
	HealthPercentage     = nil,
	PreviousMana         = nil,
	Mana                 = nil,
	MaxMana              = nil,
	ManaPercentage       = nil,
	AutoHealthToggle     = false,
	AutoManaToggle       = false,
	AutoHealthThreshold  = 0,
	AutoManaThreshold    = 0,
	AutoFarmToggle       = false,
	AutoFarmEnemyNames   = {"[1] Training Dummy"},
	AutoFarmEnemies      = {"Dummy"},
	AutoFarmTarget       = "Closest",
	HitEnemies           = {},
	ConnectedEnemyFolders = {},
	AutoFarmDelay        = 1.5,
	AutoFarmQuestToggle  = false,
	AutoRechargeToggle   = false,
	SpellRange           = 100,
	TrackGold            = false,
	TrackXP              = false,
	TrackedGold          = 0,
	TrackedXP            = 0,
	TrackedGoldTimer     = 0,
	TrackedXPTimer       = 0,
	GoldHours            = nil,
	GoldMinutes          = nil,
	GoldSeconds          = nil,
	GoldDurationString   = nil,
	GoldPerHour          = nil,
	XPHours              = nil,
	XPMinutes            = nil,
	XPSeconds            = nil,
	XPDurationString     = nil,
	XPPerHour            = nil,
	TrackedElements      = {},
	WalkspeedToggleOld   = false,
	WalkspeedToggle      = false,
	Walkspeed            = 16,
	JumpPowerToggleOld   = false,
	JumpPowerToggle      = false,
	JumpPower            = 50,
	PlayerXPPercentage   = nil,
	PlayerLevel          = nil,
	PlayerTotalXP        = nil,
	LevelTimer           = nil,
	LevelMinutes         = nil,
	LevelSeconds         = nil,
	LevelHours           = nil,
	LevelDuration        = nil,
	DisableRendering     = false,
}

vars.HealthPercentage = Humanoid.Health / Humanoid.MaxHealth * 100

-- ──────────────────────────────────────────────
--  Lookup tables
-- ──────────────────────────────────────────────
local PetSlotOptions = { [1] = "Main", [2] = "Secondary (gamepass)", [3] = "Mount" }

local ChestOptions = {
	Chest1        = "Training Area Chest",
	Chest2        = "Werewolf Chest",
	Chest3        = "Deep Seas Chest",
	Chest4        = "Magma Chest",
	Chest5        = "Castle Chest",
	Chest6        = "Candy Chest",
	CheapMountChest = "Cheap Mount Chest",
	MountChest    = "Mount Chest",
}

local AutoFarmEnemyOptions = {
	Dummy              = "[1] Training Dummy",
	DummyWarrior       = "[3] Dummy Warrior",
	DummyArcher        = "[6] Dummy Archer",
	DummySpearman      = "[8] Dummy Spearman",
	DummyWizard        = "[12] Dummy Wizard",
	EarthGolem         = "[24] Earth Golem",
	Stone3             = "[24] Summoned Earth Rock",
	DummyKing          = "Dummy King",
	GreenSlime         = "[12] Green Slime",
	BigSlime           = "[17] Giant Green Slime",
	Spider             = "[15] Spider",
	GiantSpider        = "[20] Big Spider",
	Wolf               = "[22] Wolf",
	Werewolf           = "[25] Werewolf",
	Bear               = "[26] Bear",
	StoneGolem         = "[32] Stone Golem",
	Stone1             = "[32] Summoned Rock",
	Lumberjack         = "Lumberjack",
	GiantWerewolf      = "Lumberjack? (Werewolf)",
	BeachCrab          = "[28] Beach Crab",
	Clam               = "[30] Clam",
	RockCrab           = "[32] Rock Crab",
	Jellyfish          = "[35] Jellyfish",
	IceJellyfish       = "[36] Ice Jellyfish",
	GreenPirate        = "[38] Green Pirate",
	RedPirate          = "[39] Red Pirate",
	WaterGolem         = "[42] Water Golem",
	Stone4             = "[42] Summoned Water Rock",
	KingPirate         = "Pirate King",
	MagmaSlime         = "[40] Magma Slime",
	GiantMagmaSlime    = "[43] Giant Magma Slime",
	FireAnt            = "[43] Fire Ant",
	GiantFireAnt       = "[46] Giant Fire Ant",
	MagmaCrab          = "[48] Magma Crab",
	MagmaSpider        = "[49] Magma Spider",
	MagmaScorpion      = "[51] Magma Scorpion",
	Worm               = "[53] Magma Worm",
	MagmaGolem         = "[54] Magma Golem",
	Stone2             = "[54] Summoned Magma Rock",
	MagmaKing          = "Magma King",
	MagmaEater         = "Magma Eater",
	DummyKnight        = "[58] Elite Dummy Knight",
	DummyArcher2       = "[60] Elite Dummy Archer",
	DummySpearman2     = "[62] Elite Dummy Spearman",
	SmallWasp          = "[64] Wasp",
	Wasp               = "[66] Giant Wasp",
	SmallTreant        = "[66] Stumpant",
	Treant             = "[68] Treant",
	RockScorpion       = "[69] Rock Scorpion",
	RockTitan          = "[71] Rock Titan",
	SmallJello         = "[74] Small Jello",
	Cupcake            = "[75] Cupcake",
	Donut              = "[77] Donut",
	BigJello           = "[78] Big Jello",
	GummyWorm          = "[80] Gummy Worm",
	GingerbreadSoldier = "[81] Gingerbread Soldier",
	GingerbreadWizard  = "[82] Gingerbread Wizard",
	CandyGolem         = "[84] Candy Golem",
	StaticWaypoint     = "Candy Chomper (also targets gates)",
}

local Multipliers = { K = 1000, M = 1000000, B = 1000000000 }

-- ──────────────────────────────────────────────
--  Helpers
-- ──────────────────────────────────────────────
local function round(num) return math.floor(num + 0.5) end

local function fireRemote(name, ...)
	return ReplicatedStorage:WaitForChild("Remote"):WaitForChild(name):FireServer(...)
end

local function invokeRemote(name, ...)
	return ReplicatedStorage:WaitForChild("Remote"):WaitForChild(name):InvokeServer(...)
end

-- ──────────────────────────────────────────────
--  Window
-- ──────────────────────────────────────────────
print("[WSG] Loading Window")

local Window = Rayfield:CreateWindow({
	Name          = "Wizard Simulator",
	LoadingTitle  = "Wizard Simulator GUI",
	LoadingSubtitle = "by penguin",
	ConfigurationSaving = {
		Enabled    = true,
		FolderName = "wizardsimulatorgui",
		FileName   = "wizardsimulatorgui_config",
	},
	Discord = {
		Enabled      = true,
		Invite       = "fWncS2vFxn",
		RememberJoins = true,
	},
	KeySystem = false,
	KeySettings = {
		Title    = "Untitled",
		Subtitle = "Key System",
		Note     = "No method of obtaining the key is provided",
		FileName = "Key",
		SaveKey  = true,
		GrabKeyFromSite = false,
		Key      = {"random"},
	},
})

-- ──────────────────────────────────────────────
--  Info Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Info Tab")

local CreditTab = Window:CreateTab("Info", nil)
CreditTab:CreateLabel("Developed by penguin586970")
CreditTab:CreateLabel("Executor used for development: MacSploit, Delta (not affiliated!)")
CreditTab:CreateLabel("For questions/concerns, contact windows1267 on Discord or join via the GitHub")

-- ──────────────────────────────────────────────
--  QOL Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading QOL Tab")

local QOLTab = Window:CreateTab("QOL", nil)

-- Pets
QOLTab:CreateSection("Pets")

QOLTab:CreateInput({
	Name = "Select Pet",
	PlaceholderText = "Order in the Pet Menu",
	RemoveTextAfterFocusLost = false,
	Callback = function(Text)
		local num = tonumber(Text)
		if num ~= nil and num > 0 and math.floor(num) == num then
			vars.SelectedPet = num
		elseif Text == "" then
			vars.SelectedPet = nil
		else
			Rayfield:Notify({ Title = "Error", Content = "Has to be a positive integer", Duration = 5,
				Actions = { Ignore = { Name = "Debug", Callback = function() print("Input:", Text) end } } })
		end
	end,
})

QOLTab:CreateParagraph({ Title = "Equip/Unequip Pets", Content = "Enter the pet number, or the order of the pet when it appears in the pet menu." })

QOLTab:CreateDropdown({
	Name = "Pet Slot",
	Options = PetSlotOptions,
	CurrentOption = PetSlotOptions[1],
	MultipleOptions = false,
	Flag = "QOLDropdown1",
	Callback = function(Option)
		vars.SelectedPetSlotName = Option[1]
		for i, v in pairs(PetSlotOptions) do
			if v == vars.SelectedPetSlotName then vars.SelectedPetSlot = i; break end
		end
	end,
})

QOLTab:CreateButton({
	Name = "Equip Pet",
	Callback = function()
		if vars.SelectedPet and vars.SelectedPetSlot then
			ReplicatedStorage.Remote.EquipPet:FireServer(vars.SelectedPet, vars.SelectedPetSlot)
		else
			Rayfield:Notify({ Title = "Error", Content = "Pet Number or Pet Slot missing!", Duration = 5,
				Actions = { Ignore = { Name = "OK", Callback = function() end } } })
		end
	end,
})

QOLTab:CreateButton({
	Name = "Unequip Pet",
	Callback = function()
		ReplicatedStorage.Remote.EquipPet:FireServer(0, vars.SelectedPetSlot)
	end,
})

QOLTab:CreateParagraph({ Title = "Delete Pet", Content = "Select the slot you want to delete (in Select Pet Input). After deleting, the next pet shifts to that slot. The delete lock toggle must be active." })

QOLTab:CreateButton({
	Name = "Delete Pet",
	Callback = function()
		if vars.SelectedPet and vars.SelectedPet > 0 then
			if vars.DeletePetLockTimer > 0 then
				ReplicatedStorage.Remote.DeletePet:FireServer(vars.SelectedPet)
				if vars.AutoReroll then invokeRemote("OpenPetChest", vars.SelectedChest) end
			else
				Rayfield:Notify({ Title = "Delete Pet Lock",
					Content = "Delete Pet Lock is active. Press Disable Lock to allow deletion for 1 minute.", Duration = 5,
					Actions = { Ignore = { Name = "Disable Lock", Callback = function() vars.DeletePetLockTimer = 60 end } } })
			end
		else
			Rayfield:Notify({ Title = "No Pet Selected!", Content = "You did not select a pet slot above!", Duration = 5 })
		end
	end,
})

QOLTab:CreateButton({
	Name = "Disable Delete Pet Lock",
	Callback = function()
		vars.DeletePetLockTimer = 60
		Rayfield:Notify({ Title = "Pet Lock Enabled", Content = "You may now delete pets for 60 seconds!", Duration = 5 })
	end,
})

-- Chests
QOLTab:CreateSection("Chests")

QOLTab:CreateDropdown({
	Name = "Select Chest",
	Options = { "Training Area Chest","Werewolf Chest","Deep Seas Chest","Magma Chest","Castle Chest","Candy Chest","Cheap Mount Chest","Mount Chest" },
	CurrentOption = "Training Area Chest",
	MultipleOptions = false,
	Flag = "QOLDropdown2",
	Callback = function(Option)
		vars.SelectedChestName = Option[1]
		for i, v in pairs(ChestOptions) do
			if v == vars.SelectedChestName then vars.SelectedChest = i; break end
		end
	end,
})

QOLTab:CreateButton({
	Name = "Buy Chest",
	Callback = function() invokeRemote("OpenPetChest", vars.SelectedChest) end,
})

QOLTab:CreateParagraph({ Title = "Auto Reroll", Content = "Automatically deletes the pet in the selected slot and buys another chest." })

QOLTab:CreateButton({
	Name = "Reroll Pet",
	Callback = function()
		if vars.SelectedPet and vars.SelectedPet > 0 then
			if vars.DeletePetLockTimer > 0 then
				ReplicatedStorage.Remote.DeletePet:FireServer(vars.SelectedPet)
				invokeRemote("OpenPetChest", vars.SelectedChest)
			else
				Rayfield:Notify({ Title = "Delete Pet Lock", Content = "Disable the lock first.", Duration = 5 })
			end
		else
			Rayfield:Notify({ Title = "No Pet Selected!", Content = "You did not select a pet slot above!", Duration = 5 })
		end
	end,
})

local QOLToggle2 = QOLTab:CreateToggle({
	Name = "Roll Until Rarity",
	CurrentValue = false,
	Flag = "QOLToggle2",
	Callback = function(Value) vars.AutoReroll = Value end,
})

QOLTab:CreateDropdown({
	Name = "Target Rarities",
	Options = { "COMMON","RARE","EPIC","LEGENDARY","GODLY" },
	CurrentOption = "COMMON",
	MultipleOptions = true,
	Flag = "QOLDropdown3",
	Callback = function(Option) vars.SelectedRarities = Option end,
})

-- Scamming
QOLTab:CreateParagraph({ Title = "Scamming", Content = "Removes all pets from your side and accepts — usually too fast for the other side to react." })

QOLTab:CreateButton({
	Name = "Scam",
	Callback = function()
		for i = 1, 4 do fireRemote("TradeUpdate", "UpdateOffer", i, 0) end
		fireRemote("TradeUpdate", "SetReady", true)
	end,
})

-- GUI Blockers
QOLTab:CreateSection("GUI Blockers")

QOLTab:CreateToggle({ Name = "Remove Home TP Black Screen",     CurrentValue = false, Flag = "QOLToggle3", Callback = function(v) vars.HomeTPBlack     = v end })
QOLTab:CreateToggle({ Name = "Remove Location TP Black Screen", CurrentValue = false, Flag = "QOLToggle4", Callback = function(v) vars.LocationTPBlack = v end })

QOLTab:CreateToggle({
	Name = "Spell No Wait",
	CurrentValue = false,
	Flag = "QOLToggle5",
	Callback = function(Value)
		local actionhandler = require(Player.PlayerScripts.GameHandler.ActionHandler)
		local stats = debug.getupvalue(actionhandler.CastSpell, 2)
		for _, spell in stats do spell.NoWait = Value end
		debug.setupvalue(actionhandler.CastSpell, 2, stats)
	end,
})

QOLTab:CreateToggle({ Name = "No Stop", CurrentValue = false, Flag = "QOLToggle6", Callback = function(v) vars.NoStop = v end })

-- ──────────────────────────────────────────────
--  Quest Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Quest Tab")

local QuestTab = Window:CreateTab("Quest", nil)

QuestTab:CreateParagraph({ Title = "Quest Manipulation", Content = "Give yourself quests regardless of distance or level. Do NOT spam these remotes. There is a small cooldown between finishing and receiving a quest." })

QuestTab:CreateDropdown({
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
		"CJ:1","CJ:2","CJ:3","CJ:4","CJ:5","CJ:6","CJ:7","CJ:8","CJ:9","CJ:10","CJ:11",
	},
	CurrentOption = {"LJ:1"},
	MultipleOptions = false,
	Flag = "QuestDropdown1",
	Callback = function(Option) vars.SelectedQuest = Option[1] end,
})

local function giveQuest()
	if vars.SelectedQuest then
		ReplicatedStorage.Remote.AcceptQuest:FireServer(vars.SelectedQuest)
	else
		Rayfield:Notify({ Title = "Error", Content = "No quest selected!", Duration = 5,
			Actions = { Ignore = { Name = "Debug", Callback = function() print("SelectedQuest:", vars.SelectedQuest) end } } })
	end
end

QuestTab:CreateButton({ Name = "Give Quest", Callback = giveQuest })
QuestTab:CreateKeybind({ Name = "Keybind", CurrentKeybind = "F", HoldToInteract = false, Flag = "QuestKeybind1", Callback = giveQuest })

local function cancelQuest() fireRemote("CancelQuest") end
QuestTab:CreateButton({ Name = "Cancel Quest", Callback = cancelQuest })
QuestTab:CreateKeybind({ Name = "Keybind", CurrentKeybind = "F", HoldToInteract = false, Flag = "QuestKeybind2", Callback = cancelQuest })

QuestTab:CreateToggle({ Name = "Auto Give Quest", CurrentValue = false, Flag = "QuestToggle1", Callback = function(v) vars.AutoQuestToggle = v end })
QuestTab:CreateParagraph({ Title = "Auto Give", Content = "CJ:4 kills 1 Training Dummy (Training World) but gives a ton of XP and Gold — great for fast progression. Auto Give automatically fires CJ:4 whenever you press E or Q (assuming you one-shot Dummies)." })

-- ──────────────────────────────────────────────
--  Potion Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Potion Tab")

local PotionTab = Window:CreateTab("Potion", nil)

PotionTab:CreateParagraph({ Title = "Potion Triggers", Content = "Click buttons to pick up a potion (if available). Use Auto Health/Mana to pick up automatically when below threshold." })
PotionTab:CreateParagraph({ Title = "Replenish Rates", Content = "HP from Enemy Kill: 50%, HP from Spell: 25%, Mana: 30%. Rates from enemy kills are relative to the killing player's MAX HP/MANA." })

-- Health
PotionTab:CreateSection("Health")
local PotionButton1 = PotionTab:CreateButton({ Name = "Get Health Potion", Callback = function() if vars.HPot then firetouchinterest(RootPart, vars.HPot.Forcefield, 0) end end })
PotionTab:CreateKeybind({ Name = "Keybind", CurrentKeybind = "F", HoldToInteract = false, Flag = "PotionKeybind1", Callback = function() if vars.HPot then firetouchinterest(RootPart, vars.HPot.Forcefield, 0) end end })
PotionTab:CreateToggle({ Name = "Auto Health", CurrentValue = false, Flag = "PotionToggle1", Callback = function(v) vars.AutoHealthToggle = v end })
PotionTab:CreateSlider({ Name = "Auto Health Threshold", Range = {0,100}, Increment = 1, Suffix = "% HP",   CurrentValue = 50, Flag = "PotionSlider1", Callback = function(v) vars.AutoHealthThreshold = v end })

-- Mana
PotionTab:CreateSection("Mana")
local PotionButton2 = PotionTab:CreateButton({ Name = "Get Mana Potion", Callback = function() if vars.MPot then firetouchinterest(Humanoid.LeftLeg, vars.MPot.Forcefield, 0) end end })
PotionTab:CreateKeybind({ Name = "Keybind", CurrentKeybind = "F", HoldToInteract = false, Flag = "PotionKeybind2", Callback = function() if vars.MPot then firetouchinterest(Humanoid.LeftLeg, vars.MPot.Forcefield, 0) end end })
PotionTab:CreateToggle({ Name = "Auto Mana", CurrentValue = false, Flag = "PotionToggle2", Callback = function(v) vars.AutoManaToggle = v end })
PotionTab:CreateSlider({ Name = "Auto Mana Threshold", Range = {0,100}, Increment = 1, Suffix = "% Mana", CurrentValue = 70, Flag = "PotionSlider2", Callback = function(v) vars.AutoManaThreshold = v end })

-- ──────────────────────────────────────────────
--  Auto Farm Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Auto Farm Tab")

local AutoFarmTab = Window:CreateTab("Auto Farm", nil)

AutoFarmTab:CreateParagraph({ Title = "Auto Farm", Content = "Automatically farms an enemy, targeting the closest one within spell range. Configure below." })

local AutoFarmToggle1 = AutoFarmTab:CreateToggle({ Name = "Auto Farm Toggle", CurrentValue = false, Flag = "AutoFarmToggle1", Callback = function(v) vars.AutoFarmToggle = v end })

AutoFarmTab:CreateKeybind({
	Name = "Keybind", CurrentKeybind = "F", HoldToInteract = false, Flag = "AutoFarmKeybind1",
	Callback = function()
		vars.AutoFarmToggle = not vars.AutoFarmToggle
		AutoFarmToggle1:Set(vars.AutoFarmToggle)
		Rayfield:Notify({ Title = "Auto Farm", Content = "Toggled!", Duration = 5 })
	end,
})

AutoFarmTab:CreateSection("Settings")

AutoFarmTab:CreateDropdown({
	Name = "Enemy Selection",
	Options = {
		"[1] Training Dummy","[3] Dummy Warrior","[6] Dummy Archer","[8] Dummy Spearman","[12] Dummy Wizard",
		"[24] Earth Golem","[24] Summoned Earth Rock","Dummy King","[12] Green Slime","[17] Giant Green Slime",
		"[15] Spider","[20] Big Spider","[22] Wolf","[25] Werewolf","[26] Bear","[32] Stone Golem","[32] Summoned Rock",
		"Lumberjack","Lumberjack? (Werewolf)","[28] Beach Crab","[30] Clam","[32] Rock Crab","[35] Jellyfish",
		"[36] Ice Jellyfish","[38] Green Pirate","[39] Red Pirate","[42] Water Golem","[42] Summoned Water Rock",
		"Pirate King","[40] Magma Slime","[43] Giant Magma Slime","[43] Fire Ant","[46] Giant Fire Ant",
		"[48] Magma Crab","[49] Magma Spider","[51] Magma Scorpion","[53] Magma Worm","[54] Magma Golem",
		"[54] Summoned Magma Rock","Magma King","Magma Eater","[58] Elite Dummy Knight","[60] Elite Dummy Archer",
		"[62] Elite Dummy Spearman","[64] Wasp","[66] Giant Wasp","[66] Stumpant","[68] Treant","[69] Rock Scorpion",
		"[71] Rock Titan","[74] Small Jello","[75] Cupcake","[77] Donut","[78] Big Jello","[80] Gummy Worm",
		"[81] Gingerbread Soldier","[82] Gingerbread Wizard","[84] Candy Golem","Candy Chomper (also targets gates)",
	},
	CurrentOption = {"[1] Training Dummy"},
	MultipleOptions = true,
	Flag = "AutoFarmDropdown1",
	Callback = function(Options)
		vars.AutoFarmEnemyNames = {}
		vars.AutoFarmEnemies    = {}
		for _, Option in ipairs(Options) do
			table.insert(vars.AutoFarmEnemyNames, Option)
			for Identifier, Name in pairs(AutoFarmEnemyOptions) do
				if Name == Option then table.insert(vars.AutoFarmEnemies, Identifier); break end
			end
		end
	end,
})

AutoFarmTab:CreateDropdown({ Name = "Target Method", Options = {"Closest","Farthest","Never Hit"}, CurrentOption = {"Closest"}, MultipleOptions = false, Flag = "AutoFarmDropdown2", Callback = function(Option) vars.AutoFarmTarget = Option[1] end })

AutoFarmTab:CreateButton({
	Name = "Clear Hit Enemies",
	Callback = function()
		vars.HitEnemies = {}
		Rayfield:Notify({ Title = "Clear Hit Enemies", Content = "All tracked enemies cleared. Useful since the script can attack through walls and doesn't verify actual hits.", Duration = 5 })
	end,
})

AutoFarmTab:CreateParagraph({ Title = "Spell Delay", Content = "Time (seconds) to cycle through ONE spell slot. Set this to the spell's recharge time. You should have the same spell in both slots." })
AutoFarmTab:CreateSlider({ Name = "Spell Delay", Range = {0,20}, Increment = 0.1, Suffix = "sec",   CurrentValue = 1.5, Flag = "AutoFarmSlider1", Callback = function(v) vars.AutoFarmDelay = v end })

AutoFarmTab:CreateParagraph({ Title = "Spell Range", Content = "Range (studs) required to hit an enemy. Guess and check — the algorithm targets the closest enemy within range." })
AutoFarmTab:CreateSlider({ Name = "Spell Range", Range = {0,150}, Increment = 1, Suffix = "studs", CurrentValue = 85, Flag = "AutoFarmSlider2", Callback = function(v) vars.SpellRange = v end })

AutoFarmTab:CreateParagraph({ Title = "Auto Farm Quest", Content = "Auto-gives CJ:4 (Kill 1 Training Dummy) — widely considered the fastest XP+Gold grind. Replaces Auto Give Quest; disable that if using this." })
AutoFarmTab:CreateToggle({ Name = "Auto Farm Quest", CurrentValue = false, Flag = "AutoFarmToggle2", Callback = function(v) vars.AutoFarmQuestToggle = v end })
AutoFarmTab:CreateToggle({ Name = "Auto Recharge at 30% (requires gamepass)", CurrentValue = false, Flag = "AutoFarmToggle3", Callback = function(v) vars.AutoRechargeToggle = v end })

-- ──────────────────────────────────────────────
--  Tracker Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Tracker Tab")

local TrackerTab = Window:CreateTab("Tracker", nil)

local ToggleGold, ToggleXP, ResetGold, ResetXP  -- forward declare

TrackerTab:CreateButton({
	Name = "Toggle Trackers",
	Callback = function()
		ToggleGold(); ToggleXP()
		Rayfield:Notify({ Title = "Toggle Trackers", Content = "Toggled both Gold and XP trackers.", Duration = 5 })
	end,
})

TrackerTab:CreateButton({
	Name = "Reset Trackers",
	Callback = function()
		ResetGold(); ResetXP()
		Rayfield:Notify({ Title = "Reset Trackers", Content = "Reset both Gold and XP trackers.", Duration = 5 })
	end,
})

TrackerTab:CreateSection("Gold")
local TrackerLabel1 = TrackerTab:CreateLabel("Tracked Gold: 0")
local TrackerLabel2 = TrackerTab:CreateLabel("Tracked Duration: 0 seconds")
local TrackerLabel3 = TrackerTab:CreateLabel("Gold/Hour: 0")
local TrackerToggle1 = TrackerTab:CreateToggle({ Name = "Track Gold", CurrentValue = false, Flag = "TrackerToggle1", Callback = function(v) vars.TrackGold = v end })
TrackerTab:CreateButton({ Name = "Reset Gold", Callback = function() ResetGold(); Rayfield:Notify({ Title = "Reset Gold", Content = "Tracked Gold has been reset.", Duration = 5 }) end })

TrackerTab:CreateSection("XP")
local TrackerLabel4 = TrackerTab:CreateLabel("Tracked XP: 0")
local TrackerLabel5 = TrackerTab:CreateLabel("Tracked Duration: 0 seconds")
local TrackerLabel6 = TrackerTab:CreateLabel("XP/Hour: 0")
local TrackerToggle2 = TrackerTab:CreateToggle({ Name = "Track XP", CurrentValue = false, Flag = "TrackerToggle2", Callback = function(v) vars.TrackXP = v end })
TrackerTab:CreateButton({ Name = "Reset XP", Callback = function() ResetXP(); Rayfield:Notify({ Title = "Reset XP", Content = "Tracked XP has been reset.", Duration = 5 }) end })

TrackerTab:CreateSection("Levels")
TrackerTab:CreateSection("A more accurate display of leveling than the default GUI bar")
TrackerTab:CreateSection("Numbers are still a rough estimate")
local TrackerLabel9  = TrackerTab:CreateLabel("Level: 0")
local TrackerLabel10 = TrackerTab:CreateLabel("XP To Next Level: 0")
local TrackerLabel11 = TrackerTab:CreateLabel("Time to Next Level: No Data")

-- ──────────────────────────────────────────────
--  Tools Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Tools Tab")

local ToolTab = Window:CreateTab("Tools", nil)

ToolTab:CreateParagraph({ Title = "Small Things", Content = "Probably available in other universal scripts, but easy to access here. Keeping walkspeed toggled at 16 will cancel spell delay." })

ToolTab:CreateLabel("Walkspeed")
ToolTab:CreateToggle({ Name = "Walkspeed Toggle", CurrentValue = false, Flag = "ToolToggle1", Callback = function(v) vars.WalkspeedToggle = v end })
ToolTab:CreateSlider({ Name = "Walkspeed", Range = {0,100}, Increment = 1, Suffix = "Studs/Sec", CurrentValue = 16, Flag = "ToolSlider1", Callback = function(v) vars.Walkspeed = v end })
ToolTab:CreateToggle({ Name = "Jump Power Toggle", CurrentValue = false, Flag = "ToolToggle2", Callback = function(v) vars.JumpPowerToggle = v end })
ToolTab:CreateSlider({ Name = "Jump Power", Range = {0,250}, Increment = 1, Suffix = "Studs", CurrentValue = 50, Flag = "ToolSlider2", Callback = function(v) vars.JumpPower = v end })

ToolTab:CreateSection("Performance")
ToolTab:CreateToggle({
	Name = "Disable Rendering",
	CurrentValue = false,
	Flag = "ToolToggle3",
	Callback = function(Value)
		vars.DisableRendering = Value
		RunService:Set3dRenderingEnabled(not Value)
	end,
})

ToolTab:CreateSection("Universal Scripts")
ToolTab:CreateButton({ Name = "Infinite Yield",                   Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end })
ToolTab:CreateButton({ Name = "Remote Spy (Simple Spy v3)",        Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/78n/SimpleSpy/main/SimpleSpySource.lua"))() end })
ToolTab:CreateButton({ Name = "Remote Spy (Simple Spy v2.2)",      Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua"))() end })
ToolTab:CreateButton({ Name = "Orca",                              Callback = function() loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/richie0866/orca/master/public/latest.lua"))() end })
ToolTab:CreateButton({ Name = "CMD-X",                             Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))() end })
ToolTab:CreateButton({ Name = "Dex v4",                            Callback = function() loadstring(game:GetObjects("rbxassetid://418957341")[1].Source)() end })
ToolTab:CreateButton({ Name = "Dark Dex Mobile (Modded DDex v3)",  Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/refs/heads/main/Universal/BypassedDarkDexV3.lua", true))() end })

-- ──────────────────────────────────────────────
--  Options Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Options Tab")

local OptionsTab = Window:CreateTab("Options", nil)
OptionsTab:CreateDropdown({
	Name = "Themes",
	Options = {"Default","AmberGlow","Amethyst","Bloom","DarkBlue","Green","Light","Ocean","Serenity"},
	CurrentOption = {"Default"},
	MultipleOptions = false,
	Flag = "OptionsDropdown1",
	Callback = function(Options) Window.ModifyTheme(Options[1]) end,
})

-- ──────────────────────────────────────────────
--  Debug Tab
-- ──────────────────────────────────────────────
print("[WSG] Loading Debug Tab")

local DebugTab = Window:CreateTab("Debug", nil)

DebugTab:CreateButton({
	Name = "Reset All Keybinds",
	Callback = function()
		for _, flag in ipairs({"QuestKeybind1","QuestKeybind2","PotionKeybind1","PotionKeybind2","AutoFarmKeybind1"}) do
			-- Rayfield handles keybinds by flag; re-set via the stored references isn't needed here
		end
	end,
})

DebugTab:CreateButton({
	Name = "Dump HitEnemies",
	Callback = function()
		print("Dumping HitEnemies:")
		for i, v in pairs(vars.HitEnemies) do print(i, v) end
		print("Done")
	end,
})

DebugTab:CreateButton({ Name = "Kill GUI", Callback = function() Rayfield:Destroy() end })

DebugTab:CreateButton({
	Name = "Teleport to Position",
	Callback = function() Player.Character:SetPrimaryPartCFrame(CFrame.new(903, 4.1, -400)) end,
})

DebugTab:CreateButton({ Name = "Print in Console", Callback = function() print("hi") end })

-- ──────────────────────────────────────────────
--  Background loops & events
-- ──────────────────────────────────────────────
print("[WSG] Loading Scripts")

-- Level + position poller
task.spawn(function()
	while task.wait(0.1) do
		vars.Level = Player.Level.Value
		if vars.Level == "Boss" then
			vars.Arena = Player.Level:FindFirstChild("Arena") and Player.Level.Arena.Value
		end
		if Player.Character then
			vars.PlayerPos = Player.Character.PrimaryPart and Player.Character.PrimaryPart.Position
		end
	end
end)

-- Input: auto quest
UserInputService.InputBegan:Connect(function(input)
	if vars.AutoQuestToggle then
		if input.KeyCode == Enum.KeyCode.E or input.KeyCode == Enum.KeyCode.Q then
			ReplicatedStorage.Remote.AcceptQuest:FireServer("CJ:4")
		end
	end
end)

-- Pet lock countdown
task.spawn(function()
	while task.wait(1) do
		if vars.DeletePetLockTimer > 0 then vars.DeletePetLockTimer = vars.DeletePetLockTimer - 1 end
	end
end)

-- Home TP black screen
GameGUI.ChildAdded:Connect(function(Object)
	if Object.Name == "Frame" and vars.HomeTPBlack then
		Object.Visible = false
		if vars.HomeTPTimer == 0 then vars.HomeTPTimer = 2 end
	end
end)
task.spawn(function()
	while task.wait() do
		if vars.HomeTPTimer == 2 then Rayfield:Notify({ Title = "Teleporting...", Content = "", Duration = 1 }) end
		if vars.HomeTPTimer > 0 then vars.HomeTPTimer = vars.HomeTPTimer - 1; task.wait(1) end
	end
end)

-- Location TP black screen
GameGUI:FindFirstChild("Black").ChildAdded:Connect(function()
	if vars.LocationTPBlack then
		GameGUI.Black.Visible = false
		if vars.LocationTPTimer == 0 then vars.LocationTPTimer = 3 end
	end
end)
task.spawn(function()
	while task.wait() do
		if vars.LocationTPTimer == 3 then Rayfield:Notify({ Title = "Teleporting...", Content = "", Duration = 2 }) end
		if vars.LocationTPTimer > 0 then vars.LocationTPTimer = vars.LocationTPTimer - 1; task.wait(1) end
	end
end)

-- Health tracker
Humanoid.HealthChanged:Connect(function()
	vars.HealthPercentage = Humanoid.Health / Humanoid.MaxHealth * 100
end)

-- Mana tracker
task.spawn(function()
	while task.wait(0.1) do
		vars.Mana    = Player.Mana.value
		vars.MaxMana = Player.MaxMana.value
		if vars.PreviousMana ~= vars.Mana then
			vars.ManaPercentage = vars.Mana / vars.MaxMana * 100
		end
		vars.PreviousMana = vars.Mana
	end
end)

-- Potion availability + auto pickup
task.spawn(function()
	while task.wait(0.1) do
		pcall(function() vars.HPot = Workspace.Effects:FindFirstChild("HealthPotion") end)
		pcall(function() vars.MPot = Workspace.Effects:FindFirstChild("ManaPotion")   end)

		PotionButton1:Set(vars.HPot and "Get Health Potion - Available" or "Get Health Potion - Unavailable")
		PotionButton2:Set(vars.MPot and "Get Mana Potion - Available"   or "Get Mana Potion - Unavailable")

		if vars.AutoHealthToggle and vars.HealthPercentage < vars.AutoHealthThreshold then
			if vars.HPot then firetouchinterest(Humanoid.LeftLeg, vars.HPot.Forcefield, 0) end
		end
		if vars.AutoManaToggle and vars.ManaPercentage < vars.AutoManaThreshold then
			if vars.MPot then firetouchinterest(Humanoid.LeftLeg, vars.MPot.Forcefield, 0) end
		end
	end
end)

-- Auto Farm
local function ConnectEnemyRemoved(Folder)
	if Folder and not vars.ConnectedEnemyFolders[Folder] then
		vars.ConnectedEnemyFolders[Folder] = Folder.ChildRemoved:Connect(function(e) vars.HitEnemies[e] = nil end)
	end
end

task.spawn(function()
	while task.wait(vars.AutoFarmDelay / 2) do
		if vars.PlayerPos and vars.AutoFarmToggle then
			local TargetEnemy    = nil
			local TargetDistance = vars.AutoFarmTarget == "Farthest" and 0 or math.huge

			local function checkEnemy(Enemy)
				local EnemyPos = Enemy.PrimaryPart and Enemy.PrimaryPart.Position
				if not EnemyPos then return end
				local dist = (vars.PlayerPos - EnemyPos).Magnitude

				if vars.AutoFarmTarget == "Closest" and dist < TargetDistance and dist < vars.SpellRange then
					TargetEnemy, TargetDistance = Enemy, dist
				elseif vars.AutoFarmTarget == "Farthest" and dist > TargetDistance and dist < vars.SpellRange then
					TargetEnemy, TargetDistance = Enemy, dist
				elseif vars.AutoFarmTarget == "Never Hit" and not vars.HitEnemies[Enemy] and dist < TargetDistance and dist < vars.SpellRange then
					TargetEnemy, TargetDistance = Enemy, dist
				end
			end

			for _, EnemyName in ipairs(vars.AutoFarmEnemies) do
				for _, LevelFolder in ipairs(Workspace.Levels:GetChildren()) do
					local folder = LevelFolder:FindFirstChild("Enemies")
					if folder then
						ConnectEnemyRemoved(folder)
						for _, e in ipairs(folder:GetChildren()) do if e.Name == EnemyName then checkEnemy(e) end end
					end
				end
				for _, ArenaFolder in ipairs(Workspace.BossArenas:GetChildren()) do
					local folder = ArenaFolder:FindFirstChild("Enemies")
					if folder then
						ConnectEnemyRemoved(folder)
						for _, e in ipairs(folder:GetChildren()) do if e.Name == EnemyName then checkEnemy(e) end end
					end
				end
			end

			if TargetEnemy and TargetDistance < vars.SpellRange then
				if vars.AutoFarmQuestToggle then ReplicatedStorage.Remote.AcceptQuest:FireServer("CJ:4") end
				ReplicatedStorage.Remote.CastSpell:FireServer(vars.SpellState, TargetEnemy)
				if vars.AutoFarmTarget == "Never Hit" then vars.HitEnemies[TargetEnemy] = "hit" end
				vars.SpellState = 3 - vars.SpellState
			end
		end
	end
end)

-- Auto Recharge
task.spawn(function()
	while task.wait(0.1) do
		if vars.AutoRechargeToggle and vars.ManaPercentage and vars.ManaPercentage < 30 then
			ReplicatedStorage.Remote.Recharge:FireServer()
		end
	end
end)

-- Tracker: parse pickup GUI
local function ParseTrackerText(text)
	local amount, abbreviation, TextType = text:match("([%d]*[%.]*[%d]*)%s*([kMB]?)%s*(%a*)")
	if not TextType or TextType == "" then TextType = "Gold" end
	local Multiplier = Multipliers[abbreviation:upper()] or 1
	return tonumber(amount) * Multiplier, TextType
end

local function commaFormat(n)
	return string.format("%0.0f", n):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

PickupGuiContainer.ChildAdded:Connect(function(GuiFrame)
	for _, TextLabel in ipairs(GuiFrame:GetChildren()) do
		if TextLabel.Name == "Amount" and not vars.TrackedElements[GuiFrame] then
			task.wait(0.1)
			local Amount, Type = ParseTrackerText(TextLabel.Text)
			if Type == "Gold" then
				if vars.TrackGold then vars.TrackedGold = vars.TrackedGold + Amount; TrackerLabel1:Set("Tracked Gold: " .. commaFormat(vars.TrackedGold)) end
			elseif Type == "XP" then
				if vars.TrackXP then vars.TrackedXP = vars.TrackedXP + Amount; TrackerLabel4:Set("Tracked XP: " .. commaFormat(vars.TrackedXP)) end
			else
				Rayfield:Notify({ Title = "Error", Content = "Unknown statistic type! See console.", Duration = 5,
					Actions = { Ignore = { Name = "Debug", Callback = function() print("Raw:", TextLabel.Text, "Amount:", Amount, "Type:", Type) end } } })
			end
			vars.TrackedElements[GuiFrame] = true
			GuiFrame.AncestryChanged:Connect(function(_, parent) if not parent then vars.TrackedElements[GuiFrame] = nil end end)
			break
		end
	end
end)

-- Tracker timers
task.spawn(function()
	while task.wait(1) do
		local function buildDuration(seconds)
			local h = math.floor(seconds / 3600)
			local m = math.floor((seconds % 3600) / 60)
			local s = seconds % 60
			if h > 0 then return h.." hour(s), "..m.." minute(s), and "..s.." second(s)"
			elseif m > 0 then return m.." minute(s) and "..s.." second(s)"
			else return s.." second(s)" end
		end

		if vars.TrackGold then
			vars.TrackedGoldTimer = vars.TrackedGoldTimer + 1
			TrackerLabel2:Set("Tracked Duration: " .. buildDuration(vars.TrackedGoldTimer))
			vars.GoldPerHour = math.floor(vars.TrackedGold / vars.TrackedGoldTimer * 3600)
			TrackerLabel3:Set("Gold/Hour: " .. commaFormat(vars.GoldPerHour))
		end

		if vars.TrackXP then
			vars.TrackedXPTimer = vars.TrackedXPTimer + 1
			TrackerLabel5:Set("Tracked Duration: " .. buildDuration(vars.TrackedXPTimer))
			vars.XPPerHour = math.floor(vars.TrackedXP / vars.TrackedXPTimer * 3600)
			TrackerLabel6:Set("XP/Hour: " .. commaFormat(vars.XPPerHour))
		end
	end
end)

-- Walkspeed / Jump Power
task.spawn(function()
	while task.wait(0.01) do
		if vars.WalkspeedToggleOld and not vars.WalkspeedToggle then Humanoid.WalkSpeed = 16 end
		if vars.WalkspeedToggle then Humanoid.WalkSpeed = vars.Walkspeed end
		if vars.JumpPowerToggleOld and not vars.JumpPowerToggle then Humanoid.JumpPower = 50 end
		if vars.JumpPowerToggle then Humanoid.JumpPower = vars.JumpPower end
		vars.WalkspeedToggleOld = vars.WalkspeedToggle
		vars.JumpPowerToggleOld = vars.JumpPowerToggle
	end
end)

-- (Unused) Refill Mana helper
local function RefillMana()
	if vars.Level ~= "Boss" then
		ReplicatedStorage.Remote.TouchedRecharge:FireServer(Workspace.Levels.level:WaitForChild("SpawnPoint"))
	end
end

-- Toggle / Reset tracker closures
ToggleGold = function() vars.TrackGold = not vars.TrackGold; TrackerToggle1:Set(vars.TrackGold) end
ToggleXP   = function() vars.TrackXP   = not vars.TrackXP;  TrackerToggle2:Set(vars.TrackXP) end

ResetGold = function()
	vars.TrackedGold = 0; vars.TrackedGoldTimer = 0; vars.GoldPerHour = 0
	TrackerLabel1:Set("Tracked Gold: 0"); TrackerLabel2:Set("Tracked Duration: 0 seconds"); TrackerLabel3:Set("Gold/Hour: 0")
end

ResetXP = function()
	vars.TrackedXP = 0; vars.TrackedXPTimer = 0; vars.XPPerHour = 0
	TrackerLabel4:Set("Tracked XP: 0"); TrackerLabel5:Set("Tracked Duration: 0 seconds"); TrackerLabel6:Set("XP/Hour: 0")
end

-- XP level tracker
local function ParseTotalXPValue(value)
	local number, unit = value:match("/([%d%.]+)([KMBT]?)")
	number = tonumber(number)
	if unit == "K" then number = number * 1e3
	elseif unit == "M" then number = number * 1e6
	elseif unit == "B" then number = number * 1e9
	elseif unit == "T" then number = number * 1e12 end
	return number
end

task.spawn(function()
	while task.wait(1) do
		local XPBar  = GameGUI.Stats.ExperienceOutside.Bar
		local XPText = GameGUI.Stats.ExperienceOutside.Amount
		if XPBar and XPText then
			vars.PlayerLevel = Player.leaderstats.Level.Value
			TrackerLabel9:Set("Level: " .. vars.PlayerLevel)
			vars.PlayerXPPercentage = XPBar.Size.X.Scale
			vars.PlayerTotalXP      = ParseTotalXPValue(XPText.Text)
			local MissingXP = round((1 - vars.PlayerXPPercentage) * vars.PlayerTotalXP)
			TrackerLabel10:Set("XP To Next Level: " .. commaFormat(MissingXP))
			if vars.XPPerHour and vars.XPPerHour > 0 then
				vars.LevelTimer   = round(MissingXP / vars.XPPerHour * 3600)
				vars.LevelHours   = math.floor(vars.LevelTimer / 3600)
				vars.LevelMinutes = math.floor((vars.LevelTimer % 3600) / 60)
				vars.LevelSeconds = vars.LevelTimer % 60
				if vars.LevelHours > 0 then
					vars.LevelDuration = vars.LevelHours..":"..vars.LevelMinutes..":"..vars.LevelSeconds.." (h,m,s)"
				elseif vars.LevelMinutes > 0 then
					vars.LevelDuration = vars.LevelMinutes..":"..vars.LevelSeconds.." (m,s)"
				else
					vars.LevelDuration = vars.LevelSeconds.."s"
				end
				TrackerLabel11:Set("Time To Next Level: " .. vars.LevelDuration)
			end
		end
		if vars.XPPerHour and vars.XPPerHour <= 0 then
			TrackerLabel11:Set("Time To Next Level: No Data")
		end
	end
end)

-- Auto Reroll until rarity
task.spawn(function()
	while task.wait(0.1) do
		local PetGUI = GameGUI.Pets
		if PetGUI and vars.AutoReroll then
			if not (vars.SelectedPet and vars.SelectedPet > 0) then
				Rayfield:Notify({ Title = "No Pet Selected!", Content = "You did not select a pet slot above!", Duration = 5 })
				vars.AutoReroll = false
				QOLToggle2:Set(false)
			elseif vars.DeletePetLockTimer <= 0 then
				Rayfield:Notify({ Title = "Delete Pet Lock", Content = "Disable the lock first.", Duration = 5 })
				vars.AutoReroll = false
				QOLToggle2:Set(false)
			elseif not PetGUI.Visible then
				Rayfield:Notify({ Title = "Pet GUI Not Visible", Content = "Open the Pet Menu so rarity can be checked.", Duration = 5 })
				vars.AutoReroll = false
				QOLToggle2:Set(false)
			else
				local slot = PetGUI.ListFrame.ListBackground.List:FindFirstChild(vars.SelectedPet)
				if not slot then
					Rayfield:Notify({ Title = "Pet Not Found", Content = "Check that there is a pet in the inputted slot.", Duration = 5 })
					vars.AutoReroll = false
					QOLToggle2:Set(false)
				else
					local correctRarity = false
					for _, rarity in pairs(vars.SelectedRarities) do
						if rarity == slot.Rarity.Text then correctRarity = true; break end
					end
					if correctRarity then
						Rayfield:Notify({ Title = "Pet Found!", Content = "A pet of the selected rarity has been rolled! Manually reroll if you don't want it.", Duration = 5 })
						vars.AutoReroll = false
						QOLToggle2:Set(false)
					else
						ReplicatedStorage.Remote.DeletePet:FireServer(vars.SelectedPet)
						invokeRemote("OpenPetChest", vars.SelectedChest)
					end
				end
			end
		end
	end
end)

-- No Stop hook
local hook
hook = hookmetamethod(game, "__newindex", function(self, ...)
	local args = {...}
	if vars.NoStop and self == Humanoid and args[1] == "WalkSpeed" and args[2] == 0 then return end
	return hook(self, ...)
end)

print("[WSG] Loaded!")