import axios from 'axios';

const BASE = process.env.REACT_APP_API_URL || (process.env.NODE_ENV === 'production' ? '/api' : 'http://localhost:8081/api');
export const WS_URL = process.env.REACT_APP_WS_URL || (process.env.NODE_ENV === 'production' ? '' : 'http://localhost:8081');

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

export const createRoom = (name) =>
    api.post('/rooms', {name}).then(r => r.data);
export const joinRoom = (code) =>
    api.post('/rooms/join', {code}).then(r => r.data);
export const getRoster = (roomId) =>
    api.get(`/rooms/${roomId}/roster`).then(r => r.data);
export const leaveRoom = (roomId) =>
    api.post(`/rooms/${roomId}/leave`);
export const getMyRooms = () =>
    api.get('/rooms').then(r => r.data);
export const getRoom = (roomId) =>
    api.get(`/rooms/${roomId}`).then(r => r.data);
export const changeRoomStatus = (roomId, status) =>
    api.patch(`/rooms/${roomId}/status`, {status}).then(r => r.data);
export const selectCharacter = (roomId, characterCode) =>
    api.post(`/rooms/${roomId}/character`, {characterCode});
export const updateRoomSourceBooks = (roomId, sourceBooks) =>
    api.patch(`/rooms/${roomId}/source-books`, {sourceBooks}).then(r => r.data);
export const updateRoomWebhook = (roomId, webhookUrl) =>
    api.patch(`/rooms/${roomId}/webhook`, {webhookUrl}).then(r => r.data);

export const getAllTalents = () =>
    cached('all-talents', () => api.get('/talents').then(r => r.data));

export const getPatronReference = () =>
    api.get('/patron/reference').then(r => r.data);

export const savePatron = (data, code = null) => {
    const url = code ? `/patron/save?code=${code}` : '/patron/save';
    return api.post(url, data, {headers: {'Content-Type': 'application/json'}}).then(r => r.data);
};

export const loadPatron = (code) =>
    api.get(`/patron/load/${code}`).then(r => r.data);

export const getPatronPreview = (code) =>
    api.get(`/patron/preview/${code}`).then(r => r.data);

export const setRoomPatron = (roomId, patronCode) =>
    api.patch(`/rooms/${roomId}/patron`, {patronCode}).then(r => r.data);

export const logFrontendError = (payload) => {
    // Fire-and-forget: never throws, never blocks the caller
    api.post('/error-log', payload).catch(() => {});
};

