-- Lionas's Food & Drink Reminder
-- Author: Lionas

LioFADR = {
  name = "LionasFoodAndDrinkReminder",
  displayName = "Lionas's Food & Drink Reminder",
  notifyFirst = {}, -- 最初の通知済みリスト
  notifyRemain = {}, -- 残り時間通知済みリスト
  notifyClosed = {}, -- 残り時間が迫っている通知済みリスト
  notifyExpired = {}, -- 効果が切れた通知済みリスト
  default = {
    enable = true,              -- アドオン有効無効
    notifyThresholdMins = 3,  -- 通知する閾値(分)
    notifyInDungeon = true,  -- ダンジョンにいる時に通知する
    isInDungeon = false,  -- 現在ダンジョンにいるかどうか
    enableToChat = true,  -- チャット欄に通知する
    notifyByZoneChanging = true, -- ゾーン変更時に通知する
    isZoneChanged = false, -- ゾーン変更したかどうか
    cooldownSec = 60, -- クールダウン時間(秒)
    lastNotifyTime = 0, -- 最後に通知した時間
  },
}

local PLAYER_TAG = "player"

local ADD_ON_LOADED_REGISTER_NAME = LioFADR.name .. "_OnLoad"
local PLAYER_ACTIVATED_REGISTER_NAME = LioFADR.name .. "_Player_Activate"
local PLAYER_DEACTIVATED_REGISTER_NAME = LioFADR.name .. "_Player_DeActivate"
local UPDATE_INTERVAL_REGISTER_NAME = LioFADR.name .. "_Update"
local ZONE_CHANGED_REGISTER_NAME = LioFADR.name .. "_ZoneChanged"
local SAVED_PREFS_NAME = LioFADR.name .. "_SavedPrefs"
local SAVED_PREFS_VERSION = 2

local UPDATE_INTERVAL_MSEC = 1000
local HOUR_PER_SECS = 3600
local MIN_PER_SECS = 60

local THRESHOLD_EXPIRE_SECS = 60

local EXPIRED_DUMMY_ID = -1

-- Vanilla UIメッセージの色
local BUFF_COLOR = "ff0000"
local TIME_COLOR = "ff00ff"
local ATTENTION_COLOR = "ff3DA5"

-- チャットメッセージ
local DMSG_HEADER = "[" .. LioFADR.displayName .. "] "

-- テーブルの長さを取得する
function getTableLength(T)

  local count = 0

  for _ in pairs(T) do
    count = count + 1 
  end

  return count

end


-- テーブルに指定の要素が含まれているかどうか  
local function isContain(element, tbl)

  if table == nil or getTableLength(tbl) == 0 then
    return false
  end

  for _, id in pairs(tbl) do

    if( id == element ) then
      return true
    end

  end

  return false

end


-- テーブルに指定のkeyが含まれているかどうか  
local function isContainKey(key, tbl)

  if table == nil or getTableLength(tbl) == 0 then
    return false
  end

  for k, v in pairs(tbl) do

    if( k == key ) then
      return true
    end

  end

  return false

end


-- Clear table
function clearTable(tbl)

  if(tbl ~= nil and (getTableLength(tbl) ~= 0)) then

    for i, v in pairs(tbl) do
      tbl[i] = nil
    end

  end

end

function LioFADR:clearTable(tbl)

  clearTable(tbl)

end


-- Insert table
function insertTable(tbl, element)
  
  if(not isContain(element, tbl)) then
    table.insert(tbl, element)
  end
  
end


-- Clear tables
function LioFADR:clearTables()

  clearTable(LioFADR.notifyFirst)
  clearTable(LioFADR.notifyRemain)
  clearTable(LioFADR.notifyClosed)
  clearTable(LioFADR.notifyExpired)

end


-- Initialize preferences
local function initializePrefs()

  LioFADR.savedVariables = ZO_SavedVars:New(SAVED_PREFS_NAME, SAVED_PREFS_VERSION, nil,
    {
      enable = LioFADR.default.enable,
      notifyThresholdMins = LioFADR.default.notifyThresholdMins,
      notifyInDungeon = LioFADR.default.notifyInDungeon,
      isInDungeon = LioFADR.default.isInDungeon,
      enableToChat = LioFADR.default.enableToChat,
      notifyByZoneChanging = LioFADR.default.notifyByZoneChanging,
      isZoneChanged = LioFADR.default.isZoneChanged,
      cooldownSec = LioFADR.default.cooldownSec,
      lastNotifyTime = LioFADR.default.lastNotifyTime,
    }
  )

end


-- チャット欄への出力
local function outputChat(message)

  if(LioFADR.savedVariables.enableToChat) then
    d(DMSG_HEADER .. message)
  end

end

-- 通知
local function notify(message, buffName, icon)

  -- チャット欄に通知
  outputChat(message)

  -- Vanilla UIに通知
  CENTER_SCREEN_ANNOUNCE:AddMessage(999, CSA_EVENT_COMBINED_TEXT, SOUNDS.AVA_GATE_OPENED, message, buffName, icon, nil, nil, nil, nil, 4420)

  -- 通知時間を保存
  LioFADR.savedVariables.lastNotifyTime = GetTimeStamp()
  
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
    -- 1時間以上効果がある時は、「残りx時間x分で食事の効果が消えます」

    -- メッセージの作成
    local hours = math.floor(remainSec / HOUR_PER_SECS)
    local mins = math.floor((remainSec % HOUR_PER_SECS) / MIN_PER_SECS)

    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_HOUR_MIN), getColoredString(TIME_COLOR, hours), getColoredString(TIME_COLOR, mins))

  end

  if (remainSec >= MIN_PER_SECS) and (remainSec < HOUR_PER_SECS) then
    -- 1分以上1時間未満の効果がある時は、「残りx分で食事の効果が消えます」

    -- メッセージの作成
    local mins = math.floor(remainSec / MIN_PER_SECS)
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_MIN), getColoredString(TIME_COLOR, mins))

  end

  if (remainSec > 0) and (remainSec < MIN_PER_SECS) then
    -- 1分未満の効果がある時は、「食事の効果がまもなく消えます」
    return getColoredString(ATTENTION_COLOR, GetString(LIO_FADR_NEAR_EXPIRE_CLOSED))

  else
    -- 食事の効果が切れました！
    return getColoredString(ATTENTION_COLOR, GetString(LIO_FADR_NEAR_EXPIRED))

  end

end


-- 残り時間を通知
local function notifyRemainTime(remainSec, abilityId)

  local buffName = GetAbilityName(abilityId)
  local buffIcon = GetAbilityIcon(abilityId)

  if (remainSec <= LioFADR.savedVariables.notifyThresholdMins * 60) and (not isContain(abilityId, LioFADR.notifyRemain)) then
    -- 残り時間が指定時間以下になったら通知する

    insertTable(LioFADR.notifyFirst, abilityId)

    -- 通知
    notify(buildNotifyMessage(remainSec, buffName), buffName, buffIcon)

    -- 通知済みテーブルに追加と削除
    insertTable(LioFADR.notifyRemain, abilityId)

  elseif (remainSec < THRESHOLD_EXPIRE_SECS) and (not isContain(abilityId, LioFADR.notifyClosed)) then
    -- 指定時間を切ったら最終通知

    insertTable(LioFADR.notifyFirst, abilityId)

    -- 通知
    notify(buildNotifyMessage(remainSec, buffName), buffName, buffIcon)

    -- 通知済みテーブルに追加と削除
    insertTable(LioFADR.notifyClosed, abilityId)

  elseif (getTableLength(LioFADR.notifyFirst) == 0) then
    -- 最初に必ず通知

    insertTable(LioFADR.notifyFirst, abilityId)

    -- 通知
    notify(buildNotifyMessage(remainSec, buffName), buffName, buffIcon)

  end

end


-- 有効なバフかどうかを判定
local function getFoodTypeBonus()
    
    local FODD_BUFF_NONE = 0
    local FODD_BUFF_MAX_HEALTH = 1
    local FODD_BUFF_MAX_MAGICKA = 2
    local FODD_BUFF_MAX_STAMINA = 4
    local FODD_BUFF_REGEN_HEALTH = 8
    local FODD_BUFF_REGEN_MAGICKA = 16
    local FODD_BUFF_REGEN_STAMINA = 32
    local FODD_BUFF_MAX_HEALTH_MAGICKA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_MAX_MAGICKA
    local FODD_BUFF_MAX_HEALTH_STAMINA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_MAX_STAMINA
    local FODD_BUFF_MAX_MAGICKA_STAMINA = FODD_BUFF_MAX_MAGICKA + FODD_BUFF_MAX_STAMINA
    local FODD_BUFF_REGEN_HEALTH_MAGICKA = FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_MAGICKA
    local FODD_BUFF_REGEN_HEALTH_STAMINA = FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_STAMINA
    local FODD_BUFF_REGEN_MAGICKA_STAMINA = FODD_BUFF_REGEN_MAGICKA + FODD_BUFF_REGEN_STAMINA
    local FODD_BUFF_MAX_ALL = FODD_BUFF_MAX_HEALTH + FODD_BUFF_MAX_MAGICKA + FODD_BUFF_MAX_STAMINA
    local FODD_BUFF_REGEN_ALL = FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_MAGICKA + FODD_BUFF_REGEN_STAMINA
    local FODD_BUFF_MAX_HEALTH_REGEN_HEALTH = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_HEALTH
    local FODD_BUFF_MAX_HEALTH_REGEN_MAGICKA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_MAGICKA
    local FODD_BUFF_MAX_HEALTH_REGEN_STAMINA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_STAMINA
    local FODD_BUFF_MAX_HEALTH_REGEN_ALL = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_MAGICKA + FODD_BUFF_REGEN_STAMINA
    
    local isFoodBuff = {
        [61259] = FODD_BUFF_MAX_HEALTH,
        [61260] = FODD_BUFF_MAX_MAGICKA,
        [61261] = FODD_BUFF_MAX_STAMINA,
        [61322] = FODD_BUFF_REGEN_HEALTH,
        [61325] = FODD_BUFF_REGEN_MAGICKA,
        [61328] = FODD_BUFF_REGEN_STAMINA,
        [61257] = FODD_BUFF_MAX_HEALTH_MAGICKA,
        [61255] = FODD_BUFF_MAX_HEALTH_STAMINA,
        [61294] = FODD_BUFF_MAX_MAGICKA_STAMINA,
        [72816] = FODD_BUFF_REGEN_HEALTH_MAGICKA,
        [61340] = FODD_BUFF_REGEN_HEALTH_STAMINA,
        [61345] = FODD_BUFF_REGEN_MAGICKA_STAMINA,
        [61218] = FODD_BUFF_MAX_ALL,
        [61350] = FODD_BUFF_REGEN_ALL,
        [72822] = FODD_BUFF_MAX_HEALTH_REGEN_HEALTH,
        [72816] = FODD_BUFF_MAX_HEALTH_REGEN_MAGICKA,
        [72819] = FODD_BUFF_MAX_HEALTH_REGEN_STAMINA,
        [72824] = FODD_BUFF_MAX_HEALTH_REGEN_ALL,
    }
    
    return isFoodBuff
        
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

  for _, id in pairs(LioFADR.notifyFirst) do

    -- 現在のバフ一覧に入っていないものはもうバフが切れているので、期限切れ一覧に追加
    if (not isContain(id, currentBuffs)) and (not isContain(id, expiredBuffs)) then
      insertTable(expiredBuffs, id)
    end

  end

  for _, id in pairs(LioFADR.notifyRemain) do

    -- 現在のバフ一覧に入っていないものはもうバフが切れているので、期限切れ一覧に追加
    if (not isContain(id, currentBuffs)) and (not isContain(id, expiredBuffs)) then
      insertTable(expiredBuffs, id)
    end

  end

  for _, id in pairs(LioFADR.notifyClosed) do

    -- 現在のバフ一覧に入っていないものはもうバフが切れているので、期限切れ一覧に追加
    if (not isContain(id, currentBuffs)) and (not isContain(id, expiredBuffs)) then
      insertTable(expiredBuffs, id)
    end

  end

  -- 効果が切れたバフの一覧
  for _, id in pairs(expiredBuffs) do

    -- バフ一覧から削除
    removeFromTable(LioFADR.notifyFirst, id)
    removeFromTable(LioFADR.notifyRemain, id)
    removeFromTable(LioFADR.notifyClosed, id)

    -- 通知
    local buffName = GetAbilityName(id)
    local buffIcon = GetAbilityIcon(id)
    notify(buildNotifyMessage(0, buffName), buffName, buffIcon)

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
    if(isContainKey(abilityId, getFoodTypeBonus())) then

d(buffName)

      -- Expired通知の削除
      if(isContain(EXPIRED_DUMMY_ID, LioFADR.notifyExpired)) then
        removeFromTable(LioFADR.notifyExpired, EXPIRED_DUMMY_ID)
      end

      -- 現在のバフリストに追加
      insertTable(currentBuffs, abilityId)

      -- 残り時間の算出
      local remainSec = math.floor(timeEnding - (GetGameTimeMilliseconds() / 1000))

      -- 残り時間が延長されたバフがある場合は通知していないことにする
      extendRemainTime(remainSec, abilityId)

      -- 残り時間の通知
      notifyRemainTime(remainSec, abilityId)

    end	

  end

  -- 効果が切れたバフの通知
  notifyExpiredBuffs(currentBuffs)

  -- 効果がない時で、戦闘中でない場合、「食事の効果を発動してください」のメッセージをVanilla UI上で表示する
  if (getTableLength(currentBuffs) == 0) and (not IsUnitInCombat(PLAYER_TAG)) and (not isContain(EXPIRED_DUMMY_ID, LioFADR.notifyExpired)) then

    -- 通知
    notify(getColoredString(ATTENTION_COLOR, GetString(LIO_FADR_SHOULD_EAT_DRINK)), nil, nil)

    -- 通知済みテーブルに追加と削除
    insertTable(LioFADR.notifyExpired, EXPIRED_DUMMY_ID)

  end

end

-- Cooldown check
local function isCooldown()
  
  return (GetTimeStamp() < LioFADR.savedVariables.lastNotifyTime + LioFADR.savedVariables.cooldownSec)
  
end


-- Cyclic check
local function onUpdate()

--d("onUpdate()"..GetTimeStamp())

  -- ダンジョンを出入りしたら初回表示を有効にする
  if(IsUnitInDungeon(PLAYER_TAG) and (not LioFADR.savedVariables.isInDungeon)) then
    
    clearTable(LioFADR.notifyFirst)
    LioFADR.savedVariables.isInDungeon = true

  elseif((not IsUnitInDungeon(PLAYER_TAG)) and (LioFADR.savedVariables.isInDungeon)) then
    
    clearTable(LioFADR.notifyFirst)
    LioFADR.savedVariables.isInDungeon = false
  end

  -- ゾーンを移動したら初回表示を有効にする
  if(LioFADR.savedVariables.notifyByZoneChanging and LioFADR.savedVariables.isZoneChanged) then

    if(not isCooldown()) then
      clearTable(LioFADR.notifyFirst)
    end
    
    LioFADR.savedVariables.isZoneChanged = false
  
  end

  if((LioFADR.savedVariables.notifyInDungeon and LioFADR.savedVariables.isInDungeon) or -- ダンジョンで通知するが有効でダンジョン内にいる時
     (not LioFADR.savedVariables.isInDungeon) -- ダンジョン内にいない時
    ) then 

    scanBuffs()

  end

end


-- 通知を有効にする
function LioFADR:setEnable()

    outputChat(GetString(LIO_FADR_ENABLE))
    EVENT_MANAGER:RegisterForUpdate(UPDATE_INTERVAL_REGISTER_NAME, UPDATE_INTERVAL_MSEC, onUpdate)

end


-- 通知を無効にする
function LioFADR:setDisableWithoutUnregister()

    outputChat(GetString(LIO_FADR_DISABLE))

end

function LioFADR:setDisable()

    LioFADR.setDisableWithoutUnregister()
    EVENT_MANAGER:UnregisterForUpdate(UPDATE_INTERVAL_REGISTER_NAME)

end


-- 有効無効スイッチ
function toggleEnable()

  LioFADR.savedVariables.enable = not LioFADR.savedVariables.enable

  -- addon start or not
  if(LioFADR.savedVariables.enable) then
    LioFADR.setEnable()
  else
    LioFADR.setDisable()
  end

end


-- zone changed
function LioFADR:onZoneChanged()
  
--d("onZoneChanged()")  
  
  LioFADR.savedVariables.isZoneChanged = true
  
end


-- player activated
local function onPlayerActivated()

  -- unregist event handler
  EVENT_MANAGER:UnregisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_ACTIVATED)

  -- load Menu Settings
  LioFADRMenu.LoadLAM2Panel()

  -- addon start or not
  if(LioFADR.savedVariables.enable) then
    LioFADR.setEnable()
  else
    LioFADR.setDisableWithoutUnregister()
  end

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
  EVENT_MANAGER:RegisterForEvent(ZONE_CHANGED_REGISTER_NAME, EVENT_ZONE_CHANGED, LioFADR.onZoneChanged)  
  EVENT_MANAGER:UnregisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED)

end


-- Regist event handler
EVENT_MANAGER:RegisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED, onLoad)
