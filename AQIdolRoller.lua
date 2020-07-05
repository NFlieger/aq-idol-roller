
--------------------------------------------------------------
---- Data
--------------------------------------------------------------

local CLASS = {
  NONE         = 0,
  WARRIOR      = 1,
  PALADIN      = 2,
  HUNTER       = 3,
  ROGUE        = 4,
  PRIEST       = 5,
  DEATH_KNIGHT = 6,
  SHAMAN       = 7,
  MAGE         = 8,
  WARLOCK      = 9,
  MONK         = 10,
  DRUID        = 11,
  DEMON_HUNTER = 12
}

local SCARABS = {
  20858, -- Stone Scarab
  20859, -- Gold Scarab
  20860, -- Silver Scarab
  20861, -- Bronze Scarab
  20862, -- Crystal Scarab
  20863, -- Clay Scarab
  20864, -- Bone Scarab
  20865, -- Ivory Scarab
}

local IDOLS = {}
---- AQ 20
-- Azure Idol
IDOLS[20866] = {}
IDOLS[20866][CLASS.HUNTER] = true
IDOLS[20866][CLASS.ROGUE] = true
IDOLS[20866][CLASS.MAGE] = true
-- Onyx Idol
IDOLS[20867] = {}
IDOLS[20867][CLASS.WARRIOR] = true
IDOLS[20867][CLASS.ROGUE] = true
IDOLS[20867][CLASS.WARLOCK] = true
-- Lambent Idol
IDOLS[20868] = {}
IDOLS[20868][CLASS.WARRIOR] = true
IDOLS[20868][CLASS.HUNTER] = true
IDOLS[20868][CLASS.PRIEST] = true
-- Amber Idol
IDOLS[20869] = {}
IDOLS[20869][CLASS.PALADIN] = true
IDOLS[20869][CLASS.HUNTER] = true
IDOLS[20869][CLASS.SHAMAN] = true
IDOLS[20869][CLASS.WARLOCK] = true
-- Jasper Idol
IDOLS[20870] = {}
IDOLS[20870][CLASS.PRIEST] = true
IDOLS[20870][CLASS.WARLOCK] = true
IDOLS[20870][CLASS.DRUID] = true
-- Obsidian Idol
IDOLS[20871] = {}
IDOLS[20871][CLASS.PALADIN] = true
IDOLS[20871][CLASS.PRIEST] = true
IDOLS[20871][CLASS.SHAMAN] = true
IDOLS[20871][CLASS.MAGE] = true
-- Vermillion Idol
IDOLS[20872] = {}
IDOLS[20872][CLASS.PALADIN] = true
IDOLS[20872][CLASS.ROGUE] = true
IDOLS[20872][CLASS.SHAMAN] = true
IDOLS[20872][CLASS.DRUID] = true
-- Alabaster Idol
IDOLS[20873] = {}
IDOLS[20873][CLASS.WARRIOR] = true
IDOLS[20873][CLASS.MAGE] = true
IDOLS[20873][CLASS.DRUID] = true
---- AQ 40
-- Idol of the Sun
IDOLS[20874] = {}
IDOLS[20874][CLASS.WARRIOR] = true
IDOLS[20874][CLASS.HUNTER] = true
IDOLS[20874][CLASS.ROGUE] = true
IDOLS[20874][CLASS.MAGE] = true
-- Idol of Night
IDOLS[20875] = {}
IDOLS[20875][CLASS.WARRIOR] = true
IDOLS[20875][CLASS.ROGUE] = true
IDOLS[20875][CLASS.MAGE] = true
IDOLS[20875][CLASS.WARLOCK] = true
-- Idol of Death
IDOLS[20876] = {}
IDOLS[20876][CLASS.WARRIOR] = true
IDOLS[20876][CLASS.PRIEST] = true
IDOLS[20876][CLASS.MAGE] = true
IDOLS[20876][CLASS.WARLOCK] = true
-- Idol of the Sage
IDOLS[20877] = {}
IDOLS[20877][CLASS.PALADIN] = true
IDOLS[20877][CLASS.PRIEST] = true
IDOLS[20877][CLASS.SHAMAN] = true
IDOLS[20877][CLASS.MAGE] = true
IDOLS[20877][CLASS.WARLOCK] = true
-- Idol of Rebirth
IDOLS[20878] = {}
IDOLS[20878][CLASS.PALADIN] = true
IDOLS[20878][CLASS.PRIEST] = true
IDOLS[20878][CLASS.SHAMAN] = true
IDOLS[20878][CLASS.WARLOCK] = true
IDOLS[20878][CLASS.DRUID] = true
-- Idol of Life
IDOLS[20879] = {}
IDOLS[20879][CLASS.PALADIN] = true
IDOLS[20879][CLASS.HUNTER] = true
IDOLS[20879][CLASS.PRIEST] = true
IDOLS[20879][CLASS.SHAMAN] = true
IDOLS[20879][CLASS.DRUID] = true
-- Idol of Strife
IDOLS[20881] = {}
IDOLS[20881][CLASS.PALADIN] = true
IDOLS[20881][CLASS.HUNTER] = true
IDOLS[20881][CLASS.ROGUE] = true
IDOLS[20881][CLASS.SHAMAN] = true
IDOLS[20881][CLASS.DRUID] = true
-- Idol of War
IDOLS[20882] = {}
IDOLS[20882][CLASS.WARRIOR] = true
IDOLS[20882][CLASS.HUNTER] = true
IDOLS[20882][CLASS.ROGUE] = true
IDOLS[20882][CLASS.DRUID] = true

local ROLL = {
  PASS  = 0,
  NEED  = 1,
  GREED = 2
}

local function getRollText(index)
  for k, v in pairs(ROLL) do
    if (v == index) then
      return k
    end
  end
  return "Missing Roll in getRollText(index)"
end

local rollOnClass = {}
local rollOnIdol = {}
local rollOnScarab = {}

function rollOnClass:addItem(itemId)
  local item = Item:CreateFromItemID(itemId)
  item:ContinueOnItemLoad(
    function()
      if (debug) then
        print(format("item added to auto loot: %d - %s", itemId, item:GetItemName()))
      end
      rollOnClass[item:GetItemName()] = true
    end
  )
end

function rollOnIdol:addItem(itemId)
  local item = Item:CreateFromItemID(itemId)
  item:ContinueOnItemLoad(
    function()
      if (debug) then
        print(format("item added to auto loot: %d - %s", itemId, item:GetItemName()))
      end
      rollOnIdol[item:GetItemName()] = true
    end
  )
end

function rollOnScarab:addItem(itemId)
  local item = Item:CreateFromItemID(itemId)
  item:ContinueOnItemLoad(
    function()
      if (debug) then
        print(format("item added to auto loot: %d - %s", itemId, item:GetItemName()))
      end
      rollOnScarab[item:GetItemName()] = true
    end
  )
end

---- options

local rollDefaultClass = ROLL.NEED
local rollDefaultIdol = ROLL.GREED
local rollDefaultScarab = ROLL.GREED
local debug = false

--------------------------------------------------------------
---- helper functions
--------------------------------------------------------------

local addonName = "AQIdolRoller"

local idolFrame = CreateFrame("Frame", addonName)
local panel = CreateFrame("Frame", addonName .. "Panel")
local saveSettingsButton = CreateFrame("CheckButton", "saveSettingsButton", panel, "ChatConfigCheckButtonTemplate")
saveSettingsButton:SetScript("OnClick",
  function()
    AQIdolRollerSettings["saveSettings"] = not AQIdolRollerSettings["saveSettings"]
  end
)
local classDropDown = CreateFrame("FRAME", "classDropDown", panel, "UIDropDownMenuTemplate")
local idolDropDown = CreateFrame("FRAME", "idolDropDown", panel, "UIDropDownMenuTemplate")
local scarabDropDown = CreateFrame("FRAME", "scarabDropDown", panel, "UIDropDownMenuTemplate")

-- print the current roll behaviour
local function printRollBehavior()
  for k, v in pairs(ROLL) do
    if (v == AQIdolRollerSettings["rollClass"]) then
      print(format("current roll behaviour for CLASS_IDOLs: %s", k))
    end
    if (v == AQIdolRollerSettings["rollIdol"]) then
      print(format("current roll behaviour for IDOLs: %s", k))
    end
    if (v == AQIdolRollerSettings["rollScarab"]) then
      print(format("current roll behaviour for SCARABs:  %s", k))
    end
  end
end

-- function for clicking on the class dropdown in the options panel
local function classDropDown_OnClick(_, arg1)
  AQIdolRollerSettings["rollClass"] = arg1
  UIDropDownMenu_SetText(classDropDown, getRollText(arg1))
end

-- initialization of the class dropdown panel
local function initClassDropDown(dropDown, level, menuList)
  local info = UIDropDownMenu_CreateInfo()
  info.func = classDropDown_OnClick
  for k, v in pairs(ROLL) do
    info.text = k
    info.arg1 = v
    info.checked = v == AQIdolRollerSettings["rollClass"]
    UIDropDownMenu_AddButton(info)
  end
end

-- function for clicking on the idol dropdown in the options panel
local function idolDropDown_OnClick(_, arg1)
  AQIdolRollerSettings["rollIdol"] = arg1
  UIDropDownMenu_SetText(idolDropDown, getRollText(arg1))
end

-- initialization of the idol dropdown panel
local function initIdolDropDown(dropDown, level, menuList)
  local info = UIDropDownMenu_CreateInfo()
  info.func = idolDropDown_OnClick
  for k, v in pairs(ROLL) do
    info.text = k
    info.arg1 = v
    info.checked = v == AQIdolRollerSettings["rollIdol"]
    UIDropDownMenu_AddButton(info)
  end
end

-- function for clicking on the scarab dropdown in the options panel
local function scarabDropDown_OnClick(_, arg1)
  AQIdolRollerSettings["rollScarab"] = arg1
  UIDropDownMenu_SetText(scarabDropDown, getRollText(arg1))
end

-- initialization of the scarab dropdown panel
local function initScarabDropDown(dropDown, level, menuList)
  local info = UIDropDownMenu_CreateInfo()
  info.func = scarabDropDown_OnClick
  for k, v in pairs(ROLL) do
    info.text = k
    info.arg1 = v
    info.checked = v == AQIdolRollerSettings["rollScarab"]
    UIDropDownMenu_AddButton(info)
  end
end

-- initialization of the addon panel
local function InitializePanel()
  panel.name = "AQ Idol Roller"

  InterfaceOptions_AddCategory(panel)

  local title = panel:CreateFontString(addonName .. "Title", "OVERLAY", "GameFontNormalLarge")
  title:SetPoint("TOP", 0, -12)
  title:SetText(panel.name)

  -- save settings
  local saveSettingsText = panel:CreateFontString(addonName .. "saveSettingsText", "OVERLAY", "GameFontNormalSmall")
  saveSettingsText:SetPoint("TOPLEFT", 35, -45)
  saveSettingsText:SetText("Load all these settings after a relog / reloadui ?")

  local saveSettingsText2 = panel:CreateFontString(addonName .. "saveSettingsText2", "OVERLAY", "GameFontNormalSmall")
  saveSettingsText2:SetPoint("TOPLEFT", 35, -65)
  saveSettingsText2:SetText(format("If not, the default roll behaviours (%s, %s, %s) will ge selected again.", getRollText(rollDefaultClass), getRollText(rollDefaultIdol), getRollText(rollDefaultScarab)))

  saveSettingsButton:SetPoint("TOPLEFT", 10, -48)
  saveSettingsButton:SetChecked(AQIdolRollerSettings["saveSettings"])

  -- class behaviour
  local classRollText = panel:CreateFontString(addonName .. "classRollText", "OVERLAY", "GameFontNormalSmall")
  classRollText:SetPoint("TOPLEFT", 10, -135)
  classRollText:SetText("Matching Class Idol rolls:")

  classDropDown:SetPoint("TOPLEFT", 0, -150)
  UIDropDownMenu_SetText(classDropDown, getRollText(AQIdolRollerSettings["rollClass"]))
  UIDropDownMenu_Initialize(classDropDown, initClassDropDown, 1)

  -- idol behaviour
  local idolRollText = panel:CreateFontString(addonName .. "idolRollText", "OVERLAY", "GameFontNormalSmall")
  idolRollText:SetPoint("TOPLEFT", 185, -135)
  idolRollText:SetText("Other Idol rolls:")

  idolDropDown:SetPoint("TOPLEFT", 175, -150)
  UIDropDownMenu_SetText(idolDropDown, getRollText(AQIdolRollerSettings["rollIdol"]))
  UIDropDownMenu_Initialize(idolDropDown, initIdolDropDown, 1)

  -- scarab behaviour
  local scarabRollText = panel:CreateFontString(addonName .. "scarabRollText", "OVERLAY", "GameFontNormalSmall")
  scarabRollText:SetPoint("TOPLEFT", 360, -135)
  scarabRollText:SetText("Scarab rolls:")

  scarabDropDown:SetPoint("TOPLEFT", 350, -150)
  UIDropDownMenu_SetText(scarabDropDown, getRollText(AQIdolRollerSettings["rollScarab"]))
  UIDropDownMenu_Initialize(scarabDropDown, initScarabDropDown, 1)

  -- info footer
  local info1 = panel:CreateFontString(addonName .. "info1", "OVERLAY", "GameFontNormalSmall")
  info1:SetPoint("TOPLEFT", 70, -335)
  info1:SetText("All options will be saved immediatly without using the Okay or Cancel Button below.")

  local helpText = panel:CreateFontString(addonName .. "Help", "OVERLAY", "GameFontNormalSmall")
  helpText:SetPoint("TOPLEFT", 10, -400)
  helpText:SetText("For more information, type /aqroll help")
end

-- ADDON_LOADED
function idolFrame:ADDON_LOADED(eventName)
  if (debug) then
    print(format("event found in idolFrame:ADDON_LOADED: %s", eventName))
  end
  if (eventName == addonName) then
    if (AQIdolRollerSettings == nil or not AQIdolRollerSettings["saveSettings"]) then
      AQIdolRollerSettings = {}
      AQIdolRollerSettings["rollClass"] = rollDefaultClass
      AQIdolRollerSettings["rollIdol"] = rollDefaultIdol
      AQIdolRollerSettings["rollScarab"] = rollDefaultScarab
    else
      if (AQIdolRollerSettings["rollClass"] == nil) then
        AQIdolRollerSettings["rollClass"] = rollDefaultClass
      end
      if (AQIdolRollerSettings["rollIdol"] == nil) then
        AQIdolRollerSettings["rollIdol"] = rollDefaultIdol
      end
      if (AQIdolRollerSettings["rollScarab"] == nil) then
        AQIdolRollerSettings["rollScarab"] = rollDefaultScarab
      end
    end
    InitializePanel()
    for _, v in pairs(SCARABS) do
      rollOnScarab:addItem(v)
      if (debug) then
        print(format("item added to scarab: %d", v))
      end
    end
    local _, _, classIndex = UnitClass("player")
    for k, _ in pairs(IDOLS) do
      if (IDOLS[k][classIndex]) then
        rollOnClass:addItem(k)
        if (debug) then
          print(format("item added to class: %d", k))
        end
      else
        rollOnIdol:addItem(k)
        if (debug) then
          print(format("item added to idol: %d", k))
        end
      end
    end

    if (debug) then
      print("AQIdolRoller loaded.")
      printRollBehavior()
    end
  end
end

-- START_LOOT_ROLL
function idolFrame:START_LOOT_ROLL(rollID)
  local _, name, _, _, _, canNeed, canGreed, _ = GetLootRollItemInfo(rollID)
  if (rollOnClass[name] or rollOnIdol[name] or rollOnScarab[name]) then
    if (debug) then
      print(format("canNeed: %s", tostring(canNeed)))
      print(format("canGreed: %s", tostring(canGreed)))
    end
    if (rollOnClass[name] and
      (AQIdolRollerSettings["rollClass"] == ROLL.NEED and canNeed
        or AQIdolRollerSettings["rollClass"] == ROLL.GREED and canGreed
        or AQIdolRollerSettings["rollClass"] == ROLL.PASS)) then
      if (debug) then
        print(format("item match. rolling for class idol: %s", AQIdolRollerSettings["rollClass"]))
      end
      RollOnLoot(rollID, AQIdolRollerSettings["rollClass"])
    elseif (rollOnIdol[name] and
      (AQIdolRollerSettings["rollIdol"] == ROLL.NEED and canNeed
        or AQIdolRollerSettings["rollIdol"] == ROLL.GREED and canGreed
        or AQIdolRollerSettings["rollIdol"] == ROLL.PASS)) then
      if (debug) then
        print(format("item match. rolling for idol: %s", AQIdolRollerSettings["rollIdol"]))
      end
      RollOnLoot(rollID, AQIdolRollerSettings["rollIdol"])
    elseif (AQIdolRollerSettings["rollScarab"] == ROLL.NEED and canNeed
        or AQIdolRollerSettings["rollScarab"] == ROLL.GREED and canGreed
        or AQIdolRollerSettings["rollScarab"] == ROLL.PASS) then
      if (debug) then
        print(format("item match. rolling for scarab: %s", AQIdolRollerSettings["rollScarab"]))
      end
      RollOnLoot(rollID, AQIdolRollerSettings["rollScarab"])
    else
      print("You found a bug, please report it with the following informations!")
      print("Buginfo:")
      print(string.format("name: %s", name))
      print(string.format("canNeed: %s", canNeed))
      print(string.format("canGreed: %s", canGreed))
      print(string.format("rollScarab: %s", AQIdolRollerSettings["rollScarab"]))
      print(string.format("rollIdol: %s", AQIdolRollerSettings["rollIdol"]))
      print(string.format("rollClass: %s", AQIdolRollerSettings["rollClass"]))
    end
  end
end

function idolFrame:RAID_INSTANCE_WELCOME(name)
  local aq20 = C_Map.GetAreaInfo(3429)
  local aq40 = C_Map.GetAreaInfo(3428)
  if (debug) then
    print(format("zone name: %s", name))
    print(format("localized AQ20: %s", aq20))
    print(format("localized AQ40: %s", aq40))
  end
  if (name == aq20 or name == aq40) then
    print("AQ Idol Roller active")
    printRollBehavior()
    print("For more information type /aqroll")
  end
end

-- print help on how to use the command line
local function printHelp()
  print("AQ Idol Roller usage:")
  print("/aqroll [c|class|i|idol|s|scarab] need  : roll need on all idols matching your class, all other idols or all scarabs in aq")
  print("/aqroll [c|class|i|idol|s|scarab] greed : roll greed on all idols matching your class, all other idols or all scarabs in aq")
  print("/aqroll [c|class|i|idol|s|scarab] pass  : pass on all idols matching your class, all other idols or all scarabs in aq")
  print("/aqroll current : prints the current roll behavior")
  print("/aqidolroller debug : toggle debug modus")
end

--------------------------------------------------------------
---- CLI
--------------------------------------------------------------

-- handler for class idol commands
local function handlerClass(msg)
  if (msg == "need") then
    classDropDown_OnClick(nil, ROLL.NEED)
    printRollBehavior()
  elseif (msg == "greed") then
    classDropDown_OnClick(nil, ROLL.GREED)
    printRollBehavior()
  elseif (msg == "pass") then
    classDropDown_OnClick(nil, ROLL.PASS)
    printRollBehavior()
  else
    printHelp()
  end
end

-- handler for idol commands
local function handlerIdol(msg)
  if (msg == "need") then
    idolDropDown_OnClick(nil, ROLL.NEED)
    printRollBehavior()
  elseif (msg == "greed") then
    idolDropDown_OnClick(nil, ROLL.GREED)
    printRollBehavior()
  elseif (msg == "pass") then
    idolDropDown_OnClick(nil, ROLL.PASS)
    printRollBehavior()
  else
    printHelp()
  end
end

-- handler for scarab commands
local function handlerScarab(msg)
  if (msg == "need") then
    scarabDropDown_OnClick(nil, ROLL.NEED)
    printRollBehavior()
  elseif (msg == "greed") then
    scarabDropDown_OnClick(nil, ROLL.GREED)
    printRollBehavior()
  elseif (msg == "pass") then
    scarabDropDown_OnClick(nil, ROLL.PASS)
    printRollBehavior()
  else
    printHelp()
  end
end

-- command line handler
local function handler(msg)
  local classPattern = "^class%s+(.*)"
  local cPattern = "^c%s+(.*)"
  local idolPattern = "^idols?%s+(.*)"
  local iPattern = "^i%s+(.*)"
  local scarabPattern = "^scarabs?%s+(.*)"
  local sPattern = "^s%s+(.*)"
  if (msg == "debug") then
    debug = not debug
    if (debug) then
      print("debug is now on")
    else
      print("debug is now off")
    end
  elseif (msg == "current") then
    printRollBehavior()
  elseif (string.match(msg, classPattern)) then
    local command = string.match(msg, classPattern)
    handlerClass(string.lower(command))
  elseif (string.match(msg, cPattern)) then
    local command = string.match(msg, cPattern)
    handlerClass(string.lower(command))
  elseif (string.match(msg, idolPattern)) then
    local command = string.match(msg, idolPattern)
    handlerIdol(string.lower(command))
  elseif (string.match(msg, iPattern)) then
    local command = string.match(msg, iPattern)
    handlerIdol(string.lower(command))
  elseif (string.match(msg, scarabPattern)) then
    local command = string.match(msg, scarabPattern)
    handlerScarab(string.lower(command))
  elseif (string.match(msg, sPattern)) then
    local command = string.match(msg, sPattern)
    handlerScarab(string.lower(command))
  elseif (msg == "help") then
    printHelp()
  else
    InterfaceOptionsFrame_OpenToCategory(panel)
    InterfaceOptionsFrame_OpenToCategory(panel) -- one call will only open the normal interface options. blizzard bug?
  end
end


--------------------------------------------------------------
---- handles
--------------------------------------------------------------

-- CLI
SLASH_AQIDOLROLLER1 = '/aqidolroller'
SLASH_AQIDOLROLLER2 = '/idolroll'
SLASH_AQIDOLROLLER3 = '/idolroller'
SLASH_AQIDOLROLLER4 = '/aqroll'
SlashCmdList["AQIDOLROLLER"] = handler

idolFrame:RegisterEvent("ADDON_LOADED")
idolFrame:RegisterEvent("START_LOOT_ROLL")
idolFrame:RegisterEvent("RAID_INSTANCE_WELCOME")
idolFrame:SetScript(
  "OnEvent",
  function(self, event, ...)
    if (idolFrame[event]) then
      idolFrame[event](self, ...)
    end
  end
)
