function iv(a,m,...) return component.invoke(a,m,...) end
function gc(c) return component.list(c)() end
local wnc=gc("modem")
local rom=gc("eeprom")
local machine=gc("gt_machine")
iv(wnc,"open",40)

function run()
  iv(wnc,"close",40)
  while true do
    local info={table.unpack(iv(machine,"getSensorInformation"))}
    local problems=tonumber(string.sub(info[5],14,14))
    if (problems>0) then
      iv(wnc,"broadcast",2613,"broken")
      computer.beep(1000,1)
    else
      iv(wnc,"broadcast",2613,"perfect")
      computer.beep(40,.25)
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