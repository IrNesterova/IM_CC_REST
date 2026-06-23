-- Augmetics from Macharian Requisition Guide, pp. 13-14
-- Run AFTER inventory.sql

DO $$
DECLARE
    inv_id BIGINT;
    rec    RECORD;
BEGIN
    FOR rec IN
        SELECT * FROM (VALUES
            ('Aortic Supercharger', 'AUGMETIC', 3000,  'RARE',   0,
             'An Aortic Supercharger is an augmetic reinforcement
to the heart that enhances the bearer’s endurance to
allow feats of stamina beyond what their body would
otherwise be capable of. This augmetic resembles
life-extending organ replacements, but it can have
the opposite effect in the long term. If installed and
overused, the bearer’s circulatory system can suffer
slow degradation through overworking.
Once per session, the bearer of an Aortic Supercharger
may choose to automatically pass a Test to resist
becoming Fatigued.'),
            ('Augmetic Organs',     'AUGMETIC', 10000, 'EXOTIC', 0,
             'Augmetic Organs are commonplace among those with
the power to obtain them — the planetary governor,
seeking to extend their reign to guide their world to
greatness; the rogue trader, who cannot accept that a
final voyage must come; the Astra Militarum general,
whose expertise cannot be allowed to die.Augmetic Organs give their bearer +1 SL on Toughness
Tests, and extend their natural lifespan by 3 + 1d10
decades. ' ||
             'However, any Augmetic Organs only function
properly for around 50 years; they must be replaced
before they expire or threaten the life of the augmented.
Additionally, the average chirurgeon will not have the
capacity to repair or work around these organs; any
Tests they make to heal the augmented character in a
manner related to their Augmetic Organs increases the
Difficulty by one step.'),
            ('Implanted Weapon',    'AUGMETIC', 3000,  'RARE',   0,
             'Few are willing to undertake the total replacement
of a hand, forearm, or entire limb with an implanted
weapon, and as such, it is usually the reserve of
servitors. Those who bear an Implanted Weapon have
accepted, or been forced to accept, a life centred around
battle, with little room for anything else. For all the
restrictions in replacing a limb with a weapon, there is
one marked advantage: the weapon truly becomes an
extension of the wielder’s body. A weapon with an Encumbrance value of up to 3 can
be attached as an Implanted Weapon. In addition,
implanted melee and ranged weapons have the
following unique advantages:' ||
             '* A weapon installed this way loses the Two-handed
Trait, as it is wielded from its implant.
* When you take the Charge Action, you do not have
Disadvantage on Melee and Reflex Tests to defend
yourself in your next turn.
* If you take the Aim Action with an implanted ranged
weapon, gain Advantage on the Aimed Shot.
* If the weapon replaces a limb in a hit location,
that Hit Location has the same Armour value as
the weapon’s Encumbrance value. You cannot have
Armour applied to that location otherwise.
* The weapon’s Encumbrance does not count towards
your total carry value.
* The cost of this Augmetic does not cover the cost of
the weapon itself.'),
            ('Internal Compartment','AUGMETIC', 1500,  'RARE',   0,
             'Small storage compartments nestled within living
flesh, Internal Compartments are ubiquitous among
the Tech-Priests of the Adeptus Mechanicus. They
are also regularly used by covert operatives to conceal
weaponry and by Infractionists to move restricted
goods. Advanced variants may feature shielding or
skin-grafting to hide them and their contents further.
Given the painful process of long-term adjustment
to the rearranging of the bearer’s internal organs
to facilitate installation, it is their use in smuggling
that makes their ubiquity unsurprising — lifelong
discomfort is a small price to pay to avoid the typically
brutal reprisals for breaking the Lex Imperialis.
An Internal Compartment can hold an object with
an Encumbrance value of 0, no bigger than the
Compartment’s body area. A character can install a
maximum number of Internal Compartments equal to
half their Toughness Bonus, rounded down.'),
            ('Simple Prosthesis',   'AUGMETIC_REPLACEMENTS', 200, 'SCARCE', 0,
             'The abundance of Humans serving in industries across
the Macharian Sector means that few precautions are
taken in both the design of machinery and their use,
outside of protecting the machines themselves. Grievous
injuries are not sought to be eliminated, only reduced
to acceptable figures that do not slow production.
Limbs are routinely lost in the manufactorums of forge
worlds, to harvesters and autothreshers on agri worlds,
and in bloody service to the Astra Militarum. The
lowly worker or soldier who survives such an injury
is rarely provided with advanced augmetics, instead
receiving simpler prosthetics, from their supervisors,
from traders, or created by their community.
A character may choose to have a simple prosthetic
limb as part of their starting equipment at no extra
cost. Simple prosthetic limbs function identically
to their standard augmetic counterpart (Imperium
Maledictum, 152–153) but do not provide +1 Armour
or any bonus SL to related Tests.'),
                ('Skinplant',           'AUGMETIC', 500,   'RARE',   0,
             'A common designation for microcrystalline intra
dermal implants, a Skinplant becomes visible through
the skin of its bearer when subjected to a programmed
stimulus, such as touch or light. The capacity of
Skinplants to produce far more elaborate effects than
tattoos makes them popular aesthetic augmetics,
but beyond cosmetic civilian applications, more
specialised Skinplants exist: touch-activated lights
mounted in the hand are used for detailed work in low
light environments — nominally for maintenance, but
unsanctioned installation by Infractionists has earned
this variant the nickname Thief’s Light. Covert agents
of many Imperial military bodies are known to install
wrist-mounted chrono Skinplants, as the precise timing
of operations cannot risk the loss of a worn chrono.
A Skinplant is installed with a trigger (touch, light,
or a specific external control) and a display, which
may be an image, a dim light, or a Chrono (Imperium
Maledictum, page 146).'),
                           ('Toxiphage',           'AUGMETIC', 5000,  'RARE',   0,
             'A Toxiphage is an exceptionally advanced defensive
augmetic, capable of detecting poison in its bearer’s
body and releasing chemicals into the bearer’s
bloodstream to neutralise its effects. Given that the
fates of Highborn planetary dynasties matter little to
the High Lords of Terra, so long as their tithes continue
to be paid, installing a Toxiphage offers those in power a
contingency against the poisons of would-be usurpers.
Toxiphages also see use beyond the halls of paranoid
aristocrats — the atrocious manners of poison-induced
deaths inflicted by Drukhari and Tyranid alike make
these augmetics standard issue for Astra Militarum
officers deployed against xenos forces.
A bearer of this augmetic may automatically pass the
first Test to resist Poisoned once per day. If they are
being poisoned surreptitiously, when the augment
activates, it gives them a silent warning.')
) AS t(name, category, cost, avail, enc, descr)
    LOOP
        SELECT id INTO inv_id FROM inventory WHERE name = rec.name LIMIT 1;

        IF inv_id IS NULL THEN
            INSERT INTO inventory (name, inventory_category, availability, encumbrance, cost, source_book)
            VALUES (rec.name, rec.category, rec.avail, rec.enc, rec.cost, 'MR')
            RETURNING id INTO inv_id;
        ELSE
            UPDATE inventory
            SET inventory_category = rec.category,
                availability       = rec.avail,
                encumbrance        = rec.enc,
                cost               = rec.cost,
                source_book        = 'MR'
            WHERE id = inv_id;
        END IF;

        INSERT INTO generic_item (id, description)
        VALUES (inv_id, rec.descr)
        ON CONFLICT (id) DO UPDATE SET description = EXCLUDED.description;

    END LOOP;
END $$;
