import 'package:flutter/material.dart';
import '../../core/colors/colors.dart';
import '../../core/constants/constants.dart';
import '../../core/assets/mock_data.dart';
import '../../core/navigation/app_page_route.dart';
import '../../widgets/cards/profile_card.dart';
import '../../widgets/cards/empty_state_widget.dart';
import '../profile_details/profile_details_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Profile>>(
      valueListenable: ProfileDatabase.notifier,
      builder: (context, profiles, _) {
        final favouriteProfiles = profiles.where((p) => p.isFavourite).toList();

        return Scaffold(
          body: favouriteProfiles.isEmpty
              ? const EmptyStateWidget(
                  icon: Icons.favorite_border_rounded,
                  title: 'No Favourites Yet',
                  description: 'Start exploring profiles and tap the heart icon to save your preferred matches here.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  physics: const BouncingScrollPhysics(),
                  itemCount: favouriteProfiles.length,
                  itemBuilder: (context, index) {
                    final profile = favouriteProfiles[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: ProfileCard(
                        profile: profile,
                        cardType: ProfileCardType.favourite,
                        onFavoriteToggle: () {
                          ProfileDatabase.toggleFavorite(profile.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Removed ${profile.name} from favourites'),
                              behavior: SnackBarBehavior.floating,
                              duration: const Duration(milliseconds: 1200),
                              action: SnackBarAction(
                                label: 'Undo',
                                textColor: AppColors.secondary,
                                onPressed: () {
                                  ProfileDatabase.toggleFavorite(profile.id);
                                },
                              ),
                            ),
                          );
                        },
                        onViewProfile: () {
                          Navigator.of(context).push(
                            appPageRoute(
                              ProfileDetailsScreen(
                                profile: profile,
                                heroTag: 'profile-image-${profile.id}-favs',
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
