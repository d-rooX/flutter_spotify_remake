import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, showDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(const ApiState()) {
    on<ApiInitEvent>(_initializeApi);
  }

  Future<void> _initializeApi(
    ApiInitEvent event,
    Emitter<ApiState> emit,
  ) async {
    SpotifyApi? api = await useSavedCredentials();
    api ??= await authorize(event.context);
    emit(ApiState(api: api));
  }

  Future<void> saveCredentials(SpotifyApiCredentials credentials) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('accessToken', credentials.accessToken!);
    await prefs.setString('refreshToken', credentials.refreshToken!);
    await prefs.setInt(
      'expiration',
      credentials.expiration!.millisecondsSinceEpoch,
    );
    await prefs.setStringList('scopes', credentials.scopes!);
  }

  Future<SpotifyApi?> useSavedCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('accessToken');
    final refreshToken = prefs.getString('refreshToken');
    final expiration = prefs.getInt('expiration');
    final scopes = prefs.getStringList('scopes');

    // fixme
    if (scopes != null) {
      final scopesEqual = CLIENT_SCOPES.every(
        (element) => scopes.contains(element),
      );
      if (!scopesEqual) {
        print("NOT EQUAL SCOPES");

        return null;
      }
    }

    if (accessToken != null && refreshToken != null) {
      try {
        final api = await SpotifyApi.asyncFromCredentials(
          SpotifyApiCredentials(
            CLIENT_ID,
            CLIENT_SECRET,
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiration: DateTime.fromMillisecondsSinceEpoch(expiration!),
            scopes: scopes,
          ),
        );

        return api;
      } catch (e) {
        print("ERRRRRROOOOOOOOOOOR: $e");
      }
    }

    return null;
  }

  Future<SpotifyApi> authorize(BuildContext context) async {
    final credentials = SpotifyApiCredentials(CLIENT_ID, CLIENT_SECRET);
    final grant = SpotifyApi.authorizationCodeGrant(credentials);

    final authUri = grant.getAuthorizationUrl(
      Uri.parse(REDIRECT_URL),
      scopes: CLIENT_SCOPES,
    );
    final responseUri = await showAuthWebView(context, authUri);
    final api = SpotifyApi.fromAuthCodeGrant(grant, responseUri);

    final gotCredentials = await api.getCredentials();
    await saveCredentials(gotCredentials);

    return api;
  }

  Future<String> showAuthWebView(
    BuildContext context,
    Uri uriToRedirect,
  ) async {
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
}
