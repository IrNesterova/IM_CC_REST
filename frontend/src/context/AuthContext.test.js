import {act, render, screen, waitFor} from '@testing-library/react';
import {AuthProvider, useAuth} from './AuthContext';
import {getMe, login as apiLogin} from '../api/api';

jest.mock('../api/api', () => ({
    getMe: jest.fn(),
    login: jest.fn(),
    logout: jest.fn(() => Promise.resolve()),
}));

let auth;
function Probe() {
    auth = useAuth();
    return <div data-testid="user">{auth.user ? JSON.stringify(auth.user) : 'none'}</div>;
}

const unauthorized = () => Promise.reject({response: {status: 401}});

describe('AuthProvider', () => {
    beforeEach(() => {
        localStorage.clear();
        getMe.mockReset();
        apiLogin.mockReset();
    });

    it('signs out locally when the cached session has expired', async () => {
        localStorage.setItem('im_cc_user', JSON.stringify({id: 7, email: 'old@example.com'}));
        getMe.mockImplementation(unauthorized);

        render(<AuthProvider><Probe/></AuthProvider>);

        await waitFor(() => expect(screen.getByTestId('user').textContent).toBe('none'));
        expect(localStorage.getItem('im_cc_user')).toBeNull();
    });

    it('keeps the cached user when the server is just unreachable', async () => {
        localStorage.setItem('im_cc_user', JSON.stringify({id: 7, email: 'old@example.com'}));
        getMe.mockImplementation(() => Promise.reject(new Error('Network Error')));

        render(<AuthProvider><Probe/></AuthProvider>);

        await waitFor(() => expect(getMe).toHaveBeenCalled());
        expect(screen.getByTestId('user').textContent).toContain('"id":7');
    });

    it('loads the full profile after login, so the user id is known right away', async () => {
        getMe.mockImplementationOnce(unauthorized)
             .mockImplementationOnce(() => Promise.resolve({id: 42, email: 'gm@example.com', displayName: 'GM'}));
        apiLogin.mockResolvedValue({email: 'gm@example.com'});
        render(<AuthProvider><Probe/></AuthProvider>);
        await waitFor(() => expect(getMe).toHaveBeenCalledTimes(1));

        await act(() => auth.login('gm@example.com', 'secret'));

        expect(auth.user).toEqual({id: 42, email: 'gm@example.com', displayName: 'GM'});
        expect(JSON.parse(localStorage.getItem('im_cc_user')).id).toBe(42);
    });
});
