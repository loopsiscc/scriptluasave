local replicated_storage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")
local teams = game:GetService("Teams")
local user_input_service = game:GetService("UserInputService")
local run_service = game:GetService("RunService")
local player = players.LocalPlayer
local library = loadstring(game:HttpGet("https://github.com/loopsiscc/scriptluasave.git"))()

local window = library:MakeWindow({
    Name = "style selector",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "styleselectorui"
})

local camera = workspace.CurrentCamera
local lock_ball = false
local away_coords = Vector3.new(-232.98773193359375, 11.166533470153809, -64.32842254638672)
local home_coords = Vector3.new(310.09368896484375, 11.166532516479492, -35.67409133911133)
local default_shoot_power = 700
local shoot_power = default_shoot_power

local cursor_image = "rbxassetid://7072729817"
local cursor = Instance.new("ImageLabel")
cursor.Image = cursor_image
cursor.Size = UDim2.new(0, 32, 0, 32)
cursor.BackgroundTransparency = 1
cursor.Visible = false
cursor.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local function find_ball()
    local football = workspace:FindFirstChild("Football")
    if football then
        return football:FindFirstChild("BallAnims"):FindFirstChild("BALL") or football:FindFirstChild("BALL")
    end
    return nil
end

local ball = find_ball()

run_service.RenderStepped:Connect(function()
    if user_input_service.MouseEnabled or user_input_service.TouchEnabled then
        local position = user_input_service:GetMouseLocation()
        cursor.Position = UDim2.new(0, position.X, 0, position.Y)
        cursor.Visible = true
    else
        cursor.Visible = false
    end
end)

local function lockb()
    while lock_ball do
        ball = find_ball()
        if ball then
            local ball_position = ball.Position
            local camera_position = camera.CFrame.Position
            local smooth_speed = 0.2
            local camera_offset = Vector3.new(0, 5, -10)
            local target_position = ball_position + camera_offset
            local cla = ball_position
            local ncp = camera.CFrame.Position:Lerp(target_position, smooth_speed)
            camera.CFrame = CFrame.new(ncp, cla)
        end
        task.wait(0.1)
    end
end

local function shoot_ball()
    ball = find_ball()
    if ball then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid_root_part = character:WaitForChild("HumanoidRootPart")
        local team = player.Team
        local target_coords = (team == teams:FindFirstChild("Home")) and home_coords or away_coords
        local direction = (target_coords - ball.Position).unit
        local body_velocity = ball:FindFirstChild("BodyVelocity") or Instance.new("BodyVelocity")
        body_velocity.MaxForce = Vector3.new(100000, 100000, 100000)
        body_velocity.Velocity = direction * shoot_power
        body_velocity.Parent = ball
    end
end

local function set_style(desired_style)
    if player:FindFirstChild("PlayerStats") then
        local playerStats = player.PlayerStats
        if playerStats:FindFirstChild("Style") Then
            playerStats.Style.Value = desired_style
        end
    end
end

local function set_flow(desired_flow)
    if player:FindFirstChild("PlayerStats") then
        local playerStats = player.PlayerStats
        if playerStats:FindFirstChild("Flow") then
            playerStats.Flow.Value = desired_flow
        end
    end
end

local main_tab = window:MakeTab({ Name = "Main", Icon = "rbxassetid://4483345998" })
main_tab:AddButton({
    Name = "Toggle Ball Lock",
    Callback = function()
        lock_ball = not lock_ball
        if lock_ball then
            task.spawn(lockb)
        end
    end
})

local style_tab = window:MakeTab({ Name = "Style", Icon = "rbxassetid://4483345998" })
style_tab:AddButton({
    Name = "sae style",
    Callback = function()
        set_style("Sae")
    end
})
style_tab:AddButton({
    Name = "rin style",
    Callback = function()
        set_style("Rin")
    end
})
style_tab:AddTextbox({
    Name = "custom style",
    PlaceholderText = "enter custom style",
    Callback = function(custom_style)
        if custom_style ~= "" then
            set_style(custom_style)
        end
    end
})

local flow_tab = window:MakeTab({ Name = "Flow", Icon = "rbxassetid://4483345998" })
flow_tab:AddSection({ Name = "Important Information" })
flow_tab:AddLabel("**FLOW REQUIRES MONEY**")
flow_tab:AddButton({
    Name = "Wild Card",
    Callback = function()
        set_flow("Wild Card")
    end
})
flow_tab:AddButton({
    Name = "awk genius",
    Callback = function()
        set_flow("Awakened Genius")
    end
})
flow_tab:AddTextbox({
    Name = "custom flow",
    PlaceholderText = "enter custom flow",
    Callback = function(custom_flow)
        if custom_flow ~= "" then
            set_flow(custom_flow)
        end
    end
})

local notes_tab = window:MakeTab({ Name = "Notes", Icon = "rbxassetid://4483345998" })
notes_tab:AddSection({ Name = "Important Notes" })
notes_tab:AddLabel("where you see custom style that is to get other styles, not only nagi or shidou")
notes_tab:AddLabel("also if you got shidou and you want nagi you needda rejoin")
notes_tab:AddLabel("this applies with every other style")

local credits_tab = window:MakeTab({ Name = "Credits", Icon = "rbxassetid://4483345998" })
credits_tab:AddSection({ Name = "Credits" })
credits_tab:AddLabel("credits loops27.")

library:Init()