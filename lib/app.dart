import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake/constants.dart';
import 'package:spotify_remake/core/bloc/bloc_exports.dart';
import 'package:spotify_remake/pages/home/home_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryTextTheme: Typography.whiteCupertino,
        textTheme: Typography.whiteCupertino,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      home: BlocProvider(
        create: (context) => ApiBloc()..add(ApiInitEvent(context: context)),
        child: BlocBuilder<ApiBloc, ApiState>(
          builder: (context, state) => state.api != null
              ? RootWindow(api: state.api!)
              : const Placeholder(),
        ),
      ),
    );
  }
}

class RootWindow extends StatefulWidget {
  final SpotifyApi api;
  const RootWindow({super.key, required this.api});

  @override
  State<RootWindow> createState() => _RootWindowState();
}

class _RootWindowState extends State<RootWindow> {
  final pages = const [
    HomePage(),
    Placeholder(),
    Placeholder(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
            borderRadius: BorderRadius.circular(22),
          ),
          height: 65,
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIconTheme: const IconThemeData(color: SpotiGreen),
            iconSize: 28,
            unselectedIconTheme: IconThemeData(color: Colors.grey.shade900),
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (value) => setState(() => _currentIndex = value),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.menu), label: ''),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => HomeCubit(api: widget.api)),
          BlocProvider(create: (context) => ImageCacheCubit(api: widget.api))
        ],
        child: SafeArea(
          // bottom: false,
          maintainBottomViewPadding: true,
          child: pages.elementAt(_currentIndex),
        ),
      ),
    );
  }
}
