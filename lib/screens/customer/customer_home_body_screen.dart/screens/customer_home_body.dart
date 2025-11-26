

import 'package:flutter/material.dart';
import 'package:homeservice/core/theme/app_theme.dart';
import 'package:homeservice/providers/auth/user_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/banner_images_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/local_expert_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/popular_service_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/recommended_service_provider.dart';
import 'package:homeservice/providers/customer/customerhomepageprovider/top_services_provider.dart';
import 'package:homeservice/providers/customer/customerprofileprovider/customer_profile_provider.dart';
import 'package:homeservice/screens/customer/shared/components/build_horizontal_service_with_provider_list.dart';
import 'package:homeservice/screens/customer/shared/components/build_vertical_service_with_provider_list.dart';
import 'package:homeservice/screens/customer/customer_home_body_screen.dart/components/buildbanner.dart';
import 'package:homeservice/screens/customer/customer_home_body_screen.dart/components/buildexpertsection.dart';
import 'package:homeservice/screens/customer/customer_home_body_screen.dart/components/buildexploreservicesgrid.dart';
import 'package:homeservice/screens/customer/customer_home_body_screen.dart/components/buildheader.dart';
import 'package:homeservice/screens/customer/customer_home_body_screen.dart/components/buildsectiontitle.dart';
import 'package:homeservice/screens/customer/customer_home_body_screen.dart/components/buildstaticsearchbar.dart';
import 'package:homeservice/screens/shared/widgets/common_completeprofilemessage_overlay.dart';
import 'package:provider/provider.dart';

class CustomerHomeBody extends StatefulWidget {
  const CustomerHomeBody({super.key});

  @override
  State<CustomerHomeBody> createState() => _CustomerHomeBodyState();
}

class _CustomerHomeBodyState extends State<CustomerHomeBody> {
  late ScrollController _mainScrollController;
  bool _hasLoadedInitialData = false; // Track if we've loaded data

  @override
  void initState() {
    super.initState();
    _mainScrollController = ScrollController();
    _mainScrollController.addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Load data only once when the widget is first built
    if (!_hasLoadedInitialData) {
      _hasLoadedInitialData = true;
      
      // Load data immediately after dependencies are available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadInitialData();
        }
      });
    }
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_onScroll);
    _mainScrollController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    await _loadInitialData();
  }

  void _onScroll() {
    if (_mainScrollController.position.pixels >=
        _mainScrollController.position.maxScrollExtent * 0.9) {
      final topServiceProvider = Provider.of<TopServiceProvider>(
        context,
        listen: false,
      );

      if (topServiceProvider.hasMoreData && !topServiceProvider.isLoadingMore) {
        topServiceProvider.loadMoreTopServices();
      }
    }
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;

    print('🔄 [CustomerHome] Loading initial data...');

    final bannerProvider = Provider.of<BannerImageProvider>(
      context,
      listen: false,
    );
    final localExpertProvider = Provider.of<LocalExpertProvider>(
      context,
      listen: false,
    );
    final recommendedProvider = Provider.of<RecommendedServiceProvider>(
      context,
      listen: false,
    );
    final topServiceProvider = Provider.of<TopServiceProvider>(
      context,
      listen: false,
    );
    final popularProvider = Provider.of<PopularServiceProvider>(
      context,
      listen: false,
    );

    // FIX: Load data sequentially with proper error handling
    // This ensures each provider completes before the next starts
    try {
      // Load banners first (usually fastest)
      await bannerProvider.loadBannerImages();
      print('✅ [CustomerHome] Banners loaded');

      // Load all service data in parallel (they don't conflict)
      await Future.wait([
        localExpertProvider.loadLocalExperts('Kathmandu'),
        recommendedProvider.loadRecommendedServicesWithProvider(),
        topServiceProvider.loadTopServicesWithProvider(),
        popularProvider.loadPopularServicesWithProvider(),
      ]);

      print('✅ [CustomerHome] All data loaded successfully');
    } catch (e) {
      print('❌ [CustomerHome] Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            controller: _mainScrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: AppTheme.appbar,
                elevation: 0,
                toolbarHeight: 160,
                floating: false,
                pinned: true,
                snap: false,
                expandedHeight: 160,
                automaticallyImplyLeading: false,
                surfaceTintColor: Colors.white,
                shadowColor: Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 16,
                      bottom: 8,
                    ),
                    child: Stack(
                      children: [
                        Consumer<CustomerProfileProvider>(
                          builder: (context, customerProfileProvider, _) {
                            if (!customerProfileProvider
                                    .isCustomerProfileComplete &&
                                !customerProfileProvider.isBannerShown(
                                  'customer_home',
                                )) {
                              customerProfileProvider.markBannerShown(
                                'customer_home',
                              );
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                CompleteProfileBannerOverlay.show(
                                  context,
                                  message:
                                      "Complete your profile to unlock booking features!",
                                  duration: const Duration(seconds: 5),
                                );
                              });
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Consumer<UserProvider>(
                              builder: (context, userProvider, _) {
                                return BuildHeader(
                                  isAuthenticated:
                                      userProvider.isAuthenticated &&
                                      userProvider.getCachedUser() != null,
                                  userDisplayName: userProvider.getCachedUser()?.name,
                                  userprofilePhotoUrl: userProvider.getCachedUser()?.profilePhotoUrl,
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            BuildStaticSearchBar(),
                            const SizedBox(height: 5),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Banner
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverToBoxAdapter(
                  child: Consumer<BannerImageProvider>(
                    builder: (context, bannerImageProvider, _) {
                      return BuildBanner(
                        dataforbannerImages: bannerImageProvider.bannerImages,
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              // Explore Services
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: BuildSectionTitle(title: "Explore Services"),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(14),
                sliver: const SliverToBoxAdapter(
                  child: BuildExploreServicesGrid(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: BuildSectionTitle(title: "Expert in Your Locality"),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.all(14),
                sliver: SliverToBoxAdapter(
                  child: Consumer<LocalExpertProvider>(
                    builder: (context, localExpertProvider, _) {
                      // FIX: Show loading state for experts
                      if (localExpertProvider.isLoading && 
                          localExpertProvider.localExperts.isEmpty) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      return BuildExpertSection(
                        dataforlocalExperts: localExpertProvider.localExperts,
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              // Recommended Services
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: const SliverToBoxAdapter(
                  child: BuildSectionTitle(title: "Recommended Services"),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Consumer<RecommendedServiceProvider>(
                    builder: (context, recommendedServiceProvider, _) {
                      return BuildHorizontalServiceWithProviderList(
                        dataforhorizontalList: recommendedServiceProvider
                            .recommendedServicesWithProvider,
                        onLoadMore: recommendedServiceProvider
                            .loadMoreRecommendedServices,
                        hasMoreData: recommendedServiceProvider.hasMoreData,
                        isLoadingMore: recommendedServiceProvider.isLoadingMore,
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              // Popular Services
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: const SliverToBoxAdapter(
                  child: BuildSectionTitle(title: "Popular Services"),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Consumer<PopularServiceProvider>(
                    builder: (context, popularServiceProvider, _) {
                      return BuildHorizontalServiceWithProviderList(
                        dataforhorizontalList:
                            popularServiceProvider.popularServicesWithProvider,
                        onLoadMore:
                            popularServiceProvider.loadMorePopularServices,
                        hasMoreData: popularServiceProvider.hasMoreData,
                        isLoadingMore: popularServiceProvider.isLoadingMore,
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 10)),

              // Top Services
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: const SliverToBoxAdapter(
                  child: BuildSectionTitle(title: "Recent Services"),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Consumer<TopServiceProvider>(
                    builder: (context, topServiceProvider, _) {
                      return BuildVerticalServiceWithProviderList(
                        dataforverticalList:
                            topServiceProvider.topProviderServicesWithProvider,
                        onLoadMore: topServiceProvider.loadMoreTopServices,
                        hasMoreData: topServiceProvider.hasMoreData,
                        isLoadingMore: topServiceProvider.isLoadingMore,
                      );
                    },
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }
}