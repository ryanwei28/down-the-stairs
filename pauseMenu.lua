-----------------------------------------------------------------------------------------
--
-- pauseMenu.lua
-- 暫停選單
--
-----------------------------------------------------------------------------------------


--=======================================================================================
--引入各種函式庫
--=======================================================================================
local scene = composer.newScene( )
--=======================================================================================
--宣告各種變數
--=======================================================================================
local menuGroup = display.newGroup( )
local menu
local continu 
--=======================================================================================
--宣告各種函數函數
--=======================================================================================
local init
local continuGame
--=======================================================================================
--定義各種函式
--=======================================================================================

init = function (  )
	menu = display.newImageRect( menuGroup, "images/menu.png", 280, 320 )
	menu.x , menu.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y

	continu = display.newImageRect( menuGroup, "images/continu.png", 270, 50 )
	continu.x , continu.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y - 75

	newGame = display.newImageRect( menuGroup, "images/newgame.png", 270, 50 )
	newGame.x , newGame.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y + 15

	continu:addEventListener( "tap", continuGame )
	newGame:addEventListener( "tap", function (  )
		local options = { effect = "fade" , time = 400}
		composer.gotoScene( "scene1" , options )
		composer.recycleAutomatically = true
	end )
end

continuGame = function (  )	
	composer.hideOverlay( false ,"crossFade" , 400)
	transition.resume( cancelLadder )
	timer.resume( ladderTmr )
	mc.isBodyActive = true
    for i = 1 , 4 do 
        num[i]:play( )
    end
end
--=======================================================================================
--Composer
--=======================================================================================

--畫面沒到螢幕上時，先呼叫scene:create
--任務:負責UI畫面繪製
function scene:create(event)
    print('scene:create')
    --把場景的view存在sceneGroup這個變數裡
    local sceneGroup = self.view

    --接下來把會出現在畫面的東西，加進sceneGroup裡面，這個非常重要
    init()
    sceneGroup:insert( menuGroup )
end


--畫面到螢幕上時，呼叫scene:show
--任務:移除前一個場景，播放音效，開始計時，播放各種動畫
function  scene:show( event)
    local sceneGroup = self.view
    local phase = event.phase

    if( "will" == phase ) then
        print('scene:show will')
        --畫面即將要推上螢幕時要執行的程式碼寫在這邊
    elseif ( "did" == phase ) then
        print('scene:show did')
        --把畫面已經被推上螢幕後要執行的程式碼寫在這邊
        --可能是移除之前的場景，播放音效，開始計時，播放各種動畫

        --移除前一個畫面的元件
       
    end
end


--即將被移除，呼叫scene:hide
--任務:停止音樂，釋放音樂記憶體，停止移動的物體等
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( "will" == phase ) then
        print('scene:hide will')
        --畫面即將移開螢幕時，要執行的程式碼
        --這邊需要停止音樂，釋放音樂記憶體，有timer的計時器也可以在此停止
       
    elseif ( "did" == phase ) then
        print('scene:hide did')
        --畫面已經移開螢幕時，要執行的程式碼
    end
end

--下一個場景畫面推上螢幕後
--任務:摧毀場景
function scene:destroy( event )
    print('scene:destroy')
    if ("will" == event.phase) then
        --這邊寫下畫面要被消滅前要執行的程式碼

    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene