-- Lionas's Food & Drink Reminder
-- Author: Lionas

LioFADR = {
  name = "LionasFoodAndDrinkReminder",
  notified = {},
  default = {
      -- default values
  },  
}

local PLAYER_TAG = "player"

local ADD_ON_LOADED_REGISTER_NAME = LioFADR.name .. "_OnLoad"
local PLAYER_ACTIVATED_REGISTER_NAME = LioFADR.name .. "_Player"
local UPDATE_INTERVAL_REGISTER_NAME = LioFADR.name .. "_Update"
local SAVED_PREFS_NAME = LioFADR.name .. "_SavedPrefs"

local UPDATE_INTERVAL_MSEC = 500

-- Initialize preferences
local function initializePrefs()

  LioFADR.savedVariables = ZO_SavedVars:New(SAVED_PREFS_NAME, 1, nil, LioFADR.default)
  
end

-- 実装仕様
-- ダンジョンに入った時のみ、「食べ物」と「飲み物」の効果があるかどうかのチェック
-- 効果がない時は、自動的に指定のスロットを選択し、「Q（コントローラの時は上ボタン）を押して食べ物 または 飲み物の効果を発動してください」のメッセージをVanilla UI上で表示する
-- 選択できる食べ物または飲み物がクイックスロットにない時は「使用可能な食べ物または飲み物がありません！」とvanilla UI上に表示する
-- 効果がある時は、「残りx時間 x分（1分未満の時はもうすぐ）で食べ物または飲み物の効果が消えます」と vanilla UI上で表示する
-- 効果が切れた時は、「食べ物または飲み物の効果が切れました！」とvanilla UI上で表示する。その際、戦闘中でない場合は、（効果がない時）と同じ処理を実行。
-- 食べ物または飲み物の残り時間が少なくなる（3分未満、設定変更可能）と、Vanilla UI上で「xxx（食べ物の名前、できればアイコン付き）の効果がまもなく切れます」と表示する

-- Main Logic
local function LioFADR.onUpdate()

	if(IsUnitInDungeon(PLAYER_TAG)) then
	  -- ダンジョンの中
		
	else
	  -- ダンジョンの外
	
	end

end

-- player deactivated
local function LioFADR.onPlayerDeactivated()

  EVENT_MANAGER:UnregisterForUpdate(UPDATE_INTERVAL_REGISTER_NAME)
  EVENT_MANAGER:UnregisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_DEACTIVATED)
  
end


-- player activated
local function LioFADR.onPlayerActivated()

  -- unregist event handler
  --EVENT_MANAGER:UnregisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_ACTIVATED)

  -- load Menu Settings
  LoadLAM2Panel()
  
  -- regist handler  
  EVENT_MANAGER:RegisterForUpdate(UPDATE_INTERVAL_REGISTER_NAME, UPDATE_INTERVAL_MSEC, LioFADR.onUpdate)
  EVENT_MANAGER:RegisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_DEACTIVATED, LioFADR.onPlayerDeActivated)

end

-- OnLoad
local function LioFADR.onLoad(event, addon)
  
  if(addon ~= LioFADR.name) then
    return
  end
  
  initializePrefs()

  -- regist handler
  EVENT_MANAGER:RegisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_ACTIVATED, LioFADR.onPlayerActivated)  
  
  -- unregist handler
  EVENT_MANAGER:UnregisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED)
 
end

-- Update variables
local function onUpdateVars()

--d("onUpdateVars")
  
  local anchor, point, rTo, rPoint, offsetx, offsety = ZO_CompassFrame:GetAnchor() 
    
  if((offsetx ~= ADCUI.savedVariables.x and offsetx ~= ADCUI.default.anchorOffsetX)
      or 
     (offsety ~= ADCUI.savedVariables.y and offsety ~= ADCUI.default.anchorOffsetY)) then
    
    ADCUI.savedVariables.x = offsetx
    ADCUI.savedVariables.y = offsety
    ADCUI.savedVariables.point = point
  
    if(rPoint ~= nil) then
      ADCUI.savedVariables.point = rPoint
    end
  
--d("x="..ADCUI.savedVariables.x..", y="..ADCUI.savedVariables.y..", point="..ADCUI.savedVariables.point)
  
  end
  
end  

-- Regist event handler
EVENT_MANAGER:RegisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED, LioFADR.onLoad)
