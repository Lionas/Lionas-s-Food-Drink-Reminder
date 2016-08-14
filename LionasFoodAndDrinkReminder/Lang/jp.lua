-- Lionas's Food & Drink Reminder
-- Author: Lionas
-- Japanese specific file

-- enable/disable
ZO_CreateStringId("LIO_FADR_ENABLE", "[<<1>>]は有効です")
ZO_CreateStringId("LIO_FADR_DISABLE", "[<<1>>]は無効です")

-- notification
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRE_HOUR_MIN", "残り<<1>>時間<<2>>分で食事の効果が消えます。")
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRE_MIN", "残り<<1>>分で食事の効果が消えます。")
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRE_CLOSED", "食事の効果がまもなく消えます。")
ZO_CreateStringId("LIO_FADR_NEAR_EXPIRED", "食事の効果が切れました！")

ZO_CreateStringId("LIO_FADR_SHOULD_EAT_DRINK", "食事の効果がありません！")

-- menus
ZO_CreateStringId("LIO_FADR_DESCRIPTION", "食事の状態を通知するアドオンです。")
ZO_CreateStringId("LIO_FADR_ENABLE_TITLE", "通知を有効にする")
ZO_CreateStringId("LIO_FADR_ENABLE_TOOLTIP", "食事の状態を通知する場合はチェックしてください")
ZO_CreateStringId("LIO_FADR_NOTIFY_THRESHOLD_TITLE", "通知タイミング[分]")
ZO_CreateStringId("LIO_FADR_NOTIFY_THRESHOLD_TOOLTIP", "残り時間がこの時間未満になったら通知します")
ZO_CreateStringId("LIO_FADR_NOTIFY_ONLY_IN_DUNGEON_TITLE", "ダンジョンにいる時のみ通知する")
ZO_CreateStringId("LIO_FADR_NOTIFY_ONLY_IN_DUNGEON_TOOLTIP", "ダンジョンにいる時のみ、食事の状態を通知する場合はチェックしてください")

-- keybinds
ZO_CreateStringId("SI_BINDING_NAME_LIO_FADR_ACTIVATE", "通知の切り替え")

