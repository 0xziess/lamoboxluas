--[[
creds to muqa for this cool menu and functions https://github.com/Muqa1/Muqa-LBOX-pastas/blob/main/Release%20misc%20tools.lua
creds to LNX for the rounded corners from this menu https://github.com/lnx00/Lmaobox-Lua/blob/main/src/PoC/WinUI.lua 
creds to 11x1 for the colorpicker from his amazing espbuilder lua https://github.com/11x1/Lua/blob/main/Lmaobox.net/espbuilder/espbuilder.lua
]]--
local menu = {
    x = 500,
    y = 500,

    w = 405,
    h = 365,

    rX = 0,
    rY = 0,

    tabs = {
        tab_1 = true,
        tab_2 = false,
        tab_3 = false,
        tab_4 = false,
    },

    buttons = {
        main = false,
        colors = false,
        misc = false,
        antiaim = false,

        cfg_load = false,
        cfg_save = false,
    },

    toggles = {
        keybinde_menu = false,
        nitro_dt_bar = false,
        ateris_dt_bar = false,
        monkey_dt_bar = false,
        rijin_dt_bar = false,

        ateris_spec_list = false,
        nitro_spec_list = false,
        rijin_spec_list = false,

        dyn_switch = false,
        antieim = true,

        aimbot = true,
        crits = true,
        dtky = true,
        rechrge = true,
        thrdperson = true,
        fakeleg = true,
        werp = true,
        triggerbt = true,
        triggersht = true,

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

    },

    misc = { 
        aspectrat = 0.0,
        wepnswyinterp = 1,
        wepnswyscale = 0,

        xwpn = 0,
        ywpn = 0,
        zwpn = 0,
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

    Values = { -- colors
        NitroKeybind = {194, 83, 83, 255},
        NitroKeybindBackground = {41, 42, 46, 255},
        NitroDtBar = {255, 134, 42, 255},
        AterisDtBar = {205, 42, 46, 255},
        MonkeyBotDtBar = {255, 15, 255, 255},
        
        RijinDtBarLeft = {1, 25, 31, 255, 255},
        RijinDtBarRight = {67, 213, 250, 255},
        RijinDtBarOutline = {255, 255, 255, 255},
    },
    
}


local title = draw.CreateFont( "Roboto Medium", 23, 500 )
local binds = draw.CreateFont( "Arial", 18, 1000 )

local textcolorwhenoff = {120, 120, 120, 250}

local nitrofont = draw.CreateFont('Verdana', 15, 1000, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)
local nitrofont2 = draw.CreateFont('Tahoma', 16, 1000, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE)

local rjnfont = draw.CreateFont("Smallest Pixel", 13, 400, FONTFLAG_OUTLINE, 1)
local chargetxt = draw.CreateFont("Smallest Pixel", 16, 400, FONTFLAG_OUTLINE, 1)
local smallestPixel = draw.CreateFont("Smallest Pixel", 11, 400, FONTFLAG_OUTLINE, 1)

local tglbtn = draw.CreateFont("Smallest Pixel", 18, 400, FONTFLAG_OUTLINE, 1)

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
    
        if self.hovered and is_m1_pressed then
            self.open = not self.open
        end
    
        if self.open then
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

local colorpicker1, colorpicker2, colorpicker3, colorpicker4, colorpicker5, colorpicker6, colorpicker7, colorpicker8
local colorpickerX, colorpickerY

local function initializeclrpickers()
    colorpickerX = menu.x + 118
    colorpickerY = menu.y - 123
    colorpicker1 = options.new_colorpicker("", color(table.unpack(menu.Values.NitroKeybind)), colorpickerX, colorpickerY)
    colorpicker2 = options.new_colorpicker("", color(table.unpack(menu.Values.NitroKeybindBackground)), colorpickerX, colorpickerY)
    colorpicker3 = options.new_colorpicker("", color(table.unpack(menu.Values.NitroDtBar)), colorpickerX, colorpickerY)
    colorpicker4 = options.new_colorpicker("", color(table.unpack(menu.Values.AterisDtBar)), colorpickerX, colorpickerY)
    colorpicker5 = options.new_colorpicker("", color(table.unpack(menu.Values.MonkeyBotDtBar)), colorpickerX, colorpickerY)
    colorpicker6 = options.new_colorpicker("", color(table.unpack(menu.Values.RijinDtBarLeft)), colorpickerX, colorpickerY)
    colorpicker7 = options.new_colorpicker("", color(table.unpack(menu.Values.RijinDtBarRight)), colorpickerX, colorpickerY)
    colorpicker8 = options.new_colorpicker("", color(table.unpack(menu.Values.RijinDtBarOutline)), colorpickerX, colorpickerY)
end

initializeclrpickers()

callbacks.Register("Draw", function()
    local newX = menu.x + 118
    local newY = menu.y - 123

    if newX ~= colorpickerX or newY ~= colorpickerY then
        colorpickerX = newX
        colorpickerY = newY
        colorpicker1 = options.new_colorpicker("", color(table.unpack(menu.Values.NitroKeybind)), colorpickerX, colorpickerY)
        colorpicker2 = options.new_colorpicker("", color(table.unpack(menu.Values.NitroKeybindBackground)), colorpickerX, colorpickerY)
        colorpicker3 = options.new_colorpicker("", color(table.unpack(menu.Values.NitroDtBar)), colorpickerX, colorpickerY)
        colorpicker4 = options.new_colorpicker("", color(table.unpack(menu.Values.AterisDtBar)), colorpickerX, colorpickerY)
        colorpicker5 = options.new_colorpicker("", color(table.unpack(menu.Values.MonkeyBotDtBar)), colorpickerX, colorpickerY)
        colorpicker6 = options.new_colorpicker("", color(table.unpack(menu.Values.RijinDtBarLeft)), colorpickerX, colorpickerY)
        colorpicker7 = options.new_colorpicker("", color(table.unpack(menu.Values.RijinDtBarRight)), colorpickerX, colorpickerY)
        colorpicker8 = options.new_colorpicker("", color(table.unpack(menu.Values.RijinDtBarOutline)), colorpickerX, colorpickerY)
    end
end)

--[COLORPICKER END]--

local function unrequire(m) package.loaded[m] = nil _G[m] = nil end

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
local Textures = lnxLib.UI.Textures

---@alias Context { Rect: number[] }

--[[ Vars ]]

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


function interpolateNumber(startValue, endValue, factor)
    factor = math.sin(factor * math.pi * 2) * 0.5 + 0.5
    
    local interpolatedValue = startValue * (1 - factor) + endValue * factor
    
    return interpolatedValue
end

local tahoma = draw.CreateFont( "Tahoma", 12, 400, FONTFLAG_OUTLINE )
local tahoma2 = draw.CreateFont( "Tahoma", 12, 400)
local tahoma_bold = draw.CreateFont( "Tahoma", 12, 800, FONTFLAG_OUTLINE )

local f = math.floor

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



function Round(num)
    if num >= 0 then
        return math.floor(num + 0.5)
    else
        return math.ceil(num - 0.5)
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
    local clr = {24, 87, 120, 80}
    if IsMouseInBounds(table.unpack(pos)) and input.IsButtonPressed(MOUSE_LEFT) then
        local currentTime = globals.RealTime()
        if currentTime - (Toggles[toggle_bool] or 0) >= 0.1 then
            menu.toggles[toggle_bool] = not menu.toggles[toggle_bool]
            Toggles[toggle_bool] = currentTime

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
        clr = {65, 65, 65, 50}
    end
    draw.Color(table.unpack(clr))
    draw.FilledRect(table.unpack(pos))
    draw.Color(255, 255, 255, 255)
    draw.Text(pos[3]+5,y+f(h/4), name)
    if menu.toggles[toggle_bool] == true then
        draw.Color(255, 27, 45, 255)
        draw.SetFont( tglbtn )
        draw.Text( f(pos[3]-13),f(y-1), "x" )
        draw.Color(2, 31, 46, 255)
        draw.OutlinedRect(table.unpack(pos))
        draw.SetFont( tahoma )
    end
    if menu.toggles[toggle_bool] == false then
        draw.Color(2, 31, 46, 255)
        draw.OutlinedRect(table.unpack(pos))
    end
end

local Toggles2 = {}
local function Toggle2(x, y, name, toggle_bool)
    local w, h = draw.GetTextSize(name)
    local pos = {x, y, x + 35, y + 20}
    if Toggles2[toggle_bool] == nil then
        table.insert(Toggles2, toggle_bool)
    end
    local clr = {10, 10, 10, 50}
    if IsMouseInBounds(table.unpack(pos)) and input.IsButtonPressed(MOUSE_LEFT) then
        local currentTime = globals.RealTime()
        if currentTime - (Toggles2[toggle_bool] or 0) >= 0.1 then
            menu.toggles[toggle_bool] = not menu.toggles[toggle_bool]
            Toggles2[toggle_bool] = currentTime
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
        draw.Color(80, 255, 80, 255)
        draw.OutlinedRect(table.unpack(pos))
        draw.FilledRect(pos[1] + 20 , pos[2] + 5, pos[3] - 5, pos[4] - 5)
    else
        draw.Color(255, 100, 100, 255)
        draw.OutlinedRect(table.unpack(pos))
        draw.FilledRect(pos[1] + 5 , pos[2] + 5, pos[3] - 20, pos[4] - 5)
    end
end

local function Island(x,y,x2,y2, name)
    local r,g,b = 2, 106, 209
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
    local value = menu.misc[sliderValue] or menu.antiaim[sliderValue]
    if IsMouseInBounds(x,y - 5,x2,y2 + 5) and input.IsButtonDown(MOUSE_LEFT) then 
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
    draw.Color(10,10,10,50)
    draw.FilledRect(x,y,x2,y2)
    local r,g,b = 2, 106, 209
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

local function Slider2(x,y,x2,y2, sliderValue ,min,max, name)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    local value = menu.misc[sliderValue] or menu.antiaim[sliderValue]
    if IsMouseInBounds(x,y - 5,x2,y2 + 5) and input.IsButtonDown(MOUSE_LEFT) then 
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
    draw.Color(10,10,10,50)
    draw.FilledRect(x,y,x2,y2)
    local r,g,b = 2, 106, 209
    draw.Color(r,g,b,40)
    local sliderWidth = math.floor((x2 - x) * (value - min) / (max - min))
    local pos = {x, y, x + sliderWidth, y2}
    draw.FilledRect(table.unpack(pos))
    draw.Color(r,g,b,255)
    draw.OutlinedRect(table.unpack(pos))
    draw.Color(255,255,255,255)
    local w,h = draw.GetTextSize(value)
    draw.Text(x2-w, pos[2]-h, value)
    w,h = draw.GetTextSize(name)
    draw.Text(x, pos[2]-h, name)
end

local function CFGbutton(x,y,x2,y2,name,button)
    local clr = {2, 106, 209}
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
    local r,g,b = 2, 106, 209
    string = string
    local w,h = draw.GetTextSize(string)
    local padding = 5
    draw.Color(r,g,b,f(50*alphaProcent))
    draw.FilledRect(x-padding,y-padding,x+w+padding,y+h+padding)
    draw.Color(r, g, b, f(255*alphaProcent))
    draw.OutlinedRect(x-padding, y-padding, x+w+padding,y+h+padding)
    draw.Color(255,255,255,f(255*alphaProcent))
    draw.Text(x,y,string)
end

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

local function brightenColor(color, amount)
    return {
        math.min(color[1] + amount, 255),
        math.min(color[2] + amount, 255),
        math.min(color[3] + amount, 255),
        color[4]
    }
end

local function interpolateColor(color1, color2, factor)
    factor = math.min(factor, 1)
    local result = {}
    for i = 1, 3 do
        local c1 = color1[i] or 0
        local c2 = color2[i] or 0
        result[i] = math.floor(lerp(c1, c2, factor))
    end
    result[4] = 255
    return result
end
local colorTop2 = {255, 255, 255}
local colorMiddle2 = {115, 115, 115}
local colorBottom2 = {255, 255, 255}
local gradientBarMaskCustom2 = createCustomGradientBarMask(colorTop2, colorMiddle2, colorBottom2)

local function vl(value, min, max)
    return math.max(min, math.min(value, max))
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

local transparent_rect_color = {15, 15, 15, 200}

local x5, y5 = menu.x, menu.y
local bW, bH = menu.w, menu.h

local IsDragging = false
local IsDragging2 = false
local IsDragging3 = false
local IsDragging4 = false
local IsDragging5 = false
local IsDragging6 = false

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

local startTime = os.clock()

local buttons = {
    [1] = {name="Main", table="main", tab="tab_1"},
    [2] = {name="Colors", table="colors", tab="tab_2"},
    [3] = {name="Misc", table="misc", tab="tab_3"},
    [4] = {name="Anti-Aim", table="antiaim", tab="tab_4"},
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

    draw.Color( 3, 127, 252, 255 )
    draw.OutlinedRect(x, y - 15, x + bW, y + bH) -- outline to the main menu
    draw.OutlinedRect(x, y - 15, x + bW, y) -- outline of top bar

    draw.Color( 2, 79, 156,150 )
    draw.FilledRect(x, y - 15, x + bW, y) -- top bar

    local string = "stuff.."
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
        local pos = {x + 5, y + startY + 5, x + 85, y + startY + 25}
        local clr = {10, 10, 10, 50}
        local clr2 = {2, 106, 209, 40}
    
        if IsMouseInBounds(table.unpack(pos)) and input.IsButtonPressed(MOUSE_LEFT) then 
            clr = {40, 40, 40, 50}
            menu.buttons[button.table] = true
        else
            menu.buttons[button.table] = false
        end
    
        for tab, isActive in pairs(menu.tabs) do
            if isActive and tab == button.tab then
                clr2 = {23, 252, 65, 50}
                break
            end
        end
        
        draw.Color(table.unpack(clr))
        draw.FilledRect(table.unpack(pos))
        draw.Color(table.unpack(clr2))
        draw.OutlinedRect(table.unpack(pos))
        draw.Color(255, 255, 255, 255)
        TextInCenter(pos[1], pos[2], pos[3], pos[4], button.name)
        startY = startY + 25
    end

    if menu.buttons.main then 
        menu.tabs.tab_1=true
        menu.tabs.tab_2=false
        menu.tabs.tab_3=false
        menu.tabs.tab_4=false
    end
    if menu.buttons.colors then 
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

    if menu.buttons.antiaim then 
        menu.tabs.tab_1=false
        menu.tabs.tab_2=false
        menu.tabs.tab_3=false
        menu.tabs.tab_4=true
    end

    draw.Color(45, 45, 45, 255)
    draw.Line(x+90,y+1, x+90, y+bH-1)

    CFGbutton(x+5, y+bH-20,x+46, y+bH-5,"Load", "cfg_load")
    CFGbutton(x+48, y+bH-20,x+87, y+bH-5,"Save", "cfg_save")
    x = x + 90
    local x1,y1 = x+5, y+20
    if menu.tabs.tab_1 then
        menu.w = 250
        menu.h = 185

        Island(x1,y1,x1+150,y1+160,"Stuff")
        Toggle(x1+5, y1+5,"Nitro Keybinds", "keybinde_menu")
        Toggle(x1+5, y1+35,"Nitro DT Bar", "nitro_dt_bar")
        Toggle(x1+5, y1+65,"Ateris DT Bar", "ateris_dt_bar")
        Toggle(x1+5, y1+95,"MoneyBot Dt Bar", "monkey_dt_bar")
        Toggle(x1+5, y1+125,"Rijin Dt Bar", "rijin_dt_bar")
        
    end

    if menu.tabs.tab_2 then
        menu.w = 350
        menu.h = 250
        local w5 = 200
        

        Island(x1+5,y1,x1+175,y1+65,"Nitro")
        draw.Text(x1+10,y1+5,"Keybinds toggled ON + Line")
        draw.Text(x1+10,y1+20,"Keybinds Background")
        draw.Text(x1+10,y1+40,"DT Bar")
        colorpicker1:render(vector(x1-28, y1), w5)
        colorpicker2:render(vector(x1-55, y1+15), w5)
        colorpicker3:render(vector(x1-125, y1+35), w5)

        Island(x1+180,y1,x1+250,y1+65,"Ateris")
        draw.Text(x1+185,y1+5,"DT Bar")
        colorpicker4:render(vector(x1+52, y1), w5)

        Island(x1+180,y1+85,x1+250,y1+150,"MoneyBot")
        draw.Text(x1+185,y1+90,"DT Bar")
        colorpicker5:render(vector(x1+52, y1+85), w5)
        
        Island(x1+5,y1+85,x1+175,y1+150,"Rijin")
        draw.Text(x1+10,y1+90,"DT Bar Left Gradient")
        draw.Text(x1+10,y1+110,"DT Bar Right Gradient")
        draw.Text(x1+10,y1+130,"DT Bar Outline")
        colorpicker6:render(vector(x1-65, y1+85), w5)
        colorpicker7:render(vector(x1-58, y1+105), w5)
        colorpicker8:render(vector(x1-90, y1+125), w5)
    end

    if menu.tabs.tab_3 then
        menu.w = 450
        menu.h = 185

        Island(x1+5,y1,x1+170,y1+45,"Aspect Ratio")
        Slider2(x1+10,y1+25,x1+160,y1+35, "aspectrat" ,0,2, "")

        Island(x1+175,y1,x1+320,y1+65,"Weapon Sway")
        Slider(x1+180,y1+15,x1+310,y1+25, "wepnswyinterp" ,1,100, "Interp")
        Slider(x1+180,y1+45,x1+310,y1+55, "wepnswyscale" ,0,100, "Scale")

        Island(x1+5,y1+65,x1+170,y1+160,"Viewmodel Position")
        Slider2(x1+10,y1+85,x1+160,y1+95, "xwpn" ,-50,50, "X")
        Slider2(x1+10,y1+115,x1+160,y1+125, "ywpn" ,-50,50, "Y")
        Slider2(x1+10,y1+145,x1+160,y1+155, "zwpn" ,-50,50, "Z")
        
    end

    if menu.tabs.tab_4 then
        menu.w = 415
        menu.h = 125
        local mk1 = 10

        Island(x1+mk1-10,y1,x1+mk1+140,y1+55,"Main")
        Toggle(x1+mk1-5,y1+5,"Enable AA", "antieim")
        Slider2(x1+mk1-5,y1+42,x1+mk1+135,y1+52, "aadelay" ,.2,10, "Delay")

        if menu.toggles.antieim then
            Island(x1+170,y1,x1+310,y1+55,"Type AA")
            Toggle(x1+175,y1+5,"Rage AA", "rage_aa")
            Toggle(x1+175,y1+29,"Legit AA", "legit_aa")

            if menu.toggles.rage_aa then
                menu.h = 275
                Island(x1+5,y1+75,x1+150,y1+155,"Real AA Method")
                Toggle(x1+mk1+5,y1+80,"Rotate", "aa_rotril")
                Toggle(x1+mk1+5,y1+105,"Rotate Dynamic", "aa_dynrotril")
                Toggle(x1+mk1+5,y1+130,"Spin", "aa_spinril")

                Island(x1+170,y1+75,x1+315,y1+155,"Fake AA Method")
                Toggle(x1+mk1+170,y1+80,"Rotate", "aa_rotfek")
                Toggle(x1+mk1+170,y1+105,"Rotate Dynamic", "aa_dynrotfek")
                Toggle(x1+mk1+170,y1+130,"Spin", "aa_spinfek")

                if menu.toggles.aa_dynrotril then
                Island(x1+5,y1+180,x1+150,y1+250,"Real AA")
                Slider(x1+10,y1+200,x1+140,y1+210, "aaril1" ,-360,360, "Real Angle 1")
                Slider(x1+10,y1+230,x1+140,y1+240, "aaril2" ,-360,360, "Real Angle 2")
                end

                if menu.toggles.aa_dynrotfek then
                Island(x1+170,y1+180,x1+315,y1+250,"Fake AA")
                Slider(x1+175,y1+200,x1+305,y1+210, "aafek1" ,-360,360, "Fake Angle 1")
                Slider(x1+175,y1+230,x1+305,y1+240, "aafek2" ,-360,360, "Fake Angle 2")
                end

                if menu.toggles.aa_rotril then
                Island(x1+5,y1+180,x1+150,y1+250,"Real AA")
                Slider(x1+10,y1+200,x1+140,y1+210, "aaril" ,-180,180, "Real Angle")
                end

                if menu.toggles.aa_rotfek then
                Island(x1+170,y1+180,x1+315,y1+250,"Fake AA")
                Slider(x1+175,y1+200,x1+305,y1+210, "aafek" ,-180,180, "Fake Angle")
                end
                
                if menu.toggles.aa_spinril then
                Island(x1+5,y1+180,x1+150,y1+250,"Real AA")
                Slider(x1+10,y1+200,x1+140,y1+210, "aaspinril" ,1,10, "Spin Speed")
                Toggle(x1+10,y1+220,"Inverted", "invert1")
                end

                if menu.toggles.aa_spinfek then
                Island(x1+170,y1+180,x1+315,y1+250,"Fake AA")
                Slider(x1+175,y1+200,x1+305,y1+210, "aaspinfek" ,1,10, "Spin Speed")
                Toggle(x1+175,y1+220,"Inverted", "invert2")
                end

            elseif menu.toggles.legit_aa then
                menu.h = 150
                Island(x1+85,y1+75,x1+205,y1+120,"Legit AA")
                Slider(x1+90,y1+95,x1+200,y1+110, "aaligit" ,-180,180, "Real Angle")
            end

        end
   
    end

end
callbacks.Unregister( "Draw", "awftgybhdunjmiko")
callbacks.Register( "Draw", "awftgybhdunjmiko", DrawMenu )


local confg = {}


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

-- Function to save the configuration for all color pickers
local function saveColorPickerConfig(configTable)
    configTable.colorpicker1 = colorpicker1:get_config()
    configTable.colorpicker2 = colorpicker2:get_config()
    configTable.colorpicker3 = colorpicker3:get_config()
    configTable.colorpicker4 = colorpicker4:get_config()
    configTable.colorpicker5 = colorpicker5:get_config()
    configTable.colorpicker6 = colorpicker6:get_config()
    configTable.colorpicker7 = colorpicker7:get_config()
    configTable.colorpicker8 = colorpicker8:get_config()
end

-- Function to load the configuration for all color pickers
local function loadColorPickerConfig(configTable)
    if configTable.colorpicker1 then
        colorpicker1:set_config(configTable.colorpicker1)
    else
        print("Error: No colorpicker1 configuration found in config table")
    end

    if configTable.colorpicker2 then
        colorpicker2:set_config(configTable.colorpicker2)
    else
        print("Error: No colorpicker2 configuration found in config table")
    end

    if configTable.colorpicker3 then
        colorpicker3:set_config(configTable.colorpicker3)
    else
        print("Error: No colorpicker3 configuration found in config table")
    end

    if configTable.colorpicker4 then
        colorpicker4:set_config(configTable.colorpicker4)
    else
        print("Error: No colorpicker4 configuration found in config table")
    end

    if configTable.colorpicker5 then
        colorpicker5:set_config(configTable.colorpicker5)
    else
        print("Error: No colorpicker4 configuration found in config table")
    end

    if configTable.colorpicker6 then
        colorpicker6:set_config(configTable.colorpicker6)
    else
        print("Error: No colorpicker4 configuration found in config table")
    end

    if configTable.colorpicker7 then
        colorpicker7:set_config(configTable.colorpicker7)
    else
        print("Error: No colorpicker4 configuration found in config table")
    end

    if configTable.colorpicker8 then
        colorpicker8:set_config(configTable.colorpicker8)
    else
        print("Error: No colorpicker4 configuration found in config table")
    end
end

local delays = {
    dyn_wait = 0,
}

local logs = {}

local sW,sH = draw.GetScreenSize()

local screenX, screenY = draw.GetScreenSize()
local barX = math.floor(screenX / 2 - barWidth / 2)
local barY = math.floor(screenY / 2) + barOffset
local x1, y1, width, height = 50, 980, 320, 280

local barX1 = math.floor(screenX / 2 - barW / 2)
local barY1 = math.floor(screenY / 2) + 50

local barX2 = math.floor(screenX / 2 - rectWidth / 2)
local barY2 = math.floor(screenY / 2) + barOffset

local recX = math.floor(screenX / 2 - rectWidth / 2)
local recY = math.floor(screenY / 2) + barOffset - 25

local barX4 = math.floor(screenX / 2 - barWidth5 / 2)
local barY4 = math.floor(screenY / 2) + barOffset

local function NonMenuDraw()
    custom_input.update_keys()
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
    
    local y2 = y1

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
        saveColorPickerConfig(menu)  -- Save the color picker configs to the menu table
        CreateCFG([[menusss]], menu) -- Save the entire menu table to the file
        table.insert(notifications, 1, {time = globals.CurTime(), text = "saved cfg"})
    end
    
    if menu.buttons.cfg_load then 
        local loadedMenu = LoadCFG([[menusss]])
        if loadedMenu then
            menu = loadedMenu
            loadColorPickerConfig(menu)  -- Load the color picker configs from the menu table
            table.insert(notifications, 1, {time = globals.CurTime(), text = "loaded cfg"})
        else
            table.insert(notifications, 1, {time = globals.CurTime(), text = "failed to load cfg"})
        end
    end

    local keybindHeight = height
    local keybindWidth = width
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
            if menu.toggles.aa_dynrotril then
                if (globals.RealTime() > (delays.dyn_wait + menu.antiaim.aadelay / 1000)) then 
                    menu.toggles.dyn_switch = not menu.toggles.dyn_switch
                    delays.dyn_wait = globals.RealTime()
                end
        
                if menu.toggles.dyn_switch then
                    gui.SetValue("Anti aim - custom yaw (real)", interpnum1)
                end
            end
    
            if menu.toggles.aa_dynrotfek then
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
            gui.SetValue( "Anti aim - custom yaw (fake)", 1 )
            gui.SetValue( "Anti aim - custom yaw (real)", menu.antiaim.aaligit)
        end
    
    end

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

              local chosen_color1 = colorpicker1:get()
              menu.Values.NitroKeybind = {chosen_color1:unpack()}

              local chosen_color2 = colorpicker2:get()
              menu.Values.NitroKeybindBackground = {chosen_color2:unpack()}
            
                draw.SetFont(title)
                draw.Color( table.unpack(menu.Values.NitroKeybindBackground))
                RoundedRect(posX, posY, posX + width, posY + keybindHeight, 6)
            
                draw.Color( 255, 255, 255, 255 )
                draw.Text( 20 + posX, 10 + posY, "Binds" )
                
                draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                        if IsMouseInBounds(x - 10, y - 10, x + bW + 50, y + bH + 10) then
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
                    draw.Color( table.unpack(menu.Values.NitroKeybindBackground) )
                    RoundedRect(posX, posY, posX + width + 45, posY + keybindHeight, 6)
            
                    draw.Color( 255, 255, 255, 255 )
                    draw.Text( 20 + posX, 10 + posY, "Binds" )
                
                    draw.Color( table.unpack(menu.Values.NitroKeybind)  )
                    RoundedRect(posX + 15, posY + 35, posX + width + 25, posY + 210 - 172, 0)

                    Toggle2(320 + x1, y2 + 48,"", "aimbot")
                    Toggle2(320 + x1, y2 + 73,"", "crits")
                    Toggle2(320 + x1, y2 + 98,"", "dtky")
                    Toggle2(320 + x1, y2 + 123,"", "rechrge")
                    Toggle2(320 + x1, y2 + 148,"", "thrdperson")
                    Toggle2(320 + x1, y2 + 173,"", "fakeleg")
                    Toggle2(320 + x1, y2 + 198,"", "triggerbt")
                    Toggle2(320 + x1, y2 + 223,"", "triggersht")
                    Toggle2(320 + x1, y2 + 248,"", "werp")           

                else
                end 
                draw.SetFont(binds)

            if Lbox_Menu_Open == true then

                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)

                    if (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 and gui.GetValue("Aim key") >= 1 and (input.IsButtonDown( gui.GetValue( "aim key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Hold" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                  
                      elseif gui.GetValue("Aim key") >= 1 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 1 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                      elseif gui.GetValue("Aim key") >= 1 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "Off" )
                      elseif (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 and gui.GetValue("Aim key") >= 1 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 50, "aimbot" )
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Text( 25 + x1, y2 + 50, "Hold" )
                        draw.Text( 270 + x1, y2 + 50, "Off" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 then
                          draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, "none" )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 0 then
                          draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                          draw.Text( 85 + x1, y2 + 50, "aimbot" )
                          draw.Text( 185 + x1, y2 + 50, "none" )
                    
                          draw.Text( 25 + x1, y2 + 50, "Toggle" )
                          draw.Text( 270 + x1, y2 + 50, "Off" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 1 then
                          draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, "none" )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 0 then
                          draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                          draw.Text( 85 + x1, y2 + 50, "aimbot")
                          draw.Text( 185 + x1, y2 + 50, "none" )
                    
                          draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                          draw.Text( 25 + x1, y2 + 50, "Toggle" )
                          draw.Text( 270 + x1, y2 + 50, "Off" )
                      end
        
                   
        
               
        
                
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "crit hack key" ) )) and gui.GetValue("crit hack key") >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "On" )
                    elseif gui.GetValue("crit hack key") >= 1 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "Off" )
                    elseif gui.GetValue("crit hack key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, "none" )
                  
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "Off" )
                      end
                
        
                
        
        
               
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if (input.IsButtonDown( gui.GetValue( "double tap key" ) )) and gui.GetValue("double tap key") >= 1 and gui.GetValue("double tap") == "force key" then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                    elseif gui.GetValue("double tap key") >= 1 and gui.GetValue("double tap") == "force key" then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "Off" )
                    elseif gui.GetValue("double tap key") == 0 and gui.GetValue("double tap") == "force key" then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, "none" )
                  
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "Off" )
                    elseif gui.GetValue("double tap key") >= 1 and gui.GetValue("double tap") == "force always" then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 100, "Toggle" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                    elseif gui.GetValue("double tap key") == 0 and gui.GetValue("double tap") == "force always" then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, "none" )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 100, "Toggle" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                    elseif gui.GetValue("double tap") == "none" then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, "none" )
                  
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "Off" )
                      end
        
                      
                
                
        
                    
        
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
                    
                    if gui.GetValue( "force recharge key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, "none" )
                  
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "Off" )
                    elseif gui.GetValue( "force recharge key") >= 0 and (input.IsButtonDown( gui.GetValue( "force recharge key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, dt_key_recharge )
                        
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "On" )
                    elseif gui.GetValue( "force recharge key") >= 0 then
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
                    
                    if gui.GetValue( "thirdperson" ) == 1 and gui.GetValue( "thirdperson key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, "none"  )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "On" )
                    elseif gui.GetValue( "thirdperson" ) == 0 and gui.GetValue( "thirdperson key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, "none" )
                  
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "Off" )
                    elseif gui.GetValue( "thirdperson" ) == 1 and gui.GetValue( "thirdperson key") >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, thirdperson_key  )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "On" )
                    elseif gui.GetValue( "thirdperson" ) == 0 and gui.GetValue( "thirdperson key") >= 0 then
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 200 + y2, "Toggle" )
                        draw.Text( 270 + x1, 200 + y2, "On" )
                    elseif gui.GetValue( "trigger key", trigger_key) and (input.IsButtonDown( gui.GetValue( "trigger key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, trigger_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                    
                    if (input.IsButtonDown( gui.GetValue( "dash move key" ) )) and gui.GetValue( "dash move key") >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 250, "Hold" )
                        draw.Text( 270 + x1, y2 + 250, "On" )
                      elseif gui.GetValue( "dash move key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, "none" )
                  
                        draw.Text( 25 + x1, y2 + 250, "Hold" )
                        draw.Text( 270 + x1, y2 + 250, "Off" )
                      elseif gui.GetValue( "dash move key") >= 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Text( 25 + x1, y2 + 250, "Hold" )
                        draw.Text( 270 + x1, y2 + 250, "Off" )
                      end




            end

            if Lbox_Menu_Open == false then
                
                if menu.toggles.aimbot then

            
                    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
                        return
                      end
                    draw.SetFont(binds)
        
                    
                    
                    
                    if (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 and gui.GetValue("Aim key") >= 1 and (input.IsButtonDown( gui.GetValue( "aim key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Hold" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                  
                      elseif gui.GetValue("Aim key") >= 1 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 1 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                      elseif gui.GetValue("Aim key") >= 1 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "Off" )
                      elseif (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 and gui.GetValue("Aim key") >= 1 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 50, "aimbot" )
                        draw.Text( 185 + x1, y2 + 50, aimbot_key )
                  
                        draw.Text( 25 + x1, y2 + 50, "Hold" )
                        draw.Text( 270 + x1, y2 + 50, "Off" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 1 then
                          draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, "none" )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "hold-to-use") and gui.GetValue("aim bot") == 0 then
                          draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                          draw.Text( 85 + x1, y2 + 50, "aimbot" )
                          draw.Text( 185 + x1, y2 + 50, "none" )
                    
                          draw.Text( 25 + x1, y2 + 50, "Toggle" )
                          draw.Text( 270 + x1, y2 + 50, "Off" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 1 then
                          draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 50, "aimbot")
                        draw.Text( 185 + x1, y2 + 50, "none" )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 50, "Toggle" )
                        draw.Text( 270 + x1, y2 + 50, "On" )
                      elseif gui.GetValue("Aim key") == 0 and (aimbot_mode == "press-to-toggle") and gui.GetValue("aim bot") == 0 then
                          draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                          draw.Text( 85 + x1, y2 + 50, "aimbot")
                          draw.Text( 185 + x1, y2 + 50, "none" )
                    
                          draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                          draw.Text( 25 + x1, y2 + 50, "Toggle" )
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
                    
                    if (input.IsButtonDown( gui.GetValue( "crit hack key" ) )) and gui.GetValue("crit hack key") >= 1 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "On" )
                    elseif gui.GetValue("crit hack key") >= 1 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, force_crits_key )
                  
                        draw.Text( 25 + x1, y2 + 75, "Hold" )
                        draw.Text( 270 + x1, y2 + 75, "Off" )
                    elseif gui.GetValue("crit hack key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 75, "force crits" )
                        draw.Text( 185 + x1, y2 + 75, "none" )
                  
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
                    
                    if (input.IsButtonDown( gui.GetValue( "double tap key" ) )) and gui.GetValue("double tap key") >= 1 and gui.GetValue("double tap") == "force key" then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                    elseif gui.GetValue("double tap key") >= 1 and gui.GetValue("double tap") == "force key" then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "Off" )
                    elseif gui.GetValue("double tap key") == 0 and gui.GetValue("double tap") == "force key" then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, "none" )
                  
                        draw.Text( 25 + x1, y2 + 100, "Hold" )
                        draw.Text( 270 + x1, y2 + 100, "Off" )
                    elseif gui.GetValue("double tap key") >= 1 and gui.GetValue("double tap") == "force always" then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, dt_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 100, "Toggle" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                    elseif gui.GetValue("double tap key") == 0 and gui.GetValue("double tap") == "force always" then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, "none" )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 100, "Toggle" )
                        draw.Text( 270 + x1, y2 + 100, "On" )
                    elseif gui.GetValue("double tap") == "none" then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 100, "double tap" )
                        draw.Text( 185 + x1, y2 + 100, "none" )
                  
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
                    
                    if gui.GetValue( "force recharge key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, "none" )
                  
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "Off" )
                    elseif gui.GetValue( "force recharge key") >= 0 and (input.IsButtonDown( gui.GetValue( "force recharge key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 125 + y2, "recharge dt" )
                        draw.Text( 185 + x1, 125 + y2, dt_key_recharge )
                        
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 125 + y2, "Hold" )
                        draw.Text( 270 + x1, 125 + y2, "On" )
                    elseif gui.GetValue( "force recharge key") >= 0 then
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
                    
                    if gui.GetValue( "thirdperson" ) == 1 and gui.GetValue( "thirdperson key") == 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, "none"  )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "On" )
                    elseif gui.GetValue( "thirdperson" ) == 0 and gui.GetValue( "thirdperson key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, "none" )
                  
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "Off" )
                    elseif gui.GetValue( "thirdperson" ) == 1 and gui.GetValue( "thirdperson key") >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 150 + y2, "thirdperson" )
                        draw.Text( 185 + x1, 150 + y2, thirdperson_key  )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 150 + y2, "Toggle" )
                        draw.Text( 270 + x1, 150 + y2, "On" )
                    elseif gui.GetValue( "thirdperson" ) == 0 and gui.GetValue( "thirdperson key") >= 0 then
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, 200 + y2, "Toggle" )
                        draw.Text( 270 + x1, 200 + y2, "On" )
                    elseif gui.GetValue( "trigger key", trigger_key) and (input.IsButtonDown( gui.GetValue( "trigger key" ) )) then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, 200 + y2, "trigger bot" )
                        draw.Text( 185 + x1, 200 + y2, trigger_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                         
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
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
                    
                    if (input.IsButtonDown( gui.GetValue( "dash move key" ) )) and gui.GetValue( "dash move key") >= 0 then
                        draw.Color( 200, 200, 200, 250 )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Color( table.unpack(menu.Values.NitroKeybind) )
                        draw.Text( 25 + x1, y2 + 250, "Hold" )
                        draw.Text( 270 + x1, y2 + 250, "On" )
                      elseif gui.GetValue( "dash move key") == 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, "none" )
                  
                        draw.Text( 25 + x1, y2 + 250, "Hold" )
                        draw.Text( 270 + x1, y2 + 250, "Off" )
                      elseif gui.GetValue( "dash move key") >= 0 then
                        draw.Color( textcolorwhenoff[1], textcolorwhenoff[2], textcolorwhenoff[3], textcolorwhenoff[4] )
                        draw.Text( 85 + x1, y2 + 250, "dash move" )
                        draw.Text( 185 + x1, y2 + 250, warp_key )
                  
                        draw.Text( 25 + x1, y2 + 250, "Hold" )
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
            
            menu.Values.NitroDtBar = {colorpicker3:get():unpack()}
            

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
                draw.Color( table.unpack(menu.Values.NitroDtBar) )
                RoundedRect(barX, barY, barX + math.floor(charge * barWidth), barY + barHeight, 4)
            end
        
        
            draw.SetFont(nitrofont)
            local LocalWeapon = entities.GetLocalPlayer():GetPropEntity( "m_hActiveWeapon" )
            if (warp.CanDoubleTap(LocalWeapon)) and ((entities.GetLocalPlayer():GetPropInt( "m_fFlags" )) & FL_ONGROUND) == 1 and charge == 1 then
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

     if menu.toggles.ateris_dt_bar then
        if input.IsButtonPressed( KEY_END ) or input.IsButtonPressed( KEY_INSERT ) or input.IsButtonPressed( KEY_F11 ) then 
			toggleMenu()
		end

		if engine.Con_IsVisible() or engine.IsGameUIVisible() then
			return
		end

        menu.Values.AterisDtBar = {colorpicker4:get():unpack()}
	
		local originalColor = {table.unpack(menu.Values.AterisDtBar)}
		local greyColor = {40, 40, 40, 255}
	
		local LocalWeapon = entities.GetLocalPlayer():GetPropEntity("m_hActiveWeapon")
	
		local x, y = barX1, barY1
		local bW, bH = barW, barH
		local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
	 
		if Lbox_Menu_Open == true then
			if IsDragging4 then
				if input.IsButtonDown(MOUSE_LEFT) then
					barX1 = mX - math.floor(bW * menu.rX)
					barY1 = mY - math.floor(15 * menu.rY)
				else
					IsDragging4 = false
				end
			else
				if IsMouseInBounds(x, y, x + bW, y + bH) then
					if not input.IsButtonDown(MOUSE_LEFT) then
						menu.rX = ((mX - x) / bW)
						menu.rY = ((mY - y) / 15)
					else
						barX1 = mX - math.floor(bW * menu.rX)
						barY1 = mY - math.floor(15 * menu.rY)
						IsDragging4 = true
					end
				end
			end
		end

	
		barW = lerp(barW, vl(charge * barW2+.1, 10, barW2+.1), speed)
	
		draw.Color(1, 1, 1, 200)
		draw.FilledRect(barX1, barY1, math.floor(barX1 + barW2), barY1 + barH)
	
		local factor = 1 - (barW / barW2)
		local currentColor = interpolateColor(originalColor, greyColor, factor)
	
		local speedMultiplier = 5
		factor = factor * speedMultiplier
	
		draw.Color(currentColor[1], currentColor[2], currentColor[3], currentColor[4])
		draw.TexturedRect(gradientBarMaskCustom2, barX1, barY1, barX1 + math.floor(barW), barY1 + barH)
	
		draw.SetFont(tickstxt)
		local textWidth, textHeight = draw.GetTextSize("TICKS")
		draw.Color(255, 255, 255, 255)
		draw.Text(barX1, barY1 - textHeight - 4, "TICKS: " .. warp.GetChargedTicks())
	
		draw.SetFont(tickstxt)
		local dtStateText = ""
		local LocalWeapon = entities.GetLocalPlayer():GetPropEntity("m_hActiveWeapon")
	
		draw.Color(1, 1, 1, 255)
		--draw.OutlinedRect(barX1, barY1, math.floor(barX1 + barW2), barY1 + barH)

        drawRectOutline(math.floor(barX1-1), math.floor(barY1-.1), math.floor(barW2+1), math.floor(barH+1), {1,1,1,255}, 1)

		local brightenedColor = brightenColor(originalColor, 25)

		if barW2 ~= 170 then
			brightenedColor = interpolateColor(originalColor, brightenedColor, factor + .2)
		end
		
		-- state
		if charge == 0 then
			draw.Color(207, 51, 42, 255)
			local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("LOW CHARGE")
			draw.Text(math.floor(barX1 + barW2 - dtStateTextWidth), barY1 - dtStateTextHeight - 4, "LOW CHARGE")
	
			draw.Color(brightenedColor[1], brightenedColor[2], brightenedColor[3], 255)
			draw.OutlinedRect(barX1, barY1, math.floor(barX1 + barW), barY1 + barH)
	
		elseif charging then
			draw.Color(235, 240, 26, 255)
			local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("RECHARGING")
			draw.Text(math.floor(barX1 + barW2 - dtStateTextWidth), barY1 - dtStateTextHeight - 4, "RECHARGING")
	
			draw.Color(brightenedColor[1], brightenedColor[2], brightenedColor[3], 255)
			draw.OutlinedRect(barX1, barY1, math.floor(barX1 + barW), barY1 + barH)
	
		elseif charge ~= 1 then
			draw.Color(207, 51, 42, 255)
			local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("LOW CHARGE")
			draw.Text(math.floor(barX1 + barW2 - dtStateTextWidth), barY1 - dtStateTextHeight - 4, "LOW CHARGE")
	
			draw.Color(brightenedColor[1], brightenedColor[2], brightenedColor[3], 255)
			draw.OutlinedRect(barX1, barY1, math.floor(barX1 + barW), barY1 + barH)
	
		elseif charge == 1 and (warp.CanDoubleTap(LocalWeapon)) then
			draw.Color(48, 227, 104, 255)
			local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("CHARGED")
			draw.Text(math.floor(barX1 + barW2 - dtStateTextWidth), barY1 - dtStateTextHeight - 4, "CHARGED")
	
			draw.Color(brightenedColor[1], brightenedColor[2], brightenedColor[3], 255)
			draw.OutlinedRect(barX1, barY1, math.floor(barX1 + barW), barY1 + barH)
	
		elseif not (warp.CanDoubleTap(LocalWeapon)) then
			draw.Color(247, 219, 59, 255)
			local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("WAIT")
			draw.Text(math.floor(barX1 + barW2 - dtStateTextWidth), barY1 - dtStateTextHeight - 4, "WAIT")

			draw.Color(brightenedColor[1], brightenedColor[2], brightenedColor[3], 255)
			draw.OutlinedRect(barX1, barY1, math.floor(barX1 + barW), barY1 + barH)
		end
     end

     if menu.toggles.monkey_dt_bar then
        
        if engine.Con_IsVisible() or engine.IsGameUIVisible() then
			return
		end

        menu.Values.MonkeyBotDtBar = {colorpicker5:get():unpack()}
 
        local x, y = barX2, barY2
		local bW, bH = barWidth1, barHeight1
		local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
	 
		if Lbox_Menu_Open == true then
			if IsDragging5 then
				if input.IsButtonDown(MOUSE_LEFT) then
					barX2 = mX - math.floor(bW * menu.rX)
					barY2 = mY - math.floor(15 * menu.rY)
				else
					IsDragging5 = false
				end
			else
				if IsMouseInBounds(x, y - 25, x + bW, y + bH) then
					if not input.IsButtonDown(MOUSE_LEFT) then
						menu.rX = ((mX - x) / bW)
						menu.rY = ((mY - y) / 15)
					else
						barX2 = mX - math.floor(bW * menu.rX)
						barY2 = mY - math.floor(15 * menu.rY)
						IsDragging5 = true
					end
				end
			end
		end

        barWidth1 = lerp(barWidth1, vl(charge * rectWidth, 10, barW2), speed)
    
        draw.Color(transparent_rect_color[1], transparent_rect_color[2], transparent_rect_color[3], transparent_rect_color[4])
        draw.FilledRect(barX2, barY2-25, barX2 + rectWidth, math.floor(barY2 + recHeight-25))
    
        draw.Color(table.unpack(menu.Values.MonkeyBotDtBar))
    
        draw.TexturedRect(gradientBarMask, barX2, barY2, barX2 + math.floor(barWidth1), barY2 + barHeight1)
    
        draw.SetFont(rjnfont)
        local LocalWeapon = entities.GetLocalPlayer():GetPropEntity("m_hActiveWeapon")
        if (warp.CanDoubleTap(LocalWeapon)) and ((entities.GetLocalPlayer():GetPropInt("m_fFlags")) & FL_ONGROUND) == 1 and charge == 1 then
            local state_text = "READY"
            draw.Color(0, 255, 125, 255)
            local StateTextWidth, StateTextHeight = draw.GetTextSize(state_text)
            draw.Text(barX2 + rectWidth - StateTextWidth - 2, barY2 - StateTextHeight - 2, state_text)
        else
            local not_ready = "NOT READY"
            draw.Color(255, 0, 0, 255)
            local StateTextWidth, StateTextHeight = draw.GetTextSize(not_ready)
            draw.Text(barX2 + rectWidth - StateTextWidth - 2, barY2 - StateTextHeight - 2, not_ready)
        end
    
        local chargetext = "Charge";
        draw.SetFont(chargetxt)    
        local StateTextWidth, StateTextHeight = draw.GetTextSize(chargetext);
        draw.Color( 255, 255, 255, 255 )
        draw.Text( barX2 + rectWidth - StateTextWidth - 125, barY2 - StateTextHeight - 2, chargetext)

     end

     
     if menu.toggles.rijin_dt_bar then
        
        if engine.Con_IsVisible() or engine.IsGameUIVisible() then
            return
        end
        menu.Values.RijinDtBarLeft = {colorpicker6:get():unpack()}
        menu.Values.RijinDtBarRight = {colorpicker7:get():unpack()}
        menu.Values.RijinDtBarOutline = {colorpicker8:get():unpack()}

        local LocalWeapon = entities.GetLocalPlayer():GetPropEntity( "m_hActiveWeapon" )
    
        draw.SetFont(smallestPixel)

        local x, y = barX4, barY4
		local bW, bH = barWidth4, barHeight3
		local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
	 
		if Lbox_Menu_Open == true then
			if IsDragging6 then
				if input.IsButtonDown(MOUSE_LEFT) then
					barX4 = mX - math.floor(bW * menu.rX)
					barY4 = mY - math.floor(15 * menu.rY)
				else
					IsDragging6 = false
				end
			else
				if IsMouseInBounds(x, y - 10, x + bW, y + bH) then
					if not input.IsButtonDown(MOUSE_LEFT) then
						menu.rX = ((mX - x) / bW)
						menu.rY = ((mY - y) / 15)
					else
						barX4 = mX - math.floor(bW * menu.rX)
						barY4 = mY - math.floor(15 * menu.rY)
						IsDragging6 = true
					end
				end
			end
		end

        
    
        -- Background
        draw.Color(28, 29, 38, 255)
        draw.FilledRect(barX4, barY4, math.floor(barX4 + barWidth5), barY4 + barHeight3)
    
        barWidth4 = lerp(barWidth4, vl(charge * barWidth5+.1, 10, barWidth5+.1), speed)
    
    
        -- Bar gradient
        draw.Color(table.unpack(menu.Values.RijinDtBarLeft))
        draw.TexturedRect(gradientBarMask, barX4, barY4, math.floor(barX4 + barWidth4), barY4 + barHeight3)


        draw.Color(table.unpack(menu.Values.RijinDtBarRight))
        draw.TexturedRect(gradientBarMask, barX4, barY4, math.floor(barX4 + barWidth4), barY4 + barHeight3)

    
        -- Border
        --draw.OutlinedRect(barX4, barY4, math.floor(barX4 + barWidth5), barY4 + barHeight3)
        drawRectOutline(barX4, barY4, math.floor(barWidth5), barHeight3, {table.unpack(menu.Values.RijinDtBarOutline)}, 1)
    
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

     ::continue::
end
callbacks.Register( "Draw", "awbtyngfuimhdj", NonMenuDraw )

-- pasted by boghonorojczyzna_

local function OnUnload() 
    client.SetConVar( "tf_viewmodels_offset_override", 0 .. " " .. 0 .. " " .. 0 )
    client.SetConVar( "cl_wpn_sway_interp", 0.0 )
    client.SetConVar( "cl_wpn_sway_scale", 0.0 )
    client.SetConVar( "r_aspectratio", 0.0 )

    draw.DeleteTexture(gradientBarMask)
end

client.Command("clear", true)

callbacks.Unregister( "Unload", "gehdas5" )
callbacks.Register( "Unload", "gehdas5", OnUnload )

callbacks.Register("CreateMove", function(cmd)
    updateBarCharge()
end)

table.insert(notifications, 1, {time = globals.CurTime(), text = "loaded pasted lua"})