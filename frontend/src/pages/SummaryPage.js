import {useEffect, useState, useMemo, useCallback, useRef} from 'react';
import {useNavigate} from 'react-router-dom';
import {buildSummary, saveCharacter, loadCharacter, uploadCharacterImage, characterImageUrl, getPsychicDisciplines, getInjuries, lookupCriticalWound, getConditions} from '../api/api';
import {useCharacter} from '../context/CharacterContext';
import {useAuth} from '../context/AuthContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

const ARMOUR_LOC_MAP = {
    HEAD: ['Head'],
    BODY: ['Body'],
    ARMS: ['Left Arm', 'Right Arm'],
    LEGS: ['Left Leg', 'Right Leg'],
    ALL: ['Head', 'Body', 'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg'],
    SPECIAL: [],
};
const PROTECT_LOCS = ['Head', 'Body', 'Left Arm', 'Right Arm', 'Left Leg', 'Right Leg'];

export default function SummaryPage() {
    const {ccm, dispatch} = useCharacter();
    const {user} = useAuth();
    const navigate = useNavigate();
    const [data, setData] = useState(null);
    const [loading, setLoading] = useState(true);
    const [saveCode, setSaveCode] = useState(null);
    const [saving, setSaving] = useState(false);
    const [copied, setCopied] = useState(false);
    const [loadInput, setLoadInput] = useState('');

    // Editable character state
    const [charName, setCharName] = useState('');
    const [charStart, setCharStart] = useState({});
    const [charAdv, setCharAdv] = useState({});
    const [skillAdv, setSkillAdv] = useState({});
    const [specAdv, setSpecAdv] = useState({});
    const [talents, setTalents] = useState([]);
    const [mutations, setMutations] = useState([]);
    const [augmetics, setAugmetics] = useState([]);
    const [equipment, setEquipment] = useState([]);
    const [fateTotal, setFateTotal] = useState(3);
    const [fateCur, setFateCur] = useState(3);
    const [startingMoney, setStartingMoney] = useState(null);
    const [solarsAmount, setSolarsAmount] = useState('');
    const [disciplines, setDisciplines] = useState([]);
    const [knownPowers, setKnownPowers] = useState([]);
    const [woundsCur, setWoundsCur] = useState(0);
    const [critWounds, setCritWounds] = useState(0);
    const [superiority, setSuperiority] = useState(0);
    const [extraSpecs, setExtraSpecs] = useState([]);
    const [openSpecSkill, setOpenSpecSkill] = useState(null);
    const [customSpecText, setCustomSpecText] = useState('');
    const [charImageUrl, setCharImageUrl] = useState(null);
    const [imageUploading, setImageUploading] = useState(false);
    const [imageError, setImageError] = useState(null);
    const [webhookUrl, setWebhookUrl] = useState(() => localStorage.getItem('im_discord_webhook') || '');
    const effectiveWebhookUrl = user?.webhookUrl || webhookUrl;
    const [lastRoll, setLastRoll] = useState(null);
    const [rolling, setRolling] = useState(false);
    const [rollModal, setRollModal] = useState(null);
    const [rollMode, setRollMode] = useState('normal');
    const [rollDifficulty, setRollDifficulty] = useState(0);
    const [rollModifier, setRollModifier] = useState(0);
    const [rollExtraDoS, setRollExtraDoS] = useState(0);
    const [rollResult, setRollResult] = useState(null);
    const [corruption, setCorruption] = useState(0);
    const [handedness, setHandedness] = useState('right');
    const [protection, setProtection] = useState(
        PROTECT_LOCS.reduce((a, l) => ({...a, [l]: {ap: 0, special: '', wt: ''}}), {})
    );
    const [critTable, setCritTable] = useState([]);
    useEffect(() => {
        const count = critTable.filter(r => {
            const t = (r.treatment || '').trim().toLowerCase();
            return t && t !== 'none required.';
        }).length;
        setCritWounds(count);
    }, [critTable]);
    const [injuries, setInjuries] = useState([]);
    const [allInjuries, setAllInjuries] = useState([]);
    const [allConditions, setAllConditions] = useState([]);
    // {[name]: 'minor' | 'major' | 'active'}
    const [activeConditions, setActiveConditions] = useState({});
    const [critLookupLoc, setCritLookupLoc] = useState('HEAD');
    const [critLookupRoll, setCritLookupRoll] = useState('');
    const [critLookupResult, setCritLookupResult] = useState(null);
    const [critLookupLoading, setCritLookupLoading] = useState(false);
    const [influence, setInfluence] = useState([{faction: '', infl: '', notes: ''}, {
        faction: '',
        infl: '',
        notes: ''
    }, {faction: '', infl: '', notes: ''}]);
    const [age, setAge] = useState('');
    const [height, setHeight] = useState('');
    const [eyes, setEyes] = useState('');
    const [hairColor, setHairColor] = useState('');
    const [hairStyle, setHairStyle] = useState('');
    const [distFeatures, setDistFeatures] = useState('');
    const [divination, setDivination] = useState(ccm.divination || '');
    const [shortGoal, setShortGoal] = useState('');
    const [longGoal, setLongGoal] = useState('');
    const [biography, setBiography] = useState('');

    // Unified weapon table rows
    const [weaponRows, setWeaponRows] = useState(Array(8).fill(null).map(() => ({
        name: '',
        spec: '',
        test: '',
        dmg: '',
        range: '',
        mag: '',
        enc: '',
        traits: ''
    })));

    useEffect(() => {
        setLoading(true);
        Promise.all([buildSummary(ccm), getPsychicDisciplines()])
            .then(([d, disc]) => {
                setData(d);
                setDisciplines(disc);
            })
            .catch(() => {})
            .finally(() => setLoading(false));
        getInjuries().then(inj => setAllInjuries(inj || [])).catch(() => {});
        getConditions().then(c => setAllConditions(c || [])).catch(() => {});
    }, []); // eslint-disable-line react-hooks/exhaustive-deps

    useEffect(() => {
        if (!data) return;
        const {sheet} = data;
        setCharName(sheet.characterName || '');

        const start = {}, adv = {};
        Object.entries(sheet.characteristics || {}).forEach(([k, v]) => {
            start[k] = parseInt(v) || 0;
            adv[k] = 0;
        });
        setCharStart(start);
        setCharAdv(adv);

        const sa = {};
        (sheet.skills || []).forEach(s => {
            sa[s.name] = s.advances;
        });
        setSkillAdv(sa);

        const spa = {};
        (sheet.specializations || []).forEach(s => {
            spa[s.name] = s.advances;
        });
        setSpecAdv(spa);

        setTalents((sheet.talents || []).map(t => ({name: t, desc: data.talentDescMap?.[t] || ''})));
        setAugmetics((sheet.augmetics || []).map(a => ({name: a, notes: ''})));

        const eqMap = {};
        (sheet.equipment || []).forEach(name => {
            if (eqMap[name]) eqMap[name].qty++;
            else {
                const wEnc = parseFloat(data?.meleeWeaponMap?.[name]?.wt || data?.rangedWeaponMap?.[name]?.wt) || 0;
                eqMap[name] = {name, qty: 1, notes: '', equipped: false, enc: wEnc};
            }
        });
        setEquipment(Object.values(eqMap));
        // auto-fill unified weapon table (deduplicated by name)
        const wr = Array(8).fill(null).map(() => ({
            name: '',
            spec: '',
            test: '',
            dmg: '',
            range: '',
            mag: '',
            enc: '',
            traits: ''
        }));
        let wi = 0;
        const seen = new Set();
        (sheet.equipment || []).forEach(name => {
            if (seen.has(name)) return;
            seen.add(name);
            const m = data.meleeWeaponMap?.[name];
            if (m && wi < 8) {
                wr[wi++] = {
                    name,
                    spec: m.class || '',
                    test: 'WS',
                    dmg: m.damage || '',
                    range: '—',
                    mag: '—',
                    enc: m.wt || '',
                    traits: m.special || ''
                };
            }
            const r = data.rangedWeaponMap?.[name];
            if (r && wi < 8) {
                wr[wi++] = {
                    name,
                    spec: r.class || '',
                    test: 'BS',
                    dmg: r.damage || '',
                    range: r.range || '',
                    mag: r.clip || '',
                    enc: r.wt || '',
                    traits: r.special || ''
                };
            }
        });
        setWeaponRows(wr);

        const fp = sheet.fatePoints || 3;
        setFateTotal(fp);
        setFateCur(fp);
        const sm = sheet.startingMoney || null;
        setStartingMoney(sm);
        if (sm && !/\d+d\d+/i.test(sm)) {
            const fixed = parseInt(sm);
            setSolarsAmount(isNaN(fixed) ? '' : String(fixed));
        } else {
            setSolarsAmount('');
        }
        setAge(sheet.age || '');
        setHeight(sheet.height || '');
        setEyes(sheet.eyeType || '');
        setHairColor(sheet.hairColor || '');
        setHairStyle(sheet.hairStyle || '');
        setDistFeatures(sheet.distinguishingFeatures || '');
        setDivination(sheet.divination || ccm.divination || '');
        setShortGoal(sheet.shortTermGoal || '');
        setLongGoal(sheet.longTermGoal || '');
        setInfluence(prev => {
            const n = [...prev];
            if (sheet.factionName) n[0] = {...n[0], faction: sheet.factionName, infl: n[0].infl || '1'};
            return n.map(r => r.faction?.trim() && !r.infl ? {...r, infl: '1'} : r);
        });
    }, [data]); // eslint-disable-line react-hooks/exhaustive-deps

    // ── Derived values ───────────────────────────────────────────
    const charCurrent = useMemo(() => {
        const m = {};
        Object.keys(charStart).forEach(k => {
            m[k] = (charStart[k] || 0) + (charAdv[k] || 0);
        });
        return m;
    }, [charStart, charAdv]);

    const b = (abbr) => Math.floor((charCurrent[abbr] || 0) / 10);
    const initiative = b('PER') + b('AG');
    const woundsMax = b('STR') + 2 * b('TGH') + b('WIL');
    // Reflexes = parent skill; Dodge = specialization under it (cumulative)
    // With Dodge spec:    AG + (Reflexes advances + Dodge advances) × 5
    // With Reflexes only: AG + Reflexes advances × 5
    // Fallback:           raw AG
    const agVal = charCurrent['AG'] || 0;
    const reflexSkillAdv = skillAdv['REFLEXES'] || 0;
    const dodgeSpecAdv = specAdv['DODGE'] || 0;
    const dodge = dodgeSpecAdv > 0
        ? agVal + (reflexSkillAdv + dodgeSpecAdv) * 5
        : reflexSkillAdv > 0
            ? agVal + reflexSkillAdv * 5
            : agVal;
    // Parry: WS + best Melee skill advance
    const meleeAdv = Math.max(0, ...Object.keys(skillAdv).filter(k => k.toLowerCase().startsWith('melee')).map(k => skillAdv[k] || 0), 0);
    const parry = (charCurrent['WS'] || 0) + meleeAdv * 5;

    const hasPorter = talents.some(t => t.name.toLowerCase() === 'porter');
    const encMax = hasPorter ? 2 * b('STR') + b('TGH') : b('STR') + b('TGH');
    const encCurrent = equipment.reduce((sum, item) => sum + (parseFloat(item.enc) || 0) * (item.qty || 1), 0);

    const skillTotal = (skill) => (charCurrent[skill.characteristicAbbr] || 0) + (skillAdv[skill.name] || 0) * 5;
    const specTotal = (spec) => (charCurrent[spec.characteristicAbbr] || 0) + ((specAdv[spec.name] || 0) + (skillAdv[spec.skillName] || spec.skillAdvances || 0)) * 5;

    // ── Equipment: equip/unequip armour ─────────────────────────
    // Per location: best non-subtle AP + best subtle AP (max 2 armors combined)
    const recalcProtection = useCallback((equippedList, pp) => {
        const np = {};
        PROTECT_LOCS.forEach(label => {
            np[label] = {ap: 0, special: '', wt: pp[label]?.wt || ''};
        });

        const byLabel = {};
        PROTECT_LOCS.forEach(label => {
            byLabel[label] = {subtle: [], nonSubtle: []};
        });

        equippedList.forEach(r => {
            if (!r.equipped) return;
            const rd = data?.armourMap?.[r.name];
            if (!rd) return;
            const ap = parseInt(rd.ap) || 0;
            const isSubtle = (rd.special || '').toLowerCase().includes('subtle');
            (Array.isArray(rd.locations) ? rd.locations : []).forEach(loc => {
                (ARMOUR_LOC_MAP[loc] || []).forEach(label => {
                    if (isSubtle) byLabel[label].subtle.push({name: r.name, ap});
                    else byLabel[label].nonSubtle.push({name: r.name, ap});
                });
            });
        });

        PROTECT_LOCS.forEach(label => {
            const best = (arr) => arr.reduce((b, c) => c.ap > b.ap ? c : b, {name: null, ap: 0});
            const bestNS = best(byLabel[label].nonSubtle);
            const bestS = best(byLabel[label].subtle);
            np[label].ap = bestNS.ap + bestS.ap;
            np[label].special = [bestNS.name, bestS.name].filter(Boolean).join(', ');
        });

        return np;
    }, [data]);

    const toggleEquip = useCallback((idx) => {
        setEquipment(prev => {
            const next = prev.map((r, i) => i === idx ? {...r, equipped: !r.equipped} : r);
            if (data?.armourMap?.[next[idx].name]) setProtection(pp => recalcProtection(next, pp));
            return next;
        });
    }, [data, recalcProtection]);

    const addEquip = (name) => {
        if (!name.trim()) return;
        setEquipment(prev => {
            const existing = prev.findIndex(r => r.name.toLowerCase() === name.toLowerCase());
            if (existing !== -1) return prev.map((r, i) => i === existing ? {...r, qty: r.qty + 1} : r);
            const m = data?.meleeWeaponMap?.[name];
            if (m) setWeaponRows(rows => {
                const n = [...rows];
                const fi = n.findIndex(r => !r.name);
                if (fi !== -1) n[fi] = {
                    name,
                    spec: m.class || '',
                    test: 'WS',
                    dmg: m.damage || '',
                    range: '—',
                    mag: '—',
                    enc: m.wt || '',
                    traits: m.special || ''
                };
                return n;
            });
            const r = data?.rangedWeaponMap?.[name];
            if (r) setWeaponRows(rows => {
                const n = [...rows];
                const fi = n.findIndex(r2 => !r2.name);
                if (fi !== -1) n[fi] = {
                    name,
                    spec: r.class || '',
                    test: 'BS',
                    dmg: r.damage || '',
                    range: r.range || '',
                    mag: r.clip || '',
                    enc: r.wt || '',
                    traits: r.special || ''
                };
                return n;
            });
            const wEnc = parseFloat(data?.meleeWeaponMap?.[name]?.wt || data?.rangedWeaponMap?.[name]?.wt) || 0;
            return [...prev, {name, qty: 1, notes: '', equipped: false, enc: wEnc}];
        });
    };

    const removeEquip = (idx) => {
        const item = equipment[idx];
        if (item.equipped && data?.armourMap?.[item.name]) toggleEquip(idx);
        setEquipment(prev => prev.filter((_, i) => i !== idx));
    };

    // ── Talent / fate ────────────────────────────────────────────
    const addTalent = (name) => {
        if (!name.trim()) return;
        if (talents.find(t => t.name.toLowerCase() === name.toLowerCase())) return;
        const desc = data?.talentDescMap?.[name] || '';
        setTalents(prev => [...prev, {name, desc}]);
        if (name.toLowerCase() === 'fated') setFateTotal(f => f + 1);
    };
    const removeTalent = (name) => {
        setTalents(prev => prev.filter(t => t.name !== name));
        if (name.toLowerCase() === 'fated') setFateTotal(f => Math.max(1, f - 1));
    };

    const addMutation = (name) => {
        if (!name.trim() || mutations.find(m => m.name === name)) return;
        setMutations(prev => [...prev, {name, desc: data?.mutationDescMap?.[name] || ''}]);
    };

    const addAugmetic = (name) => {
        if (!name.trim()) return;
        setAugmetics(prev => [...prev, {name, notes: ''}]);
    };

    const addInjuryFromSearch = (name) => {
        const inj = allInjuries.find(i => i.name === name);
        if (!inj) {
            setInjuries(prev => [...prev, {loc: '', desc: name, effect: ''}]);
            return;
        }
        setInjuries(prev => [...prev, {loc: inj.affectedPart || '', desc: inj.name, effect: inj.effect || ''}]);
    };

    const doCritLookup = async () => {
        const roll = parseInt(critLookupRoll);
        if (!roll || roll < 1) return;
        setCritLookupLoading(true);
        setCritLookupResult(null);
        try {
            const result = await lookupCriticalWound(critLookupLoc, roll);
            setCritLookupResult(result);
        } catch {
            setCritLookupResult({error: true});
        } finally {
            setCritLookupLoading(false);
        }
    };

    // ── Save ──────────────────────────────────────────────────────
    const handleSave = async () => {
        setSaving(true);
        try {
            const payload = JSON.stringify({ccm, edits: {characterName: charName}});
            const result = await saveCharacter(payload, saveCode);
            setSaveCode(result.code);
            setCharImageUrl(characterImageUrl(result.code));
        } catch (e) {
            console.error(e);
        } finally {
            setSaving(false);
        }
    };

    const handleImageUpload = async (e) => {
        const file = e.target.files?.[0];
        if (!file || !saveCode) return;
        setImageUploading(true);
        setImageError(null);
        try {
            await uploadCharacterImage(saveCode, file);
            setCharImageUrl(characterImageUrl(saveCode) + '?t=' + Date.now());
        } catch (err) {
            const msg = err.response?.data?.error || 'Upload failed';
            setImageError(msg);
        } finally {
            setImageUploading(false);
            e.target.value = '';
        }
    };

    const handleLoad = async () => {
        if (!loadInput.trim()) return;
        try {
            const result = await loadCharacter(loadInput.trim().toUpperCase());
            if (result?.ccm) {
                dispatch({type: 'RESTORE', payload: result.ccm});
                navigate('/summary');
            }
        } catch (e) {
            alert('Character not found.');
        }
    };

    const copyCode = () => {
        if (saveCode) {
            navigator.clipboard.writeText(saveCode);
            setCopied(true);
            setTimeout(() => setCopied(false), 1500);
        }
    };

    // ── Skill advance helpers ────────────────────────────────────
    const changeSkillAdv = (name, delta) => {
        setSkillAdv(prev => {
            const cur = prev[name] || 0;
            const next = Math.max(0, Math.min(4, cur + delta));
            return {...prev, [name]: next};
        });
    };
    const changeCharAdv = (abbr, delta) => {
        setCharAdv(prev => ({...prev, [abbr]: Math.max(0, (prev[abbr] || 0) + delta)}));
    };

    // ── d100 roll ────────────────────────────────────────────────
    const DIFFICULTIES = [
        {label: 'Very Easy', short: 'VE', mod: +60},
        {label: 'Easy', short: 'E', mod: +40},
        {label: 'Routine', short: 'R', mod: +20},
        {label: 'Challenging', short: 'C', mod: 0},
        {label: 'Difficult', short: 'D', mod: -10},
        {label: 'Hard', short: 'H', mod: -20},
        {label: 'Very Hard', short: 'VH', mod: -30},
    ];

    const openRollModal = (label, target, isWeapon = false) => {
        setRollModal({label, target, isWeapon});
        setRollMode('normal');
        setRollDifficulty(0);
        setRollModifier(0);
        setRollExtraDoS(0);
        setRollResult(null);
    };

    const chooseBetter = (a, b, target) => {
        const as = a <= target, bs = b <= target;
        if (as && !bs) return a;
        if (bs && !as) return b;
        return Math.min(a, b); // both same outcome: lower = more DoS or fewer DoF
    };

    const chooseWorse = (a, b, target) => {
        const as = a <= target, bs = b <= target;
        if (as && !bs) return b;
        if (bs && !as) return a;
        return Math.max(a, b); // both same outcome: higher = fewer DoS or more DoF
    };

    const executeRoll = async () => {
        const effectiveTarget = (rollModal.target || 0) + rollDifficulty + rollModifier;
        const tens = Math.floor(Math.random() * 10);
        const units = Math.floor(Math.random() * 10);
        const orig = tens === 0 && units === 0 ? 100 : tens * 10 + units;
        const rev = tens === 0 && units === 0 ? 100 : units * 10 + tens;
        const value = rollMode === 'advantage' ? chooseBetter(orig, rev, effectiveTarget)
            : rollMode === 'disadvantage' ? chooseWorse(orig, rev, effectiveTarget)
                : orig;
        const reversed = orig !== rev && value === rev;

        const success = value <= effectiveTarget;
        const isDouble = value === 100 || (value < 100 && Math.floor(value / 10) === value % 10);
        const crit = rollModal.isWeapon && isDouble && success;
        const fumble = rollModal.isWeapon && isDouble && !success;
        const rawDoS = success ? Math.floor((effectiveTarget - value) / 10) : Math.floor((value - effectiveTarget - 1) / 10);
        const degrees = success ? rawDoS + rollExtraDoS : rawDoS;
        const result = {value, orig, rev, reversed, success, crit, fumble, degrees, effectiveTarget};
        setRollResult(result);
        setLastRoll({value, label: rollModal.label, target: effectiveTarget, success, degrees, crit, fumble});

        if (!effectiveWebhookUrl.trim()) return;
        setRolling(true);
        try {
            const diffLabel = DIFFICULTIES.find(d => d.mod === rollDifficulty)?.label || '';
            const revNote = reversed ? ` *(reversed ${orig}→${rev})*`
                : (rollMode !== 'normal' && orig !== rev) ? ` *(${orig} / ${rev})*` : '';
            const outcome = crit ? `Roll: **${value}**${revNote} 🌟 Critical Success!`
                : fumble ? `Roll: **${value}**${revNote} 💀 Fumble!`
                    : success ? `Roll: **${value}**${revNote} ✅ Success (DoS: ${degrees})`
                        : `Roll: **${value}**${revNote} ❌ Failure (DoF: ${degrees})`;
            const color = crit ? 0xf1c40f : fumble ? 0x8e44ad : success ? 0x27ae60 : 0xe74c3c;
            const diffStr2 = diffLabel ? ` — ${diffLabel}` : '';
            const modStr2 = rollModifier !== 0 ? ` mod ${rollModifier > 0 ? '+' : ''}${rollModifier}` : '';
            const modeStr2 = rollMode !== 'normal' ? ` *(${rollMode})*` : '';
            const embed = {
                title: `🎲 ${rollModal.label}${diffStr2}${modeStr2}`,
                description: `Target: **${effectiveTarget}**${modStr2}\n${outcome}`,
                color,
                footer: {text: 'Imperium Maledictum'},
            };
            if (user?.displayName) embed.author = {name: user.displayName};
            const webhookBody = {embeds: [embed]};
            if (charName) webhookBody.username = charName;

            if (charImageUrl) {
                // Send image as file attachment so it works on localhost too
                try {
                    const blob = await fetch(charImageUrl.split('?')[0], {credentials: 'include'}).then(r => r.blob());
                    const ext = blob.type.split('/')[1] || 'png';
                    const filename = `portrait.${ext}`;
                    embed.thumbnail = {url: `attachment://${filename}`};
                    const form = new FormData();
                    form.append('files[0]', blob, filename);
                    form.append('payload_json', JSON.stringify(webhookBody));
                    await fetch(effectiveWebhookUrl, {method: 'POST', body: form});
                } catch {
                    // fallback: send without image
                    await fetch(effectiveWebhookUrl, {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(webhookBody)});
                }
            } else {
                await fetch(effectiveWebhookUrl, {method: 'POST', headers: {'Content-Type': 'application/json'}, body: JSON.stringify(webhookBody)});
            }
        } catch (e) {
            console.error('Discord webhook error:', e);
        } finally {
            setRolling(false);
        }
    };

    const makeRoll = (label, target) => openRollModal(label, target);

    // ── Table row helpers ─────────────────────────────────────────
    const updateWeaponRow = (idx, field, val) => setWeaponRows(prev => prev.map((r, i) => i === idx ? {
        ...r,
        [field]: val
    } : r));
    const updateCritRow = (idx, field, val) => setCritTable(prev => prev.map((r, i) => i === idx ? {
        ...r,
        [field]: val
    } : r));
    const updateInflRow = (idx, field, val) => setInfluence(prev => prev.map((r, i) => {
        if (i !== idx) return r;
        const updated = {...r, [field]: val};
        if (field === 'faction') updated.infl = val.trim() ? (r.infl || '1') : '';
        return updated;
    }));

    if (loading) return (
        <>
            <ProgressBar/><Topbar/>
            <div style={{
                display: 'flex',
                justifyContent: 'center',
                alignItems: 'center',
                minHeight: '60vh',
                color: 'var(--muted)',
                fontFamily: "'Barlow', sans-serif",
                fontSize: '13px',
                letterSpacing: '3px'
            }}>
                Building character sheet…
            </div>
        </>
    );

    if (!data) return null;

    const {sheet} = data;
    const charKeys = Object.keys(charStart);
    const halfSkills = Math.ceil((sheet.skills || []).length / 2);

    return (
        <>
            <ProgressBar/><Topbar/>
            <div style={{flex: 1, background: 'var(--bg)'}}>
                <div className="sheet-wrapper">

                    {/* ── CHARACTER HEADER ── */}
                    <div className="char-header">
                        <div className="char-header-top">
                            <div className="char-portrait-wrap">
                                {charImageUrl && (
                                    <img
                                        src={charImageUrl}
                                        alt="Character portrait"
                                        className="char-portrait"
                                        onError={() => setCharImageUrl(null)}
                                    />
                                )}
                                {saveCode && (
                                    <label className="portrait-upload-btn" title={charImageUrl ? 'Change portrait' : 'Upload portrait'}>
                                        {imageUploading ? '…' : charImageUrl ? '✎' : '+'}
                                        <input type="file" accept="image/*" style={{display: 'none'}}
                                               disabled={imageUploading}
                                               onChange={handleImageUpload}/>
                                    </label>
                                )}
                            </div>
                            <div className="char-header-name-wrap">
                                <div className="char-header-eyebrow">Character Sheet</div>
                                <input className="char-header-name" value={charName}
                                       onChange={e => {
                                           setCharName(e.target.value);
                                           dispatch({type: 'SET_DETAILS', payload: {characterName: e.target.value}});
                                       }} placeholder="Character Name"/>
                            </div>
                            <div className="char-header-actions">
                                <button className="action-btn" onClick={handleSave}
                                        disabled={saving}>{saving ? 'Saving…' : saveCode ? 'Save Again' : 'Save'}</button>
                                <button className="action-btn secondary" onClick={() => window.print()}>Print / PDF
                                </button>
                            </div>
                        </div>
                        <div className="char-identity-strip">
                            {[['Origin', sheet.originName], ['Faction', sheet.factionName], ['Role', sheet.roleName]].map(([label, val]) => (
                                <div key={label} className="char-id-cell">
                                    <div className="char-id-label">{label}</div>
                                    <div className="char-id-value">{val || '—'}</div>
                                </div>
                            ))}
                        </div>
                    </div>

                    {/* ── ACTIONS BAR ── */}
                    <div className="page-actions">
                        {saveCode && (
                            <div className="save-code-box">
                                Saved — Code: <strong>{saveCode}</strong>
                                <button className={`copy-btn${copied ? ' copied' : ''}`}
                                        onClick={copyCode}>{copied ? 'Copied!' : 'Copy'}</button>
                            </div>
                        )}
                        <div style={{display: 'flex', gap: '5px', alignItems: 'center'}}>
                            <input style={{
                                width: '90px',
                                textTransform: 'uppercase',
                                letterSpacing: '2px',
                                textAlign: 'center',
                                fontFamily: "'Barlow',sans-serif",
                                padding: '6px 8px',
                                background: 'var(--field-bg)',
                                border: '1px solid var(--border)',
                                color: 'var(--ink)',
                                outline: 'none',
                                fontSize: '13px'
                            }}
                                   placeholder="Code…" maxLength={6} value={loadInput}
                                   onChange={e => setLoadInput(e.target.value)}/>
                            <button className="action-btn secondary" onClick={handleLoad}>Load</button>
                        </div>
                    </div>

                    {/* ══════════════════════════════════════
              PAGE 1 — CHARACTERISTICS · STATS
          ══════════════════════════════════════ */}
                    <div className="sheet-page">

                        {/* Characteristics */}
                        <div className="sec-hdr" style={{borderTop: 'none'}}>Characteristics</div>
                        <div style={{padding: '0 0 4px'}}>
                            <table className="char-table">
                                <thead>
                                <tr>
                                    <th className="char-row-label"></th>
                                    {charKeys.map(k => <th key={k}>{k}</th>)}
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <td className="char-row-label">Starting</td>
                                    {charKeys.map(k => (
                                        <td key={k}>
                                            <input className="sheet-num" type="number" value={charStart[k] || 0}
                                                   onChange={e => setCharStart(p => ({
                                                       ...p,
                                                       [k]: parseInt(e.target.value) || 0
                                                   }))}/>
                                        </td>
                                    ))}
                                </tr>
                                <tr>
                                    <td className="char-row-label">Advances</td>
                                    {charKeys.map(k => (
                                        <td key={k} style={{whiteSpace: 'nowrap'}}>
                                            <div className="adv-ctrl">
                                                <button className="adv-btn" onClick={() => changeCharAdv(k, -1)}>−
                                                </button>
                                                <input className="sheet-adv" type="number" min={0}
                                                       value={charAdv[k] || 0}
                                                       onChange={e => setCharAdv(p => ({
                                                           ...p,
                                                           [k]: Math.max(0, parseInt(e.target.value) || 0)
                                                       }))}/>
                                                <button className="adv-btn" onClick={() => changeCharAdv(k, 1)}>+
                                                </button>
                                            </div>
                                        </td>
                                    ))}
                                </tr>
                                <tr>
                                    <td className="char-row-label">Current</td>
                                    {charKeys.map(k => (
                                        <td key={k} className="char-cur-cell rollable"
                                            onClick={() => openRollModal(k, charCurrent[k] || 0)}>
                                            {charCurrent[k] || 0}
                                        </td>
                                    ))}
                                </tr>
                                </tbody>
                            </table>
                        </div>

                        {/* Core Stats */}
                        <div className="sec-block">
                            <div className="sec-hdr">Core Statistics</div>
                            <div className="quick-stats">
                                <div className="qs-cell">
                                    <div className="id-label">Initiative</div>
                                    <div className="qs-val">{initiative}</div>
                                </div>
                                <div className="qs-cell">
                                    <div className="id-label">Fate Points</div>
                                    <div className="fate-stack">
                                        <div className="fate-line"><span className="fate-ll">Total</span><span
                                            className="fate-threshold">{fateTotal}</span></div>
                                        <div className="fate-line"><span className="fate-ll">Current</span>
                                            <input className="fate-num-input" type="number" min={0} max={fateTotal}
                                                   value={fateCur}
                                                   onChange={e => setFateCur(Math.min(fateTotal, Math.max(0, parseInt(e.target.value) || 0)))}/>
                                        </div>
                                    </div>
                                </div>
                                <div className="qs-cell">
                                    <div className="id-label">Critical Wounds</div>
                                    <div className="fate-stack">
                                        <div className="fate-line"><span className="fate-ll">Max</span><span
                                            className="fate-threshold">{b('TGH')}</span></div>
                                        <div className="fate-line"><span className="fate-ll">Current</span>
                                            <input className="fate-num-input" type="number" min={0} max={b('TGH')}
                                                   value={critWounds}
                                                   onChange={e => setCritWounds(Math.min(b('TGH'), Math.max(0, parseInt(e.target.value) || 0)))}/>
                                        </div>
                                    </div>
                                </div>
                                <div className="qs-cell">
                                    <div className="id-label">Handedness</div>
                                    <select className="qs-select" value={handedness}
                                            onChange={e => setHandedness(e.target.value)}>
                                        <option value="right">Right</option>
                                        <option value="left">Left</option>
                                    </select>
                                </div>
                                <div className="qs-cell">
                                    <div className="id-label">Corruption</div>
                                    <input className="fate-num-input" type="number" min={0} value={corruption}
                                           onChange={e => setCorruption(parseInt(e.target.value) || 0)}/>
                                </div>
                                <div className="qs-cell">
                                    <div className="id-label">Wounds</div>
                                    <div className="fate-stack">
                                        <div className="fate-line"><span className="fate-ll">Max</span><span
                                            className="fate-threshold">{woundsMax}</span></div>
                                        <div className="fate-line"><span className="fate-ll">Current</span>
                                            <input className="fate-num-input" type="number" min={0} value={woundsCur}
                                                   onChange={e => setWoundsCur(parseInt(e.target.value) || 0)}/>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>

                        {/* Influence */}
                        <div className="sec-block">
                            <div className="sec-hdr">Influence</div>
                            <div className="sec-body">
                                <table className="infl-table">
                                    <thead>
                                    <tr>
                                        <th style={{width: '45%'}}>Faction</th>
                                        <th style={{width: '44px'}}>Infl</th>
                                        <th>Notes / Contacts</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {influence.map((row, i) => (
                                        <tr key={i}>
                                            <td><input className="infl-input" type="text" value={row.faction}
                                                       onChange={e => updateInflRow(i, 'faction', e.target.value)}/>
                                            </td>
                                            <td><input className="infl-input" type="number"
                                                       style={{textAlign: 'center'}} value={row.infl}
                                                       onChange={e => updateInflRow(i, 'infl', e.target.value)}/></td>
                                            <td><input className="infl-input" type="text" value={row.notes}
                                                       onChange={e => updateInflRow(i, 'notes', e.target.value)}/></td>
                                        </tr>
                                    ))}
                                    </tbody>
                                </table>
                            </div>
                        </div>

                    </div>
                    {/* /page 1 */}


                    {/* ══════════════════════════════════════
              PAGE 2 — SKILLS · TALENTS · MUTATIONS
          ══════════════════════════════════════ */}
                    <div className="sheet-page">

                        <div className="sec-hdr" style={{borderTop: 'none'}}>Skills &amp; Specializations</div>
                        <div className="main-2col">
                            {[0, 1].map(col => (
                                <div key={col} className="skill-col">
                                    <div className="col-hdr">
                                        <span className="col-hdr-name">Skill</span>
                                        <span className="col-hdr-right">Adv · Total</span>
                                    </div>
                                    {(sheet.skills || []).filter((_, si) => col === 0 ? si < halfSkills : si >= halfSkills).map(skill => {
                                        const sheetSpecs = (sheet.specializations || []).filter(sp => sp.skillName === skill.name);
                                        const allSpecs = [...sheetSpecs, ...extraSpecs.filter(sp => sp.skillName === skill.name)];
                                        const alreadyAdded = new Set(allSpecs.map(s => s.name));
                                        const availableSpecNames = Object.entries(data?.allSpecMeta || {})
                                            .filter(([name, m]) => m.skillName === skill.name && !alreadyAdded.has(name))
                                            .map(([name]) => name);
                                        const isOpen = openSpecSkill === skill.name;
                                        return (
                                            <div key={skill.name} style={{position: 'relative'}}>
                                                <div className="sk-row" data-char={skill.characteristicAbbr}>
                                                    <button
                                                        className="spec-add-btn"
                                                        title="Add specialization"
                                                        onClick={() => setOpenSpecSkill(isOpen ? null : skill.name)}
                                                    >+
                                                    </button>
                                                    <span className="sk-char">{skill.characteristicAbbr}</span>
                                                    <span className="sk-name">{skill.name}</span>
                                                    <div className="adv-ctrl">
                                                        <button className="adv-btn"
                                                                onClick={() => changeSkillAdv(skill.name, -1)}>−
                                                        </button>
                                                        <input className="sheet-adv" type="number" min={0} max={4}
                                                               value={skillAdv[skill.name] || 0}
                                                               onChange={e => setSkillAdv(p => ({
                                                                   ...p,
                                                                   [skill.name]: Math.max(0, Math.min(4, parseInt(e.target.value) || 0))
                                                               }))}/>
                                                        <button className="adv-btn"
                                                                onClick={() => changeSkillAdv(skill.name, 1)}>+
                                                        </button>
                                                    </div>
                                                    <span className="sk-total rollable"
                                                          onClick={() => openRollModal(skill.name, skillTotal(skill))}>{skillTotal(skill)}</span>
                                                </div>
                                                {isOpen && (
                                                    <div className="spec-dropdown">
                                                        {availableSpecNames.map(name => (
                                                            <div key={name} className="spec-drop-item"
                                                                 onMouseDown={() => {
                                                                     const meta = data?.allSpecMeta?.[name];
                                                                     const charAbbr = meta?.characteristicAbbr || skill.characteristicAbbr;
                                                                     setExtraSpecs(prev => [...prev, {
                                                                         name,
                                                                         skillName: skill.name,
                                                                         characteristicAbbr: charAbbr
                                                                     }]);
                                                                     setOpenSpecSkill(null);
                                                                     setCustomSpecText('');
                                                                 }}>{name}</div>
                                                        ))}
                                                        <div className="spec-drop-custom">
                                                            <input
                                                                className="spec-drop-input"
                                                                placeholder="Custom specialization…"
                                                                value={customSpecText}
                                                                onChange={e => setCustomSpecText(e.target.value)}
                                                                onKeyDown={e => {
                                                                    if (e.key === 'Enter' && customSpecText.trim()) {
                                                                        setExtraSpecs(prev => [...prev, {
                                                                            name: customSpecText.trim(),
                                                                            skillName: skill.name,
                                                                            characteristicAbbr: skill.characteristicAbbr
                                                                        }]);
                                                                        setCustomSpecText('');
                                                                        setOpenSpecSkill(null);
                                                                    }
                                                                    if (e.key === 'Escape') setOpenSpecSkill(null);
                                                                }}
                                                                autoFocus
                                                            />
                                                        </div>
                                                    </div>
                                                )}
                                                {allSpecs.map(spec => (
                                                    <div key={spec.name} className="sp-row"
                                                         data-char={spec.characteristicAbbr}>
                                                        <span className="sk-char">{spec.characteristicAbbr}</span>
                                                        <span className="sp-name">{spec.name}</span>
                                                        <div className="adv-ctrl">
                                                            <button className="adv-btn"
                                                                    onClick={() => setSpecAdv(p => ({
                                                                        ...p,
                                                                        [spec.name]: Math.max(0, (p[spec.name] || 0) - 1)
                                                                    }))}>−
                                                            </button>
                                                            <input className="sheet-adv" type="number" min={0} max={4}
                                                                   value={specAdv[spec.name] || 0}
                                                                   onChange={e => setSpecAdv(p => ({
                                                                       ...p,
                                                                       [spec.name]: Math.max(0, Math.min(4, parseInt(e.target.value) || 0))
                                                                   }))}/>
                                                            <button className="adv-btn"
                                                                    onClick={() => setSpecAdv(p => ({
                                                                        ...p,
                                                                        [spec.name]: Math.min(4, (p[spec.name] || 0) + 1)
                                                                    }))}>+
                                                            </button>
                                                        </div>
                                                        <span className="sk-total rollable"
                                                              onClick={() => openRollModal(spec.name, specTotal(spec))}>{specTotal(spec)}</span>
                                                    </div>
                                                ))}
                                            </div>
                                        );
                                    })}
                                </div>
                            ))}
                        </div>

                        {/* Talents */}
                        <div className="sec-block">
                            <div className="sec-hdr">Talents &amp; Traits</div>
                            <div className="sec-body">
                                <div className="tag-cloud">
                                    {talents.map(t => (
                                        <span key={t.name} className="sm-tag removable-tag" data-desc={t.desc || ''}>
                      <span>{t.name}</span>
                      <button className="tag-remove-btn" onClick={() => removeTalent(t.name)}>×</button>
                    </span>
                                    ))}
                                </div>
                                <AcAddRow placeholder="Search talents…" options={data.allTalentNames || []}
                                          onAdd={addTalent}/>
                            </div>
                        </div>

                        {/* Mutations */}
                        <div className="sec-block">
                            <div className="sec-hdr">Corruption &amp; Mutations</div>
                            <div className="sec-body">
                                <div className="tag-cloud">
                                    {mutations.map(m => (
                                        <span key={m.name} className="sm-tag removable-tag" data-desc={m.desc || ''}>
                      <span>{m.name}</span>
                      <button className="tag-remove-btn"
                              onClick={() => setMutations(p => p.filter(x => x.name !== m.name))}>×</button>
                    </span>
                                    ))}
                                </div>
                                <AcAddRow placeholder="Search mutations…" options={data.allMutationNames || []}
                                          onAdd={addMutation}/>
                            </div>
                        </div>

                        {/* Psychic Powers */}
                        {talents.some(t => t.name.toLowerCase() === 'psyker') && (
                            <div className="sec-block">
                                <div className="sec-hdr">Psychic Powers</div>
                                <div className="sec-body">
                                    <table className="data-table">
                                        <thead>
                                        <tr>
                                            <th>Name</th>
                                            <th style={{width: '36px'}}>WR</th>
                                            <th style={{width: '100px'}}>Difficulty</th>
                                            <th style={{width: '80px'}}>Range</th>
                                            <th style={{width: '80px'}}>Target</th>
                                            <th style={{width: '80px'}}>Duration</th>
                                            <th>Effect</th>
                                            <th style={{width: '24px'}}></th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        {knownPowers.map(p => (
                                            <tr key={p.id}>
                                                <td>{p.name}</td>
                                                <td style={{textAlign: 'center'}}>{p.warpRating}</td>
                                                <td>{p.difficulty}</td>
                                                <td>{p.range}</td>
                                                <td>{p.target}</td>
                                                <td>{p.duration}</td>
                                                <td style={{fontSize: '13px', color: 'var(--muted)', fontFamily: "'Barlow', sans-serif"}}>{p.effect}</td>
                                                <td style={{textAlign: 'center', padding: '2px'}}>
                                                    <button className="tag-remove-btn"
                                                            onClick={() => setKnownPowers(prev => prev.filter(x => x.id !== p.id))}>×</button>
                                                </td>
                                            </tr>
                                        ))}
                                        </tbody>
                                    </table>
                                    <AcAddRow
                                        placeholder="Search powers…"
                                        options={disciplines.flatMap(d => d.powers || []).map(p => p.name)}
                                        onAdd={name => {
                                            const power = disciplines.flatMap(d => d.powers || []).find(p => p.name === name);
                                            if (power && !knownPowers.find(p => p.id === power.id)) {
                                                setKnownPowers(prev => [...prev, power]);
                                            }
                                        }}
                                    />
                                </div>
                            </div>
                        )}

                    </div>
                    {/* /page 2 */}


                    {/* ══════════════════════════════════════
              PAGE 3 — COMBAT · WEAPONS · EQUIPMENT
          ══════════════════════════════════════ */}
                    <div className="sheet-page">

                        <div className="sec-hdr" style={{borderTop: 'none'}}>Combat</div>
                        <div className="combat-bar">
                            <div className="cb-cell">
                                <div className="id-label">Initiative</div>
                                <div className="cb-val">{initiative}</div>
                            </div>
                            <div className="cb-cell">
                                <div className="id-label">Dodge</div>
                                <div className="cb-val rollable" onClick={() => openRollModal('Dodge', dodge)}>{dodge}</div>
                            </div>
                            <div className="cb-cell">
                                <div className="id-label">Parry</div>
                                <div className="cb-val rollable" onClick={() => openRollModal('Parry', parry)}>{parry}</div>
                            </div>
                            <div className="cb-cell">
                                <div className="id-label">Superiority</div>
                                <input className="fate-num-input" type="number" min={0} value={superiority}
                                       onChange={e => setSuperiority(parseInt(e.target.value) || 0)}/>
                            </div>
                            <div className="cb-cell dice-cell">
                                <div className="id-label">d100</div>
                                <button className="dice-btn" onClick={() => makeRoll()} disabled={rolling}
                                        title="Roll d100">
                                    {rolling ? '…' : '🎲'}
                                </button>
                                {lastRoll && <div
                                    className={`dice-result${lastRoll.crit ? ' crit' : lastRoll.fumble ? ' fumble' : lastRoll.success === true ? ' success' : lastRoll.success === false ? ' failure' : ''}`}>{lastRoll.value}</div>}
                            </div>
                        </div>


                        {/* Combat Actions */}
                        {(data.allActionNames || []).length > 0 && (
                            <div className="sec-block">
                                <div className="sec-hdr">Combat Actions <span style={{
                                    fontFamily: "'Barlow',sans-serif",
                                    fontSize: '10px',
                                    textTransform: 'none',
                                    letterSpacing: 0,
                                    color: 'var(--muted)',
                                    fontStyle: 'italic'
                                }}>hover for description</span></div>
                                <div className="sec-body">
                                    <div className="tag-cloud">
                                        {data.allActionNames.map(a => (
                                            <span key={a} className="sm-tag"
                                                  data-desc={data.actionDescMap?.[a] || ''}>{a}</span>
                                        ))}
                                    </div>
                                </div>
                            </div>
                        )}

                        {/* Weapons */}
                        <div className="sec-block">
                            <div className="sec-hdr">Weapons</div>
                            <div className="sec-body">
                                <table className="data-table">
                                    <thead>
                                    <tr>
                                        <th style={{width: '20px'}}></th>
                                        <th style={{width: '130px'}}>Name</th>
                                        <th style={{width: '80px'}}>Specialization</th>
                                        <th style={{width: '44px'}}>Test</th>
                                        <th style={{width: '60px'}}>Damage</th>
                                        <th style={{width: '65px'}}>Range</th>
                                        <th style={{width: '36px'}}>Mag</th>
                                        <th style={{width: '36px'}}>Enc</th>
                                        <th>Traits</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {weaponRows.map((r, i) => (
                                        <tr key={`w${i}`}>
                                            <td style={{textAlign: 'center', padding: '2px'}}>
                                                {r.name && r.test && (
                                                    <span className="weapon-roll-trigger rollable"
                                                          onClick={() => openRollModal(`${r.name} (${r.test})`, charCurrent[r.test] || 0, true)}>
                              {r.test}
                            </span>
                                                )}
                                            </td>
                                            <td><input type="text" value={r.name}
                                                       onChange={e => updateWeaponRow(i, 'name', e.target.value)}/></td>
                                            <td><input type="text" value={r.spec}
                                                       onChange={e => updateWeaponRow(i, 'spec', e.target.value)}/></td>
                                            <td><input type="text" value={r.test}
                                                       onChange={e => updateWeaponRow(i, 'test', e.target.value)}/></td>
                                            <td><input type="text" value={r.dmg}
                                                       onChange={e => updateWeaponRow(i, 'dmg', e.target.value)}/></td>
                                            <td><input type="text" value={r.range}
                                                       onChange={e => updateWeaponRow(i, 'range', e.target.value)}/>
                                            </td>
                                            <td><input type="text" value={r.mag}
                                                       onChange={e => updateWeaponRow(i, 'mag', e.target.value)}/></td>
                                            <td><input type="text" value={r.enc}
                                                       onChange={e => updateWeaponRow(i, 'enc', e.target.value)}/></td>
                                            <td><input type="text" value={r.traits}
                                                       onChange={e => updateWeaponRow(i, 'traits', e.target.value)}/>
                                            </td>
                                        </tr>
                                    ))}
                                    <GhostRows count={Math.max(0, 5 - weaponRows.length)} cols={9}/>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        {/* Protection + Conditions */}
                        <div className="two-col-panels">
                            <div className="panel-half">
                                <div className="panel-half-title">Protection</div>
                                <table className="data-table">
                                    <thead>
                                    <tr>
                                        <th style={{width: '90px'}}>Location</th>
                                        <th style={{width: '38px'}}>AP</th>
                                        <th>Special</th>
                                        <th style={{width: '30px'}}>WT</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {PROTECT_LOCS.map(loc => (
                                        <tr key={loc}>
                                            <td className="loc-cell">{loc}</td>
                                            <td><input type="text" value={protection[loc]?.ap || ''}
                                                       onChange={e => setProtection(p => ({
                                                           ...p,
                                                           [loc]: {...p[loc], ap: e.target.value}
                                                       }))}/></td>
                                            <td><input type="text" value={protection[loc]?.special || ''}
                                                       onChange={e => setProtection(p => ({
                                                           ...p,
                                                           [loc]: {...p[loc], special: e.target.value}
                                                       }))}/></td>
                                            <td><input type="text" value={protection[loc]?.wt || ''}
                                                       onChange={e => setProtection(p => ({
                                                           ...p,
                                                           [loc]: {...p[loc], wt: e.target.value}
                                                       }))}/></td>
                                        </tr>
                                    ))}
                                    </tbody>
                                </table>
                            </div>
                            <div className="panel-half">
                                <div className="panel-half-title">Conditions <span style={{fontFamily:"'Barlow',sans-serif",fontSize:'10px',textTransform:'none',letterSpacing:0,color:'var(--muted)',fontStyle:'italic'}}>hover for description</span></div>
                                <div className="tag-cloud">
                                    {allConditions.map(c => {
                                        const st = activeConditions[c.name] || {};
                                        const isActive = st.minor || st.major;
                                        const toggle = (key, e) => { e.stopPropagation(); setActiveConditions(p => { const prev = p[c.name] || {}; const newVal = !prev[key]; let next = {...prev, [key]: newVal}; if (key === 'major' && newVal) next.minor = true; if (key === 'minor' && !newVal) next.major = false; return {...p, [c.name]: next}; }); };
                                        const tooltip = [c.description, c.minorEffect && `Minor: ${c.minorEffect}`, c.majorEffect && `Major: ${c.majorEffect}`, c.removal && `Remove: ${c.removal}`].filter(Boolean).join('\n\n');
                                        const hasSeverity = c.minorEffect || c.majorEffect;
                                        return (
                                            <div key={c.name} className={`cond-chip${isActive ? ' cond-chip-active' : ''}`} data-desc={tooltip}>
                                                <span className="cond-chip-name">{c.name}</span>
                                                <input type="checkbox" className="cond-cb" checked={!!st.minor} onChange={e => toggle('minor', e)}/>
                                                {hasSeverity && <input type="checkbox" className="cond-cb" checked={!!st.major} onChange={e => toggle('major', e)}/>}
                                            </div>
                                        );
                                    })}
                                </div>
                            </div>
                        </div>

                        {/* Critical Wounds — full width */}
                        <div className="sec-block">
                            <div className="sec-hdr">Critical Wounds</div>
                            <div className="sec-body">
                                {/* Lookup bar */}
                                <div className="crit-lookup-bar no-print">
                                    <select className="crit-lookup-select" value={critLookupLoc}
                                            onChange={e => { setCritLookupLoc(e.target.value); setCritLookupResult(null); }}>
                                        {['HEAD', 'BODY', 'ARMS', 'LEGS'].map(l => <option key={l}>{l}</option>)}
                                    </select>
                                    <input className="crit-lookup-roll" type="number" min={1} max={99}
                                           placeholder="Roll…" value={critLookupRoll}
                                           onChange={e => { setCritLookupRoll(e.target.value); setCritLookupResult(null); }}
                                           onKeyDown={e => e.key === 'Enter' && doCritLookup()}/>
                                    <button className="action-btn secondary" style={{padding: '4px 10px', fontSize: '11px'}}
                                            onClick={doCritLookup} disabled={critLookupLoading}>
                                        {critLookupLoading ? '…' : 'Lookup'}
                                    </button>
                                </div>
                                {critLookupResult && !critLookupResult.error && (
                                    <div className="crit-lookup-result no-print">
                                        <div className="crit-lookup-title">
                                            {critLookupResult.title}
                                            {critLookupResult.fatal && <span className="crit-fatal-badge">Fatal</span>}
                                        </div>
                                        <div className="crit-lookup-effect">{critLookupResult.effect}</div>
                                        {critLookupResult.injury && (
                                            <div className="crit-lookup-injury">Injury: {critLookupResult.injury}</div>
                                        )}
                                        {critLookupResult.treatment && (
                                            <div className="crit-lookup-injury">Treatment: {critLookupResult.treatment}</div>
                                        )}
                                        <button className="crit-lookup-add-btn" onClick={() => {
                                            const entry = `${critLookupResult.title} — ${critLookupResult.effect}`;
                                            const treatment = critLookupResult.treatment || '';
                                            const empty = critTable.findIndex(r => !r.loc && !r.effect);
                                            if (empty !== -1) {
                                                setCritTable(prev => prev.map((r, i) => i === empty
                                                    ? {...r, loc: critLookupLoc, effect: entry, treatment}
                                                    : r));
                                            } else {
                                                setCritTable(prev => [...prev, {loc: critLookupLoc, effect: entry, treatment, val: ''}]);
                                            }
                                            const li = critLookupResult.linkedInjury;
                                            if (li) {
                                                setInjuries(prev => [...prev, {
                                                    loc: li.affectedPart || '',
                                                    desc: li.name,
                                                    effect: li.effect || ''
                                                }]);
                                            }
                                            setCritLookupResult(null);
                                            setCritLookupRoll('');
                                        }}>+ Add to table</button>
                                    </div>
                                )}
                                {critLookupResult?.error && (
                                    <div className="crit-lookup-result no-print" style={{color: 'var(--muted)'}}>No result for roll {critLookupRoll}.</div>
                                )}
                                <table className="data-table crit-wound-table">
                                    <thead>
                                    <tr>
                                        <th style={{width: '72px'}}>Location</th>
                                        <th>Effect / Notes</th>
                                        <th style={{width: '140px'}}>Treatment</th>
                                        <th style={{width: '24px'}}></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {critTable.map((r, i) => (
                                        <tr key={i} style={{verticalAlign: 'top'}}>
                                            <td><input type="text" value={r.loc} placeholder="—"
                                                       onChange={e => updateCritRow(i, 'loc', e.target.value)}/></td>
                                            <td><AutoTextarea value={r.effect} placeholder="—"
                                                              className="crit-cell-textarea"
                                                              onChange={e => updateCritRow(i, 'effect', e.target.value)}/></td>
                                            <td><AutoTextarea value={r.treatment || ''} placeholder="—"
                                                              className="crit-cell-textarea"
                                                              onChange={e => updateCritRow(i, 'treatment', e.target.value)}/></td>
                                            <td style={{textAlign: 'center', padding: '2px'}}>
                                                <button className="tag-remove-btn"
                                                        onClick={() => setCritTable(prev => prev.filter((_, j) => j !== i))}>×</button>
                                            </td>
                                        </tr>
                                    ))}
                                    <GhostRows count={Math.max(0, 6 - critTable.length)} cols={4}/>
                                    </tbody>
                                </table>
                                <div className="no-print" style={{marginTop: '4px'}}>
                                    <button className="action-btn secondary" style={{padding: '3px 10px', fontSize: '11px'}}
                                            onClick={() => setCritTable(prev => [...prev, {loc: '', effect: '', treatment: '', val: ''}])}>+ Row</button>
                                </div>
                            </div>
                        </div>

                        {/* Injuries */}
                        <div className="sec-block">
                            <div className="sec-hdr">Injuries</div>
                            <div className="sec-body">
                                <table className="data-table">
                                    <thead>
                                    <tr>
                                        <th style={{width: '140px'}}>Injury</th>
                                        <th style={{width: '80px'}}>Location</th>
                                        <th>Effect</th>
                                        <th style={{width: '24px'}}></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {injuries.map((r, i) => (
                                        <tr key={i} style={{verticalAlign: 'top'}}>
                                            <td><input type="text" value={r.desc}
                                                       onChange={e => setInjuries(p => p.map((x, j) => j === i ? {
                                                           ...x,
                                                           desc: e.target.value
                                                       } : x))}/></td>
                                            <td><input type="text" value={r.loc}
                                                       onChange={e => setInjuries(p => p.map((x, j) => j === i ? {
                                                           ...x,
                                                           loc: e.target.value
                                                       } : x))}/></td>
                                            <td><AutoTextarea value={r.effect}
                                                              className="crit-cell-textarea"
                                                              onChange={e => setInjuries(p => p.map((x, j) => j === i ? {
                                                                  ...x,
                                                                  effect: e.target.value
                                                              } : x))}/></td>
                                            <td style={{textAlign: 'center', padding: '2px'}}>
                                                <button className="tag-remove-btn"
                                                        onClick={() => setInjuries(p => p.filter((_, j) => j !== i))}>×</button>
                                            </td>
                                        </tr>
                                    ))}
                                    <GhostRows count={Math.max(0, 5 - injuries.length)} cols={4}/>
                                    </tbody>
                                </table>
                                <AcAddRow placeholder="Search injuries…"
                                          options={allInjuries.map(i => i.name)}
                                          onAdd={addInjuryFromSearch}/>
                            </div>
                        </div>

                        {/* Equipment */}
                        <div className="sec-block">
                            <div className="sec-hdr">Equipment</div>
                            <div className="sec-body">
                                <table className="data-table">
                                    <thead>
                                    <tr>
                                        <th style={{width: '28px'}} title="Equipped">Eqp</th>
                                        <th>Name</th>
                                        <th style={{width: '36px'}}>Qty</th>
                                        <th style={{width: '36px'}}>Enc</th>
                                        <th>Notes</th>
                                        <th style={{width: '24px'}}></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {equipment.map((item, i) => (
                                        <tr key={i}>
                                            <td style={{textAlign: 'center', padding: '2px'}}>
                                                <input type="checkbox" checked={item.equipped}
                                                       onChange={() => toggleEquip(i)}/>
                                            </td>
                                            <td><input type="text" value={item.name}
                                                       onChange={e => setEquipment(p => p.map((x, j) => j === i ? {
                                                           ...x,
                                                           name: e.target.value
                                                       } : x))}/></td>
                                            <td><input type="number" min={1} value={item.qty}
                                                       onChange={e => setEquipment(p => p.map((x, j) => j === i ? {
                                                           ...x,
                                                           qty: parseInt(e.target.value) || 1
                                                       } : x))} style={{textAlign: 'center'}}/></td>
                                            <td><input type="number" min={0} step={0.5} value={item.enc ?? 0}
                                                       onChange={e => setEquipment(p => p.map((x, j) => j === i ? {
                                                           ...x,
                                                           enc: parseFloat(e.target.value) || 0
                                                       } : x))} style={{textAlign: 'center'}}/></td>
                                            <td><input type="text" value={item.notes}
                                                       onChange={e => setEquipment(p => p.map((x, j) => j === i ? {
                                                           ...x,
                                                           notes: e.target.value
                                                       } : x))}/></td>
                                            <td style={{textAlign: 'center', padding: '2px'}}>
                                                <button className="tag-remove-btn" onClick={() => removeEquip(i)}>×
                                                </button>
                                            </td>
                                        </tr>
                                    ))}
                                    <GhostRows count={Math.max(0, 10 - equipment.length)} cols={6}/>
                                    </tbody>
                                </table>
                                <AcAddRow placeholder="Search equipment…" options={data.allInventoryNames || []}
                                          onAdd={addEquip}/>
                                <div style={{display:'flex', alignItems:'center', gap:'24px', marginTop:'10px', padding:'6px 0', borderTop:'1px solid var(--border)'}}>
                                    <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                        <span className="id-label" style={{margin:0}}>Encumbrance</span>
                                        <span className="fate-threshold">{encCurrent % 1 === 0 ? encCurrent : encCurrent.toFixed(1)}</span>
                                        <span style={{color:'var(--muted)', fontFamily:"'Barlow',sans-serif", fontSize:'13px'}}>/</span>
                                        <span className={`fate-threshold${encCurrent > encMax ? ' over-enc' : ''}`}
                                              style={{color: encCurrent > encMax ? 'var(--red)' : undefined}}>{encMax}</span>
                                    </div>
                                    <div style={{display:'flex', alignItems:'center', gap:'8px'}}>
                                        <span className="id-label" style={{margin:0}}>Solars</span>
                                        {startingMoney && (() => {
                                            const isDice = /\d+d\d+/i.test(startingMoney);
                                            const rollMoney = () => {
                                                const match = startingMoney.match(/(\d+)d(\d+)/i);
                                                if (!match) return;
                                                const [, count, sides] = match.map(Number);
                                                let total = 0;
                                                for (let i = 0; i < count; i++) total += Math.floor(Math.random() * sides) + 1;
                                                setSolarsAmount(String(total));
                                            };
                                            return isDice
                                                ? <button className="dice-roll-btn" onClick={rollMoney} title={`Roll ${startingMoney}`}>⚄ {startingMoney}</button>
                                                : null;
                                        })()}
                                        <input
                                            type="number"
                                            min={0}
                                            value={solarsAmount}
                                            onChange={e => setSolarsAmount(e.target.value)}
                                            placeholder="—"
                                            className="fate-num-input"
                                            style={{width:'60px'}}
                                        />
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* Augmentics */}
                        <div className="sec-block">
                            <div className="sec-hdr">Augmentics</div>
                            <div className="sec-body">
                                <table className="data-table">
                                    <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Notes / Location</th>
                                        <th style={{width: '24px'}}></th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    {augmetics.map((a, i) => (
                                        <tr key={i}>
                                            <td><input type="text" value={a.name}
                                                       onChange={e => setAugmetics(p => p.map((x, j) => j === i ? {...x, name: e.target.value} : x))}/></td>
                                            <td><input type="text" value={a.notes}
                                                       onChange={e => setAugmetics(p => p.map((x, j) => j === i ? {...x, notes: e.target.value} : x))}/></td>
                                            <td style={{textAlign: 'center', padding: '2px'}}>
                                                <button className="tag-remove-btn"
                                                        onClick={() => setAugmetics(p => p.filter((_, j) => j !== i))}>×</button>
                                            </td>
                                        </tr>
                                    ))}
                                    <GhostRows count={Math.max(0, 5 - augmetics.length)} cols={3}/>
                                    </tbody>
                                </table>
                                <AcAddRow placeholder="Search augmetics…" options={data.allAugmeticNames || []}
                                          onAdd={addAugmetic}/>
                            </div>
                        </div>

                    </div>
                    {/* /page 3 */}


                    {/* ══════════════════════════════════════
              PAGE 4 — APPEARANCE · NOTES
          ══════════════════════════════════════ */}
                    <div className="sheet-page">

                        <div className="sec-hdr" style={{borderTop: 'none'}}>Appearance</div>
                        <div className="appear-row">
                            {[['Age', age, setAge], ['Height', height, setHeight], ['Eyes', eyes, setEyes], ['Hair Colour', hairColor, setHairColor], ['Hair Style', hairStyle, setHairStyle]].map(([label, val, set]) => (
                                <div key={label} className="appear-item">
                                    <div className="appear-label">{label}</div>
                                    <textarea className="appear-input" rows={2} value={val}
                                              onChange={e => set(e.target.value)}/>
                                </div>
                            ))}
                            <div className="appear-item wide">
                                <div className="appear-label">Distinguishing Features</div>
                                <textarea className="appear-input" rows={2} value={distFeatures}
                                          onChange={e => setDistFeatures(e.target.value)}/>
                            </div>
                        </div>

                        <div className="notes-grid">
                            <div className="notes-cell">
                                <div style={{
                                    fontFamily: "'Barlow',sans-serif",
                                    fontSize: '7px',
                                    color: 'var(--red-mid)',
                                    textTransform: 'uppercase',
                                    letterSpacing: '2px',
                                    marginBottom: '4px'
                                }}>Divination
                                </div>
                                <textarea className="sheet-textarea" rows={4} value={divination}
                                          onChange={e => setDivination(e.target.value)} placeholder="Your divination…"/>
                            </div>
                            <div className="notes-cell">
                                <div style={{
                                    fontFamily: "'Barlow',sans-serif",
                                    fontSize: '7px',
                                    color: 'var(--red-mid)',
                                    textTransform: 'uppercase',
                                    letterSpacing: '2px',
                                    marginBottom: '4px'
                                }}>Short Term Goal
                                </div>
                                <textarea className="sheet-textarea" rows={4} value={shortGoal}
                                          onChange={e => setShortGoal(e.target.value)}/>
                            </div>
                            <div className="notes-cell">
                                <div style={{
                                    fontFamily: "'Barlow',sans-serif",
                                    fontSize: '7px',
                                    color: 'var(--red-mid)',
                                    textTransform: 'uppercase',
                                    letterSpacing: '2px',
                                    marginBottom: '4px'
                                }}>Long Term Goal
                                </div>
                                <textarea className="sheet-textarea" rows={4} value={longGoal}
                                          onChange={e => setLongGoal(e.target.value)}/>
                            </div>
                        </div>

                        <div className="sec-block">
                            <div className="sec-hdr">Biography</div>
                            <div className="sec-body">
                                <textarea className="sheet-textarea" rows={12} style={{minHeight: '180px'}}
                                          value={biography} onChange={e => setBiography(e.target.value)}
                                          placeholder="Character background, history, personality, connections…"/>
                            </div>
                        </div>

                    </div>
                    {/* /page 4 */}

                    {/* ── Bottom actions ── */}
                    <div className="page-actions">
                        <button className="action-btn" onClick={handleSave}
                                disabled={saving}>{saving ? 'Saving…' : saveCode ? 'Save Again' : 'Save Character'}</button>
                        {saveCode && (
                            <div className="save-code-box">
                                Code: <strong>{saveCode}</strong>
                                <button className={`copy-btn${copied ? ' copied' : ''}`}
                                        onClick={copyCode}>{copied ? 'Copied!' : 'Copy'}</button>
                            </div>
                        )}
                        <button className="action-btn secondary" onClick={() => window.print()}>Print / Save PDF
                        </button>
                    </div>

                </div>
            </div>

            {/* ── Roll modal ── */}
            {rollModal && (
                <div className="roll-overlay" onClick={e => {
                    if (e.target === e.currentTarget) setRollModal(null);
                }}>
                    <div className="roll-modal">
                        <div className="roll-modal-header">
                            <div className="roll-modal-title">{rollModal.label}</div>
                            <div
                                className="roll-modal-target">Target: <strong>{(rollModal.target || 0) + rollModifier}</strong>
                            </div>
                            <button className="roll-modal-close" onClick={() => setRollModal(null)}>×</button>
                        </div>

                        <div className="roll-modal-body">

                            {/* Difficulty */}
                            <div className="roll-modal-section">
                                <div className="roll-modal-label">Difficulty</div>
                                <div className="diff-grid">
                                    {DIFFICULTIES.map(d => (
                                        <button key={d.short}
                                                className={`diff-btn${rollDifficulty === d.mod ? ' active' : ''}`}
                                                onClick={() => setRollDifficulty(d.mod)}
                                                title={d.label}>
                                            <span className="diff-short">{d.short}</span>
                                            <span className="diff-mod">{d.mod > 0 ? '+' : ''}{d.mod}</span>
                                        </button>
                                    ))}
                                </div>
                            </div>

                            {/* Mode */}
                            <div className="roll-modal-section">
                                <div className="roll-modal-label">Mode</div>
                                <div className="roll-mode-group">
                                    {[['normal', 'Normal'], ['advantage', 'Advantage'], ['disadvantage', 'Disadvantage']].map(([m, lbl]) => (
                                        <button key={m} className={`roll-mode-btn${rollMode === m ? ' active' : ''}`}
                                                onClick={() => setRollMode(m)}>{lbl}</button>
                                    ))}
                                </div>
                            </div>

                            {/* Modifiers row */}
                            <div className="roll-modal-row">
                                <div className="roll-modal-field">
                                    <div className="roll-modal-label">Modifier</div>
                                    <input className="roll-modal-input" type="number" value={rollModifier}
                                           onChange={e => setRollModifier(parseInt(e.target.value) || 0)}/>
                                </div>
                                <div className="roll-modal-field">
                                    <div className="roll-modal-label">Extra DoS</div>
                                    <input className="roll-modal-input" type="number" value={rollExtraDoS} min={0}
                                           onChange={e => setRollExtraDoS(parseInt(e.target.value) || 0)}/>
                                </div>
                                <div className="roll-modal-field">
                                    <div className="roll-modal-label">Effective</div>
                                    <div
                                        className="roll-modal-effective">{(rollModal.target || 0) + rollDifficulty + rollModifier}</div>
                                </div>
                            </div>

                            {superiority > 0 && (
                                <label style={{
                                    display: 'flex', alignItems: 'center', gap: '8px',
                                    cursor: 'pointer', marginBottom: '8px',
                                    fontFamily: "'Barlow', sans-serif", fontSize: '13px',
                                    color: 'var(--text)', userSelect: 'none',
                                }}>
                                    <input type="checkbox"
                                           checked={rollExtraDoS >= superiority}
                                           onChange={e => setRollExtraDoS(d => e.target.checked ? d + superiority : Math.max(0, d - superiority))}
                                           style={{width: 'auto', accentColor: 'var(--red)'}}/>
                                    Add Superiority (+{superiority} DoS)
                                </label>
                            )}

                            <button className="roll-execute-btn" onClick={executeRoll} disabled={rolling}>
                                {rolling ? 'Rolling…' : 'Roll d100'}
                            </button>

                            {rollResult && (
                                <div
                                    className={`roll-modal-result${rollResult.crit ? ' crit' : rollResult.fumble ? ' fumble' : rollResult.success ? ' success' : ' failure'}`}>
                                    <div className="rmr-dice">
                                        {rollMode !== 'normal' && rollResult.orig !== rollResult.rev
                                            ? <><span
                                                className={rollResult.reversed ? 'rmr-dim' : ''}>{rollResult.orig}</span>
                                                <span className="rmr-sep">/</span>
                                                <span
                                                    className={!rollResult.reversed ? 'rmr-dim' : ''}>{rollResult.rev}</span>
                                            </>
                                            : rollResult.value}
                                    </div>
                                    {rollMode !== 'normal' && rollResult.orig !== rollResult.rev && (
                                        <div className="rmr-chosen">
                                            {rollResult.reversed ? 'reversed →' : 'used →'}
                                            <strong>{rollResult.value}</strong>
                                        </div>
                                    )}
                                    <div className="rmr-verdict">
                                        {rollResult.crit ? '🌟 Critical Success!'
                                            : rollResult.fumble ? '💀 Fumble!'
                                                : rollResult.success ? `✅ Success — DoS ${rollResult.degrees}`
                                                    : `❌ Failure — DoF ${rollResult.degrees}`}
                                    </div>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            )}

            {/* ── Roll toast ── */}
            {lastRoll && (
                <div
                    className={`roll-toast${lastRoll.crit ? ' crit' : lastRoll.fumble ? ' fumble' : lastRoll.success === true ? ' success' : lastRoll.success === false ? ' failure' : ''}`}
                    onClick={() => setLastRoll(null)}>
                    {lastRoll.label && <div className="rt-label">{lastRoll.label}</div>}
                    <div className="rt-value">{lastRoll.value}</div>
                    {lastRoll.target !== null && (
                        <div className="rt-sub">
                            {lastRoll.crit ? '🌟 Critical!' : lastRoll.fumble ? '💀 Fumble!'
                                : lastRoll.success ? `✓ DoS ${lastRoll.degrees}` : `✗ DoF ${lastRoll.degrees}`}
                            <span className="rt-target"> / {lastRoll.target}</span>
                        </div>
                    )}
                </div>
            )}
        </>
    );
}

/* ── Auto-growing textarea ── */
function GhostRows({count, cols}) {
    if (count <= 0) return null;
    return Array.from({length: count}, (_, i) => (
        <tr key={`g${i}`} className="print-ghost-row">
            {Array.from({length: cols}, (_, j) => <td key={j}>&nbsp;</td>)}
        </tr>
    ));
}

function AutoTextarea({value, onChange, className, placeholder}) {
    const ref = useRef(null);
    useEffect(() => {
        if (!ref.current) return;
        ref.current.style.height = 'auto';
        ref.current.style.height = ref.current.scrollHeight + 'px';
    }, [value]);
    return (
        <textarea ref={ref} value={value} onChange={onChange}
                  className={className} placeholder={placeholder}
                  rows={1} style={{resize: 'none', overflow: 'hidden', width: '100%', boxSizing: 'border-box'}}/>
    );
}

/* ── Autocomplete add row ── */
function AcAddRow({placeholder, options, onAdd}) {
    const [text, setText] = useState('');
    const [open, setOpen] = useState(false);
    const filtered = options.filter(o => text.length > 0 && o.toLowerCase().includes(text.toLowerCase()));

    const commit = (val) => {
        const v = (val || text).trim();
        if (v) {
            onAdd(v);
            setText('');
            setOpen(false);
        }
    };

    return (
        <div className="add-row">
            <div className="ac-wrap">
                <input className="add-input" type="text" placeholder={placeholder} value={text}
                       onChange={e => {
                           setText(e.target.value);
                           setOpen(true);
                       }}
                       onBlur={() => setTimeout(() => setOpen(false), 150)}
                       onKeyDown={e => {
                           if (e.key === 'Enter') commit();
                       }}/>
                {open && filtered.length > 0 && (
                    <div className="ac-drop">
                        {filtered.slice(0, 20).map(o => (
                            <div key={o} className="ac-item" onMouseDown={() => commit(o)}>{o}</div>
                        ))}
                    </div>
                )}
            </div>
            <button className="add-btn" onClick={() => commit()}>+</button>
        </div>
    );
}
