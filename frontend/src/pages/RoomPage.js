import {useCallback, useEffect, useMemo, useRef, useState} from 'react';
import {useLocation, useNavigate, useParams} from 'react-router-dom';
import {Client} from '@stomp/stompjs';
import SockJS from 'sockjs-client';
import {changeRoomStatus, getMyCharacters, getPatronPreview, getRoom, getRoster, leaveRoom, selectCharacter, setRoomPatron, updateRoomSourceBooks, updateRoomWebhook, WS_URL} from '../api/api';
import {useAuth} from '../context/AuthContext';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';

const ROLE_LABEL = {GM: 'GM', PLAYER: 'Player'};
const STATUS_COLOR = {ACTIVE: 'var(--ink)', LEFT: 'var(--muted)'};

export default function RoomPage() {
    const {roomId} = useParams();
    const {state} = useLocation();
    const navigate = useNavigate();
    const {user} = useAuth();
    const {dispatch, setAllowedSourceBooks} = useCharacter();

    const [room, setRoom] = useState(state?.room || null);
    const [roster, setRoster] = useState([]);
    const [rosterError, setRosterError] = useState('');
    const [copied, setCopied] = useState(false);
    const [leaving, setLeaving] = useState(false);
    const [myCharacters, setMyCharacters] = useState([]);
    const [selectingChar, setSelectingChar] = useState(false);
    const [webhookInput, setWebhookInput] = useState('');
    const [webhookSaved, setWebhookSaved] = useState(false);
    const [patronInput, setPatronInput] = useState('');
    const [patronSaved, setPatronSaved] = useState(false);
    const [patronPreview, setPatronPreview] = useState(null);

    const fetchRoster = useCallback(async () => {
        try {
            const data = await getRoster(roomId);
            setRoster(data);
            setRosterError('');
        } catch {
            setRosterError('Could not load roster.');
        }
    }, [roomId]);

    const fetchRosterRef = useRef(fetchRoster);
    fetchRosterRef.current = fetchRoster;

    useEffect(() => {
        getRoom(roomId).then(r => { setRoom(r); setWebhookInput(r.webhookUrl || ''); setPatronInput(r.patronCode || ''); }).catch(() => navigate('/lobby'));
    }, [roomId]); // eslint-disable-line react-hooks/exhaustive-deps

    useEffect(() => {
        getMyCharacters().then(setMyCharacters).catch(() => {});
    }, []);

    useEffect(() => {
        if (room?.patronCode) {
            getPatronPreview(room.patronCode).then(setPatronPreview).catch(() => setPatronPreview(null));
        } else {
            setPatronPreview(null);
        }
    }, [room?.patronCode]);

    useEffect(() => {
        fetchRoster();
    }, [fetchRoster]);

    useEffect(() => {
        const client = new Client({
            webSocketFactory: () => new SockJS(`${WS_URL}/ws`),
            reconnectDelay: 5000,
            onConnect: () => {
                client.subscribe(`/topic/rooms/${roomId}`, (msg) => {
                    const event = JSON.parse(msg.body);
                    switch (event.type) {
                        case 'MEMBER_JOINED':
                        case 'MEMBER_LEFT':
                            fetchRosterRef.current();
                            break;
                        case 'CHARACTER_SELECTED':
                            setRoster(prev => prev.map(r =>
                                r.userId === event.userId
                                    ? {...r, characterId: event.characterId, characterCode: event.characterCode, characterName: event.characterName}
                                    : r
                            ));
                            break;
                        case 'ROOM_STATUS_CHANGED':
                            setRoom(prev => prev ? {...prev, open: event.open} : prev);
                            break;
                        case 'SOURCE_BOOKS_CHANGED':
                            setRoom(prev => prev ? {...prev, sourceBooks: event.sourceBooks} : prev);
                            break;
                        case 'PATRON_CHANGED':
                            setRoom(prev => prev ? {...prev, patronCode: event.patronCode} : prev);
                            setPatronInput(event.patronCode || '');
                            break;
                        default:
                            break;
                    }
                });
            },
        });
        client.activate();
        return () => client.deactivate();
    }, [roomId]);

    const myEntry = roster.find(r => r.userId === user?.id);
    const isGm = room?.gmUserId != null && user?.id != null && room.gmUserId === user.id;

    // Violations: character parts that use source books not allowed in this room.
    // Only meaningful when the room has a restriction and the player has a character assigned.
    const violations = useMemo(() => {
        if (!room?.sourceBooks || !myEntry?.characterCode) return [];
        const char = myCharacters.find(c => c.code === myEntry.characterCode);
        if (!char) return [];
        const result = [];
        if (char.originSourceBook && !room.sourceBooks.includes(char.originSourceBook))
            result.push({label: 'Origin', name: char.originName, sourceBook: char.originSourceBook});
        if (char.factionSourceBook && !room.sourceBooks.includes(char.factionSourceBook))
            result.push({label: 'Faction', name: char.factionName, sourceBook: char.factionSourceBook});
        if (char.roleSourceBook && !room.sourceBooks.includes(char.roleSourceBook))
            result.push({label: 'Role', name: char.roleName, sourceBook: char.roleSourceBook});
        return result;
    }, [myCharacters, myEntry?.characterCode, room?.sourceBooks]); // eslint-disable-line react-hooks/exhaustive-deps

    const characterViolations = (code) => {
        if (!room?.sourceBooks) return [];
        const char = myCharacters.find(c => c.code === code);
        if (!char) return [];
        const result = [];
        if (char.originSourceBook && !room.sourceBooks.includes(char.originSourceBook)) result.push(char.originSourceBook);
        if (char.factionSourceBook && !room.sourceBooks.includes(char.factionSourceBook)) result.push(char.factionSourceBook);
        if (char.roleSourceBook && !room.sourceBooks.includes(char.roleSourceBook)) result.push(char.roleSourceBook);
        return result;
    };

    const rosterViolations = (entry) => {
        if (!room?.sourceBooks || !entry.characterCode) return [];
        const result = [];
        if (entry.originSourceBook && !room.sourceBooks.includes(entry.originSourceBook))
            result.push({label: 'Origin', sourceBook: entry.originSourceBook});
        if (entry.factionSourceBook && !room.sourceBooks.includes(entry.factionSourceBook))
            result.push({label: 'Faction', sourceBook: entry.factionSourceBook});
        if (entry.roleSourceBook && !room.sourceBooks.includes(entry.roleSourceBook))
            result.push({label: 'Role', sourceBook: entry.roleSourceBook});
        return result;
    };

    const copyCode = () => {
        navigator.clipboard.writeText(room?.joinCode || '');
        setCopied(true);
        setTimeout(() => setCopied(false), 1500);
    };

    const handleLeave = async () => {
        setLeaving(true);
        try {
            if (isGm) {
                await changeRoomStatus(roomId, 'CLOSED');
            } else {
                await leaveRoom(roomId);
            }
            navigate('/cabinet', {state: {tab: 'rooms'}});
        } catch {
            setLeaving(false);
        }
    };

    const handleSelectCharacter = async (code) => {
        if (!code || selectingChar) return;
        setSelectingChar(true);
        try {
            await selectCharacter(roomId, code);
        } catch (e) {
            console.error('Failed to select character', e);
        } finally {
            setSelectingChar(false);
        }
    };

    const handleToggleSourceBook = async (book) => {
        if (book === 'IM') return; // IM is always on
        const current = new Set(room?.sourceBooks || []);
        if (current.has(book)) {
            current.delete(book);
        } else {
            current.add(book);
        }
        try {
            const updated = await updateRoomSourceBooks(roomId, [...current]);
            setRoom(prev => prev ? {...prev, sourceBooks: updated.sourceBooks} : prev);
        } catch (e) {
            console.error('Failed to update source books', e);
        }
    };

    const handleSaveWebhook = async () => {
        try {
            const updated = await updateRoomWebhook(roomId, webhookInput);
            setRoom(prev => prev ? {...prev, webhookUrl: updated.webhookUrl} : prev);
            setWebhookSaved(true);
            setTimeout(() => setWebhookSaved(false), 2000);
        } catch (e) {
            console.error('Failed to save webhook', e);
        }
    };

    const handleSavePatron = async (code) => {
        try {
            const resolved = code !== undefined ? code : (patronInput.trim().toUpperCase() || null);
            const updated = await setRoomPatron(roomId, resolved);
            setRoom(prev => prev ? {...prev, patronCode: updated.patronCode} : prev);
            setPatronInput(updated.patronCode || '');
            setPatronSaved(true);
            setTimeout(() => setPatronSaved(false), 2000);
        } catch (e) {
            console.error('Failed to set patron', e);
        }
    };

    const handleCreateCharacter = () => {
        setAllowedSourceBooks(room?.sourceBooks ? [...room.sourceBooks] : null);
        dispatch({type: 'RESET'});
        navigate('/characteristics', {state: {webhookUrl: room?.webhookUrl || null}});
    };

    return (
        <>
            <Topbar/>
            <main style={{
                flex: 1, background: 'var(--bg)',
                display: 'flex', justifyContent: 'center',
                padding: '60px 24px',
            }}>
                <div style={{maxWidth: '680px', width: '100%', display: 'flex', flexDirection: 'column', gap: '16px'}}>

                    {/* Room header */}
                    <div style={{
                        background: 'var(--panel)', border: '1px solid var(--border)',
                        padding: '36px 48px', boxShadow: '0 4px 28px var(--shadow)',
                        position: 'relative',
                    }}>
                        <div style={{
                            position: 'absolute', top: 0, left: 0, width: '100%', height: '3px',
                            background: 'linear-gradient(90deg, transparent, var(--red), transparent)',
                        }}/>
                        <div style={{display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', gap: '24px', flexWrap: 'wrap'}}>
                            <div>
                                <div style={{
                                    fontFamily: "'Barlow', sans-serif", fontSize: '26px',
                                    textTransform: 'uppercase', color: 'var(--red)',
                                    letterSpacing: '2px', lineHeight: 1.1,
                                }}>
                                    {room?.name || 'Room'}
                                </div>
                                <div style={{display: 'flex', alignItems: 'center', gap: '10px', marginTop: '10px'}}>
                                    <span style={{fontFamily: 'monospace', fontSize: '18px', letterSpacing: '6px', color: '#085d65'}}>
                                        {room?.joinCode}
                                    </span>
                                    <button onClick={copyCode} style={{
                                        padding: '4px 12px',
                                        fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                        letterSpacing: '2px', textTransform: 'uppercase',
                                        background: copied ? '#085d65' : 'transparent',
                                        color: copied ? '#fff' : 'var(--muted)',
                                        border: '1px solid var(--border)',
                                        cursor: 'pointer', transition: 'all 0.2s',
                                    }}>
                                        {copied ? 'Copied' : 'Copy'}
                                    </button>
                                    {room?.open === false && (
                                        <span style={{
                                            fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                            letterSpacing: '2px', textTransform: 'uppercase',
                                            color: 'var(--muted)',
                                        }}>Closed</span>
                                    )}
                                </div>
                            </div>
                            <button onClick={handleLeave} disabled={leaving} style={{
                                padding: '10px 20px',
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                letterSpacing: '2px', textTransform: 'uppercase',
                                background: 'transparent', color: 'var(--muted)',
                                border: '1px solid var(--border)',
                                cursor: leaving ? 'not-allowed' : 'pointer',
                                opacity: leaving ? 0.5 : 1, whiteSpace: 'nowrap',
                            }}>
                                {isGm ? 'Close room' : 'Leave'}
                            </button>
                        </div>
                    </div>

                    {/* Source books — GM can toggle, players see read-only */}
                    <div style={{
                        background: 'var(--panel)', border: '1px solid var(--border)',
                        padding: '24px 48px', boxShadow: '0 4px 28px var(--shadow)',
                    }}>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                            letterSpacing: '3px', textTransform: 'uppercase',
                            color: 'var(--muted)', marginBottom: '16px',
                        }}>
                            Allowed source books
                        </div>
                        <div style={{display: 'flex', gap: '8px', flexWrap: 'wrap'}}>
                            {[
                                {key: 'IM', label: 'Core (IM)', color: 'var(--muted)', locked: true},
                                {key: 'IN', label: 'Inquisition (IN)', color: '#a07840', locked: false},
                                {key: 'AM', label: 'Adeptus Mechanicus (AM)', color: '#8b3a3a', locked: false},
                                {key: 'MR', label: 'Macharian Requisition (MR)', color: '#5a6e9c', locked: false},
                            ].map(({key, label, color, locked}) => {
                                const active = room?.sourceBooks?.includes(key) ?? true;
                                const clickable = isGm && !locked;
                                return (
                                    <button
                                        key={key}
                                        onClick={() => clickable && handleToggleSourceBook(key)}
                                        disabled={!clickable}
                                        style={{
                                            padding: '8px 16px',
                                            fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                            letterSpacing: '2px', textTransform: 'uppercase',
                                            background: active ? color : 'transparent',
                                            color: active ? '#fff' : color,
                                            border: `1px solid ${color}`,
                                            cursor: clickable ? 'pointer' : 'default',
                                            opacity: (!active && !isGm) ? 0.35 : (locked ? 0.6 : 1),
                                            transition: 'all 0.2s',
                                        }}
                                    >
                                        {label}
                                    </button>
                                );
                            })}
                        </div>
                    </div>

                    {/* Discord webhook (GM only) */}
                    {isGm && (
                        <div style={{
                            background: 'var(--panel)', border: '1px solid var(--border)',
                            padding: '24px 48px', boxShadow: '0 4px 28px var(--shadow)',
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                letterSpacing: '3px', textTransform: 'uppercase',
                                color: 'var(--muted)', marginBottom: '12px',
                            }}>
                                Discord Webhook
                            </div>
                            <div style={{display: 'flex', gap: '8px'}}>
                                <input
                                    type="text"
                                    value={webhookInput}
                                    onChange={e => { setWebhookInput(e.target.value); setWebhookSaved(false); }}
                                    onKeyDown={e => e.key === 'Enter' && handleSaveWebhook()}
                                    placeholder="https://discord.com/api/webhooks/…"
                                    style={{
                                        flex: 1, padding: '10px 14px',
                                        fontFamily: "'Barlow', sans-serif", fontSize: '13px',
                                        background: 'var(--field-bg)', border: '1px solid var(--border)',
                                        color: 'var(--ink)', outline: 'none',
                                    }}
                                />
                                <button onClick={handleSaveWebhook} style={{
                                    padding: '10px 20px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                    letterSpacing: '2px', textTransform: 'uppercase',
                                    background: webhookSaved ? '#085d65' : 'transparent',
                                    color: webhookSaved ? '#fff' : 'var(--muted)',
                                    border: '1px solid var(--border)',
                                    cursor: 'pointer', transition: 'all 0.2s', whiteSpace: 'nowrap',
                                }}>
                                    {webhookSaved ? 'Saved' : 'Save'}
                                </button>
                            </div>
                            {room?.webhookUrl && (
                                <div style={{
                                    marginTop: '8px', fontFamily: "'Barlow', sans-serif",
                                    fontSize: '11px', color: '#085d65', letterSpacing: '1px',
                                }}>
                                    ● Rolls will be posted to Discord
                                </div>
                            )}
                        </div>
                    )}

                    {/* Patron — GM sets, everyone sees */}
                    {isGm && (
                        <div style={{
                            background: 'var(--panel)', border: '1px solid var(--border)',
                            padding: '24px 48px', boxShadow: '0 4px 28px var(--shadow)',
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                letterSpacing: '3px', textTransform: 'uppercase',
                                color: 'var(--muted)', marginBottom: '12px',
                            }}>
                                Patron
                            </div>
                            <div style={{display: 'flex', gap: '8px'}}>
                                <input
                                    type="text"
                                    value={patronInput}
                                    onChange={e => { setPatronInput(e.target.value.toUpperCase()); setPatronSaved(false); }}
                                    onKeyDown={e => e.key === 'Enter' && handleSavePatron()}
                                    placeholder="6-char patron code"
                                    maxLength={6}
                                    style={{
                                        flex: 1, padding: '10px 14px',
                                        fontFamily: "'Barlow', sans-serif", fontSize: '14px',
                                        letterSpacing: '4px', textTransform: 'uppercase',
                                        background: 'var(--field-bg)', border: '1px solid var(--border)',
                                        color: 'var(--ink)', outline: 'none',
                                    }}
                                />
                                <button onClick={() => handleSavePatron()} style={{
                                    padding: '10px 20px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                    letterSpacing: '2px', textTransform: 'uppercase',
                                    background: patronSaved ? '#085d65' : 'transparent',
                                    color: patronSaved ? '#fff' : 'var(--muted)',
                                    border: '1px solid var(--border)',
                                    cursor: 'pointer', transition: 'all 0.2s',
                                }}>
                                    {patronSaved ? 'Saved' : 'Set'}
                                </button>
                                {room?.patronCode && (
                                    <button onClick={() => handleSavePatron(null)} style={{
                                        padding: '10px 16px',
                                        fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                        letterSpacing: '2px', textTransform: 'uppercase',
                                        background: 'transparent', color: 'var(--muted)',
                                        border: '1px solid var(--border)', cursor: 'pointer',
                                    }}>
                                        Clear
                                    </button>
                                )}
                            </div>
                            {room?.patronCode && (
                                <button
                                    onClick={() => window.open(`/patron?code=${room.patronCode}`, '_blank')}
                                    style={{
                                        marginTop: '10px', padding: '8px 16px',
                                        fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                        letterSpacing: '2px', textTransform: 'uppercase',
                                        background: 'transparent', color: '#085d65',
                                        border: '1px solid #085d65', cursor: 'pointer',
                                    }}>
                                    Open Patron Sheet ↗
                                </button>
                            )}
                        </div>
                    )}

                    {room?.patronCode && patronPreview && (
                        <div style={{
                            background: 'var(--panel)', border: '1px solid var(--border)',
                            boxShadow: '0 4px 28px var(--shadow)', position: 'relative', overflow: 'hidden',
                        }}>
                            <div style={{height: '3px', background: 'linear-gradient(90deg, transparent, #085d65, transparent)'}}/>

                            <div style={{padding: '24px 32px'}}>
                                {/* Header: name + button */}
                                <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'flex-start', marginBottom: '20px'}}>
                                    <div>
                                        <div style={{
                                            fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                            letterSpacing: '3px', textTransform: 'uppercase',
                                            color: 'var(--muted)', marginBottom: '6px',
                                        }}>
                                            Patron
                                        </div>
                                        <div style={{
                                            fontFamily: "'Cinzel', serif", fontSize: '22px',
                                            fontWeight: 700, color: '#085d65', letterSpacing: '1px',
                                            lineHeight: 1.1,
                                        }}>
                                            {patronPreview.patronName || '—'}
                                        </div>
                                        {patronPreview.factionText && (
                                            <div style={{
                                                fontFamily: "'Barlow', sans-serif", fontSize: '13px',
                                                color: 'var(--muted)', marginTop: '4px', letterSpacing: '0.5px',
                                            }}>
                                                {patronPreview.factionText}
                                            </div>
                                        )}
                                    </div>
                                    <button
                                        onClick={() => window.open(`/patron?code=${room.patronCode}`, '_blank')}
                                        style={{
                                            padding: '8px 16px', flexShrink: 0,
                                            fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                            letterSpacing: '2px', textTransform: 'uppercase',
                                            background: 'transparent', color: '#085d65',
                                            border: '1px solid #085d65', cursor: 'pointer',
                                        }}>
                                        Full sheet ↗
                                    </button>
                                </div>

                                {/* Stats row */}
                                <div style={{
                                    display: 'grid',
                                    gridTemplateColumns: 'repeat(2, 1fr)',
                                    gap: '1px',
                                    background: 'var(--border)',
                                    border: '1px solid var(--border)',
                                    marginBottom: '16px',
                                }}>
                                    {patronPreview.dutyName && (
                                        <div style={{background: 'var(--panel)', padding: '10px 14px'}}>
                                            <div style={{
                                                fontFamily: "'Barlow', sans-serif", fontSize: '9px',
                                                letterSpacing: '2px', textTransform: 'uppercase',
                                                color: 'var(--muted)', marginBottom: '3px',
                                            }}>Duty</div>
                                            <div style={{
                                                fontFamily: "'Barlow', sans-serif", fontSize: '13px',
                                                color: 'var(--ink)', fontWeight: 500,
                                            }}>{patronPreview.dutyName}</div>
                                            {patronPreview.dutyBoonName && (
                                                <div style={{
                                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                                    color: '#085d65', marginTop: '3px',
                                                }}>Boon: {patronPreview.dutyBoonName}</div>
                                            )}
                                        </div>
                                    )}
                                    {[
                                        {label: 'Motivation', value: patronPreview.motivationName},
                                        {label: 'Demeanour', value: patronPreview.demeanourName},
                                        {label: 'Pay Grade', value: patronPreview.payGradeName},
                                    ].filter(f => f.value).map(({label, value}) => (
                                        <div key={label} style={{background: 'var(--panel)', padding: '10px 14px'}}>
                                            <div style={{
                                                fontFamily: "'Barlow', sans-serif", fontSize: '9px',
                                                letterSpacing: '2px', textTransform: 'uppercase',
                                                color: 'var(--muted)', marginBottom: '3px',
                                            }}>{label}</div>
                                            <div style={{
                                                fontFamily: "'Barlow', sans-serif", fontSize: '13px',
                                                color: 'var(--ink)', fontWeight: 500,
                                            }}>{value}</div>
                                        </div>
                                    ))}
                                </div>

                                {/* Boons & Liabilities */}
                                {(patronPreview.boonNames?.length > 0 || patronPreview.liabilityNames?.length > 0) && (
                                    <div style={{display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '16px'}}>
                                        {patronPreview.boonNames?.length > 0 && (
                                            <div style={{
                                                background: 'rgba(8,93,101,0.06)',
                                                border: '1px solid rgba(8,93,101,0.2)',
                                                padding: '12px 16px',
                                            }}>
                                                <div style={{
                                                    fontFamily: "'Barlow', sans-serif", fontSize: '9px',
                                                    letterSpacing: '2px', textTransform: 'uppercase',
                                                    color: '#085d65', marginBottom: '8px',
                                                }}>Boons</div>
                                                {patronPreview.boonNames.map(n => (
                                                    <div key={n} style={{
                                                        fontFamily: "'EB Garamond', serif", fontSize: '14px',
                                                        color: 'var(--ink)', lineHeight: '1.8',
                                                        display: 'flex', gap: '8px', alignItems: 'baseline',
                                                    }}>
                                                        <span style={{color: '#085d65', fontSize: '12px'}}>+</span>{n}
                                                    </div>
                                                ))}
                                            </div>
                                        )}
                                        {patronPreview.liabilityNames?.length > 0 && (
                                            <div style={{
                                                background: 'rgba(120,60,60,0.06)',
                                                border: '1px solid rgba(120,60,60,0.2)',
                                                padding: '12px 16px',
                                            }}>
                                                <div style={{
                                                    fontFamily: "'Barlow', sans-serif", fontSize: '9px',
                                                    letterSpacing: '2px', textTransform: 'uppercase',
                                                    color: 'var(--muted)', marginBottom: '8px',
                                                }}>Liabilities</div>
                                                {patronPreview.liabilityNames.map(n => (
                                                    <div key={n} style={{
                                                        fontFamily: "'EB Garamond', serif", fontSize: '14px',
                                                        color: 'var(--ink)', lineHeight: '1.8',
                                                        display: 'flex', gap: '8px', alignItems: 'baseline',
                                                    }}>
                                                        <span style={{color: 'var(--muted)', fontSize: '12px'}}>−</span>{n}
                                                    </div>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                )}
                            </div>
                        </div>
                    )}

                    {/* Character selection (players only) */}
                    {user && !isGm && (
                        <div style={{
                            background: 'var(--panel)', border: '1px solid var(--border)',
                            padding: '24px 48px', boxShadow: '0 4px 28px var(--shadow)',
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                letterSpacing: '3px', textTransform: 'uppercase',
                                color: 'var(--muted)', marginBottom: '12px',
                            }}>
                                {myEntry?.characterName ? `Character: ${myEntry.characterName}` : 'Select your character'}
                            </div>
                            {myCharacters.length > 0 ? (
                                <select
                                    value=""
                                    onChange={e => handleSelectCharacter(e.target.value)}
                                    disabled={selectingChar}
                                    style={{
                                        width: '100%', padding: '12px 16px',
                                        background: 'var(--field-bg)', border: '1px solid var(--border)',
                                        color: 'var(--ink)', fontFamily: "'Barlow', sans-serif",
                                        fontSize: '15px', outline: 'none', cursor: 'pointer',
                                    }}
                                >
                                    <option value="">— {myEntry?.characterName ? 'change' : 'select'} —</option>
                                    {myCharacters.map(c => {
                                        const hasViolation = characterViolations(c.code).length > 0;
                                        return (
                                            <option key={c.code} value={c.code}>
                                                {hasViolation ? '⚠ ' : ''}{c.name}
                                            </option>
                                        );
                                    })}
                                </select>
                            ) : (
                                <span style={{fontFamily: "'Barlow', sans-serif", fontSize: '13px', color: 'var(--muted)'}}>
                                    No saved characters.{' '}
                                </span>
                            )}
                            {violations.length > 0 && (
                                <div style={{
                                    marginTop: '12px', padding: '12px 16px',
                                    background: 'rgba(180,40,40,0.12)', border: '1px solid rgba(180,40,40,0.5)',
                                }}>
                                    <div style={{
                                        fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                        letterSpacing: '2px', textTransform: 'uppercase',
                                        color: 'var(--red)', marginBottom: '8px',
                                    }}>
                                        Restricted content in this character
                                    </div>
                                    {violations.map(v => (
                                        <div key={v.label} style={{
                                            display: 'flex', gap: '12px', alignItems: 'baseline',
                                            fontFamily: "'Barlow', sans-serif", fontSize: '13px',
                                            color: 'var(--ink)', padding: '4px 0',
                                        }}>
                                            <span style={{
                                                color: 'var(--red)', fontSize: '10px',
                                                letterSpacing: '1px', textTransform: 'uppercase',
                                                minWidth: '52px', flexShrink: 0,
                                            }}>{v.label}</span>
                                            <span>{v.name}</span>
                                            <span style={{
                                                fontFamily: 'monospace', fontSize: '11px',
                                                letterSpacing: '2px', color: 'var(--red)',
                                            }}>[{v.sourceBook}]</span>
                                        </div>
                                    ))}
                                </div>
                            )}
                            <div style={{marginTop: '8px'}}>
                                <button
                                    onClick={handleCreateCharacter}
                                    style={{
                                        background: 'none', border: 'none', padding: 0,
                                        fontFamily: "'Barlow', sans-serif", fontSize: '12px',
                                        color: '#085d65', cursor: 'pointer', letterSpacing: '1px',
                                        textDecoration: 'underline',
                                    }}
                                >
                                    + Create a new character
                                </button>
                            </div>
                        </div>
                    )}

                    {/* Roster */}
                    <div style={{
                        background: 'var(--panel)', border: '1px solid var(--border)',
                        boxShadow: '0 4px 28px var(--shadow)',
                    }}>
                        <div style={{
                            padding: '18px 48px', borderBottom: '1px solid var(--border)',
                            display: 'flex', alignItems: 'center', justifyContent: 'space-between',
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                letterSpacing: '3px', textTransform: 'uppercase', color: 'var(--muted)',
                            }}>
                                Roster
                            </div>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                color: 'var(--muted)', letterSpacing: '1px',
                            }}>
                                {roster.filter(r => r.status === 'ACTIVE').length} active
                            </div>
                        </div>

                        {rosterError ? (
                            <div style={{padding: '40px 48px', color: 'var(--red)', fontFamily: "'Barlow', sans-serif", fontSize: '13px'}}>
                                {rosterError}
                            </div>
                        ) : roster.length === 0 ? (
                            <div style={{
                                padding: '48px', textAlign: 'center',
                                fontFamily: "'Barlow', sans-serif", fontSize: '12px',
                                letterSpacing: '2px', color: 'var(--muted)', textTransform: 'uppercase',
                            }}>
                                Loading…
                            </div>
                        ) : (
                            roster.map((entry, i) => (
                                <div key={entry.userId} style={{
                                    display: 'flex', alignItems: 'center', gap: '16px',
                                    padding: '16px 48px',
                                    borderBottom: i < roster.length - 1 ? '1px solid var(--border)' : 'none',
                                    opacity: entry.status !== 'ACTIVE' ? 0.45 : 1,
                                }}>
                                    <div style={{
                                        fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                        letterSpacing: '2px', textTransform: 'uppercase',
                                        color: entry.role === 'GM' ? 'var(--red)' : 'var(--muted)',
                                        width: '40px', flexShrink: 0,
                                    }}>
                                        {ROLE_LABEL[entry.role]}
                                    </div>
                                    <div style={{flex: 1, minWidth: 0}}>
                                        <div style={{
                                            fontFamily: "'Barlow', sans-serif", fontSize: '16px',
                                            color: STATUS_COLOR[entry.status] || 'var(--ink)',
                                            whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
                                        }}>
                                            {entry.username}
                                            {entry.userId === user?.id && (
                                                <span style={{fontSize: '11px', color: 'var(--muted)', marginLeft: '8px', letterSpacing: '1px'}}>you</span>
                                            )}
                                        </div>
                                        {entry.characterName && (
                                            <div style={{marginTop: '2px'}}>
                                                <div
                                                    onClick={() => entry.characterCode && navigate(`/character/${entry.characterCode}`, {
                                                        state: {
                                                            allowedSourceBooks: room?.sourceBooks,
                                                            originSourceBook: entry.originSourceBook,
                                                            factionSourceBook: entry.factionSourceBook,
                                                            roleSourceBook: entry.roleSourceBook,
                                                            webhookUrl: room?.webhookUrl || null,
                                                            patronCode: room?.patronCode || null,
                                                        }
                                                    })}
                                                    style={{
                                                        fontSize: '12px', color: 'var(--muted)',
                                                        fontFamily: "'Barlow', sans-serif",
                                                        cursor: entry.characterCode ? 'pointer' : 'default',
                                                        textDecoration: entry.characterCode ? 'underline' : 'none',
                                                        display: 'inline',
                                                    }}
                                                >
                                                    {entry.characterName}
                                                </div>
                                                {rosterViolations(entry).map(v => (
                                                    <span key={v.label} style={{
                                                        marginLeft: '8px',
                                                        padding: '1px 6px',
                                                        background: 'rgba(180,40,40,0.15)',
                                                        border: '1px solid rgba(180,40,40,0.5)',
                                                        fontFamily: "'Barlow', sans-serif",
                                                        fontSize: '10px', letterSpacing: '1px',
                                                        textTransform: 'uppercase', color: 'var(--red)',
                                                    }}>
                                                        {v.label} [{v.sourceBook}]
                                                    </span>
                                                ))}
                                            </div>
                                        )}
                                    </div>
                                    {entry.status !== 'ACTIVE' && (
                                        <div style={{
                                            fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                            letterSpacing: '2px', textTransform: 'uppercase',
                                            color: STATUS_COLOR[entry.status],
                                        }}>
                                            {entry.status.toLowerCase()}
                                        </div>
                                    )}
                                </div>
                            ))
                        )}
                    </div>

                </div>
            </main>
        </>
    );
}