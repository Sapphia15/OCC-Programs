function v(a,m,...) return component.invoke(a,m,...) end
function g(c) return component.list(c)() end
function b(f,t) computer.beep(f,t) end
w=g("modem")
r=g("eeprom")
v(w,"open",40)

function run()
    while true do
        b(100,.5)
        b(200,.5)
        b(300,.5)
        b(200,.5)
    end
end

while true do
  s={computer.pullSignal(1)}
  if #s>5 and s[1]=="modem_message" then
    if s[6]=="set" and #s>6 then 
        v(r,"set",s[7])
        b(400,.5)
        computer.shutdown(true)
    elseif sig[6]=="run" then
        local st, err=pcall(run)
        if not st then
          v(w,"broadcast",404,err)
        end
    end
  end
end