import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const EquationSolverPage(),
    );
  }
}

class EquationSolverPage extends StatefulWidget {
  const EquationSolverPage({super.key});

  @override
  _EquationSolverPageState createState() => _EquationSolverPageState();
}

class _EquationSolverPageState extends State<EquationSolverPage> {
  // Змінні, що містимуть рівняння введене користувачем
  String equation1 = '';
  String equation2 = '';
  double h = 0.0;

  //
  String resultsText = '';

  // Масиви з даними преведених до тих, що можна використовувати для будування графіку.
  final List<ChartData> chartDataY1 = [];
  final List<ChartData> chartDataY2 = [];
  final List<ChartData> chartDataY3 = [];
  final List<ChartData> chartDataY4 = [];
  final List<ChartData> chartDataY5 = [];

  // Оброблені дані (Обробка нескінченних значень)
  List<ChartData> processedDataY1 = [];
  List<ChartData> processedDataY2 = [];
  List<ChartData> processedDataY3 = [];
  List<ChartData> processedDataY4 = [];
  List<ChartData> processedDataY5 = [];

  // Флаг для відображення таблиці
  bool showTable = false;

  // Змінні з результатами
  List<double> resultY1 = [];
  List<double> resultY2 = [];
  List<double> resultAnalitic = [];
  List<double> resultAbsE = [];
  List<double> resultAbsE4 = [];
  List<String> xValuesTable = [];

  //Функція для підрахунку методом Рунге-Кутта 4 порядку
  void rungeKutta4orders(String expression1, String expression2, double step) {
    // Відрізок на якому проводяться розрахунки
    double x0 = 20;
    double xn = 70;

    double y1 = 1;
    double y2 = 1;
    double k1, k2, k3, k4, l1, l2, l3, l4;

    // Кількість точок
    int n = ((xn - x0) / step).round();

    // Массив із значеннями X (Потрібно для відображення графіку)
    List<double> xValues = [];

    // Створення парсера для зчитування введеного користувачем рівняння
    Parser parser1 = Parser();
    Parser parser2 = Parser();

    // Розпарсування введення користувача в вираз
    Expression exp1 = parser1.parse(expression1);
    Expression exp2 = parser2.parse(expression2);

    // Створення функції f1 з використанням розпарсеного виразу
    double f1(double x, double y, double z) {
      ContextModel contextModel = ContextModel();
      contextModel.bindVariable(Variable('x'), Number(x));
      contextModel.bindVariable(Variable('y'), Number(y));
      contextModel.bindVariable(Variable('z'), Number(z));
      return exp1.evaluate(EvaluationType.REAL, contextModel);
    }

    // Створення функції f2 з використанням розпарcеного виразу
    double f2(double x, double y, double z) {
      ContextModel contextModel = ContextModel();
      contextModel.bindVariable(Variable('x'), Number(x));
      contextModel.bindVariable(Variable('y'), Number(y));
      contextModel.bindVariable(Variable('z'), Number(z));
      return exp2.evaluate(EvaluationType.REAL, contextModel);
    }

    for (int i = 0; i <= n; i++) {
      // k1 = f1(x0, y1, y2);
      // l1 = f2(x0, y1, y2);
      //
      // k2 = f1(0 + step/3, y1 + step/3*l1,  y2 + step/3*k1);
      // l2 = f2(x0 + step/3, y1 + step/3*l1, y2 + step/3*k1);
      //
      // k3 = f1(x0 + 2/3*step, y1 - step/3*l1 +step*l2, y2 - step/3*k1 +step*k2);
      // l3 = f2(x0 + 2/3*step, y1 - step/3*l1 +step*l2, y2 - step/3*k1 +step*k2);
      //
      // k4 = f1(x0 + step, y1 + step*l1 - step*l2 +step*l3, y2 + step*k1 - step*k2 +step*k3);
      // l4 = f2(x0 + step, y1 + step*l1 - step*l2 +step*l3, y2 + step*k1 - step*k2 +step*k3);
      //
      // double yn1 = y1 + step*(l1 + 3 * l2 + 3 * l3 + l4) / 8;
      // double yn2 = y2 + step*(k1 + 3 * k2 + 3 * k3 + k4) / 8;

      k1 = step * f1(x0, y1, y2);
      l1 = step * f2(x0, y1, y2);

      k2 = step * f1(x0 + step / 2, y1 + l1 / 2, y2 + k1 / 2);
      l2 = step * f2(x0 + step / 2, y1 + l1 / 2, y2 + k1 / 2);

      k3 = step * f1(x0 + step / 2, y1 + l2 / 2, y2 + k2 / 2);
      l3 = step * f2(x0 + step / 2, y1 + l2 / 2, y2 + k2 / 2);

      k4 = step * f1(x0 + step, y1 + l3, y2 + k3);
      l4 = step * f2(x0 + step, y1 + l3, y2 + k3);

      double yn1 = y1 + (l1 + 2 * l2 + 2 * l3 + l4) / 6;
      double yn2 = y2 + (k1 + 2 * k2 + 2 * k3 + k4) / 6;

      resultY1.add(y1);
      resultY2.add(y2);

      print('Аналитическое y(x):${(1 + x0)}');
      resultAnalitic.add((1 + x0));
      resultAbsE.add(((1 + x0) - y2).abs());
      resultAbsE4.add(((1 + x0) - y2).abs() / pow(step, 4));
      // Додавання до массиву округлених значень Х згідно математичних законів
      xValuesTable.add(x0.toStringAsPrecision(2));
      xValues.add(x0);

      x0 = x0 + step;

      y2 = yn2;
      y1 = yn1;
    }

    for (int i = 0; i < resultY1.length; i++) {
      chartDataY1.add(ChartData(xValues[i], resultY1[i]));
      chartDataY2.add(ChartData(xValues[i], resultY2[i]));
      chartDataY3.add(ChartData(xValues[i], resultAnalitic[i]));
      chartDataY4.add(ChartData(xValues[i], resultAbsE[i]));
      chartDataY5.add(ChartData(xValues[i], resultAbsE4[i]));
    }

    // Обробка даних для графіку
    for (int i = 0; i < chartDataY1.length; i++) {
      ChartData dataY1 = chartDataY1[i];
      ChartData dataY2 = chartDataY2[i];
      ChartData dataY3 = chartDataY3[i];
      ChartData dataY4 = chartDataY4[i];
      ChartData dataY5 = chartDataY5[i];

      if (dataY1.y! < 100 || dataY2.y! < 100) {
        processedDataY1.add(dataY1);
        processedDataY2.add(dataY2);
        processedDataY3.add(dataY3);
        processedDataY4.add(dataY4);
        processedDataY5.add(dataY5);
      } else {
        // Тобто якщо значення функції дуже велике, ми замінюємо його на 100
        double infinityValue = 100;
        processedDataY1.add(ChartData(dataY1.x, infinityValue));
        processedDataY2.add(ChartData(dataY2.x, infinityValue));
        processedDataY3.add(ChartData(dataY3.x, infinityValue));
        processedDataY4.add(ChartData(dataY4.x, infinityValue));
        processedDataY5.add(ChartData(dataY5.x, infinityValue));
      }
    }

    // Зміна стану флага
    setState(() {
      showTable = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equation Solver'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Equation 1',
                          ),
                          onChanged: (value) {
                            setState(() {
                              equation1 = value;
                            });
                          },
                        ),
                        TextField(
                          decoration: const InputDecoration(
                            labelText: 'Equation 2',
                          ),
                          onChanged: (value) {
                            setState(() {
                              equation2 = value;
                            });
                          },
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () =>
                              rungeKutta4orders(equation1, equation2, h),
                          child: const Text('Solve Equations'),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: SfCartesianChart(
                                  legend: Legend(isVisible: true),
                                  primaryXAxis: NumericAxis(crossesAt: 0),
                                  primaryYAxis: NumericAxis(
                                    crossesAt: 0,
                                    edgeLabelPlacement: EdgeLabelPlacement.none,
                                  ),
                                  series: <ChartSeries>[
                                    SplineSeries<ChartData, double>(
                                        name: 'y\'(x)',
                                        color: Colors.red,
                                        dataSource: processedDataY1,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                    SplineSeries<ChartData, double>(
                                        name: 'y(x)',
                                        color: Colors.blue,
                                        dataSource: processedDataY2,
                                        xValueMapper: (ChartData data, _) =>
                                            data.x,
                                        yValueMapper: (ChartData data, _) =>
                                            data.y),
                                  ]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        if (showTable)
                          buildTable(
                              xValuesTable, resultY1, resultY2, resultAnalitic),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: SizedBox(
                          width: 60,
                          child: TextField(
                            decoration: const InputDecoration(
                              labelText: 'Step:',
                            ),
                            onChanged: (value) {
                              setState(() {
                                h = double.parse(value);
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      SizedBox(
                        width: 450,
                        child: SfCartesianChart(
                            legend: Legend(isVisible: true),
                            primaryXAxis: NumericAxis(crossesAt: 0),
                            primaryYAxis: NumericAxis(
                              crossesAt: 0,
                              edgeLabelPlacement: EdgeLabelPlacement.none,
                            ),
                            series: <ChartSeries>[
                              SplineSeries<ChartData, double>(
                                  name: 'y(x)',
                                  color: Colors.blue,
                                  dataSource: processedDataY2,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y),
                              SplineSeries<ChartData, double>(
                                  name: 'Analytical y(x)',
                                  color: Colors.green,
                                  dataSource: processedDataY3,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y)
                            ]),
                      ),
                      SizedBox(
                        width: 450,
                        child: SfCartesianChart(
                            legend: Legend(isVisible: true),
                            primaryXAxis: NumericAxis(crossesAt: 0),
                            primaryYAxis: NumericAxis(
                              crossesAt: 0,
                              edgeLabelPlacement: EdgeLabelPlacement.none,
                            ),
                            series: <ChartSeries>[
                              SplineSeries<ChartData, double>(
                                  name: 'Absolute error',
                                  color: Colors.redAccent,
                                  dataSource: processedDataY4,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y),
                            ]),
                      ),
                      SizedBox(
                        width: 450,
                        child: SfCartesianChart(
                            legend: Legend(isVisible: true),
                            primaryXAxis: NumericAxis(crossesAt: 0),
                            primaryYAxis: NumericAxis(
                              crossesAt: 0,
                              edgeLabelPlacement: EdgeLabelPlacement.none,
                            ),
                            series: <ChartSeries>[
                              SplineSeries<ChartData, double>(
                                  name: 'E/h4',
                                  color: Colors.teal,
                                  dataSource: processedDataY5,
                                  xValueMapper: (ChartData data, _) => data.x,
                                  yValueMapper: (ChartData data, _) => data.y),
                            ]),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final double x;
  final double? y;
}

List<DataRow> buildTableRows(List<String> steps, List<double> resultY1,
    List<double> resultY2, List<double> resultAnalitic) {
  List<DataRow> rows = [];

  for (int i = 0; i < resultY1.length; i++) {
    DataRow row = DataRow(
      cells: [
        DataCell(Text(steps[i])),
        DataCell(Text(resultY1[i].toString())),
        DataCell(Text(resultY2[i].toString())),
        DataCell(Text(resultAnalitic[i].toString())),
      ],
    );
    rows.add(row);
  }

  return rows;
}

Widget buildTable(
  List<String> steps,
  List<double> resultY1,
  List<double> resultY2,
  List<double> resultAnalitic,
) {
  List<DataRow> rows =
      buildTableRows(steps, resultY1, resultY2, resultAnalitic);

  return DataTable(
    columns: const [
      DataColumn(label: Text("X")),
      DataColumn(label: Text("Y'(x)")),
      DataColumn(label: Text("Y(x)")),
      DataColumn(label: Text("Точне Y(x)")),
    ],
    rows: rows,
  );
}
