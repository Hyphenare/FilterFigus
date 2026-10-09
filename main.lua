local Players = game:GetService("Players")
local Me = Players.LocalPlayer

local Selected
local Highlight
local Minimized = false
local ListOpen = true
local CurrentTab = "Standard"

local GUI = Instance.new("ScreenGui")
GUI.Name = "PlayerInspector"
GUI.ResetOnSpawn = false
GUI.Parent = Me:WaitForChild("PlayerGui")

local function New(Class, Parent, Props)
    local Obj = Instance.new(Class)
    for K, V in pairs(Props) do
        Obj[K] = V
    end
    Obj.Parent = Parent
    return Obj
end

local function Corner(Obj, Radius)
    New("UICorner", Obj, {
        CornerRadius = UDim.new(0, Radius)
    })
end

local function Button(Parent, Text, Size, Position, Color)
    local B = New("TextButton", Parent, {
        Text = Text,
        Size = Size,
        Position = Position,
        BackgroundColor3 = Color,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 14,
        Font = Enum.Font.GothamMedium,
        BorderSizePixel = 0,
        AutoButtonColor = true
    })
    Corner(B, 8)
    return B
end

local Main = New("Frame", GUI, {
    Size = UDim2.fromOffset(340, 390),
    Position = UDim2.new(0.5, -170, 0.5, -195),
    BackgroundColor3 = Color3.fromRGB(27, 29, 35),
    BorderSizePixel = 0,
    Active = true,
    Draggable = true
})
Corner(Main, 12)

local Header = New("Frame", Main, {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Color3.fromRGB(38, 40, 48),
    BorderSizePixel = 0
})
Corner(Header, 12)

New("TextLabel", Header, {
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(1, -150, 1, 0),
    BackgroundTransparency = 1,
    Text = "Player Inspector",
    TextColor3 = Color3.new(1, 1, 1),
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left
})

local Refresh = Button(Header, "♻️", UDim2.fromOffset(32, 30),
    UDim2.new(1, -142, 0, 7), Color3.fromRGB(55, 115, 75))

local Back = Button(Header, "/", UDim2.fromOffset(28, 30),
    UDim2.new(1, -105, 0, 7), Color3.fromRGB(225, 135, 50))

local Min = Button(Header, "–", UDim2.fromOffset(28, 30),
    UDim2.new(1, -71, 0, 7), Color3.fromRGB(65, 68, 78))

local Close = Button(Header, "×", UDim2.fromOffset(28, 30),
    UDim2.new(1, -37, 0, 7), Color3.fromRGB(190, 55, 60))

local Body = New("Frame", Main, {
    Position = UDim2.fromOffset(10, 54),
    Size = UDim2.new(1, -20, 1, -64),
    BackgroundTransparency = 1
})

local ListPage = New("Frame", Body, {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1
})

local ToggleList = Button(ListPage, "▼  Players", UDim2.new(1, 0, 0, 34),
    UDim2.new(), Color3.fromRGB(48, 51, 60))

local PlayerList = New("ScrollingFrame", ListPage, {
    Position = UDim2.fromOffset(0, 42),
    Size = UDim2.new(1, 0, 1, -88),
    BackgroundColor3 = Color3.fromRGB(34, 36, 43),
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new()
})
Corner(PlayerList, 8)

local PlayerLayout = New("UIListLayout", PlayerList, {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.Name
})

local SelectButton = Button(ListPage, "Select Player", UDim2.new(1, 0, 0, 36),
    UDim2.new(0, 0, 1, -36), Color3.fromRGB(65, 100, 180))

local DetailsPage = New("Frame", Body, {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Visible = false
})

local Avatar = New("ImageLabel", DetailsPage, {
    Size = UDim2.fromOffset(64, 64),
    Position = UDim2.fromOffset(4, 4),
    BackgroundColor3 = Color3.fromRGB(45, 47, 55),
    BorderSizePixel = 0
})
Corner(Avatar, 12)

local NameLabel = New("TextLabel", DetailsPage, {
    Position = UDim2.fromOffset(78, 5),
    Size = UDim2.new(1, -82, 0, 28),
    BackgroundTransparency = 1,
    Text = "No player selected",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
})

local Tabs = New("Frame", DetailsPage, {
    Position = UDim2.fromOffset(0, 76),
    Size = UDim2.new(1, 0, 0, 36),
    BackgroundTransparency = 1
})

local StandardTab = Button(Tabs, "Standard", UDim2.new(0.34, -3, 1, 0),
    UDim2.new(), Color3.fromRGB(65, 100, 180))

local HighlightTab = Button(Tabs, "Highlight", UDim2.new(0.33, -3, 1, 0),
    UDim2.new(0.34, 0, 0, 0), Color3.fromRGB(48, 51, 60))

local TeleportTab = Button(Tabs, "Teleport", UDim2.new(0.33, -3, 1, 0),
    UDim2.new(0.67, 0, 0, 0), Color3.fromRGB(48, 51, 60))

local Content = New("ScrollingFrame", DetailsPage, {
    Position = UDim2.fromOffset(0, 120),
    Size = UDim2.new(1, 0, 1, -120),
    BackgroundColor3 = Color3.fromRGB(34, 36, 43),
    BorderSizePixel = 0,
    ScrollBarThickness = 4,
    CanvasSize = UDim2.new()
})
Corner(Content, 8)

local Message = New("TextLabel", Body, {
    Position = UDim2.new(0, 0, 1, -22),
    Size = UDim2.new(1, 0, 0, 20),
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = Color3.fromRGB(255, 190, 100),
    TextSize = 12,
    Font = Enum.Font.Gotham,
    Visible = false
})

local function ClearContent()
    for _, Child in ipairs(Content:GetChildren()) do
        if not Child:IsA("UICorner") then
            Child:Destroy()
        end
    end
    Content.CanvasPosition = Vector2.zero
    Content.CanvasSize = UDim2.new()
end

local function ShowMessage(Text)
    Message.Text = Text
    Message.Visible = true
    task.delay(3, function()
        if Message.Text == Text then
            Message.Visible = false
        end
    end)
end

local function AddRow(Text, Y)
    return New("TextLabel", Content, {
        Position = UDim2.fromOffset(8, Y),
        Size = UDim2.new(1, -16, 0, 30),
        BackgroundColor3 = Color3.fromRGB(48, 51, 60),
        BorderSizePixel = 0,
        Text = Text,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left
    })
end

local function RenderTab(Tab)
    CurrentTab = Tab
    ClearContent()

    StandardTab.BackgroundColor3 =
        Tab == "Standard" and Color3.fromRGB(65, 100, 180)
        or Color3.fromRGB(48, 51, 60)

    HighlightTab.BackgroundColor3 =
        Tab == "Highlight" and Color3.fromRGB(65, 100, 180)
        or Color3.fromRGB(48, 51, 60)

    TeleportTab.BackgroundColor3 =
        Tab == "Teleport" and Color3.fromRGB(65, 100, 180)
        or Color3.fromRGB(48, 51, 60)

    if not Selected then
        AddRow("Select a player first.", 8)
        return
    end

    if Tab == "Standard" then
        local Character = Selected.Character
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        local MyCharacter = Me.Character
        local MyRoot = MyCharacter and MyCharacter:FindFirstChild("HumanoidRootPart")
        local TargetRoot = Character and Character:FindFirstChild("HumanoidRootPart")

        local Health = Humanoid and
            string.format("Health: %.0f / %.0f", Humanoid.Health, Humanoid.MaxHealth)
            or "Health: unavailable"

        local Distance = MyRoot and TargetRoot and
            string.format("Distance: %.1f studs", (MyRoot.Position - TargetRoot.Position).Magnitude)
            or "Distance: unavailable"

        AddRow(Health, 8)
        AddRow(Distance, 44)

        local Y = 80
        AddRow("Backpack tools:", Y)
        Y += 36

        -- Other players' Backpack contents may not replicate to your client.
        local Backpack = Selected:FindFirstChildOfClass("Backpack")
        local Count = 0

        if Backpack then
            for _, Tool in ipairs(Backpack:GetChildren()) do
                if Tool:IsA("Tool") then
                    AddRow("• " .. Tool.Name, Y)
                    Y += 34
                    Count += 1
                end
            end
        end

        if Count == 0 then
            AddRow("No visible Backpack tools.", Y)
            Y += 34
        end

        Content.CanvasSize = UDim2.new(0, 0, 0, Y + 8)

    elseif Tab == "Highlight" then
        local B = Button(Content, "Highlight Player",
            UDim2.new(1, -16, 0, 38), UDim2.fromOffset(8, 8),
            Color3.fromRGB(65, 140, 90))

        B.Activated:Connect(function()
            if not Selected.Character then
                ShowMessage("Player has no character.")
                return
            end

            if Highlight then
                Highlight:Destroy()
                Highlight = nil
            end

            Highlight = Instance.new("Highlight")
            Highlight.Adornee = Selected.Character
            Highlight.FillColor = Color3.fromRGB(255, 170, 45)
            Highlight.OutlineColor = Color3.new(1, 1, 1)
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Parent = GUI

            B.Text = "Highlight Enabled"
        end)

        local Remove = Button(Content, "Remove Highlight",
            UDim2.new(1, -16, 0, 38), UDim2.fromOffset(8, 54),
            Color3.fromRGB(160, 65, 65))

        Remove.Activated:Connect(function()
            if Highlight then
                Highlight:Destroy()
                Highlight = nil
            end
        end)

        Content.CanvasSize = UDim2.new(0, 0, 0, 104)

    elseif Tab == "Teleport" then
        local B = Button(Content, "Teleport to Player",
            UDim2.new(1, -16, 0, 38), UDim2.fromOffset(8, 8),
            Color3.fromRGB(65, 100, 180))

        B.Activated:Connect(function()
            local Character = Me.Character
            local Target = Selected.Character
            local MyRoot = Character and Character:FindFirstChild("HumanoidRootPart")
            local TargetRoot = Target and Target:FindFirstChild("HumanoidRootPart")

            if not MyRoot or not TargetRoot then
                ShowMessage("Character unavailable.")
                return
            end

            Character:PivotTo(TargetRoot.CFrame * CFrame.new(0, 0, 3))
        end)

        Content.CanvasSize = UDim2.new(0, 0, 0, 54)
    end
end

local function OpenDetails()
    if not Selected then
        ShowMessage("Select a player first.")
        return
    end

    ListPage.Visible = false
    DetailsPage.Visible = true

    local Image = Players:GetUserThumbnailAsync(
        Selected.UserId,
        Enum.ThumbnailType.HeadShot,
        Enum.ThumbnailSize.Size150x150
    )

    Avatar.Image = Image
    NameLabel.Text = Selected.DisplayName .. "  (@" .. Selected.Name .. ")"
    RenderTab("Standard")
end

local function RefreshPlayers()
    for _, Child in ipairs(PlayerList:GetChildren()) do
        if Child:IsA("TextButton") then
            Child:Destroy()
        end
    end

    Selected = nil
    SelectButton.Text = "Select Player"

    local Y = 5
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= Me then
            local B = Button(PlayerList, Player.DisplayName .. "  (@" .. Player.Name .. ")",
                UDim2.new(1, -10, 0, 34), UDim2.fromOffset(5, Y),
                Color3.fromRGB(48, 51, 60))

            B.TextXAlignment = Enum.TextXAlignment.Left
            B.Activated:Connect(function()
                Selected = Player
                SelectButton.Text = "Selected: " .. Player.Name

                for _, Other in ipairs(PlayerList:GetChildren()) do
                    if Other:IsA("TextButton") then
                        Other.BackgroundColor3 = Color3.fromRGB(48, 51, 60)
                    end
                end

                B.BackgroundColor3 = Color3.fromRGB(65, 100, 180)
            end)

            Y += 39
        end
    end

    PlayerList.CanvasSize = UDim2.new(0, 0, 0, Y + 5)
end

ToggleList.Activated:Connect(function()
    ListOpen = not ListOpen
    PlayerList.Visible = ListOpen
    SelectButton.Visible = ListOpen
    ToggleList.Text = ListOpen and "▼  Players" or "▶  Players"
end)

SelectButton.Activated:Connect(OpenDetails)

StandardTab.Activated:Connect(function()
    RenderTab("Standard")
end)

HighlightTab.Activated:Connect(function()
    RenderTab("Highlight")
end)

TeleportTab.Activated:Connect(function()
    RenderTab("Teleport")
end)

Back.Activated:Connect(function()
    if DetailsPage.Visible then
        DetailsPage.Visible = false
        ListPage.Visible = true
    else
        ListOpen = not ListOpen
        PlayerList.Visible = ListOpen
        SelectButton.Visible = ListOpen
        ToggleList.Text = ListOpen and "▼  Players" or "▶  Players"
    end
end)

Refresh.Activated:Connect(RefreshPlayers)

Min.Activated:Connect(function()
    Minimized = not Minimized
    Body.Visible = not Minimized
    Main.Size = Minimized and UDim2.fromOffset(340, 44)
        or UDim2.fromOffset(340, 390)
end)

Close.Activated:Connect(function()
    if Highlight then
        Highlight:Destroy()
    end
    GUI:Destroy()
end)

Players.PlayerAdded:Connect(RefreshPlayers)
Players.PlayerRemoving:Connect(function(Player)
    if Selected == Player then
        Selected = nil
    end
    RefreshPlayers()
end)

RefreshPlayers()
