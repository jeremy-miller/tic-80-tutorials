-- title:  Warm Wheels
-- author: Jeremy Miller
-- desc:   Sandbox driving game
-- script: lua

-- buttons
LEFT=2
RIGHT=3
A=4

TURN_RADIUS=0.05
ACCEL_VALUE=0.02
ROAD_FRICTION=0.98
GRASS_FRICTION=0.95
ALIGNMENT=0.02 -- how fast velocity catches up to direction

PI2=math.pi*2

car={
	x=120,
	dx=0,
	y=68,
	dy=0,
	a=0,
}

-- rotate a vector by an angle
function rotate(x,y,a)
	return
		(x*math.cos(a))-(y*math.sin(a)),
		(x*math.sin(a))+(y*math.cos(a))
end

-- get vector of given length, oriented
-- on the given angle
function vector(length,angle)
	return rotate(0,-length,angle)
end

-- get the angle of a vector
function angle(x,y)
	-- account for origin being in top-left corner,
	-- not bottom-left corner
	return math.pi - math.atan2(x,y)
end

-- get angle from one point to another
function angle2(fromX,fromY,toX,toY)
	return angle(toX-fromX,toY-fromY)
end

-- add two angles, ensuring result is
-- in 0-2pi range
function angleAdd(ang,deg)
	ang=ang+deg
	if ang<0 then
		ang=ang+PI2
	elseif ang>=PI2 then
		ang=ang-PI2
	end
	return ang
end

-- calculate if two angles are closer
-- in positive or negative direction
-- -1=decrease "from" angle
-- 0=equivalent
-- 1=increate "from" angle
function angleDir(fromAng,toAng)
	local diff=toAng-fromAng
	-- avoid rounding errors that prevent settling
	if math.abs(diff)<0.00001 then return 0 end
	if diff>math.pi then
		return -1
	elseif diff<-math.pi then
		return 1
	else
		return diff>0 and 1 or -1
	end
end

-- get length of given vector
function vecLen(x,y)
	return math.sqrt(x^2 + y^2)
end

function round(x)
	return x+0.5-(x+0.5)%1
end

function drawCar(c)
	local idx=round(c.a*16/PI2)%16
	spr(256+(idx%4),math.floor(c.x)-4,math.floor(c.y)-4,14,1,0,idx//4)
end

function TIC()
	if btn(LEFT) then car.a=angleAdd(car.a,-TURN_RADIUS) end
	if btn(RIGHT) then car.a=angleAdd(car.a,TURN_RADIUS) end
	
	cls(14)
	rect(120,0,120,136,5) -- grass
	
	drawCar(car)
	
	if btn(A) then
		local ax,ay=vector(ACCEL_VALUE,car.a)
		car.dx=car.dx+ax
		car.dy=car.dy+ay
	end
	
	-- apply friction
	local friction=car.x>120 and DIRT_FRICTION or ROAD_FRICTION
	car.dx=car.dx*friction
	car.dy=car.dy*friction
	
	-- rotate velocity to match car direction
	local velAng=angle(car.dx,car.dy)
	local dir=angleDir(velAng,car.a)
	car.dx,car.dy=rotate(car.dx,car.dy,ALIGNMENT*dir)
	
	car.x=car.x+car.dx
	car.y=car.y+car.dy
end

-- <SPRITES>
-- 000:eeeeeeeeee4224eee02aa20eeea22aeeee2222eee022220eee2222eeeeeeeeee
-- 001:eeeeeeeeeee422eeee0aa24eeea22a0ee0222aeee22220eeeee22eeeeeeeeeee
-- 002:eeeeeeeeeee042eeeeeaaa2ee0222a4ee2222a0eee222eeeeee20eeeeeeeeeee
-- 003:eeeeeeeeeeee04eeee0aa22ee2222a2ee2222a4eee22a0eeee20eeeeeeeeeeee
-- </SPRITES>

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

