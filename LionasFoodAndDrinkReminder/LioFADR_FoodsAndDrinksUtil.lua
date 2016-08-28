﻿-- Lionas's Food & Drink Reminder
-- Author: Lionas
-- FoodsAndDrinksUtil

LioFADRFoods = {}

-- 食べ物と飲み物の効果定義
local FoodsAndDrinks = {
  
  [66568] = {
    ["jp"] = "最大マジカを増加させる",
    ["en"] = "Increase Max Magicka",
    ["de"] = "gestärkte Magicka",
  },
  [66576] = 
  {
    ["jp"] = "最大スタミナを増加させる",
    ["en"] = "Increase Max Stamina",
    ["de"] = "Erhöht Eure maximale Ausdauer",
  },
  [66586] = 
  {
    ["jp"] = "体力再生",
    ["en"] = "Health Recovery",
    ["de"] = "Lebensregeneration",   
  },
  [66594] = 
  {
    ["jp"] = "スタミナ再生",
    ["en"] = "Stamina Recovery",
    ["de"] = "Ausdauerregeneration",
  },
  [66125] = 
  {
    ["jp"] = "体力の最大値を上昇させる",
    ["en"] = "Increase Max Health",
    ["de"] = "Erhöht Euer maximales Leben",
  },
  [66128] = 
  {
    ["jp"] = "最大マジカを増加させる",
    ["en"] = "Increase Max Magicka",
    ["de"] = "Erhöht Eure maximale Magicka",
  },
  [66127] = 
  {
    ["jp"] = "",
    ["en"] = "",
    ["de"] = "Erhöht Eure maximale Magicka",
  },
  [66137] = 
  {
    ["jp"] = "マジカ再生",
    ["en"] = "Magicka Recovery",
    ["de"] = "Erhöht Eure Magickaregeneration",
  },
  [62554] = 
  {
    ["jp"] = "体力回復",
    ["en"] = "Restore Health",
    ["de"] = "Leben wiederherstellen",
  },
  [66132] = 
  {
    ["jp"] = "体力再生",
    ["en"] = "Health Recovery",
    ["de"] = "Erhöht Eure Lebensregeneration",
  },
  [62574] = 
  {
    ["jp"] = "スタミナ回復",
    ["en"] = "Restore Stamina",
    ["de"] = "Ausdauer wiederherstellen",
  },
  [62576] = 
  {
    ["jp"] = "マジカ回復",
    ["en"] = "Restore Magicka",
    ["de"] = "Magicka wiederherstellen",
  },
  [66130] = 
  {
    ["jp"] = "最大スタミナを増加させる",
    ["en"] = "Increase Max Stamina",
    ["de"] = "Erhöht Eure maximale Ausdauer",
  },
  [68412] = 
  {
    ["jp"] = "最大スタミナを増加させる",
    ["en"] = "Increase Max Stamina",
    ["de"] = "Erhöht Eure maximale Ausdauer",
  },
  [66590] = 
  {
    ["jp"] = "マジカ再生",
    ["en"] = "Magicka Recovery",
    ["de"] = "Magickaregeneration",
  },
  [66551] = 
  {
    ["jp"] = "体力の最大値を上昇させる",
    ["en"] = "Increase Max Health",
    ["de"] = "Erhöht Euer maximales Leben",
  },
  [68409] = 
  {
    ["jp"] = "スタミナ回復",
    ["en"] = "Restore Stamina",
    ["de"] = "Ausdauer wiederherstellen",
  },
  [68413] = 
  {
    ["jp"] = "最大マジカを増加させる",
    ["en"] = "Increase Max Magicka",
    ["de"] = "Erhöht Eure maximale Magicka",
  },
  [61259] = 
  {
    ["jp"] = "体力の最大値を上昇させる",
    ["en"] = "Increase Max Health",
    ["de"] = "Erhöht Euer maximales Leben",
  },
  [61261] = 
  {
    ["jp"] = "最大スタミナを増加させる",
    ["en"] = "Increase Max Stamina",
    ["de"] = "Erhöht Eure maximale Ausdauer",
  },
  [66254] = 
  {
    ["jp"] = "体力回復",
    ["en"] = "Restore Health",
    ["de"] = "Leben wiederherstellen",
  },
  [66141] = 
  {
    ["jp"] = "スタミナ再生",
    ["en"] = "Stamina Recovery",
    ["de"] = "Erhöht Eure Ausdauerregeneration",
  },
  [60770] = 
  {
    ["jp"] = "マジカ再生",
    ["en"] = "Magicka Regen",
    ["de"] = "Magickaregeneration",
  },
  [60771] = 
  {
    ["jp"] = "マジカ再生",
    ["en"] = "Magicka Regen",
    ["de"] = "Magickaregeneration",
  },
  [60773] = 
  {
    ["jp"] = "スタミナ回復",
    ["en"] = "Stamina Return",
    ["de"] = "Ausdauergewinnung",
  },
  [61345] = 
  {
    ["jp"] = "マジカとスタミナ再生",
    ["en"] = "Magicka & Stamina Recovery",
    ["de"] = "Magicka- und Ausdauerregeneration",
  },
  [61325] = 
  {
    ["jp"] = "マジカ再生",
    ["en"] = "Magicka Recovery",
    ["de"] = "Magickaregeneration",
  },
  [61294] = 
  {
    ["jp"] = "最大マジカとスタミナをアップする",
    ["en"] = "Increase Max Magicka & Stamina",
    ["de"] = "Erhöht Eure maximale Magicka und Ausdauer",
  },
  [61260] = 
  {
    ["jp"] = "最大マジカを増加させる",
    ["en"] = "Increase Max Magicka",
    ["de"] = "gestärkte Magicka",
  },
  [61257] = 
  {
    ["jp"] = "最大体力とマジカを増加させる",
    ["en"] = "Increase Max Health & Magicka",
    ["de"] = "Erhöht Euer maximales Leben und Magicka",
  },
  [61255] = 
  {
    ["jp"] = "最大体力とスタミナを増加させる",
    ["en"] = "Increase Max Health & Stamina",
    ["de"] = "Gestärktes Leben und Ausdauer",
  },
  [61322] = 
  {
    ["jp"] = "体力再生",
    ["en"] = "Health Recovery",
    ["de"] = "Lebensregeneration",
  },
  [61328] = 
  {
    ["jp"] = "スタミナ再生",
    ["en"] = "Stamina Recovery",
    ["de"] = "Ausdauerregeneration",
  },
  [61335] = 
  {
    ["jp"] = "体力とマジカ再生",
    ["en"] = "Health & Magicka Recovery",
    ["de"] = "Lebens- und Magickaregeneration",
  },
  [61340] = 
  {
    ["jp"] = "体力とスタミナ再生",
    ["en"] = "Health & Stamina Recovery",
    ["de"] = "Lebens- und Ausdauerregeneration",
  },
  [68407] = 
  {
    ["jp"] = "マジカ回復",
    ["en"] = "Restore Magicka",
    ["de"] = "Magickaregeneration",
  },
  [72816] = 
  {
    ["jp"] = "体力とマジカ再生",
    ["en"] = "Health & Magicka Recovery",
    ["de"] = "Lebens- und Magickaregeneration",
  },
  [72816] = 
  {
    ["jp"] = "体力とマジカ再生",
    ["en"] = "Health & Magicka Recovery",
    ["de"] = "Lebens- und Magickaregeneration",
  },
  [61218] = 
  {
    ["jp"] = "MAX_ALL",
    ["en"] = "",
    ["de"] = "",
  },
  [61350] = 
  {
    ["jp"] = "REGEN_ALL",
    ["en"] = "",
    ["de"] = "",
  },
  [72822] = 
  {
    ["jp"] = "MAX_HEALTH_REGEN_HEALTH",
    ["en"] = "",
    ["de"] = "",
  },
  [72819] = 
  {
    ["jp"] = "MAX_HEALTH_REGEN_STAMINA",
    ["en"] = "",
    ["de"] = "",
  },
  [72824] = 
  {
    ["jp"] = "MAX_HEALTH_REGEN_ALL",
    ["en"] = "",
    ["de"] = "",
  },

}


-- 食べ物と飲み物のリストを取得する
function LioFADRFoods.getFoodsAndDrinks()
  
  return FoodsAndDrinks
  
end


-- テーブルに指定の食べ物または飲み物が含まれているかどうか  
function LioFADRFoods.isContain(abilityId)

  local tbl = LioFADRFoods.getFoodsAndDrinks()
  
  if tbl == nil or LioFADRCommon.getTableLength(tbl) == 0 then
    return false
  end

  for k, v in pairs(tbl) do

    if( k == abilityId ) then
      return true
    end

  end

  return false

end


--local function getFoodTypeBonus()
    
--    local FODD_BUFF_NONE = 0
--    local FODD_BUFF_MAX_HEALTH = 1
--    local FODD_BUFF_MAX_MAGICKA = 2
--    local FODD_BUFF_MAX_STAMINA = 4
--    local FODD_BUFF_REGEN_HEALTH = 8
--    local FODD_BUFF_REGEN_MAGICKA = 16
--    local FODD_BUFF_REGEN_STAMINA = 32
--    local FODD_BUFF_MAX_HEALTH_MAGICKA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_MAX_MAGICKA
--    local FODD_BUFF_MAX_HEALTH_STAMINA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_MAX_STAMINA
--    local FODD_BUFF_MAX_MAGICKA_STAMINA = FODD_BUFF_MAX_MAGICKA + FODD_BUFF_MAX_STAMINA
--    local FODD_BUFF_REGEN_HEALTH_MAGICKA = FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_MAGICKA
--    local FODD_BUFF_REGEN_HEALTH_STAMINA = FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_STAMINA
--    local FODD_BUFF_REGEN_MAGICKA_STAMINA = FODD_BUFF_REGEN_MAGICKA + FODD_BUFF_REGEN_STAMINA
--    local FODD_BUFF_MAX_ALL = FODD_BUFF_MAX_HEALTH + FODD_BUFF_MAX_MAGICKA + FODD_BUFF_MAX_STAMINA
--    local FODD_BUFF_REGEN_ALL = FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_MAGICKA + FODD_BUFF_REGEN_STAMINA
--    local FODD_BUFF_MAX_HEALTH_REGEN_HEALTH = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_HEALTH
--    local FODD_BUFF_MAX_HEALTH_REGEN_MAGICKA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_MAGICKA
--    local FODD_BUFF_MAX_HEALTH_REGEN_STAMINA = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_STAMINA
--    local FODD_BUFF_MAX_HEALTH_REGEN_ALL = FODD_BUFF_MAX_HEALTH + FODD_BUFF_REGEN_HEALTH + FODD_BUFF_REGEN_MAGICKA + FODD_BUFF_REGEN_STAMINA
    
--    local isFoodBuff = {
--        [61259] = FODD_BUFF_MAX_HEALTH,
--        [61260] = FODD_BUFF_MAX_MAGICKA,
--        [61261] = FODD_BUFF_MAX_STAMINA,
--        [61322] = FODD_BUFF_REGEN_HEALTH,
--        [61325] = FODD_BUFF_REGEN_MAGICKA,
--        [61328] = FODD_BUFF_REGEN_STAMINA,
--        [61257] = FODD_BUFF_MAX_HEALTH_MAGICKA,
--        [61255] = FODD_BUFF_MAX_HEALTH_STAMINA,
--        [61294] = FODD_BUFF_MAX_MAGICKA_STAMINA,
--        [72816] = FODD_BUFF_REGEN_HEALTH_MAGICKA,
--        [61340] = FODD_BUFF_REGEN_HEALTH_STAMINA,
--        [61345] = FODD_BUFF_REGEN_MAGICKA_STAMINA,
--        [61218] = FODD_BUFF_MAX_ALL,
--        [61350] = FODD_BUFF_REGEN_ALL,
--        [72822] = FODD_BUFF_MAX_HEALTH_REGEN_HEALTH,
--        [72816] = FODD_BUFF_MAX_HEALTH_REGEN_MAGICKA,
--        [72819] = FODD_BUFF_MAX_HEALTH_REGEN_STAMINA,
--        [72824] = FODD_BUFF_MAX_HEALTH_REGEN_ALL,
--    }
    
--    return isFoodBuff
        
--end

