import {characteristicBonuses, withBonuses, withoutBonuses} from './characteristicBonuses';

const ccm = {
    originPrimaryCharNames: 'STR',
    originSecondaryCharName: 'TGH',
    factionPrimaryCharNames: 'TGH',
    factionSecondaryCharName: 'WS',
    factionGradeFixedCharName: '',
    factionGradeFixedCharAmount: 0,
    factionGradeCharName: '',
};

describe('characteristicBonuses', () => {
    it('adds up origin and faction bonuses, including two on the same characteristic', () => {
        expect(characteristicBonuses(ccm)).toEqual({STR: 5, TGH: 10, WS: 5});
    });

    it('includes AM grade bonuses and comma-separated primary lists', () => {
        expect(characteristicBonuses({
            factionPrimaryCharNames: 'INT, TGH',
            factionGradeFixedCharName: 'INT',
            factionGradeFixedCharAmount: 10,
            factionGradeCharName: 'AG',
        })).toEqual({INT: 15, TGH: 5, AG: 5});
    });

    it('is empty before origin and faction are chosen', () => {
        expect(characteristicBonuses({})).toEqual({});
    });
});

describe('withoutBonuses / withBonuses', () => {
    const stored = {WS: '35', BS: '30', STR: '40', TGH: '45'};

    it('recovers the base values the player set', () => {
        expect(withoutBonuses(stored, ccm)).toEqual({WS: '30', BS: '30', STR: '35', TGH: '35'});
    });

    it('round-trips, so revisiting the page never adds a bonus twice', () => {
        let values = stored;
        for (let visit = 0; visit < 3; visit++) values = withBonuses(withoutBonuses(values, ccm), ccm);
        expect(values).toEqual(stored);
    });

    it('applies bonuses to edited base values', () => {
        const base = {...withoutBonuses(stored, ccm), BS: '33'};
        expect(withBonuses(base, ccm)).toEqual({WS: '35', BS: '33', STR: '40', TGH: '45'});
    });
});
