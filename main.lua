-- D:\ProgramsForCoding\love2D\love.exe C:\Users\Issao\Desktop\Lua_Workspace\loveGame
SCREEN_WIDTH = 320
SCREEN_HEIGHT = 480

MAX_METEORS = 10
END_GAME = false

METEOR_HIT = 0
METEOR_HIT_GOAL = 10

player = {
    imageSource = "imagens/14bis.png",
    width = 50,
    height = 60,
    positionX = SCREEN_WIDTH/2 - 64/2, -- 64/2 represents player's X size divide 2
    positionY = SCREEN_HEIGHT - 64,  -- 64 represents player's Y size
    speedMovement = 3,
    shoots = {}
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

function destroyPlayer()
    destroyedSound:play()
    player.imageSource = "imagens/explosao_nave.png"
    player.image = love.graphics.newImage(player.imageSource)
    player.width = 67
    player.height = 77
    END_GAME = true
end

function shoot()
    shooting:play()
    local bullet = {
        imageSource = "imagens/tiro.png",
        x = player.positionX + player.width/2,
        y = player.positionY,
        width = 16,
        height = 16
    }

    table.insert(player.shoots, bullet)
end

function moveBullets()
    for i=#player.shoots,1,-1 do
        if player.shoots[i].y > 0 then
            player.shoots[i].y = player.shoots[i].y - 2
        else
            table.remove(player.shoots, i)
        end
    end

end

meteors = {}

function createMeteor()
    meteor = {
        positionX = math.random(SCREEN_WIDTH),
        positionY = 0,
        width = 48,
        height = 40,
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

function gotCollision(X1, Y1, L1, A1, X2, Y2, L2, A2)
    return  X2 < X1 + L1 and
            X1 < X2 + L2 and
            Y2 < Y1 + A1 and
            Y1 < Y2 + A2
end

function checkCollision()
    checkCollisionWithMeteor()
    checkCollisionBulletMeteor()
end

function checkCollisionWithMeteor()
    for key, meteor in pairs(meteors) do
        if gotCollision(meteor.positionX, meteor.positionY, meteor.width, meteor.height,
                        player.positionX, player.positionY, player.width, player.height) then
            destroyPlayer()
            changeMusicToGameOver()
        end
    end
end

function checkCollisionBulletMeteor()
    for i = #player.shoots, 1, -1 do
        for j = #meteors, 1, - 1 do
            if gotCollision(player.shoots[i].x, player.shoots[i].y, player.shoots[i].width, player.shoots[i].height,
            meteors[j].positionX, meteors[j].positionY, meteors[j].width, meteors[j].height) then
                METEOR_HIT = METEOR_HIT + 1
                table.remove(player.shoots, i)
                table.remove(meteors, j)
                break
            end
        end
    end
end

function changeMusicToGameOver()
    backgroundMusic:stop()
    gameOverSound:play()
end

function checkMainGoal()
    if METEOR_HIT >= METEOR_HIT_GOAL then
        WIN = true
        winnerSound:play()
        backgroundMusic:stop()
    end
end

function love.load()
    love.window.setTitle("14bis vs meteors")
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT, {resizable = false})

    --Images loading
    background = love.graphics.newImage("imagens/background.png")
    gameOver_scene = love.graphics.newImage("imagens/gameover.png")
    win_scene = love.graphics.newImage("imagens/vencedor.png")

    player.image = love.graphics.newImage(player.imageSource)
    meteor_source = love.graphics.newImage("imagens/meteoro.png")
    shoot_img = love.graphics.newImage("imagens/tiro.png")


    -- Scenario audio loading
    backgroundMusic = love.audio.newSource("audios/ambiente.wav", "static")
    destroyedSound = love.audio.newSource("audios/destruicao.wav", "static")
    gameOverSound = love.audio.newSource("audios/game_over.wav", "static")
    winnerSound = love.audio.newSource("audios/winner.wav", "static")
    

    -- Player audio loading
    shooting = love.audio.newSource("audios/disparo.wav", "static")
    
    -- Audio setting
    backgroundMusic:setLooping(true)
    backgroundMusic:play()


end

function love.keypressed(tecla)
    if tecla == "escape" then
        love.event.quit()
    elseif tecla == "space" then
        shoot()
    end
end

function love.update(dt)
    if not END_GAME and not WIN then
        PlayerMove()
        removeMeteor()
        if #meteors < MAX_METEORS then
            createMeteor()
        end
        moveMeteor()        
        moveBullets()
        checkCollision()
        checkMainGoal()
    end
end

function love.draw()
    love.graphics.draw(background, 0 ,0)
    love.graphics.draw(player.image, player.positionX , player.positionY)

    love.graphics.print("Meteors remaining: "..METEOR_HIT_GOAL - METEOR_HIT, 0, 0)

    for key, meteor in pairs(meteors) do
        love.graphics.draw(meteor_source, meteor.positionX, meteor.positionY)
    end

    for key, shoot in pairs(player.shoots) do
        love.graphics.draw(shoot_img, shoot.x, shoot.y)
    end

    if END_GAME then
        -- love.graphics.draw(gameOver_scene, SCREEN_WIDTH - gameOver_scene:getWidth()/2, SCREEN_HEIGHT - gameOver_scene:getHeight()/2)
        love.graphics.draw(gameOver_scene, SCREEN_WIDTH/2 - gameOver_scene:getWidth()/2, SCREEN_HEIGHT/2 - gameOver_scene:getHeight()/2)
        --love.graphics.draw(gameOver_scene, 0, 0)
    end

    if WIN then
        love.graphics.draw(win_scene, SCREEN_WIDTH/2 - win_scene:getWidth()/2, SCREEN_HEIGHT/2 - win_scene:getHeight()/2)
    end

end