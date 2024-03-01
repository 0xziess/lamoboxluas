--> creds to muqa for this cool menu and functions https://github.com/Muqa1/Muqa-LBOX-pastas/blob/main/Release%20misc%20tools.lua | creds to LNX for the rounded corners from this menu https://github.com/lnx00/Lmaobox-Lua/blob/main/src/PoC/WinUI.lua
local menu = {
    x = 500,
    y = 500,

    w = 405,
    h = 365,

    rX = 0,
    rY = 0,

    rX2 = 0,
    rY2 = 0,

    tabs = {
        tab_1 = true,
        tab_2 = false,
        tab_3 = false,
        tab_4 = false,
    },

    buttons = {
        main = false,
        colors = false,
        keybinds = false,
        cfg = false,

        cfg_load = false,
        cfg_save = false,
    },

    toggles = {
        keybinde_menu = true,
        nitro_dt_bar = true,

        aimbot = true,
        crits = true,
        dtky = true,
        rechrge = true,
        thrdperson = true,
        fakeleg = true,
        werp = true,
        triggerbt = true,
        triggersht = true,

    },

    colors = { 

        all = 194,
        all2 = 83,
        all3 = 83,

        dtbarcolr = 255,
        dtbarcolr2 = 134,
        dtbarcolr3 = 42,

        bgcolr = 41,
        bgcolr2 = 42,
        bgcolr3 = 46,
    },
}

local title = draw.CreateFont( "Roboto Medium", 23, 500 )
local binds = draw.CreateFont( "Arial", 18, 1000 )


local textcolorwhenoff = {120, 120, 120, 250}

local nitrofont = draw.CreateFont('Verdana', 15, 1000, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)
local nitrofont2 = draw.CreateFont('Tahoma', 16, 1000, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)

local barWidth = 115
local barHeight = 9 -- change this to make the dt bar bigger
local minTicks = 1
local maxTicks = 23
local barOffset = 45



local function clamp(a,b,c)return(a<b)and b or(a>c)and c or a end

local charge = 0;
local charging = false;
local updateBarCharge = (function()
    local last_charge = 0;

    return function()
        local max = clamp((client.GetConVar("sv_maxusrcmdprocessticks") or 23) - 2, 1, 21);
        charge = clamp((warp.GetChargedTicks() - 1) / 22, 0, 1);
        charging = charge > last_charge;

        last_charge = charge;

    end
end)();

---@type lnxLib
local lnxLib = require("lnxLib")
local Input, KeyHelper = lnxLib.Utils.Input, lnxLib.Utils.KeyHelper
local Textures = lnxLib.UI.Textures

---@alias Context { Rect: number[] }

--[[ Vars ]]

local mouseHelper = KeyHelper.new(MOUSE_LEFT)
local currentId = 0
local activeId = nil
local dragPos = nil



---@type lnxLib
local lnxLib = require("lnxLib")
local Input, KeyHelper = lnxLib.Utils.Input, lnxLib.Utils.KeyHelper
local Textures = lnxLib.UI.Textures

---@alias Context { Rect: number[] }

--[[ Vars ]]

local mouseHelper = KeyHelper.new(MOUSE_LEFT)
local currentId = 0
local activeId = nil
local dragPos = nil

local circle = Textures.Circle(16, { 255, 255, 255, 255 })


local Style = {
  HeaderSize = 50,
  FramePadding = 10,
  ItemPadding = 5,
  Circles = true
}

--[[ Utils ]]

local function DrawCircle(x, y, r)
    draw.TexturedRect(circle, x - r, y - r, x + r, y + r)
end

local function RoundedRect(x1, y1, x2, y2, r)
    if not Style.Circles then
        draw.FilledRect(x1, y1, x2, y2)
        return
    end

    DrawCircle(x1 + r, y1 + r, r)
    DrawCircle(x2 - r, y1 + r, r)
    DrawCircle(x1 + r, y2 - r, r)
    DrawCircle(x2 - r, y2 - r, r)

    draw.FilledRect(x1 + r, y1, x2 - r, y2)
    draw.FilledRect(x1, y1 + r, x2, y2 - r)
end

local function GetInteraction(x1, y1, x2, y2, id)
  -- Is a different element active?
  if activeId ~= nil and activeId ~= id then
      return false, false, false
  end

  local hovered = Input.MouseInBounds(x1, y1, x2, y2) or id == activeId
  local clicked = hovered and (mouseHelper:Released())
  local active = hovered and (mouseHelper:Down())

  -- Should this element be active?
  if active and activeId == nil then
      activeId = id
  end

  -- Is this element no longer active?
  if activeId == id and not active then
      activeId = nil
  end

  return hovered, clicked, active
end


local tahoma = draw.CreateFont( "Tahoma", 12, 400, FONTFLAG_OUTLINE )
local tahoma2 = draw.CreateFont( "Tahoma", 12, 400)
local tahoma_bold = draw.CreateFont( "Tahoma", 12, 800, FONTFLAG_OUTLINE )

local f = math.floor

local function GetPressedKey()
    for i = 1, 113 do 
        if input.IsButtonPressed( i ) then
            if i ~= 107 then 
                return i
            end
        end
    end
end

local function IsMouseInBounds(x,y,x2,y2)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    if mX >= x and mX <= x2 and mY >= y and mY <= y2 then
        return true 
    end
    return false
end

local function TextInCenter(x,y,x2,y2,string)
    local w, h = draw.GetTextSize(string)
    local width, height = x2-x, y2-y
    draw.Text(math.floor(x+(width/2)-(w/2)), math.floor(y+(height/2)-(h/2)), string)
end

local Toggles = {}
local function Toggle(x, y, name, toggle_bool)
    local w, h = draw.GetTextSize(name)
    local pos = {x, y, x + 20, y + 20}
    if Toggles[toggle_bool] == nil then
        table.insert(Toggles, toggle_bool)
    end
    local clr = {10, 10, 10, 50}
    if IsMouseInBounds(table.unpack(pos)) and input.IsButtonPressed(MOUSE_LEFT) then
        local currentTime = globals.RealTime()
        if currentTime - (Toggles[toggle_bool] or 0) >= 0.1 then
            menu.toggles[toggle_bool] = not menu.toggles[toggle_bool]
            Toggles[toggle_bool] = currentTime
        end
        clr = {40, 40, 40, 50}
    end
    draw.Color(table.unpack(clr))
    draw.FilledRect(table.unpack(pos))
    draw.Color(80, 80, 80, 255)
    draw.OutlinedRect(table.unpack(pos))
    draw.Color(255, 255, 255, 255)
    draw.Text(pos[3]+5,y+f(h/4), name)
    if menu.toggles[toggle_bool] == true then
        draw.Color(60, 60, 60, 255)
        draw.FilledRect(pos[1] + 5, pos[2] + 5, pos[3] - 5, pos[4] - 5)
    end
end

local function Island(x,y,x2,y2, name)
    local r,g,b = 53,126,53
    draw.Color(10, 10, 10, 50)
    draw.FilledRect(x,y,x2,y2)
    draw.Color( r,g,b,125 )
    draw.OutlinedRect(x, y, x2, y2)
    draw.Color( r,g,b,40 )
    draw.FilledRect(x, y - 15, x2, y)
    draw.Color( r,g,b,125 )
    draw.OutlinedRect(x, y - 15, x2, y)
    draw.Color( 255,255,255,255 )
    local w,h = draw.GetTextSize(name)
    draw.Text(math.floor(x+((x2-x)/2)-(w/2)), math.floor(y-14), name )
end

local function Slider(x,y,x2,y2, sliderValue ,min,max, name)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    local value = menu.colors[sliderValue]
    if IsMouseInBounds(x,y - 5,x2,y2 + 5) and input.IsButtonDown(MOUSE_LEFT) then 
        function clamp(value, min, max) -- math.clamp was causing errors :shrug:
            return math.max(min, math.min(max, value))
        end
        local percent = clamp((mX - x) / (x2-x), 0, 1)
        local value2 = math.floor((min + (max - min) * percent))
        menu.colors[sliderValue] = value2
    end
    draw.Color(40,40,40,255)
    draw.OutlinedRect(x,y,x2,y2)
    draw.Color(10,10,10,50)
    draw.FilledRect(x,y,x2,y2)
    local r,g,b = 53,126,53
    draw.Color( r,g,b,40 )
    local sliderWidth = math.floor((x2-x) * (value - min) / (max - min))
    local pos = {x, y, x + sliderWidth, y2}
    draw.FilledRect(table.unpack(pos))
    draw.Color( r,g,b,255 )
    draw.OutlinedRect(table.unpack(pos))
    draw.Color(255,255,255,255)
    local w,h = draw.GetTextSize( value )
    draw.Text(x2-w, pos[2]-h, value)
    w,h = draw.GetTextSize( name )
    draw.Text(x, pos[2]-h, name)
end

local function CFGbutton(x,y,x2,y2,name,button)
    
    local clr = {53,126,53}
    if IsMouseInBounds(x,y,x2,y2) and input.IsButtonPressed(MOUSE_LEFT) then 
        clr = {175, 175, 175}
        menu.buttons[button] = true
    else
        menu.buttons[button] = false
    end
    draw.Color( clr[1],clr[2],clr[3],40 )
    draw.FilledRect(x, y, x2, y2)
    draw.Color( clr[1],clr[2],clr[3],125 )
    draw.OutlinedRect(x, y, x2, y2)
    local w,h = draw.GetTextSize(name)
    draw.Color( 255,255,255,255 )
    draw.Text(math.floor(x+((x2-x)/2)-(w/2)), math.floor(y+(h*0.1)),name)
end

local function NotificationBox(x,y,string,alphaProcent)
    local r,g,b = 53,126,53
    string = "Notification: ".. string
    local w,h = draw.GetTextSize(string)
    local padding = 5
    draw.Color(r,g,b,f(50*alphaProcent))
    draw.FilledRect(x-padding,y-padding,x+w+padding,y+h+padding)
    draw.Color(r, g, b, f(255*alphaProcent))
    draw.OutlinedRect(x-padding, y-padding, x+w+padding,y+h+padding)
    draw.Color(255,255,255,f(255*alphaProcent))
    draw.Text(x,y,string)
end

local notifications = {} 

local lastToggleTime = 0
local Lbox_Menu_Open = true
local function toggleMenu()
    local currentTime = globals.RealTime()
    if currentTime - lastToggleTime >= 0.1 then
        Lbox_Menu_Open = not Lbox_Menu_Open
        lastToggleTime = currentTime
    end
end

local IsDragging = false
local IsDragging2 = false
local IsDragging3 = false
local IsDraggingDMGLOG = false

local buttons = {
    [1] = {name="Main", table="antiaim"},
    [2] = {name="Colors", table="visuals"},
}

local function DrawMenu()
    if not Lbox_Menu_Open then return end
    draw.SetFont( tahoma )

    local x, y = menu.x, menu.y
    local bW, bH = menu.w, menu.h
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    
    if IsDragging2 then
        if input.IsButtonDown(MOUSE_LEFT) then
            menu.x = mX - math.floor(bW * menu.rX)
            menu.y = mY - math.floor(15 * menu.rY)
        else
            IsDragging2 = false
        end
    else
        if IsMouseInBounds(x, y - 15, x + bW, y) then
            if not input.IsButtonDown(MOUSE_LEFT) then
                menu.rX = ((mX - x) / bW)
                menu.rY = ((mY - y) / 15)
            else
                menu.x = mX - math.floor(bW * menu.rX)
                menu.y = mY - math.floor(15 * menu.rY)
                IsDragging2 = true
            end
        end
    end
    
    


    draw.Color( 30, 30, 30, 255 )
    draw.FilledRect(x, y, x + bW, y + bH) -- main backround

    draw.Color( 53,126,53, 255 )
    draw.OutlinedRect(x, y - 15, x + bW, y + bH) -- outline to the main menu
    draw.OutlinedRect(x, y - 15, x + bW, y) -- outline of blue bar

    draw.Color( 53,126,53,125 )
    draw.FilledRect(x, y - 15, x + bW, y) -- blue bar

    local string = "misc tools test"
    local w, h = draw.GetTextSize(string)
    draw.Color(255, 255, 255, 255)
    --draw.Text(math.floor(x+(bW/2)-(w/2)), math.floor(y-h), string) -- name
    TextInCenter(x, y - 15, x + bW, y, string)

    draw.Color(255,255,255,200)
    local time = os.date("%H:%M")
    w,h = draw.GetTextSize(time)
    draw.Text(x+bW-w-2,y-h,time)


    -- button  
    local startY = 0
    for i = 1, #buttons do 
        local button = buttons[i]
        local w, h = draw.GetTextSize(button.name)
        local pos = {x+5, y+startY+5, x+85, y+startY+25}
        local clr = {10, 10, 10, 50}
        
        -- Check if the mouse is inside the button bounds and the left mouse button is pressed
        if IsMouseInBounds(table.unpack(pos)) and input.IsButtonPressed(MOUSE_LEFT) then 
            clr = {40, 40, 40, 50}
            -- Toggle the button state in the menu.buttons table
            menu.buttons[button.table] = true
        else
            menu.buttons[button.table] = false
        end
        
        draw.Color(table.unpack(clr))
        draw.FilledRect(table.unpack(pos))
        draw.Color(53,126,53, 40)--45, 45, 45, 255
        draw.OutlinedRect(table.unpack(pos))
        draw.Color(255, 255, 255, 255)
        TextInCenter(pos[1], pos[2], pos[3], pos[4], button.name)
        startY = startY + 25
    end

    if menu.buttons.antiaim then 
        menu.tabs.tab_1=true
        menu.tabs.tab_2=false
        menu.tabs.tab_3=false
        menu.tabs.tab_4=false
    end
    if menu.buttons.visuals then 
        menu.tabs.tab_1=false
        menu.tabs.tab_2=true
        menu.tabs.tab_3=false
        menu.tabs.tab_4=false
    end
    if menu.buttons.misc then 
        menu.tabs.tab_1=false
        menu.tabs.tab_2=false
        menu.tabs.tab_3=true
        menu.tabs.tab_4=false
    end

    draw.Color(45, 45, 45, 255)
    draw.Line(x+90,y+1, x+90, y+bH-1)

    draw.Color(200, 200, 200, 50)
    draw.Text(x+5, y+bH-35, "Config")
    CFGbutton(x+5, y+bH-20,x+46, y+bH-5,"Load", "cfg_load")
    CFGbutton(x+48, y+bH-20,x+87, y+bH-5,"Save", "cfg_save")
    x = x + 90
    if menu.tabs.tab_1 then
        menu.w = 300
        menu.h = 200
        local x1,y1 = x+5, y+20

        Island(x1,y1,x1+150,y1+130,"Features")
        Toggle(x1+5, y1+5,"Nitro Keybinds", "keybinde_menu")
        Toggle(x1+5, y1+35,"Nitro DT Bar", "nitro_dt_bar")

        
        

    end

    if menu.tabs.tab_2 then
        menu.w = 450
        menu.h = 250
        local x1,y1 = x+5, y+20

        Island(x1 + 5,y1,x1+150,y1+100,"Keybinds toggled ON + Line")
        Slider(x1+10,y1+25,x1+140,y1+35, "all" ,0,255, "Red")
        Slider(x1+10,y1+55,x1+140,y1+65, "all2" ,0,255, "Green")
        Slider(x1+10,y1+85,x1+140,y1+95, "all3" ,0,255, "Blue")

        Island(x1+175,y1,x1+320,y1+100,"DT Bar")
        Slider(x1+180,y1+25,x1+310,y1+35, "dtbarcolr" ,0,255, "Red")
        Slider(x1+180,y1+55,x1+310,y1+65, "dtbarcolr2" ,0,255, "Green")
        Slider(x1+180,y1+85,x1+310,y1+95, "dtbarcolr3" ,0,255, "Blue")

        Island(x1+85,y1+125,x1+250,y1+225,"Keybinds Background")
        Slider(x1+90,y1+150,x1+240,y1+160, "bgcolr" ,0,255, "Red")
        Slider(x1+90,y1+180,x1+240,y1+190, "bgcolr2" ,0,255, "Green")
        Slider(x1+90,y1+210,x1+240,y1+220, "bgcolr3" ,0,255, "Blue")

        
    end

    if menu.tabs.tab_3 then
        menu.w = 415
        menu.h = 360
        local x1,y1 = x+5, y+20

        Island(x1,y1,x1+150,y1+55,"Crosshair Indicators")
        Toggle(x1+5, y1+5,"Enable", "crosshair_indicators")

        y1 = y1+50
        Island(x1,y1,x1+150,y1+55,"Damage Logger")
        Toggle(x1+5, y1+5,"Enable", "dmg_logger")
        Toggle(x1+5, y1+30,"Custom Position", "dmg_logger_custom_pos")



    end
end
callbacks.Unregister( "Draw", "awftgybhdunjmiko")
callbacks.Register( "Draw", "awftgybhdunjmiko", DrawMenu )



local function CreateCFG(folder_name, table)
    local success, fullPath = filesystem.CreateDirectory(folder_name)
    local filepath = tostring(fullPath .. "/config.txt")
    local file = io.open(filepath, "w")
    
    if file then
        local function serializeTable(tbl, level)
            level = level or 0
            local result = string.rep("    ", level) .. "{\n"
            for key, value in pairs(tbl) do
                result = result .. string.rep("    ", level + 1)
                if type(key) == "string" then
                    result = result .. '["' .. key .. '"] = '
                else
                    result = result .. "[" .. key .. "] = "
                end
                if type(value) == "table" then
                    result = result .. serializeTable(value, level + 1) .. ",\n"
                elseif type(value) == "string" then
                    result = result .. '"' .. value .. '",\n'
                else
                    result = result .. tostring(value) .. ",\n"
                end
            end
            result = result .. string.rep("    ", level) .. "}"
            return result
        end
        
        local serializedConfig = serializeTable(table)
        file:write(serializedConfig)
        file:close()
    end
end

local function LoadCFG(folder_name)
    local success, fullPath = filesystem.CreateDirectory(folder_name)
    local filepath = tostring(fullPath .. "/config.txt")
    local file = io.open(filepath, "r")
    
    if file then
        local content = file:read("*a")
        file:close()
        local chunk, err = load("return " .. content)
        if chunk then
            return chunk()
        else
            print("Error loading configuration:", err)
        end
    end
end



local logs = {}


local sW,sH = draw.GetScreenSize()

local screenX, screenY = draw.GetScreenSize()
local barX = math.floor(screenX / 2 - barWidth / 2)
local barY = math.floor(screenY / 2) + barOffset
local x1, y1, width, height = 50, 980, 310, 280
local moving = false
local moving1 = false
local IsDragging2 = false

local function NonMenuDraw()
    if input.IsButtonPressed( KEY_END ) or input.IsButtonPressed( KEY_INSERT ) or input.IsButtonPressed( KEY_F11 ) then 
        toggleMenu()
    end

    local keybindslist = {
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
        "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
        "u", "v", "w", "x", "y", "z", "num0", "num1", "num2",
        "num3", "num4", "num5", "num6", "num7", "num8", "num9",
        "/", "*", "-", "+", "Enter", ",", "[", "]", ";", "'",
        "`", ",", ".", "/", "\\", "-", "=", "Enter", "Space",
        "BSpace", "Tab", "Caps", "NumL", "Esc", "Scrlk", "Ins",
        "Del", "Home", "End", "PgUp", "PgDn", "Break", "shift",
        "shift", "alt", "alt", "Ctrl", "Ctrl", "Win", "Win",
        "App", "Upp", "Left", "Down", "Right", "F1", "F2", "F3",
        "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12",
        "Cap", "Num", "KEY_SCROLLLOCKTOGGLE", "m1", "m2",
        "m3", "m4", "m5", "m4", "m5",
        "mwup", "mwdn"
    }
    
    local x2, y2 = x1, y1

    local posX, posY = x1, y1
    
    local aimbot_key = keybindslist[gui.GetValue("Aim key")]
    local aimbot_mode = gui.GetValue( "Aim key mode" )
    
    local dt_key = keybindslist[gui.GetValue( "double tap key" )]
    local dt_key_recharge = keybindslist[gui.GetValue( "force recharge key" )]
    
    local force_crits = gui.GetValue( "crit hack" )
    local force_crits_key = keybindslist[gui.GetValue( "crit hack key" )]
    
    local thirdperson_key = keybindslist[gui.GetValue( "thirdperson key")]
    
    local fakelag_key = keybindslist[gui.GetValue( "fake lag key" )]

    local fakelagms = gui.GetValue( "fake lag value (ms)" ) + 15

    local aimbot_state = gui.GetValue("aimbot")

    local trigger_key = keybindslist[gui.GetValue( "trigger key" )]

    local triggershoot_key = keybindslist[gui.GetValue( "trigger shoot key" )]

    local warp_key = keybindslist[gui.GetValue( "dash move key" )]

    draw.SetFont(tahoma_bold)

    local notif_startY = 0
    local time = 4
    local currentTime = globals.CurTime()
    local seenNotifications = {}
    for i = #notifications, 1, -1 do 
        local notif = notifications[i]
        local logTime = notif.time or currentTime
        local elapsedTime = currentTime - logTime
        if not seenNotifications[notif.text] then
            if elapsedTime >= time then
                table.remove(notifications, i)
            else
                NotificationBox(10, 10 + notif_startY, notif.text, 1 - (elapsedTime / time))
                notif_startY = notif_startY + 30
            end
            seenNotifications[notif.text] = true
        else
            table.remove(notifications, i)
        end
    end
    

    if menu.buttons.cfg_save then 
        CreateCFG([[MiscToolsLua]], menu)
        table.insert(notifications, 1, {time = globals.CurTime(), text = "Saved Config!"})
    end
    

    if menu.buttons.cfg_load then 
        menu = LoadCFG([[MiscToolsLua]])
        table.insert(notifications, 1, {time = globals.CurTime(), text = "Loaded Config!"})
    end

    

    local keybindHeight = height
    local keybindWidth = width

    

    if menu.toggles.keybinde_menu then

            if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                return
              end

              if Lbox_Menu_Open == false then

                if menu.toggles.aimbot == false then
                    keybindHeight = keybindHeight - 25
                end
            
                if menu.toggles.crits == false then
                    keybindHeight = keybindHeight - 25
                end
            
                if menu.toggles.dtky == false then
                    keybindHeight = keybindHeight - 25
                end
            
                if menu.toggles.rechrge == false then
                    keybindHeight = keybindHeight - 25
                end
            
                if menu.toggles.thrdperson == false then
                    keybindHeight = keybindHeight - 25
                end
            
                if menu.toggles.fakeleg == false then
                    keybindHeight = keybindHeight - 25
                end
            
                if menu.toggles.triggerbt == false then
                    keybindHeight = keybindHeight - 25
                end
            
                if menu.toggles.triggersht == false then
                    keybindHeight = keybindHeight - 25
                end

                if menu.toggles.werp == false then
                    keybindHeight = keybindHeight - 25
                end
            
              end
            
                draw.SetFont(title)
                draw.Color( menu.colors.bgcolr, menu.colors.bgcolr2, menu.colors.bgcolr3, 255 )
                RoundedRect(posX, posY, posX + width, posY + keybindHeight, 6)
            
                draw.Color( 255, 255, 255, 255 )
                draw.Text( 20 + posX, 10 + posY, "Binds" )
                
                draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                RoundedRect(posX + 15, posY + 35, posX + width - 10, posY + 210 - 172, 0)

                if Lbox_Menu_Open == true then
                    draw.Color( 255, 255, 255, 255 )
                    draw.OutlinedRect( posX - 12, posY - 12, posX + width + 55, posY + keybindHeight + 12 )

                    local x, y = x1, y1
                    local bW, bH = width, height
                    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
                    
                    if IsDragging then
                        if input.IsButtonDown(MOUSE_LEFT) then
                            x1 = mX - math.floor(bW * menu.rX)
                            y1 = mY - math.floor(15 * menu.rY)
                        else
                            IsDragging = false
                        end
                    else
                        if IsMouseInBounds(x, y, x + bW, y + bH) then
                            if not input.IsButtonDown(MOUSE_LEFT) then
                                menu.rX = ((mX - x) / bW)
                                menu.rY = ((mY - y) / 15)
                            else
                                x1 = mX - math.floor(bW * menu.rX)
                                y1 = mY - math.floor(15 * menu.rY)
                                IsDragging = true
                            end
                        end
                    end

                    
                    draw.SetFont(title)
                    draw.Color( menu.colors.bgcolr, menu.colors.bgcolr2, menu.colors.bgcolr3, 255 )
                    RoundedRect(posX, posY, posX + width + 45, posY + keybindHeight, 6)
            
                    draw.Color( 255, 255, 255, 255 )
                    draw.Text( 20 + posX, 10 + posY, "Binds" )
                
                    draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                    RoundedRect(posX + 15, posY + 35, posX + width + 25, posY + 210 - 172, 0)

                    Toggle(320 + x1, y2 + 48,"", "aimbot")
                    Toggle(320 + x1, y2 + 73,"", "crits")
                    Toggle(320 + x1, y2 + 98,"", "dtky")
                    Toggle(320 + x1, y2 + 123,"", "rechrge")
                    Toggle(320 + x1, y2 + 148,"", "thrdperson")
                    Toggle(320 + x1, y2 + 173,"", "fakeleg")
                    Toggle(320 + x1, y2 + 198,"", "triggerbt")
                    Toggle(320 + x1, y2 + 223,"", "triggersht")
                    Toggle(320 + x1, y2 + 248,"", "werp")

                    

                else
                end 

                
            
                draw.SetFont(binds)

            if Lbox_Menu_Open == true then
                
               

            
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
        
                    
                    
                    
                    if (input.IsButtonDown( gui.GetValue("Aim key") )) and (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 then
                      draw.Color( 200, 200, 200, 250 )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                      draw.Text( 25 + x1, y2 + 50, "Hold" )
                      draw.Text( 270 + x1, y2 + 50, "On" )
                
                    elseif (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 1 then
                      draw.Color( 200, 200, 200, 250 )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                      draw.Text( 25 + x1, y2 + 50, "Toggle" )
                      draw.Text( 270 + x1, y2 + 50, "On" )
                    elseif (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 0 then
                      draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                      draw.Text( 25 + x1, y2 + 50, "Toggle" )
                      draw.Text( 270 + x1, y2 + 50, "Off" )
                    else
                      draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                      draw.Text( 85 + x1, y2 + 50, "aimbot" )
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Text( 25 + x1, y2 + 50, "Hold" )
                      draw.Text( 270 + x1, y2 + 50, "Off" )
                    end
        
                   
        
               
        
                
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "crit hack key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "Off" )
                      end
                
        
                
        
        
               
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "double tap key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "Off" )
                      end
        
                      
                
                
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "force recharge key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, dt_key_recharge )
                        
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, dt_key_recharge )
                  
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "Off" )
                      end
        
                      
                
                
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if gui.GetValue( "thirdperson" ) == 1 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, thirdperson_key  )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, thirdperson_key )
                  
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "Off" )
                      end
        
                      
                
        
                
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "fake lag" ) >= 1 and gui.GetValue( "fake lag key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, "none" )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    elseif gui.GetValue( "fake lag" ) >= 0 and gui.GetValue( "fake lag key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, "none" )
                  
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    elseif gui.GetValue( "fake lag" ) >= 1 and gui.GetValue( "fake lag key") >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, fakelag_key )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, fakelag_key )
                         
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    end
                      
                

                
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "trigger key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, "always on" )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 200 + y2, "Toggle" )
                        draw.Text( 270 + x1, 200 + y2, "On" )
                    elseif gui.GetValue( "trigger key", trigger_key) and (input.IsButtonDown( gui.GetValue( "trigger key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, trigger_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 200 + y2, "Hold" )
                        draw.Text( 270 + x1, 200 + y2, "On" )
                    else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, trigger_key )
                  
                        draw.Text( 25 + x1, 200 + y2, "Hold" )
                        draw.Text( 270 + x1, 200 + y2, "Off" )
                    end

                      
                

               
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "trigger shoot") == 1 and gui.GetValue( "trigger shoot key" ) == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, "none" )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 225 + y2, "Toggle" )
                        draw.Text( 270 + x1, 225 + y2, "On" )
                    elseif gui.GetValue( "trigger shoot") == 0 and gui.GetValue( "trigger shoot key" ) == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, "none" )
                         
                        draw.Text( 25 + x1, 225 + y2, "Toggle" )
                        draw.Text( 270 + x1, 225 + y2, "Off" )
                    elseif gui.GetValue( "trigger shoot") == 1 and gui.GetValue( "trigger shoot key" ) >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, triggershoot_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 225 + y2, "Hold" )
                        draw.Text( 270 + x1, 225 + y2, "On" )
                    else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, triggershoot_key )
                  
                        draw.Text( 25 + x1, 225 + y2, "Hold" )
                        draw.Text( 270 + x1, 225 + y2, "Off" )
                    end

                      
                
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "dash move key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, y2 + 250, "Toggle" )
                        draw.Text( 270 + x1, y2 + 250, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Text( 25 + x1, y2 + 250, "Toggle" )
                        draw.Text( 270 + x1, y2 + 250, "Off" )
                      end




            end

            if Lbox_Menu_Open == false then
                
                if menu.toggles.aimbot then

            
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
        
                    
                    
                    
                    if (input.IsButtonDown( gui.GetValue("Aim key") )) and (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 then
                      draw.Color( 200, 200, 200, 250 )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                      draw.Text( 25 + x1, y2 + 50, "Hold" )
                      draw.Text( 270 + x1, y2 + 50, "On" )
                
                    elseif (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 1 then
                      draw.Color( 200, 200, 200, 250 )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                      draw.Text( 25 + x1, y2 + 50, "Toggle" )
                      draw.Text( 270 + x1, y2 + 50, "On" )
                    elseif (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 0 then
                      draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                      draw.Text( 25 + x1, y2 + 50, "Toggle" )
                      draw.Text( 270 + x1, y2 + 50, "Off" )
                    else
                      draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                      draw.Text( 85 + x1, y2 + 50, "aimbot" )
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Text( 25 + x1, y2 + 50, "Hold" )
                      draw.Text( 270 + x1, y2 + 50, "Off" )
                    end
        
                   
        
                else
                    if Lbox_Menu_Open == false then
                        y2 = y2 - 25
                    end
                end
        
                if menu.toggles.crits then
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "crit hack key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "Off" )
                      end
                else
                    y2 = y2 - 25
                end
        
                
        
        
                if menu.toggles.dtky then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "double tap key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "Off" )
                      end
        
                      
                else
                    y2 = y2 - 25  
                end
        
                if menu.toggles.rechrge then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "force recharge key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, dt_key_recharge )
                        
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, dt_key_recharge )
                  
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "Off" )
                      end
        
                      
                else
                    y2 = y2 - 25
                end
        
                if menu.toggles.thrdperson then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if gui.GetValue( "thirdperson" ) == 1 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, thirdperson_key  )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, thirdperson_key )
                  
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "Off" )
                      end
        
                      
                else
                    y2 = y2 - 25
                end
        
                if menu.toggles.fakeleg then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "fake lag" ) >= 1 and gui.GetValue( "fake lag key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, "none" )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    elseif gui.GetValue( "fake lag" ) >= 0 and gui.GetValue( "fake lag key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, "none" )
                  
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    elseif gui.GetValue( "fake lag" ) >= 1 and gui.GetValue( "fake lag key") >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, fakelag_key )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, fakelag_key )
                         
                        draw.Text( 25 + x1, 175 + y2, "Toggle" )
                        draw.Text( 270 + x1, 175 + y2, fakelagms )
                    end
                      
                else
                    y2 = y2 - 25
                end

                if menu.toggles.triggerbt then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "trigger key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, "always on" )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 200 + y2, "Toggle" )
                        draw.Text( 270 + x1, 200 + y2, "On" )
                    elseif gui.GetValue( "trigger key", trigger_key) and (input.IsButtonDown( gui.GetValue( "trigger key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, trigger_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 200 + y2, "Hold" )
                        draw.Text( 270 + x1, 200 + y2, "On" )
                    else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, trigger_key )
                  
                        draw.Text( 25 + x1, 200 + y2, "Hold" )
                        draw.Text( 270 + x1, 200 + y2, "Off" )
                    end

                      
                else
                    y2 = y2 - 25
                end

                if menu.toggles.triggersht then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "trigger shoot") == 1 and gui.GetValue( "trigger shoot key" ) == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, "none" )
                         
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 225 + y2, "Toggle" )
                        draw.Text( 270 + x1, 225 + y2, "On" )
                    elseif gui.GetValue( "trigger shoot") == 0 and gui.GetValue( "trigger shoot key" ) == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, "none" )
                         
                        draw.Text( 25 + x1, 225 + y2, "Toggle" )
                        draw.Text( 270 + x1, 225 + y2, "Off" )
                    elseif gui.GetValue( "trigger shoot") == 1 and gui.GetValue( "trigger shoot key" ) >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, triggershoot_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, 225 + y2, "Hold" )
                        draw.Text( 270 + x1, 225 + y2, "On" )
                    else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, triggershoot_key )
                  
                        draw.Text( 25 + x1, 225 + y2, "Hold" )
                        draw.Text( 270 + x1, 225 + y2, "Off" )
                    end

                      
                else
                    y2 = y2 - 25
                end

                if menu.toggles.werp then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "dash move key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Color( menu.colors.all, menu.colors.all2, menu.colors.all3, 255 )
                        draw.Text( 25 + x1, y2 + 250, "Toggle" )
                        draw.Text( 270 + x1, y2 + 250, "On" )
                      else
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Text( 25 + x1, y2 + 250, "Toggle" )
                        draw.Text( 270 + x1, y2 + 250, "Off" )
                      end
        
                      
                else
                    y2 = y2 - 25  
                end
            end
                

    end

    if menu.toggles.nitro_dt_bar then

        
        
        
        
            if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                return
            end


        
            if Lbox_Menu_Open == true then
                draw.Color( 255, 255, 255, 255 )
                draw.OutlinedRect( barX - 18, barY - 26, barX + barWidth + 22, barY + barHeight + 16 )

                local x, y = barX, barY
              local bW, bH = barWidth, barHeight
              local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
              
              if IsDragging3 then
                  if input.IsButtonDown(MOUSE_LEFT) then
                    barX = mX - math.floor(bW * menu.rX)
                    barY = mY - math.floor(15 * menu.rY)
                  else
                      IsDragging3 = false
                  end
              else
                  if IsMouseInBounds(x - 18, y - 25, x + bW + 18, y + bH + 15) then
                      if not input.IsButtonDown(MOUSE_LEFT) then
                          menu.rX = ((mX - x) / bW)
                          menu.rY = ((mY - y) / 15)
                      else
                        barX = mX - math.floor(bW * menu.rX)
                        barY = mY - math.floor(15 * menu.rY)
                          IsDragging3 = true
                      end
                  end
              end
            else
            end
            

            draw.Color(41, 42, 46, 255)
            RoundedRect(barX - 2, barY - 2, barX + barWidth + 2, barY + barHeight + 2, 4)

        
            if  charge ~= 0  then
                draw.Color( menu.colors.dtbarcolr, menu.colors.dtbarcolr2, menu.colors.dtbarcolr3, 255 )
                RoundedRect(barX, barY, barX + math.floor(charge * barWidth), barY + barHeight, 4)
            end
        
        
            draw.SetFont(nitrofont)
            local LocalWeapon = entities.GetLocalPlayer():GetPropEntity( "m_hActiveWeapon" )
            if (warp.CanDoubleTap(LocalWeapon)) and ((entities.GetLocalPlayer():GetPropInt( "m_fFlags" )) & FL_ONGROUND) == 1 and charge == 1 then
                --draw.Text( 1000, 500, warp.GetChargedTicks().."/23")
            else
                local state_text = "Not Ready";
                draw.Color(255, 255, 255, 255)
                
                local StateTextWidth, StateTextHeight = draw.GetTextSize(state_text);
        
                draw.Text( barX + barWidth - StateTextWidth - 23, barY - StateTextHeight - (-27), state_text)
            end
        
                draw.SetFont(nitrofont2)
                draw.Color( 255,255,255,255 )
                local ticks = "Ticks "..warp.GetChargedTicks().." / 23";
        
                local StateTextWidth, StateTextHeight = draw.GetTextSize(ticks);
        
                draw.Text( barX + barWidth - StateTextWidth - 18, barY - StateTextHeight - 2, ticks)
                

              
            
        
            

end
    


   

    ::continue::

    
end
callbacks.Register( "Draw", "awbtyngfuimhdj", NonMenuDraw )


-- pasted by boghonorojczyzna_



local t = globals.TickCount()
client.Command("clear", true)
local function OnLoad()
    local lines = {"loaded test lua"}
    local clr1 = {115, 119, 255}
    local clr2 = {224, 173, 199}
    if t < globals.TickCount() + 1 then
        for i = 1, #lines do
            local t = i / #lines
            local clr = {
                math.floor(clr1[1] + (clr2[1] - clr1[1]) * t),
                math.floor(clr1[2] + (clr2[2] - clr1[2]) * t),
                math.floor(clr1[3] + (clr2[3] - clr1[3]) * t)
            }
            printc(clr[1], clr[2], clr[3], 255, lines[i])
        end
        callbacks.Unregister( "CreateMove", "awjkudl9i0" )
    end
end
callbacks.Unregister( "CreateMove", "awjkudl9i0" )
callbacks.Register( "CreateMove", "awjkudl9i0", OnLoad )

callbacks.Register("CreateMove", function(cmd)
    updateBarCharge()
end)


table.insert(notifications, 1, {time = globals.CurTime(), text = "Loaded Lua!"})
