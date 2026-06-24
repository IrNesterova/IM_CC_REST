import {useState} from 'react';
import {useNavigate, Link} from 'react-router-dom';
import {useAuth} from '../context/AuthContext';
import Topbar from '../components/Topbar';

const field = {
    width: '100%',
    padding: '14px 16px',
    background: 'var(--field-bg)',
    border: '1px solid var(--border-strong)',
    color: 'var(--ink)',
    fontFamily: "'Barlow', sans-serif",
    fontSize: '15px',
    outline: 'none',
    boxSizing: 'border-box',
};

export default function LoginPage() {
    const {login} = useAuth();
    const navigate = useNavigate();
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const submit = async (e) => {
        e.preventDefault();
        setError('');
        setLoading(true);
        try {
            await login(email, password);
            navigate('/cabinet');
        } catch {
            setError('Incorrect email or password.');
        } finally {
            setLoading(false);
        }
    };

    return (
        <>
            <Topbar/>
            <main style={{
                flex: 1, background: 'var(--bg)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                padding: '60px 24px',
            }}>
                <div style={{
                    background: 'var(--panel)', border: '1px solid var(--border)',
                    padding: '52px 56px', boxShadow: '0 4px 28px var(--shadow)',
                    maxWidth: '460px', width: '100%', position: 'relative',
                }}>
                    <div style={{
                        position: 'absolute', top: 0, left: 0, width: '100%', height: '3px',
                        background: 'linear-gradient(90deg, transparent, var(--red), transparent)',
                    }}/>

                    <div style={{marginBottom: '36px'}}>
                        <div style={{height: '1px', background: 'var(--red)', marginBottom: '18px'}}/>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif", fontSize: '32px',
                            textTransform: 'uppercase', color: 'var(--red)', letterSpacing: '3px',
                        }}>
                            Sign In
                        </div>
                        <div style={{height: '1px', background: 'var(--border)', marginTop: '18px'}}/>
                    </div>

                    <form onSubmit={submit} style={{display: 'flex', flexDirection: 'column', gap: '14px'}}>
                        <input
                            type="email" required placeholder="Email"
                            value={email} onChange={e => setEmail(e.target.value)}
                            style={field}
                        />
                        <input
                            type="password" required placeholder="Пароль"
                            value={password} onChange={e => setPassword(e.target.value)}
                            style={field}
                        />

                        {error && (
                            <div style={{color: 'var(--red)', fontSize: '14px', fontStyle: 'italic'}}>
                                {error}
                            </div>
                        )}

                        <button type="submit" disabled={loading} style={{
                            marginTop: '8px', padding: '16px 28px',
                            fontFamily: "'Barlow', sans-serif", fontSize: '12px', fontWeight: 600,
                            letterSpacing: '3px', textTransform: 'uppercase',
                            background: 'var(--red)', color: 'var(--on-accent)',
                            border: '1px solid var(--red)', cursor: loading ? 'not-allowed' : 'pointer',
                            opacity: loading ? 0.7 : 1,
                        }}>
                            {loading ? 'Signing in…' : 'Sign In'}
                        </button>

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

                        <a href="http://localhost:8081/oauth2/authorization/discord" style={{
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

                        <div style={{
                            textAlign: 'center', fontSize: '13px',
                            color: 'var(--muted)', marginTop: '8px',
                        }}>
                            Don't have an account?{' '}
                            <Link to="/register" style={{color: 'var(--ink)', textDecoration: 'underline'}}>
                                Register
                            </Link>
                        </div>
                    </form>
                </div>
            </main>
        </>
    );
}
