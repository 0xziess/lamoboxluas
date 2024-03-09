local menu = {
    rX = 0,
    rY = 0,
}

local tickstxt = draw.CreateFont("Verdana", 13, 100, FONTFLAG_CUSTOM | FONTFLAG_OUTLINE , 1)
local barWidth = 200
local barWidth2 = 200
local barHeight = 20
local maxTicks = 23


local speed = 0.03
local speed2 = 0.04
local speed3 = 0.05
local speed4 = 0.01

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

local colorTop = {59, 222, 247}
local colorMiddle = {27, 88, 97}
local colorBottom = {59, 222, 247}

local colorTop2 = {125, 133, 125}
local colorMiddle2 = {51, 50, 50}
local colorBottom2 = {125, 133, 125}

local gradientBarMaskCustom = createCustomGradientBarMask(colorTop, colorMiddle, colorBottom)
local gradientBarMaskCustom2 = createCustomGradientBarMask(colorTop2, colorMiddle2, colorBottom2)

local IsDragging = false

local function IsMouseInBounds(x,y,x2,y2)
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]
    if mX >= x and mX <= x2 and mY >= y and mY <= y2 then
        return true 
    end
    return false
end


function lerp(a, b, t)
        return a + (b - a) * t
    end

    function easeOutQuad(t)
        return 1 - (1 - t) ^ 2
    end

local screenX, screenY = draw.GetScreenSize()
local barX = math.floor(screenX / 2 - 200 / 2)
local barY = math.floor(screenY / 2) + 50

callbacks.Register("Draw", function()
    if engine.Con_IsVisible() or engine.IsGameUIVisible() then
        return
    end

    local LocalWeapon = entities.GetLocalPlayer():GetPropEntity( "m_hActiveWeapon" )

    local x, y = barX, barY
    local bW, bH = barWidth, barHeight
    local mX, mY = input.GetMousePos()[1], input.GetMousePos()[2]

    if IsDragging then
        if input.IsButtonDown(MOUSE_LEFT) then
            barX = mX - math.floor(bW * menu.rX)
            barY = mY - math.floor(15 * menu.rY)
        else
            IsDragging = false
        end
    else
        if IsMouseInBounds(x - 10, y - 10, x + bW + 50, y + bH + 10) then
            if not input.IsButtonDown(MOUSE_LEFT) then
                menu.rX = ((mX - x) / bW)
                menu.rY = ((mY - y) / 15)
            else
                barX = mX - math.floor(bW * menu.rX)
                barY = mY - math.floor(15 * menu.rY)
                IsDragging = true
            end
        end
    end

    -- bg
    draw.Color(10, 10, 10, 200)
    draw.OutlinedRect(barX - 5, barY - 20, math.floor(barX + barWidth2 + 5), barY + barHeight + 3)
    draw.FilledRect(barX - 5, barY - 20, math.floor(barX + barWidth2 + 5), barY + barHeight + 3)
    --

    local t = easeOutQuad(math.min(barWidth / 160, 1))

    local t2 = easeOutQuad(math.min(barWidth / 2, 1))

    local t3 = easeOutQuad(math.min(barWidth / 0, 1))

    if charge >= 0 then
        barWidth = lerp(barWidth, 200, t * speed)
    end

    if charge == 0 then
        barWidth = lerp(barWidth, 0, t3 * speed2)
    end

    if charge ~= 1 then
        barWidth = lerp(barWidth, 0, t2 * speed3)
    end

    draw.Color(1, 1, 1, 255)
    draw.FilledRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)

    draw.Color(255, 255, 255, math.floor(math.sin(globals.CurTime()*0) * 100 + 155))

    draw.TexturedRect(gradientBarMaskCustom, barX, barY, math.floor(barX + barWidth), barY + barHeight)

    draw.SetFont(tickstxt)
    local textWidth, textHeight = draw.GetTextSize("TICKS")
    draw.Color(255, 255, 255, 255)
    draw.Text( barX, barY - textHeight - 1, "TICKS: "..warp.GetChargedTicks())
    
    draw.SetFont(tickstxt)
    local dtStateText = "";
    local LocalWeapon = entities.GetLocalPlayer():GetPropEntity( "m_hActiveWeapon" )

    draw.Color(25, 25, 25, 255)
    draw.OutlinedRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)
    
    -- state txt
    if charge == 0 then
        draw.Color(207, 51, 42, 255)
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("LOW CHARGE");
        dtStateText = "";
        draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 1, "LOW CHARGE")

        draw.Color(255, 255, 255, 255)
        draw.TexturedRect(gradientBarMaskCustom2, barX, barY, math.floor(barX + barWidth), barY + barHeight)

        draw.Color(25, 25, 25, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)

        draw.Color(155, 163, 155, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth), barY + barHeight)


    elseif charging then
        barWidth = lerp(barWidth, 660, t * speed4)
        draw.Color(235, 240, 26, 255)
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("RECHARGING");
        dtStateText = "";
        draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 1, "RECHARGING")

        draw.Color(255, 255, 255, 255)
        draw.TexturedRect(gradientBarMaskCustom2, barX, barY, math.floor(barX + barWidth), barY + barHeight)

        draw.Color(25, 25, 25, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)

        draw.Color(155, 163, 155, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth), barY + barHeight)
        

    elseif charge ~= 1 then
        draw.Color(207, 51, 42, 255)
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("LOW CHARGE");
        dtStateText = "";
        draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 1, "LOW CHARGE")

        draw.Color(255, 255, 255, 255)
        draw.TexturedRect(gradientBarMaskCustom2, barX, barY, math.floor(barX + barWidth), barY + barHeight)

        draw.Color(25, 25, 25, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)

        draw.Color(155, 163, 155, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth), barY + barHeight)
    
    elseif charge == 1 and (warp.CanDoubleTap(LocalWeapon)) then
        draw.Color(80, 204, 222, 255)
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("CHARGED");
        dtStateText = "";
        draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 1, "CHARGED")

        draw.Color(59, 222, 247, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth), barY + barHeight)
    elseif not (warp.CanDoubleTap(LocalWeapon)) then
        draw.Color(247, 219, 59, 255)
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("WAIT");
        dtStateText = "";
        draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 1, "WAIT")
        draw.Color(59, 222, 247, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth), barY + barHeight)
       
    end
    --

    local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize(dtStateText);


    draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 1, dtStateText)
end)




callbacks.Register("CreateMove", function(cmd)
    updateBarCharge()
end)

local t = globals.TickCount()
client.Command("clear", true)
local function OnLoad()
    local lines = {"ateris dt bar loaded"}
    local clr1 = {59, 222, 247, 255}
    local clr2 = {59, 222, 247, 255}
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
