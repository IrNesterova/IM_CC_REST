import {Link, useLocation} from 'react-router-dom';
import {useCharacter} from '../context/CharacterContext';

const STEPS = [
    {label: 'Stats', path: '/characteristics'},
    {label: 'Origin', path: '/origins'},
    {label: 'Faction', path: '/factions'},
    {label: 'Role', path: '/roles'},
    {label: 'Details', path: '/details'},
    {label: 'Summary', path: '/summary'},
];

const STAT_ABBRS = ['WS', 'BS', 'STR', 'TGH', 'AG', 'INT', 'PER', 'WIL', 'FEL'];

function TipRow({label, value}) {
    if (!value) return null;
    return (
        <div className="tip-row">
            <span className="tip-row-label">{label}</span>
            <span className="tip-row-value">{value}</span>
        </div>
    );
}

export default function ProgressBar() {
    const {pathname} = useLocation();
    const {ccm} = useCharacter();

    const isDone = (path) => {
        if (path === '/characteristics') return Object.keys(ccm.characteristics).length > 0;
        if (path === '/origins') return ccm.originId != null;
        if (path === '/factions') return ccm.factionId != null;
        if (path === '/roles') return ccm.roleId != null;
        if (path === '/details') return !!ccm.characterName;
        return false;
    };

    const getValue = (path) => {
        if (path === '/origins' && ccm._originName) return ccm._originName;
        if (path === '/factions' && ccm._factionName) return ccm._factionName;
        if (path === '/roles' && ccm._roleName) return ccm._roleName;
        if (path === '/details' && ccm.characterName) return ccm.characterName;
        return null;
    };

    const getTooltip = (path) => {
        if (path === '/characteristics' && Object.keys(ccm.characteristics).length > 0) {
            return (
                <table className="stats-grid">
                    <thead>
                    <tr>{STAT_ABBRS.map(a => <th key={a} className="stat-abbr">{a}</th>)}</tr>
                    </thead>
                    <tbody>
                    <tr>{STAT_ABBRS.map(a => <td key={a}
                                                 className="stat-val">{ccm.characteristics[a] || '—'}</td>)}</tr>
                    </tbody>
                </table>
            );
        }

        if (path === '/origins' && ccm.originId) {
            return (
                <div className="tip-stack">
                    <TipRow label="Characteristics" value={ccm._originCharBonuses}/>
                    <TipRow label="Skill" value={ccm._originSkillSummary}/>
                    <TipRow label="Spec" value={ccm._originSpecSummary}/>
                    <TipRow label="Talents" value={ccm._originTalents}/>
                    <TipRow label="Items" value={ccm._originItems}/>
                    <TipRow label="Mutations" value={ccm._subtleMutationSummary}/>
                </div>
            );
        }

        if (path === '/factions' && ccm.factionId) {
            return (
                <div className="tip-stack">
                    <TipRow label="Characteristics" value={ccm._factionCharBonuses}/>
                    <TipRow label="Skills" value={ccm._factionSkillSummary}/>
                    <TipRow label="Equipment" value={ccm._equipmentPackName || ccm._factionInventory}/>
                </div>
            );
        }

        if (path === '/roles' && ccm.roleId) {
            return (
                <div className="tip-stack">
                    <TipRow label="Skills" value={ccm._roleSkillSummary}/>
                    <TipRow label="Specializations" value={ccm._roleSpecSummary}/>
                    <TipRow label="Equipment" value={ccm._roleEquipment}/>
                </div>
            );
        }

        return null;
    };

    return (
        <nav className="wizard-progress">
            {STEPS.map((step, i) => {
                const active = pathname === step.path;
                const done = isDone(step.path);
                const canNav = active || done || (step.path === '/summary' && ccm.roleId != null);
                const cls = `wizard-step${active ? ' active' : done ? ' done' : ' pending'}`;
                const dot = active ? '●' : done ? '✓' : '○';
                const value = getValue(step.path);
                const tooltip = getTooltip(step.path);

                const inner = (
                    <>
                        <span className="step-dot">{dot}</span>
                        <span className="step-info">
              <span className="step-label">{step.label}</span>
                            {value && <span className="step-value">{value}</span>}
            </span>
                    </>
                );

                return (
                    <span key={step.path} style={{display: 'flex', alignItems: 'center'}}>
            <div className="progress-step-wrap">
              {canNav
                  ? <Link to={step.path} className={cls} style={{textDecoration: 'none'}}>{inner}</Link>
                  : <span className={cls} style={{pointerEvents: 'none'}}>{inner}</span>
              }
                {tooltip && <div className="step-tooltip">{tooltip}</div>}
            </div>
                        {i < STEPS.length - 1 && <span className="step-connector">—</span>}
          </span>
                );
            })}
        </nav>
    );
}