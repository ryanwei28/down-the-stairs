-----------------------------------------------------------------------------------------
--
-- scen1.lua
-- 進入遊戲選單畫面
--
-----------------------------------------------------------------------------------------

--=======================================================================================
--引入各種函式庫
--=======================================================================================
local scene = composer.newScene( )
--=======================================================================================
--宣告各種變數
--=======================================================================================
local selectBg
local play
local selectImg
moveLadderSpeed = 0 --最好先行宣告

--=======================================================================================
--宣告各種函數函數
--=======================================================================================
local init
--=======================================================================================
--定義各種函式
--=======================================================================================
init = function ( _parent )
    selectBg = display.newImageRect( _parent , "images/selectBg.png", _SCREEN.W , _SCREEN.H )
    selectBg.x , selectBg.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y

    play = display.newImageRect( _parent , "images/play.png", 250*WIDTH , 60*HEIGHT )
    play.x , play.y = _SCREEN.CENTER.X , 260 *HEIGHT

    selectImg = display.newImageRect( _parent , "images/select.png", 250*WIDTH , 60*HEIGHT )
    selectImg.x , selectImg.y = _SCREEN.CENTER.X , 330*HEIGHT

    moveLadderSpeed = 5000
end

showDid = function (  )
    local options = { effect = "fade" , time = 400}
    selectImg:addEventListener( "tap", function (  )
        audio.play( playSound )
        composer.gotoScene( "scene2" , options)
    end )

    play:addEventListener( "tap", function (  )
        composer.gotoScene( "game" , options)
    end )
end
--=======================================================================================
--Composer
--=======================================================================================

--畫面沒到螢幕上時，先呼叫scene:create
--任務:負責UI畫面繪製
function scene:create(event)
    print('scene1:create')
    --把場景的view存在sceneGroup這個變數裡
    local sceneGroup = self.view

    --接下來把會出現在畫面的東西，加進sceneGroup裡面，這個非常重要
   init(sceneGroup)
end


--畫面到螢幕上時，呼叫scene:show
--任務:移除前一個場景，播放音效，開始計時，播放各種動畫
function  scene:show( event)
    local sceneGroup = self.view
    local phase = event.phase

    if( "will" == phase ) then
        print('scene1:show will')
        --畫面即將要推上螢幕時要執行的程式碼寫在這邊
    elseif ( "did" == phase ) then
        print('scene1:show did')
        --把畫面已經被推上螢幕後要執行的程式碼寫在這邊
        --可能是移除之前的場景，播放音效，開始計時，播放各種動畫
        showDid()
        --移除前一個畫面的元件       
    end
end


--即將被移除，呼叫scene:hide
--任務:停止音樂，釋放音樂記憶體，停止移動的物體等
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( "will" == phase ) then
        print('scene1:hide will')
        --畫面即將移開螢幕時，要執行的程式碼
        --這邊需要停止音樂，釋放音樂記憶體，有timer的計時器也可以在此停止
    elseif ( "did" == phase ) then
        print('scene1:hide did')
        --畫面已經移開螢幕時，要執行的程式碼
        composer.recycleOnSceneChange = true
    end
end

--下一個場景畫面推上螢幕後
--任務:摧毀場景
function scene:destroy( event )
    print('scene1:destroy')
    if ("will" == event.phase) then
        --這邊寫下畫面要被消滅前要執行的程式碼


    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene