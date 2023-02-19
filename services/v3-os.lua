-- W:288 H:160
tick = 0

color       = screen.setColor               -- (r,g,b,a)
clear       = screen.drawClear
print       = screen.drawText       	    -- (x, y, text)
printBox    = screen.drawTextBox        	-- (x, y, w, h, text, h_align, v_align)
line        = screen.drawLine       	    -- (x1, y1, x2, y2)
circle      = screen.drawCircle     	    -- (x, y, radius)
circleF     = screen.drawCircleF        	-- (x, y, radius)
rect        = screen.drawRect       	    -- (x, y, width, height)
rectF       = screen.drawRectF      	    -- (x, y, width, height)


-- Tick function that will be executed every logic tick
function onTick()
    value = input.getNumber(1)			 -- Read the first number from the script's composite input
    output.setNumber(1, value * 10)		-- Write a number to the script's composite output
end

-- Draw function that will be executed when this script renders to a screen
function onDraw()
    W=screen.getWidth()
    H=screen.getHeight()
    
    wp = W/12
    hp = H/6
    
    -- Background
    color(30,30,30)
    rectF(0,0,W,H)
    
	color(0,0,0)
	print(1,1, "W:"..W.." / H:"..H)
    printBox(1,6,50,10,"TEXT BOX TEST",0,-1)

end