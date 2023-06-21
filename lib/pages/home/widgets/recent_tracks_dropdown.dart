import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify/spotify.dart' hide Image;
import 'package:spotify_remake/core/bloc/bloc_exports.dart';
import 'package:spotify_remake/pages/home/widgets/recent_tracks_list.dart';

class RecentTracksDropdown extends StatefulWidget {
  const RecentTracksDropdown({super.key});

  @override
  State<RecentTracksDropdown> createState() => _RecentTracksDropdownState();
}

class _RecentTracksDropdownState extends State<RecentTracksDropdown> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        Iterable<PlayHistory>? recentTracks = state.recentTracks;
        if (recentTracks == null) {
          final homeCubit = context.read<HomeCubit>();
          homeCubit.getRecentTracks();
          recentTracks = [];
        }

        return AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(5),
          ),
          duration: const Duration(milliseconds: 400),
          height: isExpanded ? 500 : 150,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(""),
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ),
              ),
              if (!isExpanded) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 80,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final track = recentTracks!.elementAt(index).track!;

                      return BlocBuilder<ImageCacheCubit, ImageCacheState>(
                        buildWhen: (previous, current) =>
                            current.cache.containsKey(track.id!),
                        builder: (context, state) {
                          final cover = state.cache[track.id];
                          if (cover == null) {
                            context.read<ImageCacheCubit>().getCover(track);

                            return const ColoredBox(color: Colors.grey);
                          } else {
                            return Image.network(cover.url!);
                          }
                        },
                      );
                    },
                    itemCount: recentTracks.length,
                  ),
                ),
              ] else ...[
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: RecentTracksList(recentTracks: recentTracks),
                  ),
                )
              ]
            ],
          ),
        );
      },
    );
  }
}
