import 'package:flutter/material.dart';

class TambahCatatan extends StatefulWidget {
  const TambahCatatan({Key? key}) : super(key: key);

  @override
  _TambahCatatanState createState() => _TambahCatatanState();
}

class _TambahCatatanState extends State<TambahCatatan> {
  String? _selectedCategory;
  List<String> _categories = ['Pemasukkan', 'Pengeluaran'];
  
  final _judulController = TextEditingController();
  final _jumlahController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan Finansial'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextField(
                controller: _judulController,
                decoration: InputDecoration(
                  labelText: 'Judul Catatan',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: _categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _jumlahController,
                decoration: InputDecoration(
                  labelText: 'Jumlah Uang',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_judulController.text.isNotEmpty &&
                      _selectedCategory != null &&
                      _jumlahController.text.isNotEmpty) {
                    Navigator.pop(context, {
                      'judul': _judulController.text,
                      'kategori': _selectedCategory,
                      'jumlah': int.parse(_jumlahController.text),
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mohon isi semua field')),
                    );
                  }
                },
                child: Text('Simpan Catatan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _judulController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }
}