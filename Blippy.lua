-- Blippy.lua

-- Create the addon namespace
Blippy = {}

-- Event handler for addon initialization
function Blippy.OnLoad()
    -- Register events for addon
    this:RegisterEvent("PLAYER_LOGIN")
    this:RegisterEvent("PLAYER_ENTERING_WORLD")
    this:RegisterEvent("PLAYER_LEAVE_COMBAT")
end

-- Event handler for player login
function Blippy.OnPlayerLogin()
    -- Load saved variables
    Blippy.LoadSavedVariables()

    -- Addon initialization code
    -- ...

    print("Loaded variable:", Blippy.savedVariable)
end

-- Event handler for player entering the world
function Blippy.OnPlayerEnteringWorld()
    -- Check if the player is in an instance
    if IsInInstance() then
        -- Get player and instance information
        local characterName = UnitName("player")
        local instanceName = GetInstanceInfo()
        local instanceID = GetInstanceID()
        local enterTime = date("%H:%M:%S") -- Local current time as EnterTime

        -- Create a new entry in saved variables
        Blippy.savedVariables = Blippy.savedVariables or {}
        table.insert(Blippy.savedVariables, {
            characterName = characterName,
            instanceName = instanceName,
            instanceID = instanceID,
            EnterTime = enterTime,
            ExitTime = nil -- Initialize ExitTime as nil
        })

        print("Data stored for instance:", instanceName)

        -- Save the updated variables
        Blippy.SaveVariables()
    end
end

-- Event handler for player leaving combat
function Blippy.OnPlayerLeaveCombat()
    -- Check if the player is no longer in an instance
    if not IsInInstance() then
        local lastEntry = Blippy.savedVariables[#Blippy.savedVariables]
        if lastEntry and not lastEntry.ExitTime then
            -- Update the exit time with the current local time
            lastEntry.ExitTime = date("%H:%M:%S") -- Local current time as ExitTime

            print("Data updated for instance:", lastEntry.instanceName)

            -- Save the updated variables
            Blippy.SaveVariables()
        end
    end
end

-- Function to load saved variables
function Blippy.LoadSavedVariables()
    if BlippySavedVariables then
        Blippy.savedVariables = BlippySavedVariables
    end

    if not Blippy.savedVariables then
        Blippy.savedVariables = {}
    end
end

-- Function to save variables
function Blippy.SaveVariables()
    BlippySavedVariables = Blippy.savedVariables

    print("Variables saved")
end

-- Register event handlers and set event frame
Blippy.OnLoad()
BlippyFrame:SetScript("OnEvent", function(self, event, ...)
    Blippy[event](self, ...)
end)
