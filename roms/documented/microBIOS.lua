--create functions with short names for common functions to reduce file size
function iv(a,m,...) return component.invoke(a,m,...) end
function gc(c) return component.list(c)() end

--get components, also uses short names.
local wnc=gc("modem")
local rom=gc("eeprom")

--open port 40 to recieve messages over for enabling or deploying code.
--you'll probably want to close this port at the beginning of the run function if you're going to do any network listening there.
iv(wnc,"open",40)

--this is the main function that will run when once this system is remotely enabled
--the current content of this function is just a simple beeping program
function run()
    while true do
        computer.beep(100,.5)
        computer.beep(200,.5)
        computer.beep(300,.5)
        computer.beep(200,.5)
    end
end

--this is where the system will listen for signals to either enable, or deploy code to it.
--it won't run the main program (the content of the run function) until it is remotely enabled
while true do

  --first, we listen for a signal from the computer and put it in an array
  local sig={computer.pullSignal(1)}

  --since we're using computer.pullSignal instead of event.pull due to being an eeprom program,
  --we have to manually filter the signal to make sure it's what we want

  --the message parts from modem messages always start at index six, so we can check if it has at least 5 elements
  --then we make sure that the type of message is indeed modem_message
  if #sig>5 and sig[1]=="modem_message" then
    --if those checks were passed, then we know that we can read the signal as a modem message
    
    --if the first message part is 'set' then we will look to the next message part if it exists
    if sig[6]=="set" and #sig>6 then 

        --now we overwrite the eeprom with the data from the second message part
        iv(rom,"set",sig[7])

        --once the rom is flashed, the system will beep and then restart
        computer.beep(400,.5)
        computer.shutdown(true)

        --now new code has been deployed!
    elseif sig[6]=="run" then
        --if the message was 'run', then the system will be enabled and will run the code in the run function
        --since there may not be a screen and graphics card available, error reporting is handled wirelessly
        --the run function is called with pcall so that if it fails, it will store the error message in the err variable
        --basically this is a try/catch on the run function that wirelessly broadcasts the error message
        local status, err=pcall(run)
        --if status is false, then there was an error, so the error message is broadcast on port 404
        --you can access the error message by listening to port 404 and printing messages from it on you development system
        --(I reccomend using a tablet so that you can easily test and debug your micro-program in the field, but sometimes a regular computer is fine)
        if not status then
          iv(wnc,"broadcast",404,err)
        end
    end
  end
end