import {createContext, useContext, useEffect, useState} from 'react';
import {getMe, login as apiLogin, logout as apiLogout} from '../api/api';

const AuthContext = createContext(null);

const STORAGE_KEY = 'im_cc_user';

export function AuthProvider({children}) {
    const [user, setUser] = useState(() => {
        try { return JSON.parse(localStorage.getItem(STORAGE_KEY)); } catch { return null; }
    });
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        const params = new URLSearchParams(window.location.search);
        if (params.get('auth') === 'discord') {
            setLoading(true);
            getMe()
                .then(u => { setUser(u); localStorage.setItem(STORAGE_KEY, JSON.stringify(u)); })
                .catch(() => {})
                .finally(() => {
                    setLoading(false);
                    params.delete('auth');
                    const newUrl = window.location.pathname + (params.toString() ? '?' + params : '');
                    window.history.replaceState({}, '', newUrl);
                });
        }
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const login = async (email, password) => {
        const u = await apiLogin(email, password);
        setUser(u);
        localStorage.setItem(STORAGE_KEY, JSON.stringify(u));
    };
    const logout = async () => {
        await apiLogout();
        setUser(null);
        localStorage.removeItem(STORAGE_KEY);
    };

    return <AuthContext.Provider value={{user, loading, login, logout}}>{children}</AuthContext.Provider>;
}
export const useAuth = () => useContext(AuthContext);