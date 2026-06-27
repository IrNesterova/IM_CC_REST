import axios from 'axios';

const BASE = process.env.REACT_APP_API_URL || (process.env.NODE_ENV === 'production' ? '/api' : 'http://localhost:8081/api');

const api = axios.create({baseURL: BASE, withCredentials: true, xsrfCookieName: 'XSRF-TOKEN', xsrfHeaderName:'X-XSRF-TOKEN',});



export const register = (email, password, displayName) =>
    api.post('/auth/register', {email, password, displayName}).then(r => r.data);
export const login = (email, password) =>
    api.post('/auth/login', {email, password}).then(r => r.data);
export const logout = () => api.post('/auth/logout');
export const getMe = () => api.get('/me').then(r => r.data);
export const getMyCharacters = () => api.get('/me/characters').then(r => r.data);
export const saveWebhookUrl = (webhookUrl) => api.put('/me/webhook', {webhookUrl});
export const deleteCharacter = (code) => api.delete(`/character/${code}`);


const _cache = {};
const cached = (key, fn) => {
    if (_cache[key]) return Promise.resolve(_cache[key]);
    return fn().then(data => { _cache[key] = data; return data; });
};

export const getCharacteristics = () => api.get('/characteristics').then(r => r.data);
export const getOrigins = () => api.get('/origins').then(r => r.data);
export const getFactions = () => api.get('/factions').then(r => r.data);
export const getRoles = () => api.get('/roles').then(r => r.data);
export const getEquipmentPacks = () => api.get('/equipment-packs').then(r => r.data);
export const getAugmetics = () => cached('augmetics', () => api.get('/augmetics').then(r => r.data));
export const getPsychicDisciplines = () => api.get('/psychic-disciplines').then(r => r.data);


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

export const uploadCharacterImage = (code, file) => {
    const form = new FormData();
    form.append('file', file);
    return api.post(`/character/${code}/image`, form).then(r => r.data);
};

export const characterImageUrl = (code) =>
    `${BASE}/character/${code}/image`;

export const getInjuries = () =>
    api.get('/injuries').then(r => r.data);

export const lookupCriticalWound = (location, roll) =>
    api.get('/critical-wounds', {params: {location, roll}}).then(r => r.data);

export const getConditions = () =>
    api.get('/conditions').then(r => r.data);

export const getSubtleMutationsTable = () =>
    cached('subtle-mutations', () => api.get('/mutations/subtle').then(r => r.data));

