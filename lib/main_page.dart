import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'financial_provider.dart';
import 'tambah_catatan.dart';

class MainPage extends StatelessWidget {
  void _showDeleteConfirmationDialog(BuildContext context, FinancialProvider provider, String transactionId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Penghapusan'),
          content: Text('Apakah Anda yakin ingin menghapus catatan ini?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Hapus'),
              onPressed: () {
                provider.deleteTransaction(transactionId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Aplikasi Keuangan'),
      ),
      body: SafeArea(
        child: Consumer<FinancialProvider>(
          builder: (context, financialProvider, child) {
            int totalPemasukan = financialProvider.transactions
                .where((t) => t.amount > 0)
                .fold(0, (sum, t) => sum + t.amount.toInt());
            int totalPengeluaran = financialProvider.transactions
                .where((t) => t.amount < 0)
                .fold(0, (sum, t) => sum + t.amount.abs().toInt());

            return Column(
              children: [
                SizedBox(height: 20),
                Text('Total Pemasukkan : Rp$totalPemasukan'),
                SizedBox(height: 20),
                Text('Total Pengeluaran : Rp$totalPengeluaran'),
                SizedBox(height: 20),
                Text('Saldo: Rp${financialProvider.balance.toInt()}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TambahCatatan()),
                    );
                    if (result != null) {
                      financialProvider.addTransaction(Transaction(
                        id: DateTime.now().toString(),
                        description: result['judul'],
                        amount: result['kategori'] == 'Pemasukkan'
                            ? result['jumlah'].toDouble()
                            : -result['jumlah'].toDouble(),
                      ));
                    }
                  },
                  child: Text('Tambah Catatan Finansial'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: financialProvider.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = financialProvider.transactions[index];
                      return ListTile(
                        title: Text(transaction.description),
                        subtitle: Text('Rp${transaction.amount.abs()}'),
                        leading: Text(
                          transaction.amount > 0 ? '💰' : '💸',
                          textScaler: TextScaler.linear(3),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteConfirmationDialog(context, financialProvider, transaction.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}