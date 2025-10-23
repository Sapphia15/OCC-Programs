local computer=require("computer")

local max=computer.maxEnergy()*2.5
local cur=computer.energy()*2.5

local pcnt=math.floor(cur*100/max)
local bl=math.floor(pcnt/10)
local bar="["
for i=1,bl do
    bar=bar.."▓"
end
for i=1,(10-bl) do
    bar=bar.."░"
end
bar=bar.."] "..pcnt.."%"
print(bar)
print(cur.." / "..max.."EU")
