// Where a character's sheet edits (XP, wounds, talents, notes, ...) live in the browser, and how a
// saved character is opened. Each saved character has its own key; an unsaved character uses one
// draft key, which is cleared when a new character is started.

const DRAFT_KEY = 'im_cc_sheet_draft';

export const sheetKey = (saveCode) => (saveCode ? `im_cc_sheet_${saveCode}` : DRAFT_KEY);

export function readSheet(key) {
    try {
        const stored = localStorage.getItem(key);
        return stored ? JSON.parse(stored) : null;
    } catch {
        return null;
    }
}

export function writeSheet(key, sheet) {
    try {
        localStorage.setItem(key, JSON.stringify(sheet));
    } catch {
        // Storage full or blocked: the sheet still lives in memory and in the next server save.
    }
}

export function clearDraftSheet() {
    try {
        localStorage.removeItem(DRAFT_KEY);
    } catch {
        // ignore
    }
}

// Before per-character keys, sheets were stored under origin + faction + role, so characters with
// the same three choices shared one sheet. Read only as a fallback, to keep players' existing edits.
export function readLegacySheet(ccm) {
    return readSheet(`im_cc_summary_${ccm.originId ?? 'x'}_${ccm.factionId ?? 'x'}_${ccm.roleId ?? 'x'}`);
}

// A save is {ccm, edits, sheet}; saves made before sheets were stored have no sheet.
export function parseSavedCharacter(raw) {
    const parsed = typeof raw === 'string' ? JSON.parse(raw) : raw;
    return {ccm: parsed?.ccm || parsed, sheet: parsed?.sheet || null};
}

// Opens a saved character for editing: the server copy of its sheet wins over anything in the browser.
export function restoreSavedCharacter(dispatch, code, raw) {
    const {ccm, sheet} = parseSavedCharacter(raw);
    if (sheet) writeSheet(sheetKey(code), sheet);
    dispatch({type: 'RESTORE', payload: {...ccm, _saveCode: code, _loadedAt: Date.now()}});
}

export function startNewCharacter(dispatch) {
    clearDraftSheet();
    dispatch({type: 'RESET'});
}

// What goes to the server: the wizard state without the browser-only bookkeeping fields.
export function savePayload(ccm, characterName, sheet) {
    const {_saveCode, _loadedAt, ...wizard} = ccm;
    return JSON.stringify({ccm: wizard, edits: {characterName}, sheet});
}
