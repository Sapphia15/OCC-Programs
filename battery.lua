local computer=require("computer")

local max=computer.maxEnergy()
local cur=computer.energy()

local pcnt=math.floor(cur*100/max)
local bl=math.floor(pcnt/5)
local bar="[".."\27[32m"
for i=1,bl do
    bar=bar.."▓"
end
bar=bar.."\27[31m"
for i=1,(20-bl) do
    bar=bar.."░"
end
bar=bar.."] "..pcnt.."%\n"
max=math.floor(max*25)/10
cur=math.floor(cur*25)/10
local col="\27[32m"
if (pcnt>10 and pcnt<50) then
    col="\27[33m"
elseif (pcnt<11) then
    col="\27[31m"
end
io.write(bar)
io.write(col..cur.." / "..max.."EU\n")
