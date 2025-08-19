import React, { useState } from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { Button, Input, LoginForm } from '../components';

const SharedComponentsDemo: React.FC = () => {
  const [text, setText] = useState('');
  const [loading, setLoading] = useState(false);

  const handleLogin = async (username: string, password: string) => {
    setLoading(true);
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 2000));
    console.log('Login attempt:', { username, password });
    setLoading(false);
  };

  const handleButtonPress = () => {
    console.log('Button pressed!');
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>
        🚀 Shared Components Demo
      </Text>
      <Text style={styles.subtitle}>
        Platform: Mobile (React Native)
      </Text>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Button Components</Text>
        <View style={styles.buttonRow}>
          <Button
            title="Primary Button"
            onPress={handleButtonPress}
            variant="primary"
            size="medium"
          />
          <Button
            title="Secondary"
            onPress={handleButtonPress}
            variant="secondary"
            size="medium"
          />
          <Button
            title="Outline"
            onPress={handleButtonPress}
            variant="outline"
            size="medium"
          />
        </View>
        
        <View style={styles.buttonRow}>
          <Button
            title="Small"
            onPress={handleButtonPress}
            size="small"
          />
          <Button
            title="Large"
            onPress={handleButtonPress}
            size="large"
          />
          <Button
            title="Loading"
            onPress={handleButtonPress}
            loading={true}
          />
        </View>
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Input Components</Text>
        <Input
          label="Text Input"
          value={text}
          onChangeText={setText}
          placeholder="Type something..."
          required
        />
        <Input
          label="Password Input"
          value=""
          onChangeText={() => {}}
          placeholder="Enter password"
          type="password"
          required
        />
        <Input
          label="Email Input"
          value=""
          onChangeText={() => {}}
          placeholder="Enter email"
          type="email"
        />
        <Input
          label="Number Input"
          value=""
          onChangeText={() => {}}
          placeholder="Enter number"
          type="number"
        />
      </View>

      <View style={styles.section}>
        <Text style={styles.sectionTitle}>Login Form Component</Text>
        <LoginForm
          onLogin={handleLogin}
          loading={loading}
          error=""
        />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 20,
    backgroundColor: '#f5f5f5',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    textAlign: 'center',
    marginBottom: 8,
    color: '#333',
  },
  subtitle: {
    fontSize: 16,
    textAlign: 'center',
    marginBottom: 30,
    color: '#666',
  },
  section: {
    marginBottom: 30,
    padding: 20,
    backgroundColor: '#ffffff',
    borderRadius: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: '600',
    marginBottom: 16,
    color: '#333',
  },
  buttonRow: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    marginBottom: 16,
    flexWrap: 'wrap',
    gap: 10,
  },
});

export default SharedComponentsDemo; 