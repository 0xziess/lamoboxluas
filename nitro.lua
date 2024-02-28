local Menu = { -- the config table

    colors = { 
        -- Local = {},
        all = {194,83,83},
        keybinde = {41, 42, 46},
        dtber = {255, 134, 42},
    },

    tabs = { 
        main = true, 
        colors = false,
        keybinds = false,
        config = false,
    },

    main_tab = {
        keybinds = true,
        dtbar = true,
    },

    keybinde_tab = {
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

    colors_tab = {
        colors = {"ON Color", "Keybind Menu", "DT Bar"},
        selected_color = 1,
    }
}

------- STUFF TO LOAD THE BAR AND THE KEYBINDS




local title = draw.CreateFont( "Roboto Medium", 23, 500 )
local binds = draw.CreateFont( "Arial", 18, 1000 )




local textcolorwhenoff = {120, 120, 120, 250}

local nitrofont = draw.CreateFont('Verdana', 15, 1000, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)
local nitrofont2 = draw.CreateFont('Tahoma', 16, 1000, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE | FONTFLAG_ANTIALIAS)

local barWidth = 115 -- dont touch this
local barHeight = 9 -- change this to make the bar bigger
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

-- Draw a horizontal rectangle with rounded corners left and right
local function RoundedRectH(x1, y1, x2, y2)
    if not Style.Circles then
        draw.FilledRect(x1, y1, x2, y2)
        return
    end

    local r = (y2 - y1) // 2
    DrawCircle(x1 + r, y1 + r, r)
    DrawCircle(x2 - r, y1 + r, r)
    draw.FilledRect(x1 + r, y1, x2 - r, y2)
end




local menuLoaded, ImMenu = pcall(require, "ImMenu")
assert(menuLoaded, "ImMenu not found, please install it!")
assert(ImMenu.GetVersion() >= 0.66, "ImMenu version is too old, please update it!")

local lastToggleTime = 0
local Lbox_Menu_Open = true
local function toggleMenu()
    local currentTime = globals.RealTime()
    if currentTime - lastToggleTime >= 0.1 then
        if Lbox_Menu_Open == false then
            Lbox_Menu_Open = true
        elseif Lbox_Menu_Open == true then
            Lbox_Menu_Open = false
        end
        lastToggleTime = currentTime
    end
end

local s_width, s_height = draw.GetScreenSize()

local function ColorCalculator(index) -- best name
    local colors = {
        [1] = Menu.colors.all,
        [2] = Menu.colors.keybinde,
        [3] = Menu.colors.dtber,
    }
    return colors[index]
end



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
        printc( 255, 183, 0, 255, "["..os.date("%H:%M:%S").."] Saved to ".. tostring(fullPath))
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
            printc( 0, 255, 140, 255, "["..os.date("%H:%M:%S").."] Loaded from ".. tostring(fullPath))
            return chunk()
        else
            print("Error loading configuration:", err)
        end
    end
end

local screenX, screenY = draw.GetScreenSize()
local barX = math.floor(screenX / 2 - barWidth / 2)
local barY = math.floor(screenY / 2) + barOffset
local x1, y1, width, height = 50, 980, 310, 260
local moving = false
local moving1 = false
callbacks.Register( "Draw", "NITRO CUSTOMIZABLE", function()

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
    
    if input.IsButtonPressed( KEY_END ) or input.IsButtonPressed( KEY_INSERT ) or input.IsButtonPressed( KEY_F11 ) then 
        toggleMenu() 
    end

    if Lbox_Menu_Open == true and ImMenu.Begin("Customizable Nitro Thing", true) then -- managing the menu

        ImMenu.BeginFrame(1) -- tabs

        if ImMenu.Button("Main") then
            Menu.tabs.main = true
            Menu.tabs.colors = false
            Menu.tabs.keybinds = false
            Menu.tabs.config = false
        end

        if ImMenu.Button("Colors") then
            Menu.tabs.main = false
            Menu.tabs.colors = true
            Menu.tabs.keybinds = false
            Menu.tabs.config = false
        end

        if ImMenu.Button("Keybinds") then
            Menu.tabs.main = false
            Menu.tabs.colors = false
            Menu.tabs.keybinds = true
            Menu.tabs.config = false
        end

        if ImMenu.Button("Config") then
            Menu.tabs.main = false
            Menu.tabs.colors = false
            Menu.tabs.keybinds = false
            Menu.tabs.config = true
        end

        ImMenu.EndFrame()


        if Menu.tabs.main then 

            ImMenu.BeginFrame(1)
            Menu.main_tab.keybinds =  ImMenu.Checkbox("Keybinds", Menu.main_tab.keybinds)
            Menu.main_tab.dtbar =  ImMenu.Checkbox("DT Bar", Menu.main_tab.dtbar)
            ImMenu.EndFrame()

        end

      

        if Menu.tabs.colors then

            ImMenu.BeginFrame(1)
            ImMenu.Text("Selected Part")
            Menu.colors_tab.selected_color = ImMenu.Option(Menu.colors_tab.selected_color, Menu.colors_tab.colors)
            ImMenu.EndFrame()

            ImMenu.BeginFrame(1)
            ColorCalculator(Menu.colors_tab.selected_color)[1] = ImMenu.Slider("Red", ColorCalculator(Menu.colors_tab.selected_color)[1] , 0, 255)
            ImMenu.EndFrame()
            ImMenu.BeginFrame(1)
            ColorCalculator(Menu.colors_tab.selected_color)[2] = ImMenu.Slider("Green", ColorCalculator(Menu.colors_tab.selected_color)[2] , 0, 255)
            ImMenu.EndFrame()
            ImMenu.BeginFrame(1)
            ColorCalculator(Menu.colors_tab.selected_color)[3] = ImMenu.Slider("Blue", ColorCalculator(Menu.colors_tab.selected_color)[3] , 0, 255)
            ImMenu.EndFrame()
        end

        if Menu.tabs.keybinds then 

            ImMenu.BeginFrame(1)
            Menu.keybinde_tab.aimbot =  ImMenu.Checkbox("Aimbot", Menu.keybinde_tab.aimbot)
            Menu.keybinde_tab.crits =  ImMenu.Checkbox("Crits", Menu.keybinde_tab.crits)
            Menu.keybinde_tab.dtky =  ImMenu.Checkbox("DT", Menu.keybinde_tab.dtky)
            ImMenu.EndFrame()

            ImMenu.BeginFrame(1)
            Menu.keybinde_tab.rechrge =  ImMenu.Checkbox("Recharge DT", Menu.keybinde_tab.rechrge)
            Menu.keybinde_tab.thrdperson =  ImMenu.Checkbox("Thirdperson", Menu.keybinde_tab.thrdperson)
            Menu.keybinde_tab.fakeleg =  ImMenu.Checkbox("Fake Lag", Menu.keybinde_tab.fakeleg)
            ImMenu.EndFrame()

            ImMenu.BeginFrame(1)
            Menu.keybinde_tab.triggerbt =  ImMenu.Checkbox("Trigger Bot", Menu.keybinde_tab.triggerbt)
            Menu.keybinde_tab.triggersht =  ImMenu.Checkbox("Trigger Shoot", Menu.keybinde_tab.triggersht)
            ImMenu.EndFrame()

        end

        if Menu.tabs.config then 
            ImMenu.BeginFrame(1)
            if ImMenu.Button("Create/Save CFG") then
                CreateCFG( [[nitro custom]] , Menu )
            end

            if ImMenu.Button("Load CFG") then
                Menu = LoadCFG( [[nitro custom]] )
            end

            ImMenu.EndFrame()

            ImMenu.BeginFrame(1)
            ImMenu.Text("Dont load a config if you havent saved one.")
            ImMenu.EndFrame()
        end

        ImMenu.End()
    end

    

    

local customcolor = nil
local end_bar_color = nil
local dtbarcolr = nil

customcolor = Menu.colors.all -- ui color
end_bar_color = Menu.colors.keybinde -- transparent bar
dtbarcolr = Menu.colors.dtber

local keybindHeight = height



        if Menu.keybinde_tab.aimbot == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.keybinde_tab.crits == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.keybinde_tab.dtky == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.keybinde_tab.rechrge == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.keybinde_tab.thrdperson == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.keybinde_tab.fakeleg == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.keybinde_tab.triggerbt == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.keybinde_tab.triggersht == false then
            keybindHeight = keybindHeight - 25
        end

        if Menu.main_tab.keybinds then 

        local function drawBox()
            if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                return
              end
              if Lbox_Menu_Open == true then
                draw.Color( 255, 255, 255, 255 )
                draw.OutlinedRect( posX - 12, posY - 12, posX + width + 12, posY + keybindHeight + 12 )
            else
            end
            
    
              local uitransparency1 = Menu.main_tab.uitransparency

            
                draw.SetFont(title)
                draw.Color( end_bar_color[1], end_bar_color[2], end_bar_color[3], 255 )
                RoundedRect(posX, posY, posX + width, posY + keybindHeight, 6)
            
                draw.Color( 255, 255, 255, 255 )
                draw.Text( 20 + posX, 10 + posY, "Binds" )
                
                draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
                RoundedRect(posX + 15, posY + 35, posX + width - 10, posY + 210 - 172, 0)
            
                draw.SetFont(binds)

                if Menu.keybinde_tab.aimbot then

            
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
        
                    
                    
                    
                    if (input.IsButtonDown( gui.GetValue("Aim key") )) and (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 then
                      draw.Color( 200, 200, 200, 250 )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
                      draw.Text( 25 + x1, y2 + 50, "Hold" )
                      draw.Text( 270 + x1, y2 + 50, "On" )
                
                    elseif (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 1 then
                      draw.Color( 200, 200, 200, 250 )
                      draw.Text( 85 + x1, y2 + 50, "aimbot")
                      draw.Text( 185 + x1, y2 + 50, aimbot_key )
                
                      draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
                    y2 = y2 - 25
                end
        
                if Menu.keybinde_tab.crits then
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "crit hack key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
        
                
        
        
                if Menu.keybinde_tab.dtky then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "double tap key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
        
                if Menu.keybinde_tab.rechrge then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "force recharge key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, dt_key_recharge )
                        
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
        
                if Menu.keybinde_tab.thrdperson then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if gui.GetValue( "thirdperson" ) == 1 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, thirdperson_key  )
                  
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
        
                if Menu.keybinde_tab.fakeleg then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "fake lag" ) >= 1 and gui.GetValue( "fake lag key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 175 + y2, "fake lag" )
                        draw.Text( 185 + x1, 175 + y2, "none" )
                         
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
                         
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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

                if Menu.keybinde_tab.triggerbt then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "trigger key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, "always on" )
                         
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
                        draw.Text( 25 + x1, 200 + y2, "Toggle" )
                        draw.Text( 270 + x1, 200 + y2, "On" )
                    elseif gui.GetValue( "trigger key", trigger_key) and (input.IsButtonDown( gui.GetValue( "trigger key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, trigger_key )
                  
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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

                if Menu.keybinde_tab.triggersht then
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    local keystatetext = "none";
                    
                    if gui.GetValue( "trigger shoot") == 1 and gui.GetValue( "trigger shoot key" ) == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 225 + y2, "trigger shoot" )
                        draw.Text( 185 + x1, 225 + y2, "none" )
                         
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
                  
                        draw.Color( customcolor[1], customcolor[2], customcolor[3], 255 )
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
            
        end
            gui.SetValue( "double tap indicator size", 0 )
            
            if Lbox_Menu_Open == true then

                if (input.IsButtonDown(MOUSE_LEFT)) then
                    if not moving then
                      local height,width = draw.GetScreenSize()
                      local tmpX = input.GetMousePos()[1] - 100
                      local tmpY = input.GetMousePos()[2] - 10
              
                      local rangeX = tmpX - x1
                      local rangeY = tmpY - y1 
                      
              
                      if (rangeX >= -100) and (rangeX <= 200) and (rangeY >= -10) and (rangeY <= 10) then
                        moving = true
                      end
              
                      
                    end
                  end
              
                  if (not input.IsButtonDown(MOUSE_LEFT)) then
                    moving = false
                  end
              
                  if (moving) then
                    local height,width = draw.GetScreenSize()
                    local tmpX = input.GetMousePos()[1] - 155
                    local tmpY = input.GetMousePos()[2] - 20
                    
                    if (tmpX <= (height - 1)) and (tmpY <= (width - 1)) and (tmpX >= 1) and (tmpY >= 1) then
                      x1 = tmpX
                      y1 = tmpY
                    end
                  end

            end
            
              

            drawBox()
            
           
        end

        

        

       

        if Menu.main_tab.dtbar then

            local CWindow = {
                Visible = true,
                Pos = { 50, 50 },
                Size = { 400, 250 },
                Title = "",
            }
            CWindow.__index = CWindow
            
            -- Create a new window
            function CWindow.new(pos, size, title)
                local self = setmetatable({}, CWindow)
                self.Visible = true
                self.Pos = pos
                self.Size = size
                self.Title = title
            
                return self
            end
            
            
            function CWindow:Draw()
                if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                    return
                end
            
                if Lbox_Menu_Open == true then
                    draw.Color( 255, 255, 255, 255 )
                    draw.OutlinedRect( barX - 18, barY - 26, barX + barWidth + 22, barY + barHeight + 16 )
                else
                end
                

                draw.Color(41, 42, 46, 255)
                RoundedRect(barX - 2, barY - 2, barX + barWidth + 2, barY + barHeight + 2, 4)

            
                if  charge ~= 0  then
                    draw.Color( dtbarcolr[1], dtbarcolr[2], dtbarcolr[3], 255 )
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
            
                    draw.Text( barX + barWidth - StateTextWidth - 22, barY - StateTextHeight - (-27), state_text)
                end
            
                    draw.SetFont(nitrofont2)
                    draw.Color( 255,255,255,255 )
                    local ticks = "Ticks "..warp.GetChargedTicks().." / 23";
            
                    local StateTextWidth, StateTextHeight = draw.GetTextSize(ticks);
            
                    draw.Text( barX + barWidth - StateTextWidth - 20, barY - StateTextHeight - 2, ticks)
                    

                  
                
            end
            ----------------------------------------------------------------------------------------------------------
            if Lbox_Menu_Open == true then

                if (input.IsButtonDown(MOUSE_LEFT)) then
                    if not moving1 then
                      local height,width = draw.GetScreenSize()
                      local tmpX1 = input.GetMousePos()[1]
                      local tmpY1 = input.GetMousePos()[2]
              
                      local rangeX = tmpX1 - barX
                      local rangeY = tmpY1 - barY 
              
                      if (rangeX >= -1) and (rangeX <= 50) and (rangeY >= -20) and (rangeY <= 20) then
                        moving1 = true
                      end
              
                      
                    end
                  end
              
                  if (not input.IsButtonDown(MOUSE_LEFT)) then
                    moving1 = false
                  end
              
                  if (moving1) then
                    local height,width = draw.GetScreenSize()
                    local tmpX1 = input.GetMousePos()[1] - 65
                    local tmpY1 = input.GetMousePos()[2] - 20
                    
                    if (tmpX1 <= (height - 1)) and (tmpY1 <= (width - 1)) and (tmpX1 >= 1) and (tmpY1 >= 1) then
                      barX = tmpX1
                      barY = tmpY1
                    end
                  end

            end

            
            local window = CWindow.new({ 450, 120 }, { 100, 15 }, " ")
            window:Draw()
        end

end)





callbacks.Register( "Unload", function() 
    local entities = entities.FindByClass( "CBaseAnimating" )
    for i, entity in pairs(entities) do 
        entity:SetPropFloat( 1, "m_flPlaybackRate" )
    end
end)

callbacks.Register("CreateMove", function(cmd)
    updateBarCharge()
end)

