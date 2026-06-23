import axios from 'axios';

const BASE = 'http://localhost:8081/api';

const api = axios.create({baseURL: BASE});

export const getCharacteristics = () => api.get('/characteristics').then(r => r.data);
export const getOrigins = () => api.get('/origins').then(r => r.data);
export const getFactions = () => api.get('/factions').then(r => r.data);
export const getRoles = () => api.get('/roles').then(r => r.data);
export const getEquipmentPacks = () => api.get('/equipment-packs').then(r => r.data);

export const buildSummary = (ccm) =>
    api.post('/summary', ccm).then(r => r.data);

export const saveCharacter = (data, code = null) => {
    const url = code ? `/character/save?code=${code}` : '/character/save';
    return api.post(url, data, {headers: {'Content-Type': 'application/json'}}).then(r => r.data);
};

export const loadCharacter = (code) =>
    api.get(`/character/load/${code}`).then(r => r.data);

export const submitBugReport = (report) =>
    api.post('/bug-report', report);
