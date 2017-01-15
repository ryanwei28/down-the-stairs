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
-- display.setStatusBar( display.HiddenStatusBar ) 
composer = require("composer")

--=======================================================================================
--宣告各種變數
--=======================================================================================
_SCREEN = {
	W = display.contentWidth ,
	H = display.contentHeight
}
_SCREEN.CENTER = {
	X = display.contentCenterX ,
	Y = display.contentCenterY
}

WIDTH = _SCREEN.W/320
HEIGHT = _SCREEN.H/480

local logo
local blank
difficult_mode = 'normal'
local logoGroup = display.newGroup( )
local logoSound = audio.loadSound( "sounds/logo.mp3" )  --預先載入所有音樂及音效
playSound = audio.loadSound( "sounds/play.mp3" )
selectSound = audio.loadSound( "sounds/diff.mp3" )
backSound = audio.loadSound( "sounds/back.mp3" )
sound1 = audio.loadSound( "sounds/ladder.mp3" )
sound2 = audio.loadSound( "sounds/vanishLadder.mp3" )
sound3 = audio.loadSound( "sounds/spring.mp3" )
sound4 = audio.loadSound( "sounds/trap.mp3" )
sound5 = audio.loadSound( "sounds/die.mp3" )
bgMusic = audio.loadStream( "sounds/bgMusic.mp3" )
--=======================================================================================
--宣告各個函式名稱
--=======================================================================================
local init

--=======================================================================================
--宣告與定義main()函式
--=======================================================================================
local main = function ( )
	init()
end

--=======================================================================================
--定義其他函式
--=======================================================================================
init = function ( )
	--加入logo及背景
	blank = display.newImageRect( logoGroup , "images/blank.png", _SCREEN.W , _SCREEN.H )
	blank.x , blank.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y

	logo = display.newImageRect( logoGroup , "images/logo.png", 150*WIDTH , 150*HEIGHT )
	logo.x , logo.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y
	audio.play( logoSound )
	local options = {time = 3000 }
	timer.performWithDelay( 500 , function ( )
		transition.to( logoGroup , {time = 1000 , alpha = 0 , onComplete = function (  )
			composer.gotoScene( "scene1",options )
			audio.dispose( logoSound )
			logoSound = nil
		end} )
	end )
	
end


--=======================================================================================
--呼叫主函式
--=======================================================================================
main()

