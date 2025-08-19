import React from 'react';
import { Platform } from 'react-native';

// Platform-specific imports
const WebDemo = Platform.select({
  web: () => require('./SharedComponentsDemo.web').default,
  default: () => require('./SharedComponentsDemo.native').default,
})();

const SharedComponentsDemo: React.FC = () => {
  return <WebDemo />;
};

export default SharedComponentsDemo; 