-- Lionas's Food & Drink Reminder
-- Author: Lionas
-- German specific file
 
-- enable/disable
ZO_CreateStringId("LIO_FADR_ENABLE", " ist aktiv.")
ZO_CreateStringId("LIO_FADR_DISABLE", " ist nicht aktiv.")
 
-- notification
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRE_HOUR_MIN", "Die Mahlzeit läuft in <<1>>h <<2>>min aus.")
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRE_MIN", "Die Mahlzeit läuft in <<1>>min aus.")
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRE_CLOSED", "Die Mahlzeit läuft bald aus.")
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRED", "Du hast den Wirkung der Mahlzeit verloren!")
ZO_CreateStringId("LIO_FADR_SHOULD_EAT_DRINK", "Es ist keine Mahlzeit aktiv!")
 
-- menus
ZO_CreateStringId("LIO_FADR_DESCRIPTION", "Dieses AddOn zeigt dir den Status deiner Mahlzeit an..")
ZO_CreateStringId("LIO_FADR_ENABLE_TITLE", "Aktiviere Meldungen")
ZO_CreateStringId("LIO_FADR_ENABLE_TOOLTIP", "Wenn du über den Zustand deiner Mahlzeit informiert werde möchtest, aktiviere diese Einstellung.")
ZO_CreateStringId("LIO_FADR_NOTIFY_THRESHOLD_TITLE", "Schwelle für Erinnerung in [min]")
ZO_CreateStringId("LIO_FADR_NOTIFY_THRESHOLD_TOOLTIP", "Du wirst über den Zustand der Mahlzeit infomiert, sobald dieser Wert unterschritten wird.")
ZO_CreateStringId("LIO_FADR_NOTIFY_IN_DUNGEON_TITLE", "Meldungen innerhalb Verlies")
ZO_CreateStringId("LIO_FADR_NOTIFY_IN_DUNGEON_TOOLTIP", "Wenn du über den Zustand der Mahlzeit in einem Verlies informiert werden möchtest, aktiviere diese Einstellung.")
ZO_CreateStringId("LIO_FADR_ENABLE_NOTIFY_TO_CHAT_TITLE", "Meldungen in Chat")
ZO_CreateStringId("LIO_FADR_ENABLE_NOTIFY_TO_CHAT_TOOLTIP", "Mitteilungen und Zustände im Chat ausgeben.")
ZO_CreateStringId("LIO_FADR_NOTIFY_BY_ZONE_CHANGING_TITLE", "Erinnerung nach Zonenwechsel")
ZO_CreateStringId("LIO_FADR_NOTIFY_BY_ZONE_CHANGING_TOOLTIP", "Nach jedem Zonenwechsel bekommst du eine Erinnerung über den Zustand deiner Mahlzeit.")
ZO_CreateStringId("LIO_FADR_NOTIFY_COOLDOWN_TITLE", "Zeit zwischen Meldungen [sek]")
ZO_CreateStringId("LIO_FADR_NOTIFY_COOLDOWN_TOOLTIP", "Falls Mitteilungen in dieser Zeit vorkommen sollten, werden diese nicht wiedergegeben.")
ZO_CreateStringId("LIO_FADR_DEBUG_TITLE", "aktiviere Debug Modus")
ZO_CreateStringId("LIO_FADR_DEBUG_TOOLTIP", "Falls es gewisse Probleme gibt, kann man mit dem Debug Modus die entsprechenden Informationen auslesen.")

ZO_CreateStringId("LIO_FADR_TOP_SETTING_HEADER", "Allgemeines")
ZO_CreateStringId("LIO_FADR_ZONE_SETTING_HEADER", "Meldungen in Zone")
ZO_CreateStringId("LIO_FADR_DEBUG_SETTING_HEADER", "Fehlersuche")
 
ZO_CreateStringId("LIO_FADR_ENABLE_NONE_TITLE", "Meldungen wenn ausgelaufen")
ZO_CreateStringId("LIO_FADR_ENABLE_NONE_TOOLTIP", "Auch wenn du nach ausgelaufender Mahlzeit, beim Wechseln einer Zone oder beim Betreten eines Verlieses, informiert werden möchtest, aktiviere diese Einstellung.")
 
ZO_CreateStringId("LIO_FADR_ENABLE_NOTIFY_ICON_TITLE", "Aktiviere Symbol")
ZO_CreateStringId("LIO_FADR_ENABLE_NOTIFY_ICON_TOOLTIP", "Wenn Sie über den Zustand Ihrer Mahlzeit mit Symbol informiert würden , aktivieren Sie diese Einstellung.")
 
ZO_CreateStringId("LIO_FADR_ENABLE_ACCOUNTWIDE_TITLE", "Enable account-wide settings")
ZO_CreateStringId("LIO_FADR_ENABLE_ACCOUNTWIDE_TOOLTIP", "If you enable to use account-wide settings, please check it.")
ZO_CreateStringId("LIO_FADR_UI_WARN", "Changing this option will trigger a reload of the user interface.")
 
-- keybinds
ZO_CreateStringId("SI_BINDING_NAME_LIO_FADR_ACTIVATE", "Aktiviere/Deaktiviere Meldung")