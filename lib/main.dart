import 'package:flutter/material.dart';
import 'Colors.dart';
import 'package:english_words/english_words.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var index = 0;
  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (index) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $index');
    }

    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "WordPair App",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.violet, background: AppColors.bg),
        ),
        home: Scaffold(
          body: LayoutBuilder(builder: (context, constraints) {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    selectedIndex: index,
                    onDestinationSelected: (value) {
                      setState(() {
                        index = value;
                      });
                    },
                    destinations: const [
                      NavigationRailDestination(
                          icon: Icon(Icons.home), label: Text("Home")),
                      NavigationRailDestination(
                          icon: Icon(Icons.favorite), label: Text("Favorites")),
                    ],
                  ),
                ),
                Expanded(
                  child: page,
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var wordPair = WordPair.random();

  getNext() {
    wordPair = WordPair.random();
    notifyListeners();
  }

  var favoritePairs = <WordPair>[];
  void toggleFavorite() {
    if (favoritePairs.contains(wordPair)) {
      favoritePairs.remove(wordPair);
    } else {
      favoritePairs.add(wordPair);
    }
    notifyListeners();
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    var wordList = appState.favoritePairs;

    return ListView.builder(
      itemCount: wordList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(wordList[index].asPascalCase,
              style: const TextStyle(color: Colors.white)),
        );
      },
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    var isFavorite = appState.favoritePairs.contains(appState.wordPair);

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          WordCard(),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  child: Row(
                    children: [
                      isFavorite
                          ? const Icon(Icons.favorite, color: Colors.pink)
                          : const Icon(Icons.favorite_border_outlined,
                              color: Colors.grey),
                      const SizedBox(width: 5),
                      const Text("Like")
                    ],
                  )),
              const SizedBox(width: 15),
              ElevatedButton(
                  onPressed: appState.getNext, child: const Text("Next"))
            ],
          )
        ],
      ),
    ));
  }
}

class WordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MyAppState>(context);
    var word1 = appState.wordPair.first;
    var word2 = appState.wordPair.second;

    return Card(
        color: AppColors.bg2,
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: AppColors.violet,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: RichText(
                text: TextSpan(children: <TextSpan>[
              TextSpan(
                text: word1,
                style: const TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                  text: word2,
                  style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ))
            ]))));
  }
}
