import {useEffect, useState} from 'react';
import {getAuthProviders} from '../api/api';

const DISCORD_LOGIN_URL = `${(process.env.REACT_APP_API_URL || 'http://localhost:8081/api').replace(/\/api$/, '')}/oauth2/authorization/discord`;

// Renders nothing unless the backend reports that Discord login is configured.
export default function DiscordLoginButton() {
    const [enabled, setEnabled] = useState(false);

    useEffect(() => {
        let active = true;
        getAuthProviders()
            .then(providers => { if (active) setEnabled(providers.discord === true); })
            .catch(() => {});
        return () => { active = false; };
    }, []);

    if (!enabled) return null;

    return (
        <>
            <div style={{
                display: 'flex', alignItems: 'center', gap: '12px', margin: '4px 0',
            }}>
                <div style={{flex: 1, height: '1px', background: 'var(--border)'}}/>
                <span style={{
                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                    color: 'var(--muted)', letterSpacing: '1px',
                }}>or</span>
                <div style={{flex: 1, height: '1px', background: 'var(--border)'}}/>
            </div>

            <a href={DISCORD_LOGIN_URL} style={{
                display: 'flex', alignItems: 'center', justifyContent: 'center', gap: '10px',
                padding: '14px 28px', textDecoration: 'none',
                fontFamily: "'Barlow', sans-serif", fontSize: '12px', fontWeight: 600,
                letterSpacing: '3px', textTransform: 'uppercase',
                background: '#5865F2', color: '#fff',
                border: '1px solid #4752c4',
            }}>
                <svg width="18" height="14" viewBox="0 0 71 55" fill="white" xmlns="http://www.w3.org/2000/svg">
                    <path d="M60.1 4.9A58.5 58.5 0 0 0 45.6.7a.2.2 0 0 0-.2.1 40.7 40.7 0 0 0-1.8 3.7 54 54 0 0 0-16.2 0A37.5 37.5 0 0 0 25.6.8a.2.2 0 0 0-.2-.1A58.4 58.4 0 0 0 10.9 4.9a.2.2 0 0 0-.1.1C1.6 18.1-.9 31 .3 43.7a.2.2 0 0 0 .1.2 58.8 58.8 0 0 0 17.7 8.9.2.2 0 0 0 .3-.1 42 42 0 0 0 3.6-5.9.2.2 0 0 0-.1-.3 38.7 38.7 0 0 1-5.5-2.6.2.2 0 0 1 0-.4l1.1-.9a.2.2 0 0 1 .2 0c11.6 5.3 24.1 5.3 35.6 0a.2.2 0 0 1 .2 0l1.1.9a.2.2 0 0 1 0 .4 36 36 0 0 1-5.5 2.6.2.2 0 0 0-.1.3 47 47 0 0 0 3.6 5.9.2.2 0 0 0 .3.1 58.6 58.6 0 0 0 17.8-8.9.2.2 0 0 0 .1-.2C72.9 29.4 69.4 16.6 60.2 5a.2.2 0 0 0-.1-.1ZM23.7 36.2c-3.5 0-6.4-3.2-6.4-7.2s2.8-7.2 6.4-7.2c3.6 0 6.5 3.3 6.4 7.2 0 4-2.8 7.2-6.4 7.2Zm23.6 0c-3.5 0-6.4-3.2-6.4-7.2s2.8-7.2 6.4-7.2c3.6 0 6.5 3.3 6.4 7.2 0 4-2.8 7.2-6.4 7.2Z"/>
                </svg>
                Continue with Discord
            </a>
        </>
    );
}
