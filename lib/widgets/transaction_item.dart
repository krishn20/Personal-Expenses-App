import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transactions.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required this.deleteTx,
  }) : super(key: key);

  final Transactions transaction;
  final Function deleteTx;



  //***************************************************************//
  //******************** Widgets Build ****************************//
  //***************************************************************//

  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: FittedBox(
              child: Text('₹ ${transaction.amount}'),
            ),
          ),
        ),

        title: Text(
          transaction.title,
          style: Theme.of(context).textTheme.title,
        ),

        subtitle: Text(
          DateFormat.yMMMd().format(transaction.date),
        ),
        
        trailing: MediaQuery.of(context).size.width > 420
            ? FlatButton.icon(
          onPressed: () => deleteTx(transaction.id),
          icon: Icon(Icons.delete_outline),
          label: Text('Delete'),
          textColor: Theme.of(context).errorColor,
        )
            : IconButton(
          icon: Icon(Icons.delete_outline),
          color: Theme.of(context).errorColor,
          onPressed: () => deleteTx(transaction.id),
        ),
      ),
    );
  }
}
