local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8
local renderWindow = imgui.new.bool(false)
local ev = require'moonloader'.audiostream_state
local fonts = renderCreateFont("Arial", 10, 4)
local style = 0
local selectMenu = imgui.new.int(1)

local lovlya = {
    dom = {
        wh = imgui.new.bool(false),
        lv = imgui.new.bool(false),
        sound = imgui.new.bool(false)
    },

    biz = {
        wh = imgui.new.bool(false),
        lv = imgui.new.bool(false),
        distance = imgui.new.int(5)
    },

    garage = {
        wh = imgui.new.bool(false),
        lv = imgui.new.bool(false),
        distance = imgui.new.int(5)
    },

    garden = {
        wh = imgui.new.bool(false),
        lv = imgui.new.bool(false),
        distance = imgui.new.int(5)
    },

    kiosk = {
        lv = imgui.new.bool(false)
    }
}

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then
        return
    end
    while not isSampAvailable() do
        wait(0)
    end

    sampRegisterChatCommand("lovim", function()
        renderWindow[0] = not renderWindow[0]
        if renderWindow[0] then
            sampAddChatMessage(
                "[{FF00CC}Ловля бизов/огородов/домов/гаражей/киосков by AkeGGa{FFFFFF}]: Меню была открыта.",
                -1)
        else
            sampAddChatMessage(
                "[{FF00CC}Ловля бизов/огородов/домов/гаражей/киосков by AkeGGa{FFFFFF}]: Меню была закрыта.",
                -1)
        end
    end)

    while true do
        wait(0)

        if lovlya.dom.lv[0] then
            local ix, iz, iy = getCharCoordinates(PLAYER_PED)
            for _, v in pairs(getAllObjects()) do
                local result, oX, oY, oZ = getObjectCoordinates(v)
                local models = getObjectModel(v)
                if models == 1273 then
                    local dist_doma = getDistanceBetweenCoords3d(ix, iz, iy, oX, oY, oZ)
                    if dist_doma < 4 then
                        flood_DOMA()
                    end
                end
            end
        end
        MYPOS = {getCharCoordinates(PLAYER_PED)}
        for _, v in pairs(getAllObjects()) do
            if isObjectOnScreen(v) and (lovlya.dom.wh[0]) then
                local _, x, y, z = getObjectCoordinates(v)
                local x1, y1 = convert3DCoordsToScreen(x, y, z)
                local model = getObjectModel(v)
                local x10, y10 = convert3DCoordsToScreen(MYPOS[1], MYPOS[2], MYPOS[3])
                local distance = getDistanceBetweenCoords3d(x, y, z, MYPOS[1], MYPOS[2], MYPOS[3])
                if (model == 1273) then
                    if (lovlya.dom.wh[0]) then
                        renderDrawPolygon(x1, y1, 10, 10, 10, 0, -1)
                        renderDrawPolygon(x10, y10, 10, 10, 10, 0, -1)
                        renderFontDrawText(fonts, string.format("DOM (%.1fm)", distance), x1, y1, -1)
                        renderDrawLine(x10, y10, x1, y1, 1.0, -1)
                    end
                end
            end
        end
        if lovlya.dom.sound[0] then
            for _, v in pairs(getAllObjects()) do
                local models = getObjectModel(v)
                if models == 1273 then
                    local sound = loadAudioStream("moonloader/SLETELDOM.mp3")
                    setAudioStreamState(sound, ev.PLAY)
                end
            end
        end
        for i = 0, 2048 do
            if sampIs3dTextDefined(i) then
                local text, color, posX, posY, posZ, distance, ignoreWalls, playerId, vehicleId = sampGet3dTextInfoById(
                    i)
                pxx, pyy, pzz = getCharCoordinates(playerPed)
                if lovlya.garage.lv[0] then
                    if text:find('Гараж') then
                        if isPointOnScreen(posX, posY, posZ, 0) and text:find('/buygarage') then
                            local dist_garage = getDistanceBetweenCoords3d(pxx, pyy, pzz, posX, posY, posZ)
                            local cx, zy = convert3DCoordsToScreen(posX, posY, posZ)
                            local x1, y1 = convert3DCoordsToScreen(pxx, pyy, pzz)
                            if dist_garage < 4 then
                                sampSendChat("/buygarage")
                                flood()
                                wait(1000)
                            end
                        end
                    end
                end
                if lovlya.biz.lv[0] then
                    if text:find('Бизнес') then
                        if isPointOnScreen(posX, posY, posZ, 0) and text:find('/buybiz') then
                            local dist_biz = getDistanceBetweenCoords3d(pxx, pyy, pzz, posX, posY, posZ)
                            local cx, zy = convert3DCoordsToScreen(posX, posY, posZ)
                            local x1, y1 = convert3DCoordsToScreen(pxx, pyy, pzz)
                            if dist_biz < 4 then
                                sampSendChat("/buybiz")
                                flood()
                                wait(1000)
                            end
                        end
                    end
                end
                if lovlya.garden.lv[0] then
                    if text:find('Огород') then
                        if isPointOnScreen(posX, posY, posZ, 0) and text:find('/buygarden') then
                            local dist_ogorod = getDistanceBetweenCoords3d(pxx, pyy, pzz, posX, posY, posZ)
                            local cx, zy = convert3DCoordsToScreen(posX, posY, posZ)
                            local x1, y1 = convert3DCoordsToScreen(pxx, pyy, pzz)
                            if dist_ogorod < 4 then
                                sampSendChat("/buygarden")
                                flood()
                                wait(1000)
                            end
                        end
                    end
                end
                if lovlya.biz.wh[0] then
                    if text:find('/buybiz') then
                        drawline(posX, posY, posZ, lovlya.biz, 200, 255, 0, 0)
                    end
                end
                if lovlya.garden.wh[0] then
                    if text:find('/buygarden') then
                        drawline(posX, posY, posZ, lovlya.garden, 200, 205, 0, 255)
                    end
                end
                if lovlya.garage.wh[0] then
                    if text:find('/buygarage') then
                        drawline(posX, posY, posZ, lovlya.garage, 200, 0, 0, 128)
                    end
                end
            end
        end
    end
end

require('samp.events').onServerMessage = function(color, text)
    if text:match('Поздравляем') and text:match('Вы приобрели дом') then
        thisScript():reload()
    end
    if lovlya.kiosk.lv[0] then
        if text:match('БАНКОВСКИЙ') and text:match('ЧЕК') and kiosk then
            flood()
        end
    end
end

function flood()
    lua_thread.create(function()
        while true do
            wait(0)
            setVirtualKeyDown(18, true)
            setVirtualKeyDown(18, false)
            setVirtualKeyDown(13, true)
            setVirtualKeyDown(13, false)
        end
    end)
end

function flood_DOMA()
    lua_thread.create(function()
        while true do wait(0)
            setVirtualKeyDown(18, true)
            wait(0)
            setVirtualKeyDown(18, false)
            wait(300)
        end
    end)
end

function onReceivePacket(id, bs)
	if id == 215 and lovlya.dom.lv[0] then
		raknetBitStreamIgnoreBits(bs, 8)
		if raknetBitStreamReadInt16(bs) == 2 then
			raknetBitStreamReadInt32(bs)
			for i = 1, raknetBitStreamReadInt8(bs) do
				local l = raknetBitStreamReadInt32(bs)
                local text = raknetBitStreamReadString(bs, l)
                if text:find("Дом свободен") then
                    local bs = raknetNewBitStream()
                    local bytes = { 2, 0, 0, 0, 0, 0, 16, 0, 0, 0, 79, 110, 68, 105, 97, 108, 111, 103, 82, 101, 115, 112, 111, 110, 115, 101, 8, 0, 0, 0, 100, 0, 0, 0, 0, 100 }
                    raknetBitStreamWriteInt8(bs, 215)
                    for i = 1, #bytes do
                        raknetBitStreamWriteInt8(bs, bytes[i])
                    end
                    raknetBitStreamWriteInt32(bs, 1)
                    raknetBitStreamWriteInt8(bs, 100)
                    raknetBitStreamWriteInt32(bs, 0)
                    raknetBitStreamWriteInt8(bs, 115)
                    raknetBitStreamWriteInt32(bs, 8)
                    raknetBitStreamWriteString(bs, "by akegga")
                    raknetSendBitStreamEx(bs, 1, 7, 1)
                    raknetDeleteBitStream(bs)
                end
			end
		end
	end
end

function drawline(x, y, z, TABLE, a, r, g, b)
    if TABLE['wh'][0] and dist(x, y, z) < TABLE['distance'][0] then
        local xx, yy = convert3DCoordsToScreen(x, y, z)
        local xxx, yyy = convert3DCoordsToScreen(MYPOS[1], MYPOS[2], MYPOS[3])
        renderDrawLine(xxx, yyy, xx, yy, 2, join_argb(a, r, g, b))
        renderDrawPolygon(xxx, yyy, 10, 10, 10, 0, join_argb(a, r, g, b))
        renderDrawPolygon(xx, yy, 10, 10, 10, 0, join_argb(a, r, g, b))
    end
end

function join_argb(a, r, g, b)
    local argb = b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end

function dist(x, y, z)
    return getDistanceBetweenCoords3d(MYPOS[1], MYPOS[2], MYPOS[3], x, y, z)
end

local font = {}
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    local glyph_ranges = imgui.GetIO().Fonts:GetGlyphRangesCyrillic()
    local font_path = getFolderPath(0x14) .. '\\trebucbd.ttf'
    imgui.GetIO().Fonts:Clear()
    imgui.GetIO().Fonts:AddFontFromFileTTF(font_path, 14.0, nil, glyph_ranges)
    for k, v in pairs({8, 11, 15, 16, 20, 25}) do
        font[v] = imgui.GetIO().Fonts:AddFontFromFileTTF(font_path, v, nil, glyph_ranges)
    end
    checkstyle()
end)

local newFrame = imgui.OnFrame(function()
    return renderWindow[0]
end, function(player)
    local resX, resY = getScreenResolution()
    imgui.SetNextWindowPos(imgui.ImVec2(resX / 2.5, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(-1, -1), imgui.Cond.FirstUseEver)
    imgui.Begin('Radmir', renderWindow,
        imgui.WindowFlags.NoTitleBar + imgui.WindowFlags.NoResize + imgui.WindowFlags.NoScrollbar +
            imgui.WindowFlags.NoCollapse + imgui.WindowFlags.AlwaysAutoResize)
    imgui.BeginGroup()
    imgui.BeginChild('##menulist', imgui.ImVec2(315, 210), false, imgui.WindowFlags.NoScrollbar)
    if imgui.Button(u8 "Ловля Дома", imgui.ImVec2(100, 100)) then
        selectMenu = 1
    end
    imgui.SameLine()
    if imgui.Button(u8 "Ловля Бизнеса", imgui.ImVec2(100, 100)) then
        selectMenu = 2
    end
    imgui.SameLine()
    if imgui.Button(u8 "Ловля Гаража", imgui.ImVec2(100, 100)) then
        selectMenu = 3
    end
    if imgui.Button(u8 "Ловля Огорода", imgui.ImVec2(100, 100)) then
        selectMenu = 4
    end
    imgui.SameLine()
    if imgui.Button(u8 "Ловля Киоска", imgui.ImVec2(100, 100)) then
        selectMenu = 5
    end
    imgui.SameLine()
    if imgui.Button(u8 "Спрятать Губу", imgui.ImVec2(100, 100)) then
        selectMenu = 0
    end
    imgui.EndChild()
    if selectMenu == 1 then
        imgui.Separator()
        if imgui.Checkbox(u8 'WH', lovlya.dom.wh) then
        end
        if imgui.Checkbox(u8 'Ловля', lovlya.dom.lv) then
        end
        if imgui.Checkbox(u8 'Звук при слете', lovlya.dom.sound) then
        end
        imgui.SetCursorPosX(65)
        imgui.Text(u8 "Открыт раздел: Ловля Домов")
    elseif selectMenu == 2 then
        imgui.Separator()
        if imgui.Checkbox(u8 'WH', lovlya.biz.wh) then
        end
        imgui.SameLine()
        imgui.PushItemWidth(200)
        imgui.SliderInt(u8 'Дистанция', lovlya.biz.distance, 0, 300)
        if imgui.Checkbox(u8 'Ловля', lovlya.biz.lv) then
        end
        imgui.SetCursorPosX(65)
        imgui.Text(u8 "Открыт раздел: Ловля Бизнесов")
    elseif selectMenu == 3 then
        imgui.Separator()
        if imgui.Checkbox(u8 'WH', lovlya.garage.wh) then
        end
        imgui.SameLine()
        imgui.PushItemWidth(200)
        imgui.SliderInt(u8 'Дистанция', lovlya.garage.distance, 0, 300)
        if imgui.Checkbox(u8 'Ловля', lovlya.garage.lv) then
        end
        imgui.SetCursorPosX(65)
        imgui.Text(u8 "Открыт раздел: Ловля Гаражей")
    elseif selectMenu == 4 then
        imgui.Separator()
        if imgui.Checkbox(u8 'WH', lovlya.garden.wh) then
        end
        imgui.SameLine()
        imgui.PushItemWidth(200)
        imgui.SliderInt(u8 'Дистанция', lovlya.garden.distance, 0, 300)
        if imgui.Checkbox(u8 'Ловля', lovlya.garden.lv) then
        end
        imgui.SetCursorPosX(65)
        imgui.Text(u8 "Открыт раздел: Ловля Огородов")
    elseif selectMenu == 5 then
        imgui.Separator()
        if imgui.Checkbox(u8 'Ловля', lovlya.kiosk.lv) then
        end
        imgui.SetCursorPosX(65)
        imgui.Text(u8 "Открыт раздел: Ловля Киосков")
    end
    imgui.End()
end)

function checkstyle()
    imgui.SwitchContext()
    local colors = imgui.GetStyle().Colors
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2
    -- ==[ STYLE ]==--
    imgui.GetStyle().WindowPadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().FramePadding = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemSpacing = imgui.ImVec2(5, 5)
    imgui.GetStyle().ItemInnerSpacing = imgui.ImVec2(2, 2)
    imgui.GetStyle().TouchExtraPadding = imgui.ImVec2(0, 0)
    imgui.GetStyle().IndentSpacing = 0
    imgui.GetStyle().ScrollbarSize = 10
    imgui.GetStyle().GrabMinSize = 10

    -- ==[ BORDER ]==--
    imgui.GetStyle().WindowBorderSize = 0
    imgui.GetStyle().ChildBorderSize = 0
    imgui.GetStyle().PopupBorderSize = 0
    imgui.GetStyle().FrameBorderSize = 0
    imgui.GetStyle().TabBorderSize = 0

    -- ==[ ROUNDING ]==--
    imgui.GetStyle().WindowRounding = 5
    imgui.GetStyle().ChildRounding = 5
    imgui.GetStyle().FrameRounding = 5
    imgui.GetStyle().PopupRounding = 5
    imgui.GetStyle().ScrollbarRounding = 5
    imgui.GetStyle().GrabRounding = 5
    imgui.GetStyle().TabRounding = 5

    -- ==[ ALIGN ]==--
    imgui.GetStyle().WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().ButtonTextAlign = imgui.ImVec2(0.5, 0.5)
    imgui.GetStyle().SelectableTextAlign = imgui.ImVec2(0.5, 0.5)

    -- ==[ COLORS ]==--
    if style == 0 then
        colors[imgui.Col.Text] = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
        colors[imgui.Col.TextDisabled] = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
        colors[imgui.Col.WindowBg] = imgui.ImVec4(0.41, 0.25, 0.25, 0.66)
        colors[imgui.Col.ChildBg] = imgui.ImVec4(0.86, 0.56, 0.56, 0.00)
        colors[imgui.Col.PopupBg] = imgui.ImVec4(0.82, 0.52, 0.52, 0.94)
        colors[imgui.Col.Border] = imgui.ImVec4(1.00, 1.00, 1.00, 0.50)
        colors[imgui.Col.BorderShadow] = imgui.ImVec4(0.00, 0.00, 0.00, 0.00)
        colors[imgui.Col.FrameBg] = imgui.ImVec4(0.81, 0.52, 0.52, 0.54)
        colors[imgui.Col.FrameBgHovered] = imgui.ImVec4(0.82, 0.55, 0.55, 0.40)
        colors[imgui.Col.FrameBgActive] = imgui.ImVec4(0.80, 0.53, 0.53, 0.67)
        colors[imgui.Col.TitleBg] = imgui.ImVec4(0.70, 0.36, 0.36, 1.00)
        colors[imgui.Col.TitleBgActive] = imgui.ImVec4(0.77, 0.52, 0.52, 1.00)
        colors[imgui.Col.TitleBgCollapsed] = imgui.ImVec4(0.77, 0.42, 0.42, 0.51)
        colors[imgui.Col.MenuBarBg] = imgui.ImVec4(0.72, 0.42, 0.42, 1.00)
        colors[imgui.Col.ScrollbarBg] = imgui.ImVec4(0.82, 0.41, 0.41, 0.53)
        colors[imgui.Col.ScrollbarGrab] = imgui.ImVec4(0.87, 0.42, 0.42, 1.00)
        colors[imgui.Col.ScrollbarGrabHovered] = imgui.ImVec4(0.84, 0.38, 0.38, 1.00)
        colors[imgui.Col.ScrollbarGrabActive] = imgui.ImVec4(0.90, 0.33, 0.33, 1.00)
        colors[imgui.Col.CheckMark] = imgui.ImVec4(0.84, 0.55, 0.55, 1.00)
        colors[imgui.Col.SliderGrab] = imgui.ImVec4(0.84, 0.49, 0.49, 1.00)
        colors[imgui.Col.SliderGrabActive] = imgui.ImVec4(0.89, 0.54, 0.54, 1.00)
        colors[imgui.Col.Button] = imgui.ImVec4(1.00, 0.69, 0.69, 0.64)
        colors[imgui.Col.ButtonHovered] = imgui.ImVec4(1.00, 0.66, 0.66, 1.00)
        colors[imgui.Col.ButtonActive] = imgui.ImVec4(1.00, 0.71, 0.71, 1.00)
        colors[imgui.Col.Header] = imgui.ImVec4(1.00, 0.70, 0.70, 0.64)
        colors[imgui.Col.HeaderHovered] = imgui.ImVec4(1.00, 0.67, 0.67, 0.66)
        colors[imgui.Col.HeaderActive] = imgui.ImVec4(0.82, 0.51, 0.51, 1.00)
        colors[imgui.Col.Separator] = imgui.ImVec4(0.00, 0.00, 0.00, 0.50)
        colors[imgui.Col.SeparatorHovered] = imgui.ImVec4(0.00, 0.00, 0.00, 0.78)
        colors[imgui.Col.SeparatorActive] = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
        colors[imgui.Col.ResizeGrip] = imgui.ImVec4(1.00, 0.73, 0.73, 0.25)
        colors[imgui.Col.ResizeGripHovered] = imgui.ImVec4(1.00, 0.69, 0.69, 0.72)
        colors[imgui.Col.ResizeGripActive] = imgui.ImVec4(1.00, 0.72, 0.72, 0.95)
        colors[imgui.Col.Tab] = imgui.ImVec4(0.99, 0.73, 0.73, 0.86)
        colors[imgui.Col.TabHovered] = imgui.ImVec4(1.00, 0.70, 0.70, 0.80)
        colors[imgui.Col.TabActive] = imgui.ImVec4(1.00, 0.73, 0.73, 0.59)
        colors[imgui.Col.TabUnfocused] = imgui.ImVec4(0.15, 0.07, 0.07, 0.97)
        colors[imgui.Col.TabUnfocusedActive] = imgui.ImVec4(0.42, 0.14, 0.14, 1.00)
        colors[imgui.Col.PlotLines] = imgui.ImVec4(0.61, 0.61, 0.61, 1.00)
        colors[imgui.Col.PlotLinesHovered] = imgui.ImVec4(1.00, 0.43, 0.35, 1.00)
        colors[imgui.Col.PlotHistogram] = imgui.ImVec4(0.90, 0.70, 0.00, 1.00)
        colors[imgui.Col.PlotHistogramHovered] = imgui.ImVec4(1.00, 0.60, 0.00, 1.00)
        colors[imgui.Col.TextSelectedBg] = imgui.ImVec4(1.00, 0.72, 0.73, 0.35)
        colors[imgui.Col.DragDropTarget] = imgui.ImVec4(1.00, 1.00, 0.00, 0.90)
        colors[imgui.Col.NavHighlight] = imgui.ImVec4(1.00, 0.74, 0.74, 1.00)
        colors[imgui.Col.NavWindowingHighlight] = imgui.ImVec4(1.00, 1.00, 1.00, 0.70)
        colors[imgui.Col.NavWindowingDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.20)
        colors[imgui.Col.ModalWindowDimBg] = imgui.ImVec4(0.80, 0.80, 0.80, 0.35)
    end
end

function onWindowMessage(msg, wparam, lparam) 
	if msg == 261 and wparam == 13 then consumeWindowMessage(true, true) end 
end