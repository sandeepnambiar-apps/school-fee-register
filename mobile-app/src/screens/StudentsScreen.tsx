import React, { useState } from 'react';
import { View, ScrollView, StyleSheet, FlatList } from 'react-native';
import { Card, Title, Paragraph, Button, FAB, Searchbar, useTheme } from 'react-native-paper';
import { useTranslation } from 'react-i18next';

const StudentsScreen = () => {
  const { t } = useTranslation();
  const theme = useTheme();
  const [searchQuery, setSearchQuery] = useState('');

  const students = [
    {
      id: 1,
      name: 'Rahul Kumar',
      grade: 'Class 10',
      parentPhone: '+91 9876543210',
      totalFees: 15000,
      paidFees: 12000,
      status: 'Partial',
    },
    {
      id: 2,
      name: 'Priya Sharma',
      grade: 'Class 9',
      parentPhone: '+91 9876543211',
      totalFees: 12000,
      paidFees: 12000,
      status: 'Paid',
    },
    {
      id: 3,
      name: 'Amit Patel',
      grade: 'Class 8',
      parentPhone: '+91 9876543212',
      totalFees: 10000,
      paidFees: 5000,
      status: 'Pending',
    },
  ];

  const renderStudentCard = ({ item }) => (
    <Card style={styles.studentCard}>
      <Card.Content>
        <Title>{item.name}</Title>
        <Paragraph>{item.grade}</Paragraph>
        <Paragraph>Parent: {item.parentPhone}</Paragraph>
        <View style={styles.feeInfo}>
          <Paragraph>Total: ₹{item.totalFees}</Paragraph>
          <Paragraph>Paid: ₹{item.paidFees}</Paragraph>
          <Paragraph style={[
            styles.status,
            { color: item.status === 'Paid' ? '#4CAF50' : item.status === 'Partial' ? '#FF9800' : '#F44336' }
          ]}>
            {item.status}
          </Paragraph>
        </View>
      </Card.Content>
      <Card.Actions>
        <Button onPress={() => {}}>{t('common.viewDetails')}</Button>
        <Button onPress={() => {}}>{t('common.edit')}</Button>
      </Card.Actions>
    </Card>
  );

  return (
    <View style={styles.container}>
      <Searchbar
        placeholder={t('students.searchStudents')}
        onChangeText={setSearchQuery}
        value={searchQuery}
        style={styles.searchbar}
      />
      
      <FlatList
        data={students}
        renderItem={renderStudentCard}
        keyExtractor={(item) => item.id.toString()}
        style={styles.list}
        contentContainerStyle={styles.listContent}
      />
      
      <FAB
        style={styles.fab}
        icon="plus"
        onPress={() => {}}
        label={t('students.addStudent')}
      />
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  searchbar: {
    margin: 10,
  },
  list: {
    flex: 1,
  },
  listContent: {
    padding: 10,
  },
  studentCard: {
    marginBottom: 10,
  },
  feeInfo: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginTop: 10,
  },
  status: {
    fontWeight: 'bold',
  },
  fab: {
    position: 'absolute',
    margin: 16,
    right: 0,
    bottom: 0,
  },
});

export default StudentsScreen; 