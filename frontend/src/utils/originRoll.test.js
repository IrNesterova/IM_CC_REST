import {findRolledOrigin, formatD100, originNameForRoll} from './originRoll';

describe('originNameForRoll', () => {
    it('follows the rulebook table, including the wide Hive World band', () => {
        expect(originNameForRoll(1)).toBe('AGRI WORLD');
        expect(originNameForRoll(10)).toBe('AGRI WORLD');
        expect(originNameForRoll(11)).toBe('FERAL WORLD');
        expect(originNameForRoll(25)).toBe('FEUDAL WORLD');
        expect(originNameForRoll(40)).toBe('FORGE WORLD');
        expect(originNameForRoll(41)).toBe('HIVE WORLD');
        expect(originNameForRoll(70)).toBe('HIVE WORLD');
        expect(originNameForRoll(71)).toBe('SCHOLA PROGENIUM');
        expect(originNameForRoll(90)).toBe('SHRINE WORLD');
        expect(originNameForRoll(91)).toBe('VOIDBORN');
        expect(originNameForRoll(100)).toBe('VOIDBORN');
    });

    it('covers every roll from 1 to 100', () => {
        for (let roll = 1; roll <= 100; roll++) expect(originNameForRoll(roll)).not.toBeNull();
    });
});

describe('findRolledOrigin', () => {
    const origins = [
        {id: 5, name: 'HIVE WORLD', sourceBook: 'IM'},
        {id: 9, name: 'Hive World', sourceBook: 'IN'},
        {id: 1, name: 'Agri World', sourceBook: null},
    ];

    it('matches core origins by name regardless of case', () => {
        expect(findRolledOrigin(origins, 50).id).toBe(5);
        expect(findRolledOrigin(origins, 3).id).toBe(1);
    });

    it('returns null when the rolled origin is not available', () => {
        expect(findRolledOrigin(origins, 95)).toBeNull();
    });
});

it('formats 100 as 00', () => {
    expect(formatD100(100)).toBe('00');
    expect(formatD100(7)).toBe('07');
});
