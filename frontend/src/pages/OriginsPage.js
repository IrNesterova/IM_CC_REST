import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {getOrigins} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

export default function OriginsPage() {
    const [origins, setOrigins] = useState([]);
    const [selected, setSelected] = useState(null);
    const [secondaryChar, setSecondaryChar] = useState('');
    const [loading, setLoading] = useState(true);
    const navigate = useNavigate();
    const {ccm, dispatch} = useCharacter();

    useEffect(() => {
        getOrigins().then(data => {
            setOrigins(data);
            if (data.length > 0) {
                const saved = ccm.originId ? data.find(o => o.id === ccm.originId) : null;
                setSelected(saved || data[0]);
            }
        }).finally(() => setLoading(false));
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    useEffect(() => {
        if (selected && selected.secondaryCharacteristsics?.length > 0) {
            if (selected.id === ccm.originId && ccm.originSecondaryCharName) {
                setSecondaryChar(ccm.originSecondaryCharName);
            } else {
                setSecondaryChar(selected.secondaryCharacteristsics[0].name);
            }
        }
    }, [selected]); // eslint-disable-line react-hooks/exhaustive-deps

    const handleSelect = () => {
        if (!selected) return;

        const chars = {...ccm.characteristics};
        // undo previous origin bonuses before applying new ones
        (ccm.originPrimaryCharNames || '').split(', ').filter(Boolean).forEach(name => {
            if (chars[name]) chars[name] = String(parseInt(chars[name]) - 5);
        });
        if (ccm.originSecondaryCharName && chars[ccm.originSecondaryCharName]) {
            chars[ccm.originSecondaryCharName] = String(parseInt(chars[ccm.originSecondaryCharName]) - 5);
        }

        // Apply primary +5 bonuses
        const primaryNames = (selected.primaryCharacteristsics || []).map(c => c.name).join(', ');
        (selected.primaryCharacteristsics || []).forEach(c => {
            if (chars[c.name]) chars[c.name] = String(parseInt(chars[c.name]) + 5);
        });

        // Apply secondary +5 bonus
        if (secondaryChar && chars[secondaryChar]) {
            chars[secondaryChar] = String(parseInt(chars[secondaryChar]) + 5);
        }

        const charBonuses = [
            ...(selected.primaryCharacteristsics || []).map(c => `+5 ${c.name}`),
            ...(secondaryChar ? [`+5 ${secondaryChar} (chosen)`] : []),
        ].join(', ');

        dispatch({
            type: 'SET_ORIGIN',
            payload: {
                originId: selected.id,
                originPrimaryCharNames: primaryNames,
                originSecondaryCharName: secondaryChar,
                characteristics: chars,
                _originName: selected.name,
                _originCharBonuses: charBonuses,
            },
        });
        navigate('/factions');
    };

    if (loading) return (
        <><ProgressBar/><Topbar/>
            <div style={{display:'flex',justifyContent:'center',alignItems:'center',minHeight:'60vh',color:'var(--muted)',fontFamily:"'Barlow',sans-serif",fontSize:'13px',letterSpacing:'3px'}}>
                Loading origins…
            </div>
        </>
    );

    return (
        <>
            <ProgressBar/>
            <Topbar/>
            <div style={{
                display: 'grid',
                gridTemplateColumns: '320px 1fr',
                minHeight: 'calc(100vh - 100px)',
                background: 'var(--bg)'
            }}>

                {/* Left nav */}
                <nav style={{borderRight: '1px solid var(--border)', background: 'var(--bg)'}}>
                    <div
                        style={{position: 'sticky', top: '100px', overflowY: 'auto', maxHeight: 'calc(100vh - 100px)'}}>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif",
                            fontSize: '12px',
                            textTransform: 'uppercase',
                            letterSpacing: '3px',
                            color: 'var(--muted)',
                            padding: '18px 24px 14px',
                            borderBottom: '1px solid var(--border)'
                        }}>
                            Choose Origin
                        </div>
                        {origins.map(o => (
                            <div
                                key={o.id}
                                onClick={() => setSelected(o)}
                                style={{
                                    display: 'flex',
                                    alignItems: 'center',
                                    gap: '14px',
                                    padding: '14px 24px',
                                    cursor: 'pointer',
                                    borderLeft: `3px solid ${selected?.id === o.id ? 'var(--red)' : 'transparent'}`,
                                    background: selected?.id === o.id ? 'rgba(var(--accent-rgb),0.07)' : 'transparent',
                                    transition: '0.15s',
                                }}
                            >
                                <div style={{
                                    width: '9px',
                                    height: '9px',
                                    borderRadius: '50%',
                                    background: selected?.id === o.id ? 'var(--red)' : 'var(--border-strong)',
                                    flexShrink: 0
                                }}/>
                                <div>
                                    <div style={{
                                        fontFamily: "'Barlow', sans-serif",
                                        fontSize: '15px',
                                        color: selected?.id === o.id ? 'var(--red)' : 'var(--ink)'
                                    }}>{o.name}</div>
                                    <div style={{display: 'flex', gap: '4px', marginTop: '5px', flexWrap: 'wrap'}}>
                                        {(o.primaryCharacteristsics || []).map(c => (
                                            <span key={c.id} style={{
                                                fontFamily: "'Barlow', sans-serif",
                                                fontSize: '11px',
                                                letterSpacing: '1px',
                                                color: 'var(--muted)',
                                                background: 'rgba(var(--accent-rgb),0.06)',
                                                padding: '2px 7px'
                                            }}>{c.name}</span>
                                        ))}
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>
                </nav>

                {/* Right detail */}
                <div style={{
                    display: 'flex',
                    justifyContent: 'center',
                    alignItems: 'flex-start',
                    padding: '40px 32px 80px',
                    background: 'var(--panel)'
                }}>
                    {selected && (
                        <div style={{
                            display: 'flex',
                            flexDirection: 'column',
                            gap: '24px',
                            width: '100%',
                            maxWidth: '720px'
                        }}>
                            <div style={{
                                fontFamily: "'Barlow', sans-serif",
                                fontSize: '32px',
                                color: 'var(--ink)',
                                lineHeight: '1.1'
                            }}>{selected.name}</div>

                            {selected.description && (
                                <div style={{display: 'flex', flexDirection: 'column', gap: '10px'}}>
                                    <SectionTitle>Background</SectionTitle>
                                    <Description>{selected.description}</Description>
                                </div>
                            )}

                            {selected.examples && (
                                <div style={{display: 'flex', flexDirection: 'column', gap: '10px'}}>
                                    <SectionTitle>Examples</SectionTitle>
                                    <Description>{selected.examples}</Description>
                                </div>
                            )}

                            <div style={{display: 'flex', flexDirection: 'column', gap: '10px'}}>
                                <SectionTitle>Characteristic Bonuses</SectionTitle>
                                <div style={{display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '8px'}}>
                                    {(selected.primaryCharacteristsics || []).map((c, i, arr) => (
                                        <span key={c.id} style={{display: 'flex', alignItems: 'center', gap: '5px'}}>
                      <span style={{
                          display: 'inline-flex',
                          alignItems: 'center',
                          gap: '8px',
                          padding: '8px 16px',
                          border: '1px solid var(--border-strong)',
                          background: 'rgba(var(--accent-rgb),0.05)',
                          fontSize: '18px',
                          color: 'var(--ink)'
                      }}>
                        {c.full_name} <span
                          style={{fontFamily: "'Barlow', sans-serif", fontSize: '14px', color: 'var(--red)'}}>+5</span>
                      </span>
                                            {i < arr.length - 1 && <span style={{
                                                fontSize: '13px',
                                                color: 'var(--muted)',
                                                fontStyle: 'italic'
                                            }}>and</span>}
                    </span>
                                    ))}
                                </div>
                                {selected.secondaryCharacteristsics?.length > 0 && (
                                    <div style={{marginTop: '4px'}}>
                                        <span style={{
                                            fontFamily: "'Barlow', sans-serif",
                                            fontSize: '12px',
                                            color: 'var(--ink)',
                                            textTransform: 'uppercase',
                                            letterSpacing: '2px',
                                            display: 'block',
                                            marginBottom: '8px'
                                        }}>Choose one additional +5</span>
                                        <div style={{position: 'relative', display: 'inline-block'}}>
                                            <select
                                                value={secondaryChar}
                                                onChange={e => setSecondaryChar(e.target.value)}
                                                style={{
                                                    appearance: 'none',
                                                    padding: '8px 28px 8px 12px',
                                                    border: '1px solid var(--border-strong)',
                                                    background: 'var(--field-bg)',
                                                    color: 'var(--ink)',
                                                    fontFamily: "'Barlow', sans-serif",
                                                    fontSize: '18px',
                                                    outline: 'none',
                                                    minWidth: '200px'
                                                }}
                                            >
                                                {selected.secondaryCharacteristsics.map(c => (
                                                    <option key={c.id} value={c.name}>{c.full_name}</option>
                                                ))}
                                            </select>
                                            <span style={{
                                                position: 'absolute',
                                                right: '10px',
                                                top: '50%',
                                                transform: 'translateY(-50%)',
                                                pointerEvents: 'none',
                                                color: 'var(--ink)'
                                            }}>▾</span>
                                        </div>
                                    </div>
                                )}
                            </div>

                            <button onClick={handleSelect} className="select-btn" style={{width: '100%'}}>Select
                                Origin
                            </button>
                        </div>
                    )}
                </div>
            </div>
        </>
    );
}

function SectionTitle({children}) {
    return (
        <div style={{
            fontFamily: "'Barlow', sans-serif",
            color: 'var(--ink)',
            textTransform: 'uppercase',
            letterSpacing: '3px',
            fontSize: '15px',
            display: 'flex',
            alignItems: 'center',
            gap: '10px'
        }}>
            {children}
            <span style={{flex: 1, height: '1px', background: 'var(--border)'}}/>
        </div>
    );
}

function Description({children}) {
    return (
        <div style={{
            color: 'var(--ink)',
            fontSize: '18px',
            lineHeight: '1.7',
            background: 'var(--panel)',
            padding: '14px 18px',
            borderLeft: '2px solid var(--border-strong)'
        }}>
            {children}
        </div>
    );
}
