import 'package:flutter/material.dart';
import 'package:tugas3/models/anime_model.dart';
import 'package:tugas3/presenters/anime_presenter.dart';
import 'package:tugas3/views/anime_detali.dart';

class AnimeListScreen extends StatefulWidget {
  const AnimeListScreen({super.key});

  @override
  State<AnimeListScreen> createState() => _AnimeListScreenState();
}

class _AnimeListScreenState extends State<AnimeListScreen>
    implements AnimeView {
  late AnimePresenter _presenter;
  bool _isLoading = false;
  List<Anime> _animeList = [];
  String? _errorMessage;
  String _currentEndpoint = 'akatsuki';

  @override
  void initState() {
    super.initState();
    _presenter = AnimePresenter(this);
    _presenter.loadAnimeData(_currentEndpoint);
  }

  void _fetchData(String endpoint) {
    setState(() {
      _currentEndpoint = endpoint;
      _presenter.loadAnimeData(endpoint);
    });
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
  void showAnimeList(List<Anime> animeList) {
    setState(() {
      _animeList = animeList;
    });
  }

  @override
  void showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Anime List"),
        backgroundColor: Colors.deepPurple, // Warna AppBar
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  _fetchData('akatsuki');
                },
                child: const Text("Akatsuki"),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _fetchData('kara');
                },
                child: const Text("Kara"),
              ),
            ],
          ),
          const SizedBox(height: 10), // Menambahkan jarak
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(child: Text("Error: $_errorMessage"))
                    : ListView.builder(
                        itemCount: _animeList.length,
                        itemBuilder: (context, index) {
                          final anime = _animeList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            elevation: 6, // Menambahkan elevasi untuk efek bayangan
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12), // Membulatkan sudut
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16), // Menambahkan padding
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  anime.imageUrl.isNotEmpty
                                      ? anime.imageUrl
                                      : 'https://placehold.co/600x400',
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(
                                anime.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.deepPurple,
                                ),
                              ),
                              subtitle: Text(
                                'Family: ${anime.familyCreator}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                      id: anime.id,
                                      endpoint: _currentEndpoint,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
          )
        ],
      ),
    );
  }
}