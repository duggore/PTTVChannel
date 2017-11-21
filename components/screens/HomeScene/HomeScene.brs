' **********Francisco Carena********** 

 ' inits grid screen
 ' creates all children
 ' sets all observers 
Function Init()
	' Search Screen with keyboard and RowList
    m.Search = m.top.findNode("Search")
		
	m.loadingIndicator = m.top.findNode("loadingIndicator")
		
	' DetailsScreen Node with description, Video Player
    m.detailsScreen = m.top.findNode("DetailsScreen")
		
    ' listen on port 8089
    ? "[HomeScene] Init"
    m.screenStack = []
    'main grid screen node
    m.GridScreen = m.top.findNode("GridScreen")
    
    ShowScreen(m.GridScreen)
End Function 

Function OpenDetailsScreen()
	'show DetailsScreen Node with description, Video Player
    m.detailsScreen.content = m.gridScreen.focusedContent
	ShowScreen(m.detailsScreen)	
End Function

' if content set, focus on GridScreen
Sub OnChangeContent()
    ? "OnChangeContent "
    m.GridScreen.setFocus(true)
    m.loadingIndicator.control = "stop"
End Sub


' Main Remote keypress event loop
Function OnkeyEvent(key, press) as Boolean
    ? ">>> HomeScene >> OnkeyEvent"
    result = false
    if press
        if key = "back"
            HideTop()
            result = m.screenStack.count() <> 0
        else if key = "options"
            ShowScreen(m.Search)
            m.top.SearchString = ""
        end if
        
        ? "key == ";key
    end if
    return result
End Function

Sub ShowScreen(node)
    prev = m.screenStack.peek()
    if prev <> invalid
        prev.visible = false
    end if
    node.visible = true
    node.setFocus(true)
    m.screenStack.push(node)
End Sub

Sub HideTop()
    HideScreen(invalid)
end Sub

Sub HideScreen(node as Object)
    if node = invalid OR (m.screenStack.peek() <> invalid AND m.screenStack.peek().isSameNode(node)) 
        last = m.screenStack.pop()
        last.visible = false
        
        prev = m.screenStack.peek()
        if prev <> invalid
            prev.visible = true
            prev.setFocus(true)
        end if
    end if
End Sub
