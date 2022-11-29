local debug = false

--[[
    Takes in a table with sub tables containing a string called 'label' and displays them as a arrow-key navigatable menu.
    Optional 'pageLength' determines how many options to show on screen at once per page. Defaults to screen height - 2.
    Input table example:
tbl = {
    { label = "" },
    { label = "" }
    ...
}  
]]
local function handleMenu(menuOptions,pageLength)
    if not pageLength then
        local _,h = term.getSize()
        pageLength = math.ceil(#menuOptions/(h-2))
    end

    local menuColor = colors.green
    local highLight = colors.orange

    local maxCursor = #menuOptions
    local maxPage = math.ceil(maxCursor/pageLength)

    local cursor = 1
    local page = math.max(1, math.ceil(cursor/pageLength))

    local startCol = term.getTextColor()
    term.setTextColor(menuColor)

    term.clear()
    --while true do
        while true do

            local startIndex = math.max( pageLength*(page-1)+1 , 1 )
            local endIndex = math.min( pageLength*page , maxCursor )

            cursor = math.min(endIndex, math.max(startIndex,cursor) )

            if debug then
                txt(24,1,"maxCurs :"..maxCursor.."  ")
                txt(24,2,"maxPage :"..maxPage.."  ")
                txt(24,3,"cursor :"..cursor.."  ")
                txt(24,4,"page :"..page.."  ")
                txt(24,5,"startIndex :"..startIndex.."  ")
                txt(24,6,"endIndex :"..endIndex.."  ")
            end

            term.setCursorPos(1,1)
            for i = startIndex, endIndex do
                if i == cursor then
                    term.setTextColor(highLight)
                    print(">"..(menuOptions[i].label).."< ")
                    term.setTextColor(menuColor)
                else
                    print("["..(menuOptions[i].label).."] ")
                end
            end
            print("\nPage "..page.." / "..maxPage)
            

            local _, key = os.pullEvent("key")
            if key == keys.up then
                --Move cursor up if it's not at first option
                if cursor > 1 then
                    cursor = cursor - 1
                end
            elseif key == keys.down then
                --move cursor down if it's not at last option
                if cursor < maxCursor then
                    cursor = cursor + 1
                end
            elseif key == keys.left then
                --switch to previous page if not at first page
                if page > 1 then
                    cursor = cursor - pageLength
                    page = page - 1
                    term.clear()
                    --break
                end
            elseif key == keys.right then
                --switch to next page if not at last page
                if page < maxPage then
                    cursor = cursor + pageLength
                    page = page + 1
                    term.clear()
                    --break
                end
            elseif key == keys.enter then
                --return the menu choice
                term.setTextColor(startCol)
                return cursor,"enter"
            elseif key == keys.backspace then
                --exit the menu
                term.setTextColor(startCol)
                return cursor,"exit"
            end
        end
    --end
end

return {
    handleMenu = handleMenu
}
