-- Panel de Opciones
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 200, 0, 300)
MainFrame.Position = UDim2.new(0, 10, 0, 10)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Parent = ScreenGui

local AimbotToggle = Instance.new("TextButton")
AimbotToggle.Size = UDim2.new(0, 180, 0, 50)
AimbotToggle.Position = UDim2.new(0, 10, 0, 10)
AimbotToggle.Text = "Aimbot: OFF"
AimbotToggle.BackgroundColor3 = Color3.new(0, 0, 0)
AimbotToggle.TextColor3 = Color3.new(1, 1, 1)
AimbotToggle.Parent = MainFrame

local ESPToggle = Instance.new("TextButton")
ESPToggle.Size = UDim2.new(0, 180, 0, 50)
ESPToggle.Position = UDim2.new(0, 10, 0, 70)
ESPToggle.Text = "ESP: OFF"
ESPToggle.BackgroundColor3 = Color3.new(0, 0, 0)
ESPToggle.TextColor3 = Color3.new(1, 1, 1)
ESPToggle.Parent = MainFrame

-- Función para el ESP
local function esp()
   for _, player in pairs(game:GetService("Players"):GetPlayers()) do
      if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         local head = player.Character:FindFirstChild("Head")
         local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")

         if not head or not torso then return end

         local billboardGui = Instance.new("BillboardGui")
         billboardGui.Size = UDim2.new(1, 0, 1, 0)
         billboardGui.StudsOffset = Vector3.new(0, 2, 0)
         billboardGui.AlwaysOnTop = true
         billboardGui.Parent = head

         local frame = Instance.new("Frame")
         frame.Size = UDim2.new(1, 0, 0, 30)
         frame.BackgroundColor3 = Color3.new(0, 0, 0)
         frame.BorderSizePixel = 1
         frame.Parent = billboardGui

         local textLabel = Instance.new("TextLabel")
         textLabel.Size = UDim2.new(1, 0, 1, 0)
         textLabel.BackgroundTransparency = 1
         textLabel.Text = player.Name
         textLabel.TextColor3 = Color3.new(1, 1, 1)
         textLabel.TextScaled = true
         textLabel.Parent = frame

         -- Línea de conexión
         local line = Drawing.new("Line")
         line.Thickness = 2
         line.Color = Color3.new(1, 0, 0)
         line.Visible = true
         line.From = Vector2.new(player.Character.HumanoidRootPart.Position.X, player.Character.HumanoidRootPart.Position.Y, player.Character.HumanoidRootPart.Position.Z)
         line.To = Vector2.new(player.Character.HumanoidRootPart.Position.X, player.Character.HumanoidRootPart.Position.Y, player.Character.HumanoidRootPart.Position.Z)

         -- Caja alrededor del jugador
         local box = Drawing.new("Square")
         box.Thickness = 2
         box.Color = Color3.new(0, 1, 0)
         box.Visible = true
         box.Size = Vector2.new(2, 2)
         box.Position = Vector2.new(player.Character.HumanoidRootPart.Position.X, player.Character.HumanoidRootPart.Position.Y, player.Character.HumanoidRootPart.Position.Z)
      end
   end
end

-- Función para el Aimbot
local function aimbot()
   local players = game:GetService("Players")
   local mouse = players.LocalPlayer:GetMouse()
   local target = nil

   for _, player in pairs(players:GetPlayers()) do
      if player ~= players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
         if not target or (player.Character.HumanoidRootPart.Position - players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < (target.Character.HumanoidRootPart.Position - players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude then
            target = player
         end
      end
   end

   if target then
      local ray = Ray.new(players.LocalPlayer.Character.HumanoidRootPart.Position, (target.Character.HumanoidRootPart.Position - players.LocalPlayer.Character.HumanoidRootPart.Position).unit * 1000)
      local hit, position = workspace:FindPartOnRay(ray, players.LocalPlayer.Character)

      if hit and hit.Parent and hit.Parent:FindFirstChild("Humanoid") then
         mouse.Hit = hit
      end
   end
end

-- Eventos de Click para los Botones
AimbotToggle.MouseButton1Click:Connect(function()
   if AimbotToggle.Text == "Aimbot: OFF" then
      AimbotToggle.Text = "Aimbot: ON"
      game:GetService("RunService").RenderStepped:Connect(aimbot)
   else
      AimbotToggle.Text = "Aimbot: OFF"
      game:GetService("RunService").RenderStepped:Disconnect(aimbot)
   end
end)

ESPToggle.MouseButton1Click:Connect(function()
   if ESPToggle.Text == "ESP: OFF" then
      ESPToggle.Text = "ESP: ON"
      esp()
   else
      ESPToggle.Text = "ESP: OFF"
      for _, player in pairs(game:GetService("Players"):GetPlayers()) do
         if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            for _, v in pairs(player.Character:GetChildren()) do
               if v:IsA("BillboardGui") then
                  v:Destroy()
               end
            end
         end
      end
   end
end)
