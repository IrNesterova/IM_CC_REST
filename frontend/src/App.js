import {BrowserRouter, Routes, Route, Navigate} from 'react-router-dom';
import {CharacterProvider, useCharacter} from './context/CharacterContext';
import BugReport from './components/BugReport';
import ProtectedRoute from './components/ProtectedRoute';
import {AuthProvider} from './context/AuthContext';

import IndexPage from './pages/IndexPage';
import CharacteristicsPage from './pages/CharacteristicsPage';
import OriginsPage from './pages/OriginsPage';
import FactionsPage from './pages/FactionsPage';
import RolesPage from './pages/RolesPage';
import DetailsPage from './pages/DetailsPage';
import SummaryPage from './pages/SummaryPage';
import CabinetPage from './pages/CabinetPage';
import RoomPage from './pages/RoomPage';
import LoginPage from './pages/LoginPage';
import RegisterPage from './pages/RegisterPage';
import PatronPage from './pages/PatronPage';

// Opening a saved character while the sheet is already shown must rebuild it from scratch.
function EditableSummary() {
    const {ccm} = useCharacter();
    return <SummaryPage key={ccm._loadedAt || 'current'}/>;
}

export default function App() {
    return (
        <BrowserRouter>
            <AuthProvider>
            <CharacterProvider>
                <div style={{minHeight: '100vh', display: 'flex', flexDirection: 'column'}}>
                    <Routes>
                        <Route path="/" element={<IndexPage/>}/>
                        <Route path="/characteristics" element={<CharacteristicsPage/>}/>
                        <Route path="/origins" element={<OriginsPage/>}/>
                        <Route path="/factions" element={<FactionsPage/>}/>
                        <Route path="/roles" element={<RolesPage/>}/>
                        <Route path="/details" element={<DetailsPage/>}/>
                        <Route path="/summary" element={<EditableSummary/>}/>
                        <Route path="/character/:code" element={<SummaryPage/>}/>
                        {/* новые маршруты кабинета */}
                        <Route path="/login" element={<LoginPage/>}/>
                        <Route path="/register" element={<RegisterPage/>}/>
                        <Route path="/cabinet" element={
                            <ProtectedRoute><CabinetPage/></ProtectedRoute>
                        }/>
                        <Route path="/lobby" element={<Navigate to="/cabinet" state={{tab: 'rooms'}}/>}/>
                        <Route path="/room/:roomId" element={
                            <ProtectedRoute><RoomPage/></ProtectedRoute>
                        }/>

                        <Route path="/patron" element={<PatronPage/>}/>
                        <Route path="*" element={<Navigate to="/"/>}/>
                    </Routes>
                    <BugReport/>
                </div>
            </CharacterProvider>
            </AuthProvider>
        </BrowserRouter>
    );
}
