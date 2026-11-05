// Dismissible message for a failed action, such as a save. Renders nothing without a message.
export default function ErrorToast({message, onClose}) {
    if (!message) return null;

    return (
        <div role="alert" style={{
            position: 'fixed', bottom: '20px', left: '50%', transform: 'translateX(-50%)',
            zIndex: 1100, width: 'max-content', maxWidth: 'calc(100vw - 32px)',
            display: 'flex', alignItems: 'center', gap: '14px', padding: '12px 16px',
            background: 'var(--panel)', color: 'var(--ink)',
            border: '1px solid var(--red)', boxShadow: '0 4px 28px var(--shadow)',
            fontFamily: "'Barlow', sans-serif", fontSize: '14px',
        }}>
            <span>{message}</span>
            <button
                type="button"
                aria-label="Dismiss"
                onClick={onClose}
                style={{
                    background: 'none', border: 'none', cursor: 'pointer',
                    color: 'var(--muted)', fontSize: '18px', lineHeight: 1, padding: 0,
                }}
            >
                ×
            </button>
        </div>
    );
}
