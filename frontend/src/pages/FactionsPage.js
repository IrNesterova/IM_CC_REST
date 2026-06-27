import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {getFactions, getEquipmentPacks} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

export default function FactionsPage() {
    const [factions, setFactions] = useState([]);
    const [packs, setPacks] = useState([]);
    const [loading, setLoading] = useState(true);
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

    // AM grade state
    const [gradeId, setGradeId] = useState(null);
    const [gradeSecondaryCharId, setGradeSecondaryCharId] = useState('');
    const [gradeSkillAdvances, setGradeSkillAdvances] = useState({});
    const [gradeChoices, setGradeChoices] = useState({});

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
                        const rawChoices = ccm.factionChoices || {};
                        const normChoices = Object.fromEntries(
                            Object.entries(rawChoices).map(([k, v]) => [k, Array.isArray(v) ? v : [v]])
                        );
                        setChoices(normChoices);
                        if (saved.secondaryCharacteristics?.length > 0) {
                            const sc = saved.secondaryCharacteristics.find(c => c.name === ccm.factionSecondaryCharName);
                            setSecondaryCharId(sc ? String(sc.id) : String(saved.secondaryCharacteristics[0].id));
                        }
                        // Restore AM grade state
                        if (saved.sourceBook === 'AM' && ccm.factionGradeId) {
                            const savedGrade = (saved.grades || []).find(g => g.id === ccm.factionGradeId);
                            if (savedGrade) {
                                setGradeId(savedGrade.id);
                                setGradeSkillAdvances(ccm.factionGradeSkillAdvances || {});
                                const rawGradeChoices = ccm.factionGradeChoices || {};
                                setGradeChoices(Object.fromEntries(
                                    Object.entries(rawGradeChoices).map(([k, v]) => [k, Array.isArray(v) ? v : [v]])
                                ));
                                if (savedGrade.charChoices?.length > 0 && ccm.factionGradeCharId) {
                                    const gc = savedGrade.charChoices.find(c => c.id === ccm.factionGradeCharId);
                                    setGradeSecondaryCharId(gc ? String(gc.id) : String(savedGrade.charChoices[0].id));
                                }
                            }
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
            .catch(err => console.error('Failed to load factions/packs:', err))
            .finally(() => setLoading(false));
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const resetForFaction = (f) => {
        const adv = {};
        (f.skillList || []).forEach(s => { adv[s.id] = 0; });
        setSkillAdvances(adv);
        setChoices({});
        if (f.secondaryCharacteristics?.length > 0) setSecondaryCharId(String(f.secondaryCharacteristics[0].id));
        setGradeId(null);
        setGradeSecondaryCharId('');
        setGradeSkillAdvances({});
        setGradeChoices({});
    };

    const selectFaction = (f) => {
        setSelected(f);
        resetForFaction(f);
    };

    const selectGrade = (grade) => {
        setGradeId(grade.id);
        const adv = {};
        (grade.allowedSkills || []).forEach(s => { adv[s.id] = 0; });
        setGradeSkillAdvances(adv);
        setGradeChoices({});
        if (grade.charChoices?.length > 0) setGradeSecondaryCharId(String(grade.charChoices[0].id));
    };

    const totalAdvances = Object.values(skillAdvances).reduce((s, v) => s + v, 0);
    const totalGradeAdvances = Object.values(gradeSkillAdvances).reduce((s, v) => s + v, 0);

    const selectedGrade = gradeId ? (selected?.grades || []).find(g => g.id === gradeId) : null;
    const gradePoolSize = selectedGrade?.skillPoolSize || 0;

    const adjustSkill = (skillId, delta) => {
        const cur = skillAdvances[skillId] || 0;
        if (delta > 0 && (totalAdvances >= MAX_SKILL_ADVANCES || cur >= MAX_PER_SKILL)) return;
        if (delta < 0 && cur <= 0) return;
        setSkillAdvances(prev => ({...prev, [skillId]: cur + delta}));
    };

    const adjustGradeSkill = (skillId, delta) => {
        const cur = gradeSkillAdvances[skillId] || 0;
        if (delta > 0 && (totalGradeAdvances >= gradePoolSize || cur >= MAX_PER_SKILL)) return;
        if (delta < 0 && cur <= 0) return;
        setGradeSkillAdvances(prev => ({...prev, [skillId]: cur + delta}));
    };

    const handleSubmit = () => {
        if (!selected) return;
        const chars = {...ccm.characteristics};

        // Undo previous standard faction bonuses
        (ccm.factionPrimaryCharNames || '').split(', ').filter(Boolean).forEach(name => {
            if (chars[name]) chars[name] = String(parseInt(chars[name]) - 5);
        });
        if (ccm.factionSecondaryCharName && chars[ccm.factionSecondaryCharName]) {
            chars[ccm.factionSecondaryCharName] = String(parseInt(chars[ccm.factionSecondaryCharName]) - 5);
        }

        // Undo previous grade bonuses
        if (ccm.factionGradeFixedCharName && chars[ccm.factionGradeFixedCharName]) {
            chars[ccm.factionGradeFixedCharName] = String(
                parseInt(chars[ccm.factionGradeFixedCharName]) - (ccm.factionGradeFixedCharAmount || 0)
            );
        }
        if (ccm.factionGradeCharName && chars[ccm.factionGradeCharName]) {
            chars[ccm.factionGradeCharName] = String(parseInt(chars[ccm.factionGradeCharName]) - 5);
        }

        const chosenPack = equipTab === 'pack' ? packs.find(p => p.pack.id === packId) : null;

        if (selected.sourceBook === 'AM') {
            // ── AM GRADE path ────────────────────────────────────────
            const grade = selectedGrade;
            let gradeFixedCharName = '';
            let gradeFixedCharAmount = 0;
            let gradeCharName = '';

            if (grade) {
                if (grade.fixedChar?.name && chars[grade.fixedChar.name] !== undefined) {
                    chars[grade.fixedChar.name] = String(parseInt(chars[grade.fixedChar.name]) + grade.fixedCharAmount);
                    gradeFixedCharName = grade.fixedChar.name;
                    gradeFixedCharAmount = grade.fixedCharAmount;
                }
                const chosenChar = (grade.charChoices || []).find(c => String(c.id) === gradeSecondaryCharId);
                if (chosenChar?.name && chars[chosenChar.name] !== undefined) {
                    chars[chosenChar.name] = String(parseInt(chars[chosenChar.name]) + 5);
                    gradeCharName = chosenChar.name;
                }
            }

            const charBonuses = [
                gradeFixedCharName ? `+${gradeFixedCharAmount} ${gradeFixedCharName} (fixed)` : '',
                gradeCharName ? `+5 ${gradeCharName} (chosen)` : '',
            ].filter(Boolean).join(', ');

            const skillSummary = (grade?.allowedSkills || [])
                .filter(s => (gradeSkillAdvances[s.id] || 0) > 0)
                .map(s => `${s.name} ×${gradeSkillAdvances[s.id]}`)
                .join(', ');

            // Build grade inventory summary
            let gradeInventoryItems = [];
            if (!chosenPack) {
                (selected.inventoryList || []).forEach(fi => fi.inventory?.name && gradeInventoryItems.push(fi.inventory.name));
                (grade?.fixedInventory || []).forEach(gi => {
                    const qty = gi.quantity || 1;
                    const nm = gi.inventory?.name;
                    if (nm) gradeInventoryItems.push(qty > 1 ? `${qty}× ${nm}` : nm);
                });
                Object.entries(gradeChoices).forEach(([groupId, selected_ids]) => {
                    const grp = (grade?.choiceGroups || []).find(g => String(g.id) === String(groupId));
                    if (!grp) return;
                    const ids = Array.isArray(selected_ids) ? selected_ids : [selected_ids];
                    if (grp.choiceType === 'INVENTORY') {
                        (grp.inventoryOptions || [])
                            .filter(ic => ids.map(Number).includes(ic.id))
                            .forEach(ic => {
                                const qty = ic.quantity || 1;
                                const nm = ic.inventory?.name;
                                if (nm) gradeInventoryItems.push(qty > 1 ? `${qty}× ${nm}` : nm);
                            });
                    } else if (grp.choiceType === 'TALENT') {
                        // talents handled in SummaryServiceImpl, not in inventory list
                    }
                });
            }

            dispatch({
                type: 'SET_FACTION',
                payload: {
                    factionId: selected.id,
                    factionPrimaryCharNames: '',
                    factionSecondaryCharName: '',
                    factionSkillAdvances: {},
                    factionChoices: {},
                    factionGradeId: gradeId,
                    factionGradeCharId: gradeSecondaryCharId ? Number(gradeSecondaryCharId) : null,
                    factionGradeFixedCharName: gradeFixedCharName,
                    factionGradeFixedCharAmount: gradeFixedCharAmount,
                    factionGradeCharName: gradeCharName,
                    factionGradeSkillAdvances: gradeSkillAdvances,
                    factionGradeChoices: gradeChoices,
                    equipmentPackId: chosenPack ? packId : null,
                    characteristics: chars,
                    _factionName: selected.name,
                    _factionGradeName: grade?.name || '',
                    _equipmentPackName: chosenPack ? chosenPack.pack.name : '',
                    _factionCharBonuses: charBonuses,
                    _factionSkillSummary: skillSummary,
                    _factionInventory: gradeInventoryItems.join(', '),
                },
            });
        } else {
            // ── STANDARD faction path ────────────────────────────────
            const primaryNames = (selected.primaryCharacteristics || []).map(c => c.name).join(', ');
            (selected.primaryCharacteristics || []).forEach(c => {
                if (chars[c.name]) chars[c.name] = String(parseInt(chars[c.name]) + 5);
            });
            let secondaryName = '';
            if (secondaryCharId) {
                const sc = (selected.secondaryCharacteristics || []).find(c => String(c.id) === secondaryCharId);
                if (sc && chars[sc.name]) {
                    chars[sc.name] = String(parseInt(chars[sc.name]) + 5);
                    secondaryName = sc.name;
                }
            }

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
                    factionGradeId: null,
                    factionGradeCharId: null,
                    factionGradeFixedCharName: '',
                    factionGradeFixedCharAmount: 0,
                    factionGradeCharName: '',
                    factionGradeSkillAdvances: {},
                    factionGradeChoices: {},
                    equipmentPackId: chosenPack ? packId : null,
                    characteristics: chars,
                    _factionName: selected.name,
                    _factionGradeName: '',
                    _equipmentPackName: chosenPack ? chosenPack.pack.name : '',
                    _factionCharBonuses: charBonuses,
                    _factionSkillSummary: skillSummary,
                    _factionInventory: inventoryNames,
                },
            });
        }
        navigate('/roles');
    };

    if (loading) return (
        <><ProgressBar/><Topbar/>
            <div style={{display:'flex',justifyContent:'center',alignItems:'center',minHeight:'60vh',color:'var(--muted)',fontFamily:"'Barlow',sans-serif",fontSize:'13px',letterSpacing:'3px'}}>
                Loading factions…
            </div>
        </>
    );

    if (!selected) return null;

    const isAM = selected.sourceBook === 'AM';
    const canSubmit = isAM ? !!gradeId : true;

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
                    <div style={{position: 'sticky', top: '100px', overflowY: 'auto', maxHeight: 'calc(100vh - 100px)'}}>
                        <div style={{
                            fontFamily: "'Barlow', sans-serif",
                            fontSize: '12px',
                            textTransform: 'uppercase',
                            letterSpacing: '3px',
                            color: 'var(--muted)',
                            padding: '18px 24px 14px',
                            borderBottom: '1px solid var(--border)'
                        }}>Choose Faction</div>
                        {(() => {
                            const imFactions = factions.filter(f => !f.sourceBook || f.sourceBook === 'IM');
                            const inFactions = factions.filter(f => f.sourceBook === 'IN');
                            const amFactions = factions.filter(f => f.sourceBook === 'AM');
                            const FactionItem = (f) => (
                                <div key={f.id} onClick={() => selectFaction(f)} style={{
                                    display: 'flex', alignItems: 'center', gap: '14px',
                                    padding: '14px 24px', cursor: 'pointer',
                                    borderLeft: `3px solid ${selected.id === f.id ? 'var(--red)' : 'transparent'}`,
                                    background: selected.id === f.id ? 'rgba(var(--accent-rgb),0.07)' : 'transparent',
                                    transition: '0.15s'
                                }}>
                                    <div style={{
                                        width: '9px', height: '9px', borderRadius: '50%', flexShrink: 0,
                                        background: selected.id === f.id ? 'var(--red)' : 'var(--border-strong)'
                                    }}/>
                                    <div>
                                        <div style={{
                                            fontFamily: "'Barlow', sans-serif", fontSize: '15px',
                                            color: selected.id === f.id ? 'var(--red)' : 'var(--ink)'
                                        }}>{f.name}</div>
                                        <div style={{display: 'flex', gap: '4px', marginTop: '5px', flexWrap: 'wrap'}}>
                                            {(f.primaryCharacteristics || []).map(c => (
                                                <span key={c.id} style={{
                                                    fontFamily: "'Barlow', sans-serif", fontSize: '11px',
                                                    letterSpacing: '1px', color: 'var(--muted)',
                                                    background: 'rgba(var(--accent-rgb),0.06)', padding: '2px 7px'
                                                }}>{c.name}</span>
                                            ))}
                                            {f.sourceBook === 'AM' && (
                                                <span style={{
                                                    fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                                                    letterSpacing: '1px', color: '#8b3a3a',
                                                    background: 'rgba(139,58,58,0.1)', padding: '2px 7px'
                                                }}>AM</span>
                                            )}
                                        </div>
                                    </div>
                                </div>
                            );
                            return <>
                                {imFactions.length > 0 && <>
                                    <div style={{
                                        fontFamily:"'Barlow',sans-serif", fontSize:'11px',
                                        textTransform:'uppercase', letterSpacing:'3px',
                                        color:'var(--muted)', padding:'14px 24px 6px',
                                        borderTop:'1px solid var(--border)', marginTop:'4px'
                                    }}>Imperium Maledictum</div>
                                    {imFactions.map(FactionItem)}
                                </>}
                                {inFactions.length > 0 && <>
                                    <div style={{
                                        fontFamily:"'Barlow',sans-serif", fontSize:'11px',
                                        textTransform:'uppercase', letterSpacing:'3px',
                                        color:'#a07840', padding:'14px 24px 6px',
                                        borderTop:'1px solid var(--border)',
                                        borderBottom:'1px solid rgba(160,120,64,0.25)',
                                        background:'rgba(160,120,64,0.04)', marginTop:'4px'
                                    }}>Inquisition Supplement</div>
                                    {inFactions.map(FactionItem)}
                                </>}
                                {amFactions.length > 0 && <>
                                    <div style={{
                                        fontFamily:"'Barlow',sans-serif", fontSize:'11px',
                                        textTransform:'uppercase', letterSpacing:'3px',
                                        color:'#8b3a3a', padding:'14px 24px 6px',
                                        borderTop:'1px solid var(--border)',
                                        borderBottom:'1px solid rgba(139,58,58,0.25)',
                                        background:'rgba(139,58,58,0.04)', marginTop:'4px'
                                    }}>Adeptus Mechanicus Supplement</div>
                                    {amFactions.map(FactionItem)}
                                </>}
                            </>;
                        })()}
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
                    <div style={{display:'flex', flexDirection:'column', gap:'28px', width:'100%', maxWidth:'780px'}}>

                        {/* Source badge */}
                        {selected.sourceBook === 'IN' && (
                            <div style={{
                                fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                letterSpacing:'3px', textTransform:'uppercase',
                                color:'#a07840', background:'rgba(160,120,64,0.12)',
                                border:'1px solid rgba(160,120,64,0.4)',
                                padding:'3px 10px', display:'inline-block'
                            }}>Inquisition Supplement</div>
                        )}
                        {isAM && (
                            <div style={{
                                fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                letterSpacing:'3px', textTransform:'uppercase',
                                color:'#8b3a3a', background:'rgba(139,58,58,0.12)',
                                border:'1px solid rgba(139,58,58,0.4)',
                                padding:'3px 10px', display:'inline-block'
                            }}>Adeptus Mechanicus Supplement</div>
                        )}

                        <div style={{fontFamily:"'Barlow', sans-serif", fontSize:'32px', color:'var(--ink)'}}>
                            {selected.name}
                        </div>

                        {/* ══ AM GRADE UI ══════════════════════════════════════════ */}
                        {isAM ? (
                            <>
                                {/* General benefits */}
                                <Section title="General Benefits">
                                    <div style={{color:'var(--ink)', fontSize:'16px', lineHeight:'1.7',
                                        background:'var(--panel)', padding:'14px 18px',
                                        borderLeft:'2px solid rgba(139,58,58,0.5)'}}>
                                        All Adeptus Mechanicus characters gain: +1 Influence, Mechanicus Robes,
                                        Opus Machina, Dataslate, Sacred Unguents, and 100 solars.
                                    </div>
                                    {selected.inventoryList?.length > 0 && (
                                        <div className="tag-list" style={{marginTop:'8px'}}>
                                            {selected.inventoryList.map(fi => {
                                                const name = fi.inventory?.name || fi.name;
                                                const qty = fi.quantity && fi.quantity !== '1' ? fi.quantity : null;
                                                const isDice = qty && /\d+d\d+/i.test(qty);
                                                const rollKey = `fi_${fi.id}`;
                                                const rolled = diceRolls[rollKey];
                                                return (
                                                    <div key={fi.id} className="tag" style={{display:'flex', alignItems:'center', gap:'6px'}}>
                                                        <span>{name}{qty && !isDice ? ` ×${qty}` : ''}</span>
                                                        {isDice && (
                                                            <span style={{display:'inline-flex', alignItems:'center', gap:'4px'}}>
                                                                <button className="dice-roll-btn" onClick={() => rollDice(qty, rollKey)} title={`Roll ${qty}`}>⚄ {qty}</button>
                                                                {rolled != null && <span className="dice-roll-result">{rolled}</span>}
                                                            </span>
                                                        )}
                                                    </div>
                                                );
                                            })}
                                        </div>
                                    )}
                                </Section>

                                {/* Grade selection cards */}
                                <Section title="Augmentation Level">
                                    <div style={{
                                        color:'var(--ink)', fontSize:'16px', lineHeight:'1.7',
                                        background:'var(--panel)', padding:'14px 18px',
                                        borderLeft:'2px solid rgba(139,58,58,0.5)'
                                    }}>
                                        Choose an Augmentation Level or roll d100: 01–30 Grade I, 31–70 Grade II, 71–00 Grade III.
                                    </div>
                                    <div style={{display:'flex', gap:'12px', flexWrap:'wrap'}}>
                                        {(selected.grades || []).map(grade => {
                                            const isSelected = gradeId === grade.id;
                                            return (
                                                <div key={grade.id} onClick={() => selectGrade(grade)} style={{
                                                    flex:'1', minWidth:'200px', cursor:'pointer',
                                                    border: `2px solid ${isSelected ? '#8b3a3a' : 'var(--border-strong)'}`,
                                                    background: isSelected ? 'rgba(139,58,58,0.07)' : 'var(--bg)',
                                                    padding:'16px', transition:'0.15s'
                                                }}>
                                                    <div style={{
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'11px',
                                                        textTransform:'uppercase', letterSpacing:'3px',
                                                        color: isSelected ? '#8b3a3a' : 'var(--muted)',
                                                        marginBottom:'6px'
                                                    }}>Grade {grade.gradeNumber}</div>
                                                    <div style={{
                                                        fontSize:'18px', color:'var(--ink)', marginBottom:'8px'
                                                    }}>{grade.name}</div>
                                                    <div style={{
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                        color:'var(--muted)', lineHeight:'1.5'
                                                    }}>
                                                        {grade.fixedCharAmount > 0 && grade.fixedChar && (
                                                            <span>+{grade.fixedCharAmount} {grade.fixedChar.name}</span>
                                                        )}
                                                        {grade.charChoices?.length > 0 && (
                                                            <span style={{marginLeft:'4px'}}>
                                                                + choose +5: {grade.charChoices.map(c => c.name).join('/')}
                                                            </span>
                                                        )}
                                                    </div>
                                                </div>
                                            );
                                        })}
                                    </div>
                                </Section>

                                {/* Grade detail — shown when a grade is selected */}
                                {selectedGrade && (
                                    <>
                                        {/* Characteristic Bonuses */}
                                        <Section title="Characteristic Bonuses">
                                            <div style={{display:'flex', flexWrap:'wrap', alignItems:'center', gap:'8px'}}>
                                                {selectedGrade.fixedChar && (
                                                    <span style={{
                                                        display:'inline-flex', alignItems:'center', gap:'8px',
                                                        padding:'8px 16px', border:'1px solid var(--border-strong)',
                                                        background:'rgba(var(--accent-rgb),0.05)',
                                                        fontSize:'18px', color:'var(--ink)'
                                                    }}>
                                                        {selectedGrade.fixedChar.full_name}
                                                        <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'14px', color:'#8b3a3a'}}>
                                                            +{selectedGrade.fixedCharAmount}
                                                        </span>
                                                    </span>
                                                )}
                                            </div>
                                            {selectedGrade.charChoices?.length > 0 && (
                                                <div style={{marginTop:'4px'}}>
                                                    <span style={{
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                                        color:'var(--ink)', textTransform:'uppercase',
                                                        letterSpacing:'2px', display:'block', marginBottom:'8px'
                                                    }}>Choose one additional +5</span>
                                                    <div style={{position:'relative', display:'inline-block'}}>
                                                        <select value={gradeSecondaryCharId}
                                                                onChange={e => setGradeSecondaryCharId(e.target.value)}
                                                                style={{
                                                                    appearance:'none', padding:'8px 28px 8px 12px',
                                                                    border:'1px solid var(--border-strong)',
                                                                    background:'var(--field-bg)', color:'var(--ink)',
                                                                    fontFamily:"'Barlow',sans-serif",
                                                                    fontSize:'17px', outline:'none', minWidth:'200px'
                                                                }}>
                                                            {selectedGrade.charChoices.map(c => (
                                                                <option key={c.id} value={String(c.id)}>{c.full_name}</option>
                                                            ))}
                                                        </select>
                                                        <span style={{
                                                            position:'absolute', right:'10px', top:'50%',
                                                            transform:'translateY(-50%)', pointerEvents:'none', color:'var(--ink)'
                                                        }}>▾</span>
                                                    </div>
                                                </div>
                                            )}
                                        </Section>

                                        {/* Skill Advances */}
                                        <Section title="Skill Advances">
                                            <div style={{
                                                color:'var(--ink)', fontSize:'18px', lineHeight:'1.7',
                                                background:'var(--panel)', padding:'14px 18px',
                                                borderLeft:'2px solid var(--border-strong)'
                                            }}>
                                                You have {selectedGrade.skillPoolSize} Advances to distribute. Maximum 2 per skill.
                                            </div>
                                            {(selectedGrade.allowedSkills || []).map(skill => (
                                                <div key={skill.id} className="skill-row">
                                                    <div style={{flex:1}}>
                                                        <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                                            <div className="skill-name">{skill.name}</div>
                                                            {skill.description && (
                                                                <button className="desc-toggle"
                                                                    onClick={() => setExpandedSkills(p => ({...p, [`g_${skill.id}`]: !p[`g_${skill.id}`]}))}>
                                                                    {expandedSkills[`g_${skill.id}`] ? '▴' : '▾'}
                                                                </button>
                                                            )}
                                                        </div>
                                                        {skill.description && (
                                                            <div className={`skill-desc${expandedSkills[`g_${skill.id}`] ? ' open' : ''}`}>
                                                                {skill.description}
                                                            </div>
                                                        )}
                                                    </div>
                                                    <div className="advance-controls" style={{flexShrink:0}}>
                                                        <button type="button" className="advance-btn" onClick={() => adjustGradeSkill(skill.id, -1)}>−</button>
                                                        <input type="number" className="advance-input" readOnly value={gradeSkillAdvances[skill.id] || 0}/>
                                                        <button type="button" className="advance-btn" onClick={() => adjustGradeSkill(skill.id, 1)}>+</button>
                                                    </div>
                                                </div>
                                            ))}
                                            <div className="remaining">Remaining: {gradePoolSize - totalGradeAdvances}</div>
                                        </Section>

                                        {/* Fixed Talents */}
                                        {selectedGrade.fixedTalents?.length > 0 && (
                                            <Section title="Talents">
                                                <div style={{display:'flex', flexDirection:'column', gap:'8px'}}>
                                                    {selectedGrade.fixedTalents.map(t => (
                                                        <div key={t.id} className="talent-card">
                                                            <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                                                <div className="talent-card-name">{t.name}</div>
                                                                {t.description && (
                                                                    <button className="desc-toggle"
                                                                        onClick={() => setExpandedTalents(p => ({...p, [t.id]: !p[t.id]}))}>
                                                                        {expandedTalents[t.id] ? '▴' : '▾'}
                                                                    </button>
                                                                )}
                                                            </div>
                                                            {t.description && (
                                                                <div className={`talent-desc${expandedTalents[t.id] ? ' open' : ''}`}>{t.description}</div>
                                                            )}
                                                        </div>
                                                    ))}
                                                </div>
                                            </Section>
                                        )}

                                        {/* Fixed Items */}
                                        {selectedGrade.fixedInventory?.length > 0 && (
                                            <Section title="Starting Equipment">
                                                <div className="tag-list">
                                                    {selectedGrade.fixedInventory.map(gi => (
                                                        <div key={gi.id} className="tag">
                                                            {gi.quantity > 1 ? `${gi.quantity}× ` : ''}{gi.inventory?.name}
                                                        </div>
                                                    ))}
                                                </div>
                                            </Section>
                                        )}

                                        {/* Choice Groups */}
                                        {selectedGrade.choiceGroups?.length > 0 && (
                                            <Section title="Choices">
                                                <div style={{display:'flex', flexDirection:'column', gap:'16px'}}>
                                                    {selectedGrade.choiceGroups.map(group => {
                                                        const selectedIds = Array.isArray(gradeChoices[group.id])
                                                            ? gradeChoices[group.id]
                                                            : (gradeChoices[group.id] ? [gradeChoices[group.id]] : []);

                                                        if (group.choiceType === 'INVENTORY') {
                                                            return (
                                                                <div key={group.id} className="choice-group">
                                                                    <div style={{
                                                                        color:'var(--ink)', fontSize:'18px', lineHeight:'1.7',
                                                                        padding:'14px 18px', borderLeft:'2px solid var(--border-strong)'
                                                                    }}>Choose {group.choicesRequired}:</div>
                                                                    {(group.inventoryOptions || []).map(ic => {
                                                                        const isChecked = selectedIds.map(Number).includes(ic.id);
                                                                        return (
                                                                            <label key={ic.id} className="choice-option">
                                                                                <input
                                                                                    type="radio"
                                                                                    name={`gradeInvGroup_${group.id}`}
                                                                                    value={ic.id}
                                                                                    checked={isChecked}
                                                                                    onChange={() => setGradeChoices(c => ({...c, [group.id]: [ic.id]}))}
                                                                                    style={{marginTop:'3px', accentColor:'#8b3a3a'}}
                                                                                />
                                                                                <div className="choice-content">
                                                                                    <div className="reward-line">
                                                                                        • {ic.quantity > 1 ? `${ic.quantity}× ` : ''}{ic.inventory?.name}
                                                                                    </div>
                                                                                </div>
                                                                            </label>
                                                                        );
                                                                    })}
                                                                </div>
                                                            );
                                                        }

                                                        if (group.choiceType === 'TALENT') {
                                                            return (
                                                                <div key={group.id} className="choice-group">
                                                                    <div style={{
                                                                        color:'var(--ink)', fontSize:'18px', lineHeight:'1.7',
                                                                        padding:'14px 18px', borderLeft:'2px solid var(--border-strong)'
                                                                    }}>Choose {group.choicesRequired} talent:</div>
                                                                    {(group.talentOptions || []).map(t => {
                                                                        const isChecked = selectedIds.map(Number).includes(t.id);
                                                                        return (
                                                                            <label key={t.id} className="choice-option">
                                                                                <input
                                                                                    type="radio"
                                                                                    name={`gradeTalentGroup_${group.id}`}
                                                                                    value={t.id}
                                                                                    checked={isChecked}
                                                                                    onChange={() => setGradeChoices(c => ({...c, [group.id]: [t.id]}))}
                                                                                    style={{marginTop:'3px', accentColor:'#8b3a3a'}}
                                                                                />
                                                                                <div className="choice-content">
                                                                                    <div className="reward-line">• {t.name}</div>
                                                                                    {t.description && (
                                                                                        <div style={{
                                                                                            fontFamily:"'Barlow',sans-serif",
                                                                                            fontSize:'13px', color:'var(--muted)',
                                                                                            marginTop:'4px', lineHeight:'1.5'
                                                                                        }}>{t.description}</div>
                                                                                    )}
                                                                                </div>
                                                                            </label>
                                                                        );
                                                                    })}
                                                                </div>
                                                            );
                                                        }
                                                        return null;
                                                    })}
                                                </div>
                                            </Section>
                                        )}

                                        {/* Equipment pack option */}
                                        <Section title="Equipment Pack (Optional)">
                                            <div style={{
                                                color:'var(--ink)', fontSize:'16px', lineHeight:'1.7',
                                                background:'var(--panel)', padding:'14px 18px',
                                                borderLeft:'2px solid var(--border-strong)'
                                            }}>
                                                Optionally replace all starting equipment with an Equipment Pack.
                                            </div>
                                            <div style={{display:'flex', alignItems:'center', gap:'8px', flexWrap:'wrap'}}>
                                                <button type="button"
                                                    onClick={() => setEquipTab(t => t === 'pack' ? 'standard' : 'pack')}
                                                    style={{
                                                        background: equipTab === 'pack' ? 'rgba(139,58,58,0.1)' : 'transparent',
                                                        border: `1px solid ${equipTab === 'pack' ? '#8b3a3a' : 'var(--border-strong)'}`,
                                                        color: equipTab === 'pack' ? '#8b3a3a' : 'var(--muted)',
                                                        padding:'6px 16px', cursor:'pointer', fontSize:'14px',
                                                        fontFamily:"'Barlow',sans-serif"
                                                    }}>
                                                    {equipTab === 'pack' ? '✓ Using Equipment Pack' : 'Use Equipment Pack instead'}
                                                </button>
                                            </div>
                                            {equipTab === 'pack' && (
                                                <div style={{display:'flex', flexDirection:'column', gap:'4px', marginTop:'8px'}}>
                                                    {packs.map(p => (
                                                        <div key={p.pack.id}>
                                                            <div onClick={() => setPackId(p.pack.id)} style={{
                                                                display:'flex', alignItems:'center', gap:'12px',
                                                                padding:'10px 14px',
                                                                border:`1px solid ${packId === p.pack.id ? '#8b3a3a' : 'var(--border)'}`,
                                                                cursor:'pointer',
                                                                background: packId === p.pack.id ? 'rgba(139,58,58,0.04)' : 'rgba(var(--surface-rgb),0.2)',
                                                                transition:'0.15s'
                                                            }}>
                                                                <div style={{
                                                                    width:'13px', height:'13px',
                                                                    border:`2px solid ${packId === p.pack.id ? '#8b3a3a' : 'var(--border-strong)'}`,
                                                                    borderRadius:'50%', flexShrink:0,
                                                                    background: packId === p.pack.id ? '#8b3a3a' : 'transparent'
                                                                }}/>
                                                                <div style={{flex:1, display:'flex', alignItems:'baseline', gap:'10px'}}>
                                                                    <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'18px', color:'var(--ink)'}}>{p.pack.name}</span>
                                                                    <span style={{fontSize:'16px', color:'var(--muted)'}}>{p.pack.cost} sol</span>
                                                                </div>
                                                                <button type="button" onClick={e => {
                                                                    e.stopPropagation();
                                                                    setExpandedPacks(ex => ({...ex, [p.pack.id]: !ex[p.pack.id]}));
                                                                }} style={{
                                                                    background:'transparent', border:'1px solid var(--border-strong)',
                                                                    color:'var(--muted)', width:'22px', height:'22px', fontSize:'10px', cursor:'pointer'
                                                                }}>{expandedPacks[p.pack.id] ? '▲' : '▼'}</button>
                                                            </div>
                                                            {expandedPacks[p.pack.id] && (
                                                                <div style={{
                                                                    padding:'8px 14px 10px 38px', border:'1px solid var(--border)',
                                                                    borderTop:'none', background:'rgba(var(--surface-rgb),0.1)',
                                                                    display:'flex', flexWrap:'wrap', gap:'5px'
                                                                }}>
                                                                    {p.items.map((item, idx) => (
                                                                        item.inventory
                                                                            ? <span key={idx} style={{fontSize:'15px', color:'var(--text)', padding:'3px 10px', border:'1px solid var(--border-strong)'}}>
                                                                                {item.quantity > 1 ? `${item.quantity}× ` : ''}{item.inventory.name}
                                                                              </span>
                                                                            : item.note && <span key={idx} style={{fontSize:'15px', color:'var(--muted)', padding:'3px 10px', border:'1px dashed var(--border)', fontStyle:'italic'}}>{item.note}</span>
                                                                    ))}
                                                                </div>
                                                            )}
                                                        </div>
                                                    ))}
                                                </div>
                                            )}
                                        </Section>
                                    </>
                                )}
                            </>
                        ) : (
                        /* ══ STANDARD FACTION UI ════════════════════════════════════ */
                        <>
                            {/* Characteristics */}
                            <Section title="Characteristic Bonuses">
                                <div style={{display:'flex', flexWrap:'wrap', alignItems:'center', gap:'8px'}}>
                                    {(selected.primaryCharacteristics || []).map((c, i, arr) => (
                                        <span key={c.id} style={{display:'flex', alignItems:'center', gap:'5px'}}>
                                            <span style={{
                                                display:'inline-flex', alignItems:'center', gap:'8px',
                                                padding:'8px 16px', border:'1px solid var(--border-strong)',
                                                background:'rgba(var(--accent-rgb),0.05)', fontSize:'18px', color:'var(--ink)'
                                            }}>
                                                {c.full_name} <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'14px', color:'var(--red)'}}>+5</span>
                                            </span>
                                            {i < arr.length - 1 && <span style={{fontSize:'13px', color:'var(--muted)', fontStyle:'italic'}}>and</span>}
                                        </span>
                                    ))}
                                </div>
                                {selected.secondaryCharacteristics?.length > 0 && (
                                    <div style={{marginTop:'4px'}}>
                                        <span style={{
                                            fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                            color:'var(--ink)', textTransform:'uppercase',
                                            letterSpacing:'2px', display:'block', marginBottom:'8px'
                                        }}>Choose one additional +5</span>
                                        <div style={{position:'relative', display:'inline-block'}}>
                                            <select value={secondaryCharId} onChange={e => setSecondaryCharId(e.target.value)} style={{
                                                appearance:'none', padding:'8px 28px 8px 12px',
                                                border:'1px solid var(--border-strong)', background:'var(--field-bg)',
                                                color:'var(--ink)', fontFamily:"'Barlow',sans-serif",
                                                fontSize:'17px', outline:'none', minWidth:'200px'
                                            }}>
                                                {selected.secondaryCharacteristics.map(c => <option key={c.id} value={String(c.id)}>{c.full_name}</option>)}
                                            </select>
                                            <span style={{position:'absolute', right:'10px', top:'50%', transform:'translateY(-50%)', pointerEvents:'none', color:'var(--ink)'}}>▾</span>
                                        </div>
                                    </div>
                                )}
                            </Section>

                            {/* Skills */}
                            <Section title="Skill Advances">
                                <div style={{
                                    color:'var(--ink)', fontSize:'18px', lineHeight:'1.7',
                                    background:'var(--panel)', padding:'14px 18px', borderLeft:'2px solid var(--border-strong)'
                                }}>
                                    You have 5 Advances to distribute. Maximum 2 per skill.
                                </div>
                                {(selected.skillList || []).map(skill => (
                                    <div key={skill.id} className="skill-row">
                                        <div style={{flex:1}}>
                                            <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                                <div className="skill-name">{skill.name}</div>
                                                {skill.description && (
                                                    <button className="desc-toggle" onClick={() => setExpandedSkills(p => ({...p, [skill.id]: !p[skill.id]}))}>
                                                        {expandedSkills[skill.id] ? '▴' : '▾'}
                                                    </button>
                                                )}
                                            </div>
                                            {skill.description && (
                                                <div className={`skill-desc${expandedSkills[skill.id] ? ' open' : ''}`}>{skill.description}</div>
                                            )}
                                        </div>
                                        <div className="advance-controls" style={{flexShrink:0}}>
                                            <button type="button" className="advance-btn" onClick={() => adjustSkill(skill.id, -1)}>−</button>
                                            <input type="number" className="advance-input" readOnly value={skillAdvances[skill.id] || 0}/>
                                            <button type="button" className="advance-btn" onClick={() => adjustSkill(skill.id, 1)}>+</button>
                                        </div>
                                    </div>
                                ))}
                                <div className="remaining">Remaining: {MAX_SKILL_ADVANCES - totalAdvances}</div>
                            </Section>

                            {/* Talents */}
                            {selected.talentList?.length > 0 && (
                                <Section title="Talents">
                                    <div style={{display:'flex', flexDirection:'column', gap:'8px'}}>
                                        {selected.talentList.map(t => (
                                            <div key={t.id} className="talent-card">
                                                <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                                    <div className="talent-card-name">{t.name}</div>
                                                    {t.description && (
                                                        <button className="desc-toggle" onClick={() => setExpandedTalents(p => ({...p, [t.id]: !p[t.id]}))}>
                                                            {expandedTalents[t.id] ? '▴' : '▾'}
                                                        </button>
                                                    )}
                                                </div>
                                                {t.description && (
                                                    <div className={`talent-desc${expandedTalents[t.id] ? ' open' : ''}`}>{t.description}</div>
                                                )}
                                            </div>
                                        ))}
                                    </div>
                                </Section>
                            )}

                            {/* Equipment tabs */}
                            <Section title="Equipment">
                                <div style={{display:'flex', alignItems:'center', borderBottom:'1px solid var(--border)'}}>
                                    {['standard', 'pack'].map((tab, i) => (
                                        <span key={tab} style={{display:'flex', alignItems:'center'}}>
                                            {i > 0 && <span style={{fontSize:'12px', color:'var(--muted)', padding:'0 6px', fontStyle:'italic'}}>or</span>}
                                            <button type="button" onClick={() => setEquipTab(tab)} style={{
                                                background:'transparent', border:'none',
                                                borderBottom:`2px solid ${equipTab === tab ? 'var(--red)' : 'transparent'}`,
                                                color: equipTab === tab ? 'var(--red)' : 'var(--muted)',
                                                fontSize:'16px', padding:'8px 18px', cursor:'pointer', marginBottom:'-1px',
                                            }}>
                                                {tab === 'standard' ? 'Starting Equipment' : 'Equipment Pack'}
                                            </button>
                                        </span>
                                    ))}
                                </div>

                                {equipTab === 'standard' && (
                                    <div style={{marginTop:'12px'}}>
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
                                                                    <button className="dice-roll-btn" onClick={() => rollDice(qty, rollKey)} title={`Roll ${qty}`}>⚄ {qty}</button>
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
                                            <div style={{marginTop:'16px', display:'flex', flexDirection:'column', gap:'12px'}}>
                                                {selected.choiceGroups.map(group => {
                                                    const multi = group.choicesRequired > 1;
                                                    const selectedIds = Array.isArray(choices[group.id]) ? choices[group.id] : (choices[group.id] ? [choices[group.id]] : []);
                                                    const atLimit = selectedIds.length >= group.choicesRequired;
                                                    return (
                                                        <div key={group.id} className="choice-group">
                                                            <div style={{
                                                                color:'var(--ink)', fontSize:'18px', lineHeight:'1.7',
                                                                padding:'14px 18px', borderLeft:'2px solid var(--border-strong)'
                                                            }}>Choose {group.choicesRequired}:
                                                                {multi && <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'13px', color:'var(--muted)', marginLeft:'8px'}}>{selectedIds.length}/{group.choicesRequired} selected</span>}
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
                                                                            style={{marginTop:'3px', accentColor:'var(--red)'}}
                                                                        />
                                                                        <div className="choice-content">
                                                                            {opt.talents?.map(t => <div key={t.id} className="reward-line">• {t.name}</div>)}
                                                                            {opt.inventory?.map(i => <div key={i.id} className="reward-line">• {i.name}</div>)}
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
                                    <div style={{marginTop:'12px', display:'flex', flexDirection:'column', gap:'4px'}}>
                                        {packs.map(p => (
                                            <div key={p.pack.id}>
                                                <div onClick={() => setPackId(p.pack.id)} style={{
                                                    display:'flex', alignItems:'center', gap:'12px', padding:'10px 14px',
                                                    border:`1px solid ${packId === p.pack.id ? 'var(--red)' : 'var(--border)'}`,
                                                    cursor:'pointer',
                                                    background: packId === p.pack.id ? 'rgba(var(--accent-rgb),0.04)' : 'rgba(var(--surface-rgb),0.2)',
                                                    transition:'0.15s'
                                                }}>
                                                    <div style={{
                                                        width:'13px', height:'13px',
                                                        border:`2px solid ${packId === p.pack.id ? 'var(--red)' : 'var(--border-strong)'}`,
                                                        borderRadius:'50%', flexShrink:0,
                                                        background: packId === p.pack.id ? 'var(--red)' : 'transparent'
                                                    }}/>
                                                    <div style={{flex:1, display:'flex', alignItems:'baseline', gap:'10px'}}>
                                                        <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'18px', color:'var(--ink)'}}>{p.pack.name}</span>
                                                        <span style={{fontSize:'16px', color:'var(--muted)'}}>{p.pack.cost} sol</span>
                                                        <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'12px', letterSpacing:'1px', color:'var(--red)'}}>{p.pack.availability}</span>
                                                    </div>
                                                    <button type="button" onClick={e => {
                                                        e.stopPropagation();
                                                        setExpandedPacks(ex => ({...ex, [p.pack.id]: !ex[p.pack.id]}));
                                                    }} style={{
                                                        background:'transparent', border:'1px solid var(--border-strong)',
                                                        color:'var(--muted)', width:'22px', height:'22px', fontSize:'10px', cursor:'pointer'
                                                    }}>{expandedPacks[p.pack.id] ? '▲' : '▼'}</button>
                                                </div>
                                                {expandedPacks[p.pack.id] && (
                                                    <div style={{
                                                        padding:'8px 14px 10px 38px', border:'1px solid var(--border)',
                                                        borderTop:'none', background:'rgba(var(--surface-rgb),0.1)',
                                                        display:'flex', flexWrap:'wrap', gap:'5px'
                                                    }}>
                                                        {p.items.map((item, idx) => (
                                                            item.inventory
                                                                ? <span key={idx} style={{fontSize:'15px', color:'var(--text)', padding:'3px 10px', border:'1px solid var(--border-strong)'}}>
                                                                    {item.quantity > 1 ? `${item.quantity}× ` : ''}{item.inventory.name}
                                                                  </span>
                                                                : item.note && <span key={idx} style={{fontSize:'15px', color:'var(--muted)', padding:'3px 10px', border:'1px dashed var(--border)', fontStyle:'italic'}}>{item.note}</span>
                                                        ))}
                                                    </div>
                                                )}
                                            </div>
                                        ))}
                                    </div>
                                )}
                            </Section>
                        </>
                        )}

                        <button onClick={handleSubmit} className="select-btn" style={{width:'100%'}} disabled={!canSubmit}>
                            Select Faction
                        </button>
                    </div>
                </div>
            </div>
        </>
    );
}

function Section({title, children}) {
    return (
        <div style={{display:'flex', flexDirection:'column', gap:'12px'}}>
            <div style={{
                fontFamily:"'Barlow', sans-serif", color:'var(--ink)',
                textTransform:'uppercase', letterSpacing:'3px', fontSize:'15px',
                display:'flex', alignItems:'center', gap:'10px'
            }}>
                {title}<span style={{flex:1, height:'1px', background:'var(--border)'}}/>
            </div>
            {children}
        </div>
    );
}