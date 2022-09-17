--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    local keyColor = math.random(4)
    local blockColor = keyColor + 4
    
    --spawn the key and the locked block in random positions
    local keyX = math.random(width)
    local blockX = math.random(width)

    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 and x ~= keyX and x ~= blockX then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- spawn a locked block if we are in the defined position, else spawn a regular block
            if x == blockX then
                table.insert(objects,

                    -- locked block
                    GameObject {
                        texture = 'keys-and-locks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        frame = blockColor,
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself, the player, and the object position 
                        -- to remove it from the objects table when collided, if the player has the key.
                        -- it also spawns the goal post at the end of the level
                        onCollide = function(obj, player, objPosition)
                            if player.hasKey then
                                -- remove the block
                                table.remove(player.level.objects, objPosition)

                                -- remove the key
                                player.hasKey = false

                                gSounds['pickup']:play()

                                -- find appropiate x positions for the pole and flag at the end of the level
                                -- do not spawn it on a chasm or on a column with an block in it
                                local columnHasBlocks = true
                                local poleColumn = player.level.tileMap.width
                                while columnHasBlocks do
                                    poleColumn = poleColumn - 1
                                    local isColumnEmpty = player.level.tileMap:isColumnEmpty(poleColumn)
                                    while isColumnEmpty do
                                        poleColumn = poleColumn - 1
                                        isColumnEmpty = player.level.tileMap:isColumnEmpty(poleColumn)
                                    end
                                    columnHasBlocks = false
                                    for k, object in pairs(objects) do
                                        if ( object.x / TILE_SIZE ) + 1 == poleColumn and object.collidable then
                                            columnHasBlocks = true
                                        end
                                    end
                                end

                                local poleX = (poleColumn - 1) * TILE_SIZE
                                local flagX = poleX + TILE_SIZE - 6

                                local poleY = ( height - player.level.tileMap:columnHeight(poleColumn) - 3 ) * TILE_SIZE
                                local flagY = poleY + 5

                                -- spawn pole at the end of the level
                                local pole = GameObject {
                                    texture = 'poles',
                                    x = poleX,
                                    y = poleY,
                                    width = 16,
                                    height = 16 * 3,
                                    frame = math.random(6),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,

                                    -- when touched, change the level
                                    onConsume = function(player)
                                        gSounds['pickup']:play()
                                        gStateMachine:change('play', { 
                                            score = player.score, 
                                            width = player.level.tileMap.width
                                        })
                                    end
                                }

                                table.insert(player.level.objects, pole)

                                -- spawn flag at the end of the level
                                local flag = GameObject {
                                    texture = 'flags',
                                    x = flagX,
                                    y = flagY,
                                    width = 16,
                                    height = 16,
                                    frame = math.random(4),
                                    collidable = true,
                                    consumable = true,
                                    solid = false,

                                    -- when touched, change the level
                                    onConsume = function(player)
                                        gSounds['pickup']:play()
                                        gStateMachine:change('play', { 
                                            score = player.score, 
                                            width = player.level.tileMap.width
                                        })
                                    end
                                }

                                table.insert(player.level.objects, flag)

                            else
                            -- if player doesn't have the key, just play sound
                                gSounds['empty-block']:play()
                            end
                        end
                    }
                )
            -- chance to spawn a block
            elseif math.random(10) == 1 then
                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )
            end

            -- spawn a key if we are in the defined position
            if x == keyX then
                local key = GameObject {
                    texture = 'keys-and-locks',
                    x = (x - 1) * TILE_SIZE,
                    y = (blockHeight + 1) * TILE_SIZE,
                    width = 16,
                    height = 16,
                    frame = keyColor,
                    collidable = true,
                    consumable = true,
                    solid = false,

                    -- pick up the key
                    onConsume = function(player, obj)
                        gSounds['pickup']:play()
                        local key = obj
                        key.x = 5
                        key.y = TILE_SIZE
                        player.hasKey = key
                    end
                }

                table.insert(objects, key)
            end
        end
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end