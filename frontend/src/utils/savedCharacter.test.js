import {
    clearDraftSheet, parseSavedCharacter, readLegacySheet, readSheet, restoreSavedCharacter,
    savePayload, sheetKey, startNewCharacter, writeSheet,
} from './savedCharacter';

beforeEach(() => localStorage.clear());

describe('sheet storage', () => {
    it('keeps each saved character separate, even with the same origin, faction and role', () => {
        writeSheet(sheetKey('AAA111'), {xpTotal: 100});
        writeSheet(sheetKey('BBB222'), {xpTotal: 300});

        expect(readSheet(sheetKey('AAA111'))).toEqual({xpTotal: 100});
        expect(readSheet(sheetKey('BBB222'))).toEqual({xpTotal: 300});
    });

    it('uses one draft key before the first save and clears it for a new character', () => {
        writeSheet(sheetKey(null), {xpTotal: 50});
        const dispatch = jest.fn();

        startNewCharacter(dispatch);

        expect(readSheet(sheetKey(null))).toBeNull();
        expect(dispatch).toHaveBeenCalledWith({type: 'RESET'});
    });

    it('still finds a sheet stored under the old origin/faction/role key', () => {
        localStorage.setItem('im_cc_summary_1_2_3', JSON.stringify({xpTotal: 75}));

        expect(readLegacySheet({originId: 1, factionId: 2, roleId: 3})).toEqual({xpTotal: 75});
    });

    it('treats unreadable storage as empty', () => {
        localStorage.setItem(sheetKey('BAD001'), '{not json');
        expect(readSheet(sheetKey('BAD001'))).toBeNull();
        clearDraftSheet();
    });
});

describe('saved characters', () => {
    it('opens a save with its sheet, remembering the code', () => {
        const dispatch = jest.fn();
        const raw = {ccm: {characterName: 'Vex', factionId: 3}, edits: {}, sheet: {xpTotal: 250}};

        restoreSavedCharacter(dispatch, 'VEX001', raw);

        expect(readSheet(sheetKey('VEX001'))).toEqual({xpTotal: 250});
        const action = dispatch.mock.calls[0][0];
        expect(action.type).toBe('RESTORE');
        expect(action.payload).toMatchObject({characterName: 'Vex', factionId: 3, _saveCode: 'VEX001'});
        expect(action.payload._loadedAt).toEqual(expect.any(Number));
    });

    it('opens saves made before sheets were stored without touching the browser copy', () => {
        writeSheet(sheetKey('OLD001'), {xpTotal: 10});

        restoreSavedCharacter(jest.fn(), 'OLD001', JSON.stringify({ccm: {characterName: 'Old'}}));

        expect(readSheet(sheetKey('OLD001'))).toEqual({xpTotal: 10});
        expect(parseSavedCharacter('{"ccm":{"a":1}}')).toEqual({ccm: {a: 1}, sheet: null});
    });

    it('saves the whole sheet and leaves out browser-only fields', () => {
        const body = JSON.parse(savePayload(
            {characterName: 'Vex', _saveCode: 'VEX001', _loadedAt: 123}, 'Vex the Bold', {xpTotal: 250}));

        expect(body).toEqual({ccm: {characterName: 'Vex'}, edits: {characterName: 'Vex the Bold'}, sheet: {xpTotal: 250}});
    });
});
