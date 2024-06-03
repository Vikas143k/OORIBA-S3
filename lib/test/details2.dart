import 'package:flutter/material.dart';

void main() {
  runApp(const Detail2());
}

class Detail2 extends StatelessWidget {
  const Detail2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Details'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 1,
            children: [
              _buildGridRow(),
              _buildGridRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridRow() {
    return Column(
      children: [
        _buildImageRow(),
        _buildInfoRow(),
        _buildButtonRow(),
      ],
    );
  }

  Widget _buildImageRow() {
    return Row(
      children: [
        Expanded(
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/ooriba-s3-add23.appspot.com/o/image%2Fdp.png?alt=media&token=87f1b3a7-d249-4976-bdf9-5fdaa808bea0',
            height: 100,
            width: 100,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow() {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: Vikas Yadav', style: TextStyle(fontSize: 16)),
              Text('Email: vikas@example.com', style: TextStyle(fontSize: 16)),
              Text('Phone: 9315690341', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton(onPressed: () {}, child: const Text('Show')),
        ElevatedButton(onPressed: () {}, child: const Text('Approve')),
        ElevatedButton(onPressed: () {}, child: const Text('Reject')),
        ElevatedButton(onPressed: () {}, child: const Text('Edit')),
      ],
    );
  }
}
