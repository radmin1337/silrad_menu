---

[Showcase](https://raw.githubusercontent.com/radmin1337/silrad_menu/refs/heads/main/images/showcase.png)

---

# silrad_menu — UI Library

**silrad_menu** is a lightweight, high-performance, and visually striking UI library for Roblox. It provides a smooth user experience with high-quality animations powered by `TweenService`.

> **⚠️ Disclaimer:** This library was **not originally created for public use**. It was developed as a private project; however, you are free to use, modify, and redistribute the code as you see fit.

---

## Features
- **Smooth Animations**: High-quality transitions using `Quart` and `Back` easing styles.
- **Fully Draggable**: Easy-to-move interface via the top bar.
- **Minimize System**: Sleek toggle to collapse the menu when not in use.
- **Rich Components**: Includes Buttons, Toggles, Sliders, Dropdowns, and Keybinds.

---

## Installation

### Method 1: Loadstring (Recommended)
Host the script on GitHub or Pastebin and use the following code in your script executor:
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/radmin1337/silrad_menu/refs/heads/main/silrad_blood.lua"))()
```

### Method 2: Direct Source
Simply copy the entire source code of the library and paste it at the top of your script.

---

## Documentation

### 1. Initialize the Library
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/radmin1337/silrad_menu/refs/heads/main/silrad_blood.lua"))()
local Window = Library:CreateWindow("The Great Script")
```

### 2. Create a Tab
```lua
local MainTab = Window:AddTab("Main")
local VisualsTab = Window:AddTab("Visuals")
```

### 3. Adding Elements

#### Button
```lua
MainTab:Button("Click Me!", function()
    print("Button clicked!")
end)
```

#### Toggle
```lua
MainTab:Toggle("Enable Feature", false, function(state)
    print("Toggle status:", state)
end)
```

#### Slider
```lua
MainTab:Slider("WalkSpeed", 16, 100, 16, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
```

#### Dropdown
```lua
MainTab:Dropdown("Select Mode", {"Aggressive", "Passive", "Stealth"}, "Passive", function(selected)
    print("Selected mode:", selected)
end)
```

#### Keybind
```lua
MainTab:Bind("Menu Key", Enum.KeyCode.RightControl, function(key)
    print("New keybind set to: " .. key.Name)
end)
```

---

## Full Example Script

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/radmin1337/silrad_menu/refs/heads/main/silrad_blood.lua"))()

local Win = Library:CreateWindow("My Script")
local Tab = Win:AddTab("Combat")

Tab:Toggle("Kill Aura", false, function(bool)
    _G.Aura = bool
end)

Tab:Slider("Reach Distance", 1, 20, 5, function(val)
    print("Reach set to: " .. val)
end)

Tab:Dropdown("Target Priority", {"Closest", "Lowest HP", "Friends"}, "Closest", function(choice)
    print("Priority: " .. choice)
end)

Tab:Button("Destroy UI", function()
    game:GetService("CoreGui").silrad_menu:Destroy()
end)
```

---
