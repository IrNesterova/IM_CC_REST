// Full-page message for when the data a page depends on could not be loaded.
export default function LoadError({message}) {
    return (
        <main role="alert" style={{
            flex: 1, minHeight: '60vh', background: 'var(--bg)', padding: '24px',
            display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', gap: '20px',
        }}>
            <div style={{
                fontFamily: "'Barlow', sans-serif", fontSize: '15px',
                color: 'var(--ink)', textAlign: 'center',
            }}>
                {message}
            </div>
            <button
                type="button"
                className="action-btn"
                onClick={() => window.location.reload()}
            >
                Try again
            </button>
        </main>
    );
}
