import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {getMyCharacters, deleteCharacter, loadCharacter, saveWebhookUrl} from '../api/api';
import {useAuth} from '../context/AuthContext';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';

function formatDate(iso) {
    if (!iso) return '—';
    const d = new Date(iso);
    return d.toLocaleDateString('en-GB', {day: '2-digit', month: 'short', year: 'numeric'});
}

export default function CabinetPage() {
    const {user, logout} = useAuth();
    const {dispatch} = useCharacter();
    const navigate = useNavigate();
    const [chars, setChars] = useState([]);
    const [loading, setLoading] = useState(true);
    const [deletingCode, setDeletingCode] = useState(null);
    const [webhook, setWebhook] = useState(user?.webhookUrl || '');
    const [webhookSaved, setWebhookSaved] = useState(false);

    useEffect(() => {
        if (!user) { navigate('/login'); return; }
        getMyCharacters()
            .then(setChars)
            .catch(err => { if (err?.response?.status === 401) navigate('/login'); })
            .finally(() => setLoading(false));
    }, [user]); // eslint-disable-line react-hooks/exhaustive-deps

    useEffect(() => {
        if (user?.webhookUrl) setWebhook(user.webhookUrl);
    }, [user]);

    const handleWebhookSave = async () => {
        await saveWebhookUrl(webhook);
        setWebhookSaved(true);
        setTimeout(() => setWebhookSaved(false), 2000);
    };

    const newCharacter = () => {
        dispatch({type: 'RESTORE', payload: {}});
        navigate('/characteristics');
    };

    const open = async (code) => {
        const raw = await loadCharacter(code);
        const parsed = typeof raw === 'string' ? JSON.parse(raw) : raw;
        const ccm = parsed.ccm || parsed;
        dispatch({type: 'RESTORE', payload: ccm});
        navigate('/summary');
    };

    const remove = async (code) => {
        setDeletingCode(code);
        await deleteCharacter(code);
        setChars(cs => cs.filter(c => c.code !== code));
        setDeletingCode(null);
    };

    return (
        <>
            <Topbar/>
            <main style={{
                flex: 1, background: 'var(--bg)',
                display: 'flex', justifyContent: 'center',
                padding: '60px 24px',
            }}>
                <div style={{maxWidth: '680px', width: '100%'}}>

                    {/* Header card */}
                    <div style={{
                        background: 'var(--panel)', border: '1px solid var(--border)',
                        padding: '36px 48px', marginBottom: '16px',
                        boxShadow: '0 4px 28px var(--shadow)', position: 'relative',
                    }}>
                        <div style={{
                            position: 'absolute', top: 0, left: 0, width: '100%', height: '3px',
                            background: 'linear-gradient(90deg, transparent, var(--red), transparent)',
                        }}/>

                        <div style={{
                            display: 'flex', alignItems: 'flex-start',
                            justifyContent: 'space-between', gap: '24px', flexWrap: 'wrap',
                        }}>
                            <div>

                                <div style={{
                                    fontFamily: "'Barlow', sans-serif", fontSize: '28px',
                                    textTransform: 'uppercase', color: 'var(--red)',
                                    letterSpacing: '2px', lineHeight: 1.1,
                                }}>
                                    {user?.displayName || user?.email}
                                </div>
                                {user?.displayName && (
                                    <div style={{
                                        fontSize: '13px', color: 'var(--muted)',
                                        marginTop: '4px', fontFamily: "'Barlow', sans-serif",
                                    }}>
                                        {user.email}
                                    </div>
                                )}
                            </div>

                            <div style={{display: 'flex', gap: '10px', alignItems: 'center'}}>
                                <button onClick={newCharacter} style={{
                                    padding: '12px 22px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                    fontWeight: 600, letterSpacing: '3px', textTransform: 'uppercase',
                                    background: 'var(--red)', color: 'var(--on-accent)',
                                    border: '1px solid var(--red)', cursor: 'pointer',
                                    whiteSpace: 'nowrap',
                                }}>
                                    + New character
                                </button>
                                <button onClick={logout} style={{
                                    padding: '12px 22px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                    fontWeight: 400, letterSpacing: '2px', textTransform: 'uppercase',
                                    background: 'transparent', color: 'var(--muted)',
                                    border: '1px solid var(--border)', cursor: 'pointer',
                                    whiteSpace: 'nowrap',
                                }}>
                                    Sign out
                                </button>
                            </div>
                        </div>

                        {/* Discord webhook */}
                        <div style={{
                            marginTop: '24px', paddingTop: '20px',
                            borderTop: '1px solid var(--border)',
                            display: 'flex', alignItems: 'center', gap: '10px', flexWrap: 'wrap',
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                letterSpacing: '2px', textTransform: 'uppercase',
                                color: 'var(--muted)', whiteSpace: 'nowrap',
                            }}>Discord Webhook</div>
                            <input
                                type="text"
                                value={webhook}
                                onChange={e => setWebhook(e.target.value)}
                                placeholder="https://discord.com/api/webhooks/…"
                                style={{
                                    flex: 1, minWidth: '200px',
                                    padding: '8px 12px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '12px',
                                    background: 'var(--field-bg)', border: '1px solid var(--border)',
                                    color: 'var(--ink)', outline: 'none',
                                }}
                            />
                            <button onClick={handleWebhookSave} style={{
                                padding: '8px 18px',
                                fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                letterSpacing: '2px', textTransform: 'uppercase',
                                background: webhookSaved ? 'var(--red)' : 'transparent',
                                color: webhookSaved ? 'var(--on-accent)' : 'var(--muted)',
                                border: '1px solid var(--border)', cursor: 'pointer',
                                transition: 'all 0.2s',
                            }}>
                                {webhookSaved ? 'Saved!' : 'Save'}
                            </button>
                        </div>

                    </div>

                    {/* Characters list */}
                    <div style={{
                        background: 'var(--panel)', border: '1px solid var(--border)',
                        boxShadow: '0 4px 28px var(--shadow)',
                    }}>
                        <div style={{
                            padding: '18px 48px',
                            borderBottom: '1px solid var(--border)',
                            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                letterSpacing: '3px', textTransform: 'uppercase', color: 'var(--muted)',
                            }}>
                                Saved characters
                            </div>
                            {!loading && (
                                <div style={{
                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                    color: 'var(--muted)', letterSpacing: '1px',
                                }}>
                                    {chars.length} {chars.length === 1 ? 'record' : 'records'}
                                </div>
                            )}
                        </div>

                        {loading ? (
                            <div style={{
                                padding: '48px', textAlign: 'center',
                                fontFamily: "'Barlow', sans-serif", fontSize: '12px',
                                letterSpacing: '3px', color: 'var(--muted)', textTransform: 'uppercase',
                            }}>
                                Loading…
                            </div>
                        ) : chars.length === 0 ? (
                            <div style={{padding: '48px', textAlign: 'center'}}>
                                <div style={{
                                    fontFamily: "'Barlow', sans-serif", fontSize: '13px',
                                    color: 'var(--muted)', letterSpacing: '1px',
                                    marginBottom: '20px',
                                }}>
                                    No saved characters yet.
                                </div>
                                <button onClick={newCharacter} style={{
                                    padding: '14px 28px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                    fontWeight: 600, letterSpacing: '3px', textTransform: 'uppercase',
                                    background: 'var(--red)', color: 'var(--on-accent)',
                                    border: '1px solid var(--red)', cursor: 'pointer',
                                }}>
                                    Create your first character
                                </button>
                            </div>
                        ) : (
                            chars.map((c, i) => (
                                <div key={c.code} style={{
                                    display: 'flex', alignItems: 'center', gap: '16px',
                                    padding: '18px 48px',
                                    borderBottom: i < chars.length - 1 ? '1px solid var(--border)' : 'none',
                                    transition: 'background 0.15s',
                                }}>
                                    <div style={{flex: 1, minWidth: 0}}>
                                        <div style={{
                                            fontFamily: "'Barlow', sans-serif", fontSize: '16px',
                                            color: 'var(--ink)', fontWeight: 500,
                                            whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                                        }}>
                                            {c.name || '(unnamed)'}
                                        </div>
                                        {(c.originName || c.factionName || c.roleName) && (
                                            <div style={{
                                                display: 'flex', gap: '6px', marginTop: '3px',
                                                flexWrap: 'wrap',
                                            }}>
                                                {[c.originName, c.factionName, c.roleName].filter(Boolean).map(tag => (
                                                    <span key={tag} style={{
                                                        fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                                        letterSpacing: '1px', textTransform: 'uppercase',
                                                        color: 'var(--on-accent)', background: 'var(--red)',
                                                        padding: '2px 7px',
                                                    }}>{tag}</span>
                                                ))}
                                            </div>
                                        )}
                                        <div style={{
                                            display: 'flex', gap: '16px', marginTop: '5px',
                                            fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                            color: 'var(--muted)', letterSpacing: '1px',
                                        }}>
                                            <span style={{
                                                fontFamily: 'monospace', letterSpacing: '3px',
                                                fontSize: '12px', color: 'var(--red)',
                                            }}>{c.code}</span>
                                            <span>Updated {formatDate(c.updatedAt)}</span>
                                        </div>
                                    </div>

                                    <div style={{display: 'flex', gap: '8px', flexShrink: 0}}>
                                        <button onClick={() => open(c.code)} style={{
                                            padding: '8px 18px',
                                            fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                            fontWeight: 600, letterSpacing: '2px', textTransform: 'uppercase',
                                            background: 'transparent', color: 'var(--ink)',
                                            border: '1px solid var(--border-strong)', cursor: 'pointer',
                                        }}>
                                            Open
                                        </button>
                                        <button
                                            onClick={() => remove(c.code)}
                                            disabled={deletingCode === c.code}
                                            style={{
                                                padding: '8px 14px',
                                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                                letterSpacing: '1px', textTransform: 'uppercase',
                                                background: 'transparent',
                                                color: deletingCode === c.code ? 'var(--muted)' : 'var(--muted)',
                                                border: '1px solid var(--border)', cursor: deletingCode === c.code ? 'not-allowed' : 'pointer',
                                                opacity: deletingCode === c.code ? 0.5 : 1,
                                            }}>
                                            {deletingCode === c.code ? '…' : '×'}
                                        </button>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>

                </div>
            </main>
        </>
    );
}
