' ********** Francisco Carena ********** 
 ' inits search
 ' creates all children
 ' sets all observers 
Function Init()
    ? "[Search] Init"
    m.keyboard = m.top.findNode("Keyboard")
    m.gridScreen = m.top.findNode("Grid")

    m.top.observeField("visible", "OnTopVisibilityChange")
    m.top.observeField("rowItemSelected", "OnRowItemSelected")
End Function

Sub OnRowItemSelected()
    ' On select any item on home scene, show Details node and hide Grid
    m.gridScreen.visible = false
    m.keyboard.visible = false

    m.top.isChildrensVisible = true
    selectedItem = m.top.focusedContent
    'init of video player and start playback
      
    m.videoPlayer = CreateObject("roSGNode", "Video")
    m.videoPlayer.id="videoPlayer"
    m.videoPlayer.translation="[0, 0]"
    m.videoPlayer.width="1280"
    m.videoPlayer.height="720"
    m.videoPlayer.content = selectedItem
    'show video player
    m.top.AppendChild(m.videoPlayer)
    m.videoPlayer.visible = true
    m.videoPlayer.setFocus(true)
    m.videoPlayer.control = "play"
    m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
    m.videoPlayer.observeField("visible", "OnVideoPlayerVisibilityChange")
End Sub

Sub OnVideoPlayerStateChange()
    ? "HomeScene > OnVideoPlayerStateChange : state == ";m.videoPlayer.state
    if m.videoPlayer.state = "error" OR m.videoPlayer.state = "finished"
        'hide video player in case of error
        m.videoplayer.visible = false
        m.gridScreen.visible = true
        m.keyboard.visible = true
        m.gridScreen.setFocus(true)
        
        ?m.videoplayer.errorCode
        ?m.videoplayer.errorMsg
    end if
end Sub

sub OnVideoPlayerVisibilityChange()
    'stop video playback
    if NOT m.videoPlayer.visible then
        m.videoPlayer.control = "stop"
        m.videoplayer.content = invalid
        m.top.removeChild(m.videoplayer)
    end if
end sub

sub OnContentChange()
    m.keyboard.setFocus(true)
end sub

' handler of focused item in RowList
Sub OnItemFocused()
    itemFocused = m.top.itemFocused
    ' item focused should be an intarray with row and col of focused element in RowList
    If itemFocused.Count() = 2 then
        focusedContent          = m.top.content.getChild(itemFocused[0]).getChild(itemFocused[1])
        if focusedContent <> invalid then
            m.top.focusedContent    = focusedContent
        end if
    end if
End Sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    ? ">>> Search >> onKeyEvent"
    result = false
    if press then
        ? "key == ";  key
        if key="down" then
            m.gridScreen.setFocus(true)
            result = true
        else if key="up" then
            m.keyboard.setFocus(true)
            result = true
        else if key = "options" then
            result = true
        else if key = "back"
            ' if Details opened
            if m.videoplayer <> invalid AND m.videoplayer.visible then
                m.videoplayer.visible = false
                m.gridScreen.setFocus(true)
                m.gridScreen.visible = true
                m.keyboard.visible = true
                m.top.isChildrensVisible = false
                result = true
            end if

        end if
    end if
    return result
end function

Sub OnTopVisibilityChange()
    if m.top.visible = true
        m.keyboard.setFocus(true)
        m.gridScreen.visible = true
    end if
End Sub
