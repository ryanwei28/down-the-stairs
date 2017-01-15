-----------------------------------------------------------------------------------------
--仿作一個下樓梯的遊戲
--碰到上方或是階梯上的尖刺損失LIFE
--歸零則結束遊戲
--掉落深淵也結束遊戲
--

--Date:2016/08/29   19:35
--Author:Ryan
-----------------------------------------------------------------------------------------

--=======================================================================================
--引入各種函式庫
--=======================================================================================
display.setStatusBar( display.HiddenStatusBar ) 
math.randomseed( os.time()) 
local scene = composer.newScene( )
local physics = require("physics" ) 
local movieClip = require("movieclip")
physics.start( )  
physics.pause( ) 

physics.setGravity( 0 , 9.81) 
-- physics.setDrawMode("hybrid") 
--=======================================================================================
--宣告各種變數
--=======================================================================================

local left
local right
local bgImg
local thorn
local top
local startLadder
local gamePauseImg
local backGroup = display.newGroup( )
local midGroup = display.newGroup( )
local numberGroup = display.newGroup( )
local foreGroup = display.newGroup( )
local ladderImg
local gameoverImg
local backHome
local man
local img
local img2
local img3
local addfloor 
ladder = {}
num = {}
-- local moveLadderSpeed
local addLadderSpeed = 1000 -- 階梯增加速度
local f = 0 --計時初始值
local f2 = 0
local f3 = 0

local dieLine
mc = movieClip.newAnim({"images/man.png","images/right1.png","images/right2.png","images/left1.png","images/left2.png"})
local boundaryData = {
	{group = foreGroup , path = "images/rimStraight.png" , w = 5 , h =  _SCREEN.H - 80 , x = 2 , y = _SCREEN.CENTER.Y + 40,} ,
	{group = foreGroup , path = "images/rimStraight.png" , w = 5 , h =  _SCREEN.H - 80 , x = _SCREEN.W - 2  , y = _SCREEN.CENTER.Y + 40,} ,
	{group = foreGroup , path = "images/rimHori.png" , w = _SCREEN.W , h =  5 , x = _SCREEN.CENTER.X , y = 80,} , 
	{group = foreGroup , path = "images/rimHori.png" , w = _SCREEN.W , h =  5 , x = _SCREEN.CENTER.X , y = _SCREEN.H,} , 
	{group = midGroup , path = "images/boundary.png" , w = 20 , h =  _SCREEN.H - 80 , x = 14 , y = _SCREEN.CENTER.Y + 40,} , 
	{group = midGroup , path = "images/boundary.png" , w = 20 , h =  _SCREEN.H - 80 , x = _SCREEN.W - 15 , y = _SCREEN.CENTER.Y + 40,} ,
}

local pools = {
	ladder ={ } ,
	vanishLadder = { } ,
	spring = { } ,
	trap = { }
}

local numTable = {
	{path = "images/1.png" } ,
	{path = "images/2.png" } ,
	{path = "images/3.png" } ,
	{path = "images/4.png" } ,
	{path = "images/5.png" } ,
	{path = "images/6.png" } ,
	{path = "images/7.png" } ,
	{path = "images/8.png" } ,
	{path = "images/9.png" } ,
	{path = "images/0.png" } 
}

local floorImg = {
	{ x = 260 , removeTime = 2500} , 
	{ x = 240 ,removeTime = 15500} , 
	{ x = 220 ,removeTime = 150500} , 
	{ x = 200 ,removeTime = 1500500} 
}

local isOver = false
print( moveLadderSpeed )
--=======================================================================================
--宣告各個函式名稱
--=======================================================================================
local initial
local moveLadder
local addLadder
local moveMan
local controlMan
local recycleLadder
local dieLineCollision
-- local timerStart
local lifeRestoer
local initScene
local gameoverChk
--=======================================================================================
--宣告與定義main()函式
--=======================================================================================
local main = function ( )
	initial()
end

--=======================================================================================
--定義其他函式
--=======================================================================================
function print_r ( t )  
    local print_r_cache={}
    local function sub_print_r(t,indent)
        if (print_r_cache[tostring(t)]) then
            print(indent.."*"..tostring(t))
        else
            print_r_cache[tostring(t)]=true
            if (type(t)=="table") then
                for pos,val in pairs(t) do
                    if (type(val)=="table") then
                        print(indent.."["..pos.."] => "..tostring(t).." {")
                        sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                        print(indent..string.rep(" ",string.len(pos)+6).."}")
                    elseif (type(val)=="string") then
                        print(indent.."["..pos..'] => "'..val..'"')
                    else
                        print(indent.."["..pos.."] => "..tostring(val))
                    end
                end
            else
                print(indent..tostring(t))
            end
        end
    end
    if (type(t)=="table") then
        print(tostring(t).." {")
        sub_print_r(t,"  ")
        print("}")
    else
        sub_print_r(t,"  ")
    end
    print()
end

initial = function ( sceneGroup )
	sceneGroup:insert( backGroup ) 
    sceneGroup:insert( midGroup )
    sceneGroup:insert( numberGroup )
    sceneGroup:insert( foreGroup )
	if moveLadderSpeed ~= 5000 then
		moveLadderSpeed = composer.getVariable( "moveLadderSpeed" ) -- 階梯移動速度
	end
	physics.start( )  

	--加入背景
	bgImg = display.newImageRect( backGroup , "images/bgImg.png", _SCREEN.W , _SCREEN.H )
	bgImg.x , bgImg.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y

	--加入上方尖刺
	thorn = display.newImageRect( midGroup , "images/thorn.png", _SCREEN.W , 30*HEIGHT )
	thorn.id = "thorn"
	thorn.x , thorn.y = _SCREEN.CENTER.X , 95*HEIGHT
	physics.addBody( thorn , "static" )

	--加入邊框
	boundary = {}
	for i = 1 , #boundaryData do 
		bud = boundaryData[i]
		boundary[i] = display.newImageRect( bud.group , bud.path , bud.w , bud.h )
		boundary[i].x , boundary[i].y = bud.x ,bud.y 
	end
	physics.addBody( boundary[5], "static" )
	physics.addBody( boundary[6], "static" )

	--加入上方介面
	top = display.newImageRect( foreGroup , "images/top.png" , _SCREEN.W , 80*HEIGHT )
	top.x , top.y = _SCREEN.CENTER.X , 38*HEIGHT
	black = display.newImageRect( numberGroup , "images/black.png", 190*WIDTH , 80*HEIGHT )
	black.x , black.y = 240*WIDTH , 40*HEIGHT
	black2 = display.newRect( numberGroup , 60*WIDTH , 40*HEIGHT , 80 , 40*HEIGHT )
	black2.anchorY = 0
	black2:setFillColor( 0 )
	life = display.newRect( numberGroup , 20*WIDTH , 60*HEIGHT , 72*WIDTH , 30*HEIGHT )
	life.anchorX = 0
	life:setFillColor( 255/255 , 255/255 , 0 )

	--加入主角
	mc:stopAtFrame(1)
	mc.x , mc.y = 160*WIDTH , 400*HEIGHT
	mc.width , mc.height = 30*WIDTH , 30*HEIGHT
	mc:setSpeed(1)
	physics.addBody(mc , "dynamics" , { friction = 0 , bounce = 0 , radius = 15})
	mc.id = "man"
	mc.isFixedRotation = true
	midGroup:insert( mc )
	
	thorn.collision = thornCollision
	thorn:addEventListener( "collision", thorn )

	--加入左右控制鍵
	left = display.newImageRect( foreGroup , "images/left.png" , 60*WIDTH , 60*HEIGHT )
	left.x , left.y = 50*WIDTH , 450 *HEIGHT
	left.alpha = 0.5
	left.id = "left"

	right = display.newImageRect( foreGroup , "images/right.png" , 60*WIDTH , 60*HEIGHT )
	right.x , right.y = 270*WIDTH , 450*HEIGHT
	right.alpha = 0.5
	right.id = "right"

	left:addEventListener( "touch", move ) 
	right:addEventListener( "touch", move )
	
	--加入起始階梯
	startLadder = display.newImageRect( midGroup , "images/ladder.png", 100*WIDTH, 20*HEIGHT )
	startLadder.x , startLadder.y = 160*WIDTH , 450*HEIGHT
	physics.addBody( startLadder , "static" )
	stLadderTran =  transition.to( startLadder , {time = 5000 , y = 0 , tag = ladder , onComplete = function ( )
		if startLadder then
			startLadder:removeSelf( )
		end
	end} )

	--加入暫停圖示
	gamePauseImg = display.newImageRect( foreGroup , "images/pause.png", 30*WIDTH, 30*HEIGHT )
	gamePauseImg.x , gamePauseImg.y = 20*WIDTH , 20*HEIGHT
	gamePauseImg:addEventListener( "tap", gamePause )

	--回收階梯
	net = display.newRect( midGroup , 160 , 60 , _SCREEN.W , 3 )
	physics.addBody( net , "dynamics" )
	net.id = "net"
	net.isVisible = false
	net.collision = recycleLadder
	net:addEventListener( "collision", net )

	--死亡線
	dieLine = display.newRect( midGroup, 160 , 490 , _SCREEN.W , 3 )
	dieLine.id = "dieLine"
	physics.addBody( dieLine , "static" )
	dieLine.collision = dieLineCollision
	dieLine:addEventListener( "collision", dieLine )

	--加入結束圖片並隱藏
	gameoverImg = display.newImageRect( foreGroup , "images/gameover.png", 150*WIDTH , 40*HEIGHT )
	gameoverImg.x , gameoverImg.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y
	gameoverImg.isVisible = false

	backHome = display.newImageRect( foreGroup , "images/backhome.jpg", 50*WIDTH, 50*HEIGHT )
	backHome.x , backHome.y = 100*WIDTH , 300*HEIGHT
	backHome.isVisible = false
	audio.resume( 1 )
end

--遊戲暫停函式
gamePause = function (  )
	local options = { isModal = true , effect = "crossFade" , time = 400 }
	composer.showOverlay( "pauseMenu" , options )	
	mc.x , mc.y = mc.x , mc.y
	mc.isBodyActive = false
	transition.pause( cancelLadder )

	for i = 1 , 4 do 
		num[i]:stop( )
	end
		
	if ladderTmr then
		timer.pause( ladderTmr )		
	end

	-- timer.pause( numTmr )
end

--控制主角移動
move = function ( e )
	if (e.phase == "began") then
		display.getCurrentStage( ):setFocus( e.target )
		e.target.alpha = 1

		if (e.target.id == "right") then
			right.moveTmr = timer.performWithDelay( 10, function (  )
				mc.x = mc.x + 4		
			end , -1 )
			mc:play({startFrame = 2 , endFrame = 3 , loop = -1 , remove = false})
		end

		if (e.target.id == "left") then
			left.moveTmr = timer.performWithDelay( 10, function (  )
				mc.x = mc.x - 4					
			end , -1 )
			mc:play({startFrame = 4 , endFrame = 5 , loop = -1 , remove = false})
		end
	end
	
	if (e.phase == "ended") or (e.phase == "cancelled") then
		display.getCurrentStage( ):setFocus(nil)
		e.target.alpha = 0.5
		timer.cancel( e.target.moveTmr )
		mc:stopAtFrame(1)
	end
	
end

--回復life
lifeRestoer = function (  )
	if (life.width <= 66 ) then
		life.width = life.width + 6 
	end
end

--各種階梯碰撞函式
onCollision = function ( self,e )
	
	if (e.other.id == "man") then
		if (self.id == "ladder" ) then
			audio.play( sound1 )
			self:removeEventListener( "collision", self )
			lifeRestoer()
		end

		if (self.id == "vanishLadder" ) then
			audio.play( sound2 )
			self:removeEventListener( "collision", self )
			transition.to( self , {time = 500 , alpha = 0.2} )
			timer.performWithDelay( 500 , function (  )
				self.isBodyActive = false
			end )
			lifeRestoer()
		end

		if (self.id == "spring" ) then
			audio.play( sound3 )
			transition.to( self , {time = 500 , yScale = 1.5 , transition = easing.continuousLoop } )
			self:removeEventListener( "collision", self )
			lifeRestoer()
		end

		if (self.id == "trap" ) then
			if (life.width <= 24 ) then
				life.width = 0
			end
			life.width = life.width - 24
			audio.play( sound4 )
			self:removeEventListener( "collision", self )
			gameoverChk()
		end
	end
end

--回收階梯
recycleLadder = function ( self , e )
	if (self.id == "net") and (e.other.id == "ladder") or (e.other.id == "vanishLadder") or (e.other.id == "spring") or (e.other.id == "trap") then
		e.other:removeSelf( )
	end
end

--上方尖刺碰撞函式
thornCollision = function ( self,e )
	if (self.id == "thorn") and (e.other.id == "man") then
		if (life.width <= 24 ) then
			life.width = 0
		end
		life.width = life.width - 24
		audio.play( sound4 )
		self:removeEventListener( "collision", self )
		timer.performWithDelay( 1000 , function (  )
			self:addEventListener( "collision", self )
		end )
		gameoverChk()
	end
end


--增加階梯函式
addLadder = function (  )
		
	ladder[1] = { path = "images/ladder.png" , id = "ladder" , params = {friction = 0 , bounce = 0 } , t = pools.ladder }
	ladder[2] = { path = "images/vanishLadder.png" , id = "vanishLadder" , params = {friction = 0 , bounce = 0 } , t = pools.vanishLadder }
	ladder[3] = { path = "images/spring.png" , id = "spring" , params = {friction = 0 , bounce = 1 } , t = pools.spring }
	ladder[4] = { path = "images/trap.png" , id = "trap" , params = {friction = 0 , bounce = 0 } , t = pools.trap }
	ladder[5] = { path = "images/ladder.png" , id = "ladder" , params = {friction = 0 , bounce = 0 } , t = pools.ladder }
	ladder[6] = { path = "images/ladder.png" , id = "ladder" , params = {friction = 0 , bounce = 0 } , t = pools.ladder }

	i = math.random( 6 )
	j = math.random( 3 , 12 )*20 
	ladderImg = display.newImageRect( backGroup , ladder[i].path , 100 , 20 )
	ladderImg.x , ladderImg.y = j , 500
	ladderImg.id = ladder[i].id
	physics.addBody( ladderImg, "static", ladder[i].params )
	ladderTran = transition.to( ladderImg , {time = moveLadderSpeed , y = 0 , tag = cancelLadder})

	ladderImg.collision = onCollision
	ladderImg:addEventListener( "collision", ladderImg )	
end

--掉落底部
dieLineCollision = function ( self,e )
	if self.id == "dieLine" and e.other.id == "man" then
		life.width = 0
		gameoverChk()
	end
end

--移動階梯
moveLadder = function (  )
	ladderTmr = timer.performWithDelay( addLadderSpeed , addLadder , -1 )
end

--開始計時函式
timerStart = function (  )
	for i = 1 , 4 do
		num[i] = movieClip.newAnim({"images/0.png","images/1.png","images/2.png","images/3.png","images/4.png","images/5.png","images/6.png","images/7.png","images/8.png","images/9.png"})

		flCount = {}
		flCount[1] = { x = 200*HEIGHT , speed = 0.00003 , delay = 1000000 }
		flCount[2] = { x = 220*HEIGHT , speed = 0.0003 , delay = 100000 }
		flCount[3] = { x = 240*HEIGHT , speed = 0.003 , delay = 10000 }
		flCount[4] = { x = 260*HEIGHT , speed = 0.03 , delay = 1000 }

		num[i]:stopAtFrame(1)
		num[i].x , num[i].y = flCount[i].x , 40*HEIGHT
		num[i].width , num[i].height = 25*WIDTH , 50*HEIGHT
		numberGroup:insert( num[i] )
		num[i]:setSpeed(flCount[i].speed)
		num[i]:play({startFrame = 1 , endFrame = 10 , loop = -1 , remove = false})

		-- numTmr = timer.performWithDelay( flCount[i] , function ( )
		-- 	num[i].y =  0
		-- 	transition.to( num[i] , {time = 500 , y = 40 , tag = "stopNum"})
		-- end , -1)
	end
end

--確認是否遊戲結束
gameoverChk = function (  )
	print('gamerover')
	if (life.width <= 5) then
		if (isOver == true) then
			return
		else
			isOver = true
		end
		audio.pause( 1 )
		audio.rewind( 1 )		
		--增加gameover圖片
		gameoverImg.isVisible = true
		backHome.isVisible = true
		transition.to( backHome , {time = 600 , rotation = 360 , x = 160 } )
		backHome:addEventListener( "tap", function (  )
			print('backHome')
			local options = { effect = "fade" , time = 400}
			composer.gotoScene( "scene1" , options )
		end )
		
		audio.play( sound5 )
		timer.cancel( ladderTmr )
		
		for i = 1 , 4 do 
			num[i]:stop( )
		end
		-- timer.cancel( flTmr )
		timer.performWithDelay( 1 , function (  )
			mc.isBodyActive = false
		end ) 
		mc.isVisible = false
	end
end

--=======================================================================================
--Composer
--=======================================================================================

--畫面沒到螢幕上時，先呼叫scene:create
--任務:負責UI畫面繪製
function scene:create(event)
    print('game:create')
    --把場景的view存在sceneGroup這個變數裡
    print(moveLadderSpeed)
    local sceneGroup = self.view

    --接下來把會出現在畫面的東西，加進sceneGroup裡面，這個非常重要
    initial( sceneGroup )
end


--畫面到螢幕上時，呼叫scene:show
--任務:移除前一個場景，播放音效，開始計時，播放各種動畫
function  scene:show( event)
    local sceneGroup = self.view
    local phase = event.phase

    if( "will" == phase ) then
        print('game:show will')
        --畫面即將要推上螢幕時要執行的程式碼寫在這邊
       -- reset()
    elseif ( "did" == phase ) then
        print('game:show did')
        --把畫面已經被推上螢幕後要執行的程式碼寫在這邊
        --可能是移除之前的場景，播放音效，開始計時，播放各種動畫
        audio.setVolume( 0.5 ,{ channel = 1 } )
        audio.play( bgMusic , { channel = 1 , loops = -1} )
        timerStart()
        moveLadder()
        --移除前一個畫面的元件
    end
end


--即將被移除，呼叫scene:hide
--任務:停止音樂，釋放音樂記憶體，停止移動的物體等
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( "will" == phase ) then
        print('game:hide will')
        -- gameoverImg:removeSelf( )
        --畫面即將移開螢幕時，要執行的程式碼
        --這邊需要停止音樂，釋放音樂記憶體，有timer的計時器也可以在此停止
		-- timer.cancel( ladderTmr )
		
    elseif ( "did" == phase ) then
        print('game:hide did')
        --畫面已經移開螢幕時，要執行的程式碼
    end
end

--下一個場景畫面推上螢幕後
--任務:摧毀場景
function scene:destroy( event )
    print('game:destroy')
    if ("will" == event.phase) then
        --這邊寫下畫面要被消滅前要執行的程式碼
    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene

--=======================================================================================
--呼叫主函式
--=======================================================================================
-- main()

