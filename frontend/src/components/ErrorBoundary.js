import React from 'react';
import {logFrontendError} from '../api/api';

export default class ErrorBoundary extends React.Component {
    componentDidCatch(error, info) {
        logFrontendError({
            errorType: 'ReactComponentError',
            message: error.message,
            stackTrace: (error.stack || '') + '\n\nComponent stack:\n' + (info.componentStack || ''),
            url: window.location.href,
        });
    }

    render() {
        return this.props.children;
    }
}
