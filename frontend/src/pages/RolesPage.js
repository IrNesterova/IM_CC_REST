import {useEffect, useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {getRoles} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

export default function RolesPage() {
    const [roles, setRoles] = useState([]);
    const [selected, setSelected] = useState(null);
    const [loading, setLoading] = useState(true);
    const [roleChoices, setRoleChoices] = useState({});
    const [roleSkillAdv, setRoleSkillAdv] = useState({});
    const [roleSpecAdv, setRoleSpecAdv] = useState({});
    const [expandedSkills, setExpandedSkills] = useState({});
    const [expandedTalents, setExpandedTalents] = useState({});
    const [itemVariantChoices, setItemVariantChoices] = useState({});
    const navigate = useNavigate();
    const {ccm, dispatch} = useCharacter();

    useEffect(() => {
        getRoles().then(data => {
            setRoles(data);
            if (data.length > 0) {
                const saved = ccm.roleId ? data.find(r => r.id === ccm.roleId) : null;
                if (saved) {
                    setSelected(saved);
                    setRoleChoices(ccm.roleChoices || {});
                    setRoleSkillAdv(ccm.roleSkillAdvances || {});
                    setRoleSpecAdv(ccm.roleSpecAdvances || {});
                } else {
                    selectRole(data[0]);
                }
            }
        }).finally(() => setLoading(false));
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    const selectRole = (role) => {
        setSelected(role);
        setRoleChoices({});
        setRoleSkillAdv({});
        setRoleSpecAdv({});
        setItemVariantChoices({});
    };

    const toggleChoice = (groupId, optId, max, type) => {
        if (type === 'TALENT' || type === 'INVENTORY') {
            setRoleChoices(prev => {
                const cur = prev[groupId] || [];
                if (cur.includes(optId)) return {...prev, [groupId]: cur.filter(x => x !== optId)};
                if (cur.length >= max) return prev;
                return {...prev, [groupId]: [...cur, optId]};
            });
        }
    };

    const adjustSkillAdv = (groupId, skillId, delta, pool, maxPer, allInputs) => {
        const total = allInputs.reduce((s, id) => s + (roleSkillAdv[id] || 0), 0);
        const cur = roleSkillAdv[skillId] || 0;
        if (delta > 0 && (total >= pool || cur >= maxPer)) return;
        if (delta < 0 && cur <= 0) return;
        setRoleSkillAdv(prev => ({...prev, [skillId]: cur + delta}));
    };

    const adjustSpecAdv = (skillId, delta, pool, maxPer, allInputs) => {
        const total = allInputs.reduce((s, id) => s + (roleSpecAdv[id] || 0), 0);
        const cur = roleSpecAdv[skillId] || 0;
        if (delta > 0 && (total >= pool || cur >= maxPer)) return;
        if (delta < 0 && cur <= 0) return;
        setRoleSpecAdv(prev => ({...prev, [skillId]: cur + delta}));
    };

    const variantItemsMissing = (selected?.inventoryList || [])
        .filter(i => i.variants?.length > 0 && !itemVariantChoices[i.id]);

    const handleSubmit = () => {
        if (!selected) return;
        if (variantItemsMissing.length > 0) return;

        // Collect skill names with advances
        const skillSummaryParts = [];
        const specSummaryParts = [];
        (selected.choiceGroups || []).forEach(group => {
            if (group.choiceType === 'SKILL') {
                (group.skillOptions || []).forEach(s => {
                    const adv = roleSkillAdv[s.id] || 0;
                    if (adv > 0) skillSummaryParts.push(`${s.name} ×${adv}`);
                });
            }
            if (group.choiceType === 'SPECIALIZATION') {
                (group.specsBySkill || []).forEach(skill => {
                    (skill.specializationList || []).forEach(sp => {
                        const adv = roleSpecAdv[sp.id] || 0;
                        if (adv > 0) specSummaryParts.push(`${sp.name} ×${adv}`);
                    });
                });
            }
        });

        // Collect chosen equipment names
        const equipParts = [...(selected.inventoryList || []).map(i => i.name)];
        (selected.choiceGroups || []).forEach(group => {
            if (group.choiceType === 'INVENTORY') {
                const chosen = roleChoices[group.id] || [];
                (group.inventoryOptions || []).forEach(item => {
                    if (chosen.includes(item.id)) equipParts.push(item.name);
                });
            }
            if (group.choiceType === 'TALENT') {
                const chosen = roleChoices[group.id] || [];
                (group.talentOptions || []).forEach(t => {
                    if (chosen.includes(t.id)) equipParts.push(t.name);
                });
            }
        });

        dispatch({
            type: 'SET_ROLE',
            payload: {
                roleId: selected.id,
                roleChoices,
                roleSkillAdvances: roleSkillAdv,
                roleSpecAdvances: roleSpecAdv,
                itemVariantChoices,
                _roleName: selected.name,
                _roleSkillSummary: skillSummaryParts.join(', '),
                _roleSpecSummary: specSummaryParts.join(', '),
                _roleEquipment: equipParts.join(', '),
            },
        });
        navigate('/details');
    };

    const packChosen = !!ccm.equipmentPackId;

    if (loading) return (
        <><ProgressBar/><Topbar/>
            <div style={{display:'flex',justifyContent:'center',alignItems:'center',minHeight:'60vh',color:'var(--muted)',fontFamily:"'Barlow',sans-serif",fontSize:'13px',letterSpacing:'3px'}}>
                Loading roles…
            </div>
        </>
    );

    if (!selected) return null;

    return (
        <>
            <ProgressBar/>
            <Topbar/>
            <div style={{
                display: 'grid',
                gridTemplateColumns: '360px 1fr',
                minHeight: 'calc(100vh - 100px)',
                background: 'var(--bg)'
            }}>

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
                        }}>Choose Role
                        </div>
                        {(() => {
                            const imRoles = roles.filter(r => !r.sourceBook || r.sourceBook === 'IM');
                            const inRoles = roles.filter(r => r.sourceBook === 'IN');
                            const amRoles = roles.filter(r => r.sourceBook === 'AM');
                            const RoleItem = (r) => (
                                <div key={r.id} onClick={() => selectRole(r)} style={{
                                    display: 'flex', alignItems: 'center', gap: '14px',
                                    padding: '14px 24px', cursor: 'pointer',
                                    borderLeft: `3px solid ${selected.id === r.id ? 'var(--red)' : 'transparent'}`,
                                    background: selected.id === r.id ? 'rgba(var(--accent-rgb),0.07)' : 'transparent',
                                    transition: '0.15s'
                                }}>
                                    <div style={{
                                        width: '9px', height: '9px', borderRadius: '50%', flexShrink: 0,
                                        background: selected.id === r.id ? 'var(--red)' : 'var(--border-strong)'
                                    }}/>
                                    <div style={{
                                        fontFamily: "'Barlow', sans-serif", fontSize: '17px',
                                        color: selected.id === r.id ? 'var(--red)' : 'var(--ink)'
                                    }}>{r.name}</div>
                                </div>
                            );
                            return <>
                                {imRoles.length > 0 && <>
                                    <div style={{
                                        fontFamily:"'Barlow',sans-serif", fontSize:'11px',
                                        textTransform:'uppercase', letterSpacing:'3px',
                                        color:'var(--muted)', padding:'14px 24px 6px',
                                        borderTop:'1px solid var(--border)', marginTop:'4px'
                                    }}>Imperium Maledictum</div>
                                    {imRoles.map(RoleItem)}
                                </>}
                                {inRoles.length > 0 && <>
                                    <div style={{
                                        fontFamily:"'Barlow',sans-serif", fontSize:'11px',
                                        textTransform:'uppercase', letterSpacing:'3px',
                                        color:'#a07840', padding:'14px 24px 6px',
                                        borderTop:'1px solid var(--border)',
                                        borderBottom:'1px solid rgba(160,120,64,0.25)',
                                        background:'rgba(160,120,64,0.04)', marginTop:'4px'
                                    }}>Inquisition Supplement</div>
                                    {inRoles.map(RoleItem)}
                                </>}
                                {amRoles.length > 0 && <>
                                    <div style={{
                                        fontFamily:"'Barlow',sans-serif", fontSize:'11px',
                                        textTransform:'uppercase', letterSpacing:'3px',
                                        color:'#8b3a3a', padding:'14px 24px 6px',
                                        borderTop:'1px solid var(--border)',
                                        borderBottom:'1px solid rgba(139,58,58,0.25)',
                                        background:'rgba(139,58,58,0.04)', marginTop:'4px'
                                    }}>Adeptus Mechanicus Supplement</div>
                                    {amRoles.map(RoleItem)}
                                </>}
                            </>;
                        })()}
                    </div>
                </nav>

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
                        {selected.sourceBook === 'IN' && (
                            <div style={{
                                fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                letterSpacing:'3px', textTransform:'uppercase',
                                color:'#a07840', background:'rgba(160,120,64,0.12)',
                                border:'1px solid rgba(160,120,64,0.4)',
                                padding:'3px 10px', display:'inline-block'
                            }}>Inquisition Supplement</div>
                        )}
                        {selected.sourceBook === 'AM' && (
                            <div style={{
                                fontFamily:"'Barlow', sans-serif", fontSize:'11px',
                                letterSpacing:'3px', textTransform:'uppercase',
                                color:'#8b3a3a', background:'rgba(139,58,58,0.12)',
                                border:'1px solid rgba(139,58,58,0.4)',
                                padding:'3px 10px', display:'inline-block'
                            }}>Adeptus Mechanicus Supplement</div>
                        )}

                        <div style={{
                            fontFamily: "'Barlow', sans-serif",
                            fontSize: '32px',
                            color: 'var(--ink)'
                        }}>{selected.name}</div>

                        {/* Pack banner */}
                        {packChosen && (
                            <Section title="Equipment">
                                <div style={{
                                    color: 'var(--ink)',
                                    fontSize: '18px',
                                    lineHeight: '1.7',
                                    background: 'var(--panel)',
                                    padding: '14px 18px',
                                    borderLeft: '2px solid var(--border-strong)'
                                }}>
                                    Equipment Pack: <strong>{ccm._equipmentPackName || 'Selected'}</strong>
                                </div>
                            </Section>
                        )}

                        {/* Fixed inventory */}
                        {!packChosen && selected.inventoryList?.length > 0 && (
                            <Section title="Starting Equipment">
                                <div style={{display: 'flex', flexDirection: 'column', gap: '10px'}}>
                                    <div className="tag-list">
                                        {selected.inventoryList.map(i => (
                                            <div key={i.id} className="tag">{i.name}</div>
                                        ))}
                                    </div>
                                    {selected.inventoryList.filter(i => i.variants?.length > 0).map(item => (
                                        <div key={item.id} style={{
                                            padding: '14px 18px',
                                            borderLeft: '2px solid var(--red)',
                                            background: 'var(--panel)',
                                            display: 'flex',
                                            flexDirection: 'column',
                                            gap: '10px'
                                        }}>
                                            <div style={{color: 'var(--ink)', fontSize: '15px', fontFamily: "'Barlow', sans-serif", letterSpacing: '1px'}}>
                                                Choose function for <strong>{item.name}</strong>:
                                            </div>
                                            {item.variants.map(v => (
                                                <label key={v.id} style={{display: 'flex', gap: '10px', cursor: 'pointer', alignItems: 'flex-start'}}>
                                                    <input
                                                        type="radio"
                                                        name={`variant-${item.id}`}
                                                        checked={itemVariantChoices[item.id] === v.id}
                                                        onChange={() => setItemVariantChoices(prev => ({...prev, [item.id]: v.id}))}
                                                        style={{accentColor: 'var(--red)', marginTop: '3px', flexShrink: 0}}
                                                    />
                                                    <div>
                                                        <div style={{color: 'var(--ink)', fontSize: '16px'}}>{v.name}</div>
                                                        <div style={{color: 'var(--muted)', fontSize: '13px', lineHeight: '1.5'}}>{v.description}</div>
                                                    </div>
                                                </label>
                                            ))}
                                        </div>
                                    ))}
                                </div>
                            </Section>
                        )}

                        {/* Choice groups */}
                        {selected.choiceGroups?.length > 0 && (
                            <Section title="Choices">
                                {selected.choiceGroups.map(group => {
                                    if (group.choiceType === 'INVENTORY' && packChosen) return null;
                                    return (
                                        <div key={group.id} className="choice-group">
                                            <div style={{
                                                color: 'var(--ink)',
                                                fontSize: '18px',
                                                lineHeight: '1.7',
                                                padding: '14px 18px',
                                                borderLeft: '2px solid var(--border-strong)'
                                            }}>Choose {group.choicesRequired}:
                                            </div>

                                            {group.choiceType === 'TALENT' && (group.talentOptions || []).map(t => (
                                                <label key={t.id} className="choice-option">
                                                    <input type="checkbox"
                                                           checked={(roleChoices[group.id] || []).includes(t.id)}
                                                           onChange={() => toggleChoice(group.id, t.id, group.choicesRequired, 'TALENT')}
                                                           style={{
                                                               accentColor: 'var(--red)',
                                                               marginTop: '4px',
                                                               flexShrink: 0
                                                           }}/>
                                                    <div>
                                                        <div
                                                            style={{display: 'flex', alignItems: 'center', gap: '8px'}}>
                                                            <div style={{
                                                                color: 'var(--ink)',
                                                                fontSize: '18px'
                                                            }}>{t.name}</div>
                                                            {t.description &&
                                                                <button className="desc-toggle" onClick={e => {
                                                                    e.preventDefault();
                                                                    setExpandedTalents(p => ({...p, [t.id]: !p[t.id]}));
                                                                }}>{expandedTalents[t.id] ? '▴' : '▾'}</button>}
                                                        </div>
                                                        {t.description && <div
                                                            className={`talent-desc${expandedTalents[t.id] ? ' open' : ''}`}>{t.description}</div>}
                                                    </div>
                                                </label>
                                            ))}

                                            {group.choiceType === 'INVENTORY' && (
                                                <div style={{
                                                    display: 'flex',
                                                    flexWrap: 'wrap',
                                                    gap: '8px',
                                                    alignItems: 'center'
                                                }}>
                                                    {(group.inventoryOptions || []).map((item, idx, arr) => (
                                                        <span key={item.id} style={{
                                                            display: 'flex',
                                                            alignItems: 'center',
                                                            gap: '8px'
                                                        }}>
                              <label className="choice-option" style={{padding: '6px 12px', flexShrink: 0}}>
                                <input type="checkbox" checked={(roleChoices[group.id] || []).includes(item.id)}
                                       onChange={() => toggleChoice(group.id, item.id, group.choicesRequired, 'INVENTORY')}
                                       style={{accentColor: 'var(--red)'}}/>
                                <span style={{color: 'var(--text)', fontSize: '18px'}}>{item.name}</span>
                              </label>
                                                            {idx < arr.length - 1 && <span style={{
                                                                fontSize: '14px',
                                                                color: 'var(--muted)',
                                                                fontStyle: 'italic'
                                                            }}>or</span>}
                            </span>
                                                    ))}
                                                </div>
                                            )}

                                            {group.choiceType === 'SKILL' && (() => {
                                                const allSkillIds = (group.skillOptions || []).map(s => s.id);
                                                const total = allSkillIds.reduce((s, id) => s + (roleSkillAdv[id] || 0), 0);
                                                return (
                                                    <>
                                                        <div style={{
                                                            color: 'var(--ink)',
                                                            fontSize: '18px',
                                                            padding: '14px 18px',
                                                            borderLeft: '2px solid var(--border-strong)'
                                                        }}>3 advance points — max 2 per skill.
                                                        </div>
                                                        {(group.skillOptions || []).map(skill => (
                                                            <div key={skill.id} className="skill-row">
                                                                <div style={{flex: 1}}>
                                                                    <div style={{
                                                                        display: 'flex',
                                                                        alignItems: 'center',
                                                                        gap: '8px'
                                                                    }}>
                                                                        <div className="skill-name">{skill.name}</div>
                                                                        {skill.description &&
                                                                            <button className="desc-toggle"
                                                                                    onClick={() => setExpandedSkills(p => ({
                                                                                        ...p,
                                                                                        [skill.id]: !p[skill.id]
                                                                                    }))}>{expandedSkills[skill.id] ? '▴' : '▾'}</button>}
                                                                    </div>
                                                                    {skill.description && <div
                                                                        className={`skill-desc${expandedSkills[skill.id] ? ' open' : ''}`}>{skill.description}</div>}
                                                                </div>
                                                                <div className="advance-controls"
                                                                     style={{flexShrink: 0}}>
                                                                    <button className="advance-btn"
                                                                            onClick={() => adjustSkillAdv(group.id, skill.id, -1, 3, 2, allSkillIds)}>−
                                                                    </button>
                                                                    <input className="advance-input" readOnly
                                                                           value={roleSkillAdv[skill.id] || 0}/>
                                                                    <button className="advance-btn"
                                                                            onClick={() => adjustSkillAdv(group.id, skill.id, 1, 3, 2, allSkillIds)}>+
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        ))}
                                                        <div className="advance-pool">Remaining: {3 - total}</div>
                                                    </>
                                                );
                                            })()}

                                            {group.choiceType === 'SPECIALIZATION' && (() => {
                                                const allSpecIds = (group.specsBySkill || []).flatMap(s => (s.specializationList || []).map(sp => sp.id));
                                                const total = allSpecIds.reduce((s, id) => s + (roleSpecAdv[id] || 0), 0);
                                                return (
                                                    <>
                                                        <div style={{
                                                            color: 'var(--ink)',
                                                            fontSize: '18px',
                                                            padding: '14px 18px',
                                                            borderLeft: '2px solid var(--border-strong)'
                                                        }}>2 advance points — max 1 per specialization.
                                                        </div>
                                                        {(group.specsBySkill || []).map(skill => (
                                                            <div key={skill.id} style={{marginBottom: '10px'}}>
                                                                <div style={{
                                                                    fontFamily: "'Barlow', sans-serif",
                                                                    fontSize: '12px',
                                                                    color: 'var(--red)',
                                                                    textTransform: 'uppercase',
                                                                    letterSpacing: '2px',
                                                                    padding: '4px 0',
                                                                    borderBottom: '1px solid var(--border)',
                                                                    marginBottom: '2px'
                                                                }}>{skill.name}</div>
                                                                <div style={{
                                                                    paddingLeft: '14px',
                                                                    borderLeft: '2px solid var(--border)'
                                                                }}>
                                                                    {(skill.specializationList || []).map(spec => (
                                                                        <div key={spec.id} className="skill-row"
                                                                             style={{padding: '8px 14px'}}>
                                                                            <span
                                                                                className="skill-name">{spec.name}</span>
                                                                            <div className="advance-controls">
                                                                                <button className="advance-btn"
                                                                                        onClick={() => adjustSpecAdv(spec.id, -1, 2, 1, allSpecIds)}>−
                                                                                </button>
                                                                                <input className="advance-input"
                                                                                       readOnly
                                                                                       value={roleSpecAdv[spec.id] || 0}/>
                                                                                <button className="advance-btn"
                                                                                        onClick={() => adjustSpecAdv(spec.id, 1, 2, 1, allSpecIds)}>+
                                                                                </button>
                                                                            </div>
                                                                        </div>
                                                                    ))}
                                                                </div>
                                                            </div>
                                                        ))}
                                                        <div className="advance-pool">Remaining: {2 - total}</div>
                                                    </>
                                                );
                                            })()}
                                        </div>
                                    );
                                })}
                            </Section>
                        )}

                        <button onClick={handleSubmit} className="select-btn" style={{width: '100%'}}>Select Role
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
