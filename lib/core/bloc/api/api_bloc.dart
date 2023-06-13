import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors, showDialog;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_remake/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

part 'api_event.dart';
part 'api_state.dart';

class ApiBloc extends Bloc<ApiEvent, ApiState> {
  ApiBloc() : super(ApiNotLoadedState()) {
    on<ApiInitEvent>(_initializeApi);
  }

  Future<void> _initializeApi(
    ApiInitEvent event,
    Emitter<ApiState> emit,
  ) async {
    emit(ApiLoadingState());
    final api = await authorize(event.context);
    emit(ApiLoadedState(api: api));
  }

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
}
