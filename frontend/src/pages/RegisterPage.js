import {useState} from 'react';
import {useNavigate, Link} from 'react-router-dom';
import {register} from '../api/api';
import Topbar from '../components/Topbar';

const fieldBase = {
    flex: 1,
    padding: '14px 16px',
    background: 'var(--field-bg)',
    border: 'none',
    color: 'var(--ink)',
    fontFamily: "'Barlow', sans-serif",
    fontSize: '15px',
    outline: 'none',
    boxSizing: 'border-box',
};

const fieldWrap = {
    display: 'flex',
    alignItems: 'center',
    background: 'var(--field-bg)',
    border: '1px solid var(--border-strong)',
};

const eyeBtn = {
    background: 'none',
    border: 'none',
    cursor: 'pointer',
    padding: '0 14px',
    color: 'var(--muted)',
    fontSize: '16px',
    lineHeight: 1,
    flexShrink: 0,
};

function PasswordField({placeholder, value, onChange}) {
    const [visible, setVisible] = useState(false);
    return (
        <div style={fieldWrap}>
            <input
                type={visible ? 'text' : 'password'}
                required
                placeholder={placeholder}
                value={value}
                onChange={onChange}
                style={fieldBase}
            />
            <button type="button" style={eyeBtn} onClick={() => setVisible(v => !v)}
                    title={visible ? 'Hide' : 'Show'}>
                {visible ? '🙈' : '👁'}
            </button>
        </div>
    );
}

export default function RegisterPage() {
    const navigate = useNavigate();
    const [email, setEmail] = useState('');
    const [displayName, setDisplayName] = useState('');
    const [password, setPassword] = useState('');
    const [password2, setPassword2] = useState('');
    const [error, setError] = useState('');
    const [loading, setLoading] = useState(false);

    const submit = async (e) => {
        e.preventDefault();
        setError('');
        if (password !== password2) {
            setError("Passwords don't match.");
            return;
        }
        setLoading(true);
        try {
            await register(email, password, displayName || email);
            navigate('/login');
        } catch (err) {
            const msg = err?.response?.data?.error;
            setError(msg || 'Registration failed.');
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
                            Register
                        </div>
                        <div style={{height: '1px', background: 'var(--border)', marginTop: '18px'}}/>
                    </div>

                    <form onSubmit={submit} style={{display: 'flex', flexDirection: 'column', gap: '14px'}}>
                        <input
                            type="email" required placeholder="Email"
                            value={email} onChange={e => setEmail(e.target.value)}
                            style={{
                                width: '100%', padding: '14px 16px',
                                background: 'var(--field-bg)', border: '1px solid var(--border-strong)',
                                color: 'var(--ink)', fontFamily: "'Barlow', sans-serif",
                                fontSize: '15px', outline: 'none', boxSizing: 'border-box',
                            }}
                        />
                        <input
                            type="text" placeholder="Display name (optional)"
                            value={displayName} onChange={e => setDisplayName(e.target.value)}
                            style={{
                                width: '100%', padding: '14px 16px',
                                background: 'var(--field-bg)', border: '1px solid var(--border-strong)',
                                color: 'var(--ink)', fontFamily: "'Barlow', sans-serif",
                                fontSize: '15px', outline: 'none', boxSizing: 'border-box',
                            }}
                        />
                        <PasswordField
                            placeholder="Password"
                            value={password}
                            onChange={e => setPassword(e.target.value)}
                        />
                        <PasswordField
                            placeholder="Repeat password"
                            value={password2}
                            onChange={e => setPassword2(e.target.value)}
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
                            {loading ? 'Creating…' : 'Create account'}
                        </button>

                        <div style={{
                            textAlign: 'center', fontSize: '13px',
                            color: 'var(--muted)', marginTop: '8px',
                        }}>
                            Already have an account?{' '}
                            <Link to="/login" style={{color: 'var(--ink)', textDecoration: 'underline'}}>
                                Sign in
                            </Link>
                        </div>
                    </form>
                </div>
            </main>
        </>
    );
}
