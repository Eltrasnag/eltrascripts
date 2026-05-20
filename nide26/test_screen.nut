function OnPostSpawn() {
    // // NetProps.SetPropString(self, "m_strOverlayMaterial", "eltra/test_cat.vmt")
    // // NetProps.SetPropString(self, "m_nPanelName", "vgui_test_screen")
    // ClientPrint(null, HUD_PRINTCENTER, "VGUI Screen spawns")
    // QAcceptInput(self, "SetActive", "")
    // QFireByHandle(self, "enable")
    // local dir = "glados"
    // for (local i = 0; i < NetProps.GetPropArraySize(self, "m_chCurrentSlideLists"); i++) {
    //     printl("m_chCurrentSlideLists:" + NetProps.GetPropStringArray(self, "m_chCurrentSlideLists", i))
    //     NetProps.SetPropStringArray(self, "m_chCurrentSlideLists", "glados_screens_bird005", i)
    // }
    // foreach (i, char in dir) {
    //     // NetProps.SetPropStringArray(self, "m_szSlideshowDirectory", char.tochar(), i)
    //     // char.tochar()
    // }

    // RunScriptCode(self, "DumpProps()", 1)
}



function DumpProps() {
    dprintl("Dump netprops...")
    local props = {}
    NetProps.GetTable(self, 1, props)

    foreach (key, val in props) {
        dprintl(key + ":" +val)
    }
    __DumpScope(3, props)
    // local int

}

function Inputfireuser1() {
    DumpProps()
}