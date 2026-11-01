function Block(el)
    if el.t == "Para" or el.t == "Plain" then
        for k, _ in ipairs(el.content) do

            if el.content[k].t == "Str" and el.content[k].text == "Sanders," and
                el.content[k + 1].t == "Space" and el.content[k + 2].t == "Str" and
                el.content[k + 2].text:find("^T.") then

                local _, e = el.content[k + 2].text:find("^T.")
                local rest = el.content[k + 2].text:sub(e + 1) -- empty if e+1>length
                el.content[k] = pandoc.Strong {pandoc.Str("Sanders, T.")}
                el.content[k + 1] = pandoc.Str(rest)
                table.remove(el.content, k + 2) -- safe? another way would be to set element k+2 to Str("")
                -- no real need to skip ipairs items here

            end

        end
    end
    return el
end
-- Put the reference number in a fixed-width box so justification can't
-- stretch the space between the number and the first author
function Div(el)
    if FORMAT:match("latex") and el.classes:includes("csl-entry") then
        local para = el.content[1]
        if para and (para.t == "Para" or para.t == "Plain") and
            para.content[1] and para.content[1].t == "Str" and
            para.content[1].text:find("^%d+%.$") and
            para.content[2] and para.content[2].t == "Space" then

            para.content[1] = pandoc.RawInline("latex",
                "\\makebox[\\cslhangindent][l]{" .. para.content[1].text .. "}")
            table.remove(para.content, 2)

        end
    end
    return el
end
