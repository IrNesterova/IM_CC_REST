import {render, screen} from '@testing-library/react';
import OriginsPage from './OriginsPage';
import {getOrigins, reportError} from '../api/api';

jest.mock('../api/api', () => ({
    getOrigins: jest.fn(),
    getAugmetics: jest.fn(() => Promise.resolve([])),
    getSubtleMutationsTable: jest.fn(() => Promise.resolve([])),
    reportError: jest.fn(),
}));
jest.mock('react-router-dom', () => ({useNavigate: () => jest.fn()}), {virtual: true});
jest.mock('../context/CharacterContext', () => ({
    useCharacter: () => ({ccm: {characteristics: {}}, dispatch: jest.fn(), allowedSourceBooks: null}),
}));
jest.mock('../components/Topbar', () => () => null);
jest.mock('../components/ProgressBar', () => () => null);

describe('OriginsPage', () => {
    it('shows an error with a retry button when origins fail to load', async () => {
        const failure = new Error('network down');
        getOrigins.mockRejectedValue(failure);

        render(<OriginsPage/>);

        const alert = await screen.findByRole('alert');
        expect(alert.textContent).toContain('Could not load origins.');
        expect(screen.getByRole('button', {name: 'Try again'})).toBeTruthy();
        expect(reportError).toHaveBeenCalledWith(failure);
    });
});
