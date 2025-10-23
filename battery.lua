local computer=require("computer")

local max=computer.maxEnergy()
local cur=computer.energy()

local pcnt=math.floor(cur*100/max)
local bl=math.floor(pcnt/5)
local bar="[".."\033[0;32m"
for i=1,bl do
    bar=bar.."▓"
end
for i=1,(20-bl) do
    bar=bar.."░"
end
bar=bar.."] "..pcnt.."%"
max=math.floor(max*25)/10
cur=math.floor(cur*25)/10
print(bar)
print(cur.." / "..max.."EU")
