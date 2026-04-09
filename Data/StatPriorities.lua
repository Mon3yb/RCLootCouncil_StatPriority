local _, ns = ...

ns.STAT_PRIORITIES = {
    DEATHKNIGHT = {
        fallback_order = {"Blood", "Frost", "Unholy"},
        specs = {
            Blood = "H > M > V >= C",
            Frost = "M > C > H >= V",
            Unholy = "M > H > C >= V",
        },
    },
    DEMONHUNTER = {
        fallback_order = {"Havoc", "Vengeance"},
        specs = {
            Havoc = "M > C > H >= V",
            Vengeance = "H > V >= M > C",
        },
    },
    DRUID = {
        fallback_order = {"Balance", "Feral", "Guardian", "Restoration"},
        specs = {
            Balance = "M > H >= C > V",
            Feral = "M > C > H >= V",
            Guardian = "H > M > V >= C",
            Restoration = "H > M > C >= V",
        },
    },
    EVOKER = {
        fallback_order = {"Augmentation", "Devastation", "Preservation"},
        specs = {
            Augmentation = "M > C > H >= V",
            Devastation = "M > H > C >= V",
            Preservation = "M > H > C >= V",
        },
    },
    HUNTER = {
        fallback_order = {"Beast Mastery", "Marksmanship", "Survival"},
        specs = {
            ["Beast Mastery"] = "C > H > M >= V",
            Marksmanship = "C > M > H >= V",
            Survival = "M > H > C >= V",
        },
    },
    MAGE = {
        fallback_order = {"Arcane", "Fire", "Frost"},
        specs = {
            Arcane = "H > M > C >= V",
            Fire = "M > H > C >= V",
            Frost = "H > M > C >= V",
        },
    },
    MONK = {
        fallback_order = {"Brewmaster", "Mistweaver", "Windwalker"},
        specs = {
            Brewmaster = "V > C > H >= M",
            Mistweaver = "H > C > M >= V",
            Windwalker = "M > C > H >= V",
        },
    },
    PALADIN = {
        fallback_order = {"Holy", "Protection", "Retribution"},
        specs = {
            Holy = "H > M > C >= V",
            Protection = "H > V >= M > C",
            Retribution = "M > C > H >= V",
        },
    },
    PRIEST = {
        fallback_order = {"Discipline", "Holy", "Shadow"},
        specs = {
            Discipline = "H > C > M >= V",
            Holy = "M > H > C >= V",
            Shadow = "H > M > C >= V",
        },
    },
    ROGUE = {
        fallback_order = {"Assassination", "Outlaw", "Subtlety"},
        specs = {
            Assassination = "M > H > C >= V",
            Outlaw = "H > V >= C > M",
            Subtlety = "M > C > H >= V",
        },
    },
    SHAMAN = {
        fallback_order = {"Elemental", "Enhancement", "Restoration"},
        specs = {
            Elemental = "M > H > C >= V",
            Enhancement = "H > M > C >= V",
            Restoration = "H > C > M >= V",
        },
    },
    WARLOCK = {
        fallback_order = {"Affliction", "Demonology", "Destruction"},
        specs = {
            Affliction = "H > M > C >= V",
            Demonology = "M > H > C >= V",
            Destruction = "H > M > C >= V",
        },
    },
    WARRIOR = {
        fallback_order = {"Arms", "Fury", "Protection"},
        specs = {
            Arms = "C > H > M >= V",
            Fury = "H > M > C >= V",
            Protection = "H > V >= M > C",
        },
    },
}
