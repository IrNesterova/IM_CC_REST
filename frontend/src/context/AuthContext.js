import {createContext, useContext, useEffect, useState} from 'react';
import {getMe, login as apiLogin, logout as apiLogout} from '../api/api';

const AuthContext = createContext(null);

export function AuthProvider({children}) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);

    // ← ключевой момент: кука переживает перезагрузку страницы, а React-стейт — нет.
    // Поэтому при монтировании спрашиваем бэк «кто я», чтобы восстановить состояние.
    useEffect(() => {
        getMe().then(setUser).catch(() => setUser(null)).finally(() => setLoading(false));
    }, []);

    const login = async (email, password) => setUser(await apiLogin(email, password));
    const logout = async () => { await apiLogout(); setUser(null); };

    return <AuthContext.Provider value={{user, loading, login, logout}}>{children}</AuthContext.Provider>;
}
export const useAuth = () => useContext(AuthContext);