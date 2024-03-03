local menu = {
    rX = 0,
    rY = 0,
}

local tickstxt = draw.CreateFont("Smallest Pixel", 13, 400, FONTFLAG_OUTLINE, 1)
local statetxt = draw.CreateFont("Smallest Pixel", 11, 400, FONTFLAG_OUTLINE, 1)
local barWidth = 170
local barWidth2 = 170
local barHeight = 20
local maxTicks = 23
local barOffset = 30 -- Adjust this value to move the bar further down


local speed = 0.1
local speed2 = 0.1
local speed3 = 0.15
local targetX = 160
local targetX2 = 160

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
            r = math.floor((1 - 2 * ratio) * colorTop[1] + 2 * ratio * colorMiddle[1]) -- Transition from colorTop to colorMiddle
            g = math.floor((1 - 2 * ratio) * colorTop[2] + 2 * ratio * colorMiddle[2])
            b = math.floor((1 - 2 * ratio) * colorTop[3] + 2 * ratio * colorMiddle[3])
        else
            r = math.floor((1 - 2 * (ratio - 0.5)) * colorMiddle[1] + 2 * (ratio - 0.5) * colorBottom[1]) -- Transition from colorMiddle to colorBottom
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
local barX = math.floor(screenX / 2 - 160 / 2)
local barY = math.floor(screenY / 2) + barOffset

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

    -- Background
    draw.Color(10, 10, 10, 200)
    draw.OutlinedRect(barX - 5, barY - 20, math.floor(barX + barWidth2 + 5), barY + barHeight + 3)
    draw.FilledRect(barX - 5, barY - 20, math.floor(barX + barWidth2 + 5), barY + barHeight + 3)

    local t = easeOutQuad(math.min(barWidth / targetX, 1))  -- Normalize t between 0 and 1 based on current position
    

    local t2 = easeOutQuad(math.min(barWidth / 2, 1))  -- Normalize t between 0 and 1 based on current position

    local t3 = easeOutQuad(math.min(barWidth / 0, 1))  -- Normalize t between 0 and 1 based on current position




    -- Bar gradient
    if charge >= 0 then
        barWidth = lerp(barWidth, targetX2, t * speed)
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

    draw.TexturedRect(gradientBarMaskCustom, barX, barY, math.floor(barX + barWidth + 10), barY + barHeight)

   
    -- Border
    


    draw.SetFont(tickstxt)
    -- Text
    local textWidth, textHeight = draw.GetTextSize("TICKS")
    draw.Color(255, 255, 255, 255)
    draw.Text( barX, barY - textHeight - 3, "TICKS: "..warp.GetChargedTicks())


    -- DT State Text
    draw.SetFont(tickstxt)
    draw.Color(80, 204, 222, 255)
    local dtStateText = "CHARGED";

    draw.Color(25, 25, 25, 255)
    draw.OutlinedRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)

    if charge == 0 then
        draw.Color(207, 51, 42, 255)
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("LOW CHARGE");
        dtStateText = "";
        draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 3, "LOW CHARGE")

        draw.Color(255, 255, 255, 255)
        draw.TexturedRect(gradientBarMaskCustom2, barX, barY, math.floor(barX + barWidth + 10), barY + barHeight)

        draw.Color(25, 25, 25, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)


    elseif charging then
        dtStateText = "RECHARGING";
        draw.Color(235, 240, 26, 255)

    elseif charge ~= 1 then
        draw.Color(207, 51, 42, 255)
        local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize("LOW CHARGE");
        dtStateText = "";
        draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 3, "LOW CHARGE")

        draw.Color(255, 255, 255, 255)
        draw.TexturedRect(gradientBarMaskCustom2, barX, barY, math.floor(barX + barWidth + 10), barY + barHeight)

        draw.Color(25, 25, 25, 255)
        draw.OutlinedRect(barX, barY, math.floor(barX + barWidth2), barY + barHeight)
    
    elseif (warp.CanDoubleTap(LocalWeapon)) and ((entities.GetLocalPlayer():GetPropInt( "m_fFlags" )) & FL_ONGROUND) == 1 and charge == 1 then
        local LocalWeapon = entities.GetLocalPlayer():GetPropEntity( "m_hActiveWeapon" )
        dtStateText = "CHARGED";
        draw.Color(80, 204, 222, 255)
       else
       draw.Color(247, 219, 59, 255)

       dtStateText = "WAIT";
       end

    local dtStateTextWidth, dtStateTextHeight = draw.GetTextSize(dtStateText);


    draw.Text(math.floor(barX + barWidth2 - dtStateTextWidth), barY - dtStateTextHeight - 3, dtStateText)
end)




callbacks.Register("CreateMove", function(cmd)
    updateBarCharge()
end)

local t = globals.TickCount()
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
