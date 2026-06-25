import {createContext, useContext, useReducer} from 'react';

const initialState = {
    characteristics: {},
    originId: null,
    _originName: '',
    _originCharBonuses: '',
    originPrimaryCharNames: '',
    originSecondaryCharName: '',
    factionId: null,
    _factionName: '',
    _equipmentPackName: '',
    _factionCharBonuses: '',
    _factionSkillSummary: '',
    _factionInventory: '',
    factionPrimaryCharNames: '',
    factionSecondaryCharName: '',
    factionSkillAdvances: {},
    factionChoices: {},
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
                originPrimaryCharNames: action.payload.originPrimaryCharNames,
                originSecondaryCharName: action.payload.originSecondaryCharName,
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
                factionPrimaryCharNames: action.payload.factionPrimaryCharNames,
                factionSecondaryCharName: action.payload.factionSecondaryCharName,
                factionSkillAdvances: action.payload.factionSkillAdvances,
                factionChoices: action.payload.factionChoices,
                equipmentPackId: action.payload.equipmentPackId,
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
        default:
            return state;
    }
}

const CharacterContext = createContext(null);

export function CharacterProvider({children}) {
    const [ccm, dispatch] = useReducer(reducer, initialState);
    return (
        <CharacterContext.Provider value={{ccm, dispatch}}>
            {children}
        </CharacterContext.Provider>
    );
}

export function useCharacter() {
    return useContext(CharacterContext);
}
