import React from 'react';
import { View, ScrollView, StyleSheet } from 'react-native';
import { Card, Title, Paragraph, Button, useTheme } from 'react-native-paper';
import { useTranslation } from 'react-i18next';
import { LineChart, PieChart } from 'react-native-chart-kit';
import { Dimensions } from 'react-native';

const DashboardScreen = () => {
  const { t } = useTranslation();
  const theme = useTheme();

  const screenWidth = Dimensions.get('window').width;

  const chartConfig = {
    backgroundColor: theme.colors.surface,
    backgroundGradientFrom: theme.colors.surface,
    backgroundGradientTo: theme.colors.surface,
    decimalPlaces: 0,
    color: (opacity = 1) => `rgba(25, 118, 210, ${opacity})`,
    labelColor: (opacity = 1) => `rgba(0, 0, 0, ${opacity})`,
    style: {
      borderRadius: 16,
    },
    propsForDots: {
      r: '6',
      strokeWidth: '2',
      stroke: theme.colors.primary,
    },
  };

  const data = {
    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
    datasets: [
      {
        data: [20, 45, 28, 80, 99, 43],
        color: (opacity = 1) => `rgba(25, 118, 210, ${opacity})`,
        strokeWidth: 2,
      },
    ],
  };

  const pieData = [
    {
      name: 'Paid',
      population: 75,
      color: '#4CAF50',
      legendFontColor: '#7F7F7F',
      legendFontSize: 12,
    },
    {
      name: 'Pending',
      population: 20,
      color: '#FF9800',
      legendFontColor: '#7F7F7F',
      legendFontSize: 12,
    },
    {
      name: 'Overdue',
      population: 5,
      color: '#F44336',
      legendFontColor: '#7F7F7F',
      legendFontSize: 12,
    },
  ];

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Title style={styles.title}>{t('dashboard.title')}</Title>
        <Paragraph style={styles.subtitle}>{t('dashboard.welcome')}</Paragraph>
      </View>

      <View style={styles.statsContainer}>
        <Card style={styles.statCard}>
          <Card.Content>
            <Title>150</Title>
            <Paragraph>{t('dashboard.totalStudents')}</Paragraph>
          </Card.Content>
        </Card>

        <Card style={styles.statCard}>
          <Card.Content>
            <Title>₹45,000</Title>
            <Paragraph>{t('dashboard.totalFees')}</Paragraph>
          </Card.Content>
        </Card>

        <Card style={styles.statCard}>
          <Card.Content>
            <Title>85%</Title>
            <Paragraph>{t('dashboard.paymentRate')}</Paragraph>
          </Card.Content>
        </Card>

        <Card style={styles.statCard}>
          <Card.Content>
            <Title>12</Title>
            <Paragraph>{t('dashboard.pendingPayments')}</Paragraph>
          </Card.Content>
        </Card>
      </View>

      <Card style={styles.chartCard}>
        <Card.Content>
          <Title>{t('dashboard.feeCollection')}</Title>
          <LineChart
            data={data}
            width={screenWidth - 40}
            height={220}
            chartConfig={chartConfig}
            bezier
            style={styles.chart}
          />
        </Card.Content>
      </Card>

      <Card style={styles.chartCard}>
        <Card.Content>
          <Title>{t('dashboard.paymentStatus')}</Title>
          <PieChart
            data={pieData}
            width={screenWidth - 40}
            height={220}
            chartConfig={chartConfig}
            accessor="population"
            backgroundColor="transparent"
            paddingLeft="15"
            absolute
          />
        </Card.Content>
      </Card>

      <View style={styles.actionsContainer}>
        <Button
          mode="contained"
          style={styles.actionButton}
          onPress={() => {}}
        >
          {t('dashboard.addStudent')}
        </Button>
        <Button
          mode="outlined"
          style={styles.actionButton}
          onPress={() => {}}
        >
          {t('dashboard.viewReports')}
        </Button>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    padding: 20,
    backgroundColor: '#fff',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    marginTop: 5,
  },
  statsContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    padding: 10,
  },
  statCard: {
    width: '48%',
    margin: '1%',
  },
  chartCard: {
    margin: 10,
  },
  chart: {
    marginVertical: 8,
    borderRadius: 16,
  },
  actionsContainer: {
    padding: 20,
  },
  actionButton: {
    marginVertical: 5,
  },
});

export default DashboardScreen; 