-- Blippy.lua

Blippy = {}

function Blippy.OnLoad()
    -- Register events for addon
    this:RegisterEvent("PLAYER_LOGIN")
    this:RegisterEvent("PLAYER_ENTERING_WORLD")
    this:RegisterEvent("PLAYER_LEAVE_COMBAT")
end

function Blippy.OnPlayerLogin()
    Blippy.LoadSavedVariables()

    -- Addon initialization code
    -- ...

    print("Loaded variable:", Blippy.savedVariable)
end

function Blippy.OnPlayerEnteringWorld()
    if IsInInstance() then
        local characterName = UnitName("player")
        local instanceName = GetInstanceInfo()
        local instanceID = GetInstanceID()
        local enterTime = date("%H:%M:%S") -- Local current time as EnterTime

        Blippy.savedVariables = Blippy.savedVariables or {}
        table.insert(Blippy.savedVariables, {
            characterName = characterName,
            instanceName = instanceName,
            instanceID = instanceID,
            EnterTime = enterTime,
            ExitTime = nil -- Initialize ExitTime as nil
        })

        print("Data stored for instance:", instanceName)

        Blippy.SaveVariables()
    end
end

function Blippy.OnPlayerLeaveCombat()
    if not IsInInstance() then
        local lastEntry = Blippy.savedVariables[#Blippy.savedVariables]
        if lastEntry and not lastEntry.ExitTime then
            lastEntry.ExitTime = date("%H:%M:%S") -- Local current time as ExitTime

            print("Data updated for instance:", lastEntry.instanceName)

            Blippy.SaveVariables()
        end
    end
end

function Blippy.LoadSavedVariables()
    -- Load the saved variables from the account-wide file
    BlippySavedVariables = BlippySavedVariables or {}

    -- Assign the saved variables to the addon's table
    Blippy.savedVariables = BlippySavedVariables
end

function Blippy.SaveVariables()
    -- Assign the addon's table to the saved variables
    BlippySavedVariables = Blippy.savedVariables

    print("Variables saved")
end

Blippy.OnLoad()
BlippyFrame:SetScript("OnEvent", function(self, event, ...)
    Blippy[event](self, ...)
end)
