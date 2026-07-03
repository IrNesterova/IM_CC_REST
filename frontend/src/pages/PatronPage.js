import {useEffect, useRef, useState} from 'react';
import {useNavigate, useSearchParams} from 'react-router-dom';
import {getPatronReference, loadPatron, savePatron} from '../api/api';
import Topbar from '../components/Topbar';

/* ── Shared style constants ── */
const SECTION = {
    fontFamily: "'Barlow', sans-serif",
    fontSize: '13px',
    fontWeight: 700,
    letterSpacing: '3px',
    textTransform: 'uppercase',
    color: '#085d65',
};

const FIELD_LABEL = {
    fontFamily: "'Barlow', sans-serif",
    fontSize: '11px',
    fontWeight: 700,
    letterSpacing: '2px',
    textTransform: 'uppercase',
    color: 'var(--muted)',
    marginBottom: '4px',
};

const ROLL_BTN = {
    fontFamily: "'Barlow', sans-serif",
    fontSize: '11px',
    fontWeight: 700,
    letterSpacing: '2px',
    textTransform: 'uppercase',
    background: 'transparent',
    border: '1px solid #085d65',
    color: '#085d65',
    padding: '5px 14px',
    cursor: 'pointer',
};

const INPUT_STYLE = {
    width: '100%',
    background: 'var(--field-bg)',
    border: 'none',
    borderBottom: '1px solid var(--border-strong)',
    color: 'var(--ink)',
    fontFamily: "'Barlow', sans-serif",
    fontSize: '15px',
    padding: '6px 8px',
    outline: 'none',
};

function rand(arr) {
    return arr[Math.floor(Math.random() * arr.length)];
}

/* ── Builder panel wrapper ── */
function PickerPanel({title, rollLabel, onRoll, children, style}) {
    return (
        <div style={{
            background: 'var(--panel)',
            border: '1px solid var(--border)',
            padding: '18px 20px',
            flex: 1,
            minWidth: 0,
            ...style,
        }}>
            <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '10px'}}>
                <span style={SECTION}>{title}</span>
                {onRoll && (
                    <button style={ROLL_BTN} onClick={onRoll}>
                        {rollLabel || 'Roll'}
                    </button>
                )}
            </div>
            {children}
        </div>
    );
}

/* ── Radio-style item list (single select) ── */
function RadioList({items, selected, onSelect, renderLabel, emptyText}) {
    if (items.length === 0) {
        return (
            <div style={{color: 'var(--muted)', fontFamily: "'Barlow', sans-serif", fontSize: '13px', fontStyle: 'italic', padding: '6px'}}>
                {emptyText || 'No data'}
            </div>
        );
    }
    return (
        <div style={{display: 'flex', flexDirection: 'column', gap: '5px'}}>
            {items.map(item => {
                const active = selected?.id === item.id;
                return (
                    <button
                        key={item.id}
                        onClick={() => onSelect(active ? null : item)}
                        style={{
                            background: active ? 'rgba(8,93,101,0.12)' : 'transparent',
                            border: active ? '1px solid #085d65' : '1px solid var(--border)',
                            color: active ? '#085d65' : 'var(--ink)',
                            fontFamily: "'Barlow', sans-serif",
                            fontSize: '14px',
                            padding: '7px 12px',
                            textAlign: 'left',
                            cursor: 'pointer',
                        }}
                    >
                        {renderLabel ? renderLabel(item) : item.name}
                    </button>
                );
            })}
        </div>
    );
}

/* ── Checkbox list (multi select, max N) ── */
function CheckList({items, selected, onToggle, max, searchValue, onSearch}) {
    const filtered = searchValue
        ? items.filter(i => i.name.toLowerCase().includes(searchValue.toLowerCase()))
        : items;

    return (
        <div>
            {onSearch && (
                <input
                    value={searchValue}
                    onChange={e => onSearch(e.target.value)}
                    placeholder="Search…"
                    style={{...INPUT_STYLE, marginBottom: '8px', fontSize: '13px', padding: '7px 10px'}}
                />
            )}
            <div style={{maxHeight: '280px', overflowY: 'auto', display: 'flex', flexDirection: 'column', gap: '3px'}}>
                {filtered.length === 0 && (
                    <div style={{color: 'var(--muted)', fontFamily: "'Barlow', sans-serif", fontSize: '13px', padding: '8px', fontStyle: 'italic'}}>
                        No entries
                    </div>
                )}
                {filtered.map(item => {
                    const active = selected.some(s => s.id === item.id);
                    const disabled = !active && max !== undefined && selected.length >= max;
                    return (
                        <button
                            key={item.id}
                            onClick={() => !disabled && onToggle(item)}
                            style={{
                                background: active ? 'rgba(8,93,101,0.12)' : 'transparent',
                                border: active ? '1px solid #085d65' : '1px solid var(--border)',
                                color: active ? '#085d65' : disabled ? 'var(--muted)' : 'var(--ink)',
                                fontFamily: "'Barlow', sans-serif",
                                fontSize: '13px',
                                padding: '6px 10px',
                                textAlign: 'left',
                                cursor: disabled ? 'default' : 'pointer',
                                opacity: disabled ? 0.5 : 1,
                            }}
                        >
                            <span style={{marginRight: '6px', color: active ? '#085d65' : 'var(--muted)'}}>{active ? '✓' : '○'}</span>
                            {item.name}
                        </button>
                    );
                })}
            </div>
        </div>
    );
}

/* ── Sheet components ── */
function SheetField({label, value, style}) {
    return (
        <div style={{flex: 1, ...style}}>
            <div style={FIELD_LABEL}>{label}</div>
            <div style={{
                borderBottom: '1px solid var(--border-strong)',
                minHeight: '26px',
                padding: '3px 6px',
                fontFamily: "'Barlow', sans-serif",
                fontSize: '15px',
                color: value ? 'var(--ink)' : 'var(--muted)',
                fontStyle: value ? 'normal' : 'italic',
            }}>
                {value || '—'}
            </div>
        </div>
    );
}

function SheetDivider({label}) {
    return (
        <div style={{display: 'flex', alignItems: 'center', gap: '10px', margin: '18px 0 10px'}}>
            <div style={{flex: 1, height: '1px', background: 'var(--border-strong)'}}/>
            <span style={{...SECTION, fontSize: '11px'}}>{label}</span>
            <div style={{flex: 1, height: '1px', background: 'var(--border-strong)'}}/>
        </div>
    );
}

function SheetBlock({item, accent}) {
    if (!item) return null;
    return (
        <div style={{marginBottom: '12px'}}>
            <div style={{
                fontFamily: "'Cinzel', serif",
                fontSize: '14px',
                fontWeight: 700,
                color: accent || '#085d65',
                marginBottom: '6px',
                letterSpacing: '0.5px',
            }}>
                {item.name}
            </div>
            <div style={{
                fontFamily: "'EB Garamond', serif",
                fontSize: '15px',
                color: 'var(--text)',
                lineHeight: '1.6',
            }}>
                {item.description}
            </div>
        </div>
    );
}

function DutyBoonBlock({dutyBoonName, dutyBoonDescription}) {
    if (!dutyBoonName) return null;
    return (
        <div style={{
            marginTop: '10px',
            paddingTop: '10px',
            borderTop: '1px solid var(--border)',
        }}>
            <div style={{
                ...FIELD_LABEL,
                fontSize: '11px',
                marginBottom: '6px',
            }}>
                Duty Boon
            </div>
            <div style={{
                fontFamily: "'Cinzel', serif",
                fontSize: '14px',
                fontWeight: 700,
                color: '#085d65',
                marginBottom: '6px',
            }}>
                {dutyBoonName}
            </div>
            <div style={{
                fontFamily: "'EB Garamond', serif",
                fontSize: '15px',
                color: 'var(--text)',
                lineHeight: '1.6',
            }}>
                {dutyBoonDescription}
            </div>
        </div>
    );
}

/* ══════════════════════════════════════════════════════════
   PATRON PAGE
══════════════════════════════════════════════════════════ */
export default function PatronPage() {
    const navigate = useNavigate();
    const [searchParams, setSearchParams] = useSearchParams();
    const sheetRef = useRef(null);

    const [refData, setRefData] = useState({
        factions: [], motivations: [], demeanours: [], paymentGrades: [], duties: [],
    });
    const [loading, setLoading] = useState(true);
    const [saveCode, setSaveCode] = useState(searchParams.get('code') || null);
    const [saving, setSaving] = useState(false);
    const [saveFlash, setSaveFlash] = useState('');

    /* builder state */
    const [patronName, setPatronName] = useState('');
    const [selectedFaction, setSelectedFaction] = useState(null);
    const [factionText, setFactionText] = useState('');
    const [motivation, setMotivation] = useState(null);
    const [demeanour, setDemeanour] = useState(null);
    const [payGrade, setPayGrade] = useState(null);
    const [duty, setDuty] = useState(null);
    const [boons, setBoons] = useState([]);
    const [liabilities, setLiabilities] = useState([]);
    const [boonSearch, setBoonSearch] = useState('');
    const [liabilitySearch, setLiabilitySearch] = useState('');

    /* sheet-only editable state */
    const [influenceRows, setInfluenceRows] = useState(() =>
        Array(10).fill(null).map(() => ({faction: '', infl: '', contacts: '', intel: ''}))
    );
    const [notes, setNotes] = useState('');

    /* load refData, then optionally restore saved patron */
    useEffect(() => {
        const code = searchParams.get('code');
        getPatronReference().then(data => {
            setRefData(data);
            if (code) {
                loadPatron(code).then(raw => {
                    const p = typeof raw === 'string' ? JSON.parse(raw) : raw;
                    setPatronName(p.patronName || '');
                    setFactionText(p.factionText || '');
                    const faction = data.factions.find(f => f.id === p.factionId) || null;
                    setSelectedFaction(faction);
                    setMotivation(data.motivations.find(m => m.id === p.motivationId) || null);
                    setDemeanour(data.demeanours.find(d => d.id === p.demeanourId) || null);
                    setPayGrade(data.paymentGrades.find(g => g.id === p.paymentGradeId) || null);
                    const loadedDuty = data.duties.find(d => d.id === p.dutyId) || null;
                    setDuty(loadedDuty);
                    setBoons(loadedDuty ? (loadedDuty.boons || []).filter(b => (p.boonIds || []).includes(b.id)) : []);
                    setLiabilities(loadedDuty ? (loadedDuty.liabilities || []).filter(l => (p.liabilityIds || []).includes(l.id)) : []);
                    if (p.influenceRows) setInfluenceRows(p.influenceRows);
                    setNotes(p.notes || '');
                    setSaveCode(code);
                }).catch(() => {});
            }
            setLoading(false);
        }).catch(() => setLoading(false));
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const handleSave = async () => {
        setSaving(true);
        try {
            const payload = JSON.stringify({
                patronName,
                factionId: selectedFaction?.id || null,
                factionText,
                motivationId: motivation?.id || null,
                motivationName: motivation?.name || null,
                demeanourId: demeanour?.id || null,
                demeanourName: demeanour?.name || null,
                paymentGradeId: payGrade?.id || null,
                payGradeName: payGrade ? `${payGrade.name} — ${payGrade.payPerDay}₪/day` : null,
                dutyId: duty?.id || null,
                dutyName: duty?.name || null,
                dutyBoonName: duty?.dutyBoonName || null,
                boonIds: boons.map(b => b.id),
                boonNames: boons.map(b => b.name),
                liabilityIds: liabilities.map(l => l.id),
                liabilityNames: liabilities.map(l => l.name),
                influenceRows,
                notes,
            });
            const result = await savePatron(payload, saveCode);
            setSaveCode(result.code);
            setSearchParams({code: result.code}, {replace: true});
            setSaveFlash(result.code);
            setTimeout(() => setSaveFlash(''), 3000);
        } catch (e) {
            console.error('Failed to save patron', e);
        } finally {
            setSaving(false);
        }
    };

    const handleSelectFaction = (f) => {
        setSelectedFaction(f);
        setFactionText(f ? f.name : '');
        setDuty(null);
        setBoons([]);
        setLiabilities([]);
    };

    const handleSelectDuty = (d) => {
        setDuty(d);
        setBoons([]);
        setLiabilities([]);
    };

    const factionDuties = selectedFaction
        ? refData.duties.filter(d => d.factionId === selectedFaction.id)
        : [];

    /* ── Roll helpers ── */
    const rollMotivation = () => refData.motivations.length && setMotivation(rand(refData.motivations));

    const rollDemeanour = () => {
        if (!refData.demeanours.length) return;
        const roll = Math.floor(Math.random() * 10) + 1;
        const d = refData.demeanours.find(x => roll >= x.rollMin && roll <= x.rollMax);
        setDemeanour(d || rand(refData.demeanours));
    };

    const rollPayGrade = () => refData.paymentGrades.length && setPayGrade(rand(refData.paymentGrades));

    const rollDuty = () => factionDuties.length && handleSelectDuty(rand(factionDuties));

    const rollBoons = () => {
        const pool = duty?.boons ?? [];
        if (!pool.length) return;
        setBoons(prev => [...prev, rand(pool.filter(b => !prev.some(p => p.id === b.id)))].filter(Boolean));
    };

    const rollLiabilities = () => {
        const pool = duty?.liabilities ?? [];
        if (!pool.length) return;
        setLiabilities(prev => {
            const available = pool.filter(l => !prev.some(p => p.id === l.id));
            if (!available.length) return prev;
            return [...prev, rand(available)];
        });
    };

    const rollAll = () => {
        rollMotivation();
        rollDemeanour();
        rollPayGrade();
        const newDuty = factionDuties.length ? rand(factionDuties) : null;
        if (newDuty) {
            setDuty(newDuty);
            const boon = newDuty.boons?.length ? rand(newDuty.boons) : null;
            if (boon) {
                setBoons([boon]);
                const liability = newDuty.liabilities?.length ? rand(newDuty.liabilities) : null;
                if (liability) setLiabilities([liability]);
            } else {
                setBoons([]);
                setLiabilities([]);
            }
        }
    };

    const toggleBoon = (b) => {
        setBoons(prev => {
            const removing = prev.some(x => x.id === b.id);
            const next = removing ? prev.filter(x => x.id !== b.id) : [...prev, b];
            if (removing) setLiabilities(l => l.slice(0, next.length));
            return next;
        });
    };

    const toggleLiability = (l) => setLiabilities(prev =>
        prev.some(x => x.id === l.id) ? prev.filter(x => x.id !== l.id) : [...prev, l]
    );

    const updateInfluenceRow = (i, field, val) =>
        setInfluenceRows(prev => prev.map((r, idx) => idx === i ? {...r, [field]: val} : r));

    if (loading) {
        return (
            <>
                <Topbar/>
                <main style={{flex: 1, display: 'flex', alignItems: 'center', justifyContent: 'center', background: 'var(--bg)'}}>
                    <span style={{fontFamily: "'Barlow', sans-serif", color: 'var(--muted)', letterSpacing: '3px', fontSize: '14px', textTransform: 'uppercase'}}>
                        Loading…
                    </span>
                </main>
            </>
        );
    }

    return (
        <>
            <Topbar/>
            <main style={{flex: 1, background: 'var(--bg)', padding: '40px 24px 80px'}}>
                <div style={{maxWidth: '1100px', margin: '0 auto'}}>

                    {/* ── Page header ── */}
                    <div style={{display: 'flex', alignItems: 'baseline', justifyContent: 'space-between', marginBottom: '28px'}}>
                        <div>
                            <div style={{
                                fontFamily: "'Cinzel', serif",
                                fontSize: '26px',
                                fontWeight: 700,
                                color: '#085d65',
                                letterSpacing: '2px',
                                textTransform: 'uppercase',
                            }}>
                                Patron Generator
                            </div>
                            <div style={{fontFamily: "'Barlow', sans-serif", fontSize: '14px', color: 'var(--muted)', letterSpacing: '1px', marginTop: '4px'}}>
                                Imperium Maledictum — Core Rulebook
                            </div>
                        </div>
                        <div style={{display: 'flex', gap: '8px', alignItems: 'center'}}>
                            <button onClick={() => navigate('/')} style={{...ROLL_BTN, borderColor: 'var(--border-strong)', color: 'var(--muted)'}}>
                                ← Back
                            </button>
                            <button onClick={rollAll} style={{
                                ...ROLL_BTN,
                                background: '#085d65',
                                color: 'var(--on-accent)',
                                borderColor: '#085d65',
                                padding: '5px 18px',
                            }}>
                                Roll All
                            </button>
                            <button onClick={handleSave} disabled={saving} style={{
                                ...ROLL_BTN,
                                background: saving ? 'var(--panel)' : 'transparent',
                                borderColor: '#085d65',
                                color: '#085d65',
                                padding: '5px 18px',
                                opacity: saving ? 0.6 : 1,
                            }}>
                                {saving ? 'Saving…' : saveCode ? 'Update' : 'Save'}
                            </button>
                            {saveFlash && (
                                <div style={{
                                    fontFamily: "'Barlow', sans-serif",
                                    fontSize: '13px',
                                    letterSpacing: '3px',
                                    color: '#085d65',
                                    fontWeight: 700,
                                    padding: '4px 10px',
                                    border: '1px solid #085d65',
                                    background: 'rgba(8,93,101,0.08)',
                                }}>
                                    {saveFlash}
                                </div>
                            )}
                            {saveCode && !saveFlash && (
                                <div style={{
                                    fontFamily: "'Barlow', sans-serif",
                                    fontSize: '11px',
                                    letterSpacing: '2px',
                                    color: 'var(--muted)',
                                }}>
                                    {saveCode}
                                </div>
                            )}
                        </div>
                    </div>

                    {/* ── Patron Name ── */}
                    <div style={{marginBottom: '16px'}}>
                        <div style={FIELD_LABEL}>Patron Name</div>
                        <input
                            value={patronName}
                            onChange={e => setPatronName(e.target.value)}
                            placeholder="e.g. Inquisitor Valdris Orthen"
                            style={{...INPUT_STYLE, fontSize: '16px', padding: '8px 10px'}}
                        />
                    </div>

                    {/* ── Faction selector ── */}
                    <div style={{
                        background: 'var(--panel)',
                        border: '1px solid var(--border)',
                        padding: '18px 20px',
                        marginBottom: '14px',
                    }}>
                        <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '12px'}}>
                            <span style={SECTION}>Faction</span>
                            {selectedFaction && (
                                <button onClick={() => handleSelectFaction(null)}
                                        style={{...ROLL_BTN, borderColor: 'var(--border)', color: 'var(--muted)'}}>
                                    Clear
                                </button>
                            )}
                        </div>
                        <div style={{display: 'flex', flexWrap: 'wrap', gap: '8px', marginBottom: '12px'}}>
                            {refData.factions.map(f => {
                                const active = selectedFaction?.id === f.id;
                                return (
                                    <button key={f.id}
                                            onClick={() => handleSelectFaction(active ? null : f)}
                                            style={{
                                                background: active ? 'rgba(8,93,101,0.12)' : 'transparent',
                                                border: active ? '1px solid #085d65' : '1px solid var(--border)',
                                                color: active ? '#085d65' : 'var(--ink)',
                                                fontFamily: "'Barlow', sans-serif",
                                                fontSize: '13px',
                                                padding: '7px 14px',
                                                cursor: 'pointer',
                                                letterSpacing: '0.5px',
                                            }}>
                                        {f.name}
                                    </button>
                                );
                            })}
                        </div>
                        <div style={{...FIELD_LABEL, marginBottom: '5px'}}>Custom / override</div>
                        <input
                            value={factionText}
                            onChange={e => setFactionText(e.target.value)}
                            placeholder="Type a custom faction name…"
                            style={{...INPUT_STYLE}}
                        />
                    </div>

                    {/* ── Attribute pickers row 1: Motivation / Demeanour / Pay Grade ── */}
                    <div style={{display: 'flex', gap: '12px', marginBottom: '12px'}}>
                        <PickerPanel title="Motivation" rollLabel="Roll d5" onRoll={rollMotivation}>
                            <RadioList
                                items={refData.motivations}
                                selected={motivation}
                                onSelect={setMotivation}
                            />
                        </PickerPanel>

                        <PickerPanel title="Demeanour" rollLabel="Roll d10" onRoll={rollDemeanour}>
                            <RadioList
                                items={refData.demeanours}
                                selected={demeanour}
                                onSelect={setDemeanour}
                                renderLabel={d => `${d.name} (${d.rollMin}–${d.rollMax})`}
                            />
                        </PickerPanel>

                        <PickerPanel title="Pay Grade" rollLabel="Roll" onRoll={rollPayGrade}>
                            <RadioList
                                items={refData.paymentGrades}
                                selected={payGrade}
                                onSelect={setPayGrade}
                                renderLabel={p => `${p.name} — ${p.payPerDay}₪/day`}
                            />
                        </PickerPanel>
                    </div>

                    {/* ── Duty picker — shown only after a faction is selected ── */}
                    <div style={{marginBottom: '12px'}}>
                        <PickerPanel
                            title="Duty"
                            rollLabel={factionDuties.length ? 'Roll' : undefined}
                            onRoll={factionDuties.length ? rollDuty : undefined}
                        >
                            {!selectedFaction ? (
                                <div style={{color: 'var(--muted)', fontFamily: "'Barlow', sans-serif", fontSize: '13px', fontStyle: 'italic', padding: '6px'}}>
                                    Select a faction above to see available duties.
                                </div>
                            ) : factionDuties.length === 0 ? (
                                <div style={{color: 'var(--muted)', fontFamily: "'Barlow', sans-serif", fontSize: '13px', fontStyle: 'italic', padding: '6px'}}>
                                    No duties seeded for this faction yet.
                                </div>
                            ) : (
                                <div style={{display: 'flex', flexDirection: 'column', gap: '6px'}}>
                                    {factionDuties.map(d => {
                                        const active = duty?.id === d.id;
                                        return (
                                            <button
                                                key={d.id}
                                                onClick={() => handleSelectDuty(active ? null : d)}
                                                style={{
                                                    background: active ? 'rgba(8,93,101,0.12)' : 'transparent',
                                                    border: active ? '1px solid #085d65' : '1px solid var(--border)',
                                                    color: active ? '#085d65' : 'var(--ink)',
                                                    fontFamily: "'Barlow', sans-serif",
                                                    fontSize: '14px',
                                                    padding: '9px 14px',
                                                    textAlign: 'left',
                                                    cursor: 'pointer',
                                                    display: 'flex',
                                                    justifyContent: 'space-between',
                                                    alignItems: 'center',
                                                    gap: '12px',
                                                }}
                                            >
                                                <span>{d.name}</span>
                                                {d.dutyBoonName && (
                                                    <span style={{
                                                        fontFamily: "'Barlow', sans-serif",
                                                        fontSize: '12px',
                                                        letterSpacing: '1px',
                                                        color: active ? '#085d65' : 'var(--muted)',
                                                        fontStyle: 'italic',
                                                        whiteSpace: 'nowrap',
                                                    }}>
                                                        Boon: {d.dutyBoonName}
                                                    </span>
                                                )}
                                            </button>
                                        );
                                    })}
                                </div>
                            )}
                        </PickerPanel>
                    </div>

                    {/* ── Boon / Liability pickers ── */}
                    <div style={{display: 'flex', gap: '12px', marginBottom: '36px'}}>
                        <PickerPanel
                            title={`Boons (${boons.length})`}
                            rollLabel={duty?.boons?.length ? 'Roll d10' : undefined}
                            onRoll={duty?.boons?.length ? rollBoons : undefined}
                        >
                            {!duty ? (
                                <div style={{color: 'var(--muted)', fontFamily: "'Barlow', sans-serif", fontSize: '13px', fontStyle: 'italic', padding: '6px'}}>
                                    Select a duty above to see available boons.
                                </div>
                            ) : (
                                <CheckList
                                    items={duty.boons ?? []}
                                    selected={boons}
                                    onToggle={toggleBoon}
                                    searchValue={boonSearch}
                                    onSearch={setBoonSearch}
                                />
                            )}
                        </PickerPanel>

                        <PickerPanel
                            title={`Liabilities (${liabilities.length}/${boons.length || '—'})`}
                            rollLabel={duty?.liabilities?.length ? 'Roll d10' : undefined}
                            onRoll={duty?.liabilities?.length ? rollLiabilities : undefined}
                        >
                            {!duty ? (
                                <div style={{color: 'var(--muted)', fontFamily: "'Barlow', sans-serif", fontSize: '13px', fontStyle: 'italic', padding: '6px'}}>
                                    Select a duty above to see available liabilities.
                                </div>
                            ) : (
                                <CheckList
                                    items={duty.liabilities ?? []}
                                    selected={liabilities}
                                    onToggle={toggleLiability}
                                    max={boons.length || undefined}
                                    searchValue={liabilitySearch}
                                    onSearch={setLiabilitySearch}
                                />
                            )}
                        </PickerPanel>
                    </div>

                    {/* ═══════════════════════════════════════════════
                        PATRON SHEET
                    ═══════════════════════════════════════════════ */}
                    <div ref={sheetRef} style={{
                        background: 'var(--panel)',
                        border: '2px solid var(--border-strong)',
                        boxShadow: '0 4px 24px var(--shadow)',
                    }}>
                        <div style={{height: '3px', background: 'linear-gradient(90deg, transparent, #085d65, transparent)'}}/>

                        <div style={{padding: '28px 32px'}}>

                            {/* Sheet header */}
                            <div style={{display: 'flex', alignItems: 'flex-start', justifyContent: 'space-between', marginBottom: '20px'}}>
                                <div>
                                    <div style={{
                                        fontFamily: "'Barlow', sans-serif",
                                        fontSize: '12px',
                                        fontWeight: 700,
                                        letterSpacing: '4px',
                                        textTransform: 'uppercase',
                                        color: 'var(--muted)',
                                    }}>
                                        Imperium Maledictum
                                    </div>
                                    <div style={{
                                        fontFamily: "'Cinzel', serif",
                                        fontSize: '24px',
                                        fontWeight: 700,
                                        letterSpacing: '3px',
                                        textTransform: 'uppercase',
                                        color: '#085d65',
                                        lineHeight: '1.1',
                                    }}>
                                        Patron Sheet
                                    </div>
                                </div>
                                <button onClick={() => window.print()} style={{...ROLL_BTN, padding: '7px 18px'}}>
                                    Print
                                </button>
                            </div>

                            <div style={{height: '1px', background: 'var(--border-strong)', marginBottom: '18px'}}/>

                            {/* Row 1: Name / Faction / Duty */}
                            <div style={{display: 'flex', gap: '20px', marginBottom: '14px'}}>
                                <SheetField label="Patron Name" value={patronName} style={{flex: 2}}/>
                                <SheetField label="Faction" value={factionText}/>
                                <SheetField label="Duty" value={duty?.name}/>
                            </div>

                            {/* Row 2: Pay Grade / Motivation / Demeanour */}
                            <div style={{display: 'flex', gap: '20px', marginBottom: '10px'}}>
                                <SheetField label="Pay Grade" value={payGrade ? `${payGrade.name} — ${payGrade.payPerDay}₪/day` : null}/>
                                <SheetField label="Motivation" value={motivation?.name}/>
                                <SheetField label="Demeanour" value={demeanour?.name}/>
                            </div>

                            {/* Descriptions for motivation / demeanour */}
                            {(motivation || demeanour) && (
                                <div style={{display: 'flex', gap: '20px', marginTop: '10px', marginBottom: '6px'}}>
                                    <div style={{flex: 1}}/>
                                    <div style={{flex: 1}}>
                                        {motivation && (
                                            <div style={{
                                                fontFamily: "'EB Garamond', serif",
                                                fontSize: '15px',
                                                color: 'var(--muted)',
                                                lineHeight: '1.6',
                                                fontStyle: 'italic',
                                                borderLeft: '2px solid var(--border-strong)',
                                                paddingLeft: '12px',
                                            }}>
                                                {motivation.description}
                                            </div>
                                        )}
                                    </div>
                                    <div style={{flex: 1}}>
                                        {demeanour && (
                                            <div style={{
                                                fontFamily: "'EB Garamond', serif",
                                                fontSize: '15px',
                                                color: 'var(--muted)',
                                                lineHeight: '1.6',
                                                fontStyle: 'italic',
                                                borderLeft: '2px solid var(--border-strong)',
                                                paddingLeft: '12px',
                                            }}>
                                                {demeanour.description}
                                            </div>
                                        )}
                                    </div>
                                </div>
                            )}

                            {/* Duty description + Duty Boon */}
                            {duty && (
                                <div style={{
                                    marginTop: '12px',
                                    padding: '12px 16px',
                                    background: 'rgba(8,93,101,0.06)',
                                    border: '1px solid rgba(8,93,101,0.2)',
                                }}>
                                    <div style={{...FIELD_LABEL, marginBottom: '8px'}}>Duty</div>
                                    <div style={{
                                        fontFamily: "'Cinzel', serif",
                                        fontSize: '15px',
                                        fontWeight: 700,
                                        color: '#085d65',
                                        marginBottom: '6px',
                                    }}>
                                        {duty.name}
                                    </div>
                                    <div style={{
                                        fontFamily: "'EB Garamond', serif",
                                        fontSize: '15px',
                                        color: 'var(--text)',
                                        lineHeight: '1.6',
                                    }}>
                                        {duty.description}
                                    </div>
                                    <DutyBoonBlock
                                        dutyBoonName={duty.dutyBoonName}
                                        dutyBoonDescription={duty.dutyBoonDescription}
                                    />
                                </div>
                            )}

                            <SheetDivider label="Boons & Liabilities"/>

                            {/* Boons / Liabilities split */}
                            <div style={{display: 'flex', gap: '0'}}>
                                <div style={{flex: 1, paddingRight: '20px', borderRight: '1px solid var(--border)'}}>
                                    <div style={{...SECTION, marginBottom: '12px'}}>Boons</div>
                                    {boons.length === 0
                                        ? <div style={{fontFamily: "'EB Garamond', serif", fontSize: '15px', color: 'var(--muted)', fontStyle: 'italic'}}>No boons selected</div>
                                        : boons.map(b => <SheetBlock key={b.id} item={b}/>)
                                    }
                                </div>
                                <div style={{flex: 1, paddingLeft: '20px'}}>
                                    <div style={{...SECTION, marginBottom: '12px'}}>Liabilities</div>
                                    {liabilities.length === 0
                                        ? <div style={{fontFamily: "'EB Garamond', serif", fontSize: '15px', color: 'var(--muted)', fontStyle: 'italic'}}>No liabilities selected</div>
                                        : liabilities.map(l => <SheetBlock key={l.id} item={l} accent="var(--muted)"/>)
                                    }
                                </div>
                            </div>

                            <SheetDivider label="Influence"/>

                            {/* Influence table */}
                            <div style={{overflowX: 'auto'}}>
                                <table style={{width: '100%', borderCollapse: 'collapse'}}>
                                    <thead>
                                    <tr>
                                        {[
                                            {label: 'Faction', w: '24%'},
                                            {label: 'Infl.', w: '10%'},
                                            {label: 'Contacts', w: '36%'},
                                            {label: 'Intel', w: '30%'},
                                        ].map(({label, w}) => (
                                            <th key={label} style={{
                                                ...FIELD_LABEL,
                                                padding: '4px 8px',
                                                textAlign: 'left',
                                                borderBottom: '1px solid var(--border-strong)',
                                                width: w,
                                            }}>{label}</th>
                                        ))}
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {influenceRows.map((row, i) => (
                                        <tr key={i} style={{background: i % 2 === 0 ? 'transparent' : 'var(--accent)'}}>
                                            {['faction', 'infl', 'contacts', 'intel'].map(field => (
                                                <td key={field} style={{padding: '2px 4px'}}>
                                                    <input
                                                        value={row[field]}
                                                        onChange={e => updateInfluenceRow(i, field, e.target.value)}
                                                        style={{
                                                            ...INPUT_STYLE,
                                                            fontSize: '14px',
                                                            padding: '5px 6px',
                                                            borderBottom: '1px solid var(--border)',
                                                        }}
                                                    />
                                                </td>
                                            ))}
                                        </tr>
                                    ))}
                                    </tbody>
                                </table>
                            </div>

                            <SheetDivider label="Notes"/>

                            <textarea
                                value={notes}
                                onChange={e => setNotes(e.target.value)}
                                placeholder="Notes on your Patron — appearance, priorities, opinions of the characters…"
                                rows={5}
                                style={{
                                    width: '100%',
                                    background: 'var(--field-bg)',
                                    border: '1px solid var(--border)',
                                    color: 'var(--ink)',
                                    fontFamily: "'EB Garamond', serif",
                                    fontSize: '16px',
                                    padding: '12px 14px',
                                    resize: 'vertical',
                                    outline: 'none',
                                    lineHeight: '1.6',
                                }}
                            />

                            <div style={{
                                marginTop: '20px',
                                textAlign: 'center',
                                fontFamily: "'Barlow', sans-serif",
                                fontSize: '11px',
                                letterSpacing: '2px',
                                textTransform: 'uppercase',
                                color: 'var(--muted)',
                            }}>
                                Imperium Maledictum — Cubicle 7 Entertainment Ltd. © Games Workshop Limited 2021
                            </div>

                        </div>
                        <div style={{height: '3px', background: 'linear-gradient(90deg, transparent, #085d65, transparent)'}}/>
                    </div>

                </div>
            </main>

            <style>{`
                @media print {
                    .topbar { display: none !important; }
                    main > div > *:not(:last-child) { display: none !important; }
                }
            `}</style>
        </>
    );
}
