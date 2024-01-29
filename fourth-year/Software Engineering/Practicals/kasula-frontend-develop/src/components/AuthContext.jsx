import React, { createContext, useState, useContext } from 'react';

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [token, setToken] = useState(localStorage.getItem('token'));

    const logout = () => {
        setToken(null);
        localStorage.removeItem("token");
        localStorage.removeItem("currentUser");
    };

    const isLogged = () => {
        return localStorage.getItem("token") !== null;
    }

    return (
        <AuthContext.Provider value={{ token, setToken, logout, isLogged }}>
            {children}
        </AuthContext.Provider>
    );
}

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (context === undefined) {
        throw new Error('useAuth debe ser usado dentro de un AuthProvider');
    }
    return context;
}