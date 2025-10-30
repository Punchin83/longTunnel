-- List of stone variants
local stoneVariants = {
    "minecraft:stone", "minecraft:cobblestone", "minecraft:mossy_cobblestone",
    "minecraft:granite", "minecraft:polished_granite",
    "minecraft:diorite", "minecraft:polished_diorite",
    "minecraft:andesite", "minecraft:polished_andesite",
    "minecraft:deepslate", "minecraft:cobbled_deepslate", "minecraft:polished_deepslate",
    "minecraft:stone_bricks", "minecraft:cracked_stone_bricks", "minecraft:mossy_stone_bricks", "minecraft:chiseled_stone_bricks",
    "minecraft:deepslate_bricks", "minecraft:cracked_deepslate_bricks", "minecraft:chiseled_deepslate_bricks",
    "minecraft:deepslate_tiles", "minecraft:cracked_deepslate_tiles", "minecraft:chiseled_deepslate_tiles",
    "minecraft:tuff", "minecraft:polished_tuff",
    "minecraft:sandstone", "minecraft:smooth_sandstone", "minecraft:chiseled_sandstone", "minecraft:cut_sandstone",
    "minecraft:red_sandstone", "minecraft:smooth_red_sandstone", "minecraft:chiseled_red_sandstone", "minecraft:cut_red_sandstone",
    "minecraft:blackstone", "minecraft:polished_blackstone", "minecraft:chiseled_polished_blackstone", "minecraft:cracked_polished_blackstone",
    "minecraft:basalt", "minecraft:polished_basalt",
    "minecraft:smooth_stone"
}

-- Check if item in slot 1 is a valid stone variant
local function isValidStone()
    local detail = turtle.getItemDetail(1)
    if not detail then return false end
    for _, name in ipairs(stoneVariants) do
        if detail.name == name then return true end
    end
    return false
end
-- Refill slot 1 with valid stone variant from other slots
local function refillSlot1()
    for i = 2, 15 do
        turtle.select(i)
        local detail = turtle.getItemDetail()
        if detail then
            for _, name in ipairs(stoneVariants) do
                if detail.name == name then
                    turtle.transferTo(1)
                    return
                end
            end
        end
    end
end

-- Ensure there's a block below
local function ensureFloor()
    if not turtle.detectDown() then
        if turtle.getItemCount(1) == 0 or not isValidStone() then
            refillSlot1()
        end
        turtle.select(1)
        turtle.placeDown()
    end
end

-- Place torch from slot 16
local function placeTorch()
    turtle.select(16)
    if turtle.placeUp() then
        return
    else
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.place()
        turtle.turnRight()
        turtle.turnRight()
    end
end

-- Get distance from argument or prompt
local args = {...}
local distance = tonumber(args[1])
if not distance then
    print("Enter tunnel distance:")
    distance = tonumber(read())
end
-- Main loop
for i = 1, distance do
    -- Dig and move forward
    while turtle.detect() do turtle.dig() end
    turtle.forward()

    -- Dig above
    if turtle.detectUp() then turtle.digUp() end

    -- Ensure floor
    ensureFloor()

    -- Torch every 10 blocks
    if i % 10 == 0 then
        placeTorch()
    end
end
