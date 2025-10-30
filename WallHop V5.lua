[file name]: WallHopV5.lua
[file content begin]
-- WallHop V5 - Enhanced Wall Jump System
-- Made by Roblox Hacks 404

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
screenGui.Name = "WallHopV5GUI"

-- Services
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Player specific
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Create Main Frame (GUI 1)
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.1
frame.Size = UDim2.new(0, 220, 0, 160)
frame.Position = UDim2.new(0.5, -110, 0.5, -80)
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = false

-- Add corner for modern look
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

-- Add shadow effect
local shadow = Instance.new("ImageLabel")
shadow.Parent = frame
shadow.BackgroundTransparency = 1
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.ZIndex = -1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.8
shadow.ScaleType = Enum.ScaleType.Slice
shadow.SliceCenter = Rect.new(10, 10, 118, 118)

-- Calculate button positions (Top row)
local frameWidth = frame.Size.X.Offset
local buttonWidth = 60
local totalButtonWidth = buttonWidth * 3
local totalSpacing = frameWidth - totalButtonWidth
local spacing = totalSpacing / 4

local onButtonX = spacing
local additionButtonX = spacing + buttonWidth + spacing
local offButtonX = spacing + buttonWidth + spacing + buttonWidth + spacing

-- Create On Button
local onButton = Instance.new("TextButton")
onButton.Parent = frame
onButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
onButton.Size = UDim2.new(0, buttonWidth, 0, 30)
onButton.Position = UDim2.new(0, onButtonX, 0, 20)
onButton.Text = "On"
onButton.TextColor3 = Color3.fromRGB(0, 255, 0)
onButton.TextScaled = true
local onCorner = Instance.new("UICorner")
onCorner.CornerRadius = UDim.new(0, 6)
onCorner.Parent = onButton

-- Create Addition Button
local additionButton = Instance.new("TextButton")
additionButton.Parent = frame
additionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
additionButton.Size = UDim2.new(0, buttonWidth, 0, 30)
additionButton.Position = UDim2.new(0, additionButtonX, 0, 20)
additionButton.Text = "Extra"
additionButton.TextColor3 = Color3.fromRGB(255, 255, 0)
additionButton.TextScaled = true
local additionCorner = Instance.new("UICorner")
additionCorner.CornerRadius = UDim.new(0, 6)
additionCorner.Parent = additionButton
local additionToggle = false
local additionalFrame = nil
local jumpButtonInAddition = nil

-- Create Off Button
local offButton = Instance.new("TextButton")
offButton.Parent = frame
offButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
offButton.Size = UDim2.new(0, buttonWidth, 0, 30)
offButton.Position = UDim2.new(0, offButtonX, 0, 20)
offButton.Text = "Off"
offButton.TextColor3 = Color3.fromRGB(255, 50, 50)
offButton.TextScaled = true
local offCorner = Instance.new("UICorner")
offCorner.CornerRadius = UDim.new(0, 6)
offCorner.Parent = offButton

-- Create Destroy Button
local destroyButton = Instance.new("TextButton")
destroyButton.Parent = frame
destroyButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
destroyButton.Size = UDim2.new(0, 180, 0, 30)
destroyButton.Position = UDim2.new(0, 20, 0, 60)
destroyButton.Text = "Destroy GUI"
destroyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
destroyButton.TextScaled = true
local destroyCorner = Instance.new("UICorner")
destroyCorner.CornerRadius = UDim.new(0, 6)
destroyCorner.Parent = destroyButton

-- Create Auto Button
local autoButton = Instance.new("TextButton")
autoButton.Parent = frame
autoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
autoButton.Size = UDim2.new(0, 180, 0, 30)
autoButton.Position = UDim2.new(0, 20, 0, 100)
autoButton.Text = "Auto: OFF"
autoButton.TextColor3 = Color3.fromRGB(255, 50, 50)
autoButton.TextScaled = true
local autoCorner = Instance.new("UICorner")
autoCorner.CornerRadius = UDim.new(0, 6)
autoCorner.Parent = autoButton
local autoToggle = false

-- Create Status Indicator
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = frame
statusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statusLabel.Size = UDim2.new(0, 220, 0, 30)
statusLabel.Position = UDim2.new(0, 0, 0, -30)
statusLabel.Text = "WallHop V5: OFF"
statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
statusLabel.TextScaled = true
local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 8)
statusCorner.Parent = statusLabel

-- Create Plus Button
local plusButton = Instance.new("TextButton")
plusButton.Parent = frame
plusButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
plusButton.Size = UDim2.new(0, 30, 0, 30)
plusButton.Position = UDim2.new(0, -35, 0, -30)
plusButton.Text = "+"
plusButton.TextColor3 = Color3.fromRGB(0, 150, 255)
plusButton.TextScaled = true
local plusCorner = Instance.new("UICorner")
plusCorner.CornerRadius = UDim.new(0, 6)
plusCorner.Parent = plusButton
local plusButtonToggle = false
local plusFrame = nil
local selectButtonInPlusFrame = nil
local selectModeActive = false
local colorListLabelInPlusFrame = nil
local mouseClickConnection = nil
local selectedBrickColor = nil

-- Variables for Wallhop Functionality
local wallhopToggle = false
local InfiniteJumpEnabled = true
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
local jumpConnection = nil
local autoJumpConnection = nil

-- Enhanced wall detection function
local function getWallRaycastResult()
    local character = player.Character
    if not character then return nil end
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return nil end

    raycastParams.FilterDescendantsInstances = {character}
    local detectionDistance = 2.5
    local closestHit = nil
    local minDistance = detectionDistance + 1
    local hrpCF = humanoidRootPart.CFrame

    -- Multi-directional raycast for better detection
    for i = 0, 15 do
        local angle = math.rad(i * 22.5)
        local direction = (hrpCF * CFrame.Angles(0, angle, 0)).LookVector
        local ray = Workspace:Raycast(humanoidRootPart.Position, direction * detectionDistance, raycastParams)
        if ray and ray.Instance and ray.Distance < minDistance then
            minDistance = ray.Distance
            closestHit = ray
        end
    end

    -- Enhanced blockcast for wider detection
    local blockCastSize = Vector3.new(2, 1.5, 0.5)
    local blockCastOffset = CFrame.new(0, -0.5, -0.5)
    local blockCastOriginCF = hrpCF * blockCastOffset
    local blockCastDirection = hrpCF.LookVector
    local blockCastDistance = 2
    local blockResult = Workspace:Blockcast(blockCastOriginCF, blockCastSize, blockCastDirection * blockCastDistance, raycastParams)

    if blockResult and blockResult.Instance and blockResult.Distance < minDistance then
         minDistance = blockResult.Distance
         closestHit = blockResult
    end

    return closestHit
end

-- Enhanced Wall Jump Execution Function
local function executeWallJump(wallRayResult, jumpType)
    if jumpType ~= "Button" and not InfiniteJumpEnabled then
        return
    end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    local camera = Workspace.CurrentCamera

    if not (humanoid and rootPart and camera and humanoid:GetState() ~= Enum.HumanoidStateType.Dead and wallRayResult) then
        return
    end

    if jumpType ~= "Button" then
        InfiniteJumpEnabled = false
    end

    local maxInfluenceAngleRight = math.rad(25)
    local maxInfluenceAngleLeft  = math.rad(-25)

    local wallNormal = wallRayResult.Normal
    local baseDirectionAwayFromWall = Vector3.new(wallNormal.X, 0, wallNormal.Z).Unit
    if baseDirectionAwayFromWall.Magnitude < 0.1 then
         local dirToHit = (wallRayResult.Position - rootPart.Position) * Vector3.new(1,0,1)
         baseDirectionAwayFromWall = -dirToHit.Unit
         if baseDirectionAwayFromWall.Magnitude < 0.1 then
             baseDirectionAwayFromWall = -rootPart.CFrame.LookVector * Vector3.new(1, 0, 1)
             if baseDirectionAwayFromWall.Magnitude > 0.1 then baseDirectionAwayFromWall = baseDirectionAwayFromWall.Unit end
             if baseDirectionAwayFromWall.Magnitude < 0.1 then baseDirectionAwayFromWall = Vector3.new(0,0,1) end
         end
    end
    baseDirectionAwayFromWall = Vector3.new(baseDirectionAwayFromWall.X, 0, baseDirectionAwayFromWall.Z).Unit

    local cameraLook = camera.CFrame.LookVector
    local horizontalCameraLook = Vector3.new(cameraLook.X, 0, cameraLook.Z).Unit
    if horizontalCameraLook.Magnitude < 0.1 then horizontalCameraLook = baseDirectionAwayFromWall end

    local dot = math.clamp(baseDirectionAwayFromWall:Dot(horizontalCameraLook), -1, 1)
    local angleBetween = math.acos(dot)
    local cross = baseDirectionAwayFromWall:Cross(horizontalCameraLook)
    local rotationSign = -math.sign(cross.Y)
    if rotationSign == 0 then angleBetween = 0 end

    local actualInfluenceAngle
    if rotationSign == 1 then
        actualInfluenceAngle = math.min(angleBetween, maxInfluenceAngleRight)
    elseif rotationSign == -1 then
        actualInfluenceAngle = math.min(angleBetween, maxInfluenceAngleLeft)
    else
        actualInfluenceAngle = 0
    end

    local adjustmentRotation = CFrame.Angles(0, actualInfluenceAngle * rotationSign, 0)
    local initialTargetLookDirection = adjustmentRotation * baseDirectionAwayFromWall

    -- Smooth rotation using TweenService
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local goal = {}
    goal.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + initialTargetLookDirection)
    local tween = TweenService:Create(rootPart, tweenInfo, goal)
    tween:Play()

    local didJump = false
    if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        didJump = true
        
        -- Visual feedback
        if statusLabel then
            local originalText = statusLabel.Text
            statusLabel.Text = "JUMPING!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
            task.wait(0.5)
            if wallhopToggle then
                statusLabel.Text = "WallHop V5: ON"
                statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
            else
                statusLabel.Text = originalText
            end
        end
    end

    if didJump then
        task.wait(0.1)
        if jumpType ~= "Button" then
            task.wait(0.1)
            InfiniteJumpEnabled = true
        end
    end
end

-- Function for the "Jump" button in GUI 2
local function performFaceWallJump()
    local wallRayResult = getWallRaycastResult()
    if wallRayResult then
        executeWallJump(wallRayResult, "Button")
    else
        if statusLabel then
            local originalText = statusLabel.Text
            statusLabel.Text = "No wall detected!"
            statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
            task.wait(1)
            statusLabel.Text = originalText
            statusLabel.TextColor3 = wallhopToggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 50, 50)
        end
    end
end

-- Button Functions with enhanced visual feedback
onButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "WallHop V5: ON"
    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    wallhopToggle = true
    onButton.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
    offButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

offButton.MouseButton1Click:Connect(function()
    statusLabel.Text = "WallHop V5: OFF"
    statusLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
    wallhopToggle = false
    offButton.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    onButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

-- Addition Button Functionality (Creates/Destroys GUI 2)
additionButton.MouseButton1Click:Connect(function()
    additionToggle = not additionToggle
    if additionToggle then
        if not additionalFrame then
            additionButton.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
            additionalFrame = Instance.new("Frame")
            additionalFrame.Name = "AdditionalWallHopFrame"
            additionalFrame.Parent = frame
            additionalFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            additionalFrame.Size = UDim2.new(0, 200, 0, 100)
            additionalFrame.Position = UDim2.new(0, 0, 1, 5)
            additionalFrame.Active = false; additionalFrame.Draggable = false; additionalFrame.BorderSizePixel = 0
            
            local additionalCorner = Instance.new("UICorner")
            additionalCorner.CornerRadius = UDim.new(0, 8)
            additionalCorner.Parent = additionalFrame

            jumpButtonInAddition = Instance.new("TextButton")
            jumpButtonInAddition.Name = "FaceWallJumpButton"; jumpButtonInAddition.Parent = additionalFrame
            jumpButtonInAddition.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
            jumpButtonInAddition.Size = UDim2.new(0.8, 0, 0.4, 0)
            jumpButtonInAddition.Position = UDim2.new(0.1, 0, 0.3, 0)
            jumpButtonInAddition.Text = "JUMP NOW"; jumpButtonInAddition.TextColor3 = Color3.fromRGB(255,255,255)
            jumpButtonInAddition.TextScaled = true; jumpButtonInAddition.Active = true
            
            local jumpCorner = Instance.new("UICorner")
            jumpCorner.CornerRadius = UDim.new(0, 6)
            jumpCorner.Parent = jumpButtonInAddition
            
            jumpButtonInAddition.MouseButton1Click:Connect(performFaceWallJump)
        end
    else
        if additionalFrame then
            additionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            additionalFrame:Destroy(); additionalFrame = nil; jumpButtonInAddition = nil
        end
    end
end)

-- Auto Button Toggle Functionality
autoButton.MouseButton1Click:Connect(function()
    autoToggle = not autoToggle
    
    if autoToggle then
        if selectedBrickColor then
            autoButton.Text = "Auto: ON"
            autoButton.TextColor3 = Color3.fromRGB(0, 255, 0)
            autoButton.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
        else
            autoToggle = false
            autoButton.Text = "Auto: OFF"
            autoButton.TextColor3 = Color3.fromRGB(255, 50, 50)
            autoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            
            if statusLabel then
                local currentStatusText = statusLabel.Text
                local currentStatusColor = statusLabel.TextColor3
                statusLabel.Text = "Select color first!"
                statusLabel.TextColor3 = Color3.fromRGB(255, 150, 0)
                task.wait(2)
                statusLabel.Text = currentStatusText
                statusLabel.TextColor3 = currentStatusColor
            end
        end
    else
        autoButton.Text = "Auto: OFF"
        autoButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        autoButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- Plus Button Functionality (GUI 3 - Color Selection)
plusButton.MouseButton1Click:Connect(function()
    plusButtonToggle = not plusButtonToggle

    if plusButtonToggle then
        plusButton.BackgroundColor3 = Color3.fromRGB(0, 80, 0)

        if not plusFrame then
            plusFrame = Instance.new("Frame")
            plusFrame.Name = "PlusFrame"; plusFrame.Parent = frame
            plusFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            plusFrame.Size = UDim2.new(0, 200, 0, 120); plusFrame.Position = UDim2.new(0, -205, 0, 0)
            plusFrame.Active = false; plusFrame.Draggable = false; plusFrame.BorderSizePixel = 0
            plusFrame.Visible = true
            
            local plusFrameCorner = Instance.new("UICorner")
            plusFrameCorner.CornerRadius = UDim.new(0, 8)
            plusFrameCorner.Parent = plusFrame

            selectButtonInPlusFrame = Instance.new("TextButton")
            selectButtonInPlusFrame.Name = "SelectPlatformButton"; selectButtonInPlusFrame.Parent = plusFrame
            selectButtonInPlusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            selectButtonInPlusFrame.Size = UDim2.new(0, 80, 0, 30); selectButtonInPlusFrame.Position = UDim2.new(0, 10, 0, 10)
            selectButtonInPlusFrame.Text = "Select Color"; selectButtonInPlusFrame.TextScaled = true; 
            selectButtonInPlusFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
            
            local selectCorner = Instance.new("UICorner")
            selectCorner.CornerRadius = UDim.new(0, 6)
            selectCorner.Parent = selectButtonInPlusFrame

            colorListLabelInPlusFrame = Instance.new("TextLabel")
            colorListLabelInPlusFrame.Name = "ColorDisplayLabel"; colorListLabelInPlusFrame.Parent = plusFrame
            colorListLabelInPlusFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); 
            colorListLabelInPlusFrame.BackgroundTransparency = 0
            colorListLabelInPlusFrame.Size = UDim2.new(0, 180, 0, 70); 
            colorListLabelInPlusFrame.Position = UDim2.new(0, 10, 0, 45)
            colorListLabelInPlusFrame.Text = "Click 'Select Color' then click any part in the game world"
            colorListLabelInPlusFrame.TextColor3 = Color3.new(1, 1, 1)
            colorListLabelInPlusFrame.TextScaled = true; colorListLabelInPlusFrame.BorderSizePixel = 0;
            
            local colorLabelCorner = Instance.new("UICorner")
            colorLabelCorner.CornerRadius = UDim.new(0, 6)
            colorLabelCorner.Parent = colorListLabelInPlusFrame

            selectButtonInPlusFrame.MouseButton1Click:Connect(function()
                selectModeActive = not selectModeActive

                if selectModeActive then
                    selectButtonInPlusFrame.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
                    colorListLabelInPlusFrame.Text = "Click any part in the world to detect its color"
                    
                    if mouseClickConnection then mouseClickConnection:Disconnect(); mouseClickConnection = nil end

                    mouseClickConnection = mouse.Button1Down:Connect(function()
                        local target = mouse.Target
                        if target and target:IsA("BasePart") then
                            local part = target
                            local bColor = part.BrickColor
                            local colorValue = part.Color

                            selectedBrickColor = bColor
                            colorListLabelInPlusFrame.Text = "Selected Color:\n" .. bColor.Name
                            colorListLabelInPlusFrame.TextColor3 = colorValue
                            
                            selectButtonInPlusFrame.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
                            selectButtonInPlusFrame.Text = "Selected!"
                            
                            task.wait(1)
                            selectButtonInPlusFrame.Text = "Select Color"
                        else
                            colorListLabelInPlusFrame.Text = "Invalid target!\nClick a valid part."
                            colorListLabelInPlusFrame.TextColor3 = Color3.fromRGB(255, 50, 50)
                        end
                    end)
                else
                    selectButtonInPlusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    if mouseClickConnection then mouseClickConnection:Disconnect(); mouseClickConnection = nil end
                end
            end)
        else
            plusFrame.Visible = true
        end
    else
        plusButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        if plusFrame then
            plusFrame.Visible = false
            if selectModeActive then
                selectModeActive = false
                if selectButtonInPlusFrame then 
                    selectButtonInPlusFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) 
                end
                if mouseClickConnection then mouseClickConnection:Disconnect(); mouseClickConnection = nil end
            end
        end
    end
end)

-- Auto Jump Heartbeat Loop
autoJumpConnection = RunService.Heartbeat:Connect(function(deltaTime)
    if not autoToggle then return end
    if not selectedBrickColor then return end
    if not wallhopToggle then return end

    local character = player.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not (humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead) then return end

    local wallRayResult = getWallRaycastResult()

    if wallRayResult and wallRayResult.Instance then
        local hitPart = wallRayResult.Instance
        if hitPart:IsA("BasePart") and hitPart.BrickColor == selectedBrickColor then
            executeWallJump(wallRayResult, "Auto")
        end
    end
end)

-- Destroy Button Functionality
destroyButton.MouseButton1Click:Connect(function()
    -- Disconnect all connections
    if jumpConnection then jumpConnection:Disconnect(); jumpConnection = nil end
    if autoJumpConnection then autoJumpConnection:Disconnect(); autoJumpConnection = nil end
    if mouseClickConnection then mouseClickConnection:Disconnect(); mouseClickConnection = nil end

    -- Destroy all GUI elements
    if additionalFrame then additionalFrame:Destroy() end
    if plusFrame then plusFrame:Destroy() end
    if screenGui then screenGui:Destroy() end

    print("WallHop V5 GUI Destroyed - Made by Roblox Hacks 404")
end)

-- Main Wallhop Function (Spacebar)
jumpConnection = UserInputService.JumpRequest:Connect(function()
    if not wallhopToggle then return end

    local wallRayResult = getWallRaycastResult()
    if wallRayResult then
        executeWallJump(wallRayResult, "Manual")
    end
end)

print("WallHop V5 Loaded Successfully - Made by Roblox Hacks 404")
[file content end]