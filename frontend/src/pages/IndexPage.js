import {useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {loadCharacter} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';

export default function IndexPage() {
    const [showLoad, setShowLoad] = useState(false);
    const [code, setCode] = useState('');
    const [error, setError] = useState('');
    const navigate = useNavigate();
    const {dispatch} = useCharacter();

    const doLoad = async () => {
        const c = code.trim().toUpperCase();
        if (c.length !== 6) {
            setError('Enter a 6-character code.');
            return;
        }
        try {
            const raw = await loadCharacter(c);
            const parsed = typeof raw === 'string' ? JSON.parse(raw) : raw;
            const ccm = parsed.ccm || parsed;
            dispatch({type: 'RESTORE', payload: ccm});
            navigate('/summary');
        } catch {
            setError('Character not found.');
        }
    };

    return (
        <>
            <Topbar/>
            <main style={{
                flex: 1,
                background: 'var(--bg)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                padding: '60px 24px'
            }}>
                <div className="index-card" style={{
                    background: 'var(--panel)', border: '1px solid var(--border)',
                    padding: '52px 56px', boxShadow: '0 4px 28px var(--shadow)',
                    maxWidth: '540px', width: '100%', position: 'relative',
                }}>
                    <div style={{
                        position: 'absolute',
                        top: 0,
                        left: 0,
                        width: '100%',
                        height: '3px',
                        background: 'linear-gradient(90deg, transparent, var(--red), transparent)'
                    }}/>

                    <div style={{marginBottom: '36px'}}>
                        <div style={{height: '1px', background: 'var(--red)', marginBottom: '18px'}}/>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif",
                            fontSize: '58px',
                            lineHeight: '0.9',
                            textTransform: 'uppercase',
                            color: 'var(--red)',
                            letterSpacing: '-1px'
                        }}>
                            Imperium
                            <span style={{
                                display: 'block',
                                fontSize: '28px',
                                letterSpacing: '7px',
                                color: 'var(--red-mid)',
                                marginTop: '6px'
                            }}>Maledictum</span>
                        </div>
                        <div style={{height: '1px', background: 'var(--border)', marginTop: '18px'}}/>
                    </div>

                    <ul style={{marginBottom: '36px', listStyle: 'none', padding: 0}}>
                        {[
                            'Imperium Maledictum Character Creator',
                            'My first Java project, written with Claude Code',
                            'Spring Boot · PostgreSQL · React',
                            'Bug report button available on every page',
                        ].map(item => (
                            <li key={item} style={{
                                fontSize: '16px',
                                lineHeight: '1.7',
                                color: 'var(--text)',
                                padding: '3px 0',
                                borderBottom: '1px solid var(--border)'
                            }}>
                                <span style={{
                                    color: 'var(--red)',
                                    fontFamily: "'Barlow', sans-serif",
                                    fontSize: '13px'
                                }}>— </span>
                                {item}
                            </li>
                        ))}
                    </ul>

                    <div style={{display: 'flex', flexDirection: 'column', gap: '10px'}}>
                        <a href="/characteristics" style={{
                            display: 'block', width: '100%', padding: '16px 28px',
                            fontFamily: "'Barlow', sans-serif", fontSize: '12px', fontWeight: 600,
                            letterSpacing: '3px', textTransform: 'uppercase', textAlign: 'center',
                            textDecoration: 'none', background: 'var(--red)', color: 'var(--on-accent)',
                            border: '1px solid var(--red)', boxSizing: 'border-box',
                        }}>Create a character</a>

                        <button
                            onClick={() => setShowLoad(v => !v)}
                            style={{
                                display: 'block',
                                width: '100%',
                                padding: '16px 28px',
                                fontFamily: "'Barlow', sans-serif",
                                fontSize: '12px',
                                fontWeight: 600,
                                letterSpacing: '3px',
                                textTransform: 'uppercase',
                                textAlign: 'center',
                                background: 'transparent',
                                color: 'var(--ink)',
                                border: '1px solid var(--border-strong)',
                                cursor: 'pointer',
                            }}
                        >
                            {showLoad ? 'Cancel' : 'Load character'}
                        </button>

                        {showLoad && (
                            <div style={{display: 'flex', gap: '8px'}}>
                                <input
                                    type="text"
                                    value={code}
                                    onChange={e => {
                                        setCode(e.target.value.toUpperCase());
                                        setError('');
                                    }}
                                    onKeyDown={e => e.key === 'Enter' && doLoad()}
                                    placeholder="Enter 6-char code"
                                    maxLength={6}
                                    style={{
                                        flex: 1,
                                        padding: '14px 16px',
                                        background: 'transparent',
                                        border: '1px solid var(--border-strong)',
                                        color: 'var(--ink)',
                                        fontFamily: "'Barlow', sans-serif",
                                        fontSize: '15px',
                                        letterSpacing: '5px',
                                        textTransform: 'uppercase',
                                        textAlign: 'center',
                                        outline: 'none',
                                    }}
                                />
                                <button onClick={doLoad} style={{
                                    padding: '14px 20px', fontFamily: "'Barlow', sans-serif", fontSize: '14px',
                                    letterSpacing: '2px', background: 'var(--red)', color: 'var(--on-accent)',
                                    border: '1px solid var(--red)', cursor: 'pointer',
                                }}>→
                                </button>
                            </div>
                        )}
                        {error &&
                            <div style={{color: 'var(--red)', fontSize: '14px', fontStyle: 'italic'}}>{error}</div>}
                    </div>
                </div>
            </main>
        </>
    );
}
