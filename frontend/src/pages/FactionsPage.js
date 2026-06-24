import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {getFactions, getEquipmentPacks} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

export default function FactionsPage() {
    const [factions, setFactions] = useState([]);
    const [packs, setPacks] = useState([]);
    const [selected, setSelected] = useState(null);
    const [secondaryCharId, setSecondaryCharId] = useState('');
    const [skillAdvances, setSkillAdvances] = useState({});
    const [choices, setChoices] = useState({});
    const [equipTab, setEquipTab] = useState('standard');
    const [packId, setPackId] = useState(null);
    const [expandedPacks, setExpandedPacks] = useState({});
    const [expandedSkills, setExpandedSkills] = useState({});
    const [expandedTalents, setExpandedTalents] = useState({});
    const [expandedModifiers, setExpandedModifiers] = useState({});
    const [diceRolls, setDiceRolls] = useState({});
    const navigate = useNavigate();
    const {ccm, dispatch} = useCharacter();

    const MAX_SKILL_ADVANCES = 5;
    const MAX_PER_SKILL = 2;

    const rollDice = (qty, key) => {
        const match = qty.match(/(\d+)d(\d+)/i);
        if (!match) return;
        const [, count, sides] = match.map(Number);
        let total = 0;
        for (let i = 0; i < count; i++) total += Math.floor(Math.random() * sides) + 1;
        setDiceRolls(r => ({...r, [key]: total}));
    };

    useEffect(() => {
        Promise.all([getFactions(), getEquipmentPacks()])
            .then(([f, p]) => {
                const fList = Array.isArray(f) ? f : [];
                const pList = Array.isArray(p) ? p : [];
                setFactions(fList);
                setPacks(pList);
                if (fList.length > 0) {
                    const saved = ccm.factionId ? fList.find(x => x.id === ccm.factionId) : null;
                    const init = saved || fList[0];
                    setSelected(init);
                    if (saved) {
                        setSkillAdvances(ccm.factionSkillAdvances || {});
                        // normalise: values might be bare numbers from old saves
                        const rawChoices = ccm.factionChoices || {};
                        const normChoices = Object.fromEntries(
                            Object.entries(rawChoices).map(([k, v]) => [k, Array.isArray(v) ? v : [v]])
                        );
                        setChoices(normChoices);
                        if (saved.secondaryCharacteristics?.length > 0) {
                            const sc = saved.secondaryCharacteristics.find(c => c.name === ccm.factionSecondaryCharName);
                            setSecondaryCharId(sc ? String(sc.id) : String(saved.secondaryCharacteristics[0].id));
                        }
                    } else {
                        resetForFaction(init);
                    }
                }
                if (ccm.equipmentPackId) {
                    setPackId(ccm.equipmentPackId);
                    setEquipTab('pack');
                }
            })
            .catch(err => console.error('Failed to load factions/packs:', err));
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const resetForFaction = (f) => {
        const adv = {};
        (f.skillList || []).forEach(s => {
            adv[s.id] = 0;
        });
        setSkillAdvances(adv);
        setChoices({});
        if (f.secondaryCharacteristics?.length > 0) setSecondaryCharId(String(f.secondaryCharacteristics[0].id));
    };

    const selectFaction = (f) => {
        setSelected(f);
        resetForFaction(f);
    };

    const totalAdvances = Object.values(skillAdvances).reduce((s, v) => s + v, 0);

    const adjustSkill = (skillId, delta) => {
        const cur = skillAdvances[skillId] || 0;
        if (delta > 0 && (totalAdvances >= MAX_SKILL_ADVANCES || cur >= MAX_PER_SKILL)) return;
        if (delta < 0 && cur <= 0) return;
        setSkillAdvances(prev => ({...prev, [skillId]: cur + delta}));
    };

    const handleSubmit = () => {
        if (!selected) return;
        const chars = {...ccm.characteristics};
        // undo previous faction bonuses before applying new ones
        (ccm.factionPrimaryCharNames || '').split(', ').filter(Boolean).forEach(name => {
            if (chars[name]) chars[name] = String(parseInt(chars[name]) - 5);
        });
        if (ccm.factionSecondaryCharName && chars[ccm.factionSecondaryCharName]) {
            chars[ccm.factionSecondaryCharName] = String(parseInt(chars[ccm.factionSecondaryCharName]) - 5);
        }

        // Primary +5
        const primaryNames = (selected.primaryCharacteristics || []).map(c => c.name).join(', ');
        (selected.primaryCharacteristics || []).forEach(c => {
            if (chars[c.name]) chars[c.name] = String(parseInt(chars[c.name]) + 5);
        });

        // Secondary +5
        let secondaryName = '';
        if (secondaryCharId) {
            const sc = (selected.secondaryCharacteristics || []).find(c => String(c.id) === secondaryCharId);
            if (sc && chars[sc.name]) {
                chars[sc.name] = String(parseInt(chars[sc.name]) + 5);
                secondaryName = sc.name;
            }
        }

        const chosenPack = equipTab === 'pack' ? packs.find(p => p.pack.id === packId) : null;

        const charBonuses = [
            ...(selected.primaryCharacteristics || []).map(c => `+5 ${c.name}`),
            ...(secondaryName ? [`+5 ${secondaryName} (chosen)`] : []),
        ].join(', ');

        const skillSummary = (selected.skillList || [])
            .filter(s => (skillAdvances[s.id] || 0) > 0)
            .map(s => `${s.name} ×${skillAdvances[s.id]}`)
            .join(', ');

        let inventoryNames = '';
        if (!chosenPack) {
            const items = [...(selected.inventoryList || []).map(fi => fi.inventory?.name || fi.name)];
            Object.entries(choices).forEach(([groupId, optIds]) => {
                const group = (selected.choiceGroups || []).find(g => String(g.id) === String(groupId));
                if (!group) return;
                const ids = Array.isArray(optIds) ? optIds : [optIds];
                ids.forEach(optId => {
                    const opt = (group.options || []).find(o => String(o.id) === String(optId));
                    if (opt) (opt.inventory || []).forEach(i => items.push(i.name));
                });
            });
            inventoryNames = items.join(', ');
        }

        dispatch({
            type: 'SET_FACTION',
            payload: {
                factionId: selected.id,
                factionPrimaryCharNames: primaryNames,
                factionSecondaryCharName: secondaryName,
                factionSkillAdvances: skillAdvances,
                factionChoices: choices,
                equipmentPackId: chosenPack ? packId : null,
                characteristics: chars,
                _factionName: selected.name,
                _equipmentPackName: chosenPack ? chosenPack.pack.name : '',
                _factionCharBonuses: charBonuses,
                _factionSkillSummary: skillSummary,
                _factionInventory: inventoryNames,
            },
        });
        navigate('/roles');
    };

    if (!selected) return null;

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
                        }}>Choose Faction
                        </div>
                        {factions.map(f => (
                            <div key={f.id} onClick={() => selectFaction(f)} style={{
                                display: 'flex',
                                alignItems: 'center',
                                gap: '14px',
                                padding: '14px 24px',
                                cursor: 'pointer',
                                borderLeft: `3px solid ${selected.id === f.id ? 'var(--red)' : 'transparent'}`,
                                background: selected.id === f.id ? 'rgba(var(--accent-rgb),0.07)' : 'transparent',
                                transition: '0.15s'
                            }}>
                                <div style={{
                                    width: '9px',
                                    height: '9px',
                                    borderRadius: '50%',
                                    background: selected.id === f.id ? 'var(--red)' : 'var(--border-strong)',
                                    flexShrink: 0
                                }}/>
                                <div>
                                    <div style={{
                                        fontFamily: "'Barlow', sans-serif",
                                        fontSize: '15px',
                                        color: selected.id === f.id ? 'var(--red)' : 'var(--ink)'
                                    }}>{f.name}</div>
                                    <div style={{display: 'flex', gap: '4px', marginTop: '5px', flexWrap: 'wrap'}}>
                                        {(f.primaryCharacteristics || []).map(c => <span key={c.id} style={{
                                            fontFamily: "'Barlow', sans-serif",
                                            fontSize: '11px',
                                            letterSpacing: '1px',
                                            color: 'var(--muted)',
                                            background: 'rgba(var(--accent-rgb),0.06)',
                                            padding: '2px 7px'
                                        }}>{c.name}</span>)}
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
                    <div style={{
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '28px',
                        width: '100%',
                        maxWidth: '780px'
                    }}>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif",
                            fontSize: '32px',
                            color: 'var(--ink)'
                        }}>{selected.name}</div>

                        {/* Characteristics */}
                        <Section title="Characteristic Bonuses">
                            <div style={{display: 'flex', flexWrap: 'wrap', alignItems: 'center', gap: '8px'}}>
                                {(selected.primaryCharacteristics || []).map((c, i, arr) => (
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
                            {selected.secondaryCharacteristics?.length > 0 && (
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
                                        <select value={secondaryCharId}
                                                onChange={e => setSecondaryCharId(e.target.value)}
                                                style={{
                                                    appearance: 'none',
                                                    padding: '8px 28px 8px 12px',
                                                    border: '1px solid var(--border-strong)',
                                                    background: 'var(--field-bg)',
                                                    color: 'var(--ink)',
                                                    fontFamily: "'Barlow', sans-serif",
                                                    fontSize: '17px',
                                                    outline: 'none',
                                                    minWidth: '200px'
                                                }}>
                                            {selected.secondaryCharacteristics.map(c => <option key={c.id}
                                                                                                value={String(c.id)}>{c.full_name}</option>)}
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
                        </Section>

                        {/* Skills */}
                        <Section title="Skill Advances">
                            <div style={{
                                color: 'var(--ink)',
                                fontSize: '18px',
                                lineHeight: '1.7',
                                background: 'var(--panel)',
                                padding: '14px 18px',
                                borderLeft: '2px solid var(--border-strong)'
                            }}>
                                You have 5 Advances to distribute. Maximum 2 per skill.
                            </div>
                            {(selected.skillList || []).map(skill => (
                                <div key={skill.id} className="skill-row">
                                    <div style={{flex: 1}}>
                                        <div style={{display: 'flex', alignItems: 'center', gap: '8px'}}>
                                            <div className="skill-name">{skill.name}</div>
                                            {skill.description && <button className="desc-toggle"
                                                                          onClick={() => setExpandedSkills(p => ({
                                                                              ...p,
                                                                              [skill.id]: !p[skill.id]
                                                                          }))}>{expandedSkills[skill.id] ? '▴' : '▾'}</button>}
                                        </div>
                                        {skill.description && <div
                                            className={`skill-desc${expandedSkills[skill.id] ? ' open' : ''}`}>{skill.description}</div>}
                                    </div>
                                    <div className="advance-controls" style={{flexShrink: 0}}>
                                        <button type="button" className="advance-btn"
                                                onClick={() => adjustSkill(skill.id, -1)}>−
                                        </button>
                                        <input type="number" className="advance-input" readOnly
                                               value={skillAdvances[skill.id] || 0}/>
                                        <button type="button" className="advance-btn"
                                                onClick={() => adjustSkill(skill.id, 1)}>+
                                        </button>
                                    </div>
                                </div>
                            ))}
                            <div className="remaining">Remaining: {MAX_SKILL_ADVANCES - totalAdvances}</div>
                        </Section>

                        {/* Talents */}
                        {selected.talentList?.length > 0 && (
                            <Section title="Talents">
                                <div style={{display: 'flex', flexDirection: 'column', gap: '8px'}}>
                                    {selected.talentList.map(t => (
                                        <div key={t.id} className="talent-card">
                                            <div style={{display: 'flex', alignItems: 'center', gap: '8px'}}>
                                                <div className="talent-card-name">{t.name}</div>
                                                {t.description && <button className="desc-toggle"
                                                                          onClick={() => setExpandedTalents(p => ({
                                                                              ...p,
                                                                              [t.id]: !p[t.id]
                                                                          }))}>{expandedTalents[t.id] ? '▴' : '▾'}</button>}
                                            </div>
                                            {t.description && <div
                                                className={`talent-desc${expandedTalents[t.id] ? ' open' : ''}`}>{t.description}</div>}
                                        </div>
                                    ))}
                                </div>
                            </Section>
                        )}

                        {/* Equipment tabs */}
                        <Section title="Equipment">
                            <div style={{
                                display: 'flex',
                                alignItems: 'center',
                                borderBottom: '1px solid var(--border)'
                            }}>
                                {['standard', 'pack'].map((tab, i) => (
                                    <span key={tab} style={{display: 'flex', alignItems: 'center'}}>
                    {i > 0 && <span style={{
                        fontSize: '12px',
                        color: 'var(--muted)',
                        padding: '0 6px',
                        fontStyle: 'italic'
                    }}>or</span>}
                                        <button type="button" onClick={() => setEquipTab(tab)} style={{
                                            background: 'transparent',
                                            border: 'none',
                                            borderBottom: `2px solid ${equipTab === tab ? 'var(--red)' : 'transparent'}`,
                                            color: equipTab === tab ? 'var(--red)' : 'var(--muted)',
                                            fontSize: '16px',
                                            padding: '8px 18px',
                                            cursor: 'pointer',
                                            marginBottom: '-1px',
                                        }}>
                      {tab === 'standard' ? 'Starting Equipment' : 'Equipment Pack'}
                    </button>
                  </span>
                                ))}
                            </div>

                            {equipTab === 'standard' && (
                                <div style={{marginTop: '12px'}}>
                                    {selected.inventoryList?.length > 0 && (
                                        <div className="tag-list">
                                            {selected.inventoryList.map(fi => {
                                                const name = fi.inventory?.name || fi.name;
                                                const qty = fi.quantity && fi.quantity !== '1' ? fi.quantity : null;
                                                const mods = fi.modifiers || [];
                                                const isDice = qty && /\d+d\d+/i.test(qty);
                                                const rollKey = `fi_${fi.id}`;
                                                const rolled = diceRolls[rollKey];
                                                return (
                                                    <div key={fi.id} className="tag" style={{display:'flex', alignItems:'center', gap:'6px'}}>
                                                        <span>{name}{qty && !isDice ? ` ×${qty}` : ''}</span>
                                                        {isDice && (
                                                            <span style={{display:'inline-flex', alignItems:'center', gap:'4px'}}>
                                                                <button
                                                                    className="dice-roll-btn"
                                                                    onClick={() => rollDice(qty, rollKey)}
                                                                    title={`Roll ${qty}`}
                                                                >⚄ {qty}</button>
                                                                {rolled != null && <span className="dice-roll-result">{rolled}</span>}
                                                            </span>
                                                        )}
                                                        {mods.map(m => (
                                                            <span key={m.id} className={`item-modifier item-modifier--${m.type}`}>{m.name}</span>
                                                        ))}
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    )}
                                    {selected.choiceGroups?.length > 0 && (
                                        <div style={{
                                            marginTop: '16px',
                                            display: 'flex',
                                            flexDirection: 'column',
                                            gap: '12px'
                                        }}>
                                            {selected.choiceGroups.map(group => {
                                                const multi = group.choicesRequired > 1;
                                                const selectedIds = Array.isArray(choices[group.id]) ? choices[group.id] : (choices[group.id] ? [choices[group.id]] : []);
                                                const atLimit = selectedIds.length >= group.choicesRequired;
                                                return (
                                                <div key={group.id} className="choice-group">
                                                    <div style={{
                                                        color: 'var(--ink)',
                                                        fontSize: '18px',
                                                        lineHeight: '1.7',
                                                        padding: '14px 18px',
                                                        borderLeft: '2px solid var(--border-strong)'
                                                    }}>Choose {group.choicesRequired}:
                                                        {multi && <span style={{fontFamily:"'Barlow',sans-serif",fontSize:'13px',color:'var(--muted)',marginLeft:'8px'}}>{selectedIds.length}/{group.choicesRequired} selected</span>}
                                                    </div>
                                                    {(() => {
                                                        const groupMods = [...new Map(
                                                            group.options.flatMap(o => o.modifiers || []).map(m => [m.id, m])
                                                        ).values()];
                                                        return groupMods.length > 0 && (
                                                            <div style={{padding:'0 18px 12px'}}>
                                                                <div style={{fontFamily:"'Barlow',sans-serif", fontSize:'13px', color:'var(--muted)', marginBottom:'6px'}}>chosen item gains:</div>
                                                                <div style={{display:'flex', flexDirection:'column', gap:'6px'}}>
                                                                    {groupMods.map(m => (
                                                                        <div key={m.id} className="talent-card">
                                                                            <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                                                                <span className={`item-modifier item-modifier--${m.type}`} style={{marginLeft:0}}>{m.name}</span>
                                                                                {m.description && (
                                                                                    <button className="desc-toggle" onClick={() => setExpandedModifiers(p => ({...p, [m.id]: !p[m.id]}))}>
                                                                                        {expandedModifiers[m.id] ? '▴' : '▾'}
                                                                                    </button>
                                                                                )}
                                                                            </div>
                                                                            {m.description && (
                                                                                <div className={`talent-desc${expandedModifiers[m.id] ? ' open' : ''}`}>{m.description}</div>
                                                                            )}
                                                                        </div>
                                                                    ))}
                                                                </div>
                                                            </div>
                                                        );
                                                    })()}
                                                    {group.options.map(opt => {
                                                        const isChecked = selectedIds.includes(opt.id);
                                                        const disabled = multi && !isChecked && atLimit;
                                                        return (
                                                        <label key={opt.id} className="choice-option" style={disabled ? {opacity:0.45} : undefined}>
                                                            <input
                                                                type={multi ? 'checkbox' : 'radio'}
                                                                name={multi ? undefined : `choiceGroup_${group.id}`}
                                                                value={opt.id}
                                                                checked={multi ? isChecked : selectedIds.includes(opt.id)}
                                                                disabled={disabled}
                                                                onChange={() => {
                                                                    if (multi) {
                                                                        setChoices(c => {
                                                                            const prev = Array.isArray(c[group.id]) ? c[group.id] : (c[group.id] ? [c[group.id]] : []);
                                                                            const next = prev.includes(opt.id)
                                                                                ? prev.filter(id => id !== opt.id)
                                                                                : prev.length < group.choicesRequired ? [...prev, opt.id] : prev;
                                                                            return {...c, [group.id]: next};
                                                                        });
                                                                    } else {
                                                                        setChoices(c => ({...c, [group.id]: [opt.id]}));
                                                                    }
                                                                }}
                                                                style={{marginTop: '3px', accentColor: 'var(--red)'}}
                                                            />
                                                            <div className="choice-content">
                                                                {opt.talents?.map(t => <div key={t.id} className="reward-line">• {t.name}</div>)}
                                                                {opt.inventory?.map(i => (
                                                                    <div key={i.id} className="reward-line">• {i.name}</div>
                                                                ))}
                                                            </div>
                                                        </label>
                                                        );
                                                    })}
                                                </div>
                                                );
                                            })}
                                        </div>
                                    )}
                                </div>
                            )}

                            {equipTab === 'pack' && (
                                <div style={{marginTop: '12px', display: 'flex', flexDirection: 'column', gap: '4px'}}>
                                    {packs.map(p => (
                                        <div key={p.pack.id}>
                                            <div onClick={() => setPackId(p.pack.id)} style={{
                                                display: 'flex',
                                                alignItems: 'center',
                                                gap: '12px',
                                                padding: '10px 14px',
                                                border: `1px solid ${packId === p.pack.id ? 'var(--red)' : 'var(--border)'}`,
                                                cursor: 'pointer',
                                                background: packId === p.pack.id ? 'rgba(var(--accent-rgb),0.04)' : 'rgba(var(--surface-rgb),0.2)',
                                                transition: '0.15s'
                                            }}>
                                                <div style={{
                                                    width: '13px',
                                                    height: '13px',
                                                    border: `2px solid ${packId === p.pack.id ? 'var(--red)' : 'var(--border-strong)'}`,
                                                    borderRadius: '50%',
                                                    flexShrink: 0,
                                                    background: packId === p.pack.id ? 'var(--red)' : 'transparent'
                                                }}/>
                                                <div style={{
                                                    flex: 1,
                                                    display: 'flex',
                                                    alignItems: 'baseline',
                                                    gap: '10px'
                                                }}>
                                                    <span style={{
                                                        fontFamily: "'Barlow', sans-serif",
                                                        fontSize: '18px',
                                                        color: 'var(--ink)'
                                                    }}>{p.pack.name}</span>
                                                    <span style={{
                                                        fontSize: '16px',
                                                        color: 'var(--muted)'
                                                    }}>{p.pack.cost} sol</span>
                                                    <span style={{
                                                        fontFamily: "'Barlow', sans-serif",
                                                        fontSize: '12px',
                                                        letterSpacing: '1px',
                                                        color: 'var(--red)'
                                                    }}>{p.pack.availability}</span>
                                                </div>
                                                <button type="button" onClick={e => {
                                                    e.stopPropagation();
                                                    setExpandedPacks(ex => ({...ex, [p.pack.id]: !ex[p.pack.id]}));
                                                }} style={{
                                                    background: 'transparent',
                                                    border: '1px solid var(--border-strong)',
                                                    color: 'var(--muted)',
                                                    width: '22px',
                                                    height: '22px',
                                                    fontSize: '10px',
                                                    cursor: 'pointer'
                                                }}>
                                                    {expandedPacks[p.pack.id] ? '▲' : '▼'}
                                                </button>
                                            </div>
                                            {expandedPacks[p.pack.id] && (
                                                <div style={{
                                                    padding: '8px 14px 10px 38px',
                                                    border: '1px solid var(--border)',
                                                    borderTop: 'none',
                                                    background: 'rgba(var(--surface-rgb),0.1)',
                                                    display: 'flex',
                                                    flexWrap: 'wrap',
                                                    gap: '5px'
                                                }}>
                                                    {p.items.map((item, idx) => (
                                                        item.inventory
                                                            ? <span key={idx} style={{
                                                                fontSize: '15px',
                                                                color: 'var(--text)',
                                                                padding: '3px 10px',
                                                                border: '1px solid var(--border-strong)'
                                                            }}>{item.quantity > 1 ? `${item.quantity}× ` : ''}{item.inventory.name}</span>
                                                            : item.note && <span key={idx} style={{
                                                            fontSize: '15px',
                                                            color: 'var(--muted)',
                                                            padding: '3px 10px',
                                                            border: '1px dashed var(--border)',
                                                            fontStyle: 'italic'
                                                        }}>{item.note}</span>
                                                    ))}
                                                </div>
                                            )}
                                        </div>
                                    ))}
                                </div>
                            )}
                        </Section>

                        <button onClick={handleSubmit} className="select-btn" style={{width: '100%'}}>Select Faction
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}

function Section({title, children}) {
    return (
        <div style={{display: 'flex', flexDirection: 'column', gap: '12px'}}>
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
                {title}<span style={{flex: 1, height: '1px', background: 'var(--border)'}}/>
            </div>
            {children}
        </div>
    );
}
