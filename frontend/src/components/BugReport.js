import {useState} from 'react';
import {submitBugReport} from '../api/api';

export default function BugReport() {
    const [open, setOpen] = useState(false);
    const [description, setDescription] = useState('');
    const [sent, setSent] = useState(false);

    const submit = async () => {
        if (!description.trim()) return;
        try {
            await submitBugReport({
                description,
                pageUrl: window.location.href,
            });
            setSent(true);
            setDescription('');
            setTimeout(() => {
                setSent(false);
                setOpen(false);
            }, 2000);
        } catch {
        }
    };

    return (
        <div className="bug-report-float">
            <button
                onClick={() => setOpen(o => !o)}
                style={{
                    position: 'fixed', bottom: '20px', right: '20px', zIndex: 1000,
                    background: 'var(--red)', color: 'var(--on-accent)',
                    border: '1px solid var(--red)',
                    fontFamily: "'Barlow', sans-serif", fontSize: '10px',
                    letterSpacing: '2px', textTransform: 'uppercase',
                    padding: '8px 14px', cursor: 'pointer',
                }}
            >
                Bug
            </button>

            {open && (
                <div style={{
                    position: 'fixed', bottom: '60px', right: '20px', zIndex: 1000,
                    background: 'var(--panel)', border: '1px solid var(--border)',
                    padding: '20px', width: '300px',
                    boxShadow: '0 4px 20px var(--shadow)',
                }}>
                    <div style={{
                        fontFamily: "'Barlow', sans-serif",
                        fontSize: '11px',
                        letterSpacing: '3px',
                        textTransform: 'uppercase',
                        marginBottom: '12px',
                        color: 'var(--ink)'
                    }}>
                        Report a Bug
                    </div>
                    {sent ? (
                        <div style={{color: 'var(--red)', fontStyle: 'italic'}}>Sent! Thank you.</div>
                    ) : (
                        <>
              <textarea
                  value={description}
                  onChange={e => setDescription(e.target.value)}
                  placeholder="Describe the issue..."
                  style={{width: '100%', minHeight: '80px', marginBottom: '10px'}}
              />
                            <button onClick={submit} className="btn-primary" style={{width: '100%'}}>
                                Submit
                            </button>
                        </>
                    )}
                </div>
            )}
        </div>
    );
}
