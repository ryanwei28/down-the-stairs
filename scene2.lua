-----------------------------------------------------------------------------------------
--
-- scen2.lua
-- 選擇難易度

-- Author: Ryan
-- 
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
local easy
local hard
local normal
local back

--=======================================================================================
--宣告各種函數函數
--=======================================================================================
local init
local selectMenu
local clearMenu
local onClickBtn

--=======================================================================================
--定義各種函式
--=======================================================================================

init = function ( _parent )
    selectBg = display.newImageRect( _parent , "images/selectBg.png", _SCREEN.W , _SCREEN.H )
    selectBg.x , selectBg.y = _SCREEN.CENTER.X , _SCREEN.CENTER.Y

    easy = display.newImageRect( _parent , "images/easy.png", 230*WIDTH , 50*HEIGHT )
    easy.x ,easy.y = _SCREEN.CENTER.X , 260 *HEIGHT
    easy.id = 'easy'
    easy.moveLadderSpeed = 7000

    normal =  display.newImageRect( _parent , "images/normal.png", 230*WIDTH , 50*HEIGHT )
    normal.x , normal.y = _SCREEN.CENTER.X , 330 *HEIGHT
    normal.id = 'normal'
    normal.moveLadderSpeed = 5000

    hard =  display.newImageRect( _parent , "images/hard.png", 230*WIDTH , 50*HEIGHT)
    hard.x , hard.y = _SCREEN.CENTER.X , 400*HEIGHT
    hard.id = 'hard'
    hard.moveLadderSpeed = 3000

    back = display.newImageRect( _parent ,"images/back.png", 40*WIDTH , 40*HEIGHT )
    back.x , back.y = 280*WIDTH , 460*HEIGHT

    if (difficult_mode == 'easy') then
        easy.xScale , easy.yScale = 1.2 , 1.2
    elseif (difficult_mode == 'normal') then
        normal.xScale , normal.yScale = 1.2 , 1.2
    elseif (difficult_mode == 'hard') then
        hard.xScale , hard.yScale = 1.2 , 1.2
    end
end

onClickBtn = function ( e )
    audio.play( selectSound )
    clearMenu()
    e.target.xScale , e.target.yScale = 1.2 , 1.2
    difficult_mode = e.target.id
    composer.setVariable( "moveLadderSpeed", e.target.moveLadderSpeed ) 
end

showDid = function (  )
    easy:addEventListener( "tap", onClickBtn )
    normal:addEventListener( "tap", onClickBtn )
    hard:addEventListener( "tap", onClickBtn )
    back:addEventListener( "tap", function (  )
        local options ={time = 400 , effect = "fade"}
        audio.play( backSound )
        composer.gotoScene( "scene1" , options )
        -- composer.recycleOnSceneChange = true
    end )

end

--將Menu選單大小變回1
clearMenu = function (  )
    easy.xScale , easy.yScale = 1 , 1
    normal.xScale , normal.yScale = 1 , 1
    hard.xScale , hard.yScale = 1 , 1
end


--=======================================================================================
--Composer
--=======================================================================================

--畫面沒到螢幕上時，先呼叫scene:create
--任務:負責UI畫面繪製
function scene:create(event)
    print('scene2:create')
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
        print('scene2:show will')
        --畫面即將要推上螢幕時要執行的程式碼寫在這邊
                
    elseif ( "did" == phase ) then
        print('scene2:show did')
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
        print('scene2:hide will')
        --畫面即將移開螢幕時，要執行的程式碼
        --這邊需要停止音樂，釋放音樂記憶體，有timer的計時器也可以在此停止

    elseif ( "did" == phase ) then
        print('scene2:hide did')
        --畫面已經移開螢幕時，要執行的程式碼
    end
end

--下一個場景畫面推上螢幕後
--任務:摧毀場景
function scene:destroy( event )
    print('scene2:destroy')
    if ("will" == event.phase) then
        --這邊寫下畫面要被消滅前要執行的程式碼

    end
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene