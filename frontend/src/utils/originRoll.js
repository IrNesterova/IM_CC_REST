// Random Origin table from the core rulebook (p. 51). Rolling instead of choosing grants bonus XP.
export const ORIGIN_ROLL_XP = 25;

const ORIGIN_TABLE = [
    [1, 10, 'AGRI WORLD'],
    [11, 20, 'FERAL WORLD'],
    [21, 30, 'FEUDAL WORLD'],
    [31, 40, 'FORGE WORLD'],
    [41, 70, 'HIVE WORLD'],
    [71, 80, 'SCHOLA PROGENIUM'],
    [81, 90, 'SHRINE WORLD'],
    [91, 100, 'VOIDBORN'],
];

export const rollD100 = () => Math.floor(Math.random() * 100) + 1;

// 100 is read as "00" on percentile dice.
export const formatD100 = (roll) => (roll === 100 ? '00' : String(roll).padStart(2, '0'));

export function originNameForRoll(roll) {
    const row = ORIGIN_TABLE.find(([min, max]) => roll >= min && roll <= max);
    return row ? row[2] : null;
}

// The core origin for a roll, matched by name. Supplement origins are not on this table.
export function findRolledOrigin(origins, roll) {
    const name = originNameForRoll(roll);
    return (origins || []).find(o =>
        (!o.sourceBook || o.sourceBook === 'IM') && (o.name || '').toUpperCase() === name) || null;
}
