import {BrowserRouter, Routes, Route, Navigate} from 'react-router-dom';
import {CharacterProvider} from './context/CharacterContext';
import BugReport from './components/BugReport';

import IndexPage from './pages/IndexPage';
import CharacteristicsPage from './pages/CharacteristicsPage';
import OriginsPage from './pages/OriginsPage';
import FactionsPage from './pages/FactionsPage';
import RolesPage from './pages/RolesPage';
import DetailsPage from './pages/DetailsPage';
import SummaryPage from './pages/SummaryPage';

export default function App() {
    return (
        <BrowserRouter>
            <CharacterProvider>
                <div style={{minHeight: '100vh', display: 'flex', flexDirection: 'column'}}>
                    <Routes>
                        <Route path="/" element={<IndexPage/>}/>
                        <Route path="/characteristics" element={<CharacteristicsPage/>}/>
                        <Route path="/origins" element={<OriginsPage/>}/>
                        <Route path="/factions" element={<FactionsPage/>}/>
                        <Route path="/roles" element={<RolesPage/>}/>
                        <Route path="/details" element={<DetailsPage/>}/>
                        <Route path="/summary" element={<SummaryPage/>}/>
                        <Route path="*" element={<Navigate to="/"/>}/>
                    </Routes>
                    <BugReport/>
                </div>
            </CharacterProvider>
        </BrowserRouter>
    );
}
