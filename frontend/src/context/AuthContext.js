import {createContext, useContext, useState} from 'react';
import {login as apiLogin, logout as apiLogout} from '../api/api';

const AuthContext = createContext(null);

const STORAGE_KEY = 'im_cc_user';

export function AuthProvider({children}) {
    const [user, setUser] = useState(() => {
        try { return JSON.parse(localStorage.getItem(STORAGE_KEY)); } catch { return null; }
    });

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

    return <AuthContext.Provider value={{user, loading: false, login, logout}}>{children}</AuthContext.Provider>;
}
export const useAuth = () => useContext(AuthContext);