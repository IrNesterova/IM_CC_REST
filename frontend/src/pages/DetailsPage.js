import {useState} from 'react';
import {useNavigate} from 'react-router-dom';
import {useCharacter} from '../context/CharacterContext';
import Topbar from '../components/Topbar';
import ProgressBar from '../components/ProgressBar';

const DIVINATIONS = [
    "It is better to die for the Emperor than to live for yourself.",
    "Trust in your zeal — it is a weapon with no equal.",
    "A small mind is a tidy mind.",
    "To embrace the xenos is to welcome your own damnation.",
    "Duty prevails.",
    "The wise learn from the deaths of others.",
    "Destroy the xenos before it can speak its lies.",
    "Logic is the enemy of faith.",
    "Thought begets heresy.",
    "Heresy begets retribution.",
    "A mind without purpose will wander in dark places.",
    "By the manner of our death are we judged.",
    "Success is measured in blood: yours or your enemy's.",
    "The Emperor bestows upon us the gift of intolerance.",
    "True faith is blind and justified.",
    "There is no substitute for zeal.",
    "Even one who has nothing can still offer their life.",
    "The blood of martyrs is the seed of the Imperium.",
    "Call no one happy until they are dead.",
    "An open mind is like a fortress with its gates unbarred and unguarded.",
    "In the blood of martyrs is the blade of the Imperium made strong.",
    "A moment of heresy blights a lifetime of duty.",
    "Ruthlessness is the kindness of the wise.",
    "A coward seeks compromise.",
    "Only in death does duty end.",
    "Death is the servant of the righteous.",
    "Success is commemorated; failure, merely remembered.",
    "Mercy is a sign of weakness.",
    "Innocence proves nothing.",
    "Blessed is the mind too small for doubt.",
    "Burn the Unclean with the fires of Purity.",
    "Reason is the cloak of traitors.",
    "Turn from the Emperor's light at your peril.",
    "There is nothing to fear but failure.",
    "Doubt is a sign of weakness.",
    "The greatest armour is contempt.",
    "The justice of your action is measured by the strength of your conviction.",
    "Hatred is the Emperor's greatest gift to Humanity.",
    "Doubt forms the path to damnation.",
    "Violence solves everything.",
    "Suffering is an unrelenting instructor.",
    "The Emperor will judge you not by your medals, but by your scars.",
    "Hope is the first step on the road to disappointment.",
    "Forgiveness is a sign of weakness.",
    "Do not ask why you serve; only ask how.",
    "All your works turn to ash and dust if they do not serve the Emperor.",
    "There are no bystanders in war, only soldiers and traitors.",
    "Carry the Emperor's Will as your torch; with it destroy the shadows.",
    "Heresy grows from idleness.",
    "Burn the Heretic! Kill the Mutant! Purge the Unclean!",
];

const EYE_OPTS = ['Mournful', 'Hard', 'Old', 'Focused', 'Wild', 'Striking', 'Bitter', 'Hopeful', 'Suspicious', 'Furious', 'Warm', 'Dead', 'Fiery', 'Judgemental', 'Mesmerising', 'Forlorn', 'Curious', 'Cold', 'Haunted', 'Calculating'];
const HAIR_COLOR_OPTS = ['White/Grey', 'Black', 'Brown/Auburn', 'Red/Orange', 'Blond', 'Green', 'Blue', 'Purple', 'Bare-headed', 'Multiple'];
const HAIR_STYLE_OPTS = ['Unkempt', 'Braided', 'Mohawk', 'Transplanted from an animal', 'Long', 'Cropped', 'Tight curls', 'Large and elaborate', 'Metal wires or spikes', 'Rivets, wire mesh, or plate'];
const FEATURES = [
    "You have a tattoo of the Aquila on your forehead.",
    "You smell faintly of corpse starch.",
    "You have a faded electoo you'd rather forget about.",
    "Pox marks or another lingering sign of an old illness mar your skin.",
    "Your ears have been replaced with bulky but functional augmetics.",
    "Your teeth are made of metal.",
    "Your cornea is tattooed.",
    "You are heavily scarred, perhaps from combat or an industrial accident.",
    "Your teeth are filed to sharp points.",
    "Parts of your skull are covered by a metal plate.",
    "You bear an unexplained scar in the shape of the Aquila.",
    "Your eyelids are heavily tattooed with High Gothic script.",
    "You have a birthmark in the shape of a skull.",
    "You have been branded with the symbol of a sect or cult.",
    "Your pupils are completely white.",
    "Your skin is exceptionally pallid.",
    "Your muscles are overly defined, perhaps from a life of strenuous labour.",
    "Numerous cranial plugs jut from your scalp.",
    "You are wrapped in scripture parchments and purity seals.",
    "You are unremarkable — another infinitely replaceable cog in the machinery of the Imperium.",
];

function d10() {
    return Math.floor(Math.random() * 10) + 1;
}

function rollSelect(opts) {
    return opts[Math.floor(Math.random() * opts.length)];
}

export default function DetailsPage() {
    const {ccm, dispatch} = useCharacter();
    const navigate = useNavigate();

    const [form, setForm] = useState({
        characterName: ccm.characterName || '',
        age: ccm.age || '',
        height: ccm.height || '',
        eyeType: ccm.eyeType || '',
        hairColor: ccm.hairColor || '',
        hairStyle: ccm.hairStyle || '',
        distinguishingFeatures: ccm.distinguishingFeatures || '',
        divination: ccm.divination || '',
        shortTermGoal: ccm.shortTermGoal || '',
        longTermGoal: ccm.longTermGoal || '',
        connections: ccm.connections || '',
    });

    const set = (key, val) => setForm(f => ({...f, [key]: val}));

    const rollAge = () => set('age', String(17 + d10()));
    const rollHeight = () => {
        const inches = 57 + d10() + d10();
        set('height', `${Math.floor(inches / 12)}'${inches % 12}"`);
    };
    const rollFeature = () => {
        const f = FEATURES[Math.floor(Math.random() * FEATURES.length)];
        set('distinguishingFeatures', form.distinguishingFeatures ? form.distinguishingFeatures + '\n' + f : f);
    };
    const rollDivination = () => set('divination', DIVINATIONS[Math.floor(Math.random() * DIVINATIONS.length)]);

    const handleSubmit = (e) => {
        e.preventDefault();
        dispatch({type: 'SET_DETAILS', payload: form});
        navigate('/summary');
    };

    return (
        <>
            <ProgressBar/>
            <Topbar/>
            <div style={{
                flex: 1,
                background: 'var(--bg)',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                padding: '0 32px'
            }}>
                <div style={{width: '100%', maxWidth: '900px', padding: '40px 0 80px'}}>
                    <div style={{
                        fontFamily: "'Barlow', sans-serif",
                        fontSize: '32px',
                        color: 'var(--ink)',
                        marginBottom: '6px'
                    }}>Adding Detail
                    </div>
                    <div
                        style={{fontSize: '18px', color: 'var(--muted)', fontStyle: 'italic', marginBottom: '28px'}}>The
                        numbers on your sheet are only part of your character's story.
                    </div>

                    <form onSubmit={handleSubmit} style={{display: 'flex', flexDirection: 'column', gap: '40px'}}>

                        <Panel title="Identity">
                            <div className="field-grid">
                                <div className="field full">
                                    <label htmlFor="characterName">Name <span
                                        style={{color: 'var(--red)'}}>*</span></label>
                                    <input id="characterName" type="text" value={form.characterName}
                                           onChange={e => set('characterName', e.target.value)}
                                           placeholder="e.g. Horst, Azararch, Killian..." required/>
                                </div>
                                <div className="field">
                                    <label htmlFor="age">Age <span className="optional">(optional)</span></label>
                                    <div className="field-with-roll">
                                        <input id="age" type="text" value={form.age}
                                               onChange={e => set('age', e.target.value)} placeholder="e.g. 24"/>
                                        <button type="button" className="roll-btn" onClick={rollAge}>Roll</button>
                                    </div>
                                </div>
                                <div className="field">
                                    <label htmlFor="height">Height <span className="optional">(optional)</span></label>
                                    <div className="field-with-roll">
                                        <input id="height" type="text" value={form.height}
                                               onChange={e => set('height', e.target.value)}
                                               placeholder="e.g. 5'11&quot;"/>
                                        <button type="button" className="roll-btn" onClick={rollHeight}>Roll</button>
                                    </div>
                                </div>
                            </div>
                        </Panel>

                        <Panel title="Physical Appearance" note="Optional — roll randomly or fill in freely.">
                            <div className="field-grid">
                                <SelectField id="eyeType" label="Eyes" value={form.eyeType}
                                             onChange={v => set('eyeType', v)} opts={EYE_OPTS}
                                             onRoll={() => set('eyeType', rollSelect(EYE_OPTS))}/>
                                <SelectField id="hairColor" label="Hair Colour" value={form.hairColor}
                                             onChange={v => set('hairColor', v)} opts={HAIR_COLOR_OPTS}
                                             onRoll={() => set('hairColor', rollSelect(HAIR_COLOR_OPTS))}/>
                                <SelectField id="hairStyle" label="Hair Style" value={form.hairStyle}
                                             onChange={v => set('hairStyle', v)} opts={HAIR_STYLE_OPTS}
                                             onRoll={() => set('hairStyle', rollSelect(HAIR_STYLE_OPTS))}/>
                                <div className="field full">
                                    <label htmlFor="distinguishingFeatures">Distinguishing Features <span
                                        className="optional">(optional)</span></label>
                                    <div className="field-with-roll" style={{alignItems: 'stretch'}}>
                                        <textarea id="distinguishingFeatures" value={form.distinguishingFeatures}
                                                  onChange={e => set('distinguishingFeatures', e.target.value)}
                                                  placeholder="e.g. Heavily scarred from combat..."/>
                                        <button type="button" className="roll-btn" style={{alignSelf: 'flex-start'}}
                                                onClick={rollFeature}>Roll
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </Panel>

                        <Panel title="Goals"
                               note="Achieving a short-term goal earns 50 XP. A long-term goal earns 500 XP.">
                            <div className="field-grid">
                                <div className="field full">
                                    <label htmlFor="shortTermGoal">Short-term Goal <span
                                        className="optional">(optional)</span></label>
                                    <textarea id="shortTermGoal" value={form.shortTermGoal}
                                              onChange={e => set('shortTermGoal', e.target.value)}
                                              placeholder="An outcome you wish to achieve within days or weeks."/>
                                </div>
                                <div className="field full">
                                    <label htmlFor="longTermGoal">Long-term Goal <span
                                        className="optional">(optional)</span></label>
                                    <textarea id="longTermGoal" value={form.longTermGoal}
                                              onChange={e => set('longTermGoal', e.target.value)}
                                              placeholder="An ambition that will take months or years."/>
                                </div>
                            </div>
                        </Panel>

                        <Panel title="Divination"
                               note="Roll d100 or choose — a portent your character received. If your death reflects it, your next character gains bonus XP.">
                            <div className="field">
                                <label htmlFor="divination">Divination <span
                                    className="optional">(optional)</span></label>
                                <div className="field-with-roll">
                                    <select id="divination" value={form.divination}
                                            onChange={e => set('divination', e.target.value)}>
                                        <option value="">— choose or roll —</option>
                                        {DIVINATIONS.map((d, i) => <option key={i} value={d}>{d}</option>)}
                                    </select>
                                    <button type="button" className="roll-btn" onClick={rollDivination}>d100</button>
                                </div>
                            </div>
                        </Panel>

                        <Panel title="Connections"
                               note="Fragments of shared history that tie you to other characters and your Patron.">
                            <div className="field">
                                <label htmlFor="connections">Connections <span
                                    className="optional">(optional)</span></label>
                                <textarea id="connections" value={form.connections}
                                          onChange={e => set('connections', e.target.value)}
                                          style={{minHeight: '120px'}}
                                          placeholder="e.g. Horst owes me a significant sum of solars."/>
                            </div>
                        </Panel>

                        <div style={{display: 'flex', justifyContent: 'center'}}>
                            <button type="submit" className="submit-btn" style={{minWidth: '300px'}}>Proceed to
                                Summary
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </>
    );
}

function Panel({title, note, children}) {
    return (
        <div style={{
            display: 'flex',
            flexDirection: 'column',
            gap: '24px',
            padding: '32px 36px',
            background: 'var(--panel)',
            border: '1px solid var(--border)',
            position: 'relative',
            boxShadow: '0 2px 10px var(--shadow)'
        }}>
            <div style={{
                position: 'absolute',
                top: 0,
                left: 0,
                width: '100%',
                height: '3px',
                background: 'linear-gradient(90deg, transparent, var(--red), transparent)'
            }}/>
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
            {note &&
                <p style={{fontSize: '18px', color: 'var(--muted)', fontStyle: 'italic', marginTop: '-8px'}}>{note}</p>}
            {children}
        </div>
    );
}

function SelectField({id, label, value, onChange, opts, onRoll}) {
    return (
        <div className="field">
            <label htmlFor={id}>{label} <span className="optional">(optional)</span></label>
            <div className="field-with-roll">
                <select id={id} value={value} onChange={e => onChange(e.target.value)}>
                    <option value="">— choose or leave blank —</option>
                    {opts.map(o => <option key={o} value={o}>{o}</option>)}
                </select>
                <button type="button" className="roll-btn" onClick={onRoll}>Roll</button>
            </div>
        </div>
    );
}
