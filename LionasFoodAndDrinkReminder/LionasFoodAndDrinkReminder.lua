-- Lionas's Food & Drink Reminder
-- Author: Lionas

LioFADR = {
  name = "LionasFoodAndDrinkReminder",
  notifyRemain = {}, -- 残り時間通知済みリスト
  notifyClosed = {}, -- 残り時間が迫っている通知済みリスト
  notifyThresholdSecs = 180, -- 通知する閾値(秒)
  default = {
      -- default values
  },  
}

local PLAYER_TAG = "player"

local ADD_ON_LOADED_REGISTER_NAME = LioFADR.name .. "_OnLoad"
local PLAYER_ACTIVATED_REGISTER_NAME = LioFADR.name .. "_Player"
local UPDATE_INTERVAL_REGISTER_NAME = LioFADR.name .. "_Update"
local UPDATE_ONCE_REGISTER_NAME = LioFADR.name .. "_UpdateOnce"
local SAVED_PREFS_NAME = LioFADR.name .. "_SavedPrefs"

local UPDATE_INTERVAL_MSEC = 1000
local HOUR_PER_SECS = 3600
local MIN_PER_SECS = 60
local THRESHOLD_EXPIRE_SECS = 60

-- Initialize preferences
--local function initializePrefs()

--  LioFADR.savedVariables = ZO_SavedVars:New(SAVED_PREFS_NAME, 1, nil, LioFADR.default)
  
--end

-- 実装仕様
-- ダンジョンに入った時のみ、「食べ物」と「飲み物」の効果があるかどうかのチェック
-- 効果がない時は、自動的に指定のスロットを選択し、「Q（コントローラの時は上ボタン）を押して食べ物 または 飲み物の効果を発動してください」のメッセージをVanilla UI上で表示する
-- 選択できる食べ物または飲み物がクイックスロットにない時は「使用可能な食べ物または飲み物がありません！」とvanilla UI上に表示する
-- 効果がある時は、「残りx時間 x分（1分未満の時はもうすぐ）で食べ物または飲み物の効果が消えます」と vanilla UI上で表示する
-- 効果が切れた時は、「食べ物または飲み物の効果が切れました！」とvanilla UI上で表示する。その際、戦闘中でない場合は、（効果がない時）と同じ処理を実行。
-- 食べ物または飲み物の残り時間が少なくなる（1分未満、設定変更可能）と、Vanilla UI上で「xxx（食べ物の名前、できればアイコン付き）の効果がまもなく切れます」と表示する





-- 通知
local function notify(message, buffName)
  
  -- チャット欄に通知
  d(message)
  
  -- Vanilla UIに通知
  CENTER_SCREEN_ANNOUNCE:AddMessage(999, CSA_EVENT_COMBINED_TEXT, SOUNDS.CHAMPION_POINTS_COMMITTED, message, buffName, nil, nil, nil, nil, CSA_OPTION_SUPPRESS_ICON_FRAME),
  
end


-- 通知済みテーブルから削除
local function removeFromTable(table, abilityId)
  
  while (i <= #table) do
    
    if(table[i] == abilityId) then
      table.remove(table, i)
    else
      i = i + 1
    end
    
  end  
  
end


-- 残り時間に応じて通知するメッセージを変える
local function buildNotifyMessage(remainSec, buffName)
  
  if (remainSec >= HOUR_PER_SECS)　then
    -- 1時間以上効果がある時は、「残りx時間x分で<食べ物または飲み物>の効果が消えます」
  
    -- メッセージの作成
    local hours = remainSec / HOUR_PER_SECS
    local mins = (remainSec % HOUR_PER_SECS) / MIN_PER_SECS
    
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_HOUR_MIN), hours, mins, buffName)
          
  end
  
  if (remainSec >= MIN_PER_SECS) and (remainSec < HOUR_PER_SECS) then
    -- 1分以上1時間未満の効果がある時は、「残りx分で<食べ物または飲み物>の効果が消えます」
    
    -- メッセージの作成
    local mins = remainSec / MIN_PER_SECS
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_MIN), mins, buffName)

  end

  if (remainSec > 0) and (remasinSec < MIN_PER_SECS) then
    -- 1分未満の効果がある時は、「<食べ物または飲み物>の効果がまもなく消えます」
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRE_CLOSED), buffName)
    
  else
    -- <食べ物または飲み物>の効果が切れました！
    return zo_strformat(GetString(LIO_FADR_NEAR_EXPIRED), buffName)
    
  end
  
end


-- 残り時間を通知
local function notifyRemainTime(remainSec, abilityId, buffName)

  if (remainSec <= LioFADR.notifyThresholdSecs)　and (not in_array(abilityId, LioFADR.notifyRemain)) then
    -- 残り時間が指定時間以下になったら通知する
    
    -- 通知
    notify(buildNotifyMessage(remainSec, buffName), buffName)
          
    -- 通知済みテーブルに追加と削除
    table.insert(LioFADR.notifyRemain, abilityId)
    removeFromTable(LioFADR.notifyClosed, abilityId)
          
  elseif (remainSec < THRESHOLD_EXPIRE_SECS) and (not in_array(abilityId, LioFADR.notifyClosed)) then
    -- 指定時間を切ったら最終通知
    
    -- 通知
    nofity(buildNotifyMessage(remainSec, buffName), buffName)
    
    -- 通知済みテーブルに追加と削除
    table.insert(LioFADR.notifyClosed, abilityId)
    removeFromTable(LioFADR.notifyRemain, abilityId)

  end
    
end


-- 有効なバフかどうかのチェック
local function getEnableBuff(effectType, statusEffectType, timeStarted, timeEnding, abilityType, canClickOff)
  
	return (effectType == BUFF_EFFECT_TYPE_BUFF) and 
				 (statusEffectType == STATUS_EFFECT_TYPE_NONE) and 
				 ((timeEnding - timeStarted) > 0) and
				 (in_array( abilityType, { ABILITY_TYPE_NONE, ABILITY_TYPE_BONUS } )) and
				 canClickOff
         
end


-- 残り時間が延長されたバフがある場合は通知していないことにする
local function extendRemainTime(remainSec, abilityId)
  
  if (remainSec >= LioFADR.notifyThresholdSecs and in_array(abilityId, LioFADR.notifyRemain)) then
    removeFromTable(LioFADR.notifyRemain, abilityId)
  end
  
    if (remainSec >= LioFADR.notifyThresholdSecs and in_array(abilityId, LioFADR.notifyClosed)) then
    removeFromTable(LioFADR.notifyClosed, abilityId)
  end
  
end


-- 効果が切れたアビリティの通知
local function notifyExpiredBuffs(currentBuffs)

  local expiredBuffs = {}
    
  -- 残り時間が迫っているバフの一覧
  for _, id in pairs(LioFADR.notifyClosed) do
    
    -- 現在のバフ一覧に入っていないものはもうバフが切れているので、期限切れ一覧に追加
    if (not in_array(id, currentBuffs)) then
      table.insert(expiredBuffs id)
    end
    
  end
  
  -- 効果が切れたバフの一覧
  for _, id in pairs(expiredBuffs) do
    
    -- 残り時間が迫っているバフ一覧から削除
    removeFromTable(LioFADR.notifyClosed, id)
    
    -- 通知
    String buffName = GetAbilityName(id)
    notify(buildNotifyMessage(0, buffName), buffName)
    
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
  
  -- 効果がない時で、戦闘中でない場合、自動的に指定のスロットを選択し、「Q（コントローラの時は上ボタン）を押して食べ物 または 飲み物の効果を発動してください」のメッセージをVanilla UI上で表示する
  --GetString(LIO_FADR_SHOULD_EAT_DRINK)



end


-- Cyclic check
local function onUpdate()

	if(IsUnitInDungeon(PLAYER_TAG)) then
		-- ダンジョンの中
		scanBuffs()
		
	else
		-- ダンジョンの外
		-- 何もしない	
	end

end


-- player activated
local function onPlayerActivated()

  -- unregist event handler
  --EVENT_MANAGER:UnregisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_ACTIVATED)

  -- load Menu Settings
  LoadLAM2Panel()
  
  -- regist handler  
  EVENT_MANAGER:RegisterForUpdate(UPDATE_INTERVAL_REGISTER_NAME, UPDATE_INTERVAL_MSEC, onUpdate)
  EVENT_MANAGER:RegisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_DEACTIVATED, onPlayerDeActivated)

end


-- player deactivated
local function onPlayerDeactivated()

  EVENT_MANAGER:UnregisterForUpdate(UPDATE_INTERVAL_REGISTER_NAME)
  EVENT_MANAGER:UnregisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_DEACTIVATED)
  
end


-- OnLoad
local function onLoad(event, addon)
  
  if(addon ~= LioFADR.name) then
    return
  end
  
  -- 保存領域の初期化
--  initializePrefs()

  -- regist & unregist handler
  EVENT_MANAGER:RegisterForEvent(PLAYER_ACTIVATED_REGISTER_NAME, EVENT_PLAYER_ACTIVATED, onPlayerActivated)  
  EVENT_MANAGER:UnregisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED)
 
end


-- Regist event handler
EVENT_MANAGER:RegisterForEvent(ADD_ON_LOADED_REGISTER_NAME, EVENT_ADD_ON_LOADED, onLoad)
