import React, { useState, useEffect } from 'react';
import { useTranslation } from 'react-i18next';
import {
  Box,
  IconButton,
  Menu,
  MenuItem,
  Typography,
  Tooltip,
  Avatar,
  Divider,
  ListItemIcon,
  ListItemText,
  Chip,
  Switch,
  FormControlLabel,
  Paper,
  alpha
} from '@mui/material';
import {
  Language as LanguageIcon,
  Translate as TranslateIcon,
  Settings as SettingsIcon,
  Check as CheckIcon,
  Person as PersonIcon
} from '@mui/icons-material';

const languages = [
  { 
    code: 'en', 
    name: 'English', 
    nativeName: 'English',
    flag: '🇺🇸',
    description: 'Default language'
  },
  { 
    code: 'hi', 
    name: 'Hindi', 
    nativeName: 'हिंदी',
    flag: '🇮🇳',
    description: 'भारत की राष्ट्रीय भाषा'
  },
  { 
    code: 'te', 
    name: 'Telugu', 
    nativeName: 'తెలుగు',
    flag: '🇮🇳',
    description: 'ఆంధ్రప్రదేశ్ భాష'
  },
  { 
    code: 'ta', 
    name: 'Tamil', 
    nativeName: 'தமிழ்',
    flag: '🇮🇳',
    description: 'தமிழ்நாடு மொழி'
  }
];

interface LanguageSwitcherProps {
  userRole?: string;
  userName?: string;
}

const LanguageSwitcher: React.FC<LanguageSwitcherProps> = ({ userRole, userName }) => {
  const { i18n, t } = useTranslation();
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);
  const [showNativeNames, setShowNativeNames] = useState(true);
  const [autoTranslate, setAutoTranslate] = useState(false);

  // Load user preferences from localStorage
  useEffect(() => {
    const savedShowNative = localStorage.getItem('showNativeNames');
    const savedAutoTranslate = localStorage.getItem('autoTranslate');
    
    if (savedShowNative !== null) {
      setShowNativeNames(JSON.parse(savedShowNative));
    }
    if (savedAutoTranslate !== null) {
      setAutoTranslate(JSON.parse(savedAutoTranslate));
    }
  }, []);

  const handleClick = (event: React.MouseEvent<HTMLElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const handleLanguageChange = (languageCode: string) => {
    i18n.changeLanguage(languageCode);
    localStorage.setItem('preferredLanguage', languageCode);
    handleClose();
  };

  const handleShowNativeNamesChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = event.target.checked;
    setShowNativeNames(newValue);
    localStorage.setItem('showNativeNames', JSON.stringify(newValue));
  };

  const handleAutoTranslateChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    const newValue = event.target.checked;
    setAutoTranslate(newValue);
    localStorage.setItem('autoTranslate', JSON.stringify(newValue));
  };

  const currentLanguage = languages.find(lang => lang.code === i18n.language) || languages[0];
  const preferredLanguage = localStorage.getItem('preferredLanguage') || 'en';

  return (
    <Box>
      <Tooltip title={`${t('common.language')}: ${currentLanguage.name}`}>
        <IconButton
          onClick={handleClick}
          sx={{
            color: 'white',
            position: 'relative',
            '&:hover': {
              backgroundColor: 'rgba(255, 255, 255, 0.1)'
            }
          }}
        >
          <LanguageIcon />
          {preferredLanguage !== i18n.language && (
            <Chip
              label="!"
              size="small"
              sx={{
                position: 'absolute',
                top: -5,
                right: -5,
                backgroundColor: '#ff6b35',
                color: 'white',
                fontSize: '0.7rem',
                height: 16,
                minWidth: 16
              }}
            />
          )}
        </IconButton>
      </Tooltip>
      
      <Menu
        anchorEl={anchorEl}
        open={Boolean(anchorEl)}
        onClose={handleClose}
        PaperProps={{
          sx: {
            minWidth: 280,
            mt: 1,
            maxHeight: 400,
            overflow: 'auto'
          }
        }}
        transformOrigin={{ horizontal: 'right', vertical: 'top' }}
        anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
      >
        {/* Header */}
        <Box sx={{ p: 2, borderBottom: 1, borderColor: 'divider' }}>
          <Typography variant="h6" sx={{ fontWeight: 600, mb: 1 }}>
            {t('common.language')} & {t('common.preferences')}
          </Typography>
          {userName && (
            <Typography variant="body2" color="text.secondary">
              {t('common.welcome')}, {userName}
            </Typography>
          )}
        </Box>

        {/* Current Language */}
        <Box sx={{ p: 2, backgroundColor: alpha('#1976d2', 0.05) }}>
          <Typography variant="subtitle2" color="primary" sx={{ mb: 1 }}>
            {t('common.currentLanguage')}
          </Typography>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <Typography variant="h6">{currentLanguage.flag}</Typography>
            <Box>
              <Typography variant="body1" sx={{ fontWeight: 600 }}>
                {showNativeNames ? currentLanguage.nativeName : currentLanguage.name}
              </Typography>
              {showNativeNames && currentLanguage.nativeName !== currentLanguage.name && (
                <Typography variant="caption" color="text.secondary">
                  {currentLanguage.name}
                </Typography>
              )}
            </Box>
            <CheckIcon color="primary" sx={{ ml: 'auto' }} />
          </Box>
        </Box>

        <Divider />

        {/* Language Options */}
        <Box sx={{ p: 1 }}>
          <Typography variant="subtitle2" sx={{ px: 2, py: 1, fontWeight: 600 }}>
            {t('common.selectLanguage')}
          </Typography>
          {languages.map((language) => (
            <MenuItem
              key={language.code}
              onClick={() => handleLanguageChange(language.code)}
              selected={i18n.language === language.code}
              sx={{
                borderRadius: 1,
                mx: 1,
                mb: 0.5,
                '&:hover': {
                  backgroundColor: alpha('#1976d2', 0.08)
                },
                '&.Mui-selected': {
                  backgroundColor: alpha('#1976d2', 0.12),
                  '&:hover': {
                    backgroundColor: alpha('#1976d2', 0.16)
                  }
                }
              }}
            >
              <ListItemIcon>
                <Typography variant="h6" sx={{ fontSize: '1.2rem' }}>
                  {language.flag}
                </Typography>
              </ListItemIcon>
              <ListItemText
                primary={
                  <Typography variant="body1" sx={{ fontWeight: i18n.language === language.code ? 600 : 400 }}>
                    {showNativeNames ? language.nativeName : language.name}
                  </Typography>
                }
                secondary={
                  <Typography variant="caption" color="text.secondary">
                    {language.description}
                  </Typography>
                }
              />
              {i18n.language === language.code && (
                <CheckIcon color="primary" />
              )}
            </MenuItem>
          ))}
        </Box>

        <Divider />

        {/* Preferences */}
        <Box sx={{ p: 2 }}>
          <Typography variant="subtitle2" sx={{ mb: 2, fontWeight: 600 }}>
            {t('common.preferences')}
          </Typography>
          
          <FormControlLabel
            control={
              <Switch
                checked={showNativeNames}
                onChange={handleShowNativeNamesChange}
                size="small"
              />
            }
            label={
              <Box>
                <Typography variant="body2">
                  {t('common.showNativeNames')}
                </Typography>
                <Typography variant="caption" color="text.secondary">
                  {t('common.showNativeNamesDesc')}
                </Typography>
              </Box>
            }
            sx={{ mb: 1 }}
          />

          <FormControlLabel
            control={
              <Switch
                checked={autoTranslate}
                onChange={handleAutoTranslateChange}
                size="small"
              />
            }
            label={
              <Box>
                <Typography variant="body2">
                  {t('common.autoTranslate')}
                </Typography>
                <Typography variant="caption" color="text.secondary">
                  {t('common.autoTranslateDesc')}
                </Typography>
              </Box>
            }
          />
        </Box>

        {/* Footer */}
        <Box sx={{ p: 2, borderTop: 1, borderColor: 'divider', backgroundColor: alpha('#f5f5f5', 0.5) }}>
          <Typography variant="caption" color="text.secondary" align="center" display="block">
            {t('common.languageNote')}
          </Typography>
        </Box>
      </Menu>
    </Box>
  );
};

export default LanguageSwitcher; 