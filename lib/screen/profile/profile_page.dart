// import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_together/screen/profile/update_profile_page.dart';
import 'package:go_together/screen/user_review/user_review.dart';
import 'package:go_together/widget/loading.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../bloc/user/user_bloc.dart';
import '../../repository/auth_repository.dart';
import '../../router/routes.dart';

class ProfilePage1 extends StatelessWidget {
  const ProfilePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // systemOverlayStyle: SystemUiOverlayStyle(
          //   // Status bar color
          //   statusBarColor: Theme.of(context).scaffoldBackgroundColor,

          //   // Status bar brightness (optional)
          //   statusBarIconBrightness:
          //       Brightness.dark, // For Android (dark icons)
          //   statusBarBrightness: Brightness.light, // For iOS (dark icons)
          // ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Cá nhân',
            style: const TextStyle(
                // color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.black),
          )),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 16,
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const SizedBox();
              } else if (state is UserExist) {
                return Column(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Stack(children: [
                        SizedBox(
                          height: 120,
                          width: 120,
                          child: CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                                state.user.image!,
                                scale: 1),
                          ),
                        ),
                        // Positioned(
                        //     bottom: 2,
                        //     right: 5,
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(5),
                        //         color: Theme.of(context).primaryIconTheme.color,
                        //       ),
                        //       height: 22,
                        //       width: 22,
                        //       child: IconButton(
                        //           // focusColor: Colors.black,
                        //           padding: EdgeInsets.zero,
                        //           iconSize: 15,
                        //           onPressed: () {},
                        //           splashRadius: 15,
                        //           // style: ButtonStyle(),
                        //           icon: Icon(
                        //             Icons.border_color,
                        //             color: Theme.of(context).primaryColor,
                        //           )),
                        //     ))
                      ]),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      state.user.fullName!,
                      style: const TextStyle(
                          // color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 22,
                          fontFamily: 'Urbanist'),
                    ),
                    Text(
                      state.user.phone!,
                      style: const TextStyle(
                          // color: Colors.black,
                          // fontWeight: FontWeight.w600,
                          fontSize: 15,
                          fontFamily: 'Urbanist'),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Divider(
                        color: Colors.grey,
                      ),
                    )
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
          BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              final userState = state as UserExist;
              final user = userState.user;
              return ItemProfile(
                leftIcon: Icons.person_outline,
                label: 'Sửa thông tin cá nhân',
                rightIcon: Icons.chevron_right,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProfilePage(customUser: user,),
                      ));

                  // showDialog(
                  //   barrierColor : Colors.black.withOpacity(0.7),
                  //     context: context,
                  //     builder: (context) => AlertDialog(
                  //       elevation: 0,
                  //       backgroundColor: Colors.transparent,
                  //       content: MyLoading()));
                },
              );
            },
          ),
          ItemProfile(
            leftIcon: Icons.rate_review_outlined,
            label: 'Đánh giá người dùng',
            rightIcon: Icons.reviews,
            onPress: () {
              // Navigator.pushNamed(context, Routes.chooseAddress);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) =>
                          const UserReviewPage())));
            },
          ),
          ItemProfile(
            leftIcon: Icons.emoji_transportation,
            label: 'Quản lý chuyến đi',
            rightIcon: Icons.chevron_right,
            onPress: () {
              Navigator.pushNamed(context, Routes.manageTrips);
            },
          ),
          // ItemProfile(
          //   leftIcon: Icons.language,
          //   label: 'Language',
          //   rightIcon: Icons.chevron_right,
          //   onPress: () {
          //     // LocalizationService().switchLang();
          //   },
          // ),
          // ItemProfile(
          //   leftIcon: Icons.dark_mode,
          //   label: 'Dark Mode',
          //   rightIcon: Icons.chevron_right,
          //   onPress: () {
          //     // ThemeService().switchTheme();
          //   },
          // ),
          ItemProfile(
            leftIcon: Icons.lock_outline,
            label: 'Chính sách',
            rightIcon: Icons.chevron_right,
            onPress: () async {
              final Uri _url = Uri.parse(
                  'https://agreementservice.svs.nike.com/gb/en_gb/rest/agreement?agreementType=privacyPolicy&uxId=com.nike.unite&country=GB&language=en&requestType=redirect');
              if (!await launchUrl(_url)) {
                throw 'Could not launch $_url';
              }
            },
          ),
          ItemProfile(
            leftIcon: Icons.help_outline,
            label: 'Trung tâm trợ giúp',
            rightIcon: Icons.chevron_right,
            onPress: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => HelpCenter(),
              //     ));
            },
          ),
          ItemProfile(
            leftIcon: Icons.logout,
            label: 'Đăng xuất',
            rightIcon: Icons.chevron_right,
            onPress: () {
              AuthRepository().signOut();
            },
          ),
        ],
      )),
    );
  }
}

class ItemProfile extends StatelessWidget {
  const ItemProfile({
    Key? key,
    required this.leftIcon,
    required this.rightIcon,
    required this.label,
    required this.onPress,
  }) : super(key: key);
  final IconData leftIcon;
  final IconData rightIcon;
  final String label;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onPress();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(
            children: [
              Icon(leftIcon),
              const SizedBox(
                width: 16,
              ),
              Text(
                label,
                style: const TextStyle(
                    // color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    fontFamily: 'Urbanist'),
              ),
            ],
          ),
          // Row(
          //   children: [
          //     if (label == 'Language' || label == 'Ngôn ngữ')
          //       Text(
          //         label == 'Language' ? 'English (US)' : 'Vietnamese (VN)',
          //         style: TextStyle(
          //             // color: Colors.black,
          //             fontWeight: FontWeight.w500,
          //             fontSize: 16,
          //             fontFamily: 'Urbanist'),
          //       ),
          //     if (label != 'Dark Mode' && label != 'Chế độ tối')
          //       IconButton(
          //         icon: Icon(rightIcon),
          //         onPressed: () {
          //           onPress();
          //         },
          //       )
          //     else
          //       const CustomSwitchButton()
          //   ],
          // )
        ]),
      ),
    );
  }
}
