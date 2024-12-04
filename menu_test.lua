--[[
creds to muqa for this cool menu and functions [https://github.com/Muqa1/Muqa-LBOX-pastas/blob/main/Release%20misc%20tools.lua]
creds to LNX for the rounded corners from this menu [https://github.com/lnx00/Lmaobox-Lua/blob/main/src/PoC/WinUI.lua]
creds to 11x1 for the colorpicker from his amazing espbuilder lua [https://github.com/11x1/Lua/blob/main/Lmaobox.net/espbuilder/espbuilder.lua]
creds to PiantaMK for the dropdowns [https://github.com/PiantaMK/lmaobox-luas/blob/main/PMLib/MenuModules/Dropdowns.lua]
]]
local menu = {
    w = 500,
    h = 550,
    rX = 0,
    rY = 0,
    menuBGColor = {25, 25, 25, 255},
    -- tabs = {tab_1 = true, tab_3 = false, tab_4 = false},
    buttons = {esp = false, misc = false, antiaim = false, indicators = false, reset = false, cfg_load = false, cfg_save = false},
    toggles = {
        chams = false, 
        chams1 = false, 
        chams2 = false, 

        team_based = true, 
        enemy_based = false, 

        enemy_only = true, 

        local_player = true, 
        fake_ang = true,

        team_based_esp = true, 
        enemy_based_esp = false, 

        enemy_only_esp = true, 

        esp_color = true,

        keybinde_menu = false,
        nitro_dt_bar = false,
        ateris_dt_bar = false,
        monkey_dt_bar = false,
        rijin_dt_bar = false,
        
        dyn_switch = false, 
        antieim = true,

        rage_aa = false,
        legit_aa = false, 

        aa_dynrotril = false,
        aa_rotril = false,
        aa_spinril = false,

        aa_dynrotfek = false,
        aa_rotfek = false,
        aa_spinfek = false,

        invert1 = false,
        invert2 = false,

        autoload = false,

        nightmode = false,

        view_model = true,

        auto_rocket_jump = false,
        auto_detonate = false,
        preventDetonationlocalPlayer = true,
    },
    misc = { 
        aspectrat = 0.0,
        wepnswyinterp = 1,
        wepnswyscale = 0,

        xwpn = 0,
        ywpn = 0,
        zwpn = 0,

        cam_x = 0,
        cam_y = 0,
        cam_z = 150,

        nightmode_scale = 0,
        backtrack_scale = 0,

        detonate_radius = 100,
        minStickies = 1,
    },
    antiaim = {
        aadelay = 1,

        aafek1 = 0,
        aafek2 = 0,

        aaril = 0,
        aafek = 0,
        aaspinril = 1,
        aaspinfek = 1,

        aaril1 = 0,
        aaril2 = 0,

        aaligit = 1,
    },
    keybinds = {
        rocket_jump = nil,
        rocket_jump_keybind_name = "none",
        rocket_jump_waiting_for_input = false,
    },
    Values = {
        menuclr = {90, 120, 204, 255},
        red_team = {235, 25, 0, 255},
        red_team_invisible = {255, 50, 0, 255},
        blue_team = {0, 25, 235, 255},
        blue_team_invisible = {0, 50, 255, 255},
        enemy_team = {255, 0, 0, 255},
        enemy_team_invisible = {215, 25, 25, 255},
        friendly_team = {0, 255, 0, 255},
        friendly_team_invisible = {25, 215, 25, 255},
        red_team_chams = {255, 0, 0, 255},
        blue_team_chams = {0, 0, 255, 255},
        red_team_tint = {255, 255, 255, 255},
        blue_team_tint = {255, 255, 255, 255},
        enemy_based_chams = {255, 0, 0, 255},
        enemy_based_chams_tint = {255, 255, 255, 255},
        friendly_chams = {255, 0, 0, 255},
        friendly_chams_tint = {255, 255, 255, 255},
        localplr_chams = {255, 0, 0, 255},
        localplr_chams_tint = {255, 255, 255, 255},
        night_mode = {255, 255, 255, 255},
        back_track = {255, 255, 255, 255},

        rjn_left = {1, 25, 31, 255, 255},
        rjn_right = {67, 213, 250, 255},
        rjn_outline = {255, 255, 255, 255},
    },
    Dropdowns = {
        DropdownVar = 1,
        DropdownMultiVar = {false, true, false},
        chamsOptions = { "none", "fresnel", "shaded", "shiny", "flat", "glow" },
        skyboxOptions = { "none", "sky_night_01", "sky_nightfall_01", "sky_harvest_night_01", "sky_hydro_01", "sky_well_01", "sky_rainbow_01", "sky_alpinestorm_01" },
        cfgOptions = { "Default", "Config 2", "Config 3" },
        anotherDropdownVar = 1,
        secondDropdownVar = 1,
        skyboxDropdownVar = 1,
        localDropdownVar = 1,
        fakeDropdownVar = 1,
        cfgDropdownVar = 1,
    }
}

local atosave = {
    Dropdowns = {
        cfgOptions = { "Default", "Config 2", "Config 3" },
        cfgDropdownVar = 1,
    }
}

local is_colorpicker_open = false

local nosave = {x = 500, y = 500}
local teb = {
    tabs = {tab_1 = true, tab_2 = false, tab_3 = false, tab_4 = false, tab_5 = false},
}

local f = math.floor

local HasDropdowns,Dropdowns = pcall(require, "MenuModules/Dropdowns")
local function unrequire(m) package.loaded[m] = nil _G[m] = nil end
if (not(HasDropdowns)) then client.ChatPrintf("\x07FF0000Dropdowns module failed to load!");engine.PlaySound("common/bugreporter_failed.wav") return end

collectgarbage("collect")

engine.PlaySound("hl1/fvox/activated.wav")

local function OnUnload() 
    unrequire("MenuModules/Dropdowns")
    Dropdown_open = false
    is_colorpicker_open = false
    client.SetConVar( "tf_viewmodels_offset_override", 0 .. " " .. 0 .. " " .. 0 )
    client.SetConVar( "cl_wpn_sway_interp", 0.0 )
    client.SetConVar( "cl_wpn_sway_scale", 0.0 )
    client.SetConVar( "r_aspectratio", 0.0 )
    --[[
    client.SetConVar( "cam_idealdist", 150 .. " ")
    client.SetConVar( "cam_idealdistright", 0 .. " ")
    client.SetConVar( "cam_idealdistup", 0 .. " ")
    client.Command( "firstperson", true )
    ]]
    engine.PlaySound("hl1/fvox/deactivated.wav")
end

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


local gradientBarMask = (function()
    local chars = {}
    for i = 0, 255 do
        local p = #chars
        chars[p + 1], chars[p + 1025] = 255, 255
        chars[p + 2], chars[p + 1026] = 255, 255
        chars[p + 3], chars[p + 1027] = 255, 255
        chars[p + 4], chars[p + 1028] = i, i
    end
    return draw.CreateTextureRGBA(string.char(table.unpack(chars)), 256, 2)
end)()

local function drawRectOutline(x, y, width, height, color, thickness)
    draw.Color(color[1], color[2], color[3], color[4])
    for i = 0, thickness - 1 do
        draw.Line(x - i, y - i, x + width + i, y - i)
        draw.Line(x - i, y - i, x - i, y + height + i)
        draw.Line(x - i, y + height + i, x + width + i, y + height + i)
        draw.Line(x + width + i, y - i, x + width + i, y + height + i)
    end
end

local function a(x)
    if x >= 180 then
        x = -180
    elseif x <= -180 then
        x = 180
    end
    return x
end

local function createCustomGradientBarMask(colorTop, colorMiddle, colorBottom)
    local chars = {}

    for i = 0, 255 do
        local ratio = i / 255
        local r, g, b

        if ratio < 0.5 then
            r = math.floor((1 - 2 * ratio) * colorTop[1] + 2 * ratio * colorMiddle[1])
            g = math.floor((1 - 2 * ratio) * colorTop[2] + 2 * ratio * colorMiddle[2])
            b = math.floor((1 - 2 * ratio) * colorTop[3] + 2 * ratio * colorMiddle[3])
        else
            r = math.floor((1 - 2 * (ratio - 0.5)) * colorMiddle[1] + 2 * (ratio - 0.5) * colorBottom[1])
            g = math.floor((1 - 2 * (ratio - 0.5)) * colorMiddle[2] + 2 * (ratio - 0.5) * colorBottom[2])
            b = math.floor((1 - 2 * (ratio - 0.5)) * colorMiddle[3] + 2 * (ratio - 0.5) * colorBottom[3])
        end

        chars[i * 4 + 1] = r
        chars[i * 4 + 2] = g
        chars[i * 4 + 3] = b
        chars[i * 4 + 4] = 255
    end

    return draw.CreateTextureRGBA(string.char(table.unpack(chars)), 1, 256)
end

function lerp(a, b, t)
    return a + (b - a) * t
end

function easeOutQuad(t)
    return 1 - (1 - t) ^ 2
end

--[COLORPICKER START]--

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]

local vector = { }
local vector_mt = { }

function vector_mt.__add( self, vec2 )
    if type( vec2 ) == "number" then
        return vector.new( self.x + vec2, self.y + vec2, self.z + vec2 )
    end

    return vector.new( self.x + vec2.x, self.y + vec2.y, self.z + vec2.z )
end

function vector_mt.__sub( self, vec2 )
    return vector_mt.__add( self, vec2 * -1 )
end

function vector_mt.__mul( self, vec2 )
    if type( vec2 ) == "number" then
        return vector.new( self.x * vec2, self.y * vec2, self.z * vec2 )
    end

    return vector.new( self.x * vec2.x, self.y * vec2.y, self.z * vec2.z )
end

function vector_mt.__div( self, vec2 )
    if type( vec2 ) == "number" then
        return vector.new( self.x / vec2, self.y / vec2, self.z / vec2 )
    end

    return vector.new( self.x / vec2.x, self.y / vec2.y, self.z / vec2.z )
end

function vector_mt.__unm( self )
    return self * -1
end

function vector_mt.__eq( self, vec2 )
    if type( vec2 ) ~= "table" then
        return false
    end

    return self.x == vec2.x and self.y == vec2.y and self.z == vec2.z
end

function vector_mt.__len( self )
    return math.sqrt( self.x ^ 2 + self.y ^ 2 + self.z ^ 2 )
end

function vector_mt.__tostring( self )
    return ( 'vector( %.2f, %.2f, %.2f )' ):format( self.x, self.y, self.z )
end

function vector_mt.unpack( self )
    return self.x, self.y, self.z
end

function vector.new( x, y, z )
    local vx, vy, vz = x, y, z

    if x == nil then
        vx, vy, vz = 0, 0, 0
    end

    if vy == nil then
        vy = x
        vz = x
    end

    if vz == nil then
        vz = 0
    end

    local new_vec = {
        x = vx,
        y = vy,
        z = vz,
        unpack = vector_mt.unpack
    }

    setmetatable( new_vec, vector_mt )

    return new_vec
end

setmetatable( vector, {
    __call = function( self, ... )
        return vector.new( ... )
    end
} )


local color = { }
local color_mt = { }

local function parse_hex_string( hex_string )
    if #hex_string == 6 then
        hex_string = hex_string .. 'FF'
    end

    hex_string = hex_string:gsub( '#', '' )

    local to_return = { }
    for i = 1, 8, 2 do
        table.insert(
            to_return,
            tonumber( ( '0x%s' ):format( hex_string:sub( i, i + 1 ) ) )
        )
    end

    return table.unpack( to_return )
end

function color_mt.unpack( self )
    return math.floor( self.r ), math.floor( self.g ), math.floor( self.b ), math.floor( self.a )
end

function color.new( r, g, b, a )
    if type( r ) == "string" then
        r, g, b, a = parse_hex_string( r )
    end

    if g == nil then
        g, b = r, r
        a = 255
    end

    if b == nil then
        a = g
        g, b = r, r
    end

    if a == nil then
        a = 255
    end

    local new_color = {
        r = r, g = g, b = b, a = a,
        unpack = color_mt.unpack
    }

    return new_color
end

setmetatable( color, {
    __call = function( self, ... )
        return color.new( ... )
    end
} )

function color.hue_to_rgb( hue_degrees )
    local hue = hue_degrees / 360

    local r, g, b = 0, 0, 0

    if hue < 1 / 6 then
        r = 1
        g = hue * 6
    elseif hue < 2 / 6 then
        r = 1 - ( hue - 1 / 6 ) * 6
        g = 1
    elseif hue < 3 / 6 then
        g = 1
        b = ( hue - 2 / 6 ) * 6
    elseif hue < 4 / 6 then
        g = 1 - ( hue - 3 / 6 ) * 6
        b = 1
    elseif hue < 5 / 6 then
        r = ( hue - 4 / 6 ) * 6
        b = 1
    else
        r = 1
        b = 1 - ( hue - 5 / 6 ) * 6
    end

    return color( math.floor( r * 255 ), math.floor( g * 255 ), math.floor( b * 255 ) )
end

function color.hsb_to_rgb( h, s, b )
    local rgb = { r = 0, g = 0, b = 0 }

    if s == 0 then
        rgb.r = b * 255
        rgb.g = b * 255
        rgb.b = b * 255
    else
        local hue = ( h == 360 ) and 0 or h

        local sector = math.floor( hue / 60 )
        local sector_pos = ( hue / 60 ) - sector

        local p = b * ( 1 - s )
        local q = b * ( 1 - s * sector_pos )
        local t = b * ( 1 - s * ( 1 - sector_pos ) )

        if sector == 0 then
            rgb.r = b * 255
            rgb.g = t * 255
            rgb.b = p * 255
        elseif sector == 1 then
            rgb.r = q * 255
            rgb.g = b * 255
            rgb.b = p * 255
        elseif sector == 2 then
            rgb.r = p * 255
            rgb.g = b * 255
            rgb.b = t * 255
        elseif sector == 3 then
            rgb.r = p * 255
            rgb.g = q * 255
            rgb.b = b * 255
        elseif sector == 4 then
            rgb.r = t * 255
            rgb.g = p * 255
            rgb.b = b * 255
        elseif sector == 5 then
            rgb.r = b * 255
            rgb.g = p * 255
            rgb.b = q * 255
        end
    end

    return color(
        math.floor( rgb.r ),
        math.floor( rgb.g ),
        math.floor( rgb.b )
    )
end

function color.rgb_to_hsb( color_obj )
    local hue, saturation, brightness = 0, 0, 0

    local r = color_obj.r / 255
    local g = color_obj.g / 255
    local b = color_obj.b / 255

    local max = math.max( r, g, b )
    local min = math.min( r, g, b )

    brightness = max

    if max == 0 then
        saturation = 0
    else
        saturation = ( max - min ) / max
    end

    if max == min then
        hue = 0
    else
        local delta = max - min

        if max == r then
            hue = ( g - b ) / delta
        elseif max == g then
            hue = 2 + ( b - r ) / delta
        elseif max == b then
            hue = 4 + ( r - g ) / delta
        end

        hue = hue * 60

        if hue < 0 then
            hue = hue + 360
        end
    end

    return hue, saturation, brightness
end


local renderer = {
    fontflags = {
        [ 'i' ] = FONTFLAG_ITALIC, -- italic
        [ 'u' ] = FONTFLAG_UNDERLINE, -- underline
        [ 's' ] = FONTFLAG_STRIKEOUT, -- strikeout
        [ 'a' ] = FONTFLAG_ANTIALIAS, -- antialiasing
        [ 'b' ] = FONTFLAG_GAUSSIANBLUR, -- gaussianblur
        [ 'd' ] = FONTFLAG_DROPSHADOW, -- shadow
        [ 'o' ] = FONTFLAG_OUTLINE, -- outline
    }
}

function renderer.line( s, e, c )
    draw.Color( c:unpack( ) )
    draw.Line( s.x, s.y, e.x, e.y )
end

function renderer.line3d( s, e, c )
    local screen_pos1 = client.WorldToScreen( Vector3( s.x, s.y, s.z ) )
    local screen_pos2 = client.WorldToScreen( Vector3( e.x, e.y, e.z ) )

    if screen_pos1 and screen_pos2 then
        renderer.line(
            vector( screen_pos1[ 1 ], screen_pos1[ 2 ] ),
            vector( screen_pos2[ 1 ], screen_pos2[ 2 ] ),
            c
        )
    end
end

function renderer.rect( s, sz, c )
    draw.Color( c:unpack( ) )
    draw.OutlinedRect( s.x, s.y, s.x + sz.x, s.y + sz.y )
end

function renderer.rect_filled( s, sz, c )
    draw.Color( c:unpack( ) )
    draw.FilledRect( s.x, s.y, s.x + sz.x, s.y + sz.y )
end

function renderer.rect_fade_single_color( s, sz, c1, a1, a2, horiz )
    if horiz == nil then
        horiz = false
    end

    draw.Color( c1:unpack( ) )
    draw.FilledRectFade( s.x, s.y, s.x + sz.x, s.y + sz.y, a1, a2, horiz )
end

function renderer.rect_fade( s, sz, c1, c2, horiz )
    if horiz == nil then
        horiz = false
    end

    draw.Color( c1:unpack( ) )
    local a1 = c1.a
    draw.FilledRectFade( s.x, s.y, s.x + sz.x, s.y + sz.y, a1, 0, horiz )

    draw.Color( c2:unpack( ) )
    local a2 = c2.a
    draw.FilledRectFade( s.x, s.y, s.x + sz.x, s.y + sz.y, 10, a2, horiz )
end

function renderer.textured_rect( s, sz, texture )
    draw.Color(255, 255, 255, 255);
    draw.TexturedRect( texture, s.x, s.y, s.x + sz.x, s.y + sz.y )
end

function renderer.circle( s, r, c, p )
    if p == nil then
        p = 60
    end

    draw.Color( c:unpack( ) )
    draw.OutlinedCircle( s.x, s.y, r, p )
end

function renderer.circle_filled( s, r, c, p )
    if p == nil then
        p = 60
    end

    draw.Color( c:unpack( ) )
    draw.OutlinedCircle( s.x, s.y, r, p )
end

function renderer.text( pos, col, text )
    draw.Color( col:unpack( ) )
    draw.Text( pos.x, pos.y, text )
end

function renderer.measure_text( text )
    return vector( draw.GetTextSize( text ) )
end

function renderer.create_font( fontname, sz_in_px, weight, flags_str )

    local flags = flags_str == nil and FONTFLAG_CUSTOM | FONTFLAG_ANTIALIAS or flags_str == '' and FONTFLAG_NONE or FONTFLAG_CUSTOM

    if flags_str ~= nil then
        local letter = ''
        for i = 1, #flags_str do
            letter = string.sub( flags_str, i, i )

            if renderer.fontflags[ letter ] then
                flags = flags | renderer.fontflags[ letter ]
            end
        end
    end

    return draw.CreateFont( fontname, sz_in_px, weight, flags )
end

function renderer.use_font( font )
    draw.SetFont( font )
end

local lbox_localised_input = input
local custom_input = { keys = { } }
local function new_keypress_data( )
    return {
        last_state = false,
        pressed = false
    }
end

function custom_input.is_key_down( key )
    return lbox_localised_input.IsButtonDown( key )
end

function custom_input.get_mouse_pos( )
    return lbox_localised_input.GetMousePos( )
end

function custom_input.get_poll_tick( )
    return lbox_localised_input.GetPollTick( )
end

function custom_input.is_button_pressed( key )
    if not custom_input.keys[ key ] then
        custom_input.keys[ key ] = new_keypress_data( )
    end

    local keydata = custom_input.keys[ key ]

    return keydata.pressed
end

function custom_input.update_keys( )
    for key in pairs( custom_input.keys ) do
        local keydata = custom_input.keys[ key ]
        local is_key_down = custom_input.is_key_down( key )

        if is_key_down and not keydata.last_state then
            keydata.pressed = true
        else
            keydata.pressed = false
        end

        keydata.last_state = is_key_down
    end
end

local function is_in_bounds( pos, sz, pos_to_find_in )
    local mouse = custom_input.get_mouse_pos( )
    local x, y = table.unpack( mouse )

    if pos_to_find_in then
        x, y = pos_to_find_in.x, pos_to_find_in.y
    end

    return x >= pos.x and y >= pos.y and x <= pos.x + sz.x and y <= pos.y + sz.y
end

local preview_text_font = renderer.create_font( 'Smallest Pixel-7', 10, 0, 'obd' )

local options_menu = { }
local options_menus = { }

local open_menu = nil
local open_menu_pos = nil

local option_height = 20
local option_pad = 5

local allow_passthrough_id = nil
local skip_handle = false

local options = { }

local option_id_iterator = 0
local function gen_option_id( )
    option_id_iterator = option_id_iterator + 1
    return tostring( option_id_iterator )
end

local zero_opacity_bg = ( function( )
    local texture = {
        0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
        1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
        0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
        1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
    
    }
    
    local colors = {
        '\xDD\xDD\xDD\xFF',
        '\x88\x88\x88\xFF'
    }
    
    local texture_data = { }
    
    for i = 1, #texture do
        local val = texture[ i ]
    
        table.insert( texture_data, colors[ val + 1 ] )
    end
    
    local color_data = table.concat( texture_data, '' )
    local texture_obj = draw.CreateTextureRGBA( color_data, 16, 4 )
    
    callbacks.Register( "Unload", function( )
        draw.DeleteTexture( texture_obj )
    end )

    return texture_obj
end )( )

local function render_color_head( pos, size )
    renderer.rect_filled(
        pos,
        size,
        color( 255 )
    )

    renderer.rect(
        pos,
        size,
        color( 0 )
    )
end

local function clamp( v, min, max )
    return math.min( max, math.max( min, v ) )
end 

local function a(x)
    if x >= 180 then
        x = -180
    elseif x <= -180 then
        x = 180
    end
    return x
end

function options.new_colorpicker(name, default_color, x, y)
    renderer.use_font( preview_text_font )
    local colorpicker = { }

    colorpicker.id = gen_option_id( )

    colorpicker.name = name
    colorpicker.color = default_color

    colorpicker.open = false
    colorpicker.in_colorpicker = false

    colorpicker.name_size = renderer.measure_text( colorpicker.name )

    colorpicker.size = vector( 0, option_pad + colorpicker.name_size.y + option_pad )
    colorpicker.head_size =  vector( option_height - option_pad + 10, (option_height - option_pad))

    colorpicker.visible = true

    colorpicker.hovered = false

    colorpicker.picker = {
        gap = vector( 4 ),
        big = vector( 80, 80 ),
        hue = vector( 16, 80 ),
        opacity = vector( 80 + 16 + 4, 16 )
    }

    colorpicker.picker.total = colorpicker.picker.big + vector( colorpicker.picker.hue.x, colorpicker.picker.opacity.y ) + colorpicker.picker.gap * 3 -- left right middle, top middle bottom

    colorpicker.changing = {
        big = false,
        hue = false,
        opacity = false
    }

    local h, s, b = color.rgb_to_hsb( colorpicker.color )

    colorpicker.values = {
        big = vector( s, 1 - b ),
        hue = h / 360,
        opacity = colorpicker.color.a
    }

    colorpicker.areas = {
        hue = h,
        saturation = s,
        brightness = b,
    }

    function colorpicker:get_config( )
        local config = { self.color:unpack() }
        return config
    end

    function colorpicker:set_config( config_value )
         if config_value and #config_value == 4 then
        self.color = color(config_value[1], config_value[2], config_value[3], config_value[4])

        local h, s, b = color.rgb_to_hsb(self.color)

        self.values = {
            big = vector(s, 1 - b),
            hue = h / 360,
            opacity = colorpicker.color.a
        }

        self.areas = {
            hue = h,
            saturation = s,
            brightness = b,
        }
    end
    end

    function colorpicker:get( )
        return self.color
    end

    function colorpicker:set_visible( new_vis_state )
        self.visible = new_vis_state
    end

    function colorpicker:get_width( )
        return self.size.x
    end

    function colorpicker:get_height( )
        return self.size.y
    end

    function colorpicker:set_open(state)
        self.open = state
        -- Update the global state based on any picker
        is_colorpicker_open = state
    end

    function colorpicker:does_prevent_closing( )
        return self.open and self.in_colorpicker
    end

    function colorpicker:close( )
        self.open = false
    end

    function colorpicker:handle( pos, width )
        local is_m1_pressed = custom_input.is_button_pressed( MOUSE_LEFT )
    
        local text_start = pos + vector( option_pad, option_pad )
        local colorpicker_size = self.head_size
        local colorpicker_start = vector( pos.x + width - option_pad - colorpicker_size.x, text_start.y - math.floor( colorpicker_size.y / 2 ) + math.floor( self.name_size.y / 2 ) )

        
    
        self.hovered = is_in_bounds( colorpicker_start, colorpicker_size )
    
        if self.hovered and is_m1_pressed and not is_colorpicker_open then
            self:set_open(not self.open)
        elseif not self.in_colorpicker and self.open and is_m1_pressed then
            self:set_open(false)
        end

        --[[if is_colorpicker_open then
            if not self.hovered and is_m1_pressed then
                self:set_open(false)
            end
        end]]

        if self.open then
            self:set_open(true)
            local picker_size = self.picker.total
            local picker_start = vector(x, y)
    
            self.in_colorpicker = is_in_bounds( picker_start, picker_size )
    
            local is_m1_down = custom_input.is_key_down( MOUSE_LEFT )
    
            local color_box_start = picker_start + self.picker.gap
            local color_box_size = self.picker.big
            local in_big_bounds = is_in_bounds( color_box_start, color_box_size )
    
            local hue_start = color_box_start + vector( color_box_size.x + self.picker.gap.x, 0  )
            local hue_size = self.picker.hue
            local in_hue_bounds = is_in_bounds( hue_start, hue_size )
    
            local opacity_start = color_box_start + vector( 0, color_box_size.y + self.picker.gap.y )
            local opacity_size = self.picker.opacity
            local in_opacity_bounds = is_in_bounds( opacity_start, opacity_size )
    
            if not self.in_colorpicker and is_m1_pressed and not self.hovered then
                self.open = false
                self.changing.big = false
                self.changing.hue = false
                self.changing.opacity = false
    
                if allow_passthrough_id == self.id then
                    allow_passthrough_id = nil
                end
            end
    
            if is_m1_down and ( not allow_passthrough_id or allow_passthrough_id == self.id ) then
                if in_big_bounds and not self.changing.hue and not self.changing.opacity then
                    self.changing.big = true
                    self.changing.hue = false
                    self.changing.opacity = false
                elseif in_hue_bounds and not self.changing.big and not self.changing.opacity then
                    self.changing.big = false
                    self.changing.hue = true
                    self.changing.opacity = false
                elseif in_opacity_bounds and not self.changing.big and not self.changing.hue then
                    self.changing.big = false
                    self.changing.hue = false
                    self.changing.opacity = true
                end
            else
                self.changing.big = false
                self.changing.hue = false
                self.changing.opacity = false
            end
    
            local mouse = custom_input.get_mouse_pos( )
            local x, y = table.unpack( mouse )
            local mouse_pos = vector( x, y )
    
            if self.changing.big then
                local diff = mouse_pos - color_box_start
                local diff_pc = diff / color_box_size
    
                diff_pc.x = clamp( diff_pc.x, 0, 1 )
                diff_pc.y = clamp( diff_pc.y, 0, 1 )
    
                self.values.big = diff_pc
            elseif self.changing.hue then
                local y_diff = mouse_pos.y - hue_start.y
                local y_diff_pc = clamp( y_diff / hue_size.y, 0, 1 )
    
                self.values.hue = y_diff_pc
            elseif self.changing.opacity then
                local x_diff = mouse_pos.x - opacity_start.x
                local x_diff_pc = clamp( x_diff / opacity_size.x, 0, 1 )
    
                self.values.opacity = x_diff_pc
            end
    
            self.areas.hue = math.floor( self.values.hue * 360 + 0.5 )
            self.areas.saturation = self.values.big.x
            self.areas.brightness = 1 - self.values.big.y
    
            local rgb_color = color.hsb_to_rgb( self.areas.hue, self.areas.saturation, self.areas.brightness )
            rgb_color.a = clamp( math.floor( self.values.opacity * 255 + 0.5 ), 0, 255 )
    
            self.color = rgb_color
        end
    
        if not self.hovered and is_m1_pressed and self.open and not self.in_colorpicker then
            self.open = self:close( )
        end
    end
    

    function colorpicker:render( pos, width )
        self.size.x = width

        if not skip_handle then
            self:handle( pos, width )
        end

        -- render title
        local text_start = pos + vector( option_pad, option_pad )
        local text_color = self.hovered and color( 200 ) or color( 150 )

        -- render colorpicker
        local colorpicker_size = self.head_size
        local colorpicker_start = vector( pos.x + width - option_pad - colorpicker_size.x, text_start.y - math.floor( colorpicker_size.y / 2 ) + math.floor( self.name_size.y / 2 ) )

        renderer.rect_filled(
            colorpicker_start,
            colorpicker_size,
            self.color
        )

        renderer.rect(
            colorpicker_start,
            colorpicker_size,
            color( 0 )
        )

        if self.open then
            local picker_size = self.picker.total
            local picker_start = vector(x, y)

            draw.Color( 40, 40, 40, 255 )
            draw.FilledRect( picker_start.x, picker_start.y, picker_start.x + picker_size.x, picker_start.y + picker_size.y )

            renderer.rect(
                picker_start,
                picker_size,
                color( 0 )
            )

            -- render color box
            -- white to black vertical
            local color_box_start = picker_start + self.picker.gap
            local color_box_size = self.picker.big

            renderer.rect_fade_single_color(
                color_box_start,
                color_box_size,
                color( 255, 255, 255 ), 255, 0,
                false
            )

            local hue_to_rgb = color.hue_to_rgb( self.areas.hue )

            renderer.rect_fade_single_color(
                color_box_start,
                color_box_size,
                hue_to_rgb, 0, 255,
                true
            )
            
            renderer.rect_fade_single_color(
                color_box_start,
                color_box_size,
                color( 0, 0, 0 ), 0, 255,
                false
            )

            renderer.rect_fade_single_color(
                color_box_start,
                color_box_size,
                color( 0, 0, 0 ), 0, 255,
                false
            )

            -- render big one head
            local head_pos = color_box_start + color_box_size * self.values.big
            head_pos.x = math.floor( head_pos.x )
            head_pos.y = math.floor( head_pos.y )

            renderer.circle(
                head_pos,
                2,
                color( 0 ),
                4
            )

            renderer.circle(
                head_pos,
                1,
                color( 255 ),
                4
            )

            -- render hue oh god
            local hue_start = color_box_start + vector( color_box_size.x + self.picker.gap.x, 0  )
            local hue_size = self.picker.hue

            for i = 0, 300, 60 do
                local color_1 = color.hue_to_rgb( i )
                local color_2 = color.hue_to_rgb( i + 60 )

                renderer.rect_fade_single_color(
                    hue_start + vector( 0, math.floor( i / 360 * hue_size.y + 0.5 ) ),
                    vector( hue_size.x, math.floor( hue_size.y / 6 + ( i == 300 and 1 or 5 ) - 4 ) ),
                    color_1,
                    255,
                    100, false
                )

                renderer.rect_fade_single_color(
                    hue_start + vector( 0, math.floor( i / 360 * hue_size.y + 0.5 ) + 2 ),
                    vector( hue_size.x, math.floor( hue_size.y / 6 + ( i == 300 and 1 or 5 ) - 4 ) ),
                    color_2,
                    0,
                    255, false
                )
            end

            -- render hue slider head
            local slider_offset = vector( 2, 2 )
            local hue_slider_size = vector( hue_size.x, 0 ) + slider_offset * 2
            local hue_slider_pos = hue_start + vector( -slider_offset.x, math.floor( hue_size.y * self.values.hue ) - slider_offset.y )

            render_color_head( hue_slider_pos, hue_slider_size )

            -- render opacity
            local opacity_start = color_box_start + vector( 0, color_box_size.y + self.picker.gap.y )
            local opacity_size = self.picker.opacity

            renderer.textured_rect(
                opacity_start,
                opacity_size,
                zero_opacity_bg
            )

            renderer.rect_fade_single_color(
                opacity_start,
                opacity_size,
                color( 255 ), 0, 255, true
            )

            -- render opacity head
            local opacity_slider_size = vector( hue_slider_size.y, hue_slider_size.x )
            local opacity_slider_pos = opacity_start + vector( math.floor( opacity_size.x * self.values.opacity ) - slider_offset.x, -slider_offset.y )

            render_color_head( opacity_slider_pos, opacity_slider_size )
        end
    end

    return colorpicker
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------]]

local colorpickers = {}

local function initializeColorPickers()
    local colorpickerX = nosave.x + 300
    local colorpickerY = nosave.y + 100
    colorpickers = {
        red_team = options.new_colorpicker("", color(table.unpack(menu.Values.red_team)), colorpickerX+85, colorpickerY - 52),
        red_team_invisible = options.new_colorpicker("", color(table.unpack(menu.Values.red_team_invisible)), colorpickerX+139, colorpickerY - 37),
        blue_team = options.new_colorpicker("", color(table.unpack(menu.Values.blue_team)), colorpickerX+82, colorpickerY - 12),
        blue_team_invisible = options.new_colorpicker("", color(table.unpack(menu.Values.blue_team_invisible)), colorpickerX+137, colorpickerY + 3),
        red_team_chams = options.new_colorpicker("", color(table.unpack(menu.Values.red_team_chams)), colorpickerX, colorpickerY - 10),
        blue_team_chams = options.new_colorpicker("", color(table.unpack(menu.Values.blue_team_chams)), colorpickerX, colorpickerY + 60),
        red_team_tint = options.new_colorpicker("", color(table.unpack(menu.Values.red_team_tint)), colorpickerX, colorpickerY),
        blue_team_tint = options.new_colorpicker("", color(table.unpack(menu.Values.blue_team_tint)), colorpickerX, colorpickerY + 70),
        enemy_team = options.new_colorpicker("", color(table.unpack(menu.Values.enemy_team)), colorpickerX+98, colorpickerY - 52),
        enemy_team_invisible = options.new_colorpicker("", color(table.unpack(menu.Values.enemy_team_invisible)), colorpickerX+152, colorpickerY - 37),
        friendly_team = options.new_colorpicker("", color(table.unpack(menu.Values.friendly_team)), colorpickerX+104, colorpickerY - 12),
        friendly_team_invisible = options.new_colorpicker("", color(table.unpack(menu.Values.friendly_team_invisible)), colorpickerX+154, colorpickerY + 3),
        enemy_based_chams = options.new_colorpicker("", color(table.unpack(menu.Values.enemy_based_chams)), colorpickerX, colorpickerY - 10),
        friendly_team_chams = options.new_colorpicker("", color(table.unpack(menu.Values.friendly_chams)), colorpickerX, colorpickerY + 60),
        friendly_team_tint = options.new_colorpicker("", color(table.unpack(menu.Values.friendly_chams_tint)), colorpickerX, colorpickerY + 70),
        enemy_based_chams_tint = options.new_colorpicker("", color(table.unpack(menu.Values.enemy_based_chams_tint)), colorpickerX, colorpickerY),
        night_mode = options.new_colorpicker("", color(table.unpack(menu.Values.night_mode)), colorpickerX+118, colorpickerY + 94),
        back_track = options.new_colorpicker("", color(table.unpack(menu.Values.back_track)), colorpickerX+82, colorpickerY - 76),
        menu_color = options.new_colorpicker("", color(table.unpack(menu.Values.menuclr)), colorpickerX-32, colorpickerY-77),

        rjn_left = options.new_colorpicker("", color(table.unpack(menu.Values.rjn_left)), colorpickerX-32, colorpickerY-77),
        rjn_right = options.new_colorpicker("", color(table.unpack(menu.Values.rjn_right)), colorpickerX-32, colorpickerY-77),
        rjn_outline = options.new_colorpicker("", color(table.unpack(menu.Values.rjn_outline)), colorpickerX-32, colorpickerY-77),
    }
end

initializeColorPickers()

callbacks.Register("Draw", function()
    local newX = nosave.x + 300
    local newY = nosave.y + 100

    if newX ~= colorpickerX or newY ~= colorpickerY then
        colorpickerX = newX
        colorpickerY = newY
        initializeColorPickers()
    end
end)


--[COLORPICKER END]--


local chamsMaterials = {
    fresnel = materials.Create("fresnelMaterial",  [[
        VertexLitGeneric
        {
            $basetexture "vgui/white_additive"
            $bumpmap "models/player/shared/shared_normal"
            $envmap "skybox/sky_dustbowl_01"
            $envmapfresnel "1"
            $phong "1"
            $phongfresnelranges "[0 0.5 0.1]"
            $selfillum "1"
            $selfillumfresnel "1"
            $selfillumfresnelminmaxexp "[0.5 0.5 0]"
            $selfillumtint "[1 1 1]"
            $envmaptint "[1 1 1]"
        }
    ]]),

    shaded = materials.Create("shadedMaterial", [[
        "VertexLitGeneric"
        {
            "$basetexture" "vgui/white_additive"
            "$bumpmap" "vgui/white_additive"
            "$selfillum" "1"
            "$selfillumfresnel" "1"
            "$selfillumfresnelminmaxexp" "[-0.25 1 1]"
        }
        ]]),

    shiny = materials.Create("shinyMaterial", [[
        VertexLitGeneric
        {
            $basetexture "vgui/white_additive"
            $bumpmap "vgui/white_additive"
            $envmap "cubemaps/cubemap_sheen001"
            $selfillum "1"
            $selfillumfresnel "1"
            $selfillumfresnelminmaxexp "[-0.25 1 1]"
        }
    ]]),

    flat = materials.Create("flatMaterial", [[
        UnlitGeneric
        {
            $basetexture "vgui/white_additive"
        }
    ]]),

    glow =  materials.Create("glowMaterial", [[
        "VertexLitGeneric"
        {
            "$basetexture" "vgui/white_additive"
            "$bumpmap" "vgui/white_additive"
            "$color2" "[100 0.5 0.5]"
            "$selfillum" "1"
            "$selfIllumFresnel" "1"
            "$selfIllumFresnelMinMaxExp" "[0.1 0.2 0.3]"
            "$selfillumtint" "[0 0.3 0.6]"
        }
    ]]),
}
local IsDragging2 = false

local tahoma = draw.CreateFont( "Verdana", 12, 0, FONTFLAG_OUTLINE | FONTFLAG_CUSTOM )
local key = draw.CreateFont( "Tahoma", 13, 0, FONTFLAG_OUTLINE | FONTFLAG_CUSTOM )

local rjnfont = draw.CreateFont("Smallest Pixel", 13, 400, FONTFLAG_OUTLINE, 1)
local chargetxt = draw.CreateFont("Smallest Pixel", 16, 400, FONTFLAG_OUTLINE, 1)
local smallestPixel = draw.CreateFont("Smallest Pixel", 11, 400, FONTFLAG_OUTLINE, 1)

local keyTable = {
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

local function GetPressedKey()
    for i = 1, 113 do 
        if input.IsButtonPressed( i ) then
            if i ~= 107 then 
                return i
            end
        end
    end
end

function interpolateNumber(startValue, endValue, factor)
    factor = math.sin(factor * math.pi * 2) * 0.5 + 0.5
    
    local interpolatedValue = startValue * (1 - factor) + endValue * factor
    
    return interpolatedValue
end

function IsMouseInBounds(x,y,x2,y2)
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

local function Keybind(x, y, name, KeybindTableName)
    local keybind = menu.keybinds[KeybindTableName]
    local keybindText = menu.keybinds[KeybindTableName .. "_keybind_name"]
    local fixedWidth = 32
    local fixedHeight = 20
    local pos = {x, y, x + fixedWidth, y + fixedHeight}
    local nameWidth, nameHeight = draw.GetTextSize(name)

    if IsMouseInBounds(pos[1], pos[2], pos[3], pos[4]) then
        if input.IsButtonPressed(MOUSE_LEFT) then
            menu.keybinds[KeybindTableName .. "_waiting_for_input"] = true
        end
    end
    if menu.keybinds[KeybindTableName .. "_waiting_for_input"] then
        menu.keybinds[KeybindTableName .. "_keybind_name"] = "[...]"
        local pressedKey = GetPressedKey()
        if pressedKey ~= nil then
            if pressedKey == 70 then
                keybind = nil
            else
                keybind = pressedKey
            end
            menu.keybinds[KeybindTableName] = keybind  -- Update the keybind
            menu.keybinds[KeybindTableName .. "_waiting_for_input"] = false
        end
    else
        menu.keybinds[KeybindTableName .. "_keybind_name"] = keybind and "["..keyTable[keybind].. "]" or "[None]"
    end
 

    draw.SetFont(key)
    draw.Color(183, 183, 183, 255)
    TextInCenter(pos[1]+2, pos[2], pos[1] + fixedWidth, pos[2] + fixedHeight, keybindText)

    draw.SetFont(tahoma)
    draw.Text(pos[1] + fixedWidth + 9, y + math.floor(nameHeight / 4), name)
end

local Toggles = {}
local function Toggle(x, y, name, toggle_bool, disabled)
    local w, h = draw.GetTextSize(name)
    local buttonWidth = 15
    local pos = {x, y, x + buttonWidth, y + 15}  -- Original button bounds
    local textPos = {x, y, x + buttonWidth + w + 5, y + 15}  -- Extended bounds to include text

    local val = 80
    local val2 = 40
    menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
    local clrpickerclr = {table.unpack(menu.Values.menuclr)}
    local clrpickerclr1 = {table.unpack(menu.Values.menuclr)}
    clrpickerclr1[4] = clrpickerclr1[4] - 150
    if Toggles[toggle_bool] == nil then
        table.insert(Toggles, toggle_bool)
    end
    local clr = {clrpickerclr1[1], clrpickerclr1[2], clrpickerclr1[3], 80}
    local textColor = {183, 183, 183, 255}

    if IsMouseInBounds(table.unpack(textPos)) and not disabled and not Dropdown_open and not BlockInput then
        clr = {clrpickerclr1[1], clrpickerclr1[2], clrpickerclr1[3], 150}
        textColor = {255, 255, 255, 255} -- Brighter text color for hover
        if not input.IsButtonPressed(MOUSE_LEFT) then
            BlockInput = false
        end
        if input.IsButtonPressed(MOUSE_LEFT) then
            local currentTime = globals.RealTime()
            if currentTime - (Toggles[toggle_bool] or 0) >= 0.1 then
                menu.toggles[toggle_bool] = not menu.toggles[toggle_bool]
                Toggles[toggle_bool] = currentTime

                -- Mutual exclusivity logic for toggles
                if toggle_bool == "team_based" and menu.toggles.team_based then
                    menu.toggles.enemy_based = false
                elseif toggle_bool == "enemy_based" and menu.toggles.enemy_based then
                    menu.toggles.team_based = false
                end

                if toggle_bool == "team_based_esp" and menu.toggles.team_based_esp then
                    menu.toggles.enemy_based_esp = false
                elseif toggle_bool == "enemy_based_esp" and menu.toggles.enemy_based_esp then
                    menu.toggles.team_based_esp = false
                end

                if toggle_bool == "rage_aa" and menu.toggles.rage_aa then
                    menu.toggles.legit_aa = false
                elseif toggle_bool == "legit_aa" and menu.toggles.legit_aa then
                    menu.toggles.rage_aa = false
                end
    
                if toggle_bool == "aa_dynrotril" and menu.toggles.aa_dynrotril then
                    menu.toggles.aa_rotril = false
                    menu.toggles.aa_spinril = false
                elseif toggle_bool == "aa_rotril" and menu.toggles.aa_rotril  then
                    menu.toggles.aa_dynrotril = false
                    menu.toggles.aa_spinril = false
                elseif toggle_bool == "aa_spinril" and menu.toggles.aa_spinril then
                    menu.toggles.aa_dynrotril = false
                    menu.toggles.aa_rotril = false
                end
    
                if toggle_bool == "aa_dynrotfek" and menu.toggles.aa_dynrotfek then
                    menu.toggles.aa_rotfek = false
                    menu.toggles.aa_spinfek = false
                elseif toggle_bool == "aa_rotfek" and menu.toggles.aa_rotfek  then
                    menu.toggles.aa_dynrotfek = false
                    menu.toggles.aa_spinfek = false
                elseif toggle_bool == "aa_spinfek" and menu.toggles.aa_spinfek then
                    menu.toggles.aa_dynrotfek = false
                    menu.toggles.aa_rotfek = false
                end
            end
        end
    end

    draw.Color(table.unpack(clr))
    draw.FilledRect(x, y, x + buttonWidth, y + 15)  -- Original button rectangle
    draw.Color(table.unpack(textColor))
    draw.Text(x + buttonWidth + 5, y + math.floor(h / 4), name)  -- Adjusted text position
    
    if menu.toggles[toggle_bool] == true then
        draw.Color(2, 31, 46, 255)
        draw.SetFont(tahoma)
        draw.Color(table.unpack(clrpickerclr))
        draw.FilledRect(x + 3, y + 3, x + buttonWidth - 3, y + 12)  -- Adjusted inner rectangle for the toggle
    end
end

local Buttons = {}
local function Button(x, y, name, action, disabled)
    local textWidth, textHeight = draw.GetTextSize(name)
    local buttonWidth = textWidth + 10
    local buttonHeight = 15
    local pos = {x, y, x + buttonWidth, y + buttonHeight}

    local defaultColor = {menu.menuBGColor[1] + 45, menu.menuBGColor[2] + 45, menu.menuBGColor[3] + 45, 235}
    local hoverColor = {menu.menuBGColor[1] + 55, menu.menuBGColor[2] + 55, menu.menuBGColor[3] + 55, 235}
    local clickColor = {menu.menuBGColor[1] + 70, menu.menuBGColor[2] + 70, menu.menuBGColor[3] + 70, 80}
    local outlineColor = {menu.menuBGColor[1] + 125, menu.menuBGColor[2] + 125, menu.menuBGColor[3] + 125, 125}
    local textColor = {183, 183, 183, 255}
    local clr = defaultColor

    if IsMouseInBounds(table.unpack(pos)) and not disabled and not Dropdown_open and not BlockInput then
        clr = hoverColor
        if not input.IsButtonPressed(MOUSE_LEFT) then
            BlockInput = false
        end
        if input.IsButtonPressed(MOUSE_LEFT) then
            action()
        end
        if input.IsButtonDown(MOUSE_LEFT) then
            clr = clickColor
        end
    end

    draw.Color(table.unpack(clr))
    draw.FilledRect(x, y, x + buttonWidth, y + buttonHeight)
    draw.Color(table.unpack(outlineColor))
    draw.OutlinedRect(x, y, x + buttonWidth, y + buttonHeight)
    draw.Color(table.unpack(textColor))
    TextInCenter(x, y, x + buttonWidth, y + buttonHeight, name)
end

local function CloseButton(x, y, name, action, disabled)
    local textWidth, textHeight = draw.GetTextSize(name)
    local buttonWidth = textWidth + 10
    local buttonHeight = 15
    local pos = {x, y, x + buttonWidth, y + buttonHeight}

    menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
    local rgb = {table.unpack(menu.Values.menuclr)}
    local r, g, b = rgb[1], rgb[2], rgb[3]
    local defaultColor = {r, g, b, 0}
    local hoverColor = {r, g, b, 50}
    local clickColor = {r, g, b, 80}
    local outlineColor = {menu.menuBGColor[1] + 125, menu.menuBGColor[2] + 125, menu.menuBGColor[3] + 125, 125}
    local textColor = {183, 183, 183, 255}
    local clr = defaultColor

    if IsMouseInBounds(table.unpack(pos)) and not disabled and not Dropdown_open and not BlockInput then
        clr = hoverColor
        if not input.IsButtonPressed(MOUSE_LEFT) then
            BlockInput = false
        end
        if input.IsButtonPressed(MOUSE_LEFT) then
            action()
        end
        if input.IsButtonDown(MOUSE_LEFT) then
            clr = clickColor
        end
    end

    draw.Color(table.unpack(clr))
    draw.FilledRect(x, y, x + buttonWidth, y + buttonHeight)
    draw.Color(table.unpack(textColor))
    TextInCenter(x, y, x + buttonWidth, y + buttonHeight, name)
end

local function Slider(x,y,x2,y2, sliderValue ,min,max, name, disabled)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    local value = menu.misc[sliderValue] or menu.antiaim[sliderValue]
    menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
    local clrpickerclr = {table.unpack(menu.Values.menuclr)}
    local increment = 215
    clrpickerclr[4] = clrpickerclr[4] - increment
    if IsMouseInBounds(x,y - 5,x2,y2 + 5) and input.IsButtonDown(MOUSE_LEFT) and not disabled and not Dropdown_open and not BlockInput then 
        function clamp(value, min, max)
            return math.max(min, math.min(max, value))
        end
        local percent = clamp((mX - x) / (x2-x), 0, 1)
        local value2 = math.floor((min + (max - min) * percent))
        menu.misc[sliderValue] = value2
        menu.antiaim[sliderValue] = value2
    end
    draw.Color(40,40,40,255)
    draw.OutlinedRect(x,y,x2,y2)
    draw.Color(10,10,10,130)
    draw.FilledRect(x,y,x2,y2)
    draw.Color( table.unpack(clrpickerclr) )
    local sliderWidth = math.floor((x2-x) * (value - min) / (max - min))
    local pos = {x, y, x + sliderWidth, y2}
    draw.FilledRect(table.unpack(pos))
    draw.Color( table.unpack(clrpickerclr) )
    draw.OutlinedRect(table.unpack(pos))
    draw.Color(255,255,255,255)
    local w,h = draw.GetTextSize( value )
    draw.Text(x2-w, pos[2]-h, value)
    w,h = draw.GetTextSize( name )
    draw.Text(x, pos[2]-h, name)
end

local function Slider2(x,y,x2,y2, sliderValue ,min,max, name, disabled)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    local value = menu.misc[sliderValue] or menu.antiaim[sliderValue]
    menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
    local clrpickerclr = {table.unpack(menu.Values.menuclr)}
    local increment = 215
    clrpickerclr[4] = math.min(math.max((clrpickerclr[4]) - increment, 0), 255)
    if IsMouseInBounds(x,y - 5,x2,y2 + 5) and input.IsButtonDown(MOUSE_LEFT) and not disabled and not Dropdown_open and not BlockInput then 
        function clamp(value, min, max)
            return math.max(min, math.min(max, value))
        end
        local percent = clamp((mX - x) / (x2 - x), 0, 1)
        local value2 = math.floor(((min * 10) + ((max * 10) - (min * 10)) * percent) + 0.5) / 10
        menu.misc[sliderValue] = value2
        menu.antiaim[sliderValue] = value2
    end
    draw.Color(40,40,40,255)
    draw.OutlinedRect(x,y,x2,y2)
    draw.Color(10,10,10,130)
    draw.FilledRect(x,y,x2,y2)
    draw.Color(table.unpack(clrpickerclr))
    local sliderWidth = math.floor((x2 - x) * (value - min) / (max - min))
    local pos = {x, y, x + sliderWidth, y2}
    draw.FilledRect(table.unpack(pos))
    draw.Color(table.unpack(clrpickerclr))
    draw.OutlinedRect(table.unpack(pos))
    draw.Color(255,255,255,255)
    local w,h = draw.GetTextSize(value)
    draw.Text(x2-w, pos[2]-h, value)
    w,h = draw.GetTextSize(name)
    draw.Text(x, pos[2]-h, name)
end

function table.contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

local function cls()
    callbacks.Unregister( "Draw", "kigeiag")
    callbacks.Unregister("Unload", "unlod")
end

local function applySkybox()
    local selectedOption = menu.Dropdowns.skyboxOptions[menu.Dropdowns.skyboxDropdownVar]
    client.RemoveConVarProtection( "sv_skyname" )
    client.SetConVar( "sv_skyname", selectedOption )
    if selectedOption == "none" then
        client.Command("sv_skyname \"\"", true)
    end
end
local function resetSkyboxToDefault()
    client.Command("sv_skyname \"\"", true)
end
resetSkyboxToDefault()
local function updateSkyboxOptions()
    local skyboxNames = {}
    local knownSuffixes = { "bk", "dn", "ft", "lf", "rt", "up" }

    local function hasValidSuffix(filename)
        for _, suffix in ipairs(knownSuffixes) do
            if string.match(filename, suffix .. "%.vtf") or string.match(filename, suffix .. "%.vmt") then
                return true
            end
        end
        return false
    end
    local function extractBaseName(filename)
        for _, suffix in ipairs(knownSuffixes) do
            local baseName = string.match(filename, "^(.-)" .. suffix .. "%.")
            if baseName then
                return baseName
            end
        end
        return nil
    end
    filesystem.EnumerateDirectory([[tf/materials/skybox/*]], function(filename, attributes)
        local baseName = extractBaseName(filename)
        if baseName and hasValidSuffix(filename) and not skyboxNames[baseName] then
            skyboxNames[baseName] = true
        end
    end)
    for skyboxName in pairs(skyboxNames) do
        if not table.contains(menu.Dropdowns.skyboxOptions, skyboxName) then
            table.insert(menu.Dropdowns.skyboxOptions, skyboxName)
        end
    end
end
updateSkyboxOptions()
local function Island(x,y,x2,y2, name)
    menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
    local rgb = {table.unpack(menu.Values.menuclr)}
    local r, g, b = rgb[1], rgb[2], rgb[3]
    draw.Color(r,g,b, 20)
    draw.FilledRect(x,y,x2,y2)
    draw.Color( r,g,b,125 )
    draw.OutlinedRect(x, y, x2, y2)
    draw.Color( r,g,b,20 )
    draw.FilledRect(x, y - 15, x2, y)
    draw.Color( r,g,b,125 )
    draw.OutlinedRect(x, y - 15, x2, y)
    draw.Color( 255,255,255,255 )
    local w,h = draw.GetTextSize(name)
    draw.Text(math.floor(x+((x2-x)/2)-(w/2)), math.floor(y-14), name )
end

local function CFGbutton(x,y,x2,y2,name,button)
    menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
    local rgb = {table.unpack(menu.Values.menuclr)}
    local r, g, b = rgb[1], rgb[2], rgb[3]
    local clr = {r, g, b}
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

local lastToggleTime = 0
local Lbox_Menu_Open = true
local function toggleMenu()
    local currentTime = globals.RealTime()
    if currentTime - lastToggleTime >= 0.1 then
        Lbox_Menu_Open = not Lbox_Menu_Open
        lastToggleTime = currentTime
    end
end

local delays = {
    dyn_wait = 0,
}

function rgbaToHex(r, g, b, a)
    r = math.floor(r)
    g = math.floor(g)
    b = math.floor(b)
    a = math.floor(a)
    return tonumber("0x".. string.format("%02x%02x%02x%02x", r, g, b, a))
end
local function vl(value, min, max)
    return math.max(min, math.min(value, max))
end

local barWidth = 115
local barHeight = 9
local minTicks = 1
local maxTicks = 23
local barOffset = 45

local tickstxt = draw.CreateFont("Smallest Pixel", 14, 1, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)
local barW = 223
local barW2 = 223
local barH = 23

local barWidth1 = 0 
local barHeight1 = 4
local rectWidth = 170
local recHeight = 29

local barWidth4 = 178
local barWidth5 = 178
local barHeight3 = 18

local speed = 0.07

local sW,sH = draw.GetScreenSize()

local screenX, screenY = draw.GetScreenSize()
local barX = math.floor(screenX / 2 - barWidth / 2)
local barY = math.floor(screenY / 2) + barOffset

local barX1 = math.floor(screenX / 2 - barW / 2)
local barY1 = math.floor(screenY / 2) + 50

local barX2 = math.floor(screenX / 2 - rectWidth / 2)
local barY2 = math.floor(screenY / 2) + barOffset

local recX = math.floor(screenX / 2 - rectWidth / 2)
local recY = math.floor(screenY / 2) + barOffset - 25

local barX4 = math.floor(screenX / 2 - barWidth5 / 2)
local barY4 = math.floor(screenY / 2) + barOffset

local startTime = os.clock()

local angleOffset = 180
local holdDuration = 0.5
local holdStartTime = 0
local IsDraggingRjn = false
local buttons = {
    [1] = {name="Esp", table="esp", tab="tab_1"},
    [2] = {name="Misc", table="misc", tab="tab_2"},
    [3] = {name="Anti-Aim", table="antiaim", tab="tab_3"},
    [4] = {name="Indicators", table="indicators", tab="tab_4"},
    [5] = {name="Reset", table="reset", tab="tab_5"},
}
local function makeDarker(r, g, b, amount)
    r = math.max(r - amount, 0)
    g = math.max(g - amount, 0)
    b = math.max(b - amount, 0)
    return r, g, b
end
-- Main draw function
local function drawMenu()
    if not Lbox_Menu_Open then return end
    local dropdowns = {}
    draw.SetFont( tahoma )
    local x, y = nosave.x, nosave.y
    local bW, bH = menu.w, menu.h
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    
    if IsDragging2 then
        if input.IsButtonDown(MOUSE_LEFT) then
            nosave.x = mX - math.floor(bW * menu.rX)
            nosave.y = mY - math.floor(15 * menu.rY)
        else
            IsDragging2 = false
        end
    else
        if IsMouseInBounds(x, y - 15, x + bW+2, y) and not Dropdown_open then
            if not input.IsButtonDown(MOUSE_LEFT) then
                menu.rX = ((mX - x) / bW)
                menu.rY = ((mY - y) / 15)
            else
                nosave.x = mX - math.floor(bW * menu.rX)
                nosave.y = mY - math.floor(15 * menu.rY)
                IsDragging2 = true
            end
        end
    end

    menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
    local rgb = {table.unpack(menu.Values.menuclr)}
    local r, g, b = rgb[1], rgb[2], rgb[3]

    local vals = 35
    draw.Color( menu.menuBGColor[1]+10,menu.menuBGColor[2]+10,menu.menuBGColor[3]+10, 255 )
    draw.FilledRect(x, y - 15, x + bW, y) -- top bar

    local string = "menu"
    local dr, dg, db = makeDarker(r, g, b, 100)
    draw.Color(255, 255, 255, 255)
    --draw.Text(math.floor(x+(bW/2)-(w/2)), math.floor(y-h), string) -- name
    TextInCenter(x, y - 15, x + bW, y, string)
    
    draw.Color(menu.menuBGColor[1],menu.menuBGColor[2],menu.menuBGColor[3], 255)
    draw.FilledRect(x, y, x + bW, y + bH)

    draw.Color(menu.menuBGColor[1]+20,menu.menuBGColor[2]+20,menu.menuBGColor[3]+20, menu.menuBGColor[4])
    draw.OutlinedRect(x, y - 15, x + bW, y) -- outline of top bar

    draw.Color(menu.menuBGColor[1]+65,menu.menuBGColor[2]+65,menu.menuBGColor[3]+65, 10)
    draw.FilledRect(x,y,math.floor(x+bW-375), y+bH)


    local mouseX = input.GetMousePos()[1]
    local mouseY = input.GetMousePos()[2]

    --[[local maxDistanceFactor = 2.0
    local startColorRatio = 0.4
    local outlineThickness = 2]]
    local isDisabled = is_colorpicker_open
    local isDisabled1 = Dropdown_open
    
    -- button  
    local startY = 0-4
    local activeTab = nil  -- Variable to store the currently selected tab
    
    -- Iterate through buttons to determine the active tab
    for tab, isActive in pairs(teb.tabs) do
        if isActive then
            activeTab = tab
            break
        end
    end
    
    for i = 1, #buttons do
        local button = buttons[i]
        local w, h = draw.GetTextSize(button.name)
        menu.Values.menuclr = {colorpickers.menu_color:get():unpack()}
        local clrpickerclr = {table.unpack(menu.Values.menuclr)}
        
        -- Calculate button position
        local buttonY = y + startY + 5
        local pos = {x, buttonY, x + 125, buttonY + 30}  -- Adjust height here if needed
        
        local hover1 = IsMouseInBounds(x, buttonY, x + 125, buttonY + 30)
        local clr = {r, g, b, 10}
        local txtclr = {165,165,165,255}
        
        if IsMouseInBounds(table.unpack(pos)) and input.IsButtonPressed(MOUSE_LEFT) then
            menu.buttons[button.table] = true
        else
            menu.buttons[button.table] = false
        end
    
        if hover1 then
            clr = {r, g, b, 40}
        end
    
        -- Set color for the button based on the active tab
        if activeTab and button.tab == activeTab then
            txtclr = {225,225,225,225}
        end
    
        -- Draw the button background
        draw.Color(table.unpack(clr))
        draw.FilledRect(table.unpack(pos))
    
        -- Draw the rectangle for the active button if it belongs to the active tab
        if button.tab == activeTab then
            draw.Color(table.unpack(clrpickerclr))  -- Use clr3 or set a color for the active tab rectangle
            draw.FilledRect(x, buttonY, x + 5, buttonY + 30)  -- Adjust Y to match button height
        end
    
        draw.Color(table.unpack(txtclr))
        TextInCenter(pos[1], pos[2], pos[3], pos[4], button.name)
        startY = startY + 30  -- Increment the Y position for the next button
    end
    
    if menu.buttons.esp then 
        teb.tabs.tab_1=true
        teb.tabs.tab_2=false
        teb.tabs.tab_3=false
        teb.tabs.tab_4=false
        teb.tabs.tab_5=false
    end

    if menu.buttons.misc then 
        teb.tabs.tab_1=false
        teb.tabs.tab_2=true
        teb.tabs.tab_3=false
        teb.tabs.tab_4=false
        teb.tabs.tab_5=false
    end

    if menu.buttons.antiaim then 
        teb.tabs.tab_1=false
        teb.tabs.tab_2=false
        teb.tabs.tab_3=true
        teb.tabs.tab_4=false
        teb.tabs.tab_5=false
    end

    if menu.buttons.indicators then 
        teb.tabs.tab_1=false
        teb.tabs.tab_2=false
        teb.tabs.tab_3=false
        teb.tabs.tab_4=true
        teb.tabs.tab_5=false
    end

    if menu.buttons.reset then 
        teb.tabs.tab_1=false
        teb.tabs.tab_2=false
        teb.tabs.tab_3=false
        teb.tabs.tab_4=false
        teb.tabs.tab_5=true
    end

    

    local selctTab = " "
    x = x + 90
    local x1,y1 = x+5, y+20
    Dropdowns:Dropdown(x-85, y+525, 115, 22, "cfgDropdownVar", menu.Dropdowns.cfgOptions, "", menu, colorpickers)
    CFGbutton(x-85, y+505, x + bW-530, y+522,"Load", "cfg_load")
    CFGbutton(x-25, y+505, x + bW-470, y+522,"Save", "cfg_save")
    CloseButton(x1+235+153, y1-35, "X", cls, isDisabled)
    if teb.tabs.tab_1 then
        
        --Dropdowns:Dropdown(x1+45, y1+350, 105, 22, "fakeDropdownVar", menu.Dropdowns.chamsOptions, "Anti Aim Chams", menu, colorpickers)
        --Dropdowns:Dropdown(x1+45, y1+300, 105, 22, "localDropdownVar", menu.Dropdowns.chamsOptions, "Local Chams", menu, colorpickers)
        -- esp
        selctTab = "esp"
        local w5 = 85
        local ex = 40
        local ex1 = 235
        local strng_Red = "Red Team"
        local strng_Red_invis = "Red Team (Invisible)"
        local strng_Blu = "Blu Team"
        local strng_Blu_invis = "Blu Team (Invisible)"
        local strng_RedWI, strng_RedHI = draw.GetTextSize( strng_Red )
        local strng_Red_invisWI, strng_Red_invisHI = draw.GetTextSize( strng_Red_invis )

        local strng_BluWI, strng_BluHI = draw.GetTextSize( strng_Blu )
        local strng_Blu_invisWI, strng_Blu_invisHI = draw.GetTextSize( strng_Blu_invis )

        local strng_Enemy = "Enemy Team"
        local strng_Enemy_invis = "Enemy Team (invisible)"
        local strng_Team = "Friendly Team"
        local strng_Team_invis = "Friendly Team (invisible)"
        local strng_EnemyWI, strng_EnemyHI = draw.GetTextSize( strng_Enemy )
        local strng_Enemy_invisWI, strng_Enemy_invisHI = draw.GetTextSize( strng_Enemy_invis )

        local strng_TeamWI, strng_TeamHI = draw.GetTextSize( strng_Team )
        local strng_Team_invisWI, strng_Team_invisHI = draw.GetTextSize( strng_Team_invis )

        local string_Nightmode = "Nightmode Color"
        local string_Backtrack = "Backtrack Color"
        local strng_NightmodeWI, strng_NightmodeHI = draw.GetTextSize( string_Nightmode )
        local strng_BacktrackWI, strng_BacktrackHI = draw.GetTextSize( string_Backtrack )

        menu.Values.red_team = {colorpickers.red_team:get():unpack()}
        red_team_hex = rgbaToHex(table.unpack(menu.Values.red_team))
        menu.Values.red_team_invisible = {colorpickers.red_team_invisible:get():unpack()}
        red_team_invisible_hex = rgbaToHex(table.unpack(menu.Values.red_team_invisible))

        menu.Values.blue_team = {colorpickers.blue_team:get():unpack()}
        blue_team_hex = rgbaToHex(table.unpack(menu.Values.blue_team))
        menu.Values.blue_team_invisible = {colorpickers.blue_team_invisible:get():unpack()}
        blue_team_invisible_hex = rgbaToHex(table.unpack(menu.Values.blue_team_invisible))

        menu.Values.friendly_team = {colorpickers.friendly_team:get():unpack()}
        friendly_team_hex = rgbaToHex(table.unpack(menu.Values.friendly_team))
        menu.Values.friendly_team_invisible = {colorpickers.friendly_team_invisible:get():unpack()}
        friendly_team_invisible_hex = rgbaToHex(table.unpack(menu.Values.friendly_team_invisible))

        menu.Values.enemy_team = {colorpickers.enemy_team:get():unpack()}
        enemy_team_hex = rgbaToHex(table.unpack(menu.Values.enemy_team))
        menu.Values.enemy_team_invisible = {colorpickers.enemy_team_invisible:get():unpack()}
        enemy_team_invisible_hex = rgbaToHex(table.unpack(menu.Values.enemy_team_invisible))

        menu.Values.night_mode = {colorpickers.night_mode:get():unpack()}
        night_mode_hex = rgbaToHex(table.unpack(menu.Values.night_mode))

        menu.Values.back_track = {colorpickers.back_track:get():unpack()}
        back_track_hex = rgbaToHex(table.unpack(menu.Values.back_track))

        Island(x1+ex1-30,y1+170,x1+157+ex1,y1+250,"Visual Colors")
        draw.Text( x1+ex1-25, y1+175, string_Nightmode )
        Slider(x1+ex1-25,y1+205,x1+345+ex,y1+215, "nightmode_scale" ,0,100, "Nightmode Scale", isDisabled)
        gui.SetValue("night mode color", night_mode_hex)
        gui.SetValue("night mode", menu.misc.nightmode_scale)
        colorpickers.night_mode:render(vector(x1+strng_NightmodeWI+ex1-75, y1+170), w5)
        
        Island(x1+ex1-30,y1,x1+157+ex1,y1+150,"Custom ESP Color")
        Toggle(x1+ex1-25, y1+105,"Team Based", "team_based_esp", isDisabled)
        Toggle(x1+ex1-25, y1+125,"Enemy Based", "enemy_based_esp", isDisabled)
        Toggle(x1+ex1-25, y1+5,"Override Color", "esp_color", isDisabled)

        if menu.toggles.esp_color then
            gui.SetValue( "blue team color", blue_team_hex)
            gui.SetValue( "red team color", red_team_hex)

            gui.SetValue( "blue team (invisible)", blue_team_invisible_hex)
            gui.SetValue( "red team (invisible)", red_team_invisible_hex)
        end

        if menu.toggles.team_based_esp then
            draw.Color( 255,255,255,255 )
            draw.Text( x1+ex1-25, y1+30, strng_Red )
            draw.Text( x1+ex1-25, y1+45, strng_Red_invis )
            colorpickers.red_team_invisible:render(vector(x1+ex1+strng_Red_invisWI-75, y1+40), 85)
            colorpickers.blue_team_invisible:render(vector(x1+ex1+strng_Blu_invisWI-75, y1+80), 85)

            draw.Color( 255,255,255,255 )
            draw.Text( x1+ex1-25, y1+70, strng_Blu )
            draw.Text( x1+ex1-25, y1+85, strng_Blu_invis )
            colorpickers.red_team:render(vector(x1+ex1+strng_RedWI-75, y1+25), 85)
            colorpickers.blue_team:render(vector(x1+ex1+strng_BluWI-75, y1+65), 85)
            
            Toggle(x1+ex1+73, y1+5,"Enemy only", "enemy_only_esp", isDisabled)
        end

        if menu.toggles.enemy_based_esp then   
            draw.Color( 255,255,255,255 )
            draw.Text( x1+ex1-25, y1+30, strng_Enemy )
            draw.Text( x1+ex1-25, y1+45, strng_Enemy_invis )
            Toggle(x1+ex1+73, y1+5,"Enemy only", "enemy_only_esp", isDisabled)

            draw.Color( 255,255,255,255 )
            draw.Text( x1+ex1-25, y1+70, strng_Team )
            draw.Text( x1+ex1-25, y1+85, strng_Team_invis )

            
            colorpickers.enemy_team_invisible:render(vector(x1+strng_Enemy_invisWI+ex1-75, y1+40), w5)
            colorpickers.friendly_team_invisible:render(vector(x1+strng_Team_invisWI+ex1-78, y1+80), w5)

            colorpickers.friendly_team:render(vector(x1+strng_TeamWI+ex1-75, y1+65), w5)
            colorpickers.enemy_team:render(vector(x1+strng_EnemyWI+ex1-75, y1+25), w5)
        end

        if menu.toggles.enemy_only_esp then
            gui.SetValue( "Enemy Only", 1 )
        else
            gui.SetValue( "Enemy Only", 0 )
        end
        -- chams
        -- Island(x1+ex,y1+240,x1+150+ex,y1+400,"Backtrack")
        Island(x1+ex,y1,x1+150+ex,y1+210,"Chams (disabled)")
        Toggle(x1+45, y1+165,"Team Based", "team_based", isDisabled)
        Toggle(x1+45, y1+185,"Enemy Based", "enemy_based", isDisabled)

        if menu.toggles.team_based then  
            Toggle(x1+105, y1+5,"Enemy only", "enemy_only", isDisabled)
            Toggle(x1+45, y1+5,"Chams", "chams", isDisabled)
        end

        if menu.toggles.enemy_based then
            Toggle(x1+105, y1+5,"Enemy only", "enemy_only", isDisabled)
            Toggle(x1+45, y1+5,"Chams", "chams1", isDisabled)
        end

       if menu.toggles.chams and menu.toggles.team_based then
        menu.toggles.chams1 = false
        local w5 = 85
        Dropdowns:Dropdown(x1+45, y1+110, 105, 22, "anotherDropdownVar", menu.Dropdowns.chamsOptions, "Blue Team Chams", menu, colorpickers)
        Dropdowns:Dropdown(x1+45, y1+50, 105, 22, "DropdownVar", menu.Dropdowns.chamsOptions, "Red Team Chams", menu, colorpickers)

        colorpickers.red_team_chams:render(vector(x1+100, y1+50), w5)
        colorpickers.blue_team_chams:render(vector(x1+100, y1+110), w5)

        colorpickers.red_team_tint:render(vector(x1+100, y1+65), w5)
        colorpickers.blue_team_tint:render(vector(x1+100, y1+125), w5)
       end

       if menu.toggles.chams1 and menu.toggles.enemy_based then
        menu.toggles.chams = false
        local w5 = 85
        Dropdowns:Dropdown(x1+45, y1+110, 105, 22, "anotherDropdownVar", menu.Dropdowns.chamsOptions, "Teammates Chams", menu, colorpickers)
        Dropdowns:Dropdown(x1+45, y1+50, 105, 22, "DropdownVar", menu.Dropdowns.chamsOptions, "Enemy Chams", menu, colorpickers)

        colorpickers.enemy_based_chams:render(vector(x1+100, y1+50), w5)
        colorpickers.friendly_team_chams:render(vector(x1+100, y1+110), w5)

        colorpickers.enemy_based_chams_tint:render(vector(x1+100, y1+65), w5)
        colorpickers.friendly_team_tint:render(vector(x1+100, y1+125), w5)
       end

    end

    if teb.tabs.tab_2 then
        local w5 = 85
        local ex = 40
        local ex1 = 235
        local wi, hi = draw.GetTextSize( "menu highlight color" )
        local xVAL = 35
        local mk1 = 10
        local haha = 220
        selctTab = "misc"

        Island(x1+ex,y1,x1+150+ex,y1+50,"Menu options")
        draw.Text( x1+xVAL+10,y1+5, "menu highlight color")
        -- Toggle(x1+mk1+35,y1+30,"Autoload CFG", "autoload", isDisabled)

        Island(x1+ex,y1+175,x1+150+ex,y1+260,"Custom skybox")
        Button(x1+ex1-188, y1+220, "Apply Skyboxes", applySkybox, isDisabled)
        Button(x1+ex1-188, y1+240, "Refresh List", updateSkyboxOptions, isDisabled) 

        

        Toggle(x1+ex1-28, y1+200, "Auto Detonate", "auto_detonate", isDisabled)
        if menu.toggles.auto_detonate then
            haha = 285
        end

        Island(x1+ex+160,y1+175,x1+310+ex,y1+haha,"Automations")
        Toggle(x1+ex1-28, y1+180, "Rocket jump", "rocket_jump", isDisabled)
        Keybind(x1+ex1+80, y1+180," ", "rocket_jump")

        if menu.toggles.auto_detonate then
            Slider(x1+ex1-28, y1+230,x1+ex1+110, y1+238, "minStickies" ,1,8, "Minimum stickies", isDisabled)
            Slider(x1+ex1-28, y1+250,x1+ex1+110, y1+258, "detonate_radius" ,20,100, "Detonation Range", isDisabled)
            Toggle(x1+ex1-28, y1+265, "Localplayer Check", "preventDetonationlocalPlayer", isDisabled)
        end

        Island(x1+ex+160,y1,x1+310+ex,y1+50,"Aspect Ratio")
        Slider2(x1+ex+165,y1+25,x1+ex+305,y1+35, "aspectrat" ,0,2, "Aspect Ratio", isDisabled)

        Island(x1+ex+160,y1+70,x1+310+ex,y1+155,"Weapon Sway")
        Slider(x1+ex+165,y1+95,x1+305+ex,y1+105, "wepnswyinterp" ,1,100, "Interp", isDisabled)
        Slider(x1+ex+165,y1+125,x1+305+ex,y1+135, "wepnswyscale" ,0,100, "Scale", isDisabled)

        Island(x1+ex,y1+70,x1+150+ex,y1+155,"Viewmodel Position")
        Slider2(x1+ex+5,y1+85,x1+145+ex,y1+95, "xwpn" ,-50,50, "X", isDisabled1)
        Slider2(x1+ex+5,y1+110,x1+145+ex,y1+120, "ywpn" ,-50,50, "Y", isDisabled1)
        Slider2(x1+ex+5,y1+135,x1+145+ex,y1+145, "zwpn" ,-50,50, "Z", isDisabled1)

        Dropdowns:Dropdown(x1+45, y1+195, 130, 22, "skyboxDropdownVar", menu.Dropdowns.skyboxOptions, "Skybox", menu, colorpickers)
        colorpickers.menu_color:render(vector(x1+wi-43+xVAL, y1), w5)

        --Toggle(x1+mk1+300,y1+480,"Sticky Radius", "sticky_radius", isDisabled)

        --[[
        Island(x1+ex+160,y1+175,x1+310+ex,y1+280,"Thirdperson Position")
        Slider(x1+ex+165,y1+190,x1+305+ex,y1+200, "cam_x" ,-500,500, "X", isDisabled1)
        Slider(x1+ex+165,y1+215,x1+305+ex,y1+225, "cam_y" ,-500,500, "Y", isDisabled1)
        Slider(x1+ex+165,y1+240,x1+305+ex,y1+250, "cam_z" ,-500,500, "Z", isDisabled1)
        Keybind(x1+ex+165, y1+255,"Thirdperson key", "third_person")
        ]]

        
    end

    if teb.tabs.tab_3 then
        local w5 = 85
        local ex = 40
        local ex1 = 235
        selctTab = "antiaim"
        local mk1 = 10

        Island(x1+40,y1,x1+150,y1+55,"Main")
        Toggle(x1+mk1+35,y1+5,"Enable AA", "antieim", isDisabled)
        Slider2(x1+mk1+35,y1+42,x1+mk1+135,y1+52, "aadelay" ,.2,10, "Delay", isDisabled)

        if menu.toggles.antieim then
            Island(x1+160,y1,x1+290,y1+55,"Type AA")
            Toggle(x1+165,y1+5,"Rage AA", "rage_aa", isDisabled)
            Toggle(x1+165,y1+29,"Legit AA", "legit_aa", isDisabled)

            if menu.toggles.rage_aa then
                Island(x1+mk1+30,y1+75,x1+150,y1+155,"Real AA Method")
                Toggle(x1+mk1+35,y1+80,"Rotate", "aa_rotril", isDisabled)
                Toggle(x1+mk1+35,y1+105,"Rotate Dynamic", "aa_dynrotril", isDisabled)
                Toggle(x1+mk1+35,y1+130,"Spin", "aa_spinril", isDisabled)

                Island(x1+160,y1+75,x1+290,y1+155,"Fake AA Method")
                Toggle(x1+165,y1+80,"Rotate", "aa_rotfek", isDisabled)
                Toggle(x1+165,y1+105,"Rotate Dynamic", "aa_dynrotfek", isDisabled)
                Toggle(x1+165,y1+130,"Spin", "aa_spinfek", isDisabled)

                if menu.toggles.aa_dynrotril then
                Island(x1+mk1+30,y1+180,x1+150,y1+250,"Real AA")
                Slider(x1+mk1+35,y1+200,x1+140,y1+210, "aaril1" ,-180,180, "Real Angle 1")
                Slider(x1+mk1+35,y1+230,x1+140,y1+240, "aaril2" ,-180,180, "Real Angle 2")
                end

                if menu.toggles.aa_dynrotfek then
                Island(x1+160,y1+180,x1+290,y1+250,"Fake AA")
                Slider(x1+165,y1+200,x1+285,y1+210, "aafek1" ,-180,180, "Fake Angle 1")
                Slider(x1+165,y1+230,x1+285,y1+240, "aafek2" ,-180,180, "Fake Angle 2")
                end

                if menu.toggles.aa_rotril then
                Island(x1+mk1+30,y1+180,x1+150,y1+250,"Real AA")
                Slider(x1+mk1+35,y1+200,x1+140,y1+210, "aaril" ,-180,180, "Real Angle")
                end

                if menu.toggles.aa_rotfek then
                Island(x1+160,y1+180,x1+290,y1+250,"Fake AA")
                Slider(x1+165,y1+200,x1+285,y1+210, "aafek" ,-180,180, "Fake Angle")
                end
                
                if menu.toggles.aa_spinril then
                Island(x1+mk1+30,y1+180,x1+150,y1+250,"Real AA")
                Slider(x1+mk1+35,y1+200,x1+140,y1+210, "aaspinril" ,1,10, "Spin Speed")
                Toggle(x1+mk1+35,y1+220,"Inverted", "invert1", isDisabled)
                end

                if menu.toggles.aa_spinfek then
                Island(x1+160,y1+180,x1+290,y1+250,"Fake AA")
                Slider(x1+165,y1+200,x1+285,y1+210, "aaspinfek" ,1,10, "Spin Speed")
                Toggle(x1+165,y1+220,"Inverted", "invert2", isDisabled)
                end

            elseif menu.toggles.legit_aa then
                Island(x1+mk1+30,y1+75,x1+150,y1+120,"Legit AA")
                Slider(x1+mk1+35,y1+95,x1+140,y1+110, "aaligit" ,-180,180, "Real Angle")
            end

        end

    end

    if teb.tabs.tab_4 then
        local w5 = 85
        local ex = 40
        local ex1 = 235
        local xVAL = 35
        local mk1 = 10
        selctTab = "indicators"

        Island(x1+ex,y1,x1+120+ex,y1+50,"Rijin")
        Toggle(x1+ex+5,y1+5,"DT Bar", "rijin_dt_bar", isDisabled)
    end

    if teb.tabs.tab_5 then
        local w5 = 85
        local ex = 40
        local ex1 = 235
        local xVAL = 35
        local mk1 = 10
        selctTab = "reset"

        Island(x1+ex,y1,x1+180+ex,y1+165,"Reset values to default")
        Button(x1+mk1+35,y1+5, "Reset Skybox (rejoin needed)", resetSkyboxToDefault, isDisabled)

        Button(x1+mk1+35,y1+25, "Reset Aspect Ratio", function() menu.misc.aspectrat = 0.0 end, isDisabled)

        Button(x1+mk1+35,y1+45, "Reset AA Delay", function() menu.misc.aadelay = 1 end, isDisabled)

        Button(x1+mk1+35,y1+65, "Reset Weapon Sway Interp", function() menu.misc.wepnswyinterp = 1 end, isDisabled)
        Button(x1+mk1+35,y1+85, "Reset Weapon Sway Scale", function() menu.misc.wepnswyscale = 0 end, isDisabled)

        Button(x1+mk1+35,y1+105, "Reset Weapon X", function() menu.misc.xwpn = 0 end, isDisabled)
        Button(x1+mk1+35,y1+125, "Reset Weapon Y", function() menu.misc.ywpn = 0 end, isDisabled)
        Button(x1+mk1+35,y1+145, "Reset Weapon Z", function() menu.misc.zwpn = 0 end, isDisabled)
    end

    for _, d in ipairs(dropdowns) do
        Dropdowns:Dropdown(d[1], d[2], d[3], d[4], d[5], d[6], d[7])
    end

    local velu = 20
    local org = 33
    local string1 = "lamobox gui"
    local menu_x = x

    local text_width, _ = draw.GetTextSize(string1 .. " > ")

    local string1_x = menu_x - text_width+velu

    draw.Color(255, 255, 255, 255)
    draw.Text(string1_x-org, y - 15, string1 .. " > ")
    draw.Text(string1_x + text_width-org, y - 15, selctTab)
end

callbacks.Unregister( "Draw", "kigeiag")
callbacks.Register( "Draw", "kigeiag", drawMenu )

local confg = {}

local function CreateCFG(folder_name, table)
    local selectedOption = menu.Dropdowns.cfgOptions[menu.Dropdowns.cfgDropdownVar]
    local success, fullPath = filesystem.CreateDirectory(folder_name)
    local filepath = tostring(fullPath .. "/".. selectedOption .. ".txt")
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
    local selectedOption = menu.Dropdowns.cfgOptions[menu.Dropdowns.cfgDropdownVar]
    local success, fullPath = filesystem.CreateDirectory(folder_name)
    local filepath = tostring(fullPath .. "/".. selectedOption .. ".txt")
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

--[[
local function AutoLoadCFG(folder_name)
    if menu.toggles.autoload then
        local config = LoadCFG(folder_name)
        if config then
            menu = config
        end
    end
end
]]

local function saveColorPickerConfig(configTable)
    for key, picker in pairs(colorpickers) do
        configTable[key] = picker:get_config()
    end
end

local function loadColorPickerConfig(configTable)
    for key, config in pairs(configTable) do
        if colorpickers[key] then
            colorpickers[key]:set_config(config)
        end
    end
end

local function autoLoadColorPickerConfig()
    if menu.toggles.autoload then
        if next(menu) then
            loadColorPickerConfig(menu)
        end
    end
end

local function NonMenuDraw()
    menu.Values.friendly_team = {colorpickers.friendly_team:get():unpack()}
    friendly_team_hex = rgbaToHex(table.unpack(menu.Values.friendly_team))
    menu.Values.friendly_team_invisible = {colorpickers.friendly_team_invisible:get():unpack()}
    friendly_team_invisible_hex = rgbaToHex(table.unpack(menu.Values.friendly_team_invisible))

    menu.Values.enemy_team = {colorpickers.enemy_team:get():unpack()}
    enemy_team_hex = rgbaToHex(table.unpack(menu.Values.enemy_team))
    menu.Values.enemy_team_invisible = {colorpickers.enemy_team_invisible:get():unpack()}
    enemy_team_invisible_hex = rgbaToHex(table.unpack(menu.Values.enemy_team_invisible))
    local localPlayer = entities.GetLocalPlayer()      
    if localPlayer then
        if localPlayer:GetTeamNumber() == 2 then 
            gui.SetValue("blue team color", enemy_team_hex) -- enemy 
            gui.SetValue("blue team (invisible)", enemy_team_invisible_hex)

            gui.SetValue("red team color", friendly_team_hex)
            gui.SetValue("red team (invisible)", friendly_team_invisible_hex) -- friendly 
        else
            gui.SetValue("blue team color", friendly_team_hex) -- friendly
            gui.SetValue("blue team (invisible)", friendly_team_invisible_hex)

            gui.SetValue("red team color", enemy_team_hex) -- enemy
            gui.SetValue("red team (invisible)", enemy_team_invisible_hex)
        end
    end
    menu.Values.night_mode = {colorpickers.night_mode:get():unpack()}
    night_mode_hex = rgbaToHex(table.unpack(menu.Values.night_mode))

    menu.Values.back_track = {colorpickers.back_track:get():unpack()}
    back_track_hex = rgbaToHex(table.unpack(menu.Values.back_track))
    gui.SetValue("night mode color", night_mode_hex)
    gui.SetValue("night mode", menu.misc.nightmode_scale)
    custom_input.update_keys()
    local localPlayer = entities.GetLocalPlayer() 
    if input.IsButtonPressed( KEY_END ) or input.IsButtonPressed( KEY_INSERT ) or input.IsButtonPressed( KEY_F11 ) then 
        toggleMenu()
    end
    if menu.buttons.cfg_save then 
        saveColorPickerConfig(menu)
        CreateCFG([[overhaulmenu]], menu)
    end
    if menu.buttons.cfg_load then 
        local loadedMenu = LoadCFG([[overhaulmenu]])
        if loadedMenu then
            menu = loadedMenu
            loadColorPickerConfig(menu)
        end
        if menu.Dropdowns.skyboxDropdownVar > 1 then
            applySkybox()
        end
    end

    local vmstr = menu.misc.xwpn .. " " .. menu.misc.ywpn .. " " .. menu.misc.zwpn
    local vmswyinterp = (menu.misc.wepnswyinterp / 100)
    local vmswyscale= (menu.misc.wepnswyscale / 10 )
    local aspct = (menu.misc.aspectrat - .01)
    
    local period = menu.antiaim.aadelay
    local elapsedTime = os.clock() - startTime
    local factor = (elapsedTime % period) / period

    local startValue1 = menu.antiaim.aaril1
    local endValue1 = menu.antiaim.aaril2
    local interpnum1 = interpolateNumber(startValue1, endValue1, factor)
    interpnum1 = math.floor(interpnum1 + 1)

    local startValue2 = menu.antiaim.aafek1
    local endValue2 = menu.antiaim.aafek2
    local interpnum2 = interpolateNumber(startValue2, endValue2, factor)
    interpnum2 = math.floor(interpnum2 + 1)

    --[[ cool thirdperson custom view but cant see anti aim model(
    local camz = menu.misc.cam_z
    local camx = menu.misc.cam_x
    local camy = menu.misc.cam_y
    if (client.GetConVar("cam_idealdist") ~= camz) then client.SetConVar("cam_idealdist", camz .. " ") end
    if (client.GetConVar("cam_idealdistright") ~= camx) then client.SetConVar("cam_idealdistright", camx .. " ") end
    if (client.GetConVar("cam_idealdistup") ~= camy) then client.SetConVar("cam_idealdistup", camy .. " ") end
    if menu.keybinds.third_person ~= nil then
        gui.SetValue( "thirdperson key", 0 )
        gui.SetValue( "thirdperson", 0 )
        local state, tick = input.IsButtonPressed(menu.keybinds.third_person)
        if state and tick ~= last_tick then
            if inThirdPerson then
                -- Switch to firstperson
                client.Command("firstperson", true)
                inThirdPerson = false
            else
                -- Switch to thirdperson
                client.Command("thirdperson", true)
                inThirdPerson = true
            end
            last_tick = tick
        end 
    end
    ]]

    if (client.GetConVar("tf_viewmodels_offset_override") ~= vmstr) then client.SetConVar( "tf_viewmodels_offset_override",vmstr) end
    if (client.GetConVar("cl_wpn_sway_interp") ~= vmswyinterp ) then client.SetConVar( "cl_wpn_sway_interp",vmswyinterp ) end
    if (client.GetConVar("cl_wpn_sway_scale") ~= vmswyscale ) and vmswyinterp >= .01 then client.SetConVar( "cl_wpn_sway_scale",vmswyscale) end
    if (client.GetConVar("r_aspectratio") ~= aspct) then client.SetConVar( "r_aspectratio",aspct) end

    if menu.toggles.antieim then
    gui.SetValue( "anti aim - yaw (real)", "custom" )
    gui.SetValue( "anti aim - yaw (fake)", "custom" )
    end

    if gui.GetValue( "Anti Aim" ) == 1 then
        if menu.toggles.antieim and menu.toggles.rage_aa then
            if menu.toggles.aa_dynrotril and localPlayer and localPlayer:IsAlive() then
                if (globals.RealTime() > (delays.dyn_wait + menu.antiaim.aadelay / 1000)) then 
                    menu.toggles.dyn_switch = not menu.toggles.dyn_switch
                    delays.dyn_wait = globals.RealTime()
                end
        
                if menu.toggles.dyn_switch then
                    gui.SetValue("Anti aim - custom yaw (real)", interpnum1)
                end
            end
    
            if menu.toggles.aa_dynrotfek and localPlayer and localPlayer:IsAlive() then
                if (globals.RealTime() > (delays.dyn_wait + menu.antiaim.aadelay / 1000)) then 
                    menu.toggles.dyn_switch = not menu.toggles.dyn_switch
                    delays.dyn_wait = globals.RealTime()
                end
        
                if menu.toggles.dyn_switch then
                    gui.SetValue("Anti aim - custom yaw (fake)", interpnum2)
                end
            end
    
            if menu.toggles.aa_rotril then
                local val = menu.antiaim.aaril
                gui.SetValue("Anti aim - custom yaw (real)", val)
            end
    
            if menu.toggles.aa_rotfek then
                local val = menu.antiaim.aafek
                gui.SetValue("Anti aim - custom yaw (fake)", val)
            end
    
            if menu.toggles.aa_spinril then
                local val1 = menu.antiaim.aaspinril
                if menu.toggles.invert1 then
                    val1 = -val1
                end
                gui.SetValue( "Anti Aim - custom Yaw (real)", a(gui.GetValue( "Anti Aim - custom Yaw (real)" ) + val1))
            end

            if menu.toggles.aa_spinfek then
                local val2 = menu.antiaim.aaspinfek
                if menu.toggles.invert2 then
                    val2 = -val2
                end
                gui.SetValue( "Anti Aim - custom Yaw (fake)", a(gui.GetValue( "Anti Aim - custom Yaw (fake)" ) + val2))
            end
        end

        if menu.toggles.antieim and menu.toggles.legit_aa then
            gui.SetValue( "Anti aim - custom yaw (real)", menu.antiaim.aaligit)
            gui.SetValue( "Anti aim - yaw (fake)", "custom")
            gui.SetValue( "Anti aim - custom yaw (fake)", 1)
        end
    
    end

    if menu.toggles.rijin_dt_bar then
        
        if engine.Con_IsVisible() or engine.IsGameUIVisible() then
            return
        end
        menu.Values.rjn_left = {colorpickers.rjn_left:get():unpack()}
        menu.Values.rjn_right = {colorpickers.rjn_right:get():unpack()}
        menu.Values.rjn_outline = {colorpickers.rjn_outline:get():unpack()}

        local LocalWeapon = entities.GetLocalPlayer():GetPropEntity( "m_hActiveWeapon" )
    
        draw.SetFont(smallestPixel)

        local x, y = barX4, barY4
		local bW, bH = barWidth4, barHeight3
		local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
	 
		if Lbox_Menu_Open == true then
			if IsDraggingRjn then
				if input.IsButtonDown(MOUSE_LEFT) then
					barX4 = mX - math.floor(bW * menu.rX)
					barY4 = mY - math.floor(15 * menu.rY)
				else
					IsDraggingRjn = false
				end
			else
				if IsMouseInBounds(x, y - 10, x + bW, y + bH) then
					if not input.IsButtonDown(MOUSE_LEFT) then
						menu.rX = ((mX - x) / bW)
						menu.rY = ((mY - y) / 15)
					else
						barX4 = mX - math.floor(bW * menu.rX)
						barY4 = mY - math.floor(15 * menu.rY)
						IsDraggingRjn = true
					end
				end
			end
		end

        -- Background
        draw.Color(28, 29, 38, 255)
        draw.FilledRect(barX4, barY4, math.floor(barX4 + barWidth5), barY4 + barHeight3)
    
        barWidth4 = lerp(barWidth4, vl(charge * barWidth5+.1, 10, barWidth5+.1), speed)
    
    
        -- Bar gradient
        draw.Color(table.unpack(menu.Values.rjn_left))
        draw.TexturedRect(gradientBarMask, barX4, barY4, math.floor(barX4 + barWidth4), barY4 + barHeight3)


        draw.Color(table.unpack(menu.Values.rjn_right))
        draw.TexturedRect(gradientBarMask, barX4, barY4, math.floor(barX4 + barWidth4), barY4 + barHeight3)
    
        -- Border
        --draw.OutlinedRect(barX4, barY4, math.floor(barX4 + barWidth5), barY4 + barHeight3)
        drawRectOutline(barX4, barY4, math.floor(barWidth5), barHeight3, {table.unpack(menu.Values.rjn_outline)}, 1)
    
        -- Text
        local textWidth, textHeight = draw.GetTextSize("CHARGE")
        draw.Color(255, 255, 255, 255)
        draw.Text(barX4 + 2, barY4 - textHeight - 1, "CHARGE")
    
        -- DT State Text
        local dtStateText = "READY";
    
        if charge == 0 then
            draw.Color(207, 51, 42, 255)
            dtStateText = "NO CHARGE";
    
        elseif charging then
            dtStateText = "CHARGING";
            draw.Color(255, 168, 29, 255)
    
        elseif charge ~= 1 then
            draw.Color(207, 51, 42, 255)
            dtStateText = "NOT ENOUGH CHARGE";
    
        elseif (warp.CanDoubleTap(LocalWeapon)) and ((entities.GetLocalPlayer():GetPropInt( "m_fFlags" )) & FL_ONGROUND) == 1 and charge == 1 then
             dtStateText = "READY";
             draw.Color(10, 188, 105, 255)
        elseif not (warp.CanDoubleTap(LocalWeapon)) and charge == 1 then
                draw.Color(207, 51, 42, 255)
    
                dtStateText = "DT IMPOSSIBLE";
        else
            draw.Color(247, 219, 59, 255)
    
            dtStateText = "WAIT";
            end
    
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize(dtStateText);
    
        draw.Text(math.floor(barX4 + barWidth5 - dtStateTextWidth+2), barY4 - dtStateTextHeight - 1, dtStateText)

     end
end
material:StudioSetColorModulation( color:Color )
material:StudioSetAlphaModulation( alpha:number )

-- draws chams
local localPlayerCounter = 0

local function onDrawModel( drawModelContext )
    local entity = drawModelContext:GetEntity()
    if not entity or not entity:IsValid() then
        return
    end

    local localPlayer = entities.GetLocalPlayer()
    if not localPlayer then return end

    local entityTeam = entity:GetTeamNumber()
    

    local localTeam = localPlayer:GetTeamNumber()
    local class = entity:GetClass()

    menu.Values.red_team_chams = {colorpickers.red_team_chams:get():unpack()}
    menu.Values.blue_team_chams = {colorpickers.blue_team_chams:get():unpack()}
    menu.Values.red_team_tint = {colorpickers.red_team_tint:get():unpack()}
    menu.Values.blue_team_tint = {colorpickers.blue_team_tint:get():unpack()}
    menu.Values.enemy_based_chams = {colorpickers.enemy_based_chams:get():unpack()}
    menu.Values.enemy_based_chams_tint = {colorpickers.enemy_based_chams_tint:get():unpack()}
    menu.Values.friendly_chams = {colorpickers.friendly_team_chams:get():unpack()}
    menu.Values.friendly_chams_tint = {colorpickers.friendly_team_tint:get():unpack()}

    local function applyChams(material, colors, tints)
        if material and #colors == 4 and #tints == 4 then
            material:SetShaderParam('$envmaptint', Vector3(tints[1] / 255, tints[2] / 255, tints[3] / 255))
            material:SetShaderParam('$color2', Vector3(colors[1] / 255, colors[2] / 255, colors[3] / 255))
            material
            drawModelContext:ForcedMaterialOverride(material)
        end
    end

    if entity and localPlayer and (entity:GetClass() == "CTFPlayer" or entity:GetClass() == "CTFWearable") then
        local player = entity:GetClass() == "CTFPlayer" and entity or entity:GetPropEntity("m_hOwnerEntity")
        if menu.toggles.chams and menu.toggles.team_based then
            local selectedOption = menu.Dropdowns.chamsOptions[menu.Dropdowns.DropdownVar]
            local material = chamsMaterials[selectedOption]
    
            if not menu.toggles.enemy_only then
                if entityTeam == 2 then  -- Red team
                    applyChams(material, menu.Values.red_team_chams, menu.Values.red_team_tint)
                elseif entityTeam == 3 then  -- Blue team
                    selectedOption = menu.Dropdowns.chamsOptions[menu.Dropdowns.anotherDropdownVar]
                    material = chamsMaterials[selectedOption]
                    applyChams(material, menu.Values.blue_team_chams, menu.Values.blue_team_tint)
                end
            elseif entityTeam ~= localTeam then
                if localTeam == 2 then
                    selectedOption = menu.Dropdowns.chamsOptions[menu.Dropdowns.anotherDropdownVar]
                    material = chamsMaterials[selectedOption]
                    applyChams(material, menu.Values.blue_team_chams, menu.Values.blue_team_tint)
                elseif localTeam == 3 then
                    applyChams(material, menu.Values.red_team_chams, menu.Values.red_team_tint)
                end
            end
        end
        
        if menu.toggles.enemy_based and menu.toggles.chams1 then
            local selectedOption = menu.Dropdowns.chamsOptions[menu.Dropdowns.DropdownVar]
            local material = chamsMaterials[selectedOption]
    
            if entityTeam ~= localTeam then
                applyChams(material, menu.Values.enemy_based_chams, menu.Values.enemy_based_chams_tint)
            elseif not menu.toggles.enemy_only then
                selectedOption = menu.Dropdowns.chamsOptions[menu.Dropdowns.anotherDropdownVar]
                material = chamsMaterials[selectedOption]
                applyChams(material, menu.Values.friendly_chams, menu.Values.friendly_chams_tint)
            end
        end

        if menu.toggles.fake_ang then
            local selectedOption = menu.Dropdowns.chamsOptions[menu.Dropdowns.fakeDropdownVar]
            local material = chamsMaterials[selectedOption]

            if player:GetIndex() == localPlayer:GetIndex() then
                if entity:GetClass() == "CTFPlayer" then
                    if gui.GetValue("anti aim indicator") == 1 and gui.GetValue("anti aim") == 1 then
                        localPlayerCounter = localPlayerCounter + 1
                        if localPlayerCounter > 1 then
                            localPlayerCounter = 0
                            applyChams(material, menu.Values.localplr_chams, menu.Values.localplr_chams_tint)
                            return
                        end
                    else
                        localPlayerCounter = 0
                    end
                end
            end
        end
    
        if menu.toggles.local_player then
            local selectedOption = menu.Dropdowns.chamsOptions[menu.Dropdowns.localDropdownVar]
            local material = chamsMaterials[selectedOption]
    
            if localPlayer == entity then
                applyChams(material, menu.Values.localplr_chams, menu.Values.localplr_chams_tint)
            end
        end

        
    end
    
   
end

local player = entities.GetLocalPlayer()
local function isHoldingRocketLauncher()
    local activeWeapon = player:GetPropEntity("m_hActiveWeapon")
    return activeWeapon and activeWeapon:GetClass() == "CTFRocketLauncher" and activeWeapon or nil
end

local function RocketJump(cmd)
    if input.IsButtonPressed(KEY_END) or input.IsButtonPressed(KEY_INSERT) or input.IsButtonPressed(KEY_F11) then 
        toggleMenu()
    end
    if Lbox_Menu_Open then return end

    if not player:IsValid() then player = entities.GetLocalPlayer() end
    if not player then return end

    local rocketLauncher = isHoldingRocketLauncher()
    if not rocketLauncher then return end
    
    if menu.toggles.rocket_jump and menu.keybinds.rocket_jump ~= nil and input.IsButtonPressed(menu.keybinds.rocket_jump) then
        local viewAngles = engine.GetViewAngles()
        viewAngles.pitch = 75
        viewAngles.yaw = viewAngles.yaw + angleOffset
        viewAngles:Normalize()
        
        cmd.viewangles = Vector3(viewAngles.pitch, viewAngles.yaw, 0)
        cmd.buttons = cmd.buttons | IN_ATTACK
        holdStartTime = globals.RealTime()
    end

    if globals.RealTime() - holdStartTime < holdDuration then
        cmd.buttons = cmd.buttons | IN_JUMP | IN_DUCK
    end
end

callbacks.Register("CreateMove", RocketJump)
--[[
local DETONATION_RADIUS = menu.misc.detonate_radius
local DEMOMAN_CLASS = 4

local function Ownedstickies(entity)
    local result = {}
    local bombs = entities.FindByClass("CTFGrenadePipebombProjectile")
    for _, bomb in pairs(bombs) do
        if not bomb:IsDormant() then
            local owner = bomb:GetPropEntity("m_hLauncher")
            if owner and owner:GetPropEntity("m_hOwnerEntity") == entity then
                table.insert(result, bomb)
            end
        end
    end
    return result
end

local function isEntityInRange(sticky, entity)
    local stickyPos = sticky:GetAbsOrigin()
    local entityPos = entity:GetAbsOrigin()
    local distance = (stickyPos - entityPos):Length()
    return distance <= DETONATION_RADIUS
end

local function isEntityVisible(sticky, entity)
    local trace = engine.TraceLine(sticky:GetAbsOrigin(), entity:GetAbsOrigin(), MASK_SHOT) -- Traces a line between the sticky and the enemy
    return trace.fraction == 1 -- If fraction == 1, there's a clear line of sight
end

local function autoDetonateSticky(cmd)
    local me = entities.GetLocalPlayer()
    if not me or not me:IsAlive() or me:GetPropInt("m_iClass") ~= DEMOMAN_CLASS then return end

    local myBombs = Ownedstickies(me)
    local enemies = entities.FindByClass("CTFPlayer")

    for _, enemy in pairs(enemies) do
        if enemy and enemy:IsAlive() and enemy:GetTeamNumber() ~= me:GetTeamNumber() and menu.toggles.auto_detonate then
            local stickiesInRange = 0

            for _, sticky in pairs(myBombs) do
                if isEntityInRange(sticky, enemy) and isEntityVisible(sticky, enemy) then
                    stickiesInRange = stickiesInRange + 1
                end
            end

            if stickiesInRange >= menu.misc.minStickies then
                for _, sticky in pairs(myBombs) do
                    if menu.toggles.preventDetonationlocalPlayer and isEntityInRange(sticky, me) then
                        return
                    end
                end
                cmd.buttons = cmd.buttons | IN_ATTACK2
                return
            end
        end
    end
end

callbacks.Register("CreateMove", "autoDetonateSticky", autoDetonateSticky)
]]


callbacks.Register( "Draw", "wsaterstfs", NonMenuDraw )
--callbacks.Register( "DrawModel", "hook123", onDrawModel )

local t = globals.TickCount()
client.Command("clear", true)
local function OnLoad()
    --[[
    client.RemoveConVarProtection( "cam_idealdist" )
    client.RemoveConVarProtection( "cam_idealdistright" )
    client.RemoveConVarProtection( "cam_idealdistup" )
    client.RemoveConVarProtection( "thirdperson" )
    client.RemoveConVarProtection( "firstperson" )
    client.SetConVar( "sv_cheats", 1 .. " " )
    client.SetConVar( "cam_ideallag", 0 .. " " )
    ]]
    CreateCFG([[overhaulmenu]], menu)
    local lines = {"menu loaded"}
    local clr1 = {115, 119, 255}
    local clr2 = {224, 173, 199}
    if t < globals.TickCount() + 1 then
        -- AutoLoadCFG([[overhaulmenu]])
        autoLoadColorPickerConfig()
        for i = 1, #lines do
            local t = i / #lines
            local clr = {
                math.floor(clr1[1] + (clr2[1] - clr1[1]) * t),
                math.floor(clr1[2] + (clr2[2] - clr1[2]) * t),
                math.floor(clr1[3] + (clr2[3] - clr1[3]) * t)
            }
            printc(clr[1], clr[2], clr[3], 255, lines[i])
        end
        callbacks.Unregister( "Draw", "onload" )
    end
end
callbacks.Register( "Draw", "onload", OnLoad )
callbacks.Register("CreateMove", function(cmd)
    updateBarCharge()
end)

callbacks.Unregister("Unload", "unlod")
callbacks.Register("Unload", "unlod", OnUnload)


