' ********** Francisco Carena ********** 

Sub RunUserInterface()
    screen = CreateObject("roSGScreen")
    m.scene = screen.CreateScene("HomeScene")
    port = CreateObject("roMessagePort")
    screen.SetMessagePort(port)
    screen.Show()
    
    oneRow = GetApiArray()
    list = [
        {
            TITLE : "1"
            ContentList : oneRow
        }
        {
            TITLE : "2"
            ContentList : oneRow
        }
    ]
    m.SearchList = [
        {
            TITLE : "Search results"
            ContentList : oneRow
        }
    ]
    m.scene.gridContent = ParseXMLContent(list)
    m.scene.observeField("SearchString", port)
    while(true)
        msg = wait(0, port)
        print "------------------"
        print "msg = "; msg
        if type(msg) = "roSGNodeEvent" and msg.getField() = "SearchString" then
            SearchQuery(m.scene.SearchString)
        end if
        
    end while
    
    if screen <> invalid then
        screen.Close()
        screen = invalid
    end if
End Sub

sub SearchQuery(SearchString as String)
    m.scene.searchContent = ParseXMLContentSearch(m.SearchList, SearchString)
end sub

Function ParseXMLContentSearch(list As Object, SearchString as String) as Object
    RowItems = createObject("RoSGNode","ContentNode")
    
    for each rowAA in list
    'for index = 0 to 1
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.Title

        for each itemAA in rowAA.ContentList
            if (Instr(1, LCase(itemAA.Title), LCase(SearchString) ) > 0 or Instr(1, LCase(itemAA.Description), LCase(SearchString) ) > 0) and SearchString <>""
                item = createObject("RoSGNode","ContentNode")
                item.SetFields(itemAA)
                row.appendChild(item)
            end if
        end for
        RowItems.appendChild(row)
    end for

    return RowItems
End Function


Function ParseXMLContent(list As Object)
    RowItems = createObject("RoSGNode","ContentNode")
    
    for each rowAA in list
    'for index = 0 to 1
        row = createObject("RoSGNode","ContentNode")
        row.Title = rowAA.Title

        for each itemAA in rowAA.ContentList
            item = createObject("RoSGNode","ContentNode")
            item.SetFields(itemAA)
            row.appendChild(item)
        end for
        RowItems.appendChild(row)
    end for

    return RowItems
End Function


Function GetApiArray()
    url = CreateObject("roUrlTransfer")
    url.SetUrl("http://api.delvenetworks.com/rest/organizations/59021fabe3b645968e382ac726cd6c7b/channels/1cfd09ab38e54f48be8498e0249f5c83/media.rss")
    rsp = url.GetToString()

    responseXML = ParseXML(rsp)
    responseXML = responseXML.GetChildElements()
    responseArray = responseXML.GetChildElements()

    result = []

    for each xmlItem in responseArray
        if xmlItem.getName() = "item"
            itemAA = xmlItem.GetChildElements()
            if itemAA <> invalid
                item = {}
                for each xmlItem in itemAA
                    item[xmlItem.getName()] = xmlItem.getText()
                    if xmlItem.getName() = "media:content"
                        item.stream = {url : xmlItem.url}
                        item.url = xmlItem.getAttributes().url
                        item.streamFormat = "mp4"
                        
                        mediaContent = xmlItem.GetChildElements()
                        for each mediaContentItem in mediaContent
                            if mediaContentItem.getName() = "media:thumbnail"
                                item.HDPosterUrl = mediaContentItem.getattributes().url
                                item.hdBackgroundImageUrl = mediaContentItem.getattributes().url
                            end if
                        end for
                    end if
                end for
                result.push(item)
            end if
        end if
    end for

    return result
End Function


Function ParseXML(str As String) As dynamic
    if str = invalid return invalid
    xml=CreateObject("roXMLElement")
    if not xml.Parse(str) return invalid
    return xml
End Function
