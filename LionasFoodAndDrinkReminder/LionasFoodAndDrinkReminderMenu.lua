-- Lionas's Food & Drink Reminder
-- Author: Lionas
local PanelTitle = "Lionas's Food and Drink Reminder"
local Version = "0.1.0"
local Author = "Lionas"

local LAM2 = LibStub:GetLibrary("LibAddonMenu-2.0")

LioFADRMenu = {}

function LioFADRMenu.LoadLAM2Panel()
    local PanelData = 
    {
        type = "panel",
        name = PanelTitle,
        author = Author,
        version = Version,
        slashCommand = "/lfdr",
    }
    local OptionsData = 
    {
        [1] =
        {
            type = "description",
            text = GetString(LIO_FADR_DESCRIPTION),
        },
        [2] = 
        {
            type = "checkbox",
            name = GetString(LIO_FADR_ENABLE_TITLE),
            tooltip = GetString(LIO_FADR_ENABLE_TOOLTIP),
            default = LioFADR.savedVariables.enable,
            getFunc = 
              function() 
                return LioFADR.savedVariables.enable
              end,
            setFunc = 
              function(value) 
                LioFADR.savedVariables.enable = value
              end,
        },
        [3] = 
        {
            type = "slider",
            name = GetString(LIO_FADR_NOTIFY_THRESHOLD_TITLE),
            tooltip = GetString(LIO_FADR_NOTIFY_THRESHOLD_TOOLTIP),
            min = 1,
            max = 60,
            step = 1,
            default = 3,
            getFunc = 
              function() 
                return LioFADR.savedVariables.notifyThresholdMins
              end,
            setFunc = 
              function(value) 
                LioFADR.savedVariables.notifyThresholdMins = value
              end,
        },
    }   
    
    LAM2:RegisterAddonPanel(PanelTitle.."LAM2Options", PanelData)
    LAM2:RegisterOptionControls(PanelTitle.."LAM2Options", OptionsData)
    
end
--------------------------------------------------------------------------------------------------------------------------------------------------------------------