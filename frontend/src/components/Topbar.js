import {useEffect, useState} from 'react';

export default function Topbar() {
    const [theme, setTheme] = useState(() =>
        localStorage.getItem('theme') || 'light'
    );

    useEffect(() => {
        document.documentElement.setAttribute('data-theme', theme);
        localStorage.setItem('theme', theme);
    }, [theme]);

    return (
        <div className="topbar">
            <span className="topbar-game">Warhammer 40,000 Roleplay</span>
            <div className="topbar-divider"/>
            <span className="topbar-sub">Character Creator</span>
            <button
                onClick={() => setTheme(t => t === 'light' ? 'dark' : 'light')}
                style={{
                    marginLeft: 'auto',
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
    );
}
