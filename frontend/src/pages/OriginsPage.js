import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {getOrigins, getAugmetics, getSubtleMutationsTable} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

export default function OriginsPage() {
    const [origins, setOrigins]         = useState([]);
    const [selected, setSelected]       = useState(null);
    const [secondaryChar, setSecondaryChar] = useState('');
    const [originSkillChoice, setOriginSkillChoice] = useState('');
    const [originSpecChoice, setOriginSpecChoice]   = useState('');
    const [originSpecTopics, setOriginSpecTopics]   = useState({});
    const [augmetics, setAugmetics]     = useState([]);
    const [originAugmeticId, setOriginAugmeticId]   = useState(null);
    const [originAugmeticTrait, setOriginAugmeticTrait] = useState('Bulky');
    const [subtleTable, setSubtleTable]         = useState(null);
    const [positiveMutation, setPositiveMutation] = useState(null);
    const [negativeMutation, setNegativeMutation] = useState(null);
    const [positiveRoll, setPositiveRoll]         = useState(null);
    const [negativeRoll, setNegativeRoll]         = useState(null);
    const [loading, setLoading]                   = useState(true);
    const navigate  = useNavigate();
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
        if (!selected) return;

        // Secondary characteristic
        if (selected.secondaryCharacteristsics?.length > 0) {
            if (selected.id === ccm.originId && ccm.originSecondaryCharName) {
                setSecondaryChar(ccm.originSecondaryCharName);
            } else {
                setSecondaryChar(selected.secondaryCharacteristsics[0].name);
            }
        } else {
            setSecondaryChar('');
        }

        // Skill choice (choice = true rows)
        const skillChoices = (selected.skillAdvances || []).filter(s => s.choice);
        if (skillChoices.length > 0) {
            if (selected.id === ccm.originId && ccm.originSkillChoice) {
                setOriginSkillChoice(ccm.originSkillChoice);
            } else {
                setOriginSkillChoice(skillChoices[0].skill.name);
            }
        } else {
            setOriginSkillChoice('');
        }

        // Spec choice (choice = true rows)
        const specChoices = (selected.specAdvances || []).filter(s => s.choice);
        if (specChoices.length > 0) {
            if (selected.id === ccm.originId && ccm.originSpecChoice) {
                setOriginSpecChoice(ccm.originSpecChoice);
            } else {
                setOriginSpecChoice(specChoices[0].specialization.name);
            }
        } else {
            setOriginSpecChoice('');
        }

        // Spec topics (restore per-spec text inputs)
        if (selected.id === ccm.originId && ccm.originSpecTopics) {
            setOriginSpecTopics(ccm.originSpecTopics);
        } else {
            setOriginSpecTopics({});
        }

        // Augmetic choice (UNUSUAL AUGMENT only)
        if (selected.name === 'UNUSUAL AUGMENT') {
            if (augmetics.length === 0) {
                getAugmetics().then(data => {
                    setAugmetics(data);
                    if (selected.id === ccm.originId && ccm.originAugmeticId) {
                        setOriginAugmeticId(ccm.originAugmeticId);
                        setOriginAugmeticTrait(ccm.originAugmeticTrait || 'Bulky');
                    } else if (data.length > 0) {
                        setOriginAugmeticId(data[0].id);
                        setOriginAugmeticTrait('Bulky');
                    }
                });
            } else {
                if (selected.id === ccm.originId && ccm.originAugmeticId) {
                    setOriginAugmeticId(ccm.originAugmeticId);
                    setOriginAugmeticTrait(ccm.originAugmeticTrait || 'Bulky');
                } else {
                    setOriginAugmeticId(augmetics[0]?.id || null);
                    setOriginAugmeticTrait('Bulky');
                }
            }
        } else {
            setOriginAugmeticId(null);
            setOriginAugmeticTrait('Bulky');
        }

        // Subtle Mutations (MUTANT origin)
        if (selected.name === 'MUTANT') {
            const restoreFromCCM = (tbl) => {
                if (selected.id === ccm.originId) {
                    if (ccm.subtleMutationPositiveId) {
                        const row = tbl.find(r => r.positive.id === ccm.subtleMutationPositiveId);
                        setPositiveMutation(row ? row.positive : null);
                    } else {
                        setPositiveMutation(null);
                    }
                    if (ccm.subtleMutationNegativeId) {
                        const row = tbl.find(r => r.negative.id === ccm.subtleMutationNegativeId);
                        setNegativeMutation(row ? row.negative : null);
                    } else {
                        setNegativeMutation(null);
                    }
                } else {
                    setPositiveMutation(null);
                    setNegativeMutation(null);
                }
                setPositiveRoll(null);
                setNegativeRoll(null);
            };
            if (!subtleTable) {
                getSubtleMutationsTable().then(tbl => {
                    setSubtleTable(tbl);
                    restoreFromCCM(tbl);
                });
            } else {
                restoreFromCCM(subtleTable);
            }
        } else {
            setPositiveMutation(null);
            setNegativeMutation(null);
            setPositiveRoll(null);
            setNegativeRoll(null);
        }
    }, [selected]); // eslint-disable-line react-hooks/exhaustive-deps

    const handleSelect = () => {
        if (!selected) return;

        const chars = {...ccm.characteristics};
        (ccm.originPrimaryCharNames || '').split(', ').filter(Boolean).forEach(name => {
            if (chars[name]) chars[name] = String(parseInt(chars[name]) - 5);
        });
        if (ccm.originSecondaryCharName && chars[ccm.originSecondaryCharName]) {
            chars[ccm.originSecondaryCharName] = String(parseInt(chars[ccm.originSecondaryCharName]) - 5);
        }

        const primaryNames = (selected.primaryCharacteristsics || []).map(c => c.name).join(', ');
        (selected.primaryCharacteristsics || []).forEach(c => {
            if (chars[c.name]) chars[c.name] = String(parseInt(chars[c.name]) + 5);
        });
        if (secondaryChar && chars[secondaryChar]) {
            chars[secondaryChar] = String(parseInt(chars[secondaryChar]) + 5);
        }

        const charBonuses = [
            ...(selected.primaryCharacteristsics || []).map(c => `+5 ${c.name}`),
            ...(secondaryChar ? [`+5 ${secondaryChar} (chosen)`] : []),
        ].join(', ');

        // Skill summary for progress bar
        const _originSkillSummary = (selected.skillAdvances || [])
            .filter(s => !s.choice || s.skill.name === originSkillChoice)
            .map(s => `${s.skill.name} ×${s.advances}`)
            .join(', ');

        // Spec summary for progress bar
        const _originSpecSummary = (selected.specAdvances || [])
            .filter(s => !s.choice || s.specialization.name === originSpecChoice)
            .map(s => {
                const topic = originSpecTopics[String(s.specialization.id)];
                return topic ? `${s.specialization.name}: ${topic}` : s.specialization.name;
            })
            .join(', ');

        const talentSummary = (selected.talentList || []).map(t => t.name).join(', ');
        const staticItems = (selected.startingItems || [])
            .map(i => {
                const name = i.inventory?.name;
                if (!name) return null;
                const mods = (i.modifiers || []).map(m => m.name).join(', ');
                return mods ? `${name} [${mods}]` : name;
            })
            .filter(Boolean);

        const augmeticItem = originAugmeticId
            ? augmetics.find(a => a.id === originAugmeticId) : null;
        if (augmeticItem) {
            staticItems.push(`${augmeticItem.name} [${originAugmeticTrait}]`);
        }

        const itemSummary = staticItems.join(', ');

        // Build skill advances map {skillId: advances}
        const originSkillAdvances = {};
        (selected.skillAdvances || []).forEach(s => {
            if (!s.choice) {
                // auto-granted
                originSkillAdvances[s.skill.id] = (originSkillAdvances[s.skill.id] || 0) + s.advances;
            } else if (s.skill.name === originSkillChoice) {
                // chosen option
                originSkillAdvances[s.skill.id] = (originSkillAdvances[s.skill.id] || 0) + s.advances;
            }
        });

        // Build spec advances map {specId: advances}
        const originSpecAdvances = {};
        (selected.specAdvances || []).forEach(s => {
            if (!s.choice) {
                // auto-granted
                originSpecAdvances[s.specialization.id] = (originSpecAdvances[s.specialization.id] || 0) + s.advances;
            } else if (s.specialization.name === originSpecChoice) {
                // chosen option
                originSpecAdvances[s.specialization.id] = (originSpecAdvances[s.specialization.id] || 0) + s.advances;
            }
        });

        dispatch({
            type: 'SET_ORIGIN',
            payload: {
                originId: selected.id,
                originPrimaryCharNames: primaryNames,
                originSecondaryCharName: secondaryChar,
                originSkillChoice,
                originSpecChoice,
                originSkillAdvances,
                originSpecAdvances,
                originSpecTopics,
                originAugmeticId: originAugmeticId || null,
                originAugmeticName: augmeticItem?.name || '',
                originAugmeticTrait: originAugmeticId ? originAugmeticTrait : '',
                characteristics: chars,
                _originName: selected.name,
                _originCharBonuses: charBonuses,
                _originSkillSummary,
                _originSpecSummary,
                _originTalents: talentSummary,
                _originItems: itemSummary,
                subtleMutationPositiveId: positiveMutation?.id || null,
                subtleMutationNegativeId: negativeMutation?.id || null,
                _subtleMutationSummary: [positiveMutation?.name, negativeMutation?.name].filter(Boolean).join(' / '),
            },
        });
        navigate('/factions');
    };

    const rollPositive = () => {
        if (!subtleTable) return;
        const roll = Math.floor(Math.random() * 100) + 1;
        const row = subtleTable.find(r => roll >= r.d100Min && roll <= r.d100Max);
        setPositiveRoll(roll);
        setPositiveMutation(row ? row.positive : null);
    };

    const rollNegative = () => {
        if (!subtleTable) return;
        const roll = Math.floor(Math.random() * 100) + 1;
        const row = subtleTable.find(r => roll >= r.d100Min && roll <= r.d100Max);
        setNegativeRoll(roll);
        setNegativeMutation(row ? row.negative : null);
    };

    // ── Grouping ──────────────────────────────────────────────────────
    const imOrigins = origins.filter(o => !o.sourceBook || o.sourceBook === 'IM');
    const inOrigins = origins.filter(o => o.sourceBook === 'IN');
    const inByCategory = inOrigins.reduce((acc, o) => {
        const key = o.category?.name || 'OTHER';
        if (!acc[key]) acc[key] = {category: o.category, origins: []};
        acc[key].origins.push(o);
        return acc;
    }, {});
    const amOrigins = origins.filter(o => o.sourceBook === 'AM');

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

                {/* ── Left nav ────────────────────────────────────────── */}
                <nav style={{borderRight: '1px solid var(--border)', background: 'var(--bg)'}}>
                    <div style={{position:'sticky', top:'100px', overflowY:'auto', maxHeight:'calc(100vh - 100px)'}}>
                        <div style={{
                            fontFamily:"'Barlow', sans-serif", fontSize:'12px',
                            textTransform:'uppercase', letterSpacing:'3px',
                            color:'var(--muted)', padding:'18px 24px 14px',
                            borderBottom:'1px solid var(--border)'
                        }}>
                            Choose Origin
                        </div>

                        {/* Core origins */}
                        {imOrigins.length > 0 && (
                            <>
                                <BookSectionHeader>Imperium Maledictum</BookSectionHeader>
                                {imOrigins.map(o => (
                                    <OriginNavItem key={o.id} origin={o} selected={selected} onSelect={setSelected}/>
                                ))}
                            </>
                        )}

                        {/* Inquisition origins grouped by category */}
                        {Object.keys(inByCategory).length > 0 && (
                            <>
                                <BookSectionHeader inquisition>Inquisition Supplement</BookSectionHeader>
                                {Object.entries(inByCategory).map(([catName, {origins: catOrigins}]) => (
                                    <div key={catName}>
                                        <CategoryHeader>{catName}</CategoryHeader>
                                        {catOrigins.map(o => (
                                            <OriginNavItem key={o.id} origin={o} selected={selected} onSelect={setSelected} indented/>
                                        ))}
                                    </div>
                                ))}
                            </>
                        )}

                        {/* Adeptus Mechanicus origins (flat list) */}
                        {amOrigins.length > 0 && (
                            <>
                                <BookSectionHeader am>Adeptus Mechanicus</BookSectionHeader>
                                {amOrigins.map(o => (
                                    <OriginNavItem key={o.id} origin={o} selected={selected} onSelect={setSelected}/>
                                ))}
                            </>
                        )}
                    </div>
                </nav>

                {/* ── Right detail ─────────────────────────────────────── */}
                <div style={{
                    display:'flex', justifyContent:'center', alignItems:'flex-start',
                    padding:'40px 32px 80px', background:'var(--panel)'
                }}>
                    {selected && (
                        <div style={{display:'flex', flexDirection:'column', gap:'24px', width:'100%', maxWidth:'720px'}}>

                            {/* Source badge */}
                            {selected.sourceBook === 'IN' && (
                                <div style={{display:'flex', alignItems:'center', gap:'10px'}}>
                                    <span style={{
                                        fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                        letterSpacing:'3px', textTransform:'uppercase',
                                        color:'#a07840', background:'rgba(160,120,64,0.12)',
                                        border:'1px solid rgba(160,120,64,0.4)',
                                        padding:'3px 10px'
                                    }}>Inquisition Supplement</span>
                                    {selected.category && (
                                        <span style={{
                                            fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                            letterSpacing:'2px', textTransform:'uppercase',
                                            color:'var(--muted)'
                                        }}>{selected.category.name}</span>
                                    )}
                                </div>
                            )}
                            {selected.sourceBook === 'AM' && (
                                <div style={{display:'flex', alignItems:'center', gap:'10px'}}>
                                    <span style={{
                                        fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                        letterSpacing:'3px', textTransform:'uppercase',
                                        color:'#8b3a3a', background:'rgba(139,58,58,0.12)',
                                        border:'1px solid rgba(139,58,58,0.4)',
                                        padding:'3px 10px'
                                    }}>Adeptus Mechanicus</span>
                                    {selected.category && (
                                        <span style={{
                                            fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                            letterSpacing:'2px', textTransform:'uppercase',
                                            color:'var(--muted)'
                                        }}>{selected.category.name}</span>
                                    )}
                                </div>
                            )}

                            {/* Category description (IN / AM) */}
                            {selected.sourceBook === 'IN' && selected.category?.description && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>{selected.category.name}</SectionTitle>
                                    <Description italic>{selected.category.description}</Description>
                                </div>
                            )}
                            {selected.sourceBook === 'AM' && selected.category?.description && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>{selected.category.name}</SectionTitle>
                                    <Description italic>{selected.category.description}</Description>
                                </div>
                            )}

                            {/* Origin name */}
                            <div style={{
                                fontFamily:"'Barlow', sans-serif", fontSize:'32px',
                                color:'var(--ink)', lineHeight:'1.1'
                            }}>{selected.name}</div>

                            {/* Background */}
                            {selected.description && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>Background</SectionTitle>
                                    <Description>{selected.description}</Description>
                                </div>
                            )}

                            {/* Examples */}
                            {selected.examples && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>Examples</SectionTitle>
                                    <Description>{selected.examples}</Description>
                                </div>
                            )}

                            {/* Characteristic Bonuses */}
                            {((selected.primaryCharacteristsics?.length > 0) || (selected.secondaryCharacteristsics?.length > 0)) && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>Characteristic Bonuses</SectionTitle>
                                    <div style={{display:'flex', flexWrap:'wrap', alignItems:'center', gap:'8px'}}>
                                        {(selected.primaryCharacteristsics || []).map((c, i, arr) => (
                                            <span key={c.id} style={{display:'flex', alignItems:'center', gap:'5px'}}>
                                                <span style={{
                                                    display:'inline-flex', alignItems:'center', gap:'8px',
                                                    padding:'8px 16px', border:'1px solid var(--border-strong)',
                                                    background:'rgba(var(--accent-rgb),0.05)', fontSize:'18px', color:'var(--ink)'
                                                }}>
                                                    {c.full_name}
                                                    <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'14px', color:'var(--red)'}}>+5</span>
                                                </span>
                                                {i < arr.length - 1 && (
                                                    <span style={{fontSize:'13px', color:'var(--muted)', fontStyle:'italic'}}>and</span>
                                                )}
                                            </span>
                                        ))}
                                    </div>
                                    {selected.secondaryCharacteristsics?.length > 0 && (
                                        <div style={{marginTop:'4px'}}>
                                            <span style={{
                                                fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                                color:'var(--ink)', textTransform:'uppercase',
                                                letterSpacing:'2px', display:'block', marginBottom:'8px'
                                            }}>Choose one additional +5</span>
                                            <div style={{position:'relative', display:'inline-block'}}>
                                                <select
                                                    value={secondaryChar}
                                                    onChange={e => setSecondaryChar(e.target.value)}
                                                    style={{
                                                        appearance:'none', padding:'8px 28px 8px 12px',
                                                        border:'1px solid var(--border-strong)',
                                                        background:'var(--field-bg)', color:'var(--ink)',
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'18px',
                                                        outline:'none', minWidth:'200px'
                                                    }}
                                                >
                                                    {selected.secondaryCharacteristsics.map(c => (
                                                        <option key={c.id} value={c.name}>{c.full_name}</option>
                                                    ))}
                                                </select>
                                                <span style={{
                                                    position:'absolute', right:'10px', top:'50%',
                                                    transform:'translateY(-50%)', pointerEvents:'none', color:'var(--ink)'
                                                }}>▾</span>
                                            </div>
                                        </div>
                                    )}
                                </div>
                            )}

                            {/* Starting Talents (IN origins) */}
                            {selected.talentList?.length > 0 && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>Starting Talents</SectionTitle>
                                    <div style={{display:'flex', flexWrap:'wrap', gap:'8px'}}>
                                        {selected.talentList.map(t => (
                                            <span key={t.id} style={{
                                                fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                letterSpacing:'2px', textTransform:'uppercase',
                                                padding:'6px 14px', border:'1px solid var(--border-strong)',
                                                color:'var(--ink)', background:'rgba(var(--accent-rgb),0.05)'
                                            }}>{t.name}</span>
                                        ))}
                                    </div>
                                </div>
                            )}

                            {/* Starting Items (IN origins) */}
                            {selected.startingItems?.length > 0 && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>Starting Items</SectionTitle>
                                    <div style={{display:'flex', flexDirection:'column', gap:'6px'}}>
                                        {selected.startingItems.map(item => (
                                            <div key={item.id} style={{display:'flex', flexDirection:'column', gap:'4px'}}>
                                                <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                                    <span style={{
                                                        padding:'6px 14px', border:'1px solid var(--border)',
                                                        background:'var(--bg)', color:'var(--ink)',
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'15px'
                                                    }}>
                                                        {item.inventory?.name}
                                                    </span>
                                                    {(item.modifiers || []).map(m => (
                                                        <span key={m.id} className={`item-modifier item-modifier--${m.type}`}>
                                                            {m.name}
                                                        </span>
                                                    ))}
                                                </div>
                                                {item.notes && (
                                                    <span style={{
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                        fontStyle:'italic', color:'var(--muted)',
                                                        paddingLeft:'4px'
                                                    }}>{item.notes}</span>
                                                )}
                                            </div>
                                        ))}
                                    </div>
                                </div>
                            )}

                            {/* Augmetic Choice (UNUSUAL AUGMENT) */}
                            {selected.name === 'UNUSUAL AUGMENT' && (
                                <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                    <SectionTitle>Choose Your Augmetic</SectionTitle>
                                    <span style={{
                                        fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                        color:'var(--muted)', fontStyle:'italic'
                                    }}>
                                        Any augmetic of your choice, with either the Bulky or Ugly Trait.
                                        Work with your GM to decide its origin.
                                    </span>

                                    {/* Augmetic dropdown */}
                                    <div>
                                        <span style={{
                                            fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                            color:'var(--ink)', textTransform:'uppercase',
                                            letterSpacing:'2px', display:'block', marginBottom:'8px'
                                        }}>Select Augmetic</span>
                                        {augmetics.length === 0
                                            ? <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'13px', color:'var(--muted)'}}>Loading…</span>
                                            : (
                                                <div style={{position:'relative', display:'inline-block'}}>
                                                    <select
                                                        value={originAugmeticId || ''}
                                                        onChange={e => setOriginAugmeticId(Number(e.target.value))}
                                                        style={{
                                                            appearance:'none', padding:'8px 28px 8px 12px',
                                                            border:'1px solid var(--border-strong)',
                                                            background:'var(--field-bg)', color:'var(--ink)',
                                                            fontFamily:"'Barlow',sans-serif", fontSize:'16px',
                                                            outline:'none', minWidth:'260px'
                                                        }}
                                                    >
                                                        {augmetics.map(a => (
                                                            <option key={a.id} value={a.id}>{a.name}</option>
                                                        ))}
                                                    </select>
                                                    <span style={{
                                                        position:'absolute', right:'10px', top:'50%',
                                                        transform:'translateY(-50%)', pointerEvents:'none', color:'var(--ink)'
                                                    }}>▾</span>
                                                </div>
                                            )
                                        }
                                    </div>

                                    {/* Trait choice */}
                                    <div>
                                        <span style={{
                                            fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                            color:'var(--ink)', textTransform:'uppercase',
                                            letterSpacing:'2px', display:'block', marginBottom:'8px'
                                        }}>Trait</span>
                                        <div style={{display:'flex', gap:'8px'}}>
                                            {['Bulky', 'Ugly'].map(trait => (
                                                <button
                                                    key={trait}
                                                    onClick={() => setOriginAugmeticTrait(trait)}
                                                    style={{
                                                        padding:'8px 20px',
                                                        border: originAugmeticTrait === trait
                                                            ? '1px solid #085d65'
                                                            : '1px solid var(--border-strong)',
                                                        background: originAugmeticTrait === trait
                                                            ? 'rgba(8,93,101,0.2)'
                                                            : 'transparent',
                                                        color: 'var(--ink)',
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'14px',
                                                        letterSpacing:'2px', textTransform:'uppercase',
                                                        cursor:'pointer'
                                                    }}
                                                >{trait}</button>
                                            ))}
                                        </div>
                                    </div>
                                </div>
                            )}

                            {/* Subtle Mutations (MUTANT origin) */}
                            {selected.name === 'MUTANT' && (
                                <div style={{display:'flex', flexDirection:'column', gap:'14px'}}>
                                    <SectionTitle>Subtle Mutations</SectionTitle>
                                    {(() => {
                                        const desc = selected.talentList?.find(t => t.name === 'SUBTLE MUTATION')?.description;
                                        return desc ? <Description>{desc}</Description> : null;
                                    })()}
                                    {!subtleTable && (
                                        <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'13px', color:'var(--muted)'}}>Loading table…</span>
                                    )}
                                    {subtleTable && ['positive', 'negative'].map(polarity => {
                                        const isPos = polarity === 'positive';
                                        const roll = isPos ? positiveRoll : negativeRoll;
                                        const mut  = isPos ? positiveMutation : negativeMutation;
                                        const doRoll = isPos ? rollPositive : rollNegative;
                                        return (
                                            <div key={polarity} style={{display:'flex', flexDirection:'column', gap:'8px'}}>
                                                <span style={{
                                                    fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                                    color:'var(--ink)', textTransform:'uppercase', letterSpacing:'2px'
                                                }}>{isPos ? 'Positive Mutation' : 'Negative Mutation'}</span>
                                                <div style={{display:'flex', alignItems:'center', gap:'12px', flexWrap:'wrap'}}>
                                                    <button
                                                        onClick={doRoll}
                                                        style={{
                                                            padding:'8px 20px',
                                                            border:'1px solid var(--border-strong)',
                                                            background:'transparent', color:'var(--ink)',
                                                            fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                            letterSpacing:'2px', textTransform:'uppercase',
                                                            cursor:'pointer'
                                                        }}
                                                    >Roll d100</button>
                                                    {roll && (
                                                        <span style={{
                                                            fontFamily:"'Barlow',sans-serif", fontSize:'13px', color:'var(--muted)'
                                                        }}>({roll})</span>
                                                    )}
                                                    {mut && (
                                                        <span style={{
                                                            fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                            letterSpacing:'2px', textTransform:'uppercase',
                                                            padding:'6px 14px', border:'1px solid var(--border-strong)',
                                                            color:'var(--ink)', background:'rgba(var(--accent-rgb),0.05)'
                                                        }}>{mut.name}</span>
                                                    )}
                                                </div>
                                                {mut?.description && (
                                                    <div style={{
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                        color:'var(--muted)', fontStyle:'italic',
                                                        paddingLeft:'4px', lineHeight:'1.5'
                                                    }}>{mut.description}</div>
                                                )}
                                            </div>
                                        );
                                    })}
                                </div>
                            )}

                            {/* Skill Advances */}
                            {selected.skillAdvances?.length > 0 && (() => {
                                const fixed  = selected.skillAdvances.filter(s => !s.choice);
                                const choices = selected.skillAdvances.filter(s => s.choice);
                                return (
                                    <div style={{display:'flex', flexDirection:'column', gap:'10px'}}>
                                        <SectionTitle>Skill Advances</SectionTitle>
                                        {fixed.map(s => (
                                            <div key={s.id} style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                                <span style={{
                                                    fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                    letterSpacing:'2px', textTransform:'uppercase',
                                                    padding:'6px 14px', border:'1px solid var(--border-strong)',
                                                    color:'var(--ink)', background:'rgba(var(--accent-rgb),0.05)'
                                                }}>{s.skill.name}</span>
                                                <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'13px', color:'var(--muted)'}}>
                                                    {s.advances === 1 ? '1 advance' : `${s.advances} advances`}
                                                </span>
                                            </div>
                                        ))}
                                        {choices.length > 0 && (
                                            <div>
                                                <span style={{
                                                    fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                                    color:'var(--ink)', textTransform:'uppercase',
                                                    letterSpacing:'2px', display:'block', marginBottom:'8px'
                                                }}>
                                                    Choose one ({choices[0].advances === 1 ? '1 advance' : `${choices[0].advances} advances`})
                                                </span>
                                                <div style={{position:'relative', display:'inline-block'}}>
                                                    <select
                                                        value={originSkillChoice}
                                                        onChange={e => setOriginSkillChoice(e.target.value)}
                                                        style={{
                                                            appearance:'none', padding:'8px 28px 8px 12px',
                                                            border:'1px solid var(--border-strong)',
                                                            background:'var(--field-bg)', color:'var(--ink)',
                                                            fontFamily:"'Barlow',sans-serif", fontSize:'16px',
                                                            outline:'none', minWidth:'200px'
                                                        }}
                                                    >
                                                        {choices.map(s => (
                                                            <option key={s.id} value={s.skill.name}>{s.skill.name}</option>
                                                        ))}
                                                    </select>
                                                    <span style={{
                                                        position:'absolute', right:'10px', top:'50%',
                                                        transform:'translateY(-50%)', pointerEvents:'none', color:'var(--ink)'
                                                    }}>▾</span>
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                );
                            })()}

                            {/* Specialization Advances */}
                            {selected.specAdvances?.length > 0 && (() => {
                                const fixed   = selected.specAdvances.filter(s => !s.choice);
                                const choices = selected.specAdvances.filter(s => s.choice);
                                const chosenSpecId = choices.find(s => s.specialization.name === originSpecChoice)?.specialization.id;
                                const updateTopic = (specId, value) =>
                                    setOriginSpecTopics(prev => ({...prev, [String(specId)]: value}));
                                return (
                                    <div style={{display:'flex', flexDirection:'column', gap:'14px'}}>
                                        <SectionTitle>Specialization Advances</SectionTitle>

                                        {/* Fixed (auto-granted) specs */}
                                        {fixed.map(s => (
                                            <div key={s.id} style={{display:'flex', flexDirection:'column', gap:'6px'}}>
                                                <div style={{display:'flex', alignItems:'center', gap:'8px', flexWrap:'wrap'}}>
                                                    {s.skill && (
                                                        <span style={{
                                                            fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                            letterSpacing:'1px', color:'var(--muted)'
                                                        }}>{s.skill.name}</span>
                                                    )}
                                                    <span style={{
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'13px',
                                                        letterSpacing:'2px', textTransform:'uppercase',
                                                        padding:'6px 14px', border:'1px solid var(--border-strong)',
                                                        color:'var(--ink)', background:'rgba(var(--accent-rgb),0.05)'
                                                    }}>{s.specialization.name}</span>
                                                    <span style={{fontFamily:"'Barlow',sans-serif", fontSize:'13px', color:'var(--muted)'}}>
                                                        {s.advances === 1 ? '1 advance' : `${s.advances} advances`}
                                                    </span>
                                                </div>
                                                <input
                                                    type="text"
                                                    placeholder="Specify topic (e.g. Illisear's Daemonic Presence)"
                                                    value={originSpecTopics[String(s.specialization.id)] || ''}
                                                    onChange={e => updateTopic(s.specialization.id, e.target.value)}
                                                    style={{
                                                        padding:'7px 12px', border:'1px solid var(--border)',
                                                        background:'var(--field-bg)', color:'var(--ink)',
                                                        fontFamily:"'Barlow',sans-serif", fontSize:'14px',
                                                        outline:'none', width:'100%', maxWidth:'420px',
                                                        fontStyle: originSpecTopics[String(s.specialization.id)] ? 'normal' : 'italic'
                                                    }}
                                                />
                                            </div>
                                        ))}

                                        {/* Choice specs */}
                                        {choices.length > 0 && (
                                            <div style={{display:'flex', flexDirection:'column', gap:'6px'}}>
                                                <span style={{
                                                    fontFamily:"'Barlow',sans-serif", fontSize:'12px',
                                                    color:'var(--ink)', textTransform:'uppercase',
                                                    letterSpacing:'2px'
                                                }}>
                                                    Choose one ({choices[0].advances === 1 ? '1 advance' : `${choices[0].advances} advances`})
                                                </span>
                                                <div style={{display:'flex', alignItems:'center', gap:'10px', flexWrap:'wrap'}}>
                                                    <div style={{position:'relative', display:'inline-block'}}>
                                                        <select
                                                            value={originSpecChoice}
                                                            onChange={e => setOriginSpecChoice(e.target.value)}
                                                            style={{
                                                                appearance:'none', padding:'8px 28px 8px 12px',
                                                                border:'1px solid var(--border-strong)',
                                                                background:'var(--field-bg)', color:'var(--ink)',
                                                                fontFamily:"'Barlow',sans-serif", fontSize:'16px',
                                                                outline:'none', minWidth:'200px'
                                                            }}
                                                        >
                                                            {choices.map(s => (
                                                                <option key={s.id} value={s.specialization.name}>
                                                                    {s.skill ? `${s.skill.name} (${s.specialization.name})` : s.specialization.name}
                                                                </option>
                                                            ))}
                                                        </select>
                                                        <span style={{
                                                            position:'absolute', right:'10px', top:'50%',
                                                            transform:'translateY(-50%)', pointerEvents:'none', color:'var(--ink)'
                                                        }}>▾</span>
                                                    </div>
                                                    {chosenSpecId && (
                                                        <input
                                                            type="text"
                                                            placeholder="Specify topic (optional)"
                                                            value={originSpecTopics[String(chosenSpecId)] || ''}
                                                            onChange={e => updateTopic(chosenSpecId, e.target.value)}
                                                            style={{
                                                                padding:'7px 12px', border:'1px solid var(--border)',
                                                                background:'var(--field-bg)', color:'var(--ink)',
                                                                fontFamily:"'Barlow',sans-serif", fontSize:'14px',
                                                                outline:'none', minWidth:'180px',
                                                                fontStyle: originSpecTopics[String(chosenSpecId)] ? 'normal' : 'italic'
                                                            }}
                                                        />
                                                    )}
                                                </div>
                                            </div>
                                        )}
                                    </div>
                                );
                            })()}

                            <button onClick={handleSelect} className="select-btn" style={{width:'100%'}}>
                                Select Origin
                            </button>
                        </div>
                    )}
                </div>
            </div>
        </>
    );
}

// ── Sub-components ────────────────────────────────────────────────────

function BookSectionHeader({children, inquisition, am}) {
    const color = inquisition ? '#a07840' : am ? '#8b3a3a' : 'var(--muted)';
    const borderColor = inquisition ? 'rgba(160,120,64,0.25)' : am ? 'rgba(139,58,58,0.25)' : 'none';
    const bg = inquisition ? 'rgba(160,120,64,0.04)' : am ? 'rgba(139,58,58,0.04)' : 'transparent';
    return (
        <div style={{
            fontFamily:"'Barlow', sans-serif", fontSize:'11px',
            textTransform:'uppercase', letterSpacing:'3px',
            color,
            padding:'14px 24px 6px',
            borderTop:'1px solid var(--border)',
            borderBottom: (inquisition || am) ? `1px solid ${borderColor}` : 'none',
            background: bg,
            marginTop: '4px'
        }}>
            {children}
        </div>
    );
}

function CategoryHeader({children}) {
    return (
        <div style={{
            fontFamily:"'Barlow', sans-serif", fontSize:'11px',
            textTransform:'uppercase', letterSpacing:'2px',
            color:'var(--muted)', padding:'10px 24px 4px 28px',
            borderLeft:'2px solid rgba(160,120,64,0.3)'
        }}>
            {children}
        </div>
    );
}

function OriginNavItem({origin, selected, onSelect, indented}) {
    const isSelected = selected?.id === origin.id;
    return (
        <div
            onClick={() => onSelect(origin)}
            style={{
                display:'flex', alignItems:'center', gap:'14px',
                padding: indented ? '10px 24px 10px 32px' : '14px 24px',
                cursor:'pointer',
                borderLeft:`3px solid ${isSelected ? 'var(--red)' : 'transparent'}`,
                background: isSelected ? 'rgba(var(--accent-rgb),0.07)' : 'transparent',
                transition:'0.15s',
            }}
        >
            <div style={{
                width: indented ? '7px' : '9px',
                height: indented ? '7px' : '9px',
                borderRadius:'50%',
                background: isSelected ? 'var(--red)' : 'var(--border-strong)',
                flexShrink: 0
            }}/>
            <div>
                <div style={{
                    fontFamily:"'Barlow', sans-serif",
                    fontSize: indented ? '14px' : '15px',
                    color: isSelected ? 'var(--red)' : 'var(--ink)'
                }}>{origin.name}</div>
                <div style={{display:'flex', gap:'4px', marginTop:'4px', flexWrap:'wrap'}}>
                    {(origin.primaryCharacteristsics || []).map(c => (
                        <span key={c.id} style={{
                            fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                            letterSpacing:'1px', color:'var(--muted)',
                            background:'rgba(var(--accent-rgb),0.06)', padding:'2px 6px'
                        }}>{c.name}</span>
                    ))}
                    {origin.talentList?.length > 0 && (
                        <span style={{
                            fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                            letterSpacing:'1px', color:'#a07840',
                            background:'rgba(160,120,64,0.08)', padding:'2px 6px'
                        }}>talent</span>
                    )}
                </div>
            </div>
        </div>
    );
}

function SectionTitle({children}) {
    return (
        <div style={{
            fontFamily:"'Barlow', sans-serif", color:'var(--ink)',
            textTransform:'uppercase', letterSpacing:'3px', fontSize:'15px',
            display:'flex', alignItems:'center', gap:'10px'
        }}>
            {children}
            <span style={{flex:1, height:'1px', background:'var(--border)'}}/>
        </div>
    );
}

function Description({children, italic}) {
    return (
        <div style={{
            color:'var(--ink)', fontSize:'18px', lineHeight:'1.7',
            background:'var(--panel)', padding:'14px 18px',
            borderLeft:'2px solid var(--border-strong)',
            fontStyle: italic ? 'italic' : 'normal'
        }}>
            {children}
        </div>
    );
}