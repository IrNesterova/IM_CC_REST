-- =====================================================================
-- IMPERIUM MALEDICTUM — SKILL DESCRIPTIONS
-- Source: IM Core Rulebook, pp. 83-101
-- =====================================================================

UPDATE skill SET description = d.description
FROM (VALUES
    ('ATHLETICS',       'Physical activities requiring strength, endurance, and coordination — climbing, jumping, swimming, running, and acts of raw strength.'),
    ('AWARENESS',       'Perceiving the world through your senses. Noticing threats, picking out details others miss, and detecting when something is wrong.'),
    ('DEXTERITY',       'Fine motor control and manual precision — picking locks, lifting pockets, sleight of hand, and defusing explosive devices.'),
    ('DISCIPLINE',      'Mental fortitude and psychological resilience — resisting fear, charm, intimidation, and psychic coercion.'),
    ('FORTITUDE',       'Enduring physical hardship — resisting pain, withstanding poisons and toxins, and pushing through exhaustion.'),
    ('INTUITION',       'Reading people and situations instinctively — sensing deception, noticing incongruous behaviour, and gauging the mood of a crowd.'),
    ('LINGUISTICS',     'Reading, writing, and speaking in languages beyond Low Gothic — ciphers, High Gothic, and forbidden tongues.'),
    ('LOGIC',           'Analytical reasoning and applying knowledge — evaluating goods, investigating crime scenes, and solving abstract problems.'),
    ('LORE',            'Factual knowledge across academic disciplines — history, theology, planetary affairs, and forbidden secrets.'),
    ('MEDICAE',         'Medical knowledge and practice — first aid, treating injuries and disease, and understanding anatomy.'),
    ('MELEE',           'Hand-to-hand combat — brawling with fists and knuckles, one-handed weapons such as swords and axes, and two-handed weapons.'),
    ('NAVIGATION',      'Finding your way — across land and sea, through the void between stars, or tracing paths through the warp.'),
    ('PILOTING',        'Operating vehicles — civilian transports, aircraft, military ground vehicles, and voidships.'),
    ('PRESENCE',        'Social coercion and command — interrogating prisoners, intimidating subjects, and inspiring allies to act.'),
    ('PSYCHIC MASTERY', 'Controlling and directing psychic powers across the disciplines of Biomancy, Divination, Pyromancy, Telekinesis, and Telepathy.'),
    ('RANGED',          'Combat with projectile and energy weapons — pistols, long guns, heavy ordnance, and thrown weapons.'),
    ('RAPPORT',         'Friendly social interaction — charm, deception, haggling, and making friends in useful places.'),
    ('REFLEXES',        'Reactive agility — dodging attacks, maintaining balance under difficult conditions, and acrobatic movement.'),
    ('STEALTH',         'Moving unseen and unheard — hiding from observers, moving silently, and concealing objects from searchers.'),
    ('TECH',            'Knowledge of machines and technology — engineering devices, operating security systems, and maintaining augmetics.')
) AS d(name, description)
WHERE skill.name = d.name;
