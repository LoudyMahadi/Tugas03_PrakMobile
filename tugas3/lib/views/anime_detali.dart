import 'package:flutter/material.dart';
import 'package:tugas3/presenters/anime_detail_presenter.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.id, required this.endpoint});
  final int id;
  final String endpoint;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    implements AnimeDetailView {
  late AnimeDetailPresenter _presenter;
  bool _isLoading = true;
  Map<String, dynamic>? _detailData;
  String? _errorMessage;
  bool _isFavorite = false; // Menandai apakah anime adalah favorit

  @override
  void initState() {
    super.initState();
    _presenter = AnimeDetailPresenter(this);
    _presenter.loadDetailData(widget.endpoint, widget.id);
  }

  @override
  void showLoading() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void hideLoading() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void showDetailData(Map<String, dynamic> detailData) {
    setState(() {
      _detailData = detailData;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite; // Toggle status favorit
    });
    // Anda bisa menambahkan logika untuk menyimpan status favorit di sini
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text("Error: $_errorMessage"))
              : _detailData != null
                  ? SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar Utama
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                _detailData!['images'][0],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 200,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Name: ${_detailData!['name']}",
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Card(
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Kekkei Genkai: ${_detailData!['personal']['kekkeiGenkai'] ?? 'Empty'}",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Title: ${_detailData!['personal']['titles']}",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Description: ${_detailData!['description'] ?? 'No description available.'}",
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Images:",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepPurple,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Menggunakan ListView.builder untuk menampilkan semua gambar
                            SizedBox(
                              height: 200, // Atur tinggi sesuai kebutuhan
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _detailData!['images'].length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 4.0 ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        _detailData!['images'][index],
                                        fit: BoxFit.cover,
                                        width: 120,
                                        height: 200,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(child: Text("No data available")),
    );
  }
}