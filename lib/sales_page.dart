import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Page'),
      ),
      body: Column(
        children: [
          SalesForm(),
          Expanded(
            child: SalesList(),
          ),
        ],
      ),
    );
  }
}

class SalesForm extends StatefulWidget {
  @override
  _SalesFormState createState() => _SalesFormState();
}

class _SalesFormState extends State<SalesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _selectedStatus = 'Vendu'; // Statut par défaut
  final List<String> _statusOptions = [
    'Vendu',
    'Visite technique validée',
    'Financement validé',
    'Annulation'
  ];

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save the sale data to Firestore
      FirebaseFirestore.instance.collection('sales').add({
        'product': _productController.text,
        'amount': double.parse(_amountController.text),
        'date': _dateController.text,
        'status': _selectedStatus,
      }).then((value) {
        // Reset the form after submission
        _formKey.currentState!.reset();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Vente enregistrée avec succès'),
        ));
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erreur lors de l\'enregistrement de la vente'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _productController,
              decoration: InputDecoration(labelText: 'Produit vendu'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le produit vendu';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Montant'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le montant';
                }
                if (double.tryParse(value) == null) {
                  return 'Veuillez entrer un montant valide';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer la date';
                }
                return null;
              },
            ),
            // Ajoutez un champ pour le statut de vente
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _selectedStatus = value ?? 'Vendu';
                });
              },
              decoration: InputDecoration(labelText: 'Statut'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Enregistrer'),
            ),
          ],
        ),
      ),
    );
  }
}

class SalesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('sales').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        }
        final sales = snapshot.data!.docs;
        return ListView.builder(
          itemCount: sales.length,
          itemBuilder: (context, index) {
            final sale = sales[index];
            return Card(
              child: ListTile(
                title: Text(sale['product']),
                subtitle: Text('${sale['amount']} € - ${sale['date']}'),
                trailing: Text(sale['status']),
              ),
            );
          },
        );
      },
    );
  }
}
