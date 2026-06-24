import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {useAuth} from '../context/AuthContext';

export default function Topbar() {
    const [theme, setTheme] = useState(() =>
        localStorage.getItem('theme') || 'light'
    );
    const {user} = useAuth();
    const navigate = useNavigate();

    useEffect(() => {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
    }, [theme]);

    return (
        <div className="topbar">
            <span className="topbar-game" onClick={() => navigate('/')}
                  style={{cursor: 'pointer'}}>Warhammer 40,000 Roleplay</span>
            <div className="topbar-divider"/>
            <span className="topbar-sub" onClick={() => navigate('/')}
                  style={{cursor: 'pointer'}}>Character Creator</span>

            <div style={{marginLeft: 'auto', display: 'flex', alignItems: 'center', gap: '10px'}}>
                {user && (
                    <button onClick={() => navigate('/cabinet')} style={{
                        background: 'transparent',
                        border: '1px solid var(--border)',
                        color: 'var(--muted)',
                        fontFamily: "'Barlow', sans-serif",
                        fontSize: '10px',
                        letterSpacing: '2px',
                        textTransform: 'uppercase',
                        padding: '5px 12px',
                        cursor: 'pointer',
                    }}>
                        {user.displayName || user.email}
                    </button>
                )}
                <button
                    onClick={() => setTheme(t => t === 'light' ? 'dark' : 'light')}
                    style={{
                        background: 'transparent',
                        border: '1px solid var(--border-strong)',
                        color: 'var(--ink)',
                        fontFamily: "'Barlow', sans-serif",
                        fontSize: '10px',
                        letterSpacing: '2px',
                        textTransform: 'uppercase',
                        padding: '5px 12px',
                        cursor: 'pointer',
                    }}
                >
                    {theme === 'light' ? 'Dark' : 'Light'}
                </button>
            </div>
        </div>
    );
}
