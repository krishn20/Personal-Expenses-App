import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import './widgets/chart.dart';
import './widgets/transactions_list.dart';
import './widgets/new_transactions.dart';
import './models/transactions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  //Setting the basic theme using StatelessWidget build, and then creating
  //and calling MyHomePage class for Stateful purposes.

  //***************************************************************//
  //******************** Widgets Build ****************************//
  //***************************************************************//

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses App',
      theme: ThemeData(
        primarySwatch: Colors.red,
        accentColor: Colors.lime,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              bodyText1: TextStyle(
                fontSize: 18,
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyText1: TextStyle(
                  fontSize: 20,
                  fontFamily: 'OpenSans',
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}




//***************************************************************//
//******************* MyHomePage Class **************************//
//***************************************************************//

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transactions> _userTransactions = [
//    Transactions(
//      id: '1',
//      title: 'New Shoes',
//      amount: 69.69,
//      date: DateTime.now(),
//    ),
//    Transactions(
//      id: '2',
//      title: 'Monthly Groceries',
//      amount: 50.50,
//      date: DateTime.now(),
//    ),
  ];

  bool _showChart = false;


  //***************************************************************//
  //***************** Transaction related functions ***************//

  void _showAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            onTap: () {},
            behavior: HitTestBehavior.opaque,
          );
        });
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transactions(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return (tx.id == id);
      });
    });
  }

  List<Transactions> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }



  //***************************************************************//
  //******************** Widgets Build ****************************//
  //***************************************************************//

  @override
  Widget build(BuildContext context) {

    //------------------------------------------------------//
    //setting up the Landscape check variable.
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;


    //------------------------------------------------------//
    //setting up the appbar variable.
    final PreferredSizeWidget appbar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text(
              'Personal Expenses',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => _showAddNewTransaction(context),
                  child: Icon(CupertinoIcons.add),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses App'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _showAddNewTransaction(context),
              )
            ],
          );


    //------------------------------------------------------//
    //setting up the List Item Widget variable.
    final txListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              appbar.preferredSize.height -
              MediaQuery.of(context).padding.top) *
          0.7,
      child: TransactionsList(_userTransactions, deleteTransaction),
    );


    //------------------------------------------------------//
    //setting up the appbody variable.
    final appBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            //CHART
            //if in landscape mode, we will show a switch to alternate between chart and transactions.
            //else, we will show chart and 

            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Show Chart',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Switch.adaptive(
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),

            if (!isLandscape)
              Container(
                height: (MediaQuery.of(context).size.height -
                        appbar.preferredSize.height -
                        MediaQuery.of(context).padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),


            //LIST
            //if not in landscape mode, we show list widget on 70% screen.
            //else, we will show the list depending on the switch value.

            if (!isLandscape) txListWidget,

            if (isLandscape)
              _showChart
                  ? Container(
                      height: (MediaQuery.of(context).size.height -
                              appbar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : txListWidget
          ],
        ),
      ),
    );


    //------------------------------------------------------//
    //Finally, after setting all the widget variable values,
    //we return a Scaffold with it's properties set
    //using these variables.

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appbar,
          )
        : Scaffold(
            appBar: appbar,
            body: appBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _showAddNewTransaction(context),
                  ),
          );
  }
}
