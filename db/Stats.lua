-- COOLTIP_STATS.xpac = {
--   {
--     search string: that can be uniquely used to string.find() a matching line,
--     value prefix: the part of the string that comes before the value,
--     value suffix: ^ after the value. pre/suffix must use % on chars to escape string.gsub(),
--     new suffix: that will be placed after the value in the new format
--   }, for each entry
-- }

COOLTIP_PRIM_STATS_COLOR = {
    r=1,
    g=1,
    b=1,
}
COOLTIP_PRIM_STATS = {
    {
        "[%+%-]%d+ Strength(%.?)$",
        "[%+%-]",
        " Strength",
        "Strength",
    },
    {
        "[%+%-]%d+ Agility(%.?)$",
        "[%+%-]",
        " Agility",
        "Agility",
    },
    {
        "[%+%-]%d+ Stamina(%.?)$",
        "[%+%-]",
        " Stamina",
        "Stamina",
    },
    {
        "[%+%-]%d+ Intellect(%.?)$",
        "[%+%-]",
        " Intellect",
        "Intellect",
    },
    {
        "[%+%-]%d+ Spirit(%.?)$",
        "[%+%-]",
        " Spirit",
        "Spirit",
    },
    { -- Jagged Obsidian Shield
        "All Resistances.",
        "%+",
        " All Resistances%.",
        "All Resistances"
    },
}

COOLTIP_SEC_STATS_COLOR = {
    r=0.00,
    g=1.00,
    b=0.00,
}
COOLTIP_SEC_STATS = {
  wotlk={
    -- Tank Stats
    {
        "Increases defense rating by ",
        "Increases defense rating by ",
        "%.",
        "Defense Rating"
    },
    {
        "Increases the block value of your shield by ",
        "Increases the block value of your shield by ",
        "%.",
        "Block Value"
    },
    {
        "Increases your dodge rating by ",
        "Increases your dodge rating by ",
        "%.",
        "Dodge Rating"
    },
    {
        "Improves your resilience rating by ",
        "Improves your resilience rating by ",
        "%.",
        "Resilience Rating"
    },

    -- DPS Stats
    {
        "Increases attack power by",
        "Increases attack power by ",
        "%.",
        "Attack Power"
    },
    {
        "Improves critical strike rating by ",
        "Improves critical strike rating by ",
        "%.",
        "Critical Strike Rating"
    },
    {
        "Improves hit rating by ",
        "Improves hit rating by ",
        "%.",
        "Hit Rating"
    },
    {
        "Increases your expertise rating by ",
        "Increases your expertise rating by ",
        "%.",
        "Expertise Rating"
    },

    -- Caster Stats
    {
        "Increases spell power by",
        "Increases spell power by ",
        "%.",
        "Spell Power"
    },
    {
        "Increases your spell penetration by ",
        "Increases your spell penetration by ",
        "%.",
        "Spell Penetration"
    },
    {
        " health per ",
        "Restores ",
        " health per 5 sec%.",
        "Health per 5s"
    },
    {
        " mana per ",
        "Restores ",
        " mana per 5 sec%.",
        "Mana Per 5s"
    },
  },
  tbc={
  },
  vanilla={
    -- Tank Stats
    {
        "Increased Defense",
        "Increased Defense %+",
        "%.",
        "Defense"
    },
    {
        "Increases your chance to block attacks with a shield by ",
        "Increases your chance to block attacks with a shield by ",
        "%.",
        "Block Chance"
    },
    {
        "Increases the block value of your shield by ",
        "Increases the block value of your shield by ",
        "%.",
        "Block Value"
    },
    {
        "Increases your chance to dodge an attack by ",
        "Increases your chance to dodge an attack by ",
        "%.",
        "Dodge"
    },
    {
        "Increases your chance to parry an attack by ",
        "Increases your chance to parry an attack by ",
        "%.",
        "Parry"
    },

    -- DPS Stats
    {
        " Attack Power%.",
        "%+",
        " Attack Power%.",
        "Attack Power"
    },
    {
        "Improves your chance to get a critical strike by ",
        "Improves your chance to get a critical strike by ",
        "%.",
        "Critical Strike"
    },
    {
        "Improves your chance to hit by ",
        "Improves your chance to hit by ",
        "%.",
        "Hit"
    },
    { -- Might of Cenarius
        " Weapon Damage(%.?)$",
        "%+",
        " Weapon Damage%.",
        "Weapon Damage",
    },

    -- Caster Stats
    {
        "Increases damage and healing done by magical spells and effects by up to ",
        "Increases damage and healing done by magical spells and effects by up to ",
        "%.",
        "Spell Power"
    },
    {
        "Increases healing done by spells and effects by up to ",
        "Increases healing done by spells and effects by up to ",
        "%.",
        "Spell Healing"
    },
    { -- Another variation, as found on "Of Healing" gear
        "Healing Spells",
        "%+",
        " Healing Spells",
        "Spell Healing"
    },
    {
        " health per ",
        "Restores ",
        " health per 5 sec%.",
        "Health per 5s"
    },
    {
        " mana per ",
        "Restores ",
        " mana per 5 sec%.",
        "Mana Per 5s"
    },
    {
        "Improves your chance to get a critical strike with spells by ",
        "Improves your chance to get a critical strike with spells by ",
        "%.",
        "Spell Critical Strike"
    },
    {
        "Improves your chance to hit with spells by ",
        "Improves your chance to hit with spells by ",
        "%.",
        "Spell Hit"
    },
    {
        "Decreases the magical resistances of your spell targets by ",
        "Decreases the magical resistances of your spell targets by ",
        "%.",
        "Spell Penetration"
    },
    { -- Ironbark Shield
        "Improves your chance to get a critical strike with Nature spells by ",
        "Improves your chance to get a critical strike with Nature spells by ",
        "%.",
        "Nature Spell Critical Strike"
    },
    { -- Priest T1
        "Improves your chance to get a critical strike with Holy spells by ",
        "Improves your chance to get a critical strike with Holy spells by ",
        "%.",
        "Holy Spell Critical Strike"
    },
    { -- Benediction, Circle of Hope
        "Increases the critical effect chance of your Holy spells by ",
        "Increases the critical effect chance of your Holy spells by ",
        "%.",
        "Holy Spell Critical Strike"
    },

    -- Other
    { -- Carrot on a Stick. Standardized with enchants.
        "Increases mount speed by ",
        "Increases mount speed by ",
        "%.",
        "Mount Speed"
    },
  },
  turtle={
    {
        " Attack Power in Cat, Bear, Dire Bear, and Moonkin forms only%.",
        "%+",
        " Attack Power in Cat, Bear, Dire Bear, and Moonkin forms only%.",
        "Feral Attack Power"
    },
    {
        " of damage dealt is returned as healing.",
        "",
        " of damage dealt is returned as healing.",
        "Vampirism"
    },
    {
        "Reduces damage taken from critical hits and damage over time effects by ",
        "Reduces damage taken from critical hits and damage over time effects by ",
        "%.",
        "Resilience"
    },
    {
        " of the target's armor.", -- BRE's effect gets caught if we search the first term
        "Your attacks ignore ",
        " of the target's armor.",
        "Armor Penetration"
    },
    {
        " %d%d?%% of your Mana regeneration to continue while casting.", -- matches 2 digits but not darkmoon card's +100%.
        "Allows ",
        " of your Mana regeneration to continue while casting.",
        "Casting Mana Regen"
    },
    {
        "Increases your attack and casting speed",
        "Increases your attack and casting speed by ",
        "%.",
        "Haste"
    },
    { -- In 1.12, just Azure Silk Belt
      -- On Turtle, this effect appears on multiple pieces of gear and stacks
        "Increases swim speed by ",
        "Increases swim speed by ",
        "%.",
        "Swim Speed"
    },
  }
}

for _,school in pairs( { "Nature", "Frost", "Fire", "Arcane", "Shadow" } ) do
    table.insert(COOLTIP_PRIM_STATS, {
        "^[%+%-]%d+ " .. school .. " Resistance$",
        "[%+%-]",
        " " .. school .. " Resistance",
        school .. " Resistance"
    })
end

for _,school in pairs( { "Nature", "Frost", "Fire", "Arcane", "Shadow", "Holy" } ) do
    table.insert(COOLTIP_SEC_STATS.vanilla, {
        "Increases damage done by " .. school .. " spells and effects by up to ",
        "Increases damage done by " .. school .. " spells and effects by up to ",
        "%.",
        school .. " Spell Damage"
    })
end

for _,weapon in pairs( { "Swords", "Two-handed Swords", "Axes", "Two-handed Axes", "Maces", "Two-handed Maces", "Daggers", "Fist Weapons", "Polearms", "Staves", "Fishing" } ) do
    table.insert(COOLTIP_SEC_STATS.vanilla, {
        "Increased " .. weapon .. " %+",
        "Increased " .. weapon .. " %+",
        "%.",
        weapon .. " Skill"
    })
end

for _,profession in pairs( { "Skinning", "Mining", "Herbalism", "Engineering" } ) do
    table.insert(COOLTIP_SEC_STATS.vanilla, {
        profession .. " %+",
        profession .. " %+",
        "%.",
        profession .. " Skill"
    })
end
