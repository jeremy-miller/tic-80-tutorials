-- title:  Breakout
-- author: Jeremy Miller
-- desc:   Breakout
-- script: lua

-- buttons
LEFT=2
RIGHT=3
B=5

function init()
	player={
		x=(240/2)-12,
		y=120,
		width=24,
		height=4,
		color=14,
		speed={
			x=0,
			max=4,
		}
	}
	
	ball={
		x=player.x+(player.width/2)-1.5,
		y=player.y-5,
		width=3,
		height=3,
		color=12,
		active=false,
		speed={
			x=0,
			y=0,
			max=1.5,
		}
	}
	
	lives=3
	score=0
	
	bricks={}
	brickCountWidth=19
	brickCountHeight=12
	createBricks()
	
	bgColor=0
end

function createBricks()
	for i=0,brickCountHeight do
		for j=0,brickCountWidth do
			local brick={
				x=10+j*11,
				y=10+i*5,
				width=10,
				height=4,
				color=i+1,
			}
			table.insert(bricks,brick)
		end
	end
end

function input()
	local sx=player.speed.x
	local smax=player.speed.max

	if btn(LEFT) then
		if sx>-smax then
			sx=sx-2
		else
			sx=-smax
		end
	end
	
	if btn(RIGHT) then
		if sx<smax then
			sx=sx+2
		else
			sx=smax
		end
	end
	
	player.speed.x=sx
	player.speed.max=smax
	
	if not ball.active then
		ball.x=player.x+(player.width/2)-1.5
		ball.y=player.y-5
		
		if btn(B) then
			ball.speed.x=math.floor(math.random())*2-1
			ball.speed.y=-1.5
			ball.active=true
		end
	end
end

function update()
	-- player
	local px=player.x
	local psx=player.speed.x
	local smax=player.speed.max
	
	px=px+psx
	
	if psx~=0 then
		if psx>0 then
			psx=psx-1
		else
			psx=psx+1
		end
	end
	
	player.x=px
	player.speed.x=psx
	player.speed.max=smax
	
	-- ball
	ball.x=ball.x+ball.speed.x
	ball.y=ball.y+ball.speed.y
	
	if ball.speed.x>ball.speed.max then
		ball.speed.x = ball.speed.max
	end
end

function collisions()
	playerWallCollision()
	ballWallCollision()
	playerBallCollision()
 ballBrickCollision()
end

function playerWallCollision()
	if player.x<0 then
		player.x=0
	elseif player.x+player.width>240 then
		player.x=240-player.width
	end
end

function ballWallCollision()
	if ball.y<0 then
		-- top
		ball.speed.y=-ball.speed.y
	elseif ball.x<0 then
		-- left
		ball.speed.x=-ball.speed.x
	elseif ball.x>240-ball.width then
		-- right
		ball.speed.x=-ball.speed.x
	elseif ball.y>136-ball.height then
		--bottom
		ball.active=false
		if lives>0 then
			lives=lives-1
		else
			gameOver()
		end
	end
end

function gameOver()
	print("Game Over",(240/2)-6*4.5,136/2)
	if btn(B) then
		init() -- restart game
	end
end

function playerBallCollision()
	if collide(player,ball) then
		ball.speed.x=ball.speed.x+0.3*player.speed.x
		ball.speed.y=-ball.speed.y
	end
end

function ballBrickCollision()
	for i,brick in pairs(bricks) do
		if collide(ball,bricks[i]) then
			-- left/right collision
			if bricks[i].y<ball.y and
						ball.y<bricks[i].y+bricks[i].height and
						ball.x<bricks[i].x or
						bricks[i].x+bricks[i].width<ball.x then
				ball.speed.x=-ball.speed.x
			end
			
			-- top/bottom collision
			if ball.y<bricks[i].y or
						ball.y>bricks[i].y and
						bricks[i].x<ball.x and
						ball.x<bricks[i].x+bricks[i].width then
				ball.speed.y=-ball.speed.y
			end
			table.remove(bricks,i)
			score=score+1
		end
	end
end

function collide(a,b)
	if a.x<b.x+b.width and
				a.x+a.width>b.x and
				a.y<b.y+b.height and
				a.y+a.height>b.y	then
		-- collision
		return true
	else
		return false
	end
end

function draw()
	drawGameObjects()
	drawGUI()
end

function drawGameObjects()
	-- player
	rect(
		player.x,
		player.y,
		player.width,
		player.height,
		player.color
	)
	-- ball
	rect(
		ball.x,
		ball.y,
		ball.width,
		ball.height,
		ball.color
	)
	
	-- bricks
	for i,brick in pairs(bricks) do
		rect(
			bricks[i].x,
			bricks[i].y,
			bricks[i].width,
			bricks[i].height,
			bricks[i].color
		)
	end
end

function drawGUI()
	print("Score ",5,1,15)
	print(score,40,1,15)
	print("Score ",5,0,13)
	print(score,40,0,13)
	print("Lives ",190,1,15)
 print(lives,225,1,15)
 print("Lives ",190,0,13)
 print(lives,225,0,13)
end

init()

function TIC()
	cls(bgColor)
	input()
	if lives>0 then
		update()
		collisions()
		draw()
	else
		gameOver()
	end
end

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

