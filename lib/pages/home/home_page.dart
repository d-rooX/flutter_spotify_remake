import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify/spotify.dart' as spotapi;
import 'package:spotify_remake/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CarouselController _controller = CarouselControllerImpl();

  SpotifyApi? api;
  Future<SpotifyApi>? _requestFuture;

  Future<SpotifyApi> authorize(BuildContext context) async {
    final credentials = SpotifyApiCredentials(CLIENT_ID, CLIENT_SECRET);
    final grant = SpotifyApi.authorizationCodeGrant(credentials);
    final scopes = ['user-read-recently-played', 'user-read-private'];
    final authUri = grant.getAuthorizationUrl(
      Uri.parse(REDIRECT_URL),
      scopes: scopes,
    );
    final responseUri = await redirect(context, authUri);

    return SpotifyApi.fromAuthCodeGrant(grant, responseUri);
  }

  Future<String> redirect(BuildContext context, Uri uriToRedirect) async {
    String? responseURI;

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith(REDIRECT_URL)) {
              responseURI = request.url;
              Navigator.of(context).pop();

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );

    await controller.loadRequest(uriToRedirect);
    await showDialog(
      context: context,
      builder: (context) => WebViewWidget(controller: controller),
    );

    return responseURI!;
  }

  @override
  Widget build(BuildContext context) {
    _requestFuture ??= authorize(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Ionicons.search,
                          color: Colors.green,
                          size: 32,
                        ),
                        Icon(
                          Ionicons.menu,
                          color: Colors.green,
                          size: 32,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Recent playlists",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  CarouselSlider(
                    carouselController: _controller,
                    items: [
                      Container(color: Colors.red),
                      Container(color: Colors.green),
                      Container(color: Colors.blueGrey),
                      Container(color: Colors.yellow),
                    ],
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        print(index);
                      },
                      enableInfiniteScroll: false,
                      height: 250,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      scrollPhysics: const BouncingScrollPhysics(),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Recent tracks",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  FutureBuilder(
                    future: _requestFuture,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        api = snapshot.data!;

                        return RecentTracksList(api: api!);
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RecentTracksList extends StatefulWidget {
  final SpotifyApi api;
  const RecentTracksList({super.key, required this.api});

  @override
  State<RecentTracksList> createState() => _RecentTracksListState();
}

class _RecentTracksListState extends State<RecentTracksList> {
  late Future<CursorPage<PlayHistory>> _request;

  @override
  void initState() {
    _request = widget.api.me.recentlyPlayed().first().catchError(
          (exc) => print(exc.toString()),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _request,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final items = snapshot.data?.items?.toList(growable: false) ?? [];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              children: items
                  .map((e) => TrackTile(track: e.track!, api: widget.api))
                  .toList(growable: false),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class TrackTile extends StatelessWidget {
  final TrackSimple track;
  final SpotifyApi api;
  const TrackTile({super.key, required this.track, required this.api});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.green.withAlpha(80),
      child: Row(
        children: [
          FutureBuilder(
            future: getCover(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final image = snapshot.data!;

                return Image.network(
                  image.url!,
                  height: 50,
                  width: 50,
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(text: getFormattedArtists()),
              Text(
                track.name ?? '',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w300),
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<spotapi.Image> getCover() async {
    return (await api.tracks.get(track.id!)).album!.images!.first;
  }

  TextSpan getFormattedArtists() {
    if (track.artists != null) {
      final List<TextSpan> children = [];
      for (final artist in track.artists!.skip(1)) {
        children.add(
          TextSpan(
            text: ", ${artist.name}",
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        );
      }

      return TextSpan(
        text: track.artists!.first.name,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        children: children,
      );
    } else {
      throw Exception("Track artists is null");
    }
  }
}
