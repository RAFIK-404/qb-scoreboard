Config = {}

-- General settings
Config.ServerName = "Infinit City"
Config.ServerLogo = "https://i.ibb.co/21j6Fb8X/logo.png"
Config.OpenKey = "HOME" -- Default key to open scoreboard
Config.RefreshRate = 5000 -- Refresh data every 5 seconds (in ms)

-- Privacy settings
Config.HidePlayerNames = false -- Set to true to show only first 2 characters of player names

-- Default UI settings for new users
Config.DefaultSettings = {
    position = "right", -- "left", "center", "right"
    color = "#5b8fb9",
    opacity = 0.9,
    fontSize = 14,
    theme = "dark" -- "dark" or "light"
}

-- Job settings
Config.Jobs = {
    ["police"] = {
        label = "Police",
        icon = "fas fa-shield-alt"
    },
    ["ambulance"] = {
        label = "EMS",
        icon = "fas fa-ambulance"
    },
    ["mechanic"] = {
        label = "Mechanic",
        icon = "fas fa-wrench"
    },
    ["taxi"] = {
        label = "Taxi",
        icon = "fas fa-taxi"
    },
    ["realtor"] = {
        label = "Real Estate",
        icon = "fas fa-home"
    }
}

-- Heist settings
Config.Heists = {
    -- Each heist can have its own police requirement and default cooldown
    ["fleeca"] = {
        name = "Fleeca Bank",
        description = "Rob the Fleeca Bank for some quick cash",
        image = "https://i.ibb.co/HfcxWs1q/image.png",
        icon = "fas fa-university",
        requiredPolice = 2, -- Minimum police required for this heist
        defaultCooldown = 60 -- Default cooldown in minutes if not specified when triggered
    },
    ["paleto"] = {
        name = "Paleto Bay Bank",
        description = "A bigger score awaits at Paleto Bay",
        image = "https://i.ibb.co/yFMYB4Qd/image.png",
        icon = "fas fa-university",
        requiredPolice = 4,
        defaultCooldown = 120
    },
    ["pacific"] = {
        name = "Pacific Standard",
        description = "The biggest bank heist in the city",
        image = "https://i.ibb.co/3y2qCpsz/image.png",
        icon = "fas fa-university",
        requiredPolice = 6,
        defaultCooldown = 180
    },
    ["jewelry"] = {
        name = "Jewelry Store",
        description = "Steal precious gems and jewelry",
        image = "https://i.ibb.co/1trzCS1G/image.png",
        icon = "fas fa-gem",
        requiredPolice = 3,
        defaultCooldown = 90
    },
    ["bobcat"] = {
        name = "Bobcat Security",
        description = "High-risk weapons heist",
        image = "https://i.ibb.co/v6HpjSXJ/image.png",
        icon = "fas fa-shield-alt",
        requiredPolice = 5,
        defaultCooldown = 150
    },
    ["store"] = {
        name = "Store Robbery",
        description = "Quick cash grab from a local store—low risk, low reward, but cops respond fast!",
        image = "https://i.ibb.co/KjdMytY2/image.png",
        icon = "fas fa-shop",
        requiredPolice = 1,
        defaultCooldown = 1
    },
}

