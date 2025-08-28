-- Script để loop gọi RemoteEvent
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local REMOTE_NAME = "Event" -- Tên RemoteEvent từ log
local ARGUMENT = "Swarm Event" -- Argument từ log
local DELAY = 1 -- Thời gian chờ giữa các lần gọi (giây), chỉnh nếu cần
local LOOP_ENABLED = true -- Bật/tắt loop (true = chạy, false = dừng)

-- Tìm RemoteEvent
local function findRemote()
    local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
    if not remote then
        -- Nếu không tìm thấy trong ReplicatedStorage, tìm toàn game
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("RemoteEvent") and obj.Name == REMOTE_NAME then
                remote = obj
                break
            end
        end
    end
    return remote
end

-- Hàm gọi FireServer
local function fireRemote()
    local remote = findRemote()
    if remote and remote:IsA("RemoteEvent") then
        remote:FireServer(ARGUMENT)
        print(string.format("[LOOP] Fired Remote: %s | Arg: %s | Time: %s", 
            REMOTE_NAME, ARGUMENT, os.date("%Y-%m-%d %H:%M:%S")))
    else
        warn("[ERROR] RemoteEvent '" .. REMOTE_NAME .. "' not found!")
    end
end

-- Loop gọi remote
print("[LOOP SCRIPT] Starting loop for Remote: " .. REMOTE_NAME)
while LOOP_ENABLED do
    local success, err = pcall(fireRemote)
    if not success then
        warn("[ERROR] Failed to fire remote: " .. tostring(err))
    end
    task.wait(DELAY) -- Chờ trước khi gọi lần tiếp theo
end

-- Thông báo script chạy
print("[LOOP SCRIPT] Loop started for user: " .. LocalPlayer.Name)

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

local function onErrorMessageChanged(errorMessage)
    if errorMessage and errorMessage ~= "" then
        print("Error detected: " .. errorMessage)

        if player then
            wait()
            TeleportService:Teleport(game.PlaceId, player)
        end
    end
end

GuiService.ErrorMessageChanged:Connect(onErrorMessageChanged)

local RunService = game:GetService("RunService")
RunService:Set3dRenderingEnabled(false)
