import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {getCharacteristics} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

const POOL_TOTAL = 90;
const BASE_VAL = 20;
const MIN_VAL = 24;
const MAX_VAL = 38;

export default function CharacteristicsPage() {
    const [chars, setChars] = useState([]);
    const [values, setValues] = useState({});
    const [mode, setMode] = useState('manual');
    const navigate = useNavigate();
    const {ccm, dispatch} = useCharacter();

    useEffect(() => {
        getCharacteristics().then(data => {
            setChars(data);
            const init = {};
            data.forEach(c => {
                init[c.name] = ccm.characteristics[c.name] || String(MIN_VAL);
            });
            setValues(init);
        });
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const remaining = POOL_TOTAL - chars.reduce((s, c) => s + (parseInt(values[c.name] || 0) - BASE_VAL), 0);

    const adjust = (name, delta) => {
        const cur = parseInt(values[name] || MIN_VAL);
        if (mode === 'manual') {
            setValues(v => ({...v, [name]: String(cur + delta)}));
        } else if (mode === 'points') {
            if (delta > 0 && (cur >= MAX_VAL || remaining <= 0)) return;
            if (delta < 0 && cur <= MIN_VAL) return;
            setValues(v => ({...v, [name]: String(cur + delta)}));
        }
    };

    const rollAll = () => {
        const next = {};
        chars.forEach(c => {
            next[c.name] = String(Math.floor(Math.random() * 10) + 1 + Math.floor(Math.random() * 10) + 1 + 20);
        });
        setValues(next);
    };

    const resetPool = () => {
        const next = {};
        chars.forEach(c => {
            next[c.name] = String(MIN_VAL);
        });
        setValues(next);
    };

    const handleSubmit = () => {
        dispatch({type: 'SET_CHARACTERISTICS', payload: values});
        navigate('/origins');
    };

    return (
        <>
            <ProgressBar/>
            <Topbar/>
            <div className="content-bg" style={{
                flex: 1,
                background: 'var(--bg)',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                padding: '0 32px'
            }}>
                <div style={{width: '100%', maxWidth: '860px', padding: '40px 0 80px'}}>
                    <div style={{
                        fontFamily: "'Barlow', sans-serif",
                        fontSize: '32px',
                        color: 'var(--ink)',
                        marginBottom: '6px'
                    }}>Characteristics
                    </div>
                    <div style={{fontSize: '18px', color: 'var(--muted)', fontStyle: 'italic', marginBottom: '28px'}}>
                        Strength, faith, cunning and willpower — determine your survival in the darkness of the
                        Imperium.
                    </div>

                    <div style={{
                        background: 'var(--panel)',
                        border: '1px solid var(--border)',
                        padding: '28px',
                        boxShadow: '0 2px 16px var(--shadow)',
                        position: 'relative'
                    }}>
                        <div style={{
                            position: 'absolute',
                            top: 0,
                            left: 0,
                            width: '100%',
                            height: '3px',
                            background: 'linear-gradient(90deg, transparent, var(--red), transparent)'
                        }}/>

                        {/* Methods */}
                        <div style={{
                            display: 'grid',
                            gridTemplateColumns: 'repeat(3, 1fr)',
                            gap: '20px',
                            marginBottom: '36px'
                        }}>
                            {[
                                {
                                    key: 'manual',
                                    title: 'Manual Assignment',
                                    desc: 'Freely edit characteristics without restrictions.'
                                },
                                {key: 'roll', title: 'Random Roll', desc: 'Roll 2d10 + 20 for every characteristic.'},
                                {
                                    key: 'points',
                                    title: '90 Point Pool',
                                    desc: 'Base value is 20. Minimum final value is 24.'
                                },
                            ].map(m => (
                                <div
                                    key={m.key}
                                    onClick={() => {
                                        setMode(m.key);
                                        if (m.key === 'roll') rollAll();
                                        if (m.key === 'points') resetPool();
                                    }}
                                    style={{
                                        padding: '14px 18px',
                                        border: `1px solid ${mode === m.key ? 'var(--red)' : 'var(--border)'}`,
                                        background: mode === m.key ? 'rgba(var(--accent-rgb),0.06)' : 'rgba(var(--surface-rgb),0.3)',
                                        cursor: 'pointer',
                                        transition: '0.2s ease',
                                    }}
                                >
                                    <div style={{
                                        fontFamily: "'Barlow', sans-serif",
                                        color: 'var(--red)',
                                        fontSize: '18px',
                                        marginBottom: '6px'
                                    }}>{m.title}</div>
                                    <div style={{
                                        color: 'var(--muted)',
                                        fontSize: '18px',
                                        lineHeight: '1.55'
                                    }}>{m.desc}</div>
                                </div>
                            ))}
                        </div>

                        {/* Points counter */}
                        <div style={{
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'space-between',
                            padding: '12px 20px',
                            marginBottom: '20px',
                            border: '1px solid var(--border)',
                            background: 'rgba(var(--accent-rgb),0.05)'
                        }}>
                            <div style={{color: 'var(--red)', fontSize: '18px'}}>Remaining Points</div>
                            <div style={{fontFamily: "'Barlow', sans-serif", color: 'var(--ink)', fontSize: '28px'}}>
                                {mode === 'manual' ? 'FREE' : mode === 'roll' ? '—' : remaining}
                            </div>
                        </div>

                        {/* Characteristics list */}
                        <div style={{display: 'flex', flexDirection: 'column', gap: '8px'}}>
                            {chars.map(c => (
                                <div key={c.id} style={{
                                    border: '1px solid var(--border)',
                                    background: 'rgba(var(--surface-rgb),0.35)'
                                }}>
                                    <div style={{
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'space-between',
                                        gap: '16px',
                                        padding: '10px 16px'
                                    }}>
                                        <div style={{flex: 1}}>
                                            <div style={{
                                                fontFamily: "'Barlow', sans-serif",
                                                color: 'var(--ink)',
                                                fontSize: '18px',
                                                marginBottom: '2px'
                                            }}>{c.full_name}</div>
                                            <div style={{color: 'var(--muted)', fontSize: '18px'}}>{c.description}</div>
                                        </div>
                                        <div
                                            style={{display: 'flex', alignItems: 'center', gap: '12px', flexShrink: 0}}>
                                            <button onClick={() => adjust(c.name, -1)} style={{
                                                width: '36px',
                                                height: '36px',
                                                border: '1px solid var(--red-dark)',
                                                cursor: 'pointer',
                                                fontSize: '20px',
                                                color: 'var(--on-accent)',
                                                background: 'var(--red)'
                                            }}>−
                                            </button>
                                            <input
                                                type="number"
                                                value={values[c.name] || MIN_VAL}
                                                onChange={e => setValues(v => ({...v, [c.name]: e.target.value}))}
                                                style={{
                                                    width: '64px',
                                                    textAlign: 'center',
                                                    fontFamily: "'Barlow', sans-serif",
                                                    fontSize: '22px',
                                                    color: 'var(--ink)',
                                                    padding: '5px 0',
                                                    border: '1px solid var(--border-strong)',
                                                    background: 'var(--field-bg)',
                                                    outline: 'none'
                                                }}
                                            />
                                            <button onClick={() => adjust(c.name, 1)} style={{
                                                width: '36px',
                                                height: '36px',
                                                border: '1px solid var(--red-dark)',
                                                cursor: 'pointer',
                                                fontSize: '20px',
                                                color: 'var(--on-accent)',
                                                background: 'var(--red)'
                                            }}>+
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>

                        <div style={{display: 'flex', justifyContent: 'flex-end', marginTop: '36px'}}>
                            <button onClick={handleSubmit} className="submit-btn">Continue Character Creation</button>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
