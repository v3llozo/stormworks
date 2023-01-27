-- auto throtle and gear
-- throttle = { 0.12, 0.16, 0.21, 0.27, 0.30, 0.35, 0.45, 0.5, 0.12, 0 }
-- gear     = {    0,    0,    1,    0,    1,    1,    1,   1,    0, 0 }

-- gears
-- a=3:1 | b=5:2 | c=9:5
-- a=  3 | b=2.5 | c=1.8
-- [0] a+b+c = 7.3
-- [1] a+b   = 5.5
-- [2] a+c   = 4.8
-- [3] b+c   = 4.3
-- [4] a	 =   3
-- [5] b     = 2.5
-- [6] c     = 1.8
-- [7]       =   0

-- if gear 3 || 2 || 1
-- g3 = 0
-- g2 = 0
-- g3 = 0

-- | 0 | 0 | 0 |
-- | 0 | 0 | 1 |
-- | 0 | 1 | 0 |
-- | 1 | 0 | 0 |
-- | 0 | 1 | 1 |
-- | 1 | 0 | 1 |
-- | 1 | 1 | 0 |
-- | 1 | 1 | 1 |

-- ||===================================||
-- || 32  | 16  |  8  |  4  |  2  |  1  ||
-- ||===================================||
-- ||  0  |  0  |  0  |  0  |  0  |  0  || = 0
-- ||  0  |  0  |  0  |  0  |  0  |  1  || = 1
-- ||  0  |  0  |  0  |  0  |  1  |  0  || = 2
-- ||  0  |  0  |  0  |  0  |  1  |  1  || = 3
-- ||  0  |  0  |  0  |  1  |  0  |  0  || = 4
-- ||  0  |  0  |  0  |  1  |  0  |  1  || = 5
-- ||  0  |  0  |  0  |  1  |  1  |  0  || = 6
-- ||  0  |  0  |  0  |  1  |  1  |  1  || = 7
-- ||  0  |  0  |  1  |  0  |  0  |  0  || = 8
-- ||  0  |  0  |  1  |  0  |  0  |  1  || = 9
-- || ... | ... | ... | ... | ... | ... || = ...
-- ||  1  |  1  |  1  |  1  |  1  |  1  || = 63
-- ||===================================||

function onTick()
	gear = input.getNumber(1)
	gearCount = input.getNumber(2)
    output.setNumber(4,gear)
	gearHash = {
	 {[1]=false,[2]=false,[3]=false},
	 {[1]=false,[2]=false,[3]=true },
	 {[1]=false,[2]=true ,[3]=false},
	 {[1]=true ,[2]=false,[3]=false},
	 {[1]=false,[2]=true ,[3]=true },
	 {[1]=true ,[2]=false,[3]=true },
	 {[1]=true ,[2]=true ,[3]=false},
	 {[1]=true ,[2]=true ,[3]=true }
	}
    if gear < 2 then
        output.setBool(1,gearHash[1][1])
        output.setBool(2,gearHash[1][2])
        output.setBool(3,gearHash[1][3])
    elseif gear > 7 then
        output.setBool(1,gearHash[8][1])
        output.setBool(2,gearHash[8][2])
        output.setBool(3,gearHash[8][3])
    else
        output.setBool(1,gearHash[gear][1])
        output.setBool(2,gearHash[gear][2])
        output.setBool(3,gearHash[gear][3])
    end
end