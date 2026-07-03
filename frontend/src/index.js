import React from 'react';
import ReactDOM from 'react-dom/client';
import './styles/theme.css';
import App from './App';
import ErrorBoundary from './components/ErrorBoundary';
import {logFrontendError} from './api/api';

// Global JS errors (syntax errors, thrown strings, etc.)
window.onerror = (message, source, lineno, colno, error) => {
    logFrontendError({
        errorType: 'GlobalError',
        message: String(message),
        stackTrace: error?.stack || `${source}:${lineno}:${colno}`,
        url: window.location.href,
    });
    return false; // don't suppress the default console output
};

// Unhandled promise rejections (failed fetch, async throws, etc.)
window.addEventListener('unhandledrejection', (event) => {
    const reason = event.reason;
    // Skip network errors from logFrontendError itself to avoid infinite loops
    if (reason?.config?.url?.includes('/error-log')) return;
    logFrontendError({
        errorType: 'UnhandledPromiseRejection',
        message: reason?.message || String(reason),
        stackTrace: reason?.stack || null,
        url: window.location.href,
    });
});

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
    <React.StrictMode>
        <ErrorBoundary>
            <App/>
        </ErrorBoundary>
    </React.StrictMode>
);
