------------>Project Alpha<--------------
----->https://discord.gg/EKyPk4QbgD<-----

Config = {}

Config.Language = "en"

Config.Locale = {
    de = {
        success = "~g~Erfolg!~s~ Du hast %sx %s geerntet.",
        failure = "~r~Fehlgeschlagen!~s~ Du hast beim Ernten versagt.",
        helpText = "Drücke ~INPUT_CONTEXT~ um zu ernten"
    },
    en = {
        success = "~g~Success!~s~ You harvested %sx %s.",
        failure = "~r~Failed!~s~ You failed to harvest.",
        helpText = "Press ~INPUT_CONTEXT~ to harvest"
    }
}

Config.Farms = {
    weed = {
        label = "Weed Farm",
        item = "weed",
        difficulty = "easy",
        amount = {min = 1, max = 3},
        blip = {
            show = true,
            sprite = 140,
            color = 2,
            scale = 0.8
        },
        marker = {
            type = 1,
            scale = vector3(1.5, 1.5, 0.5),
            color = {r = 0, g = 255, b = 0, a = 100}
        },
        animation = {
            dict = "amb@world_human_gardener_plant@male@idle_a",
            name = "idle_a",
            flag = 49
        },
        disableAfterHarvest = true,
        locations = {
            vec3(2224.56, 5577.91, 53.84),
            vec3(2230.12, 5580.34, 53.84),
            vec3(2215.78, 5575.00, 53.84)
        }
    },

    corn = {
        label = "Mais Farm",
        item = "corn",
        difficulty = "hard",
        amount = {min = 2, max = 5},
        blip = {
            show = true,
            sprite = 85,
            color = 3,
            scale = 0.7
        },
        marker = {
            type = 27,
            scale = vector3(1.0, 1.0, 1.0),
            color = {r = 255, g = 255, b = 0, a = 150}
        },
        animation = {
            dict = "amb@world_human_hammering@male@base",
            name = "base",
            flag = 49
        },
        disableAfterHarvest = false,
        locations = {
            vec3(2850.0, 4450.0, 50.0),
            vec3(2855.12, 4447.50, 50.0)
        }
    }
}
