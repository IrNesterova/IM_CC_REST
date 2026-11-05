import {useState} from 'react';
import {useNavigate, Link} from 'react-router-dom';
import {useAuth} from '../context/AuthContext';
import Topbar from '../components/Topbar';
import DiscordLoginButton from '../components/DiscordLoginButton';

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

                        <DiscordLoginButton/>

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
