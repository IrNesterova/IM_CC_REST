import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {createRoom, getMyRooms, joinRoom} from '../api/api';
import {useAuth} from '../context/AuthContext';
import Topbar from '../components/Topbar';

export default function LobbyPage() {
    const {user} = useAuth();
    const navigate = useNavigate();

    const [roomName, setRoomName] = useState('');
    const [joinCode, setJoinCode] = useState('');
    const [createError, setCreateError] = useState('');
    const [joinError, setJoinError] = useState('');
    const [creating, setCreating] = useState(false);
    const [joining, setJoining] = useState(false);
    const [myRooms, setMyRooms] = useState([]);

    useEffect(() => {
        if (user) {
            getMyRooms().then(setMyRooms).catch(() => {});
        }
    }, [user]);

    const handleCreate = async () => {
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

    const handleJoin = async () => {
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

    return (
        <>
            <Topbar/>
            <main style={{
                flex: 1, background: 'var(--bg)',
                display: 'flex', alignItems: 'center', justifyContent: 'center',
                padding: '60px 24px',
            }}>
                <div style={{maxWidth: '560px', width: '100%', display: 'flex', flexDirection: 'column', gap: '16px'}}>

                    <div style={{
                        fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                        letterSpacing: '4px', textTransform: 'uppercase', color: 'var(--muted)',
                        marginBottom: '4px',
                    }}>
                        {user?.displayName || user?.email}
                    </div>

                    {/* Create room */}
                    <div style={{
                        background: 'var(--panel)', border: '1px solid var(--border)',
                        padding: '36px 40px', boxShadow: '0 4px 28px var(--shadow)',
                        position: 'relative',
                    }}>
                        <div style={{
                            position: 'absolute', top: 0, left: 0, width: '100%', height: '3px',
                            background: 'linear-gradient(90deg, transparent, var(--red), transparent)',
                        }}/>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                            letterSpacing: '3px', textTransform: 'uppercase',
                            color: 'var(--muted)', marginBottom: '20px',
                        }}>
                            Create a room
                        </div>
                        <div style={{display: 'flex', gap: '8px'}}>
                            <input
                                type="text"
                                value={roomName}
                                onChange={e => { setRoomName(e.target.value); setCreateError(''); }}
                                onKeyDown={e => e.key === 'Enter' && handleCreate()}
                                placeholder="Room name…"
                                maxLength={120}
                                style={{
                                    flex: 1, padding: '14px 16px',
                                    background: 'var(--field-bg)', border: '1px solid var(--border)',
                                    color: 'var(--ink)', fontFamily: "'Barlow', sans-serif",
                                    fontSize: '15px', outline: 'none',
                                }}
                            />
                            <button
                                onClick={handleCreate}
                                disabled={creating}
                                style={{
                                    padding: '14px 24px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '12px',
                                    fontWeight: 600, letterSpacing: '2px', textTransform: 'uppercase',
                                    background: 'var(--red)', color: 'var(--on-accent)',
                                    border: '1px solid var(--red)', cursor: creating ? 'not-allowed' : 'pointer',
                                    opacity: creating ? 0.6 : 1, whiteSpace: 'nowrap',
                                }}
                            >
                                {creating ? '…' : 'Create'}
                            </button>
                        </div>
                        {createError && (
                            <div style={{color: 'var(--red)', fontSize: '13px', fontStyle: 'italic', marginTop: '10px'}}>
                                {createError}
                            </div>
                        )}
                    </div>

                    {/* Join room */}
                    <div style={{
                        background: 'var(--panel)', border: '1px solid var(--border)',
                        padding: '36px 40px', boxShadow: '0 4px 28px var(--shadow)',
                    }}>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                            letterSpacing: '3px', textTransform: 'uppercase',
                            color: 'var(--muted)', marginBottom: '20px',
                        }}>
                            Join a room
                        </div>
                        <div style={{display: 'flex', gap: '8px'}}>
                            <input
                                type="text"
                                value={joinCode}
                                onChange={e => { setJoinCode(e.target.value.toUpperCase()); setJoinError(''); }}
                                onKeyDown={e => e.key === 'Enter' && handleJoin()}
                                placeholder="6-character code"
                                maxLength={6}
                                style={{
                                    flex: 1, padding: '14px 16px',
                                    background: 'var(--field-bg)', border: '1px solid var(--border)',
                                    color: 'var(--ink)', fontFamily: "'Barlow', sans-serif",
                                    fontSize: '15px', letterSpacing: '5px', textTransform: 'uppercase',
                                    outline: 'none',
                                }}
                            />
                            <button
                                onClick={handleJoin}
                                disabled={joining}
                                style={{
                                    padding: '14px 24px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '14px',
                                    letterSpacing: '2px',
                                    background: 'transparent', color: 'var(--ink)',
                                    border: '1px solid var(--border-strong)',
                                    cursor: joining ? 'not-allowed' : 'pointer',
                                    opacity: joining ? 0.6 : 1,
                                }}
                            >
                                {joining ? '…' : '→'}
                            </button>
                        </div>
                        {joinError && (
                            <div style={{color: 'var(--red)', fontSize: '13px', fontStyle: 'italic', marginTop: '10px'}}>
                                {joinError}
                            </div>
                        )}
                    </div>

                    {/* Existing rooms */}
                    {myRooms.length > 0 && (
                        <div style={{
                            background: 'var(--panel)', border: '1px solid var(--border)',
                            padding: '36px 40px', boxShadow: '0 4px 28px var(--shadow)',
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                letterSpacing: '3px', textTransform: 'uppercase',
                                color: 'var(--muted)', marginBottom: '20px',
                            }}>
                                Your rooms
                            </div>
                            <div style={{display: 'flex', flexDirection: 'column', gap: '8px'}}>
                                {myRooms.map(room => (
                                    <button
                                        key={room.id}
                                        onClick={() => navigate(`/room/${room.id}`, {state: {room}})}
                                        style={{
                                            display: 'flex', alignItems: 'center',
                                            justifyContent: 'space-between', gap: '16px',
                                            padding: '14px 16px', textAlign: 'left',
                                            background: 'var(--field-bg)', border: '1px solid var(--border)',
                                            color: 'var(--ink)', cursor: 'pointer',
                                            fontFamily: "'Barlow', sans-serif", fontSize: '15px',
                                        }}
                                    >
                                        <span style={{whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis'}}>
                                            {room.name}
                                        </span>
                                        <span style={{
                                            fontFamily: 'monospace', fontSize: '13px',
                                            letterSpacing: '3px', color: '#085d65', flexShrink: 0,
                                        }}>
                                            {room.joinCode}
                                        </span>
                                    </button>
                                ))}
                            </div>
                        </div>
                    )}

                </div>
            </main>
        </>
    );
}