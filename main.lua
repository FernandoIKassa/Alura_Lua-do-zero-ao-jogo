SCREEN_WEIGHT = 320
SCREEN_HEIGHT = 480

MAX_METEORS = 12

player = {
    imageSource = "imagens/14bis.png",
    sizeX = 64,
    sizeY = 64,
    positionX = SCREEN_WEIGHT/2 - 64/2, -- 64/2 represents player's X size divide 2
    positionY = SCREEN_HEIGHT - 64,  -- 64 represents player's Y size
    speedMovement = 3
}

function PlayerMove()
    if love.keyboard.isDown("w", "a", "d", "s") then
        if love.keyboard.isDown("w") then
            player.positionY = player.positionY - player.speedMovement
        end
        if love.keyboard.isDown("s") then
            player.positionY = player.positionY + player.speedMovement
        end
        if love.keyboard.isDown("a") then
            player.positionX = player.positionX - player.speedMovement
        end
        if love.keyboard.isDown("d") then
            player.positionX = player.positionX + player.speedMovement
        end
    end 
end


meteors = {}

function createMeteor()
    meteor = {
        positionX = math.random(SCREEN_WEIGHT),
        positionY = 0,
        speed = math.random(4),
        horizontalMovement = math.random(-1, 1)
    }
    table.insert(meteors, meteor)

end

function moveMeteor()
    for key, meteor in pairs(meteors) do
        meteor.positionY = meteor.positionY + meteor.speed
        meteor.positionX = meteor.positionX + meteor.horizontalMovement

    end
end

function removeMeteor()
    for i = #meteors, 1, -1 do
        if meteors[i].positionY > SCREEN_HEIGHT then
            table.remove(meteors, i)
        end
    end
end

function love.load()
    love.window.setTitle("14bis vs meteors")
    love.window.setMode(SCREEN_WEIGHT, SCREEN_HEIGHT, {resizable = false})

    background = love.graphics.newImage("imagens/background.png")
    player.image = love.graphics.newImage(player.imageSource)
    meteor_source = love.graphics.newImage("imagens/meteoro.png")
end

function love.update(dt)
    PlayerMove()
    removeMeteor()
    if #meteors < MAX_METEORS then
        createMeteor()
    end
    moveMeteor()
end

function love.draw()
    love.graphics.draw(background, 0 ,0)
    love.graphics.draw(player.image, player.positionX , player.positionY)

    for key, meteor in pairs(meteors) do
        love.graphics.draw(meteor_source, meteor.positionX, meteor.positionY)
    end

end