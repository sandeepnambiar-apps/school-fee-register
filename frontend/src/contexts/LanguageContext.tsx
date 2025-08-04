import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { useTranslation } from 'react-i18next';

interface LanguagePreferences {
  showNativeNames: boolean;
  autoTranslate: boolean;
  preferredLanguage: string;
}

interface LanguageContextType {
  preferences: LanguagePreferences;
  updatePreferences: (newPreferences: Partial<LanguagePreferences>) => void;
  resetPreferences: () => void;
}

const defaultPreferences: LanguagePreferences = {
  showNativeNames: true,
  autoTranslate: false,
  preferredLanguage: 'en'
};

const LanguageContext = createContext<LanguageContextType | undefined>(undefined);

export const useLanguage = () => {
  const context = useContext(LanguageContext);
  if (context === undefined) {
    throw new Error('useLanguage must be used within a LanguageProvider');
  }
  return context;
};

interface LanguageProviderProps {
  children: ReactNode;
}

export const LanguageProvider: React.FC<LanguageProviderProps> = ({ children }) => {
  const { i18n } = useTranslation();
  const [preferences, setPreferences] = useState<LanguagePreferences>(defaultPreferences);

  // Load preferences from localStorage on mount
  useEffect(() => {
    const savedPreferences = localStorage.getItem('languagePreferences');
    if (savedPreferences) {
      try {
        const parsed = JSON.parse(savedPreferences);
        setPreferences(prev => ({ ...prev, ...parsed }));
        
        // Apply saved language if different from current
        if (parsed.preferredLanguage && parsed.preferredLanguage !== i18n.language) {
          i18n.changeLanguage(parsed.preferredLanguage);
        }
      } catch (error) {
        console.error('Error loading language preferences:', error);
      }
    }
  }, [i18n]);

  // Save preferences to localStorage whenever they change
  useEffect(() => {
    localStorage.setItem('languagePreferences', JSON.stringify(preferences));
  }, [preferences]);

  const updatePreferences = (newPreferences: Partial<LanguagePreferences>) => {
    setPreferences(prev => ({ ...prev, ...newPreferences }));
    
    // If language changed, update i18n
    if (newPreferences.preferredLanguage && newPreferences.preferredLanguage !== i18n.language) {
      i18n.changeLanguage(newPreferences.preferredLanguage);
    }
  };

  const resetPreferences = () => {
    setPreferences(defaultPreferences);
    i18n.changeLanguage(defaultPreferences.preferredLanguage);
    localStorage.removeItem('languagePreferences');
  };

  const value: LanguageContextType = {
    preferences,
    updatePreferences,
    resetPreferences
  };

  return (
    <LanguageContext.Provider value={value}>
      {children}
    </LanguageContext.Provider>
  );
}; 