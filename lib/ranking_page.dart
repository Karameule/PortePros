import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RankingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Classement'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }
          final users = snapshot.data!.docs;
          // Triez les utilisateurs par leur score de performance ou un autre critère
          users.sort(
              (a, b) => b['performanceScore'].compareTo(a['performanceScore']));
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              return ListTile(
                leading: CircleAvatar(
                  child: Text(userData['initials']),
                ),
                title: Text(userData['displayName']),
                subtitle: Text(
                    'Score de performance: ${userData['performanceScore']}'),
              );
            },
          );
        },
      ),
    );
  }
}
