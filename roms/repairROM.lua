function iv(a,m,...) return component.invoke(a,m,...) end
function gc(c) return component.list(c)() end
local wnc=gc("modem")
local rom=gc("eeprom")
local drone=gc("drone")
iv(wnc,"open",40)

function run()
    iv(wnc,"close",40)
    iv(wnc,"open",2613)
    while true do
        local sig={computer.pullSignal(1)}
        if #sig>5 and sig[1]=="modem_message" then
            if sig[6]=="broken" then
                iv(drone,"use",nil,true)
                computer.beep(100,1)
            end
        end
    end
end

while true do
  local sig={computer.pullSignal(1)}
  if #sig>5 and sig[1]=="modem_message" then
    if sig[6]=="set" and #sig>6 then 
        iv(rom,"set",sig[7])
        computer.beep(400,.5)
        computer.shutdown(true)
    elseif sig[6]=="run" then
        run()
    end
  end
end