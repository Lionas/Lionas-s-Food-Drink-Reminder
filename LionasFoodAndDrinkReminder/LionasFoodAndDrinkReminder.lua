-- Lionas's Food & Drink Reminder
-- Author: Lionas

LioFADR = {
  name = "LionasFoodAndDrinkReminder",
  notifyRemain = {}, -- 残り時間通知済みリスト
  notifyClosed = {}, -- 残り時間が迫っている通知済みリスト
  notifyExpired = {}, -- 効果が切れた通知済みリスト
  default = {
    enable = true,              -- アドオン有効無効
    notifyThresholdMins = 3,  -- 通知する閾値(分)
  },
  notifyFirst = false,
}

local PLAYER_TAG = "player"

local ADD_ON_LOADED_REGISTER_NAME = LioFADR.name .. "_OnLoad"
local PLAYER_ACTIVATED_REGISTER_NAME = LioFADR.name .. "_Player_Activate"
local PLAYER_DEACTIVATED_REGISTER_NAME = LioFADR.name .. "_Player_DeActivate"
local UPDATE_INTERVAL_REGISTER_NAME = LioFADR.name .. "_Update"
local UPDATE_ONCE_REGISTER_NAME = LioFADR.name .. "_UpdateOnce"
local SAVED_PREFS_NAME = LioFADR.name .. "_SavedPrefs"

local UPDATE_INTERVAL_MSEC = 1000
local HOUR_PER_SECS = 3600
local MIN_PER_SECS = 60

local THRESHOLD_EXPIRE_SECS = 60

local EXPIRED_DUMMY_ID = -1

-- Vanilla UIメッセージの色
local BUFF_COLOR = "ff0000"
local TIME_COLOR = "ff00ff"

-- チャットメッセージ
local DMSG_HEADER = "[" .. LioFADR.name .. "] "


-- テーブルの長さを取得する
function getTableLength(T)
  
  local count = 0
  
  for _ in pairs(T) do
    count = count + 1 
  end
  
  return count

end

-- テーブルに指定の要素が含まれているかどうか  
local function isContain(element, table)
  
  if table == nil or getTableLength(table) == 0 then
    return false
  end
  
  for _, id in pairs(table) do

    if( id == element ) then
      return true
    end

  end
  
  return false
  
end


-- Clear table
local function clearTable(table)

  if(table ~= nil) then

    for i, v in pairs(table) do
	  table[i] = nil
	end
  
  end
  
end


-- Clear tables
function LioFADR:clearTables()

  clearTable(LioFADR.notifyRemain)
  clearTable(LioFADR.notifyClosed)
  clearTable(LioFADR.notifyExpired)
  
end


-- Initialize preferences
local function initializePrefs()

  LioFADR.savedVariables = ZO_SavedVars:New(SAVED_PREFS_NAME, 1, nil, LioFADR.default)
  
end


-- 通知
local function notify(message)
  
  -- チャット欄に通知
  d(DMSG_HEADER .. message)
  
  -- Vanilla UIに通知
  CENTER_SCREEN_ANNOUNCE:AddMessage(999, CSA_EVENT_COMBINED_TEXT, SOUNDS.AVA_GATE_OPENED, message, nil, nil, nil, nil, nil, 4420)
  
end


-- 通知済みテーブルから削除
local function removeFromTable(table, abilityId)

  local i = 1
  while (i <= #table) do
    if(table[i] == abilityId) then
      table[i] = nil
    else
      i = i + 1
    end
  end  
  
end


-- 色設定
local function getColoredString(color, str)
  
  return "|c" .. color .. str .. "|r"
  
end

-- 残り時間に応じて通知するメッセージを変える
local function buildNotifyMessage(remainSec, buffName)
  
  if (remainSec >= HOUR_PER_SECS) then
    -- 1時間以上効果がある時は、「残りx時間x分で<食べ物または飲み物>の効果が消えます」
  
    -- メッセージの作成
    local hours = math.floor(remainSec / HOUR_PER_SECS)
    local mins = math.floor((remainSec % HOUR_PER_SECS) / MIN_PER_SECS)
    
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_HOUR_MIN), getColoredString(TIME_COLOR, hours), getColoredString(TIME_COLOR, mins), getColoredString(BUFF_COLOR, buffName))
          
  end
  
  if (remainSec >= MIN_PER_SECS) and (remainSec < HOUR_PER_SECS) then
    -- 1分以上1時間未満の効果がある時は、「残りx分で<食べ物または飲み物>の効果が消えます」
    
    -- メッセージの作成
    local mins = math.floor(remainSec / MIN_PER_SECS)
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_MIN), getColoredString(TIME_COLOR, mins), getColoredString(BUFF_COLOR, buffName))

  end

  if (remainSec > 0) and (remainSec < MIN_PER_SECS) then
    -- 1分未満の効果がある時は、「<食べ物または飲み物>の効果がまもなく消えます」
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_CLOSED), getColoredString(BUFF_COLOR, buffName))
    
  else
    -- <食べ物または飲み物>の効果が切れました！
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRED), getColoredString(BUFF_COLOR, buffName))
    
  end
  
end


-- 残り時間を通知
local function notifyRemainTime(remainSec, abilityId, buffName)

  if (remainSec <= LioFADR.savedVariables.notifyThresholdMins * 60) and (not isContain(abilityId, LioFADR.notifyRemain)) then
    -- 残り時間が指定時間以下になったら通知する

    LioFADR.notifyFirst = true

    -- 通知
    notify(buildNotifyMessage(remainSec, buffName))
          
    -- 通知済みテーブルに追加と削除
    table.insert(LioFADR.notifyRemain, abilityId)


  elseif (remainSec < THRESHOLD_EXPIRE_SECS) and (not isContain(abilityId, LioFADR.notifyClosed)) then
    -- 指定時間を切ったら最終通知

    LioFADR.notifyFirst = true

    -- 通知
    notify(buildNotifyMessage(remainSec, buffName))
    
    -- 通知済みテーブルに追加と削除
    table.insert(LioFADR.notifyClosed, abilityId)

  elseif IsUnitInDungeon(PLAYER_TAG) and (not LioFADR.notifyFirst) then
    -- ダンジョンに入ったら最初に通知

    LioFADR.notifyFirst = true

    -- 通知
    notify(buildNotifyMessage(remainSec, buffName))

  end
    
end


-- 有効なバフかどうかのチェック
local function getEnableBuff(effectType, statusEffectType, timeStarted, timeEnding, abilityType, canClickOff)
  
	return (effectType == BUFF_EFFECT_TYPE_BUFF) and 
				 (statusEffectType == STATUS_EFFECT_TYPE_NONE) and 
				 ((timeEnding - timeStarted) > 0) and
				 (isContain(abilityType, { ABILITY_TYPE_NONE, ABILITY_TYPE_BONUS })) and
				 canClickOff
         
end


-- 残り時間が延長されたバフがある場合は通知していないことにする
local function extendRemainTime(remainSec, abilityId)
  
  local notifyThresholdSecs = LioFADR.savedVariables.notifyThresholdMins * 60
  if (remainSec >= notifyThresholdSecs) and isContain(abilityId, LioFADR.notifyRemain) then
    removeFromTable(LioFADR.notifyRemain, abilityId)
  end
  
  if (remainSec >= notifyThresholdSecs) and isContain(abilityId, LioFADR.notifyClosed) then
    removeFromTable(LioFADR.notifyClosed, abilityId)
  end
  
end


-- 効果が切れたアビリティの通知
local function notifyExpiredBuffs(currentBuffs)

  local expiredBuffs = {}
    
  -- 残り時間が迫っているバフの一覧
  for _, id in pairs(LioFADR.notifyClosed) do
    
    -- 現在のバフ一覧に入っていないものはもうバフが切れているので、期限切れ一覧に追加
    if (not isContain(id, currentBuffs)) then
      table.insert(expiredBuffs, id)
    end
    
  end
  
  -- 効果が切れたバフの一覧
  for _, id in pairs(expiredBuffs) do
    
    -- るバフ一覧から削除
    removeFromTable(LioFADR.notifyRemain, id)
    removeFromTable(LioFADR.notifyClosed, id)
    
    -- 通知
    local buffName = GetAbilityName(id)

d("expire:"..buffName)

    notify(buildNotifyMessage(0, buffName))
    
  end

end


-- Scan buffs
local function scanBuffs()

	-- 「食べ物」と「飲み物」の効果があるかどうかのチェック
	local buffsNum = GetNumBuffs(PLAYER_TAG)
	local currentBuffs = {}
	local notifyIntervalSec = 1
	
	-- 現在のバフ数ループ
	for i = 1, buffsNum do
	
		-- バフを1つずつ取り出す
		local buffName, 
		timeStarted, 
		timeEnding, 
		buffSlot, 
		stackCount, 
		iconFilename, 
		buffType, 
		effectType, 
		abilityType, 
		statusEffectType, 
		abilityId, 
		canClickOff = GetUnitBuffInfo(PLAYER_TAG, i)

		-- 有効なバフかどうかのチェック
		if(getEnableBuff(effectType, statusEffectType, timeStarted, timeEnding, abilityType, canClickOff)) then
    
      -- Expired通知の削除
      if(isContain(EXPIRED_DUMMY_ID, LioFADR.notifyExpired)) then
        removeFromTable(LioFADR.notifyExpired, abilityId)
      end
    
		  -- 現在のバフリストに追加
		  table.insert(currentBuffs, abilityId)
		
		  -- 残り時間の算出
		  local remainSec = timeEnding - (GetGameTimeMilliseconds() / 1000)
	
      -- 残り時間が延長されたバフがある場合は通知していないことにする
      extendRemainTime(remainSec, abilityId)
      
      -- 残り時間の通知
      notifyRemainTime(remainSec, abilityId, buffName)
		
    end	
  
  end

  -- 効果が切れたバフの通知
  notifyExpiredBuffs(currentBuffs)
  
  -- 効果がない時で、戦闘中でない場合、「食べ物 または 飲み物の効果を発動してください」のメッセージをVanilla UI上で表示する
  if (getTableLength(currentBuffs) == 0) and (not IsUnitInCombat(PLAYER_TAG)) and (not isContain(EXPIRED_DUMMY_ID, LioFADR.notifyExpired)) then
    
    -- 通知
    notify(GetString(LIO_FADR_SHOULD_EAT_DRINK))
          
    -- 通知済みテーブルに追加と削除
    table.insert(LioFADR.notifyExpired, EXPIRED_DUMMY_ID)

  end

end


-- Cyclic check
local function onUpdate()

  -- ダンジョンを出たらフラグをOFFにする
  if(not IsUnitInDungeon(PLAYER_TAG)) then
    LioFADR.notifyFirst = false
  end

  scanBuffs()

end


-- player activated
local function onPlayerActivated()

  -- unregist event handler
  EVENT_MANAGER:UnregisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_ACTIVATED)

  -- load Menu Settings
  LioFADRMenu.LoadLAM2Panel()
  
  -- regist handler  
  EVENT_MANAGER:RegisterForUpdate(UPDATE_INTERVAL_REGISTER_NAME, UPDATE_INTERVAL_MSEC, onUpdate)

end


-- OnLoad
local function onLoad(event, addon)
  
  if(addon ~= LioFADR.name) then
    return
  end
  
  -- 保存領域の初期化
  initializePrefs()

  -- regist & unregist handler
  EVENT_MANAGER:RegisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_ACTIVATED, onPlayerActivated)  
  EVENT_MANAGER:UnregisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED)
 
end


-- Regist event handler
EVENT_MANAGER:RegisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED, onLoad)
