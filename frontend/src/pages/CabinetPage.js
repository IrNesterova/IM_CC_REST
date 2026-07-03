import {useEffect, useState} from 'react';
import {useLocation, useNavigate} from 'react-router-dom';
import {createRoom, deleteCharacter, getMyCharacters, getMyRooms, joinRoom, loadCharacter} from '../api/api';
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
    const location = useLocation();

    const [activeTab, setActiveTab] = useState(location.state?.tab || 'characters');

    // Characters state
    const [chars, setChars] = useState([]);
    const [loadingChars, setLoadingChars] = useState(true);
    const [deletingCode, setDeletingCode] = useState(null);

    // Rooms state
    const [myRooms, setMyRooms] = useState([]);
    const [roomName, setRoomName] = useState('');
    const [joinCode, setJoinCode] = useState('');
    const [createError, setCreateError] = useState('');
    const [joinError, setJoinError] = useState('');
    const [creating, setCreating] = useState(false);
    const [joining, setJoining] = useState(false);


    useEffect(() => {
        if (!user) { navigate('/login'); return; }
        getMyCharacters()
            .then(setChars)
            .catch(err => { if (err?.response?.status === 401) navigate('/login'); })
            .finally(() => setLoadingChars(false));
        getMyRooms().then(setMyRooms).catch(() => {});
    }, [user]); // eslint-disable-line react-hooks/exhaustive-deps

    const newCharacter = () => {
        dispatch({type: 'RESET'});
        navigate('/characteristics');
    };

    const openChar = async (code) => {
        const raw = await loadCharacter(code);
        const parsed = typeof raw === 'string' ? JSON.parse(raw) : raw;
        const ccm = parsed.ccm || parsed;
        dispatch({type: 'RESTORE', payload: ccm});
        navigate('/summary');
    };

    const removeChar = async (code) => {
        setDeletingCode(code);
        await deleteCharacter(code);
        setChars(cs => cs.filter(c => c.code !== code));
        setDeletingCode(null);
    };

    const handleCreateRoom = async () => {
        if (!roomName.trim()) { setCreateError('Enter a room name.'); return; }
        setCreating(true);
        setCreateError('');
        try {
            const room = await createRoom(roomName.trim());
            navigate(`/room/${room.id}`, {state: {room}});
        } catch {
            setCreateError('Failed to create room.');
        } finally {
            setCreating(false);
        }
    };

    const handleJoinRoom = async () => {
        const code = joinCode.trim().toUpperCase();
        if (code.length !== 6) { setJoinError('Enter a 6-character code.'); return; }
        setJoining(true);
        setJoinError('');
        try {
            const room = await joinRoom(code);
            navigate(`/room/${room.id}`, {state: {room}});
        } catch (err) {
            setJoinError(err?.response?.status === 404 ? 'Room not found.' : 'Failed to join room.');
        } finally {
            setJoining(false);
        }
    };

    const panel = {
        background: 'var(--panel)', border: '1px solid var(--border)',
        boxShadow: '0 4px 28px var(--shadow)',
    };

    return (
        <>
            <Topbar/>
            <main style={{flex: 1, background: 'var(--bg)', display: 'flex', justifyContent: 'center', padding: '60px 24px'}}>
                <div style={{maxWidth: '680px', width: '100%', display: 'flex', flexDirection: 'column', gap: '16px'}}>

                    {/* Profile header */}
                    <div style={{...panel, padding: '36px 48px', position: 'relative'}}>
                        <div style={{
                            position: 'absolute', top: 0, left: 0, width: '100%', height: '3px',
                            background: 'linear-gradient(90deg, transparent, var(--red), transparent)',
                        }}/>
                        <div style={{display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '24px', flexWrap: 'wrap'}}>
                            <div>
                                <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '28px', textTransform: 'uppercase', color: 'var(--red)', letterSpacing: '2px', lineHeight: 1.1}}>
                                    {user?.displayName || user?.email}
                                </div>
                                {user?.displayName && (
                                    <div style={{fontSize: '13px', color: 'var(--muted)', marginTop: '4px', fontFamily: "'Barlow', sans-serif"}}>
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
                                    border: '1px solid var(--red)', cursor: 'pointer', whiteSpace: 'nowrap',
                                }}>
                                    + New character
                                </button>
                                <button onClick={logout} style={{
                                    padding: '12px 22px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                    letterSpacing: '2px', textTransform: 'uppercase',
                                    background: 'transparent', color: 'var(--muted)',
                                    border: '1px solid var(--border)', cursor: 'pointer', whiteSpace: 'nowrap',
                                }}>
                                    Sign out
                                </button>
                            </div>
                        </div>

                    </div>

                    {/* Tab bar */}
                    <div style={{display: 'flex', borderBottom: '1px solid var(--border)'}}>
                        {[{id: 'characters', label: 'Characters'}, {id: 'rooms', label: 'Rooms'}].map(tab => (
                            <button
                                key={tab.id}
                                onClick={() => setActiveTab(tab.id)}
                                style={{
                                    padding: '12px 28px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                    letterSpacing: '3px', textTransform: 'uppercase',
                                    background: 'transparent', border: 'none',
                                    color: activeTab === tab.id ? 'var(--ink)' : 'var(--muted)',
                                    borderBottom: activeTab === tab.id ? '2px solid var(--red)' : '2px solid transparent',
                                    cursor: 'pointer', marginBottom: '-1px',
                                }}
                            >
                                {tab.label}
                            </button>
                        ))}
                    </div>

                    {/* ── Characters tab ── */}
                    {activeTab === 'characters' && (
                        <div style={{...panel}}>
                            <div style={{padding: '18px 48px', borderBottom: '1px solid var(--border)', display: 'flex', alignItems: 'center', justifyContent: 'space-between'}}>
                                <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '11px', letterSpacing: '3px', textTransform: 'uppercase', color: 'var(--muted)'}}>
                                    Saved characters
                                </div>
                                {!loadingChars && (
                                    <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '11px', color: 'var(--muted)', letterSpacing: '1px'}}>
                                        {chars.length} {chars.length === 1 ? 'record' : 'records'}
                                    </div>
                                )}
                            </div>

                            {loadingChars ? (
                                <div style={{padding: '48px', textAlign: 'center', fontFamily: "'Barlow', sans-serif", fontSize: '12px', letterSpacing: '3px', color: 'var(--muted)', textTransform: 'uppercase'}}>
                                    Loading…
                                </div>
                            ) : chars.length === 0 ? (
                                <div style={{padding: '48px', textAlign: 'center'}}>
                                    <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '13px', color: 'var(--muted)', letterSpacing: '1px', marginBottom: '20px'}}>
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
                                    }}>
                                        <div style={{flex: 1, minWidth: 0}}>
                                            <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '16px', color: 'var(--ink)', fontWeight: 500, whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'}}>
                                                {c.name || '(unnamed)'}
                                            </div>
                                            {(c.originName || c.factionName || c.roleName) && (
                                                <div style={{display: 'flex', gap: '6px', marginTop: '3px', flexWrap: 'wrap'}}>
                                                    {[c.originName, c.factionName, c.roleName].filter(Boolean).map(tag => (
                                                        <span key={tag} style={{fontFamily: "'Barlow', sans-serif", fontSize: '10px', letterSpacing: '1px', textTransform: 'uppercase', color: 'var(--on-accent)', background: 'var(--red)', padding: '2px 7px'}}>
                                                            {tag}
                                                        </span>
                                                    ))}
                                                </div>
                                            )}
                                            <div style={{display: 'flex', gap: '16px', marginTop: '5px', fontFamily: "'Barlow', sans-serif", fontSize: '11px', color: 'var(--muted)', letterSpacing: '1px'}}>
                                                <span style={{fontFamily: 'monospace', letterSpacing: '3px', fontSize: '12px', color: 'var(--red)'}}>{c.code}</span>
                                                <span>Updated {formatDate(c.updatedAt)}</span>
                                            </div>
                                        </div>
                                        <div style={{display: 'flex', gap: '8px', flexShrink: 0}}>
                                            <button onClick={() => openChar(c.code)} style={{
                                                padding: '8px 18px',
                                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                                fontWeight: 600, letterSpacing: '2px', textTransform: 'uppercase',
                                                background: 'transparent', color: 'var(--ink)',
                                                border: '1px solid var(--border-strong)', cursor: 'pointer',
                                            }}>
                                                Open
                                            </button>
                                            <button onClick={() => removeChar(c.code)} disabled={deletingCode === c.code} style={{
                                                padding: '8px 14px',
                                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                                letterSpacing: '1px', textTransform: 'uppercase',
                                                background: 'transparent', color: 'var(--muted)',
                                                border: '1px solid var(--border)',
                                                cursor: deletingCode === c.code ? 'not-allowed' : 'pointer',
                                                opacity: deletingCode === c.code ? 0.5 : 1,
                                            }}>
                                                {deletingCode === c.code ? '…' : '×'}
                                            </button>
                                        </div>
                                    </div>
                                ))
                            )}
                        </div>
                    )}

                    {/* ── Rooms tab ── */}
                    {activeTab === 'rooms' && (
                        <>
                            {/* Create room */}
                            <div style={{...panel, padding: '36px 40px', position: 'relative'}}>
                                <div style={{position: 'absolute', top: 0, left: 0, width: '100%', height: '3px', background: 'linear-gradient(90deg, transparent, var(--red), transparent)'}}/>
                                <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '11px', letterSpacing: '3px', textTransform: 'uppercase', color: 'var(--muted)', marginBottom: '20px'}}>
                                    Create a room
                                </div>
                                <div style={{display: 'flex', gap: '8px'}}>
                                    <input
                                        type="text" value={roomName}
                                        onChange={e => { setRoomName(e.target.value); setCreateError(''); }}
                                        onKeyDown={e => e.key === 'Enter' && handleCreateRoom()}
                                        placeholder="Room name…" maxLength={120}
                                        style={{flex: 1, padding: '14px 16px', background: 'var(--field-bg)', border: '1px solid var(--border)', color: 'var(--ink)', fontFamily: "'Barlow', sans-serif", fontSize: '15px', outline: 'none'}}
                                    />
                                    <button onClick={handleCreateRoom} disabled={creating} style={{
                                        padding: '14px 24px',
                                        fontFamily: "'Barlow', sans-serif", fontSize: '12px',
                                        fontWeight: 600, letterSpacing: '2px', textTransform: 'uppercase',
                                        background: 'var(--red)', color: 'var(--on-accent)',
                                        border: '1px solid var(--red)',
                                        cursor: creating ? 'not-allowed' : 'pointer',
                                        opacity: creating ? 0.6 : 1, whiteSpace: 'nowrap',
                                    }}>
                                        {creating ? '…' : 'Create'}
                                    </button>
                                </div>
                                {createError && <div style={{color: 'var(--red)', fontSize: '13px', fontStyle: 'italic', marginTop: '10px'}}>{createError}</div>}
                            </div>

                            {/* Join room */}
                            <div style={{...panel, padding: '36px 40px'}}>
                                <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '11px', letterSpacing: '3px', textTransform: 'uppercase', color: 'var(--muted)', marginBottom: '20px'}}>
                                    Join a room
                                </div>
                                <div style={{display: 'flex', gap: '8px'}}>
                                    <input
                                        type="text" value={joinCode}
                                        onChange={e => { setJoinCode(e.target.value.toUpperCase()); setJoinError(''); }}
                                        onKeyDown={e => e.key === 'Enter' && handleJoinRoom()}
                                        placeholder="6-character code" maxLength={6}
                                        style={{flex: 1, padding: '14px 16px', background: 'var(--field-bg)', border: '1px solid var(--border)', color: 'var(--ink)', fontFamily: "'Barlow', sans-serif", fontSize: '15px', letterSpacing: '5px', textTransform: 'uppercase', outline: 'none'}}
                                    />
                                    <button onClick={handleJoinRoom} disabled={joining} style={{
                                        padding: '14px 24px',
                                        fontFamily: "'Barlow', sans-serif", fontSize: '14px', letterSpacing: '2px',
                                        background: 'transparent', color: 'var(--ink)',
                                        border: '1px solid var(--border-strong)',
                                        cursor: joining ? 'not-allowed' : 'pointer',
                                        opacity: joining ? 0.6 : 1,
                                    }}>
                                        {joining ? '…' : '→'}
                                    </button>
                                </div>
                                {joinError && <div style={{color: 'var(--red)', fontSize: '13px', fontStyle: 'italic', marginTop: '10px'}}>{joinError}</div>}
                            </div>

                            {/* Existing rooms */}
                            {myRooms.length > 0 && (
                                <div style={{...panel}}>
                                    <div style={{padding: '18px 48px', borderBottom: '1px solid var(--border)'}}>
                                        <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '11px', letterSpacing: '3px', textTransform: 'uppercase', color: 'var(--muted)'}}>
                                            Your rooms
                                        </div>
                                    </div>
                                    {myRooms.map((room, i) => (
                                        <button
                                            key={room.id}
                                            onClick={() => navigate(`/room/${room.id}`, {state: {room}})}
                                            style={{
                                                display: 'flex', alignItems: 'center', justifyContent: 'space-between', gap: '16px',
                                                width: '100%', padding: '16px 48px', textAlign: 'left',
                                                background: 'transparent', color: 'var(--ink)', cursor: 'pointer',
                                                fontFamily: "'Barlow', sans-serif", fontSize: '15px',
                                                border: 'none',
                                                borderBottom: i < myRooms.length - 1 ? '1px solid var(--border)' : 'none',
                                            }}
                                        >
                                            <span style={{whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'}}>{room.name}</span>
                                            <span style={{fontFamily: 'monospace', fontSize: '13px', letterSpacing: '3px', color: '#085d65', flexShrink: 0}}>{room.joinCode}</span>
                                        </button>
                                    ))}
                                </div>
                            )}
                        </>
                    )}

                </div>
            </main>
        </>
    );
}