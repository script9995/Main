-- Chỉ chạy nếu đúng placeId
-- Script để loop gọi RemoteEvent với kiểm tra PlaceId
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local TARGET_PLACE_ID = 72829404259339 -- PlaceId cần kiểm tra
local REMOTE_NAME = "Event" -- Tên RemoteEvent
local ARGUMENT = "Swarm Event" -- Argument
local DELAY = 1 -- Thời gian chờ giữa các lần gọi (giây)
local LOOP_ENABLED = true -- Bật/tắt loop

-- Kiểm tra PlaceId
if game.PlaceId ~= TARGET_PLACE_ID then
    warn(string.format("[LOOP SCRIPT] Wrong PlaceId! Expected: %s, Current: %s", TARGET_PLACE_ID, game.PlaceId))
    return -- Dừng script nếu PlaceId không khớp
end

-- Tìm RemoteEvent
local function findRemote()
    local remote = ReplicatedStorage:FindFirstChild(REMOTE_NAME)
    if not remote then
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
print("[LOOP SCRIPT] Starting loop for Remote: " .. REMOTE_NAME .. " in PlaceId: " .. game.PlaceId)
while LOOP_ENABLED do
    local success, err = pcall(fireRemote)
    if not success then
        warn("[ERROR] Failed to fire remote: " .. tostring(err))
    end
    task.wait(DELAY)
end

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
