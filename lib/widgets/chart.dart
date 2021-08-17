import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './chart_bar.dart';
import '../models/transactions.dart';

class Chart extends StatelessWidget {
  final List<Transactions> recentTransactions;

  Chart(this.recentTransactions);


  
  //***************************************************************//
  //************************* Methods *****************************//

  List<Map<String, Object>> get groupedTransactionValues {
    //Here, we generate a list using 7 as length.
    //He get index values from 0 to 6, and we keep on generating and adding to the map type list,
    //until all indices have been traversed for.
    return List.generate(7, (index) {

      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.00;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    //Here we use fold, which assigns an initial value to a variable(sum)
    //and then helps us combine the values of a collection(item)
    //and return that single combined value back.
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }



  //***************************************************************//
  //******************** Widgets Build ****************************//
  //***************************************************************//

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data['day'],
                  data['amount'],
                  totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending),
            );
          }).toList().reversed.toList(),
        ),
      ),
    );
  }
}
