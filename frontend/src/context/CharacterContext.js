import {createContext, useContext, useEffect, useReducer} from 'react';

const STORAGE_KEY = 'im_cc_ccm';

const initialState = {
    characteristics: {},
    originId: null,
    _originName: '',
    _originCharBonuses: '',
    _originSkillSummary: '',
    _originSpecSummary: '',
    _originTalents: '',
    _originItems: '',
    originPrimaryCharNames: '',
    originSecondaryCharName: '',
    originSkillChoice: '',
    originSpecChoice: '',
    originSkillAdvances: {},
    originSpecAdvances: {},
    originSpecTopics: {},
    originAugmeticId: null,
    originAugmeticName: '',
    originAugmeticTrait: '',
    subtleMutationPositiveId: null,
    subtleMutationNegativeId: null,
    _subtleMutationSummary: '',
    factionId: null,
    _factionName: '',
    _equipmentPackName: '',
    _factionCharBonuses: '',
    _factionSkillSummary: '',
    _factionInventory: '',
    _factionGradeName: '',
    factionPrimaryCharNames: '',
    factionSecondaryCharName: '',
    factionSkillAdvances: {},
    factionChoices: {},
    factionGradeId: null,
    factionGradeCharId: null,
    factionGradeFixedCharName: '',
    factionGradeFixedCharAmount: 0,
    factionGradeCharName: '',
    factionGradeSkillAdvances: {},
    factionGradeChoices: {},
    equipmentPackId: null,
    equipmentStepDone: false,
    roleId: null,
    _roleName: '',
    _roleSkillSummary: '',
    _roleSpecSummary: '',
    _roleEquipment: '',
    roleChoices: {},
    roleSkillAdvances: {},
    roleSpecAdvances: {},
    itemVariantChoices: {},
    characterName: '',
    age: '',
    eyeType: '',
    hairColor: '',
    hairStyle: '',
    height: '',
    distinguishingFeatures: '',
    divination: '',
    shortTermGoal: '',
    longTermGoal: '',
    connections: '',
};

function reducer(state, action) {
    switch (action.type) {
        case 'SET_CHARACTERISTICS':
            return {
                ...state,
                characteristics: action.payload,
                originPrimaryCharNames: '',
                originSecondaryCharName: '',
                factionPrimaryCharNames: '',
                factionSecondaryCharName: '',
            };
        case 'SET_ORIGIN':
            return {
                ...state,
                originId: action.payload.originId,
                _originName: action.payload._originName || '',
                _originCharBonuses: action.payload._originCharBonuses || '',
                _originSkillSummary: action.payload._originSkillSummary || '',
                _originSpecSummary: action.payload._originSpecSummary || '',
                _originTalents: action.payload._originTalents || '',
                _originItems: action.payload._originItems || '',
                originPrimaryCharNames: action.payload.originPrimaryCharNames,
                originSecondaryCharName: action.payload.originSecondaryCharName,
                originSkillChoice: action.payload.originSkillChoice || '',
                originSpecChoice: action.payload.originSpecChoice || '',
                originSkillAdvances: action.payload.originSkillAdvances || {},
                originSpecAdvances: action.payload.originSpecAdvances || {},
                originSpecTopics: action.payload.originSpecTopics || {},
                originAugmeticId: action.payload.originAugmeticId || null,
                originAugmeticName: action.payload.originAugmeticName || '',
                originAugmeticTrait: action.payload.originAugmeticTrait || '',
                subtleMutationPositiveId: action.payload.subtleMutationPositiveId || null,
                subtleMutationNegativeId: action.payload.subtleMutationNegativeId || null,
                _subtleMutationSummary: action.payload._subtleMutationSummary || '',
                characteristics: action.payload.characteristics,
            };
        case 'SET_FACTION':
            return {
                ...state,
                factionId: action.payload.factionId,
                _factionName: action.payload._factionName || '',
                _equipmentPackName: action.payload._equipmentPackName || '',
                _factionCharBonuses: action.payload._factionCharBonuses || '',
                _factionSkillSummary: action.payload._factionSkillSummary || '',
                _factionInventory: action.payload._factionInventory || '',
                _factionGradeName: action.payload._factionGradeName || '',
                factionPrimaryCharNames: action.payload.factionPrimaryCharNames || '',
                factionSecondaryCharName: action.payload.factionSecondaryCharName || '',
                factionSkillAdvances: action.payload.factionSkillAdvances || {},
                factionChoices: action.payload.factionChoices || {},
                factionGradeId: action.payload.factionGradeId || null,
                factionGradeCharId: action.payload.factionGradeCharId || null,
                factionGradeFixedCharName: action.payload.factionGradeFixedCharName || '',
                factionGradeFixedCharAmount: action.payload.factionGradeFixedCharAmount || 0,
                factionGradeCharName: action.payload.factionGradeCharName || '',
                factionGradeSkillAdvances: action.payload.factionGradeSkillAdvances || {},
                factionGradeChoices: action.payload.factionGradeChoices || {},
                equipmentPackId: action.payload.equipmentPackId || null,
                characteristics: action.payload.characteristics,
            };
        case 'SET_ROLE':
            return {
                ...state,
                roleId: action.payload.roleId,
                _roleName: action.payload._roleName || '',
                _roleSkillSummary: action.payload._roleSkillSummary || '',
                _roleSpecSummary: action.payload._roleSpecSummary || '',
                _roleEquipment: action.payload._roleEquipment || '',
                roleChoices: action.payload.roleChoices,
                roleSkillAdvances: action.payload.roleSkillAdvances,
                roleSpecAdvances: action.payload.roleSpecAdvances,
                itemVariantChoices: action.payload.itemVariantChoices || {},
            };
        case 'SET_DETAILS':
            return {...state, ...action.payload};
        case 'RESTORE':
            return {...initialState, ...action.payload};
        case 'RESET':
            return initialState;
        default:
            return state;
    }
}

const CharacterContext = createContext(null);

function loadFromStorage() {
    try {
        const saved = localStorage.getItem(STORAGE_KEY);
        if (saved) return {...initialState, ...JSON.parse(saved)};
    } catch {}
    return initialState;
}

export function CharacterProvider({children}) {
    const [ccm, dispatch] = useReducer(reducer, undefined, loadFromStorage);

    useEffect(() => {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(ccm));
    }, [ccm]);

    return (
        <CharacterContext.Provider value={{ccm, dispatch}}>
            {children}
        </CharacterContext.Provider>
    );
}

export function useCharacter() {
    return useContext(CharacterContext);
}
