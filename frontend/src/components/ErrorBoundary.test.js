import {render, screen} from '@testing-library/react';
import ErrorBoundary from './ErrorBoundary';
import {logFrontendError} from '../api/api';

jest.mock('../api/api', () => ({logFrontendError: jest.fn()}));

function Crash() {
    throw new Error('render failed');
}

describe('ErrorBoundary', () => {
    beforeEach(() => {
        logFrontendError.mockClear();
        jest.spyOn(console, 'error').mockImplementation(() => {});
    });

    afterEach(() => jest.restoreAllMocks());

    it('renders children when nothing fails', () => {
        render(<ErrorBoundary><div>content</div></ErrorBoundary>);

        expect(screen.getByText('content')).toBeTruthy();
        expect(screen.queryByRole('alert')).toBeNull();
    });

    it('shows a fallback and logs the error when a child crashes', () => {
        render(<ErrorBoundary><Crash/></ErrorBoundary>);

        expect(screen.getByRole('alert').textContent).toContain('Something went wrong');
        expect(screen.getByRole('button', {name: 'Reload page'})).toBeTruthy();
        expect(screen.getByRole('link', {name: 'Go to home page'}).getAttribute('href')).toBe('/');
        expect(logFrontendError).toHaveBeenCalledWith(
            expect.objectContaining({errorType: 'ReactComponentError', message: 'render failed'})
        );
    });
});
