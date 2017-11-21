' ********** Francisco Carena. ********** 

Function Init()
    ? "[DetailsScreen] init"

    m.top.observeField("visible", "onVisibleChange")
    m.top.observeField("focusedChild", "OnFocusedChildChange")

    m.buttons           =   m.top.findNode("Buttons")
    m.poster            =   m.top.findNode("Poster")
    m.description       =   m.top.findNode("Description")
    m.background        =   m.top.findNode("Background")


    ' create buttons
    result = []
    for each button in ["Play", "Second button"]
        result.push({title : button})
    end for
    m.buttons.content = ContentList2SimpleNode(result)
End Function

Sub onVisibleChange()
    ? "[DetailsScreen] onVisibleChange"
    if m.top.visible = true then
        m.buttons.jumpToItem = 0
        m.buttons.setFocus(true)
    else if m.videoPlayer <> invalid
        m.videoPlayer.visible = false
        m.videoPlayer.control = "stop"
        m.poster.uri=""
        m.background.uri=""
    end if
End Sub

Sub OnFocusedChildChange()
    if m.top.isInFocusChain() and not m.buttons.hasFocus() and not m.videoPlayer.hasFocus() then
        m.buttons.setFocus(true)
    end if
End Sub

Sub onVideoVisibleChange()
    if m.videoPlayer.visible = false and m.top.visible = true
        m.buttons.setFocus(true)
        m.videoPlayer.control = "stop"
        'clear video player content, for proper start of next video player 
        m.videoPlayer.content = invalid
        'remove video player
        m.top.removeChild(m.videoPlayer)
    end if
End Sub

' event handler of Video player msg
Sub OnVideoPlayerStateChange()
    if m.videoPlayer.state = "error"
        ' error handling
        m.videoPlayer.visible = false
    else if m.videoPlayer.state = "playing"
        ' playback handling
    else if m.videoPlayer.state = "finished"
        m.videoPlayer.visible = false
    end if
End Sub

' on Button press handler
Sub onItemSelected()
    ' first button is Play
    if m.top.itemSelected = 0
        m.videoPlayer = CreateObject("roSGNode", "Video")
        m.videoPlayer.id="videoPlayer"
        m.videoPlayer.translation="[0, 0]"
        m.videoPlayer.width="1280"
        m.videoPlayer.height="720"
        m.videoPlayer.content   = m.top.content
        
        'show video player
        m.top.AppendChild(m.videoPlayer)
    
        m.videoPlayer.visible = true
        m.videoPlayer.setFocus(true)
        m.videoPlayer.control = "play"
        m.videoPlayer.observeField("state", "OnVideoPlayerStateChange")
        m.videoPlayer.observeField("visible", "onVideoVisibleChange")
    end if
End Sub

' Content change handler
Sub OnContentChange()
    m.description.content   = m.top.content
    m.description.Description.width = "770"
    m.poster.uri            = m.top.content.hdBackgroundImageUrl
    m.background.uri            = m.top.content.hdBackgroundImageUrl
End Sub


Function ContentList2SimpleNode(contentList as Object, nodeType = "ContentNode" as String) as Object
    result = createObject("roSGNode",nodeType)
    if result <> invalid
        for each itemAA in contentList
            item = createObject("roSGNode", nodeType)
            item.setFields(itemAA)
            result.appendChild(item)
        end for
    end if
    return result
End Function

Function OnkeyEvent(key, press) as Boolean
    ? ">>> Details >> OnkeyEvent"
    result = false
    if press AND key = "back" AND m.videoPlayer <> invalid AND m.videoPlayer.visible 
        m.videoPlayer.visible = false
        result = true    
    end if
    return result
End Function