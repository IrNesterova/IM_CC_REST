// Characteristic bonuses granted by the chosen origin, faction and AM grade, read from the wizard state.
// The wizard stores characteristics WITH these bonuses applied; the characteristics page edits the
// base values, so it removes the bonuses on load and puts them back on save.

const names = (list) => (list || '').split(',').map(n => n.trim()).filter(Boolean);

export function characteristicBonuses(ccm) {
    const bonuses = {};
    const add = (name, amount) => {
        if (name && amount) bonuses[name] = (bonuses[name] || 0) + amount;
    };
    names(ccm.originPrimaryCharNames).forEach(n => add(n, 5));
    add(ccm.originSecondaryCharName, 5);
    names(ccm.factionPrimaryCharNames).forEach(n => add(n, 5));
    add(ccm.factionSecondaryCharName, 5);
    add(ccm.factionGradeFixedCharName, Number(ccm.factionGradeFixedCharAmount) || 0);
    add(ccm.factionGradeCharName, 5);
    return bonuses;
}

function shift(characteristics, bonuses, sign) {
    return Object.fromEntries(Object.entries(characteristics || {}).map(([name, value]) => {
        const n = parseInt(value, 10);
        return [name, Number.isNaN(n) ? value : String(n + sign * (bonuses[name] || 0))];
    }));
}

export const withoutBonuses = (characteristics, ccm) => shift(characteristics, characteristicBonuses(ccm), -1);
export const withBonuses = (characteristics, ccm) => shift(characteristics, characteristicBonuses(ccm), +1);
