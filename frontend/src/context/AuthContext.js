import {createContext, useContext, useEffect, useRef, useState} from 'react';
import {getMe, login as apiLogin, logout as apiLogout} from '../api/api';

const AuthContext = createContext(null);

const STORAGE_KEY = 'im_cc_user';

export function AuthProvider({children}) {
    const [user, setUser] = useState(() => {
        try { return JSON.parse(localStorage.getItem(STORAGE_KEY)); } catch { return null; }
    });
    const [loading, setLoading] = useState(() => {
        const params = new URLSearchParams(window.location.search);
        return params.get('auth') === 'discord';
    });
    const refreshedRef = useRef(false);

    // Silently refresh user data on mount so cached sessions pick up new fields (e.g. id).
    useEffect(() => {
        if (refreshedRef.current) return;
        refreshedRef.current = true;
        getMe()
            .then(u => { setUser(u); localStorage.setItem(STORAGE_KEY, JSON.stringify(u)); })
            .catch(err => {
                // The session behind the cached user has expired (or the server restarted): sign out locally.
                if (err?.response?.status === 401) {
                    setUser(null);
                    localStorage.removeItem(STORAGE_KEY);
                }
            });
    }, []);

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
        const result = await apiLogin(email, password);
        // The login response only has the email; load the full profile (id, display name) so pages
        // that compare user.id, like the GM controls in a room, work without a reload.
        const u = await getMe().catch(() => result);
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