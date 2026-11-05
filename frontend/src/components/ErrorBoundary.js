import React from 'react';
import {logFrontendError} from '../api/api';

// Sits outside the router, so it uses plain links and a full page reload.
export default class ErrorBoundary extends React.Component {
    state = {hasError: false};

    static getDerivedStateFromError() {
        return {hasError: true};
    }

    componentDidCatch(error, info) {
        logFrontendError({
            errorType: 'ReactComponentError',
            message: error.message,
            stackTrace: (error.stack || '') + '\n\nComponent stack:\n' + (info.componentStack || ''),
            url: window.location.href,
        });
    }

    render() {
        if (!this.state.hasError) return this.props.children;

        return (
            <main role="alert" style={{
                minHeight: '100vh', background: 'var(--bg)', color: 'var(--ink)', padding: '24px',
                display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
                gap: '20px', textAlign: 'center', fontFamily: "'Barlow', sans-serif",
            }}>
                <div style={{fontSize: '24px', color: 'var(--red)'}}>Something went wrong</div>
                <div style={{fontSize: '15px'}}>
                    The page crashed. Your wizard progress is stored in this browser.
                </div>
                <div style={{display: 'flex', gap: '12px', flexWrap: 'wrap', justifyContent: 'center'}}>
                    <button type="button" className="action-btn" onClick={() => window.location.reload()}>
                        Reload page
                    </button>
                    <a href="/" className="action-btn secondary" style={{textDecoration: 'none'}}>
                        Go to home page
                    </a>
                </div>
            </main>
        );
    }
}
