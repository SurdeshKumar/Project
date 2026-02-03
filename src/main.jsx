
// Polyfill window.storage for the app
if (!window.storage) {
    window.storage = {
        get: async (key) => {
            const val = localStorage.getItem(key);
            return val ? { value: val } : null;
        },
        set: async (key, value) => {
            localStorage.setItem(key, value);
        }
    };
}

import React from 'react'
import ReactDOM from 'react-dom/client'
import LegalLensApp from './LegalLensApp.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
    <React.StrictMode>
        <LegalLensApp />
    </React.StrictMode>,
)
