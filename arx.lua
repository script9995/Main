-- Chỉ chạy loop nếu đúng placeId
if game.PlaceId == 72829404259339 then
    local REMOTE_NAME, ARGUMENT, DELAY = "Event", "Swarm Event", 1
    local remote
    print("[LOOP SCRIPT] Starting...")

    while true do
        remote = remote or game:GetService("ReplicatedStorage"):FindFirstChild(REMOTE_NAME) 
            or game:FindFirstChild(REMOTE_NAME, true)
        if remote then
            pcall(function() remote:FireServer(ARGUMENT) end)
            print(("[LOOP] Fired %s | Arg: %s | %s"):format(REMOTE_NAME, ARGUMENT, os.date("%X")))
        else
            warn("[ERROR] RemoteEvent '" .. REMOTE_NAME .. "' not found!")
        end
        task.wait(DELAY)
    end
end

-- Luôn chạy với mọi place
local player = game:GetService("Players").LocalPlayer
game:GetService("GuiService").ErrorMessageChanged:Connect(function(msg)
    if msg and msg ~= "" then
        print("Error detected:", msg)
        task.wait()
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
end)

game:GetService("RunService"):Set3dRenderingEnabled(false)
