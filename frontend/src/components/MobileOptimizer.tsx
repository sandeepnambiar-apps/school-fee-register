import React, { useEffect } from 'react';
import { useTheme, useMediaQuery } from '@mui/material';

interface MobileOptimizerProps {
  children: React.ReactNode;
}

const MobileOptimizer: React.FC<MobileOptimizerProps> = ({ children }) => {
  const theme = useTheme();
  const isMobile = useMediaQuery(theme.breakpoints.down('md'));

  useEffect(() => {
    // Prevent zoom on input focus for mobile
    const preventZoom = (e: TouchEvent) => {
      if (e.touches.length > 1) {
        e.preventDefault();
      }
    };

    // Prevent double tap zoom
    let lastTouchEnd = 0;
    const preventDoubleTapZoom = (e: TouchEvent) => {
      const now = new Date().getTime();
      if (now - lastTouchEnd <= 300) {
        e.preventDefault();
      }
      lastTouchEnd = now;
    };

    if (isMobile) {
      document.addEventListener('touchstart', preventZoom, { passive: false });
      document.addEventListener('touchend', preventDoubleTapZoom, { passive: false });
    }

    return () => {
      if (isMobile) {
        document.removeEventListener('touchstart', preventZoom);
        document.removeEventListener('touchend', preventDoubleTapZoom);
      }
    };
  }, [isMobile]);

  return <>{children}</>;
};

export default MobileOptimizer; 